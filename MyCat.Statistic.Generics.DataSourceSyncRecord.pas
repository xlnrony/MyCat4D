unit MyCat.Statistic.Generics.DataSourceSyncRecord;

interface

uses
  System.SysUtils;

{$I DGLCfg.inc_h}

type
  TDataSourceSyncRecord = record
  private
    FTime: Int64;
    FValue: TObject;
  public
    constructor Create(Time: Int64; Value: TObject);
    property Time: Int64 read FTime write FTime;
    property Value: TObject read FValue write FValue;
  end;

  _ValueType = TDataSourceSyncRecord;

const
  _NULL_Value: _ValueType = (FTime: (0); FValue: (nil));

{$DEFINE _DGL_NotHashFunction}
{$DEFINE _DGL_Compare}  // 是否需要比较函数，可选
function _IsEqual(const A, B: _ValueType): boolean;
{$IFDEF _DGL_Inline} inline;
{$ENDIF} // result:=(a=b);
function _IsLess(const A, B: _ValueType): boolean;
{$IFDEF _DGL_Inline} inline;
{$ENDIF}  // result:=(a<b); 默认排序准则

{$DEFINE __DGL_KeyType_Is_ValueType}
{$I List.inc_h}

type
  IDataSourceSyncRecordIterator = _IIterator;
  IDataSourceSyncRecordContainer = _IContainer;
  IDataSourceSyncRecordSerialContainer = _ISerialContainer;
  IDataSourceSyncRecordVector = _IVector;
  IDataSourceSyncRecordList = _IList;
  IDataSourceSyncRecordDeque = _IDeque;
  IDataSourceSyncRecordStack = _IStack;
  IDataSourceSyncRecordQueue = _IQueue;
  IDataSourceSyncRecordPriorityQueue = _IPriorityQueue;
  IDataSourceSyncRecordSet = _ISet;
  IDataSourceSyncRecordMultiSet = _IMultiSet;

  TDataSourceSyncRecordList = _TList;

  IDataSourceSyncRecordMapIterator = _IMapIterator;
  IDataSourceSyncRecordMap = _IMap;
  IDataSourceSyncRecordMultiMap = _IMultiMap;

implementation

{$I List.inc_pas}

function _IsEqual(const A, B: _ValueType): boolean;
begin
  Result := (A.FTime = B.FTime) and (A.FValue = B.FValue);
end;

function _IsLess(const A, B: _ValueType): boolean;
begin
  Result := A.FTime < B.FTime;
end;

{ TDataSourceSyncRecord }

constructor TDataSourceSyncRecord.Create(Time: Int64; Value: TObject);
begin
  FTime := Time;
  FValue := Value;
end;

end.
