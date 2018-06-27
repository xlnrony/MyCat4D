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
unit DSTL.STL.Maps;

interface

uses
  DSTL.STL.Iterator, DSTL.STL.RBTree, DSTL.Utils.Pair, Generics.Defaults,
  DSTL.Utils.Range;

type

{$REGION 'TInternalMap<K, V>'}
  (* internal map - do not use *)
  TInternalMap<K, V> = class(TContainer<K, V>)
  protected
    tree: TRedBlackTree<K, V>;

    procedure create_map(always_insert: boolean; compare: IComparer<K>);
    procedure iadvance(var Iterator: TIterator<K, V>);  override;
    function iget(const Iterator: TIterator<K, V>): TPair<K, V>; override;
    function iat_end(const Iterator: TIterator<K, V>): boolean; override;
    function iequals(const iter1, iter2: TIterator<K, V>): Boolean;  override;
    procedure iput(const Iterator: TIterator<K, V>; const obj: TPair<K, V>); override;
    function iremove(const Iterator: TIterator<K, V>): TIterator<K, V>; override;
    procedure iretreat(var Iterator: TIterator<K, V>);  override;
    function iget_at(const Iterator: TIterator<K, V>; offset: Integer)
      : TPair<K, V>;
    procedure iput_at(const Iterator: TIterator<K, V>; offset: Integer;
      const obj: TPair<K, V>);
    function idistance(const iter1, iter2: TIterator<K, V>): integer; override;
    function get_item(idx: K): V;
    procedure set_item(idx: K; const value: V);
  public
    destructor Destroy;   override;
    procedure add(const obj: TPair<K, V>);
    function start: TIterator<K, V>;
    function finish: TIterator<K, V>;
    function size: integer;
    function max_size: Integer;
    function empty: boolean;
    procedure clear;
    function insert(const obj: TPair<K, V>): TPair<TIterator<K, V>, boolean>; overload;
    function insert(position: TIterator<K, V>; const obj: TPair<K, V>): TIterator<K, V>; overload;
    procedure insert(first, last: TIterator<K, V>);  overload;
    procedure erase(position: TIterator<K, V>);  overload;
    procedure erase(const x: K);  overload;
    procedure erase(first, last: TIterator<K, V>);  overload;
    procedure swap(var x: TInternalMap<K, V>);
    function count(const key: K): Integer;
    function get_at(const key: K): TPair<K, V>;
    function find(const key: K): TIterator<K, V>;
    function lower_bound(const key: K): TIterator<K, V>;
    function upper_bound(const key: K): TIterator<K, V>;
    function equal_range(const x: K): TPair<TIterator<K, V>, TIterator<K, V>>;
    procedure put_at(const key: K; value: V);
    procedure remove(const key: K);
    procedure remove_at(Iterator: TIterator<K, V>);
    procedure remove_in(_start, _finish: TIterator<K, V>);
    function start_key: TIterator<K, V>;
    property items[idx: K]: V read get_item write set_item; default;
  end;
{$ENDREGION}

  TMap<K, V> = class(TInternalMap<K, V>)
  public
    constructor Create;
  end;

  TMultiMap<K, V> = class(TInternalMap<K, V>)
  public
    constructor Create;
  end;

implementation

{$REGION 'TInternalMap<K, V>'}
procedure TInternalMap<K, V>.create_map(always_insert: boolean; compare: IComparer<K>);
begin
  tree := TRedBlackTree<K, V>.Create(Self, always_insert, compare);
end;

destructor TInternalMap<K, V>.Destroy;
begin
	tree.free;
	inherited;
end;

procedure TInternalMap<K, V>.iadvance(var Iterator: TIterator<K, V>);
begin
  tree.RBincrement(Iterator.node);
end;

function TInternalMap<K, V>.iget(const Iterator: TIterator<K, V>): TPair<K, V>;
begin
  Result := Iterator.node.Pair;
end;

function TInternalMap<K, V>.iat_end(const Iterator: TIterator<K, V>): boolean;
begin
  Result := Iterator.node = tree.EndNode;
end;

function TInternalMap<K, V>.iequals(const iter1, iter2: TIterator<K, V>): Boolean;
begin
  result := iter1.node = iter2.node;
end;

procedure TInternalMap<K, V>.iput(const Iterator: TIterator<K, V>; const obj: TPair<K, V>);
begin
  Iterator.node.Pair := obj;
end;

function TInternalMap<K, V>.iremove(const Iterator: TIterator<K, V>): TIterator<K, V>;
begin
  result := Iterator;
  iadvance(result);
  remove_at(Iterator);
end;

procedure TInternalMap<K, V>.iretreat(var Iterator: TIterator<K, V>);
begin
  tree.RBdecrement(Iterator.node);
end;

function TInternalMap<K, V>.iget_at(const Iterator: TIterator<K, V>; offset: Integer)
  : TPair<K, V>;
var
  iter: TIterator<K, V>;
  i: integer;
