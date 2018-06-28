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
// ���� ��vector's vector
// Create by HouSisong, 2006.09.30
//------------------------------------------------------------------------------

unit _DGL_IntVectorVector;

interface
uses
  SysUtils,DGL_Integer;
{$I DGLCfg.inc_h} 
type
  _ValueType   = IIntVector;

const
  _NULL_Value:IIntVector=nil;
  function _HashValue(const Key: _ValueType):Cardinal;//Hash����

  {$define  _DGL_Compare}
  function _IsEqual(const a,b :_ValueType):boolean;{$ifdef _DGL_Inline} inline; {$endif} //result:=(a=b);
  function _IsLess(const a,b :_ValueType):boolean;{$ifdef _DGL_Inline} inline; {$endif}  //result:=(a<b); Ĭ������׼��
  {$define _DGL_ObjValue}  //��Ҫ���ֶ����ֵ����
  function  _CreateNew():_ValueType;overload;{$ifdef _DGL_Inline} inline; {$endif}//����
  function  _CopyCreateNew(const Value: _ValueType):_ValueType;overload;{$ifdef _DGL_Inline} inline; {$endif}//��������
  procedure _Assign(DestValue:_ValueType;const SrcValue: _ValueType);{$ifdef _DGL_Inline} inline; {$endif}//��ֵ
  procedure _Free(Value: _ValueType);{$ifdef _DGL_Inline} inline; {$endif}//����

{$I DGL.inc_h}

type
  TIntVAlgorithms       = _TAlgorithms;

  IIntVIterator         = _IIterator;
  IIntVContainer        = _IContainer;
  IIntVSerialContainer  = _ISerialContainer;
  IIntVVector           = _IVector;
  IIntVList             = _IList;
  IIntVDeque            = _IDeque;
  IIntVStack            = _IStack;
  IIntVQueue            = _IQueue;
  IIntVPriorityQueue    = _IPriorityQueue;
  IIntVSet              = _ISet;
  IIntVMultiSet         = _IMultiSet;

  TIntVVector           = _TVector;
  TIntVDeque            = _TDeque;
  TIntVList             = _TList;
  IIntVVectorIterator   = _IVectorIterator; //�ٶȱ�_IIterator�Կ�һ��:)
  IIntVDequeIterator    = _IDequeIterator;  //�ٶȱ�_IIterator�Կ�һ��:)
  IIntVListIterator     = _IListIterator;   //�ٶȱ�_IIterator�Կ�һ��:)
  TIntVStack            = _TStack;
  TIntVQueue            = _TQueue;
  TIntVPriorityQueue    = _TPriorityQueue;

  //

  IIntVMapIterator  = _IMapIterator;
  IIntVMap          = _IMap;
  IIntVMultiMap     = _IMultiMap;

  TIntVSet           = _TSet;
  TIntVMultiSet      = _TMultiSet;
  TIntVMap           = _TMap;
  TIntVMultiMap      = _TMultiMap;
  TIntVHashSet       = _THashSet;
  TIntVHashMultiSet  = _THashMultiSet;
  TIntVHashMap       = _THashMap;
  TIntVHashMultiMap  = _THashMultiMap;

implementation


function _HashValue(const Key :_ValueType):Cardinal; overload;
begin
  result:=Cardinal(Key)*37;
end;

function _IsEqual(const a,b :_ValueType):boolean;
begin
  result:=(a=b);
end;

function _IsLess(const a,b :_ValueType):boolean;
begin
  result:=(Cardinal(a)<Cardinal(b));
end;

function  _CreateNew():_ValueType;overload;//����
begin
  result:=TIntVector.Create();
end;

function  _CopyCreateNew(const Value: _ValueType):_ValueType;overload;//��������
begin
  if Value=nil then
    result:=TIntVector.Create()
  else
    result:=TIntVector.Create(Value.ItBegin,Value.ItEnd);
end;
procedure _Assign(DestValue:_ValueType;const SrcValue: _ValueType);//��ֵ
begin
  DestValue.Assign(SrcValue.ItBegin,SrcValue.ItEnd);
end;

procedure _Free(Value: _ValueType);//����
begin
  Value:=nil;
end;



{$I DGL.inc_pas}

end.







