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
unit DSTL.Algorithm;

interface

uses Generics.Defaults, DSTL.STL.Iterator, DSTL.Types, DSTL.Utils.Pair;

type
{$REGION 'TIterAlgorithms'}
  Func<T> = procedure(p: T);

  {$HINTS OFF}
  TIterAlgorithms<T> = class
  private
    class function inc_it(var it: TIterator<T>; n: integer): TIterator<T>;
    class function dec_it(var it: Titerator<T>; n: integer): TIterator<T>;
    class function equal_it(it1, it2: TIterator<T>): boolean;
    class function get_it(it: TIterator<T>): T;
    class procedure put_it(it: TIterator<T>; obj: T);
    class function compare_obj(obj1, obj2: T): integer;
    class procedure _sort(first, last: TIterator<T>; l, r: integer); overload;
    class procedure _sort(first, last: TIterator<T>; l, r: integer; comp: TCompare<T>); overload;
  public
    (* we cannot do this yet
     * class function accumulate(first, last: TIterator<T>; init: T);
     *)
    class function accumulate(first, last: TIterator<T>; init: T; binary_op:
                                                TBinaryFunction<T, T, T>): T;
    (* class function adjacent_difference(first, last: TIterator<T>; res: TIterator<T>;
                        ): TIterator<T>; *)
    class function adjacent_difference(first, last: TIterator<T>; res: TIterator<T>;
                        binary_op: TBinaryFunction<T, T, T>): TIterator<T>;
    class function adjacent_find(first, last: TIterator<T>): TIterator<T>;  overload;
    class function adjacent_find(first, last: TIterator<T>; pred: TBinaryPredicate<T, T>): TIterator<T>;  overload;
    class function binary_search(first, last: Titerator<T>; value: T): boolean; overload;
    class function binary_search(first, last: TIterator<T>; value: T; comp: TCompare<T>): boolean; overload;
    class function copy(first, last, res: TIterator<T>): TIterator<T>;
    class function copy_backward(first, last, res: TIterator<T>): TIterator<T>;
    class function count(first, last: TIterator<T>; value: T): integer;
    class function count_if(first, last: TIterator<T>; pred: TPredicate<T>): integer;
    class function equal(first1, last1, first2: TIterator<T>): boolean; overload;
    class function equal(first1, last1, first2: TIterator<T>; pred: TBinaryPredicate<T, T>): boolean; overload;
    class procedure fill(first, last: TIterator<T>; value: T);
    class function fill_n(first: TIterator<T>; n: integer; value: T): TIterator<T>;
    class function find(first, last: TIterator<T>; value: T): TIterator<T>;
    class function find_if(first, last: TIterator<T>; pred: TPredicate<T>): TIterator<T>;
    class function find_end(first1, last1, first2, last2: TIterator<T>): TIterator<T>;  overload;
    class function find_end(first1, last1, first2, last2: TIterator<T>; pred: TBinaryPredicate<T, T>): TIterator<T>; overload;
    class function find_first_of(first1, last1, first2, last2: TIterator<T>): TIterator<T>;  overload;
    class function find_first_of(first1, last1, first2, last2: TIterator<T>; pred: TBinaryPredicate<T, T>): TIterator<T>; overload;
    class procedure for_each(first, last: TIterator<T>; f: Func<T>);
    class procedure generate(first, last: TIterator<T>; gen: TGenerator<T>);
    class procedure generate_n(first: TIterator<T>; n: TSizeType; gen: TGenerator<T>);
    class function includes(first1, last1, first2, last2: TIterator<T>): boolean; overload;
    class function includes(first1, last1, first2, last2: TIterator<T>; comp: TCompare<T>): boolean; overload;
    class procedure iter_swap(a, b: TIterator<T>);
    class function lexicographical_compare(first1, last1, first2, last2: TIterator<T>): boolean; overload;
    class function lexicographical_compare(first1, last1, first2, last2: TIterator<T>; comp: TCompare<T>): boolean; overload;
    class function lower_bound(first, last: TIterator<T>; value: T): TIterator<T>; overload;
    class function lower_bound(first, last: TIterator<T>; value: T; comp: TCompare<T>): TIterator<T>; overload;
    class function next_permutation(first, last: TIterator<T>): boolean; overload;
    class function next_permutation(first, last: TIterator<T>; comp: TCompare<T>): boolean; overload;
    class function partition(first, last: TIterator<T>; pred: TPredicate<T>): TIterator<T>;
    class function prev_permutation(first, last: TIterator<T>): boolean; overload;
    class function prev_permutation(first, last: TIterator<T>; comp: TCompare<T>): boolean; overload;
    class procedure random_shuffle(first, last: TIterator<T>); overload;
    class procedure random_shuffle(first, last: TIterator<T>; rand: TRandomNumberGenerator); overload;
    class procedure reverse(first, last: TIterator<T>);
    class procedure rotate(first, middle, last: TIterator<T>);
    class function max_element(first, last: TIterator<T>): TIterator<T>;
    class function merge(first1, last1, first2, last2, res: TIterator<T>): TIterator<T>;
    class function min_element(first, last: TIterator<T>): TIterator<T>;
    class function mismatch(first1, last1, first2: TIterator<T>): TPair<TIterator<T>, TIterator<T>>; overload;
    class function mismatch(first1, last1, first2: TIterator<T>; pred: TBinaryPredicate<T, T>): TPair<TIterator<T>, TIterator<T>>; overload;
    class procedure sort(first, last: TIterator<T>); overload;
    class procedure sort(first, last: TIterator<T>; comp: TCompare<T>);  overload;
  end;
  {$HINTS ON}

  Func<T1, T2> = procedure(p: TPair<T1, T2>);

  TIterAlgorithms<T1, T2> = class
    class procedure for_each(first, last: TIterator<T1, T2>; f: Func<T1, T2>);
  end;
{$ENDREGION}

