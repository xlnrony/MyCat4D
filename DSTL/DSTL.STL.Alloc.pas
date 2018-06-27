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
unit DSTL.STL.Alloc;

interface
uses
  Windows, DSTL.Types, DSTL.Exception;

type
  IAllocator<T> = interface(IInterface)
    function allocate(size: integer): pointer;
    procedure deallocate(p: pointer); overload;
    procedure deallocate(p: pointer; size: integer); overload;
    procedure reallocate(p: pointer; size: TSizeType);
  end;

  TAllocator<T> = class(TInterfacedObject, IAllocator<T>)
    function allocate(size: integer): pointer;
    procedure deallocate(p: pointer); overload;
    procedure deallocate(p: pointer; size: integer); overload;
    procedure reallocate(p: pointer; size: TSizeType);
  end;

implementation

function TAllocator<T>.allocate(size: integer): pointer;
begin
  try
    GetMem(Result, size);
  except
    dstl_raise_exception(E_OUT_OF_MEMORY);
  end;
end;

procedure TAllocator<T>.deallocate(p: pointer);
begin
  FreeMem(p);
end;

procedure TAllocator<T>.deallocate(p: pointer; size: integer);
begin
  FreeMem(p, size);
end;

procedure TAllocator<T>.reallocate(p: pointer; size: TSizeType);
begin
  try
    ReallocMem(p, size);
  except
    dstl_raise_exception(E_OUT_OF_MEMORY);
  end;
end;

end.
