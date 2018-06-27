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
unit DSTL.Algorithm.Heap;

interface

uses
  DSTL.STL.Iterator, Generics.Defaults, DSTL.Types;

type
{$HINTS OFF}
  THeapAlgorithms<T> = class
  private
    class procedure _push_heap(first: TIterator<T>;
      holeIndex, topIndex: integer; value: T); overload;
    class procedure _push_heap_aux(first, last: TIterator<T>); overload;
    class procedure _push_heap(first: TIterator<T>;
      holeIndex, topIndex: integer; value: T; comp: TCompare<T>); overload;
    class procedure _push_heap_aux(first, last: TIterator<T>; value: T;
      comp: TCompare<T>); overload;
    class procedure adjust_heap(first: TIterator<T>; holeIndex, len: integer;
      value: T); overload;
    class procedure adjust_heap(first: TIterator<T>; holeIndex, len: integer;
      value: T; comp: TCompare<T>); overload;
    class procedure _pop_heap(first, last: TIterator<T>;
      var result: TIterator<T>; value: T); overload;
    class procedure _pop_heap(first, last: TIterator<T>;
      var result: TIterator<T>; value: T; comp: TCompare<T>); overload;
    class procedure _pop_heap_aux(first, last: TIterator<T>); overload;
    class procedure _pop_heap_aux(first, last: TIterator<T>;
      comp: TCompare<T>); overload;
  public
    class procedure push_heap(first, last: TIterator<T>); overload;
    class procedure push_heap(first, last: TIterator<T>;
      comp: TCompare<T>); overload;
    class procedure pop_heap(first, last: TIterator<T>); overload;
    class procedure pop_heap(first, last: TIterator<T>;
      comp: TCompare<T>); overload;
    class procedure make_heap(first, last: TIterator<T>);
    class procedure sort_heap(first, last: TIterator<T>); overload;
    class procedure sort_heap(first, last: TIterator<T>;
      comp: TCompare<T>); overload;
  end;
{$HINTS ON}

implementation

class procedure THeapAlgorithms<T>._push_heap(first: TIterator<T>;
  holeIndex, topIndex: integer; value: T);
var
  parent: integer;
  it: TIterator<T>;
begin
  parent := (holeIndex - 1) div 2;
  while (holeIndex > topIndex) and
    (TComparer<T>.Default.Compare(TIterOperations<T>.get(TIterOperations<T>.add
    (first, parent)), value) < 0) do
  begin
    TIterOperations<T>.put(TIterOperations<T>.add(first, holeIndex),
      TIterOperations<T>.get(TIterOperations<T>.add(first, parent)));
    holeIndex := parent;
    parent := (holeIndex - 1) div 2;
  end;
  TIterOperations<T>.put(TIterOperations<T>.add(first, holeIndex), value);
end;

class procedure THeapAlgorithms<T>._push_heap_aux(first, last: TIterator<T>);
var
  io: TIterOperations<T>;
  it: TIterator<T>;
begin
  it := last;
  io.retreat(it);
  _push_heap(first, io.distance(first, last) - 1, 0, io.get(it));
end;

class procedure THeapAlgorithms<T>.push_heap(first, last: TIterator<T>);
begin
  _push_heap_aux(first, last);
end;

class procedure THeapAlgorithms<T>._push_heap(first: TIterator<T>;
  holeIndex, topIndex: integer; value: T; comp: TCompare<T>);
var
  parent: integer;
  io: TIterOperations<T>;
begin
  parent := (holeIndex - 1) div 2;
  while (holeIndex > topIndex) and
    (comp(io.get(io.add(first, parent)), value) < 0) do
  begin
    io.put(io.add(first, holeIndex), io.get(io.add(first, parent)));
    holeIndex := parent;
    parent := (holeIndex - 1) div 2;
  end;
  io.put(io.add(first, holeIndex), value);
end;

class procedure THeapAlgorithms<T>._push_heap_aux(first, last: TIterator<T>;
  value: T; comp: TCompare<T>);
var
  io: TIterOperations<T>;
  it: TIterator<T>;
begin
  it := last;
  io.retreat(it);
  _push_heap(first, io.distance(first, last) - 1, 0, it, comp);
end;

class procedure THeapAlgorithms<T>.push_heap(first, last: TIterator<T>;
  comp: TCompare<T>);
var
  io: TIterOperations<T>;
begin
  _push_heap_aux(first, last, io.get(first), comp);
end;

class procedure THeapAlgorithms<T>.adjust_heap(first: TIterator<T>;
  holeIndex, len: integer; value: T);
var
  topIndex, secondChild: integer;
  it1, it2: TIterator<T>;
