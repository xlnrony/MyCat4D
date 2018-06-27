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
unit DSTL.Utils.StopWatch;

interface
uses
  Windows;

type
  TStopWatch = class
  private
    freq: int64;
    starttime, stoptime: int64;
  public
    constructor Create;
    procedure start;
    procedure stop;
    function elapsedSec: double;
    function elapsedMSec: double;
    function elapsedUSec: double;
  end;

implementation

constructor TStopWatch.Create;
begin
  QueryPerformanceFrequency(freq);
end;

procedure TStopWatch.start;
begin
  QueryPerformanceCounter(starttime);
end;

procedure TStopWatch.stop;
begin
  QueryPerformanceCounter(stoptime);
end;

function TStopWatch.elapsedSec: double;
begin
  Result := (stoptime - starttime) / freq;
end;

function TStopWatch.elapsedMSec: double;
begin
  Result := (stoptime - starttime) / freq * 1000;
end;

function TStopWatch.elapsedUSec: double;
begin
  Result := (stoptime - starttime) / freq * 1000000;
end;

end.
