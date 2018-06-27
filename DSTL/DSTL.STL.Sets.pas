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
unit DSTL.STL.Sets;

interface
uses
  DSTL.STL.Iterator, DSTL.STL.RBTree, DSTL.Utils.Pair, Generics.Defaults;

type
  TInternalSet<T> = class(TContainer<T, T>)
  protected
    tree: TRedBlackTree<T, T>;

    procedure create_set(always_insert: boolean; compare: IComparer<T>);
    procedure iadvance(var Iterator: TIterator<T, T>);  override;
    function iat_end(const Iterator: TIterator<T, T>): boolean; override;
    function iequals(const iter1, iter2: TIterator<T, T>): Boolean;  override;
    function iremove(const Iterator: TIterator<T, T>): TIterator<T, T>; override;
    procedure iretreat(var Iterator: TIterator<T, T>);  override;
    procedure clear;
  public
    destructor Destroy;   override;
    function start: TIterator<T, T>;
    function finish: TIterator<T, T>;
    procedure add(const obj: T);
    procedure remove(const obj : T);
    function includes(const obj: T): boolean;
  end;

  TSet<T> = class(TInternalSet<T>)
  public
    constructor Create;
  end;

  TMultiSet<T> = class(TInternalSet<T>)
  public
    constructor Create;
  end;

implementation

procedure TInternalSet<T>.create_set(always_insert: boolean; compare: IComparer<T>);
begin
  tree := TRedBlackTree<T, T>.Create(Self, always_insert, compare);
end;

destructor TInternalSet<T>.Destroy;
begin
	tree.free;
	inherited;
end;

procedure TInternalSet<T>.iadvance(var Iterator: TIterator<T, T>);
begin
  tree.RBincrement(Iterator.node);
end;

function TInternalSet<T>.iat_end(const Iterator: TIterator<T, T>): boolean;
begin
  Result := Iterator.node = tree.EndNode;
end;

function TInternalSet<T>.iequals(const iter1, iter2: TIterator<T, T>): Boolean;
begin
  result := iter1.node = iter2.node;
end;

function TInternalSet<T>.iremove(const Iterator: TIterator<T, T>): TIterator<T, T>;
begin
  result := Iterator;
  iadvance(result);
  tree.eraseAt(Iterator);
end;

procedure TInternalSet<T>.iretreat(var Iterator: TIterator<T, T>);
begin
  tree.RBdecrement(Iterator.node);
end;

procedure TInternalSet<T>.clear;
begin
  tree.erase(true);
end;

function TInternalSet<T>.start : TIterator<T, T>;
begin
	result := tree.start;
end;

function TInternalSet<T>.finish : TIterator<T, T>;
begin
	result := tree.finish;
end;

procedure TInternalSet<T>.add(const obj: T);
begin
{$IF DEFINED(VER210)}
  tree.insert(TPair<T, T>.Create(obj, obj));
{$ELSE}
  tree.insert(TPair<T, T>.Create(obj, T(nil)));
{$IFEND}
end;

procedure TInternalSet<T>.remove(const obj : T);
begin
	tree.eraseKey(obj);
end;

function TInternalSet<T>.includes(const obj: T): boolean;
var
  iter: TIterator<T, T>;
  io: TIterOperations<T, T>;
begin
  iter := tree.find(obj);
	result := not io.equals(iter, finish);
end;

constructor TSet<T>.Create;
begin
  create_set(false, TComparer<T>.Default);
end;

constructor TMultiSet<T>.Create;
begin
  create_set(true, TComparer<T>.Default);
end;

end.
