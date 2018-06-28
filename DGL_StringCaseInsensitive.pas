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
// ���ֻ��Ĵ�Сд�����е�String���͵�����  
// Create by HouSisong, 2005.10.13
//------------------------------------------------------------------------------

unit DGL_StringCaseInsensitive;

interface
uses
  SysUtils;
{$I DGLCfg.inc_h} 
const
  _NULL_Value:string='';
type
  _ValueType   = string; //��Сд�����е�String

  function _HashValue(const Key: _ValueType):Cardinal;{$ifdef _DGL_Inline} inline; {$endif}//Hash����
  {$define _DGL_Compare}  //�ȽϺ���
  function _IsEqual(const a,b :_ValueType):boolean;{$ifdef _DGL_Inline} inline; {$endif} //result:=(a=b);
  function _IsLess(const a,b :_ValueType):boolean; {$ifdef _DGL_Inline} inline; {$endif} //result:=(a<b); Ĭ������׼��

{$I DGL.inc_h}

type
  TCIStrAlgorithms       = _TAlgorithms;

  ICIStrIterator         = _IIterator;
  ICIStrContainer        = _IContainer;
  ICIStrSerialContainer  = _ISerialContainer;
  ICIStrVector           = _IVector;
  ICIStrList             = _IList;
  ICIStrDeque            = _IDeque;
  ICIStrStack            = _IStack;
  ICIStrQueue            = _IQueue;
  ICIStrPriorityQueue    = _IPriorityQueue;

  TCIStrVector           = _TVector;
  TCIStrDeque            = _TDeque;
  TCIStrList             = _TList;
  ICIStrVectorIterator   = _IVectorIterator; //�ٶȱ�_IIterator�Կ�һ��:)
  ICIStrDequeIterator    = _IDequeIterator;  //�ٶȱ�_IIterator�Կ�һ��:)
  ICIStrListIterator     = _IListIterator;   //�ٶȱ�_IIterator�Կ�һ��:)
  TCIStrStack            = _TStack;
  TCIStrQueue            = _TQueue;
  TCIStrPriorityQueue    = _TPriorityQueue;

  //

  ICIStrMapIterator  = _IMapIterator;
  ICIStrMap          = _IMap;
  ICIStrMultiMap     = _IMultiMap;

  TCIStrSet           = _TSet;
  TCIStrMultiSet      = _TMultiSet;
  TCIStrMap           = _TMap;
  TCIStrMultiMap      = _TMultiMap;
  TCIStrHashSet       = _THashSet;
  TCIStrHashMultiSet  = _THashMultiSet;
  TCIStrHashMap       = _THashMap;
  TCIStrHashMultiMap  = _THashMultiMap;

implementation
uses
  HashFunctions;

function _HashValue(const Key :_ValueType):Cardinal; overload;
begin
  result:=HashValue_StrCaseInsensitive(Key);
end;

function _IsEqual(const a,b :_ValueType):boolean; //result:=(a=b);
begin
  result:=IsEqual_StrCaseInsensitive(a,b);
end;

function _IsLess(const a,b :_ValueType):boolean;  //result:=(a<b); Ĭ������׼��
begin
  result:=IsLess_StrCaseInsensitive(a,b);
end;

{$I DGL.inc_pas}

end.

