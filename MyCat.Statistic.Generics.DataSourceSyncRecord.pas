unit MyCat.Statistic.Generics.DataSourceSyncRecord;

interface

uses
  System.SysUtils;

// �ṹ������������ģ��

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
{$IFDEF _DGL_Inline} inline; {$ENDIF}// Hash����

{$DEFINE _DGL_Compare}  // �Ƿ���Ҫ�ȽϺ�������ѡ
function _IsEqual(const A, B: _ValueType): boolean;
{$IFDEF _DGL_Inline} inline;
{$ENDIF} // result:=(a=b);
function _IsLess(const A, B: _ValueType): boolean;
{$IFDEF _DGL_Inline} inline;
{$ENDIF}  // result:=(a<b); Ĭ������׼��

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
  IDataSourceSyncRecordVectorIterator = _IVectorIterator; // �ٶȱ�_IIterator�Կ�һ��:)
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