{$REGION 'TMinMax<T>'}

  TMinMax<T> = class
    class function min(data: array of T): T; overload;
    class function min(a, b: T): T; overload;
    class function max(data: array of T): T; overload;
    class function max(a, b: T): T; overload;
  end;

{$ENDREGION}

{$REGION 'String Algorithm'}


function upcase(c: char): char;
function lowcase(c: char): char;

function to_upper(s: string): string;
function to_lower(s: string): string;

function is_alpha(c: char): boolean;
function is_digit(c: char): boolean;
function is_alnum(c: char): boolean;
function is_lower(c: char): boolean;
function is_upper(c: char): boolean;

{$ENDREGION}

implementation

{$REGION 'TIterAlgorithms'}

class function TIterAlgorithms<T>.inc_it(var it: TIterator<T>; n: integer): TIterator<T>;
begin
  while n > 0 do
  begin
    it.handle.iadvance(it);
    dec(n);
  end;
  exit(it);
end;

class function TIterAlgorithms<T>.dec_it(var it: TIterator<T>; n: integer): TIterator<T>;
begin
  while n > 0 do
  begin
    it.handle.iretreat(it);
    dec(n);
  end;
  exit(it);
end;

class function TIterAlgorithms<T>.equal_it(it1, it2: TIterator<T>): boolean;
begin
  Result := it1.handle.iequals(it1, it2);
end;

class function TIterAlgorithms<T>.get_it(it: TIterator<T>): T;
begin
  Result := it.handle.iget(it);
end;

class procedure TIterAlgorithms<T>.put_it(it: TIterator<T>; obj: T);
begin
  it.handle.iput(it, obj);
end;

class function TIterAlgorithms<T>.compare_obj(obj1, obj2: T): integer;
begin
  Result := TComparer<T>.Default.Compare(obj1, obj2);
end;

class function TIterAlgorithms<T>.accumulate(first, last: TIterator<T>; init: T;
                                binary_op: TBinaryFunction<T, T, T>): T;
var
  it: TIterator<T>;
begin
  Result := init;
  it := first;

  while it <> last do
  begin
    Result := binary_op(Result, it.handle.iget(it));
  end;
end;

class function TIterAlgorithms<T>.adjacent_difference(first, last: TIterator<T>;
         res: TIterator<T>; binary_op: TBinaryFunction<T, T, T>): TIterator<T>;
var
  it, it2: TIterator<T>;
begin
  if first.handle.iequals(first, last) then exit(res);

  it := first;
  res.handle.iput(res, it);
  it.handle.iadvance(it);
  res.handle.iadvance(res);
  while it <> last do
  begin
    it2 := it; it2.handle.iretreat(it2);
    res.handle.iput(res, binary_op(it.handle.iget(it), it2.handle.iget(it2)));
    it.handle.iadvance(it);
    res.handle.iadvance(res);
  end;
end;

class function TIterAlgorithms<T>.adjacent_find(first, last: TIterator<T>): TIterator<T>;
var
  next: TIterator<T>;
  comp: IComparer<T>;
begin
  comp := TComparer<T>.Default;
  if not first.handle.iequals(first, last) then
  begin
    next := first;
    next.handle.iadvance(next);
    while not next.handle.iequals(next, last) do
    begin
      if comp.Compare(first.handle.iget(first), next.handle.iget(next)) = 0then exit(first)
      else
      begin
        next.handle.iadvance(next);
        first.handle.iadvance(first);
      end;
    end;
  end;
  Result := last;
