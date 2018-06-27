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
unit DSTL.STL.Iterator;

interface

uses
  System.SysUtils, DSTL.Types, DSTL.STL.ListNode, DSTL.STL.TreeNode,
  DSTL.Utils.Pair, DSTL.STL.DequeMap, DSTL.Exception, DSTL.Tree.TreeNode,
  DSTL.STL.HashNode;

const
  defaultArrSize = 16;

type

  TContainer<T> = class;
  TContainer<T1, T2> = class;

  TIteratorHandle<T> = class;
  TIteratorHandle<T1, T2> = class;
  IteratorStructure = (isVector, isDeque, isList, isMapSet, isHash, isTree);

  TIteratorFlag = (ifForward, ifReverse, ifBidirectional, ifRandomAccess);
  TIteratorFlags = set of TIteratorFlag;

  TIterator<T> = record
    handle: TIteratorHandle<T>;
    flags: TIteratorFlags;
    class operator Implicit(a: TIterator<T>): T;
    class operator Inc(a: TIterator<T>): TIterator<T>;
    class operator Dec(a: TIterator<T>): TIterator<T>;
    class operator Equal(a: TIterator<T>; b: TIterator<T>): Boolean;
    class operator NotEqual(a: TIterator<T>; b: TIterator<T>): Boolean;
    class operator Add(a: TIterator<T>; b: integer): TIterator<T>;
    class operator Subtract(a: TIterator<T>; b: integer): TIterator<T>; overload;
    class operator Subtract(a: TIterator<T>; b: TIterator<T>): integer; overload;
    case IteratorStructure of
      isVector:
        (* position is the index of the object the iterator points to *)
        (position: Integer);
      isDeque:
        (* cur is the index of the object in the buffer
         * first is the index of the first object in the buffer
         * last is the index of the last object in the buffer
         * bnode is the current map node
         * buf_size is the buffer size of the deque
         *)
        (cur: integer;
         first: integer;
         last: integer;
         bnode: TDequeMapNode<T>;
         buf_size: integer;);
      isList:
        (* node points to current node in the list *)
        (node: TListNode<T>);
      isTree:
        (tree_node: TTreeNode<T>);
  end;

  TIterator<T1, T2> = record
    handle: TIteratorHandle<T1, T2>;
    flags: TIteratorFlags;
    class operator Implicit(a: TIterator<T1, T2>): TPair<T1, T2>;
    class operator Inc(a: TIterator<T1, T2>): TIterator<T1, T2>;
    class operator Dec(a: TIterator<T1, T2>): TIterator<T1, T2>;
    class operator Equal(a: TIterator<T1, T2>; b: TIterator<T1, T2>): Boolean;
    class operator NotEqual(a: TIterator<T1, T2>; b: TIterator<T1, T2>): Boolean;
    case IteratorStructure of
      isMapSet:
        (node: TTreeNode<T1, T2>);
      isHash:
        (hnode: THashNode<T2>;
         ht: pointer );
  end;

  TIteratorHandle<T> = class
  protected
    procedure iadvance(var Iterator: TIterator<T>); virtual; abstract;
    procedure iretreat(var Iterator: TIterator<T>); virtual; abstract;
    function iget(const Iterator: TIterator<T>): T; virtual; abstract;
    procedure iput(const Iterator: TIterator<T>; const obj: T); virtual; abstract;
    function iremove(const Iterator: TIterator<T>): TIterator<T>;  virtual; abstract;
    function iat_end(const Iterator: TIterator<T>): boolean; virtual; abstract;
    function iequals(const iter1, iter2: TIterator<T>): Boolean;
      virtual; abstract;
    function idistance(const iter1, iter2: TIterator<T>): integer;
      virtual; abstract;
  end;

  TIteratorHandle<T1, T2> = class
  protected
    procedure iadvance(var Iterator: TIterator<T1, T2>); virtual; abstract;
    procedure iretreat(var Iterator: TIterator<T1, T2>); virtual; abstract;
    function iget(const Iterator: TIterator<T1, T2>): TPair<T1, T2>;
      virtual; abstract;
    procedure iput(const Iterator: TIterator<T1, T2>; const obj: TPair<T1, T2>); virtual; abstract;
    function iremove(const Iterator: TIterator<T1, T2>): TIterator<T1, T2>;  virtual; abstract;
    function iat_end(const Iterator: TIterator<T1, T2>): boolean; virtual; abstract;
    function iequals(const iter1, iter2: TIterator<T1, T2>): Boolean;
      virtual; abstract;
    function idistance(const iter1, iter2: TIterator<T1, T2>): integer;
      virtual; abstract;
  end;

  TContainer<T> = class(TIteratorHandle<T>)
  protected
    procedure iadvance(var Iterator: TIterator<T>); override;
    procedure iretreat(var Iterator: TIterator<T>); override;
    function iget(const Iterator: TIterator<T>): T; override;
    procedure iput(const Iterator: TIterator<T>; const obj: T); override;
    function iremove(const Iterator: TIterator<T>): TIterator<T>;  override;
    function iat_end(const Iterator: TIterator<T>): boolean; override;
    function iequals(const iter1, iter2: TIterator<T>): Boolean; override;
    function idistance(const iter1, iter2: TIterator<T>): integer; override;
  public
    constructor Create;
    procedure add(const obj: T); virtual; abstract;
    function remove(const obj: T):Boolean; virtual; abstract;
    procedure clear; virtual; abstract;
  end;

  TContainer<T1, T2> = class(TIteratorHandle<T1, T2>)
  protected
    procedure iadvance(var Iterator: TIterator<T1, T2>); override;
    procedure iretreat(var Iterator: TIterator<T1, T2>); override;
    function iget(const Iterator: TIterator<T1, T2>): TPair<T1, T2>; override;
    procedure iput(const Iterator: TIterator<T1, T2>; const obj: TPair<T1, T2>); override;
    function iremove(const Iterator: TIterator<T1, T2>): TIterator<T1, T2>;  override;
    function iat_end(const Iterator: TIterator<T1, T2>): boolean; override;
    function iequals(const iter1, iter2: TIterator<T1, T2>): Boolean; override;
    function idistance(const iter1, iter2: TIterator<T1, T2>): integer; override;
  public
    constructor Create;
  end;

