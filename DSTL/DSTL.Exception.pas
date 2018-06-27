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
unit DSTL.Exception;

interface

uses SysUtils;

type
  EDSTLException = class(Exception)
  end;

  EDSTLOutOfRangeException = class(EDSTLException)
  end;

  EDSTLInvalidArgException = class(EDSTLException)
  end;

  EDSTLFileNotFoundException = class(EDSTLException)
  end;

  EDSTLOutOfMemoryException = class(EDSTLException)
  end;

  EDSTLOutOfBoundException = class(EDSTLException)
  end;

  EDSTLAllocateException = class(EDSTLException)
  end;

  EDSTLNotImplemented = class(EDSTLException)
  end;

const
  errornr = 7;
  E_OUT_OF_RANGE = $1;
  E_INVALID_ARG = $2;
  E_FILE_NOT_FOUND = $3;
  E_OUT_OF_MEMORY = $4;
  E_OUT_OF_BOUND = $5;
  E_ALLOCATE = $6;
  E_NOT_IMPL = $7;

  exception_msg: array [1 .. errornr] of string = ('Out of range',
    'Invalid argument: %s', 'File ''%s'' not found', 'Out of memory',
    'Out of bound', 'Failed allocating memory', 'Not implemented');

var
  exceptions: array [1 .. errornr] of EDSTLException;

procedure dstl_raise_exception(errno: integer); overload;
procedure dstl_raise_exception(errno: integer; args: array of const); overload;

implementation

procedure dstl_raise_exception(errno: integer);
begin
  raise Exception(exceptions[errno]).Create(exception_msg[errno]);
end;

procedure dstl_raise_exception(errno: integer; args: array of const);
var
  i: integer;
  str: string;
  idx: integer;
begin
  i := 0;
  str := '';
  idx := 0;
  while i <= length(exception_msg[errno]) do
  begin
    inc(i);
    if not(exception_msg[errno, i] = '%') then
      str := str + exception_msg[errno, i]
    else
      inc(i);
    case exception_msg[errno, i] of
      's':
        begin
          if idx > high(args) then
            break;
          str := str + String(args[idx].VString);
          inc(idx);
        end;
    end;
  end;
  raise Exception(exceptions[errno]).Create(str);
end;

initialization

exceptions[1] := EDSTLOutOfRangeException.Create('');
exceptions[2] := EDSTLInvalidArgException.Create('');
exceptions[3] := EDSTLFileNotFoundException.Create('');
exceptions[4] := EDSTLOutOfMemoryException.Create('');
exceptions[5] := EDSTLOutOfBoundException.Create('');
exceptions[6] := EDSTLAllocateException.Create('');

end.
