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
//TStrIntMap
//����
//���ֻ�String<->integer��map�������������
// Create by HouSisong, 2004.09.13
//------------------------------------------------------------------------------
unit _DGLMap_String_Integer;

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

{$I HashMap.inc_h} //"��"ģ��������ļ�
{$I Map.inc_h} //"��"ģ��������ļ�
{$I Algorithms.inc_h}

//out
type
  IStrIntMapIterator  = _IMapIterator;
  IStrIntMap          = _IMap;
  IStrIntMultiMap     = _IMultiMap;

  TStrIntHashMap          = _THashMap;
  TStrIntHashMultiMap     = _THashMultiMap;

  TStrIntMap          = _TMap;
  TStrIntMultiMap     = _TMultiMap;

implementation
uses
  HashFunctions;

{$I HashMap.inc_pas} //"��"ģ���ʵ���ļ�
{$I Map.inc_pas} //"��"ģ���ʵ���ļ�
{$I Algorithms.inc_pas}

function _HashValue(const Key :_KeyType):Cardinal; overload;
begin
  result:=HashValue_Str(Key);
end;

end.






