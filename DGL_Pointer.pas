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
// ���ֻ���Pointer���͵�����
// Create by HouSisong, 2004.09.04
//------------------------------------------------------------------------------

unit DGL_Pointer;

interface
uses
  SysUtils;


{$I DGLCfg.inc_h}
type
  _ValueType   = Pointer;

const
  _NULL_Value:pointer=nil;
  {$define _DGL_NotHashFunction}

  {$define _DGL_Compare}  //�Ƿ���Ҫ�ȽϺ�������ѡ
  function _IsEqual(const a,b :_ValueType):boolean; {$ifdef _DGL_Inline} inline; {$endif}//result:=(a=b);
  function _IsLess(const a,b :_ValueType):boolean; {$ifdef _DGL_Inline} inline; {$endif} //result:=(a<b); Ĭ������׼��

  {$I DGL.inc_h}

type
  TPointerAlgorithms       = _TAlgorithms;

  IPointerIterator         = _IIterator;
  IPointerContainer        = _IContainer;
  IPointerSerialContainer  = _ISerialContainer;
  IPointerVector           = _IVector;
  IPointerList             = _IList;
  IPointerDeque            = _IDeque;
  IPointerStack            = _IStack;
  IPointerQueue            = _IQueue;
  IPointerPriorityQueue    = _IPriorityQueue;
  IPointerSet              = _ISet;
  IPointerMultiSet         = _IMultiSet;

  TPointerVector           = _TVector;
  TPointerDeque            = _TDeque;
  TPointerList             = _TList;
  IPointerVectorIterator   = _IVectorIterator; //�ٶȱ�_IIterator�Կ�һ��:)
  IPointerDequeIterator    = _IDequeIterator;  //�ٶȱ�_IIterator�Կ�һ��:)
  IPointerListIterator     = _IListIterator;   //�ٶȱ�_IIterator�Կ�һ��:)
  TPointerStack            = _TStack;
  TPointerQueue            = _TQueue;
  TPointerPriorityQueue    = _TPriorityQueue;

  //
                                      
  IPointerMapIterator  = _IMapIterator;
  IPointerMap          = _IMap;
  IPointerMultiMap     = _IMultiMap;

  TPointerSet           = _TSet;
  TPointerMultiSet      = _TMultiSet;
  TPointerMap           = _TMap;
  TPointerMultiMap      = _TMultiMap;
  TPointerHashSet       = _THashSet;
  TPointerHashMultiSet  = _THashMultiSet;
  TPointerHashMap       = _THashMap;
  TPointerHashMultiMap  = _THashMultiMap;

implementation

function _IsEqual(const a,b :_ValueType):boolean;
begin
  result:=(a=b);
end;

function _IsLess(const a,b :_ValueType):boolean;
begin
  result:=(Cardinal(a)<Cardinal(b));
end;

{$I DGL.inc_pas}

end.


























