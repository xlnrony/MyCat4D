(*
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
// ���ֻ���Double���͵�����
// Create by HouSisong, 2006.10.09
//------------------------------------------------------------------------------

unit DGL_Double;

interface
uses
  SysUtils;
{$I DGLCfg.inc_h} 
type
  _ValueType   = Double;

const
  _NULL_Value:Double=0;
  function _HashValue(const Key: _ValueType):Cardinal;{$ifdef _DGL_Inline} inline; {$endif}//Hash����

{$I DGL.inc_h}

type
  TDoubleAlgorithms       = _TAlgorithms;

  IDoubleIterator         = _IIterator;
  IDoubleContainer        = _IContainer;
  IDoubleSerialContainer  = _ISerialContainer;
  IDoubleVector           = _IVector;
  IDoubleList             = _IList;
  IDoubleDeque            = _IDeque;
  IDoubleStack            = _IStack;
  IDoubleQueue            = _IQueue;
  IDoublePriorityQueue    = _IPriorityQueue;

  TDoubleVector           = _TVector;
  TDoubleDeque            = _TDeque;
  TDoubleList             = _TList;
  IVectorIterator   = _IVectorIterator; //�ٶȱ�_IIterator�Կ�һ��:)
  IDequeIterator    = _IDequeIterator;  //�ٶȱ�_IIterator�Կ�һ��:)
  IListIterator     = _IListIterator;   //�ٶȱ�_IIterator�Կ�һ��:)
  TDoubleStack            = _TStack;
  TDoubleQueue            = _TQueue;
  TDoublePriorityQueue    = _TPriorityQueue;


  IDoubleMapIterator  = _IMapIterator;
  IDoubleMap          = _IMap;
  IDoubleMultiMap     = _IMultiMap;

  TDoubleSet           = _TSet;
  TDoubleMultiSet      = _TMultiSet;
  TDoubleMap           = _TMap;
  TDoubleMultiMap      = _TMultiMap;
  TDoubleHashSet       = _THashSet;
  TDoubleHashMultiSet  = _THashMultiSet;
  TDoubleHashMap       = _THashMap;
  TDoubleHashMultiMap  = _THashMultiMap;

implementation
uses
  HashFunctions;


function _HashValue(const Key :_ValueType):Cardinal; overload;
begin
  result:=HashValue_Double(Key);
end;

{$I DGL.inc_pas}

end.