begin
  topIndex := holeIndex;
  secondChild := 2 * holeIndex + 2;
  while (secondChild < len) do
  begin
    it1 := first;
    TIterOperations<T>.advance_by(it1, secondChild);
    it2 := first;
    TIterOperations<T>.advance_by(it2, secondChild - 1);
    if TComparer<T>.Default.Compare(TIterOperations<T>.get(it1), TIterOperations<T>.get(it2)) < 0 then
      dec(secondChild);
    it1 := first;
    TIterOperations<T>.advance_by(it1, holeIndex);
    it2 := first;
    TIterOperations<T>.advance_by(it2, secondChild);
    TIterOperations<T>.put(it1, TIterOperations<T>.get(it2));
    holeIndex := secondChild;
    secondChild := 2 * (secondChild + 1);
  end;
  if secondChild = len then
  begin
    it1 := first;
    TIterOperations<T>.advance_by(it1, holeIndex);
    it2 := first;
    TIterOperations<T>.advance_by(it2, secondChild - 1);
    TIterOperations<T>.put(it1, TIterOperations<T>.get(it2));
    holeIndex := secondChild - 1;
  end;
  _push_heap(first, holeIndex, topIndex, value);
end;

class procedure THeapAlgorithms<T>._pop_heap(first, last: TIterator<T>;
  var result: TIterator<T>; value: T);
begin
  TIterOperations<T>.put(result, TIterOperations<T>.get(first));
  adjust_heap(first, 0, TIterOperations<T>.distance(first, last), value);
end;

class procedure THeapAlgorithms<T>._pop_heap_aux(first, last: TIterator<T>);
var
  it: TIterator<T>;
begin
  it := last;
  TIterOperations<T>.retreat(it);
  _pop_heap(first, it, it, TIterOperations<T>.get(it));
end;

class procedure THeapAlgorithms<T>.pop_heap(first, last: TIterator<T>);
begin
  _pop_heap_aux(first, last);
end;

class procedure THeapAlgorithms<T>.adjust_heap(first: TIterator<T>;
  holeIndex, len: integer; value: T; comp: TCompare<T>);
var
  topIndex, secondChild: integer;
  io: TIterOperations<T>;
  it1, it2: TIterator<T>;
begin
  topIndex := holeIndex;
  secondChild := 2 * holeIndex + 2;
  while (secondChild < len) do
  begin
    it1 := first;
    io.advance_by(it1, secondChild);
    it2 := first;
    io.advance_by(it2, secondChild - 1);
    if comp(io.get(it1), io.get(it2)) < 0 then
      dec(secondChild);
    it1 := first;
    io.advance_by(it1, holeIndex);
    it2 := first;
    io.advance_by(it2, secondChild);
    io.put(it1, io.get(it2));
    holeIndex := secondChild;
    secondChild := 2 * (secondChild + 1);
  end;
  if secondChild = len then
  begin
    it1 := first;
    io.advance_by(it1, holeIndex);
    it2 := first;
    io.advance_by(it2, secondChild - 1);
    io.put(it1, io.get(it2));
    holeIndex := secondChild - 1;
  end;
  _push_heap(first, holeIndex, topIndex, value);
end;

class procedure THeapAlgorithms<T>._pop_heap(first, last: TIterator<T>;
  var result: TIterator<T>; value: T; comp: TCompare<T>);
begin
  TIterOperations<T>.put(result, TIterOperations<T>.get(first));
  adjust_heap(first, 0, TIterOperations<T>.distance(first, last), value, comp);
end;

class procedure THeapAlgorithms<T>._pop_heap_aux(first, last: TIterator<T>;
  comp: TCompare<T>);
var
  io: TIterOperations<T>;
  it: TIterator<T>;
begin
  it := last;
  io.retreat(it);
  _pop_heap(first, it, it, io.get(it), comp);
end;

class procedure THeapAlgorithms<T>.pop_heap(first, last: TIterator<T>;
  comp: TCompare<T>);
begin
  _pop_heap_aux(first, last, comp);
end;

class procedure THeapAlgorithms<T>.make_heap(first, last: TIterator<T>);
var
  io: TIterOperations<T>;
  len, parent: integer;
  it: TIterator<T>;
begin
  len := io.distance(first, last);
  if len < 2 then
    exit;
  parent := (len - 2) div 2;

  while true do
  begin
    it := first;
    io.advance_by(it, parent);
    adjust_heap(first, parent, len, io.get(it));
    if parent = 0 then
      exit;
    dec(parent);
  end;
end;

class procedure THeapAlgorithms<T>.sort_heap(first, last: TIterator<T>);
begin
  while (TIterOperations<T>.distance(first, last) > 1) do
  begin
    pop_heap(first, last);
    TIterOperations<T>.retreat(last);
  end;
end;

class procedure THeapAlgorithms<T>.sort_heap(first, last: TIterator<T>;
  comp: TCompare<T>);
var
  io: TIterOperations<T>;
begin
  while (io.distance(first, last) > 1) do
  begin
    pop_heap(first, last, comp);
    io.retreat(last);
  end;
end;

end.
