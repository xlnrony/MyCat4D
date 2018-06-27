{ *******************************************************************************
  *                                                                             *
  *          Delphi Standard Template Library                                   *
  *                                                                             *
  *          (C)Copyright Jimx 2011                                             *
  *                                                                             *
  *          http://delphi-standard-template-library.googlecode.com             *
  *                                                                             *
  *******************************************************************************
  *  This file is part of Delphi Standard Template Library.                     *
  *                                                                             *
  *  Delphi Standard Template Library is free software:                         *
  *  you can redistribute it and/or modify                                      *
  *  it under the terms of the GNU General Public License as published by       *
  *  the Free Software Foundation, either version 3 of the License, or          *
  *  (at your option) any later version.                                        *
  *                                                                             *
  *  Delphi Standard Template Library is distributed                            *
  *  in the hope that it will be useful,                                        *
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of             *
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *
  *  GNU General Public License for more details.                               *
  *                                                                             *
  *  You should have received a copy of the GNU General Public License          *
  *  along with Delphi Standard Template Library.                               *
  *  If not, see <http://www.gnu.org/licenses/>.                                *
  ******************************************************************************* }
unit DSTL.STL.List;

interface

uses
  DSTL.Config,
  SysUtils, DSTL.Types, DSTL.STL.ListNode, DSTL.STL.Iterator, DSTL.STL.Vector,
  Generics.Defaults, DSTL.Exception, DSTL.STL.Sequence, DSTL.STL.Alloc;

type

{$REGION 'TList<T>'}
  TList<T> = class(TSequence<T>)
  protected
    head, tail: TListNode<T>;
    fin_node: TListNode<T>; (* the past-the-end element
                  tail.next = fin_node *)
    allocator: IAllocator<T>;

    procedure iadvance(var Iterator: TIterator<T>); override;
    procedure iretreat(var Iterator: TIterator<T>); override;
    function iget(const Iterator: TIterator<T>): T; override;
    function iequals(const iter1, iter2: TIterator<T>): boolean; override;
    function idistance(const iter1, iter2: TIterator<T>): integer; override;

    procedure swap_node(var it1, it2: TIterator<T>);
    procedure _sort(comparator: IComparer<T>; l, r: integer);
    function get_item(idx: integer): T;
    procedure set_item(idx: integer; const value: T);
    procedure protected_create;
  public
    constructor Create; overload;
    constructor Create(alloc: IAllocator<T>); overload;
    constructor Create(n: integer; value: T); overload;
    constructor Create(first, last: TIterator<T>); overload;
    constructor Create(x: TList<T>); overload;
    destructor Destroy; override;
    procedure assign(first, last: TIterator<T>); overload;
    procedure assign(n: integer; u: T); overload;
    procedure add(const obj: T); override;
    procedure remove(const obj: T); override;
    procedure remove_if(const pred: TPredicate<T>);
    procedure clear; override;
    function start: TIterator<T>; override;
    function finish: TIterator<T>; override;
    function rstart: TIterator<T>; override;
    function rfinish: TIterator<T>; override;
    function front: T; override;
    function back: T; override;
    function max_size: integer; override;
    procedure resize(const n: integer); overload;
    procedure resize(const n: integer; const x: T); overload;
    function size: integer; override;
    function empty: boolean; override;
    function at(const idx: integer): T; override;
    function get(const idx: integer): TIterator<T>;
    function pop_back: T; override;
    function pop_front: T;  override;
    procedure push_back(const obj: T); override;
    procedure push_front(const obj: T); override;
    procedure cut(var _start, _finish: TIterator<T>);
    function insert(var Iterator: TIterator<T>; const obj: T): TIterator<T>; overload;
    procedure insert(var Iterator: TIterator<T>; n: integer; const obj: T); overload;
    procedure insert(var Iterator: TIterator<T>; first, last: TIterator<T>); overload;
    function erase(var it: TIterator<T>): TIterator<T>; overload;
    function erase(var _start, _finish: TIterator<T>): TIterator<T>; overload;
    procedure merge(var l: TList<T>);   overload;
    procedure merge(var l: TList<T>; comp: IComparer<T>);   overload;
    procedure reverse;
    procedure sort; overload;
    procedure sort(comparator: IComparer<T>); overload;
    procedure swap(var l: TList<T>);
    procedure splice(var position: TIterator<T>;var x: TList<T>);  overload;
    procedure splice(var position: TIterator<T>;var x: TList<T>;var i: TIterator<T>); overload;
    procedure splice(var position: TIterator<T>;var x: TList<T>;var first, last: TIterator<T>); overload;
    procedure unique;  overload;
    procedure unique(bin_pred: TBinaryPredicate<T, T>); overload;

    function get_allocator: IAllocator<T>;
    procedure set_allocator(alloc: IAllocator<T>);

    property items[idx: integer]: T read get_item write set_item; default;
  end;