{$WARNINGS OFF}     // disable warning for TIterOperations.equals
  TIterOperations<T> = class
    class procedure advance(var Iterator: TIterator<T>);
    class procedure advance_by(var Iterator: TIterator<T>; n: integer);
    class procedure retreat(var Iterator: TIterator<T>);
    class procedure retreat_by(var Iterator: TIterator<T>; n: integer);
    class function get(const Iterator: TIterator<T>): T;
    class procedure put(const Iterator: TIterator<T>; const obj: T);
    class function remove(const Iterator: TIterator<T>): TIterator<T>;
    class function at_end(const Iterator: TIterator<T>): boolean;
    class function equals(const iter1, iter2: TIterator<T>): Boolean;
    class function distance(const iter1, iter2: TIterator<T>): integer;
    class function add(iter: TIterator<T>; i: integer): TIterator<T>;
  end;

  TIterOperations<T1, T2> = class
    procedure advance(var Iterator: TIterator<T1, T2>);
    procedure retreat(var Iterator: TIterator<T1, T2>);
    function get(const Iterator: TIterator<T1, T2>): TPair<T1, T2>;
    procedure put(const Iterator: TIterator<T1, T2>; const obj: TPair<T1, T2>);
    function remove(const Iterator: TIterator<T1, T2>): TIterator<T1, T2>;
    function at_end(const Iterator: TIterator<T1, T2>): boolean;
    function equals(const iter1, iter2: TIterator<T1, T2>): Boolean;
    function distance(const iter1, iter2: TIterator<T1, T2>): integer;
  end;
{$WARNINGS ON}

implementation

{$REGION 'TContainer'}

constructor TContainer<T>.Create;
begin

end;

procedure TContainer<T>.iadvance(var Iterator: TIterator<T>);
begin
  dstl_raise_exception(E_NOT_IMPL);
end;

procedure TContainer<T>.iretreat(var Iterator: TIterator<T>);
begin
  dstl_raise_exception(E_NOT_IMPL);
end;

