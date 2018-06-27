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
unit DSTL.STL.Queues;

interface

uses
  DSTL.STL.Sequence, DSTL.STL.Deque, DSTL.Algorithm.Heap;

type
  TQueue<T> = class
  protected
    FQueue: TSequence<T>;
  public
    constructor Create; overload;
    constructor Create(container: TSequence<T>); overload;
    function Empty: Boolean;
    function Size: Integer;
    function Front: T;
    function Back: T;
    function Top: T;
    procedure Push(X: T);
    procedure Pop;
    function Remove(const Obj: T): Boolean;
  end;

  TThreadedQueue<T> = class
  protected
    FLock: TObject;
    FQueue: TQueue<T>;

    procedure Lock; inline;
    procedure Unlock; inline;
  public
    constructor Create; overload;
    constructor Create(container: TSequence<T>); overload;
    destructor Destroy; override;
    function Empty: Boolean;
    function Size: Integer;
    function Front: T;
    function Back: T;
    function Top: T;
    procedure Push(X: T);
    procedure Pop;
    function Remove(const Obj: T): Boolean;
  end;

  TPriorityQueue<T> = class
  protected
    FQueue: TSequence<T>;
  public
    constructor Create; overload;
    constructor Create(container: TSequence<T>); overload;
    function Empty: Boolean;
    function Size: Integer;
    function Front: T;
    function Back: T;
    function Top: T;
    procedure Push(X: T);
    procedure Pop;
  end;

implementation

constructor TQueue<T>.Create;
begin
  FQueue := TDeque<T>.Create;
end;

constructor TQueue<T>.Create(container: TSequence<T>);
begin
  FQueue := container.Create;
end;

function TQueue<T>.Empty: Boolean;
begin
  Result := FQueue.Empty;
end;

function TQueue<T>.Size: Integer;
begin
  Result := FQueue.Size;
end;

function TQueue<T>.Front: T;
begin
  Result := FQueue.Front;
end;

function TQueue<T>.Back: T;
begin
  Result := FQueue.Back;
end;

function TQueue<T>.Top: T;
begin
  Result := FQueue.Front;
end;

procedure TQueue<T>.Push(X: T);
begin
  FQueue.push_back(X);
end;

function TQueue<T>.Remove(const Obj: T): Boolean;
begin
  Result := FQueue.Remove(Obj);
end;

procedure TQueue<T>.Pop;
begin
  FQueue.pop_front;
end;

constructor TPriorityQueue<T>.Create;
begin
  FQueue := TDeque<T>.Create;
end;

constructor TPriorityQueue<T>.Create(container: TSequence<T>);
begin
  FQueue := container.Create;
end;

function TPriorityQueue<T>.Empty: Boolean;
begin
  Result := FQueue.Empty;
end;

function TPriorityQueue<T>.Size: Integer;
begin
  Result := FQueue.Size;
end;

function TPriorityQueue<T>.Front: T;
begin
  Result := FQueue.Front;
end;

function TPriorityQueue<T>.Back: T;
begin
  Result := FQueue.Back;
end;

function TPriorityQueue<T>.Top: T;
begin
  Result := FQueue.Front;
end;

procedure TPriorityQueue<T>.Push(X: T);
begin
  FQueue.push_back(X);
  THeapAlgorithms<T>.push_heap(FQueue.start, FQueue.finish);
end;

procedure TPriorityQueue<T>.Pop;
begin
  THeapAlgorithms<T>.pop_heap(FQueue.start, FQueue.finish);
  FQueue.pop_back;
end;

{ TThreadedQueue<T> }

function TThreadedQueue<T>.Back: T;
begin
  Lock;
  try
    Result := FQueue.Back;
  finally
    Unlock;
  end;
end;

constructor TThreadedQueue<T>.Create;
begin
  FLock := TObject.Create;
  FQueue := TQueue<T>.Create;
end;

constructor TThreadedQueue<T>.Create(container: TSequence<T>);
begin
  FLock := TObject.Create;
  FQueue := TQueue<T>.Create(container);
end;

destructor TThreadedQueue<T>.Destroy;
begin
  Lock;
  try
    FQueue.Free;
    inherited Destroy;
  finally
    Unlock;
    FLock.Free;
  end;
end;

function TThreadedQueue<T>.Empty: Boolean;
begin
  Lock;
  try
    Result := FQueue.Empty;
  finally
    Unlock;
  end;
end;

function TThreadedQueue<T>.Front: T;
begin
  Lock;
  try
    Result := FQueue.Front;
  finally
    Unlock;
  end;
end;

procedure TThreadedQueue<T>.Lock;
begin
  TMonitor.Enter(FLock);
end;

procedure TThreadedQueue<T>.Pop;
begin
  Lock;
  try
    FQueue.Pop;
  finally
    Unlock;
  end;
end;

procedure TThreadedQueue<T>.Push(X: T);
begin
  Lock;
  try
    FQueue.Push(X);
  finally
    Unlock;
  end;
end;

function TThreadedQueue<T>.Remove(const Obj: T): Boolean;
begin
  Lock;
  try
    Result := FQueue.Remove(Obj);
  finally
    Unlock;
  end;
end;

function TThreadedQueue<T>.Size: Integer;
begin
  Lock;
  try
    Result := FQueue.Size;
  finally
    Unlock;
  end;
end;

function TThreadedQueue<T>.Top: T;
begin
  Lock;
  try
    Result := FQueue.Top;
  finally
    Unlock;
  end;
end;

procedure TThreadedQueue<T>.Unlock;
begin
  TMonitor.Exit(FLock);
end;

end.
