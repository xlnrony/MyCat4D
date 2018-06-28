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
//����:TStrIntMap
//���ֻ�String<->integer��map�������������
// Create by HouSisong, 2005.10.13
//------------------------------------------------------------------------------
unit _DGLMap_StringCaseInsensitive_Integer;

interface
uses
  SysUtils;
{$I DGLCfg.inc_h}

type
  _KeyType     = string;  
  _ValueType   = integer;

const
  _NULL_Value:integer=0;
  function _HashValue(const Key: _KeyType):Cardinal;{$ifdef _DGL_Inline} inline; {$endif}//Hash����
  {$define _DGL_Compare_Key}  //�ȽϺ���
  function _IsEqual_Key(const a,b :_KeyType):boolean;{$ifdef _DGL_Inline} inline; {$endif} //result:=(a=b);
  function _IsLess_Key(const a,b :_KeyType):boolean; {$ifdef _DGL_Inline} inline; {$endif} //result:=(a<b); Ĭ������׼��

//var
//  IsCaseInsensitive:boolean = true; //��Сд�Ƿ�����

{$I HashMap.inc_h} //"��"ģ��������ļ�

//out
type
  ICIStrIntMapIterator  = _IMapIterator;
  ICIStrIntMap          = _IMap;
  ICIStrIntMultiMap     = _IMultiMap;

  TCIStrIntHashMap          = _THashMap;
  TCIStrIntHashMultiMap     = _THashMultiMap;

implementation
uses
  HashFunctions;

{$I HashMap.inc_pas} //"��"ģ���ʵ���ļ�

function _HashValue(const Key :_KeyType):Cardinal; overload;
begin
//  if IsCaseInsensitive then
    result:=HashValue_StrCaseInsensitive(Key)
//  else
//    result:=HashValue_Str(Key);
end;

function _IsEqual_Key(const a,b :_KeyType):boolean; //result:=(a=b);
begin
//  if IsCaseInsensitive then
    result:=IsEqual_StrCaseInsensitive(a,b)
//  else
//    result:=(a=b);
end;

function _IsLess_Key(const a,b :_KeyType):boolean;  //result:=(a<b); Ĭ������׼��
begin
//  if IsCaseInsensitive then
    result:=IsLess_StrCaseInsensitive(a,b)
//  else
//    result:=a<b;
end;

end.