end;

class function TIterAlgorithms<T>.adjacent_find(first, last: TIterator<T>; pred: TBinaryPredicate<T, T>): TIterator<T>;
var
  next: TIterator<T>;
begin
  if not first.handle.iequals(first, last) then
  begin
    next := first;
    next.handle.iadvance(next);
    while not next.handle.iequals(next, last) do
    begin
      if pred(first.handle.iget(first), next.handle.iget(next)) then exit(first)
      else
      begin
        next.handle.iadvance(next);
        first.handle.iadvance(first);
      end;
    end;
  end;
  Result := last;
end;

class function TIterAlgorithms<T>.binary_search(first, last: Titerator<T>; value: T): boolean;
begin
  first := lower_bound(first,last,value);
  exit((not first.handle.iequals(first, last)) and (not(TComparer<T>.Default.compare(value, first.handle.iget(first)) < 0)));
end;

class function TIterAlgorithms<T>.binary_search(first, last: TIterator<T>; value: T; comp: TCompare<T>): boolean;
begin
  first := lower_bound(first,last,value, comp);
  exit((not first.handle.iequals(first, last)) and (not(comp(value, first.handle.iget(first)) < 0)));
end;

class function TIterAlgorithms<T>.copy(first, last, res: TIterator<T>): TIterator<T>;
var
  n: integer;
begin
  n := first.handle.idistance(first, last);
  while n > 0 do
  begin
    res.handle.iput(res, first.handle.iget(first));
    first.handle.iadvance(first);
    res.handle.iadvance(res);
    dec(n);
  end;
  Result := res;
end;

class function TIterAlgorithms<T>.copy_backward(first, last, res: TIterator<T>): TIterator<T>;
begin
  while not first.handle.iequals(first, last) do
  begin
    first.handle.iretreat(last);
    res.handle.iretreat(res);
    res.handle.iput(res, last.handle.iget(last));
  end;
  Result := res;
end;

class function TIterAlgorithms<T>.count(first, last: TIterator<T>; value: T): integer;
begin
  Result := 0;
  while not first.handle.iequals(first, last) do
  begin
    if TComparer<T>.Default.Compare(first.handle.iget(first), value) = 0 then inc(Result);
    first.handle.iadvance(first);
  end;
end;

class function TIterAlgorithms<T>.count_if(first, last: TIterator<T>; pred: TPredicate<T>): integer;
begin
  Result := 0;
  while not first.handle.iequals(first, last) do
  begin
    if pred(first.handle.iget(first)) then inc(Result);
    first.handle.iadvance(first);
  end;
end;

class function TIterAlgorithms<T>.equal(first1, last1, first2: TIterator<T>): boolean;
begin
  while not first1.handle.iequals(first1, last1) do
  begin
    if TComparer<T>.Default.Compare(first1.handle.iget(first1), first2.handle.iget(first2)) <> 0 then exit(false);
    first1.handle.iadvance(first1);
    first2.handle.iadvance(first2);
  end;
  exit(true);
end;

class function TIterAlgorithms<T>.equal(first1, last1, first2: TIterator<T>; pred: TBinaryPredicate<T, T>): boolean;
begin
  while not first1.handle.iequals(first1, last1) do
  begin
    if not pred(first1.handle.iget(first1), first2.handle.iget(first2)) then exit(false);
    first1.handle.iadvance(first1);
    first2.handle.iadvance(first2);
  end;
  exit(true);
end;

class procedure TIterAlgorithms<T>.fill(first, last: TIterator<T>; value: T);
begin
  while not first.handle.iequals(first, last) do
  begin
    first.handle.iput(first, value);
    first.handle.iadvance(first);
  end;
end;

class function TIterAlgorithms<T>.fill_n(first: TIterator<T>; n: integer; value: T): TIterator<T>;
begin
  while n > 0 do
  begin
    first.handle.iput(first, value);
    first.handle.iadvance(first);
    dec(n);
  end;
  Result := first;
end;

class function TIterAlgorithms<T>.find(first, last: TIterator<T>; value: T): TIterator<T>;
var
  comp: IComparer<T>;
begin
  comp := TComparer<T>.Default;
  while not first.handle.iequals(first, last) do
  begin
    if comp.Compare(first.handle.iget(first), value) = 0 then break;
    first.handle.iadvance(first);
  end;
  Result := first;
end;

