unit MyCat.BackEnd.Generics.BackEndConnection;

interface

uses
  System.SysUtils, MyCat.BackEnd.Interfaces;

{$I DGLCfg.inc_h}

type
  _ValueType = IBackEndConnection;

const
  _NULL_Value: _ValueType = nil;
{$DEFINE _DGL_NotHashFunction}
{$DEFINE  _DGL_Compare}
function _IsEqual(const a, b: _ValueType): boolean;
// {$ifdef _DGL_Inline} inline; {$endif} //result:=(a=b);
function _IsLess(const a, b: _ValueType): boolean; {$IFDEF _DGL_Inline} inline;
{$ENDIF}  // result:=(a<b); Ĭ������׼��

{$I DGL.inc_h}

type
  TBackEndConnectionAlgorithms = _TAlgorithms;

  IBackEndConnectionIterator = _IIterator;
  IBackEndConnectionContainer = _IContainer;
  IBackEndConnectionSerialContainer = _ISerialContainer;
  IBackEndConnectionVector = _IVector;
  IBackEndConnectionList = _IList;
  IBackEndConnectionDeque = _IDeque;
  IBackEndConnectionStack = _IStack;
  IBackEndConnectionQueue = _IQueue;
  IBackEndConnectionPriorityQueue = _IPriorityQueue;
  IBackEndConnectionSet = _ISet;
  IBackEndConnectionMultiSet = _IMultiSet;

  TBackEndConnectionVector = _TVector;
  TBackEndConnectionDeque = _TDeque;
  TBackEndConnectionList = _TList;
  IBackEndConnectionVectorIterator = _IVectorIterator; // �ٶȱ�_IIterator�Կ�һ��:)
  IBackEndConnectionDequeIterator = _IDequeIterator; // �ٶȱ�_IIterator�Կ�һ��:)
  IBackEndConnectionListIterator = _IListIterator; // �ٶȱ�_IIterator�Կ�һ��:)
  TBackEndConnectionStack = _TStack;
  TBackEndConnectionQueue = _TQueue;
  TBackEndConnectionPriorityQueue = _TPriorityQueue;

  IBackEndConnectionMapIterator = _IMapIterator;
  IBackEndConnectionMap = _IMap;
  IBackEndConnectionMultiMap = _IMultiMap;

  TBackEndConnectionSet = _TSet;
  TBackEndConnectionMultiSet = _TMultiSet;
  TBackEndConnectionMap = _TMap;
  TBackEndConnectionMultiMap = _TMultiMap;
  TBackEndConnectionHashSet = _THashSet;
  TBackEndConnectionHashMultiSet = _THashMultiSet;
  TBackEndConnectionHashMap = _THashMap;
  TBackEndConnectionHashMultiMap = _THashMultiMap;

implementation

uses
  HashFunctions;

function _IsEqual(const a, b: _ValueType): boolean;
begin
  result := (a = b);
end;

function _IsLess(const a, b: _ValueType): boolean;
begin
  result := (Cardinal(a) < Cardinal(b));
end;

{$I DGL.inc_pas}

end.