{$ENDREGION}

implementation

{$REGION 'TList<T>'}

procedure TList<T>.protected_create;
begin
  head := nil;
  tail := nil;
  allocator := TAllocator<T>.Create;
  fin_node := TListNode<T>.Create;
end;

constructor TList<T>.Create;
begin
  protected_create;
end;

constructor TList<T>.Create(alloc: IAllocator<T>);
begin
  protected_create;
  allocator := alloc;
end;

constructor TList<T>.Create(n: integer; value: T);
begin
  protected_create;
  assign(n, value);
end;

constructor TList<T>.Create(first, last: TIterator<T>);
begin
  protected_create;
  assign(first, last);
end;

constructor TList<T>.Create(x: TList<T>);
begin
  protected_create;
  assign(x.start, x.finish);
end;

destructor TList<T>.Destroy;
begin
  clear;
end;

procedure TList<T>.iadvance(var Iterator: TIterator<T>);
begin
  (* reverse iterator *)
  if ifReverse in Iterator.flags then
  begin
    Iterator.flags := Iterator.flags - [ifReverse];
    iretreat(Iterator);
    Iterator.flags := Iterator.flags + [ifReverse];
    exit;
  end;

  (* tail - return an iterator referring to the past-the-end element
      in the list container *)
  if Iterator.node = Self.tail then
  begin
    Iterator.node := Self.fin_node;
  end
  else if Iterator.node.next = nil then
  begin
    Iterator.node := nil;
    exit;
  end
  else begin
    Iterator.node := Iterator.node.next;
    Iterator.handle := self;
  end;
end;

procedure TList<T>.iretreat(var Iterator: TIterator<T>);
begin
  (* reverse iterator *)
  if ifReverse in Iterator.flags then
  begin
    Iterator.flags := Iterator.flags - [ifReverse];
    iadvance(Iterator);
    Iterator.flags := Iterator.flags + [ifReverse];
    exit;
  end;

  (* fin_node - return an iterator referring to the tail *)
  if Iterator.node = Self.fin_node then
  begin
    Iterator.node := Self.tail;
  end
  else if Iterator.node.prev = nil then
  begin
    Iterator.node := nil;
    exit;
  end
  else begin
    Iterator.node := Iterator.node.prev;
    Iterator.handle := self;
  end;
end;

function TList<T>.iget(const Iterator: TIterator<T>): T;
begin
  result := Iterator.node.obj;
end;

function TList<T>.iequals(const iter1, iter2: TIterator<T>): boolean;
begin
  result := iter1.node = iter2.node;
end;

function TList<T>.idistance(const iter1, iter2: TIterator<T>): integer;
var
  dist: integer;
  iter: TIterator<T>;
begin
  dist := 0;
  iter := iter1;
  while iter <> iter2 do
  begin
    iadvance(iter);
    inc(dist);
  end;
  Result := dist;
end;

function TList<T>.get_item(idx: integer): T;
var
  it: TIterator<T>;
begin
  if (idx >= size) or (idx < 0) then dstl_raise_exception(E_OUT_OF_BOUND);
  it := start;
  while idx > 0 do
  begin
    iadvance(it);
    dec(idx);
  end;
  Result := it.node.obj;
end;

procedure TList<T>.set_item(idx: integer; const value: T);
var
  it: TIterator<T>;
begin
  it := start;
  while idx > 0 do
  begin
    iadvance(it);
    dec(idx);
  end;
  it.node.obj := value;
end;

procedure TList<T>.assign(first, last: TIterator<T>);
var
  iter: TIterator<T>;
begin
  head := nil;
  tail := nil;

  iter := first;
  while iter <> last do
  begin
    Self.push_back(iter);
    iter.handle.iadvance(iter);
  end;
end;

procedure TList<T>.assign(n: integer; u: T);
var
  i: integer;
begin
  head := nil;
  tail := nil;

  for i := 0 to n - 1 do
    Self.push_back(u);
end;

procedure TList<T>.add(const obj: T);
begin
  push_back(obj);
end;

procedure TList<T>.remove(const obj: T);
var
  tmp: TIterator<T>;
  comparer: IEqualityComparer<T>;
