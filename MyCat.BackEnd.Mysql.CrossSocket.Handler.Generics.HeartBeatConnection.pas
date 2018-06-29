unit MyCat.BackEnd.Mysql.CrossSocket.Handler.Generics.HeartBeatConnection;

interface

uses
  System.SysUtils, MyCat.Net.CrossSocket.Base;

// �ṹ������������ģ��

{$I DGLCfg.inc_h}

type
  THeartBeatConnection = record
  private
    FTimeOutTimestamp: Int64;
    FConnection: ICrossConnection;
  public
    constructor Create(const Connection: ICrossConnection);
  end;

  _KeyType = Int64;
  _ValueType = THeartBeatConnection;

const
  _NULL_Value: _ValueType = (FTimeOutTimestamp: (0); FConnection: (nil));

{$DEFINE _DGL_NotHashFunction}
{$DEFINE _DGL_Compare}  // �Ƿ���Ҫ�ȽϺ�������ѡ
function _IsEqual(const A, B: _ValueType): boolean;
{$IFDEF _DGL_Inline} inline;
{$ENDIF} // result:=(a=b);
function _IsLess(const A, B: _ValueType): boolean;
{$IFDEF _DGL_Inline} inline;
{$ENDIF}  // result:=(a<b); Ĭ������׼��

{$I Map.inc_h} // "��"ģ��������ļ�
{$I HashMap.inc_h} // "��"ģ��������ļ�

type
  IHeartBeatConnectionIterator = _IIterator;
  IHeartBeatConnectionContainer = _IContainer;
  IHeartBeatConnectionSerialContainer = _ISerialContainer;
  IHeartBeatConnectionVector = _IVector;
  IHeartBeatConnectionList = _IList;
  IHeartBeatConnectionDeque = _IDeque;
  IHeartBeatConnectionStack = _IStack;
  IHeartBeatConnectionQueue = _IQueue;
  IHeartBeatConnectionPriorityQueue = _IPriorityQueue;
  IHeartBeatConnectionSet = _ISet;
  IHeartBeatConnectionMultiSet = _IMultiSet;

  IHeartBeatConnectionMapIterator = _IMapIterator;
  IHeartBeatConnectionMap = _IMap;
  IHeartBeatConnectionMultiMap = _IMultiMap;

  THeartBeatConnectionHashMap = _THashMap;
  THeartBeatConnectionHashMultiMap = _THashMultiMap;

implementation

uses
MyCat.Util;

{$I Map.inc_pas} // "��"ģ���ʵ���ļ�
{$I HashMap.inc_pas} // "��"ģ���ʵ���ļ�

function _IsEqual(const A, B: _ValueType): boolean;
begin
  Result := (A.FTimeOutTimestamp = B.FTimeOutTimestamp) and
    (A.FConnection = B.FConnection);
end;

function _IsLess(const A, B: _ValueType): boolean;
begin
  Result := A.FTimeOutTimestamp < B.FTimeOutTimestamp;
end;

{ THeartBeatConnection }

constructor THeartBeatConnection.Create(const Connection: ICrossConnection);
begin
  FTimeOutTimestamp := TTimeUtil.CurrentTimeMillis + 20 * 1000;
  FConnection := Connection;
end;

end.