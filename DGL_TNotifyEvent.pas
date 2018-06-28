(*
 * DGL(The Delphi Generic Library)
 *
 * Copyright (c) 2004
 * HouSisong@gmail.com
 *
 * This material is provided "as is", with absolutely no warranty expressed
 * or implied. Any use is at your own risk.
 *
 * Permission to use or copy this software for any purpose is hereby granted
 * without fee, provided the above notices are retained on all copies.
 * Permission to modify the code and to distribute modified code is granted,
 * provided the above notices are retained, and a notice that the code was
 * modified is included with the above copyright notice.
 *
 *)

//------------------------------------------------------------------------------
// ���ֻ���TNotifyEvent���͵�����    
// Create by HouSisong, 2004.11.30
//------------------------------------------------------------------------------

unit DGL_TNotifyEvent;

interface
uses
  SysUtils, Classes;
{$I DGLCfg.inc_h} 
const
  _NULL_Value:TNotifyEvent=nil;
type
  _ValueType   = TNotifyEvent;
  {$define _DGL_ClassFunction_Specific}  //���⴦��

  function _HashValue(const Key: _ValueType):Cardinal;{$ifdef _DGL_Inline} inline; {$endif}//Hash����
  {$define _DGL_Compare}  //�ȽϺ���
  function _IsEqual(const a,b :_ValueType):boolean; {$ifdef _DGL_Inline} inline; {$endif}//result:=(a=b);
  function _IsLess(const a,b :_ValueType):boolean; {$ifdef _DGL_Inline} inline; {$endif} //result:=(a<b); Ĭ������׼��

{$I DGL.inc_h}

type
  TEventAlgorithms       = _TAlgorithms;

  IEventIterator         = _IIterator;
  IEventContainer        = _IContainer;
  IEventSerialContainer  = _ISerialContainer;
  IEventVector           = _IVector;
  IEventList             = _IList;
  IEventDeque            = _IDeque;
  IEventStack            = _IStack;
  IEventQueue            = _IQueue;
  IEventPriorityQueue    = _IPriorityQueue;
  IEventSet              = _ISet;
  IEventMultiSet         = _IMultiSet;

  TEventVector           = _TVector;
  TEventDeque            = _TDeque;
  TEventList             = _TList;
  IEventVectorIterator   = _IVectorIterator; //�ٶȱ�_IIterator�Կ�һ��:)
  IEventDequeIterator    = _IDequeIterator;  //�ٶȱ�_IIterator�Կ�һ��:)
  IEventListIterator     = _IListIterator;   //�ٶȱ�_IIterator�Կ�һ��:)
  TEventStack            = _TStack;
  TEventQueue            = _TQueue;
  TEventPriorityQueue    = _TPriorityQueue;

  //

  IEventMapIterator  = _IMapIterator;
  IEventMap          = _IMap;
  IEventMultiMap     = _IMultiMap;

  TEventSet           = _TSet;
  TEventMultiSet      = _TMultiSet;
  TEventMap           = _TMap;
  TEventMultiMap      = _TMultiMap;
  TEventHashSet       = _THashSet;
  TEventHashMultiSet  = _THashMultiSet;
  TEventHashMap       = _THashMap;
  TEventHashMultiMap  = _THashMultiMap;
  
implementation
uses
  HashFunctions;

{$I DGL.inc_pas}

function _HashValue(const Key :_ValueType):Cardinal; overload;
begin
  result:=HashValue_Int64(PInt64(@@Key)^);
end;

function _IsEqual(const a,b :_ValueType):boolean; //result:=(a=b);
begin
  result:=(PInt64(@@a)^)=PInt64(@@b)^;
end;

function _IsLess(const a,b :_ValueType):boolean;  //result:=(a<b); Ĭ������׼��
begin
  result:=(PInt64(@@a)^)<PInt64(@@b)^;
end;

initialization
  Assert(sizeof(int64)=sizeof(_ValueType));
end.