begin
  comparer := TEqualityComparer<T>.default;
  tmp := start;
  repeat
    if comparer.Equals(tmp.node.obj, obj) then
    begin
      if tmp.node = head then
      begin
        head := head.next;
        head.prev := nil;
      end
      else if tmp.node = tail then
      begin
        tail := tail.prev;
        tail.next := nil;
      end
      else
      begin
        tmp.node.prev.next := tmp.node.next;
        tmp.node.next.prev := tmp.node.prev;
      end;
    end;
    iadvance(tmp);
  until (tmp.node = nil) or empty;
end;

procedure TList<T>.remove_if(const pred: TPredicate<T>);
var
  tmp: TIterator<T>;
begin
  tmp := start;
  repeat
    if pred(tmp.node.obj) then
    begin
      if tmp.node = head then
      begin
        head := head.next;
        head.prev := nil;
      end
      else if tmp.node = tail then
      begin
        tail := tail.prev;
        tail.next := nil;
      end
      else
      begin
        tmp.node.prev.next := tmp.node.next;
        tmp.node.next.prev := tmp.node.prev;
      end;
    end;
    iadvance(tmp);
  until (tmp.node = nil) or empty;
end;

procedure TList<T>.clear;
var
  cur, tmp: TListNode<T>;
begin
  cur := head;
  while cur <> tail do
  begin
    tmp := cur;
    cur := cur.next;
    tmp.Free;
  end;
  cur.Free;
  head := nil;
end;

function TList<T>.start: TIterator<T>;
begin
  result.node := head;
  result.handle := self;
  result.flags := [ifBidirectional];
end;

function TList<T>.finish: TIterator<T>;
begin
  result.node := fin_node;
  result.handle := self;
  result.flags := [ifBidirectional];
end;

function TList<T>.rstart: TIterator<T>;
begin
  result.node := fin_node;
  result.handle := self;
  result.flags := [ifBidirectional, ifReverse];
end;

function TList<T>.rfinish: TIterator<T>;
begin
  result.node := head;
  result.handle := self;
  result.flags := [ifBidirectional, ifReverse];
end;

function TList<T>.front: T;
begin
  if empty then
    exit;
  result := head.obj;
end;

function TList<T>.back: T;
begin
  if empty then
    exit;
  result := tail.obj;
end;

function TList<T>.max_size: integer;
begin
  Result := MaxInt;
end;

procedure TList<T>.resize(const n: integer);
begin
  { TODO: resize code here }
end;

procedure TList<T>.resize(const n: integer; const x: T);
begin
  { TODO: resize code here }
end;

function TList<T>.size: integer;
var
  i: integer;
  iter: TIterator<T>;
begin
  i := 0;
  iter := start;
  while iter <> finish do
  begin
    iadvance(iter);
    inc(i);
  end;
  result := i;
end;

function TList<T>.empty: boolean;
begin
  result := head = nil;
end;

function TList<T>.at(const idx: integer): T;
var
  tmp: TIterator<T>;
  i: integer;
begin
  tmp := start;
  i := idx;
  if i >= size then
    exit;
  while true do
  begin
    dec(i);
    if i < 0 then
      break;
    if tmp.node = nil then
      break;
    iadvance(tmp);
  end;
  if tmp.node <> nil then
    result := tmp.node.obj;
end;

function TList<T>.get(const idx: integer): TIterator<T>;
var
  tmp: TIterator<T>;
  i: integer;
begin
  tmp := start;
  i := idx;
  if idx >= size then
    exit;
  while true do
  begin
    dec(i);
    if i < 0 then
      break;
    iadvance(tmp);
  end;
  result := tmp;
end;

function TList<T>.pop_back: T;
begin
  result := tail.obj;
  tail := tail.prev;
  if tail = nil then head := nil
  else tail.next := nil;
end;

function TList<T>.pop_front: T;
begin
  result := head.obj;
  head := head.next;
  if head <> nil then head.prev := nil;
end;

procedure TList<T>.push_back(const obj: T);
var
  tmp: TListNode<T>;
begin
  if empty then
  begin
    head := TListNode<T>.Create;
    tail := TListNode<T>.Create;
    head.obj := obj;
    tail := head;
  end
  else
  begin
    tmp := TListNode<T>.Create;
    tmp.obj := obj;
    tmp.prev := tail;
    tail.next := tmp;
    tail := tmp;
  end;
end;

procedure TList<T>.push_front(const obj: T);
var
  tmp: TListNode<T>;
