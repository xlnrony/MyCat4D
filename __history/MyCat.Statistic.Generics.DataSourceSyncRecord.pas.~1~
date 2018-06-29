unit MyCat.Statistic.Generics.DataSourceSyncRecord;

interface

uses
  System.SysUtils;

// 结构的容器的声明模版

{$I DGLCfg.inc_h}
// public static class Record {
// private Object value;
// private long time;
//
// Record(long time, Object value) {
// this.time = time;
// this.value = value;
// }
// public Object getValue() {
// return this.value;
// }
// public void setValue(Object value) {
// this.value = value;
// }
// public long getTime() {
// return this.time;
// }
// public void setTime(long time) {
// this.time = time;
// }
//
//
// }

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

function _HashValue(const Value: _ValueType): Cardinal;
{$IFDEF _DGL_Inline} inline; {$ENDIF}// Hash函数

{$DEFINE _DGL_Compare}  // 是否需要比较函数，可选
function _IsEqual(const A, B: _ValueType): boolean;
{$IFDEF _DGL_Inline} inline;
{$ENDIF} // result:=(a=b);
function _IsLess(const A, B: _ValueType): boolean;
{$IFDEF _DGL_Inline} inline;
{$ENDIF}  // result:=(a<b); 默认排序准则

{$I DGL.inc_h}

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

  TDataSourceSyncRecordPointerItBox = _TPointerItBox_Obj;

  TDataSourceSyncRecordVector = _TVector;
  IDataSourceSyncRecordVectorIterator = _IVectorIterator; // 速度比_IIterator稍快一点:)
  TDataSourceSyncRecordDeque = _TDeque;
  TDataSourceSyncRecordList = _TList;
  TDataSourceSyncRecordStack = _TStack;
  TDataSourceSyncRecordQueue = _TQueue;
  TDataSourceSyncRecordPriorityQueue = _TPriorityQueue;
  TDataSourceSyncRecordHashSet = _THashSet;
  TDataSourceSyncRecordHashMuitiSet = _THashMultiSet;

  //

  IDataSourceSyncRecordMapIterator = _IMapIterator;
  IDataSourceSyncRecordMap = _IMap;
  IDataSourceSyncRecordMultiMap = _IMultiMap;

  TDataSourceSyncRecordHashMap = _THashMap;
  TDataSourceSyncRecordHashMultiMap = _THashMultiMap;

implementation

{$I DGL.inc_pas}

function _HashValue(const Value: _ValueType): Cardinal;
begin
  Result := Cardinal(Value.FValue) + Cardinal(Value.FTime);
end;

function _IsEqual(const A, B: _ValueType): boolean;
begin
  Result := (A.FValue = B.FValue) and (A.FTime = B.FTime);
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
