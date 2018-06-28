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
// ���� ��ֵ�����TTestObj������
// ���ֻ���TTestObj���͵�����
// ��Ҫ����ֵ������������������ģ��
// ֵ����:�������ڴ������Ķ�����п��������棬����ɾ������ʱ���Զ������ͷţ�
// Create by HouSisong, 2004.09.04
//------------------------------------------------------------------------------
unit _DGL_Object;

//���ֻ����Ҫ�����������壬��ע�͵�_DGL_ObjValue�Ķ���

interface
uses
  SysUtils;

var
  _refCount : integer=0;
  _ValueCount : integer=1;
type
  TTestObj = class(TObject)
    FValue : integer;
    constructor Create();overload;
    constructor Create(v:TTestObj);overload;
    destructor Destroy();override;
  end;


type
  _ValueType  = TTestObj;
const
  _NULL_Value:TTestObj =nil ;
  function _HashValue(const Key:_ValueType) : Cardinal;//Hash����

  {$define _DGL_Compare}  //��Ҫ�ȽϺ�������ѡ
  function  _IsEqual(const a,b :_ValueType):boolean; //result:=(a=b);
  function  _IsLess(const a,b :_ValueType):boolean;  //result:=(a<b); Ĭ������׼��
  {$define _DGL_ObjValue}  //��Ҫ���ֶ����ֵ����
  function  _CreateNew():_ValueType;overload;//����
  function  _CopyCreateNew(const Value: _ValueType):_ValueType;overload;//��������
  procedure _Assign(DestValue:_ValueType;const SrcValue: _ValueType);//��ֵ
  procedure _Free(Value: _ValueType);//����


{$I DGL.inc_h}


//<out>
type
  TObjAlgorithms       = _TAlgorithms;

  IObjIterator         = _IIterator;
  IObjContainer        = _IContainer;
  IObjSerialContainer  = _ISerialContainer;
  IObjVector           = _IVector;
  IObjList             = _IList;
  IObjDeque            = _IDeque;
  IObjStack            = _IStack;
  IObjQueue            = _IQueue;
  IObjPriorityQueue    = _IPriorityQueue;
  IObjSet              = _ISet;
  IObjMultiSet         = _IMultiSet;

  TObjPointerItBox     = _TPointerItBox_Obj;

  TObjVector           = _TVector;
  IObjVectorIterator   = _IVectorIterator; //�ٶȱ�_IIterator�Կ�һ��:)
  TObjDeque            = _TDeque;
  TObjList             = _TList;
  TObjStack            = _TStack;
  TObjQueue            = _TQueue;
  TObjPriorityQueue    = _TPriorityQueue;
  TObjHashSet          = _THashSet;
  TObjHashMuitiSet     = _THashMultiSet;

  //

  IObjMapIterator  = _IMapIterator;
  IObjMap          = _IMap;
  IObjMultiMap     = _IMultiMap;

  TObjHashMap          = _THashMap;
  TObjHashMultiMap     = _THashMultiMap;

implementation

{$I DGL.inc_pas}

function _HashValue(const Key :_ValueType):Cardinal;
begin
  Assert(Key<>nil);
  result:=Cardinal(Key.FValue)*37;
end;


function  _IsEqual(const a,b :_ValueType):boolean;
begin
  Assert(a<>nil);
  Assert(b<>nil);
  result:=(a.FValue=b.FValue);
  //Assert(false);//�Լ���ʵ�����ʵ��
end;

function  _IsLess(const a,b :_ValueType):boolean;
begin
  Assert(a<>nil);
  Assert(b<>nil);
  result:=(a.FValue<b.FValue);
  //Assert(false);//�Լ���ʵ�����ʵ��
end;

function  _CreateNew():_ValueType;
begin
  result:=TTestObj.Create();
  //Assert(false);//�Լ���ʵ�����ʵ��
end;

function  _CopyCreateNew(const Value: _ValueType):_ValueType;
begin
  Assert(Value<>nil);
  result:=TTestObj.Create(Value);
  //Assert(false);//�Լ���ʵ�����ʵ��
end;

procedure  _Assign(DestValue:_ValueType;const SrcValue: _ValueType);
begin
  Assert(DestValue<>nil);
  Assert(SrcValue<>nil);
  DestValue.FValue:=SrcValue.FValue;
  //Assert(false);//�Լ���ʵ�����ʵ��
end;

procedure _Free(Value: _ValueType);
begin
  Assert(Value<>nil);
  Value.Free();
  //Assert(false);//�Լ���ʵ�����ʵ�� ��:Value.Free;
end;

{ TTestObj }

constructor TTestObj.Create;
begin
  inherited Create();
  FValue:=_ValueCount;
  inc(_ValueCount);
  inc(_refCount);
end;

constructor TTestObj.Create(v: TTestObj);
begin
  inherited Create();
  FValue:=v.FValue;
  inc(_refCount);
end;

destructor TTestObj.Destroy;
begin
  dec(_refCount);
  inherited;
end;


end.