class function TIterAlgorithms<T>.find_if(first, last: TIterator<T>; pred: TPredicate<T>): TIterator<T>;
begin
  while not first.handle.iequals(first, last) do
  begin
    if pred(first.handle.iget(first)) then break;
    first.handle.iadvance(first);
  end;
  Result := first;
end;

class function TIterAlgorithms<T>.find_end(first1, last1, first2, last2: TIterator<T>): TIterator<T>;
var
  ret, it1, it2: TIterator<T>;
  comp: IComparer<T>;
begin
  comp := TComparer<T>.Default;

  if first2.handle.iequals(first2, last2) then exit(last1);

  ret := last1;

  while not first1.handle.iequals(first1, last1) do
  begin
    it1 := first1;
    it2 := first2;
    while comp.Compare(it1.handle.iget(it1), it2.handle.iget(it2)) = 0 do
    begin
      inc(it1);
      inc(it2);
      if it2.handle.iequals(it2, last2) then
      begin
        ret := first1;
        break;
      end;
      if it1.handle.iequals(it1, last1) then exit(ret);
    end;
    first1.handle.iadvance(first1);
  end;

  Result :=  ret;
end;

class function TIterAlgorithms<T>.find_end(first1, last1, first2, last2: TIterator<T>;
                                     pred: TBinaryPredicate<T, T>): TIterator<T>;
var
  ret, it1, it2: TIterator<T>;
begin
  if first2.handle.iequals(first2, last2) then exit(last1);

  ret := last1;

  while not first1.handle.iequals(first1, last1) do
  begin
    it1 := first1;
    it2 := first2;
    while pred(it1.handle.iget(it1), it2.handle.iget(it2)) do
    begin
      inc(it1);
      inc(it2);
      if it2.handle.iequals(it2, last2) then
      begin
        ret := first1;
        break;
      end;
      if it1.handle.iequals(it1, last1) then exit(ret);
    end;
    first1.handle.iadvance(first1);
  end;

  Result :=  ret;
end;

class function TIterAlgorithms<T>.find_first_of(first1, last1, first2, last2: TIterator<T>): TIterator<T>;
var
  it: TIterator<T>;
  comp: IComparer<T>;
begin
  comp := TComparer<T>.Default;
  while not first1.handle.iequals(first1, last1) do
  begin
    it := first2;
    while not it.handle.iequals(it, last2) do
    begin
      if comp.Compare(it.handle.iget(it), first1.handle.iget(first1)) = 0 then exit(first1);
      it.handle.iadvance(it);
    end;
    first1.handle.iadvance(first1);
  end;
  Result := last1;
end;

class function TIterAlgorithms<T>.find_first_of(first1, last1, first2, last2: TIterator<T>;
                                     pred: TBinaryPredicate<T, T>): TIterator<T>;
var
  it: TIterator<T>;
begin
  while not first1.handle.iequals(first1, last1) do
  begin
    it := first2;
    while not it.handle.iequals(it, last2) do
    begin
      if pred(it.handle.iget(it), first1.handle.iget(first1)) then exit(first1);
      it.handle.iadvance(it);
    end;
    first1.handle.iadvance(first1);
  end;
  Result := last1;
end;

class procedure TIterAlgorithms<T>.for_each(first, last: TIterator<T>; f: Func<T>);
var
  op: TIterOperations<T>;
begin
  while not(op.equals(first, last)) do
  begin
    f(first.handle.iget(first));
    op.advance(first);
  end;
end;

class procedure TIterAlgorithms<T>.generate(first, last: TIterator<T>; gen: TGenerator<T>);
begin
  while not first.handle.iequals(first, last) do
  begin
    first.handle.iput(first, gen);
    first.handle.iadvance(first);
  end;
end;

class procedure TIterAlgorithms<T>.generate_n(first: TIterator<T>; n: TSizeType; gen: TGenerator<T>);
begin
  while n > 0 do
  begin
    dec(n);
    first.handle.iput(first, gen);
    first.handle.iadvance(first);
  end;
end;

class function TIterAlgorithms<T>.includes(first1, last1, first2, last2: TIterator<T>): boolean;
begin
  while not first1.handle.iequals(first1, last1) do
  begin
    if TComparer<T>.Default.Compare(first2.handle.iget(first2), first1.handle.iget(first1)) < 0 then break
    else if TComparer<T>.Default.Compare(first1.handle.iget(first1), first2.handle.iget(first2)) < 0 then first1.handle.iadvance(first1)
    else begin
      first1.handle.iadvance(first1);
      first2.handle.iadvance(first2);
    end;
    if first2.handle.iequals(first2, last2) then exit(true);
  end;
  exit(false);
end;

