unit System.Generics.Collections.ThreadSafe;

interface

uses
  System.Generics.Collections;

type
  TThreadDictionary<TKey, TValue> = class
  private
    FDictionary: TDictionary<TKey, TValue>;
    FLock: TObject;

    procedure Lock; inline;
    procedure Unlock; inline;

    function GetItem(const Key: TKey): TValue; inline;
    procedure SetItem(const Key: TKey; const Value: TValue); inline;
  public
    procedure Add(const Key: TKey; const Value: TValue); inline;
    procedure AddOrSetValue(const Key: TKey; const Value: TValue); inline;
    procedure Remove(const Key: TKey); inline;
    procedure Clear; inline;

    // vvv Non-blocking methods vvv
    function TryGetValue(const Key: TKey; out Value: TValue): Boolean; inline;
    function ContainsKey(const Key: TKey): Boolean; inline;
    function ContainsValue(const Value: TValue): Boolean; inline;
    function Count: Integer; inline;

    property Items[const Key: TKey]: TValue read GetItem write SetItem; default;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TThreadDictionary<TKey, TValue> }

procedure TThreadDictionary<TKey, TValue>.Add(const Key: TKey;
  const Value: TValue);
begin
  Lock;
  try
    FDictionary.Add(Key, Value);
  finally
    Unlock;
  end;
end;

procedure TThreadDictionary<TKey, TValue>.AddOrSetValue(const Key: TKey;
  const Value: TValue);
begin
  Lock;
  try
    FDictionary.AddOrSetValue(Key, Value);
  finally
    Unlock;
  end;
end;

procedure TThreadDictionary<TKey, TValue>.Clear;
begin
  Lock;
  try
    FDictionary.Clear;
  finally
    Unlock;
  end;
end;

function TThreadDictionary<TKey, TValue>.ContainsKey(const Key: TKey): Boolean;
begin
  Result := FDictionary.ContainsKey(Key);
end;

function TThreadDictionary<TKey, TValue>.ContainsValue
  (const Value: TValue): Boolean;
begin
  Result := FDictionary.ContainsValue(Value);
end;

function TThreadDictionary<TKey, TValue>.Count: Integer;
begin
  Result := FDictionary.Count;
end;

constructor TThreadDictionary<TKey, TValue>.Create;
begin
  FLock := TObject.Create;
  FDictionary := TDictionary<TKey, TValue>.Create;
end;

destructor TThreadDictionary<TKey, TValue>.Destroy;
begin
  Lock;
  try
    FDictionary.Free;
    inherited Destroy;
  finally
    Unlock;
    FLock.Free;
  end;
end;

function TThreadDictionary<TKey, TValue>.GetItem(const Key: TKey): TValue;
begin
  Result := FDictionary[Key];
end;

procedure TThreadDictionary<TKey, TValue>.Lock;
begin
  TMonitor.Enter(FLock);
end;

procedure TThreadDictionary<TKey, TValue>.Remove(const Key: TKey);
begin
  Lock;
  try
    FDictionary.Remove(Key);
  finally
    Unlock;
  end;
end;

procedure TThreadDictionary<TKey, TValue>.SetItem(const Key: TKey;
  const Value: TValue);
begin
  Lock;
  try
    FDictionary[Key] := Value;
  finally
    Unlock;
  end;
end;

function TThreadDictionary<TKey, TValue>.TryGetValue(const Key: TKey;
  out Value: TValue): Boolean;
begin
  Result := FDictionary.TryGetValue(Key, Value)
end;

procedure TThreadDictionary<TKey, TValue>.Unlock;
begin
  TMonitor.Exit(FLock);
end;

end.
