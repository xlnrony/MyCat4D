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
unit DSTL.STL.Sequence;

interface

uses
  DSTL.Types, DSTL.STL.Iterator, DSTL.Exception;

type
  TSequence<T> = class(TContainer<T>)
    procedure add(const obj: T); override;
    function remove(const obj: T): Boolean; override;
    procedure clear; override;
    function start: TIterator<T>; virtual;
    function finish: TIterator<T>; virtual;
    function rstart: TIterator<T>; virtual;
    function rfinish: TIterator<T>; virtual;
    function front: T; virtual;
    function back: T; virtual;
    function max_size: Integer; virtual;
    function size: Integer; virtual;
    function empty: Boolean; virtual;
    function at(const idx: Integer): T; virtual;
    function pop_front: T; virtual;
    procedure push_front(const obj: T); virtual;
    function pop_back: T; virtual;
    procedure push_back(const obj: T); virtual;
  end;

implementation

{ ******************************************************************************
  *                                                                            *
  *                                TSequence                                   *
  *                                                                            *
  ****************************************************************************** }
procedure TSequence<T>.add(const obj: T);
begin
end;

function TSequence<T>.remove(const obj: T): Boolean;
begin
end;

procedure TSequence<T>.clear;
begin
end;

function TSequence<T>.start: TIterator<T>;
begin
end;

function TSequence<T>.finish: TIterator<T>;
begin
end;

function TSequence<T>.rstart: TIterator<T>;
begin
end;

function TSequence<T>.rfinish: TIterator<T>;
begin
end;

function TSequence<T>.front: T;
begin
end;

function TSequence<T>.back: T;
begin
end;

function TSequence<T>.max_size: Integer;
begin
  result := 0;
end;

function TSequence<T>.size: Integer;
begin
  result := 0;
end;

function TSequence<T>.empty: Boolean;
begin
  result := false;
end;

function TSequence<T>.at(const idx: Integer): T;
begin
end;

function TSequence<T>.pop_front: T;
begin
end;

procedure TSequence<T>.push_front(const obj: T);
begin
end;

function TSequence<T>.pop_back: T;
begin
end;

procedure TSequence<T>.push_back(const obj: T);
begin
end;
(*
  procedure TSequence<T>.insert(Iterator: TIterator<T>; const obj: T);
  begin
  end;

  function TSequence<T>.erase(it: TIterator<T>): TIterator<T>;
  begin

  end;

  function TSequence<T>.erase(_start, _finish: TIterator<T>): TIterator<T>;
  begin

  end;
*)

end.