begin
  if empty then
  begin
    head := TListNode<T>.Create;
    tail := TListNode<T>.Create;
    head.obj := obj;
    tail := head;
  end
  else
  begin
    tmp := TListNode<T>.Create;
    tmp.obj := obj;
    tmp.next := head;
    head.prev := tmp;
    head := tmp;
  end;
end;

procedure TList<T>.cut(var _start, _finish: TIterator<T>);
begin
  _start.node.next := _finish.node.next;
  _finish.node.prev := _start.node.prev;
end;

function TList<T>.insert(var Iterator: TIterator<T>; const obj: T): TIterator<T>;
var
  tmp: TListNode<T>;
begin
  tmp := TListNode<T>.Create;
  tmp.obj := obj;
  (* empty list *)
  if Self.empty then
  begin
    Self.head := tmp;
    Self.tail := tmp;
    Self.head.prev := nil;
    Self.tail.next := nil;
  end
  (* insert to the head *)
  else if Iterator.node = Self.head then
  begin
    Self.head.prev := tmp;
    tmp.next := Self.head;
    Self.head := tmp;
    Self.head.prev := nil;
  end
  (* insert to the tail *)
  else if Iterator.node = Self.tail then
  begin
    Self.tail.next := tmp;
    tmp.prev := Self.tail;
    Self.tail := tmp;
    Self.tail.next := nil;
  end
  else begin
    tmp.prev := Iterator.node.prev;
    tmp.next := Iterator.node;
    Iterator.node.prev.next := tmp;
    Iterator.node.prev := tmp;
  end;

  Result.handle := self;
  Result.node := tmp;
end;

procedure TList<T>.insert(var Iterator: TIterator<T>; n: integer; const obj: T);
var
  i: integer;
begin
  for i := 1 to n do
  begin
    insert(Iterator, obj);
  end;
end;

procedure TList<T>.insert(var Iterator: TIterator<T>; first, last: TIterator<T>);
var
  iter: TIterator<T>;
  idx, i: integer;
begin
  iter := first;
  while iter <> last do
  begin
    insert(Iterator, iter);
    iter.handle.iadvance(iter);
  end;
end;

function TList<T>.erase(var it: TIterator<T>): TIterator<T>;
begin
  Result.handle := self;
  (* list is empty - nothing to erase *)
  if Self.empty then exit
  (* head *)
  else if it.node = Self.head then
  begin
    Self.head := Self.head.next;
    if Self.head <> nil then
    begin
      Self.head.prev := nil;
      Result.node := Self.head;
    end;
  end
  (* tail *)
  else if it.node = Self.tail then
  begin
    Self.tail := Self.tail.prev;
    if Self.tail <> nil then
    begin
      Self.tail.next := nil;
    end
    (* tail == nil - list is empty now, set head to nil *)
    else Self.head := nil;
  end
  else begin
    it.node.next.prev := it.node.prev;
    Result.node := it.node.next;
    it.node.prev.next := it.node.next;
  end;
end;

function TList<T>.erase(var _start, _finish: TIterator<T>): TIterator<T>;
begin
  Result.handle := self;
  if Self.empty then exit
  else if _start.node = Self.head then
  begin
    Self.head := _finish.node;
    Result.node := _finish.node;
  end
  else begin
    _start.node.prev.next := _finish.node;
    Result.node := _finish.node;
    _finish.node.prev := _start.node.prev;
  end;
end;

procedure TList<T>.merge(var l: TList<T>);
begin
  tail.next := l.head;
  l.head.prev := tail;
  tail := l.finish.node;
  Self.sort;
end;

procedure TList<T>.merge(var l: TList<T>; comp: IComparer<T>);
begin
  tail.next := l.head;
  l.head.prev := tail;
  tail := l.finish.node;
  Self.sort(comp);
end;

procedure TList<T>.swap_node(var it1, it2: TIterator<T>);
var
  tmp: T;
begin
  tmp := it1.node.obj;
  it1.node.obj := it2.node.obj;
  it2.node.obj := tmp;
end;

procedure TList<T>.reverse;
var
  i: integer;
  it1, it2: TIterator<T>;
begin
  it1.node := Self.head;
  it2.node := Self.tail;
  for i := 0 to size div 2 - 1 do
  begin
    swap_node(it1, it2);
    iadvance(it1);
    iretreat(it2);
  end;
end;

procedure TList<T>._sort(comparator: IComparer<T>; l, r: integer);
var
  i, j: integer;
  tmp: TIterator<T>;
  s, x: T;