class function TIterAlgorithms<T>.includes(first1, last1, first2, last2: TIterator<T>; comp: TCompare<T>): boolean;
begin
  while not first1.handle.iequals(first1, last1) do
  begin
    if comp(first2.handle.iget(first2), first1.handle.iget(first1)) < 0 then break
    else if comp(first1.handle.iget(first1), first2.handle.iget(first2)) < 0 then first1.handle.iadvance(first1)
    else begin
      first1.handle.iadvance(first1);
      first2.handle.iadvance(first2);
    end;
    if first2.handle.iequals(first2, last2) then exit(true);
  end;
  exit(false);
end;

class procedure TIterAlgorithms<T>.iter_swap(a, b: TIterator<T>);
var
  tmp: T;
begin
  tmp := a.handle.iget(a);
  a.handle.iput(a, b.handle.iget(b));
  b.handle.iput(b, tmp);
end;

class function TIterAlgorithms<T>.lexicographical_compare(first1, last1, first2, last2: TIterator<T>): boolean;
begin
  while not first1.handle.iequals(first1, last1) do
  begin
    if (first2.handle.iequals(first2, last2) or
        (TComparer<T>.Default.compare(first2.handle.iget(first2), first1.handle.iget(first1)) < 0)) then
    exit(false)
    else if (TComparer<T>.Default.compare(first1.handle.iget(first1), first2.handle.iget(first2)) < 0) then
    exit(true);
    first1.handle.iadvance(first1);
    first2.handle.iadvance(first2);
  end;
  Result := not first2.handle.iequals(first2, last2);
end;

class function TIterAlgorithms<T>.lexicographical_compare(first1, last1, first2, last2: TIterator<T>; comp: TCompare<T>): boolean;
begin
    while not first1.handle.iequals(first1, last1) do
  begin
    if (first2.handle.iequals(first2, last2) or
        (comp(first2.handle.iget(first2), first1.handle.iget(first1)) < 0)) then
    exit(false)
    else if (comp(first1.handle.iget(first1), first2.handle.iget(first2)) < 0) then
    exit(true);
    first1.handle.iadvance(first1);
    first2.handle.iadvance(first2);
  end;
  Result := not first2.handle.iequals(first2, last2);
end;

class function TIterAlgorithms<T>.lower_bound(first, last: TIterator<T>; value: T): TIterator<T>;
var
  it: TIterator<T>;
  count, step: integer;
begin
  count := first.handle.idistance(first,last);
  while (count>0) do
  begin
    it := first;
    step:=count div 2;
    inc_it(it, step);
    if TComparer<T>.Default.Compare(it.handle.iget(it), value) < 0 then
    begin
      it.handle.iadvance(it);
      first := it;
      count := count - (step + 1);
    end
    else count := step;
  end;
  exit(first);
end;

class function TIterAlgorithms<T>.lower_bound(first, last: TIterator<T>; value: T; comp: TCompare<T>): TIterator<T>;
var
  it: TIterator<T>;
  count, step: integer;
begin
  count := first.handle.idistance(first,last);
  while (count>0) do
  begin
    it := first;
    step:=count div 2;
    inc_it(it, step);
    if comp(it.handle.iget(it), value) < 0 then                   // or: if (comp(*it,value)), for the comp version
    begin
      it.handle.iadvance(it);
      first := it;
      count := count - (step + 1);
    end
    else count := step;
  end;
  exit(first);
end;

class function TIterAlgorithms<T>.next_permutation(first, last: TIterator<T>): boolean;
var
  i, ii, j: TIterator<T>;
begin
  if (first.handle.iequals(first, last)) then exit(false);
  i := first;
  i.handle.iadvance(i);
  if (i.handle.iequals(i, last)) then
    exit(false);
  i := last;
  i.handle.iretreat(i);

  while true do
  begin
    ii := i;
    i.handle.iretreat(i);
    if TComparer<T>.Default.Compare(i.handle.iget(i), ii.handle.iget(ii)) < 0 then
    begin
      j := last;
      j.handle.iretreat(j);
      while (not(TComparer<T>.Default.Compare(i.handle.iget(i), j.handle.iget(j)) < 0)) do
      begin
        j.handle.iretreat(j);
      end;
      iter_swap(i, j);
      reverse(ii, last);
      exit(true);
    end;
    if (i.handle.iequals(i, first)) then
    begin
      reverse(first, last);
      exit(false);
    end;
  end;
end;

class function TIterAlgorithms<T>.next_permutation(first, last: TIterator<T>; comp: TCompare<T>): boolean;
var
  i, ii, j: TIterator<T>;