begin
  iter := Iterator;
  if offset > 0 then
    for i := 1 to offset do iadvance(iter)
  else
    for i := 1 to -offset do iretreat(iter);
  result := iget(iter);
end;

procedure TInternalMap<K, V>.iput_at(const Iterator: TIterator<K, V>; offset: Integer;
  const obj: TPair<K, V>);
var
  iter: TIterator<K, V>;
  i: integer;
begin
  iter := Iterator;
  if offset > 0 then
    for i := 1 to offset do iadvance(iter)
  else
    for i := 1 to -offset do iretreat(iter);
  iput(iter, obj);
end;

function TInternalMap<K, V>.idistance(const iter1, iter2: TIterator<K, V>): integer;
var
  dist: integer;
  iter: TIterator<K, V>;
begin
  dist := 0;
  iter := iter1;
  while iter <> iter2 do
  begin
    iter.handle.iadvance(iter);
    inc(dist);
  end;
  Result := dist;
end;

function TInternalMap<K, V>.get_item(idx: K): V;
var iter : TIterator<K, V>;
begin
	iter := tree.find(idx);
	result := iget(iter).second;
end;

procedure TInternalMap<K, V>.set_item(idx: K; const value: V);
var pair : TPair<K, V>;
begin
  pair.first := idx;
  pair.second := value;
	tree.insert(pair);
end;

procedure TInternalMap<K, V>.clear;
begin
  tree.erase(true);
end;

procedure TInternalMap<K, V>.add(const obj: TPair<K, V>);
begin
  tree.insert(obj);
end;

function TInternalMap<K, V>.start : TIterator<K, V>;
begin
	result := tree.start;
end;

function TInternalMap<K, V>.finish : TIterator<K, V>;
begin
	result := tree.finish;
end;

function TInternalMap<K, V>.size : Integer;
begin
	result := tree.size;
end;

function TInternalMap<K, V>.max_size : Integer;
begin
	result := MaxInt;
end;

function TInternalMap<K, V>.empty : boolean;
begin
	result := tree.empty;
end;

function TInternalMap<K, V>.insert(const obj: TPair<K, V>): TPair<TIterator<K, V>, boolean>;
begin
  Result.second := tree.insert(obj);
  Result.first := tree.lower_bound(obj.first);
end;

function TInternalMap<K, V>.insert(position: TIterator<K, V>; const obj: TPair<K, V>): TIterator<K, V>;
begin
  tree.insertAt(position, obj);
  Result := tree.lower_bound(obj.first);
end;

procedure TInternalMap<K, V>.insert(first, last: TIterator<K, V>);
begin
  tree.insertIn(first, last);
end;

procedure TInternalMap<K, V>.erase(position: TIterator<K, V>);
begin
  tree.eraseAt(position);
end;

procedure TInternalMap<K, V>.erase(const x: K);
begin
  tree.eraseKey(x);
end;

procedure TInternalMap<K, V>.erase(first, last: TIterator<K, V>);
begin
  tree.eraseIn(first, last);
end;

procedure TInternalMap<K, V>.swap(var x: TInternalMap<K, V>);
begin
  tree.swap(x.tree);
end;

function TInternalMap<K, V>.count(const key: K) : Integer;
begin
	result := tree.count(key);
end;

function TInternalMap<K, V>.get_at(const key : K) : TPair<K, V>;
var iter : TIterator<K, V>;
begin
	iter := tree.find(key);
	result := iget(iter);
end;

function TInternalMap<K, V>.find(const key : K) : TIterator<K, V>;
begin
	result := tree.find(key);
end;

function TInternalMap<K, V>.lower_bound(const key : K) : TIterator<K, V>;
begin
	result := tree.lower_bound(key);
end;

function TInternalMap<K, V>.upper_bound(const key : K) : TIterator<K, V>;
begin
	result := tree.upper_bound(key);
end;

function TInternalMap<K, V>.equal_range(const x: K): TPair<TIterator<K, V>, TIterator<K, V>>;
var
  r: TRange<K, V>;
begin
  r := tree.equal_range(x);
  Result.first := r.start;
  Result.second := r.finish;
end;

procedure TInternalMap<K, V>.put_at(const key: K; value: V);
var pair : TPair<K, V>;
begin
  pair.first := key;
  pair.second := value;
	tree.insert(pair);
end;

procedure TInternalMap<K, V>.remove(const key : K);
begin
	tree.eraseKey(key);
end;

procedure TInternalMap<K, V>.remove_at(iterator : TIterator<K, V>);
begin
	tree.eraseAt(iterator);
end;

procedure TInternalMap<K, V>.remove_in(_start, _finish : TIterator<K, V>);
begin
	tree.eraseIn(_start, _finish);
end;

function TInternalMap<K, V>.start_key : TIterator<K, V>;
begin
	result := start;
end;
{$ENDREGION}

constructor TMap<K, V>.Create;
begin
  create_map(false, TComparer<K>.Default);
end;

constructor TMultiMap<K, V>.Create;
begin
  create_map(true, TComparer<K>.Default);
end;

end.
