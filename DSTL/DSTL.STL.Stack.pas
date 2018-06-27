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
unit DSTL.STL.Stack;

interface

uses
  DSTL.STL.Sequence, DSTL.STL.Deque;

type
  TStack<T> = class
  protected
    stack: TSequence<T>;
  public
    constructor Create; overload;
    constructor Create(container: TSequence<T>); overload;
    function empty: boolean;
    function size: integer;
    function top: T;
    procedure push(x: T);
    procedure pop;
  end;

implementation

constructor TStack<T>.Create;
begin
  stack := TDeque<T>.Create;  (* if no container class is specified for
                                      a particular stack class, the standard
                                      container class template deque is used  *)
end;

constructor TStack<T>.Create(container: TSequence<T>);
begin
  stack := container.Create;
end;

function TStack<T>.empty: boolean;
begin
  Result := stack.empty;
end;

function TStack<T>.size: integer;
begin
  Result := stack.size;
end;

function TStack<T>.top: T;
begin
  Result := stack.back;
end;

procedure TStack<T>.push(x: T);
begin
  stack.push_back(x);
end;

procedure TStack<T>.pop;
begin
  stack.pop_back;
end;

end.