function TContainer<T>.iget(const Iterator: TIterator<T>): T;
begin
  dstl_raise_exception(E_NOT_IMPL);
end;

procedure TContainer<T>.iput(const Iterator: TIterator<T>; const obj: T);
begin
  dstl_raise_exception(E_NOT_IMPL);
end;

function TContainer<T>.iremove(const Iterator: TIterator<T>): TIterator<T>;
begin
  dstl_raise_exception(E_NOT_IMPL);
end;

function TContainer<T>.iat_end(const Iterator: TIterator<T>): boolean;
begin
  dstl_raise_exception(E_NOT_IMPL);
end;

function TContainer<T>.iequals(const iter1, iter2: TIterator<T>): Boolean;
begin
  dstl_raise_exception(E_NOT_IMPL);
end;

function TContainer<T>.idistance(const iter1, iter2: TIterator<T>): integer;
begin
  dstl_raise_exception(E_NOT_IMPL);
end;

constructor TContainer<T1, T2>.Create;
begin

end;

procedure TContainer<T1, T2>.iadvance(var Iterator: TIterator<T1, T2>);
begin
  dstl_raise_exception(E_NOT_IMPL);
end;

procedure TContainer<T1, T2>.iretreat(var Iterator: TIterator<T1, T2>);
begin
  dstl_raise_exception(E_NOT_IMPL);
end;

function TContainer<T1, T2>.iget(const Iterator: TIterator<T1, T2>)
  : TPair<T1, T2>;
begin
  dstl_raise_exception(E_NOT_IMPL);
end;

procedure TContainer<T1, T2>.iput(const Iterator: TIterator<T1, T2>; const obj: TPair<T1, T2>);
begin
  dstl_raise_exception(E_NOT_IMPL);
end;

function TContainer<T1, T2>.iremove(const Iterator: TIterator<T1, T2>): TIterator<T1, T2>;
begin
  dstl_raise_exception(E_NOT_IMPL);
end;

function TContainer<T1, T2>.iat_end(const Iterator: TIterator<T1, T2>): boolean;
begin
  dstl_raise_exception(E_NOT_IMPL);
end;

function TContainer<T1, T2>.iequals(const iter1,
  iter2: TIterator<T1, T2>): Boolean;
begin
  dstl_raise_exception(E_NOT_IMPL);
end;

function TContainer<T1, T2>.idistance(const iter1, iter2: TIterator<T1, T2>): integer;
begin
  dstl_raise_exception(E_NOT_IMPL);
end;

{$ENDREGION}

{$REGION 'TIterator'}

class operator TIterator<T>.Implicit(a: TIterator<T>): T;
begin
  Result := a.handle.iget(a);
end;

class operator TIterator<T>.Inc(a: TIterator<T>): TIterator<T>;
begin
  a.handle.iadvance(a);
  Result := a;
end;

class operator TIterator<T>.Dec(a: TIterator<T>): TIterator<T>;
begin
  a.handle.iretreat(a);
  Result := a;
end;

class operator TIterator<T>.Equal(a: TIterator<T>; b: TIterator<T>): Boolean;
begin
  Result := a.handle.iequals(a, b);
end;

class operator TIterator<T>.NotEqual(a: TIterator<T>; b: TIterator<T>): Boolean;
begin
  Result := not a.handle.iequals(a, b);
end;

class operator TIterator<T>.Add(a: TIterator<T>; b: integer): TIterator<T>;
var
  i: integer;
begin
  Result := a;
  for i := 1 to b do
    Result.handle.iadvance(Result);
end;

class operator TIterator<T>.Subtract(a: TIterator<T>; b: integer): TIterator<T>;
var
  i: integer;
begin
  Result := a;
  for i := 1 to b do
    Result.handle.iretreat(Result);
end;

class operator TIterator<T>.Subtract(a: TIterator<T>; b: TIterator<T>): integer;
begin
  Result := a.handle.idistance(b, a);
end;

class operator TIterator<T1, T2>.Implicit(a: TIterator<T1, T2>): TPair<T1, T2>;
begin
  Result := a.handle.iget(a);
end;

class operator TIterator<T1, T2>.Inc(a: TIterator<T1, T2>): TIterator<T1, T2>;
begin
  a.handle.iadvance(a);
  Result := a;