begin
  if (first.handle.iequals(first, last)) then exit(false);
  i := first;
  i.handle.iadvance(i);
  if (i.handle.iequals(i, last)) then
    exit(false);
  i := last;
  i.handle.iretreat(i);

  while true do
  begin
    ii := i;
    i.handle.iretreat(i);
    if comp(i.handle.iget(i), ii.handle.iget(ii)) < 0 then
    begin
      j := last;
      j.handle.iretreat(j);
      while (not(comp(i.handle.iget(i), j.handle.iget(j)) < 0)) do
      begin
        j.handle.iretreat(j);
      end;
      iter_swap(i, j);
      reverse(ii, last);
      exit(true);
    end;
    if (i.handle.iequals(i, first)) then
    begin
      reverse(first, last);
      exit(false);
    end;
  end;
end;

class function TIterAlgorithms<T>.partition(first, last: TIterator<T>; pred: TPredicate<T>): TIterator<T>;
begin
  while true do
  begin
    while (not first.handle.iequals(first, last)) and pred(first.handle.iget(first)) do inc_it(first,1);
    if first.handle.iequals(first, last) then break;
    dec_it(last, 1);
    while (not first.handle.iequals(first, last)) and (not pred(last.handle.iget(last))) do dec_it(last, 1);
    if first.handle.iequals(first, last) then break;
    iter_swap(first, last);
    inc_it(first, 1)
  end;
  exit(first);
end;

class function TIterAlgorithms<T>.prev_permutation(first, last: TIterator<T>): boolean;
var
  i, ii, j: TIterator<T>;
begin
  if (first.handle.iequals(first, last)) then exit(false);
  i := first;
  i.handle.iadvance(i);
  if (i.handle.iequals(i, last)) then
    exit(false);
  i := last;
  i.handle.iretreat(i);

  while true do
  begin
    ii := i;
    i.handle.iretreat(i);
    if TComparer<T>.Default.Compare(ii.handle.iget(ii), i.handle.iget(i)) < 0 then
    begin
      j := last;
      j.handle.iretreat(j);
      while (not(TComparer<T>.Default.Compare(j.handle.iget(j), i.handle.iget(i)) < 0)) do
      begin
        j.handle.iretreat(j);
      end;
      iter_swap(i, j);
      reverse(ii, last);
      exit(true);
    end;
    if (i.handle.iequals(i, first)) then
    begin
      reverse(first, last);
      exit(false);
    end;
  end;
end;

class function TIterAlgorithms<T>.prev_permutation(first, last: TIterator<T>; comp: TCompare<T>): boolean;
var
  i, ii, j: TIterator<T>;
begin
  if (first.handle.iequals(first, last)) then exit(false);
  i := first;
  i.handle.iadvance(i);
  if (i.handle.iequals(i, last)) then
    exit(false);
  i := last;
  i.handle.iretreat(i);

  while true do
  begin
    ii := i;
    i.handle.iretreat(i);
    if comp(ii.handle.iget(ii), i.handle.iget(i)) < 0 then
    begin
      j := last;
      j.handle.iretreat(j);
      while (not(comp(j.handle.iget(j), i.handle.iget(i)) < 0)) do
      begin
        j.handle.iretreat(j);
      end;
      iter_swap(i, j);
      reverse(ii, last);
      exit(true);
    end;
    if (i.handle.iequals(i, first)) then
    begin
      reverse(first, last);
      exit(false);
    end;
  end;
end;

class procedure TIterAlgorithms<T>.random_shuffle(first, last: TIterator<T>);
var
  n: integer;
  tmp1, tmp2: TIterator<T>;
begin
  randomize;
  n := first.handle.idistance(first, last) - 1;
  while n >= 0 do
  begin
    tmp1 := first;
    inc_it(tmp1, n);
    tmp2 := first;
    inc_it(tmp2, random(n + 1));
    iter_swap(tmp1, tmp2);
  end;
end;

class procedure TIterAlgorithms<T>.random_shuffle(first, last: TIterator<T>; rand: TRandomNumberGenerator);
var
  n: integer;
  tmp1, tmp2: TIterator<T>;
begin
  randomize;
  n := first.handle.idistance(first, last) - 1;
  while n >= 0 do
  begin
    tmp1 := first;
    inc_it(tmp1, n);
    tmp2 := first;
    inc_it(tmp2, rand(n + 1));
    iter_swap(tmp1, tmp2);
  end;
end;

class procedure TIterAlgorithms<T>.reverse(first, last: TIterator<T>);
begin
  while not first.handle.iequals(first, last) do
  begin
    dec_it(last, 1);
    if first.handle.iequals(first, last) then break;
    iter_swap(first, last);
    inc_it(first, 1);
  end;