begin
  i := l;
  j := r;
  x := get((i + j) shr 1);
  repeat
    while (comparator.Compare(at(i), x) < 0) do inc(i);
    while (comparator.Compare(x, at(j)) < 0) do dec(j);
    if i <= j then
    begin
      s := at(i);
      tmp := get(i);
      tmp.node.obj := at(j);
      tmp := get(j);
      tmp.node.obj := s;
      inc(i);
      dec(j);
    end;
  until i>j;
  if l < j then _sort(comparator, l,j);
  if i < r then _sort(comparator, i,r);
end;

procedure TList<T>.sort;
begin
  _sort(TComparer<T>.default, 0, size - 1);
end;

procedure TList<T>.sort(comparator: IComparer<T>);
begin
  _sort(comparator, 0, size - 1);
end;

procedure TList<T>.swap(var l: TList<T>);
var
  tmph, tmpt: TListNode<T>;
begin
  tmph := l.head;
  tmpt := l.tail;
  l.head := Self.head;
  l.tail := Self.tail;
  Self.head := tmph;
  Self.tail := tmpt;
end;

procedure TList<T>.splice(var position: TIterator<T>;var x: TList<T>);
begin
  (*
  if Self.empty then
  begin
    exit;
  end;
  if position.node = nil then position.node := TListNode<T>.Create;
  if position.node.prev <> nil then position.node.prev.next := x.head;
  x.head.prev := position.node.prev;
  position.node.prev := x.tail;
  x.tail.next := position.node;
  x.head := nil;
  x.tail := nil;
  *)
  Self.insert(position, x.start, x.finish);
  x.clear;
end;

procedure TList<T>.splice(var position: TIterator<T>;var x: TList<T>;var i: TIterator<T>);
begin
  (*
  if Self.empty then
  begin
    Self.head := i.node;
    Self.tail := i.node;
    Self.head.prev := nil;
    Self.tail.next := nil;
    exit;
  end;
  if i.node.prev <> nil then i.node.prev.next := i.node.next;
  if i.node.next <> nil then i.node.next.prev := i.node.prev;
  i.node.prev := position.node.prev;
  if position.node.prev <> nil then  position.node.prev.next := i.node;
  i.node.next := position.node;
  if position.node.prev <> nil then position.node.prev := i.node;
  *)

  Self.insert(position, iget(i));
  x.erase(i);
end;

procedure TList<T>.splice(var position: TIterator<T>;var x: TList<T>;var first, last: TIterator<T>);
begin
  (*
  if Self.empty then
  begin
    Self.head := first.node;
    Self.tail := last.node;
    Self.head.prev := nil;
    Self.tail.next := nil;
    exit;
  end;
  if position.node = nil then position.node := TListNode<T>.Create;
  if first.node.next <> nil then first.node.prev.next := last.node.next;
  if last.node.next <> nil then last.node.next.prev := first.node.prev;
  if position.node.prev <> nil then  position.node.prev.next := first.node;
  first.node.prev := position.node.prev;
  position.node.prev := last.node;
  last.node.next := position.node;
  *)
  Self.insert(position, first, last);
  x.erase(first, last);
end;

procedure TList<T>.unique;
var
  it1, it2, tmp: TIterator<T>;
  d: boolean;
begin
  if Self.empty then exit;

  it1.node := Self.head;
  it2.node := Self.head.next;
  d := false;

  while it2.node <> nil do
  begin
    if it1 = it2 then
    begin
      tmp := it1;
      it1.handle.iadvance(it1);
      it2.handle.iadvance(it2);
      erase(tmp);
    end
    else begin
      it1.handle.iadvance(it1);
      it2.handle.iadvance(it2);
    end;
  end;
end;

procedure TList<T>.unique(bin_pred: TBinaryPredicate<T, T>);
var
  it1, it2, tmp: TIterator<T>;
begin
  if Self.empty then exit;

  it1.node := Self.head;
  it2.node := Self.head.next;

  while it2.node <> nil do
  begin
    if bin_pred(it1, it2) then
    begin
      tmp := it1;
      it1.handle.iadvance(it1);
      it2.handle.iadvance(it2);
      erase(tmp);
    end
    else begin
      it1.handle.iadvance(it1);
      it2.handle.iadvance(it2);
    end;
  end;
end;

function TList<T>.get_allocator: IAllocator<T>;
begin
  Result := Self.allocator;
end;

procedure TList<T>.set_allocator(alloc: IAllocator<T>);
begin
  Self.allocator := alloc;
end;

{$ENDREGION}

end.