end;

class operator TIterator<T1, T2>.Dec(a: TIterator<T1, T2>): TIterator<T1, T2>;
begin
  a.handle.iretreat(a);
  Result := a;
end;

class operator TIterator<T1, T2>.Equal(a: TIterator<T1, T2>;
  b: TIterator<T1, T2>): Boolean;
begin
  Result := a.handle.iequals(a, b);
end;

class operator TIterator<T1, T2>.NotEqual(a: TIterator<T1, T2>;
  b: TIterator<T1, T2>): Boolean;
begin
  Result := not a.handle.iequals(a, b);
end;

{$ENDREGION}

{$REGION 'TIterOperations'}

class procedure TIterOperations<T>.advance(var Iterator: TIterator<T>);
begin
  Iterator.handle.iadvance(Iterator);
end;

class procedure TIterOperations<T>.advance_by(var Iterator: TIterator<T>; n: integer);
begin
  while n > 0 do
  begin
    advance(Iterator);
    dec(n);
  end;
end;

class procedure TIterOperations<T>.retreat(var Iterator: TIterator<T>);
begin
  Iterator.handle.iretreat(Iterator);
end;

class procedure TIterOperations<T>.retreat_by(var Iterator: TIterator<T>; n: integer);
begin
  while n > 0 do
  begin
    retreat(Iterator);
    dec(n);
  end;
end;

class function TIterOperations<T>.get(const Iterator: TIterator<T>): T;
begin
  Result := Iterator.handle.iget(Iterator);
end;

class procedure TIterOperations<T>.put(const Iterator: TIterator<T>; const obj: T);
begin
  Iterator.handle.iput(Iterator, obj);
end;

class function TIterOperations<T>.remove(const Iterator: TIterator<T>): TIterator<T>;
begin
  Result := Iterator.handle.iremove(Iterator);
end;

class function TIterOperations<T>.at_end(const Iterator: TIterator<T>): boolean;
begin
  Result := Iterator.handle.iat_end(Iterator);
end;

class function TIterOperations<T>.equals(const iter1, iter2: TIterator<T>): Boolean;
begin
  Result := iter1.handle.iequals(iter1, iter2);
end;

class function TIterOperations<T>.distance(const iter1, iter2: TIterator<T>): integer;
begin
  Result := iter1.handle.idistance(iter1, iter2);
end;

class function TIterOperations<T>.add(iter: TIterator<T>; i: integer): TIterator<T>;
begin
  while i > 0 do
  begin
    iter.handle.iadvance(iter);
    dec(i);
  end;
  Result := iter;
end;

procedure TIterOperations<T1, T2>.advance(var Iterator: TIterator<T1, T2>);
begin
  Iterator.handle.iadvance(Iterator);
end;

procedure TIterOperations<T1, T2>.retreat(var Iterator: TIterator<T1, T2>);
begin
  Iterator.handle.iretreat(Iterator);
end;

function TIterOperations<T1, T2>.get(const Iterator: TIterator<T1, T2>)
  : TPair<T1, T2>;
begin
  Result := Iterator.handle.iget(Iterator);
end;

procedure TIterOperations<T1, T2>.put(const Iterator: TIterator<T1, T2>; const obj: TPair<T1, T2>);
begin
  Iterator.handle.iput(Iterator, obj);
end;

function TIterOperations<T1, T2>.remove(const Iterator: TIterator<T1, T2>): TIterator<T1, T2>;
begin
  Result := Iterator.handle.iremove(Iterator);
end;

function TIterOperations<T1, T2>.at_end(const Iterator: TIterator<T1, T2>): boolean;
begin
  Result := Iterator.handle.iat_end(Iterator);
end;

function TIterOperations<T1, T2>.equals(const iter1,
  iter2: TIterator<T1, T2>): Boolean;
begin
  Result := iter1.handle.iequals(iter1, iter2);
end;

function TIterOperations<T1, T2>.distance(const iter1, iter2: TIterator<T1, T2>): integer;
begin
  Result := iter1.handle.idistance(iter1, iter2);
end;

{$ENDREGION}

end.