end;

class procedure TIterAlgorithms<T>.rotate(first, middle, last: TIterator<T>);
var
  next: TIterator<T>;
begin
  next := middle;
  while not (first.handle.iequals(first, next)) do
  begin
    iter_swap(first, next);
    first.handle.iadvance(first);
    next.handle.iadvance(next);
    if (next.handle.iequals(next, last)) then next := middle
    else if (first.handle.iequals(first, middle)) then middle := next;
  end;
end;

class function TIterAlgorithms<T>.max_element(first, last: TIterator<T>): TIterator<T>;
var
  largest: TIterator<T>;
begin
  largest := first;
  if first.handle.iequals(first, last) then exit(first);
  while not first.handle.iequals(first, last) do
  begin
    (* if first > largest then *)
    if TComparer<T>.Default.Compare(first.handle.iget(first), largest.handle.iget(largest)) > 0 then
    begin
      largest := first;
    end;
    first.handle.iadvance(first);
  end;
  exit(largest);
end;

class function TIterAlgorithms<T>.merge(first1, last1, first2, last2, res: TIterator<T>): TIterator<T>;
begin
  while true do
  begin
    (* if first2 < first1 *)
    if TComparer<T>.Default.Compare(first2.handle.iget(first2), first1.handle.iget(first1)) < 0 then
    begin
      res.handle.iput(res, first2.handle.iget(first2));
      first2.handle.iadvance(first2);
    end
    else begin
      res.handle.iput(res, first1.handle.iget(first1));
      first1.handle.iadvance(first1);
    end;
    res.handle.iadvance(res);
    if first1.handle.iequals(first1, last1) then exit(copy(first2, last2, res));
    if first2.handle.iequals(first2, last2) then exit(copy(first1, last1, res));
  end;
end;

class function TIterAlgorithms<T>.min_element(first, last: TIterator<T>): TIterator<T>;
var
  lowest: TIterator<T>;
begin
  lowest := first;
  if first.handle.iequals(first, last) then exit(first);
  while not first.handle.iequals(first, last) do
  begin
    (* if first < lowest then *)
    if TComparer<T>.Default.Compare(first.handle.iget(first), lowest.handle.iget(lowest)) < 0 then
    begin
      lowest := first;
    end;
    first.handle.iadvance(first);
  end;
  exit(lowest);
end;

class function TIterAlgorithms<T>.mismatch(first1, last1, first2: TIterator<T>): TPair<TIterator<T>, TIterator<T>>;
begin
  while (not first1.handle.iequals(first1, last1)) and
    (TComparer<T>.Default.Compare(first1.handle.iget(first1), first2.handle.iget(first2)) = 0) do
  begin
    first1.handle.iadvance(first1);
    first2.handle.iadvance(first2);
  end;
  Result := TPair<TIterator<T>, TIterator<T>>.Create(first1, first2);
end;

class function TIterAlgorithms<T>.mismatch(first1, last1, first2: TIterator<T>; pred: TBinaryPredicate<T, T>): TPair<TIterator<T>, TIterator<T>>;
begin
  while (not first1.handle.iequals(first1, last1)) and
    (pred(first1.handle.iget(first1), first2.handle.iget(first2))) do
  begin
    first1.handle.iadvance(first1);
    first2.handle.iadvance(first2);
  end;
  Result := TPair<TIterator<T>, TIterator<T>>.Create(first1, first2);
end;

class procedure TIterAlgorithms<T>._sort(first, last: TIterator<T>; l, r: integer);
var
  i, j, x: integer;
  xit, iit, jit: TIterator<T>;
  tmp, xobj: T;

begin
  i := l;
  j := r;
  x := ((i + j) div 2);
  xit := first; inc_it(xit, x);
  xobj := xit.handle.iget(xit);
  iit := first; inc_it(iit, i);
  jit := first; inc_it(jit, j);
  repeat
    (* items[i] < x *)
    while (TComparer<T>.Default.compare(iit.handle.iget(iit), xobj) < 0) do
    begin
      inc(i);
      iit.handle.iadvance(iit);
    end;
    (* items[j] > x *)
    while (TComparer<T>.Default.compare(xobj, jit.handle.iget(jit)) < 0) do
    begin
      dec(j);
      jit.handle.iretreat(jit);
    end;
    if i <= j then
    begin
      tmp := iit.handle.iget(iit);
      iit.handle.iput(iit, jit.handle.iget(jit));
      jit.handle.iput(jit, tmp);
      inc(i);
      iit.handle.iadvance(iit);
      dec(j);
      jit.handle.iretreat(jit);
    end;
  until i>j;
  if l < j then _sort(first, last, l,j);
  if i < r then _sort(first, last, i,r);
