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
unit DSTL.STL.Bitset;

interface

uses StrUtils;

const
  DefaultSize = 8;

type
  TBit = 0 .. 1;
  TArrBit = array [0 .. MaxInt div SizeOf(TBit) - 1] of TBit;
  PArrBit = ^TArrBit;

  TBitSet = record
    bits: PArrBit;
    len: integer;

    constructor Create(s: integer); overload;
    constructor Create(str: string; index: integer; count: integer); overload;
    function any: boolean;
    function count: integer;
    procedure flip; overload;
    procedure flip(position: integer); overload;
    function none: boolean;
    procedure reset;
    procedure set_bit; overload;
    procedure set_bit(position: integer; val: integer = 1); overload;
    function size: integer;
    function test(position: integer): TBit;
    function to_string: string;
    function to_longint: longint;

    class operator Equal(a, b: TBitSet): boolean;
    class operator NotEqual(a, b: TBitSet): boolean;
    class operator BitwiseAnd(a, b: TBitSet): TBitSet;
    class operator BitwiseOr(a, b: TBitSet): TBitSet;
    class operator BitwiseXor(a, b: TBitSet): TBitSet;
    class operator LeftShift(a: TBitSet; b: integer): TBitSet;
    class operator RightShift(a: TBitSet; b: integer): TBitSet;
  end;

implementation

constructor TBitSet.Create(s: integer);
begin
  GetMem(bits, s * SizeOf(TBit));
  Self.len := s;
end;

constructor TBitSet.Create(str: string; index: integer; count: integer);
var
  s: string;
  i: integer;
begin
  s := copy(str, index, count);
  len := length(s);
  GetMem(bits, len * SizeOf(TBit));
  for i := 1 to length(s) do
  begin
    case s[i] of
      '0':
        bits[i - 1] := 0;
      '1':
        bits[i - 1] := 1;
    end;
  end;
end;

function TBitSet.any: boolean;
var
  i: integer;
begin
  Result := false;
  for i := 0 to Self.len - 1 do
    if bits[i] = 1 then
    begin
      Result := true;
      break;
    end;
end;

function TBitSet.count: integer;
var
  i: integer;
  cnt: integer;
begin
  cnt := 0;
  for i := 0 to Self.len - 1 do
    if bits[i] = 1 then
    begin
      inc(cnt);
    end;
  Result := cnt;
end;

procedure TBitSet.flip;
var
  i: integer;
begin
  for i := 0 to Self.len - 1 do
    flip(i);
end;

procedure TBitSet.flip(position: integer);
begin
  Self.bits[position] := 1 - Self.bits[position];
end;

function TBitSet.none: boolean;
var
  i: integer;
begin
  Result := true;
  for i := 0 to Self.len - 1 do
    if bits[i] = 1 then
    begin
      Result := false;
      break;
    end;
end;

procedure TBitSet.reset;
var
  i: integer;
begin
  for i := 0 to Self.len - 1 do
    bits[i] := 0;
end;

procedure TBitSet.set_bit;
var
  i: integer;
begin
  for i := 0 to Self.len - 1 do
    bits[i] := 1;
end;

procedure TBitSet.set_bit(position: integer; val: integer = 1);
begin
  Self.bits[position] := val;
end;

function TBitSet.size;
begin
  Result := Self.len;
end;

function TBitSet.test(position: integer): TBit;
begin
  Result := Self.bits[position];
end;

function TBitSet.to_string: string;
var
  i: integer;
  s: string;
begin
  s := '';
  for i := 0 to len - 1 do
    case bits[i] of
      0:
        s := s + '0';
      1:
        s := s + '1';
    end;
  Result := s;
end;

function TBitSet.to_longint: longint;
  function pow(x, y: integer): longint;
  var
    i: integer;
    l: longint;
  begin
    l := 1;
    for i := 1 to y do
      l := l * x;
    Result := l;
  end;

var
  l: longint;
  i: integer;
  p: integer;
begin
  l := 0;
  p := -1;
  for i := Self.len - 1 downto 0 do
  begin
    inc(p);
    l := l + pow(2, p) * Self.bits[i];
  end;
  Result := l;
end;

class operator TBitSet.Equal(a, b: TBitSet): boolean;
begin
  Result := a.to_longint = b.to_longint;
end;

class operator TBitSet.NotEqual(a, b: TBitSet): boolean;
begin
  Result := a.to_longint <> b.to_longint;
end;

function max(a, b: integer): integer;
begin
  if a > b then
    Result := a
  else
    Result := b;
end;

function min(a, b: integer): integer;
begin
  if a < b then
    Result := a
  else
    Result := b;
end;

class operator TBitSet.BitwiseAnd(a, b: TBitSet): TBitSet;
var
  ai, bi: integer;
  s, s1, s2: string;
begin
  s1 := a.to_string;
  s2 := b.to_string;
  ai := length(s1);
  bi := length(s2);
  s := '';
  while (ai <> 0) and (bi <> 0) do
  begin
    if (s1[ai] = '1') and (s2[bi] = '1') then
      s := '1' + s
    else
      s := '0' + s;
    dec(ai);
    dec(bi);
  end;
  if ai = 0 then
    s := copy(s2, 1, bi) + s
  else if bi = 0 then
    s := copy(s1, 1, ai) + s;
  Result := TBitSet.Create(s, 1, length(s));
end;

class operator TBitSet.BitwiseOr(a, b: TBitSet): TBitSet;
var
  ai, bi: integer;
  s, s1, s2: string;
begin
  s1 := a.to_string;
  s2 := b.to_string;
  ai := length(s1);
  bi := length(s2);
  s := '';
  while (ai <> 0) and (bi <> 0) do
  begin
    if (s1[ai] = '0') and (s2[bi] = '0') then
      s := '0' + s
    else
      s := '1' + s;
    dec(ai);
    dec(bi);
  end;
  if ai = 0 then
    s := copy(s2, 1, bi) + s
  else if bi = 0 then
    s := copy(s1, 1, ai) + s;
  Result := TBitSet.Create(s, 1, length(s));
end;

class operator TBitSet.BitwiseXor(a, b: TBitSet): TBitSet;
var
  ai, bi: integer;
  s, s1, s2: string;
begin
  s1 := a.to_string;
  s2 := b.to_string;
  ai := length(s1);
  bi := length(s2);
  s := '';
  while (ai <> 0) and (bi <> 0) do
  begin
    if (s1[ai] = s2[bi]) then
      s := '0' + s
    else
      s := '1' + s;
    dec(ai);
    dec(bi);
  end;
  if ai = 0 then
    s := copy(s2, 1, bi) + s
  else if bi = 0 then
    s := copy(s1, 1, ai) + s;
  Result := TBitSet.Create(s, 1, length(s));
end;

class operator TBitSet.LeftShift(a: TBitSet; b: integer): TBitSet;
var
  i: integer;
  s: string;
begin
  s := a.to_string;
  for i := 1 to b do
    s := s + '0';
  s := RightStr(s, a.len);
  Result := TBitSet.Create(s, 1, length(s));
end;

class operator TBitSet.RightShift(a: TBitSet; b: integer): TBitSet;
var
  i: integer;
  s: string;
begin
  s := a.to_string;
  for i := 1 to b do
    s := '0' + s;
  s := LeftStr(s, a.len);
  Result := TBitSet.Create(s, 1, length(s));
end;

end.