end;

class procedure TIterAlgorithms<T>.sort(first, last: TIterator<T>);
begin
  _sort(first, last, 0, first.handle.idistance(first, last) - 1);
end;


class procedure TIterAlgorithms<T>._sort(first, last: TIterator<T>; l, r: integer; comp: TCompare<T>);
var
  i, j, x: integer;
  xit, iit, jit: TIterator<T>;
  tmp, xobj: T;

begin
  i := l;
  j := r;
  x := ((i + j) div 2);
  xit := first; inc_it(xit, x);
  xobj := xit.handle.iget(xit);
  iit := first; inc_it(iit, i);
  jit := first; inc_it(jit, j);
  repeat
    (* items[i] < x *)
    while (comp(iit.handle.iget(iit), xobj) < 0) do
    begin
      inc(i);
      iit.handle.iadvance(iit);
    end;
    (* items[j] > x *)
    while (comp(xobj, jit.handle.iget(jit)) < 0) do
    begin
      dec(j);
      jit.handle.iretreat(jit);
    end;
    if i <= j then
    begin
      tmp := iit.handle.iget(iit);
      iit.handle.iput(iit, jit.handle.iget(jit));
      jit.handle.iput(jit, tmp);
      inc(i);
      iit.handle.iadvance(iit);
      dec(j);
      jit.handle.iretreat(jit);
    end;
  until i>j;
  if l < j then _sort(first, last, l,j);
  if i < r then _sort(first, last, i,r);
end;

class procedure TIterAlgorithms<T>.sort(first, last: TIterator<T>; comp: TCompare<T>);
begin
  _sort(first, last, 0, first.handle.idistance(first, last) - 1, comp);
end;

class procedure TIterAlgorithms<T1, T2>.for_each(first, last: TIterator<T1, T2>;
  f: Func<T1, T2>);
begin
  { TODO: for_each for TIterAlgorithm<T1, T2> }
end;
{$ENDREGION}

{$REGION 'TMinMax<T>'}

class function TMinMax<T>.min(data: array of T): T;
var
  i: integer;
  tmp: T;
  comparer: IComparer<T>;
begin
  comparer := TComparer<T>.Default;
  tmp := data[low(data)];
  for i := low(data) + 1 to high(data) do
    if comparer.Compare(data[i], tmp) < 0 then
      tmp := data[i];
  result := tmp;
end;

class function TMinMax<T>.min(a, b: T): T;
begin
  if TComparer<T>.Default.Compare(a, b) < 0 then exit(a) else exit(b);
end;

class function TMinMax<T>.max(data: array of T): T;
var
  i: integer;
  tmp: T;
  comparer: IComparer<T>;
begin
  comparer := TComparer<T>.Default;
  tmp := data[low(data)];
  for i := low(data) + 1 to high(data) do
    if comparer.Compare(data[i], tmp) > 0 then
      tmp := data[i];
  result := tmp;
end;

class function TMinMax<T>.max(a, b: T): T;
begin
  if TComparer<T>.Default.Compare(a, b) > 0 then exit(a) else exit(b);
end;

{$ENDREGION}

{$REGION 'String Algorithm'}

function upcase(c: char): char;
begin
  if (c >= 'a') and (c <= 'z') then
    result := chr(ord(c) + (ord('A') - ord('a')))
  else
    result := c;
end;

function lowcase(c: char): char;
begin
  if (c >= 'A') and (c <= 'Z') then
    result := chr(ord(c) - (ord('A') - ord('a')))
  else
    result := c;
end;

function to_upper(s: string): string;
var
  i: integer;
  r: string;
begin
  r := '';
  for i := 1 to length(s) do
    r := r + upcase(s[i]);
  result := r;
end;

function to_lower(s: string): string;
var
  i: integer;
  r: string;
begin
  r := '';
  for i := 1 to length(s) do
    r := r + lowcase(s[i]);
  result := r;
end;

function is_alpha(c: char): boolean;
begin
  result := ((c >= 'a') and (c <= 'z')) or ((c >= 'A') and (c <= 'Z'));
end;

function is_digit(c: char): boolean;
begin
  result := ((c >= '0') and (c <= '9'));
end;

function is_alnum(c: char): boolean;
begin
  result := is_alpha(c) or is_digit(c);
end;

function is_lower(c: char): boolean;
begin
  result := ((c >= 'a') and (c <= 'z'));
end;

function is_upper(c: char): boolean;
begin
  result := ((c >= 'A') and (c <= 'Z'));
end;

{$ENDREGION}

end.
