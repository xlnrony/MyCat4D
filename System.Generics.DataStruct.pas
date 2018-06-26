unit System.Generics.DataStruct;

interface

type
  TGenerateFunction<ValueType> = function(): ValueType;
  TGenerateFunctionOfObject<ValueType> = function(): ValueType of object;
  TTansfromFunction<ValueType> = function(const Value: ValueType): ValueType;
  TTansfromFunctionOfObject<ValueType> = function(const Value: ValueType)
    : ValueType of object;
  TTansfromBinaryFunction<ValueType> = function(const Value0, Value1: ValueType)
    : ValueType;
  TTansfromBinaryFunctionOfObject<ValueType> = function(const Value0,
    Value1: ValueType): ValueType of object;
  TVisitProc<ValueType> = procedure(const Value: ValueType);
  TVisitProcOfObject<ValueType> = procedure(const Value: ValueType) of object;
  TTestFunction<ValueType> = function(const Value: ValueType): Boolean;
  TTestFunctionOfObject<ValueType> = function(const Value: ValueType)
    : Boolean Of object;
  TTestBinaryFunction<ValueType> = function(const Value0,
    Value1: ValueType): Boolean;
  TTestBinaryFunctionOfObject<ValueType> = function(const Value0,
    Value1: ValueType): Boolean Of object;

  TRandomGenerateFunction = function(const Range: Integer): Integer;
  // 0<=result<Range
  TRandomGenerateFunctionOfObject = function(const Range: Integer)
    : Integer Of object;

type
  TIteratorTrait = (itTraits0, itTraits1, itTraits2, itTraits3, itTraits4);
  TIteratorTraits = set of TIteratorTrait;

const
  itTrivialTag = [];
  itInputTag = itTrivialTag + [itTraits0];
  itOutputTag = itTrivialTag + [itTraits1];
  itForwardTag = itInputTag + [itTraits2];
  itBidirectionalTag = itForwardTag + [itTraits3];
  itRandomAccessTag = itBidirectionalTag + [itTraits4];

type
  // ������(iterator)��ͳһ˵��
  // ----------------------------------------------------------------------------
  // ��������: �����������������Ԫ��
  // ��Ҫ������Value���ԣ�������д���������õ�ֵ
  // IsEqual�������ж������������Ƿ�ָ��ͬһ��λ��
  // Distance����: ��������λ�ü�ȥ����ĵ�����ָ��λ�õĲ�ֵ
  // Assign������ʹ�����봫��ĵ�����ָ��ͬһ������������λ��
  // Next������ָ����һ��λ��
  // Previous������ָ����һ��λ��
  // Clone����������һ���µĵ����������Լ�ָ��ͬһ��λ��
  // GetSelfObj���������ؽӿڴ��ڵ�ԭʼ����(selfָ��)���ڲ�ʹ��
  // Items����: ����ƫ�������ٵķ���ֵ(����������������г���ʱ��)
  // ʹ�÷�ʽ��
  // ע������: ���ʵ���˵����������������������ʵ��Previous����,�ᴥ���쳣
  // Distance������ĳЩ�������е�ʵ�� ʱ�临�Ӷȿ���ΪO(n);
  // ��    ��: HouSisong ��2004.08.31
  // [�������]: (����еĻ�)
  // [ά����¼]: (�෢�������޸���Ҫ��¼�������޸��ˡ�ʱ�䡢��Ҫԭ������)
  // ----------------------------------------------------------------------------
  // �������ֳ�TIterator�ṹ��_DGL_TObjIterator����ʵ����Ϊ���Ż��ô��ӿ�(+��ʵ��)ʵ�ֵ������Ĵ��������ٵĿ���
  // ʵ�ʲ������ٶȴ������!  2005.10.13
  // TObjIterator<KeyType, ValueType> = class;
  // TObjIteratorClass<KeyType, ValueType> = class<KeyType, ValueType> of TObjIterator<KeyType, ValueType>>;

  TIterator<ValueType> = class
    // private
    // FObjIteratorClass: TObjIteratorClass;
    // FData0: Integer;
    // FData1: Integer;
    // FData2: Integer;
    // ���������Ҫ���Լ�����չ
    // _InfData : IInterface;
    // _DataArray : array[0..2] of integer;
    function IteratorTraits: TIteratorTraits; virtual; abstract;
    procedure SetIteratorNil; virtual; abstract;
    procedure SetValue(const aValue: ValueType); virtual; abstract;
    function GetValue: ValueType; virtual; abstract;
    function GetNextValue(const Step: Integer): ValueType; virtual; abstract;
    procedure SetNextValue(const Step: Integer; const aValue: ValueType);
      virtual; abstract;

    property Value: ValueType read GetValue write SetValue;
    property NextValue[const Index: Integer]: ValueType read GetNextValue
      write SetNextValue;

    function IsEqual(const Iterator: TIterator<ValueType>): Boolean;
      virtual; abstract;
    function Distance(const Iterator: TIterator<ValueType>): Integer;
      virtual; abstract;
    // procedure Assign(const Iterator: TIterator<ValueType>);
    procedure Next; overload; virtual; abstract;
    procedure Next(const Step: Integer); overload; virtual; abstract;

    procedure Previous; virtual; abstract;
    // function Clone: TIterator<ValueType>; overload;
    // function Clone(const NextStep: Integer): TIterator<ValueType>; overload;
  end;

  // TObjIterator<KeyType, ValueType> = class
  // public
  // class function IteratorTraits(): TIteratorTraits; virtual; abstract;
  // class procedure SetValue(const SelfItData: TIterator<ValueType>;
  // const aValue: ValueType); virtual; abstract;
  // class function GetValue(const SelfItData: TIterator<ValueType>): ValueType;
  // virtual; abstract;
  // class function GetNextValue(const SelfItData: TIterator<ValueType>;
  // const Step: Integer): ValueType; virtual; abstract;
  // class procedure SetNextValue(const SelfItData: TIterator<ValueType>;
  // const Step: Integer; const aValue: ValueType); virtual; abstract;
  // class function IsEqual(const SelfItData: TIterator<ValueType>;
  // const Iterator: TIterator<ValueType>): Boolean; virtual; abstract;
  // class function Distance(const SelfItData: TIterator<ValueType>;
  // const Iterator: TIterator<ValueType>): Integer; virtual; abstract;
  // class procedure Assign(var SelfItData: TIterator<ValueType>;
  // const Iterator: TIterator<ValueType>); virtual; abstract;
  // class procedure Next(var SelfItData: TIterator<ValueType>); overload;
  // virtual; abstract;
  // class procedure Next(var SelfItData: TIterator<ValueType>;
  // const Step: Integer); overload; virtual; abstract;
  // class procedure Previous(var SelfItData: TIterator<ValueType>);
  // virtual; abstract;
  // class function Clone(const SelfItData: TIterator<ValueType>)
  // : TIterator<ValueType>; overload; virtual; abstract;
  // class function Clone(const SelfItData: TIterator<ValueType>;
  // const NextStep: Integer): TIterator<ValueType>; overload;
  // virtual; abstract;
  // class function Map_GetKey(const SelfItData: TIterator<ValueType>): KeyType;
  // virtual; abstract;
  // end;

  // ����(Container)��ͳһ˵��
  // ----------------------------------------------------------------------------
  // ��������: �����������֯�������,�ǳ�����Ĵ洢�����ʵ���޹�
  // ��Ҫ������ItBegin����������ָ���������һ��Ԫ�ص� ������
  // ItEnd����������ָ�����������һ��Ԫ�صĺ���һ��λ�õ� ������
  // Clear��������������е���������
  // Size�����������е�Ԫ�ظ���
  // IsEmpty�����������Ƿ�Ϊ��,����ֵ�ȼ���(0=Size());
  // GetSelfObj���������ؽӿڴ��ڵ�ԭʼ����(selfָ��)���ڲ�ʹ��
  // Erase������  ɾ��������ֵ���ڲ���Value��Ԫ�أ�����ɾ����Ԫ�ظ���
  // Erase������  ��������ɾ��������ָ���Ԫ��
  // Insert������ ������ָ��λ�ò���һ������Ԫ��
  // Assign����: ��������������¸�ֵ
  // Clone����������һ���µ���������ӵ�к�����һ����Ԫ��
  // ʹ�÷�ʽ��
  // ע������:
  // ��    ��: HouSisong ��2004.08.31
  // [�������]: (����еĻ�)
  // [ά����¼]: (�෢�������޸���Ҫ��¼�������޸��ˡ�ʱ�䡢��Ҫԭ������)
  // ----------------------------------------------------------------------------
  IContainer<ValueType> = interface
    function ItBegin(): TIterator<ValueType>;
    function ItEnd(): TIterator<ValueType>;
    procedure Clear();
    function Size(): Integer;
    function IsEmpty(): Boolean;
    function EraseValue(const Value: ValueType): Integer; overload;
    procedure Erase(const ItPos: TIterator<ValueType>); overload;
    procedure Erase(const ItBegin, ItEnd: TIterator<ValueType>); overload;
    procedure Insert(const Value: ValueType); overload;
    procedure Insert(const ItPos: TIterator<ValueType>;
      const Value: ValueType); overload;
    procedure Insert(const ItPos: TIterator<ValueType>; const num: Integer;
      const Value: ValueType); overload;
    procedure Insert(const ItPos: TIterator<ValueType>;
      const ItBegin, ItEnd: TIterator<ValueType>); overload;
    procedure Assign(const num: Integer; const Value: ValueType); overload;
    procedure Assign(const ItBegin, ItEnd: TIterator<ValueType>); overload;
    function Clone(): IContainer<ValueType>;
    procedure CloneToInterface(out NewContainer_Interface);
    // NewContainer:=_IContainer.Clone();

    function GetSelfObj(): TObject;
  end;

  // ��������(SerialContainer)��ͳһ˵��
  // ----------------------------------------------------------------------------
  // ��������: Ԫ�ذ�˳�򴢴������
  // ��Ҫ������(�μ�_IContainer)
  // PushBack�������������󲿲���һ������Ԫ��
  // PopBack������ �������һ��Ԫ��
  // Back������ �������һ��Ԫ��
  // PushFront����������������ǰ�����һ��Ԫ��
  // PopFront������ ������һ��Ԫ��
  // Front������ ���ص�һ��Ԫ��
  // IsEquals�������ж����������е�Ԫ���Ƿ���ȫ���
  // ʹ�÷�ʽ��
  // ע������:
  // ��    ��: HouSisong ��2004.09.09
  // [�������]: (����еĻ�)
  // [ά����¼]: (�෢�������޸���Ҫ��¼�������޸��ˡ�ʱ�䡢��Ҫԭ������)
  // ----------------------------------------------------------------------------
  ISerialContainer<ValueType> = interface(IContainer<ValueType>)
    procedure PushBack(const Value: ValueType); overload;
    procedure PushBack(const num: Integer; Value: ValueType); overload;
    procedure PushBack(const ItBegin, ItEnd: TIterator<ValueType>); overload;
    procedure PopBack();
    function GetBackValue(): ValueType;
    procedure SetBackValue(const aValue: ValueType);
    property Back: ValueType read GetBackValue write SetBackValue;

    procedure PushFront(const Value: ValueType); overload;
    procedure PushFront(const num: Integer; Value: ValueType); overload;
    procedure PushFront(const ItBegin, ItEnd: TIterator<ValueType>); overload;
    procedure PopFront();
    function GetFrontValue(): ValueType;
    procedure SetFrontValue(const aValue: ValueType);
    property Front: ValueType read GetFrontValue write SetFrontValue;
    function IsEquals(const AContainer: IContainer<ValueType>): Boolean;
    function IsLess(const AContainer: IContainer<ValueType>): Boolean;
    procedure Resize(const num: Integer); overload;
    procedure Resize(const num: Integer; const Value: ValueType); overload;
  end;

  // ����(Vector)��ͳһ˵��
  // ----------------------------------------------------------------------------
  // ��������: �����Ե��ڴ�ռ�(����)����֯���ݣ�������һ������ʵ��
  // ��Ҫ������IndexOf����������Ԫ���������е�λ��
  // Items���ԣ�����ŵķ�ʽ���ٵķ��������е�Ԫ�أ�ʱ�临�Ӷ�O(1)
  // Reserve����: ����Ԥ��һЩ�ռ�(���ٶ�̬����)
  // Resize����: �ı�������С
  // ʹ�÷�ʽ��
  // ע������:
  // ��    ��: HouSisong ��2004.08.31
  // [�������]: (����еĻ�)
  // [ά����¼]: (�෢�������޸���Ҫ��¼�������޸��ˡ�ʱ�䡢��Ҫԭ������)
  // ----------------------------------------------------------------------------
  IVector<ValueType> = interface(ISerialContainer<ValueType>)
    function GetItemValue(const Index: Integer): ValueType;
    procedure SetItemValue(const Index: Integer; const Value: ValueType);

    property Items[const Index: Integer]: ValueType read GetItemValue
      write SetItemValue;
    function IndexOf(const Value: ValueType): Integer;
    procedure InsertByIndex(const Index: Integer; const Value: ValueType);
    function NewIterator(const Index: Integer): TIterator<ValueType>;
    procedure Reserve(const ReserveSize: Integer);
    procedure EraseByIndex(const Index: Integer); overload;
  end;

  // ����(List)��ͳһ˵��
  // ----------------------------------------------------------------------------
  // ��������: ���������ݽӵ㴮���ķ�ʽ��֯��������һ������ʵ��
  // ��Ҫ������Unique������������Ԫ����ͬ��ֻ����һ��
  // Splice��������AContainer�ڵ�Ԫ��ת�Ƶ��Լ���Pos��
  // Merge������ ��AContainer�ڵ�����Ԫ��ת�Ƶ�������Լ��������Լ��Ա�������
  // Reverse����: ��Ԫ�ط���
  // ʹ�÷�ʽ��
  // ע������: ��Ϊ������:_IList��ʵ�����ͱ����������������һ��!
  // ��    ��: HouSisong ��2004.08.31
  // [�������]: (����еĻ�)
  // [ά����¼]: (�෢�������޸���Ҫ��¼�������޸��ˡ�ʱ�䡢��Ҫԭ������)
  // ----------------------------------------------------------------------------
  IList<ValueType> = interface(ISerialContainer<ValueType>)
    procedure Unique(); overload;
    procedure Unique(const TestBinaryFunction
      : TTestBinaryFunction<ValueType>); overload;
    procedure Unique(const TestBinaryFunction
      : TTestBinaryFunctionOfObject<ValueType>); overload;
    procedure Splice(const ItPos: TIterator<ValueType>;
      AList: IList<ValueType>); overload; // ȫ��ת��
    procedure Splice(const ItPos: TIterator<ValueType>; AList: IList<ValueType>;
      const ACItPos: TIterator<ValueType>); overload; // ת��ACItPosһ��
    procedure Splice(const ItPos: TIterator<ValueType>; AList: IList<ValueType>;
      const ACItBegin, ACItEnd: TIterator<ValueType>); overload;
    procedure Reverse();

    function EraseValueIf(const TestFunction: TTestFunction<ValueType>)
      : Integer; overload;
    function EraseValueIf(const TestFunction: TTestFunctionOfObject<ValueType>)
      : Integer; overload;
    procedure Sort(); overload;
    procedure Sort(const TestBinaryFunction
      : TTestBinaryFunction<ValueType>); overload;
    procedure Sort(const TestBinaryFunction
      : TTestBinaryFunctionOfObject<ValueType>); overload;
    procedure Merge(AList: IList<ValueType>); overload;
    procedure Merge(AList: IList<ValueType>;
      const TestBinaryFunction: TTestBinaryFunction<ValueType>); overload;
    procedure Merge(AList: IList<ValueType>;
      const TestBinaryFunction
      : TTestBinaryFunctionOfObject<ValueType>); overload;
  end;

  // ��������(SList)��ͳһ˵��
  // ----------------------------------------------------------------------------
  // ��������: ���������ݽӵ㵥�����ķ�ʽ��֯��������һ������ʵ��
  // ��Ҫ������
  // ʹ�÷�ʽ��
  // ע������:
  // ��    ��: HouSisong ��2006.10.22
  // [�������]: (����еĻ�)
  // [ά����¼]: (�෢�������޸���Ҫ��¼�������޸��ˡ�ʱ�䡢��Ҫԭ������)
  // ----------------------------------------------------------------------------
  ISList<ValueType> = interface(ISerialContainer<ValueType>)
  end;

  // ����(Deque)��ͳһ˵��
  // ----------------------------------------------------------------------------
  // ��������: ��Vector��²��ܹ���ǰ��Ҳ���ٲ����ɾ��Ԫ�أ�������һ������ʵ��
  // ��Ҫ������
  // ʹ�÷�ʽ��
  // ע������:
  // ��    ��: HouSisong ��2004.08.31
  // [�������]: (����еĻ�)
  // [ά����¼]: (�෢�������޸���Ҫ��¼�������޸��ˡ�ʱ�䡢��Ҫԭ������)
  // ----------------------------------------------------------------------------
  IDeque<ValueType> = interface(IVector<ValueType>)
  end;

  // �Զ�ջ(Stack)��ͳһ˵��
  // ----------------------------------------------------------------------------
  // ��������: �����������һ�֣�һ�˿��ڣ��Ƚ��������
  // ��Ҫ������Push������ѹ��һ��Ԫ��
  // Pop����������Ԫ��
  // Top���������ؿ��ڴ��ĵ�ǰֵ
  // Clear��������������е�����
  // Size���������������е�Ԫ�ظ���
  // IsEmpty�������ж������Ƿ�Ϊ��
  // IsEquals�������ж����������е�Ԫ���Ƿ���ȫ���
  // Clone����������һ���µ���������ӵ�к�����һ����Ԫ��
  // Assign����: ��������������¸�ֵ
  // GetSelfObj���������ؽӿڴ��ڵ�ԭʼ����(selfָ��)���ڲ�ʹ��
  // ʹ�÷�ʽ��
  // ע������:
  // ��    ��: HouSisong ��2004.08.31
  // [�������]: (����еĻ�)
  // [ά����¼]: (�෢�������޸���Ҫ��¼�������޸��ˡ�ʱ�䡢��Ҫԭ������)
  // ----------------------------------------------------------------------------
  IStack<ValueType> = interface
    procedure Push(const Value: ValueType);
    procedure Pop();
    function GetTopValue(): ValueType;
    procedure SetTopValue(const aValue: ValueType);
    property Top: ValueType read GetTopValue write SetTopValue;
    procedure Clear();
    function Size(): Integer;
    function IsEmpty(): Boolean;
    function IsEquals(const AContainer: IStack<ValueType>): Boolean;
    function Clone(): IStack<ValueType>;
    procedure Assign(const num: Integer; const Value: ValueType); overload;
    procedure Assign(const ItBegin, ItEnd: TIterator<ValueType>); overload;

    function GetSelfObj(): TObject;
  end;

  // ˫�˶���(Queue)��ͳһ˵��
  // ----------------------------------------------------------------------------
  // ��������: �����������һ�֣����˿���
  // ��Ҫ������Push���������������ѹ��һ��Ԫ��
  // Pop������������ǰ��һ��Ԫ��
  // Back���������������Ԫ�صĵ�ǰֵ
  // Front������������ǰ��Ԫ�صĵ�ǰֵ
  // Clear��������������е�����
  // Size���������������е�Ԫ�ظ���
  // IsEmpty�������ж������Ƿ�Ϊ��
  // IsEquals�������ж����������е�Ԫ���Ƿ���ȫ���
  // Clone����������һ���µ���������ӵ�к�����һ����Ԫ��
  // Assign����: ��������������¸�ֵ
  // GetSelfObj���������ؽӿڴ��ڵ�ԭʼ����(selfָ��)���ڲ�ʹ��
  // ʹ�÷�ʽ��
  // ע������:
  // ��    ��: HouSisong ��2004.08.31
  // [�������]: (����еĻ�)
  // [ά����¼]: (�෢�������޸���Ҫ��¼�������޸��ˡ�ʱ�䡢��Ҫԭ������)
  // ----------------------------------------------------------------------------
  IQueue<ValueType> = interface
    procedure Push(const Value: ValueType);
    procedure Pop();
    function GetBackValue(): ValueType;
    procedure SetBackValue(const aValue: ValueType);
    property Back: ValueType read GetBackValue write SetBackValue;
    function GetFrontValue(): ValueType;
    procedure SetFrontValue(const aValue: ValueType);
    property Front: ValueType read GetFrontValue write SetFrontValue;
    procedure Clear();
    function Size(): Integer;
    function IsEmpty(): Boolean;
    function IsEquals(const AContainer: IQueue<ValueType>): Boolean;
    function Clone(): IQueue<ValueType>;
    procedure Assign(const num: Integer; const Value: ValueType); overload;
    procedure Assign(const ItBegin, ItEnd: TIterator<ValueType>); overload;

    function GetSelfObj(): TObject;
  end;

  // ���ȼ�����(PriorityQueue)��ͳһ˵��
  // ----------------------------------------------------------------------------
  // ��������: �����������һ��
  // ��Ҫ������Push��������������ѹ��һ��Ԫ��
  // Pop���������������ȵ�һ��Ԫ��
  // Top���������������ȵ�ֵ
  // Clear��������������е�����
  // Size���������������е�Ԫ�ظ���
  // IsEmpty�������ж������Ƿ�Ϊ��
  // IsEquals�������ж����������е�Ԫ���Ƿ���ȫ���
  // Clone����������һ���µ���������ӵ�к�����һ����Ԫ��
  // Assign����: ��������������¸�ֵ
  // GetSelfObj���������ؽӿڴ��ڵ�ԭʼ����(selfָ��)���ڲ�ʹ��
  // ʹ�÷�ʽ��
  // ע������:
  // ��    ��: HouSisong ��2005.03.26
  // [�������]: (����еĻ�)
  // [ά����¼]: (�෢�������޸���Ҫ��¼�������޸��ˡ�ʱ�䡢��Ҫԭ������)
  IPriorityQueue<ValueType> = interface
    procedure Push(const Value: ValueType);
    procedure Pop();
    function GetTopValue(): ValueType;
    procedure SetTopValue(const aValue: ValueType);
    property Top: ValueType read GetTopValue write SetTopValue;
    procedure Clear();
    function Size(): Integer;
    function IsEmpty(): Boolean;
    function IsEquals(const AContainer: IPriorityQueue<ValueType>): Boolean;
    function Clone(): IPriorityQueue<ValueType>;
    procedure Assign(const num: Integer; const Value: ValueType); overload;
    procedure Assign(const ItBegin, ItEnd: TIterator<ValueType>); overload;

    function GetSelfObj(): TObject;
  end;

  // Set,MultiSet��ͳһ˵��
  // ----------------------------------------------------------------------------
  // ��������: Ԫ�ؼ��� (Set���������ظ�Ԫ��,MultiSet�������ظ�Ԫ��)
  // ��Ҫ������(�μ�_IContainer��˵��)
  // Count����: ͳ��ĳԪ�صĸ���
  // Find����: ����ĳ��Ԫ�صĵ�һ�γ���λ��
  // LowerBound����: ����ĳֵ�ĵ�һ���ɰ���λ��
  // UpperBound����: ����ĳֵ�����һ���ɰ���λ��
  // EqualRange����: ����ĳֵ�Ŀɰ���ĵ�һ�������һ��λ��
  // ʹ�÷�ʽ��
  // ע������:
  // ��    ��: HouSisong ��2004.09.08
  // [�������]: (����еĻ�)
  // [ά����¼]: (�෢�������޸���Ҫ��¼�������޸��ˡ�ʱ�䡢��Ҫԭ������)
  // ----------------------------------------------------------------------------
  ISet<ValueType> = interface(IContainer<ValueType>)
    function Count(const Value: ValueType): Integer;
    function Find(const Value: ValueType): TIterator<ValueType>;
    function LowerBound(const Value: ValueType): TIterator<ValueType>;
    function UpperBound(const Value: ValueType): TIterator<ValueType>;
    procedure EqualRange(const Value: ValueType;
      out ItBegin, ItEnd: TIterator<ValueType>);
  end;

  IMultiSet<ValueType> = interface(ISet<ValueType>)
  end;

  // Map������(Map Iterator)��ͳһ˵��
  // ----------------------------------------------------------------------------
  // ��������: ��������map���������Ԫ��
  // ��Ҫ������(�μ��Ե�������ͳһ˵��)
  // Key���ԣ���������(ֻ��)���������õļ�ֵ
  // ʹ�÷�ʽ��
  // ע������:
  // ��    ��: HouSisong ��2004.09.09
  // [�������]: (����еĻ�)
  // [ά����¼]: (�෢�������޸���Ҫ��¼�������޸��ˡ�ʱ�䡢��Ҫԭ������)
  // ----------------------------------------------------------------------------
  TMapIterator<KeyType, ValueType> = class(TIterator<ValueType>)
    function GetKey: KeyType; virtual; abstract;

    property Key: KeyType read GetKey;
  end;

  // Map,MultiMap��ͳһ˵��
  // ----------------------------------------------------------------------------
  // ��������: ��ֵ/ʵֵ ӳ�� (Map�������м�ֵ�ظ�,MultiMap�����м�ֵ�ظ�)
  // ��Ҫ������ItBegin����������ָ���������һ��Ԫ�ص� ������
  // ItEnd����������ָ�����������һ��Ԫ�صĺ���һ��λ�õ� ������
  // Clear��������������е���������
  // Size�����������е�Ԫ�ظ���
  // IsEmpty�����������Ƿ�Ϊ��,����ֵ�ȼ���(0=Size());
  // IsEquals�������ж����������е�Ԫ���Ƿ���ȫ���
  // GetSelfObj���������ؽӿڴ��ڵ�ԭʼ����(selfָ��)���ڲ�ʹ��
  // Erase������  ɾ��������ֵ���ڲ���Value��Ԫ�أ�����ɾ����Ԫ�ظ���
  // Erase������  ��������ɾ��������ָ���Ԫ��
  // Insert������ ������ָ��λ�ò���һ������Ԫ��
  // Assign����: ��������������¸�ֵ
  // Clone����������һ���µ���������ӵ�к�����һ����Ԫ��
  // Count����: ͳ��ĳ��ֵ�ĸ���
  // Find����: ����ĳ��ֵ�ĵ�һ�γ���λ��
  // LowerBound����: ����ĳ��ֵ�ĵ�һ���ɰ���λ��
  // UpperBound����: ����ĳ��ֵ�����һ���ɰ���λ��
  // EqualRange����: ����ĳ��ֵ�Ŀɰ���ĵ�һ�������һ��λ��
  // Items���ԣ���KeyΪ��ŵķ�ʽ���������е�Ԫ��
  // ʹ�÷�ʽ��
  // ע������:
  // ��    ��: HouSisong ��2004.09.09
  // [�������]: (����еĻ�)
  // [ά����¼]: (�෢�������޸���Ҫ��¼�������޸��ˡ�ʱ�䡢��Ҫԭ������)
  // ----------------------------------------------------------------------------
  IMap<KeyType, ValueType> = interface
    function GetItemValue(const Key: KeyType): ValueType;
    procedure SetItemValue(const Key: KeyType; const Value: ValueType);

    function ItBegin(): TMapIterator<KeyType, ValueType>;
    function ItEnd(): TMapIterator<KeyType, ValueType>;
    property Items[const Key: KeyType]: ValueType read GetItemValue
      write SetItemValue;
    procedure Clear();
    function Size(): Integer;
    function IsEmpty(): Boolean;
    function EraseValue(const Value: ValueType): Integer; overload;
    function EraseValue(const Key: KeyType; const Value: ValueType)
      : Integer; overload;
    function EraseKey(const Key: KeyType): Integer; overload;
    procedure Erase(const ItPos: TMapIterator<KeyType, ValueType>); overload;
    procedure Erase(const ItBegin,
      ItEnd: TMapIterator<KeyType, ValueType>); overload;
    procedure Insert(const Key: KeyType; const Value: ValueType); overload;
    procedure Insert(const ItBegin,
      ItEnd: TMapIterator<KeyType, ValueType>); overload;
    procedure Insert(const num: Integer; const Key: KeyType;
      const Value: ValueType); overload;
    procedure Assign(const ItBegin,
      ItEnd: TMapIterator<KeyType, ValueType>); overload;
    procedure Assign(const num: Integer; const Key: KeyType;
      const Value: ValueType); overload;

    function Count(const Key: KeyType): Integer;
    function Find(const Key: KeyType): TMapIterator<KeyType, ValueType>;
    function LowerBound(const Key: KeyType): TMapIterator<KeyType, ValueType>;
    function UpperBound(const Key: KeyType): TMapIterator<KeyType, ValueType>;
    procedure EqualRange(const Key: KeyType;
      out ItBegin, ItEnd: TMapIterator<KeyType, ValueType>);

    function Clone(): IMap<KeyType, ValueType>;

    function GetSelfObj(): TObject;
  end;

  IMultiMap<KeyType, ValueType> = interface(IMap<KeyType, ValueType>)
  end;

  /// //////////////////////

  // type
  // // ��������_TAbstractIterator
  // // ----------------------------------------------------------------------------
  // // ��������: �������������࣬ʵ��TIterator�ӿ�
  // // ��Ҫ�������μ��ӿڵ�Ԫ�Ե�������˵��
  // // ʹ�÷�ʽ��
  // // ע������: ��Ҫ���������ʵ��
  // // ��    ��: HouSisong, 2004.09.01
  // // [�������]: (����еĻ�)
  // // [ά����¼]: (�෢�������޸���Ҫ��¼�������޸��ˡ�ʱ�䡢��Ҫԭ������)
  // // ----------------------------------------------------------------------------
  TAbstractIterator<ValueType> = class(TIterator<ValueType>)
    // ʵ��TIterator�ӿ�
  public
    function IteratorTraits: TIteratorTraits; override;
    // procedure SetIteratorNil;
    // procedure SetValue(const aValue: ValueType);
    // function GetValue: ValueType;
    function GetNextValue(const Step: Integer): ValueType; override;
    procedure SetNextValue(const Step: Integer;
      const aValue: ValueType); override;
    // property Value: ValueType read GetValue write SetValue;
    // property NextValue[const Index: Integer]: ValueType read GetNextValue
    // write SetNextValue;
    // function IsEqual(const Iterator: TIterator<ValueType>): Boolean;
    function Distance(const Iterator: TIterator<ValueType>): Integer; override;
    // procedure Assign(const Iterator: TIterator<ValueType>);
    // procedure Next; overload;
    procedure Next(const Step: Integer); overload; override;

    // procedure Previous;
    // function Clone: TIterator<ValueType>; overload;
    // function Clone(const NextStep: Integer): TIterator<ValueType>; overload;
  end;

type
  __private_Algorithms_PValueType_Iterators<ValueType> = array
    [0 .. maxint div (sizeof(ValueType)) - 1] of _ValueType;
  _PValueType_Iterator = ^__private_Algorithms_PValueType_Iterators;

type
  _TAlgorithms = class(TObject)
  public
    // todo: private
    class procedure SwapValue(const It0, It1: _PValueType_Iterator); overload;
    {$IFDEF _DGL_Inline} inline; {$ENDIF}
    class procedure SwapValue(const It: _PValueType_Iterator;
      const Index0, Index1: Integer); overload; {$IFDEF _DGL_Inline} inline;
    {$ENDIF}
    class procedure SwapValue(const It0: _PValueType_Iterator;
      const Index0: Integer; const It1: _PValueType_Iterator;
      const Index1: Integer); overload; {$IFDEF _DGL_Inline} inline; {$ENDIF}
    class procedure Sort(const ItBegin, ItEnd: _PValueType_Iterator); overload;
    class procedure Sort(const ItBegin, ItEnd: _PValueType_Iterator;
      const TestBinaryFunction: TTestBinaryFunction); overload;
    class procedure Sort(const ItBegin, ItEnd: _PValueType_Iterator;
      const TestBinaryFunction: TTestBinaryFunctionOfObject); overload;
    class function IsSorted(const ItBegin, ItEnd: _PValueType_Iterator)
      : Boolean; overload;
    class function IsSorted(const ItBegin, ItEnd: _PValueType_Iterator;
      const TestBinaryFunction: TTestBinaryFunction): Boolean; overload;
    class function IsSorted(const ItBegin, ItEnd: _PValueType_Iterator;
      const TestBinaryFunction: TTestBinaryFunctionOfObject): Boolean; overload;
    class function LowerBound(const ItBegin, ItEnd: _PValueType_Iterator;
      const Value: _ValueType): _PValueType_Iterator; overload;
    class function LowerBound(const ItBegin, ItEnd: _PValueType_Iterator;
      const Value: _ValueType; const TestBinaryFunction: TTestBinaryFunction)
      : _PValueType_Iterator; overload;
    class function LowerBound(const ItBegin, ItEnd: _PValueType_Iterator;
      const Value: _ValueType;
      const TestBinaryFunction: TTestBinaryFunctionOfObject)
      : _PValueType_Iterator; overload;
  public
{$I _Algorithms_Base.inc_h}
{$DEFINE _DGL_VectorItType}
{$I _Algorithms_Base.inc_h}
{$UNDEF  _DGL_VectorItType}
  end;

implementation

{ TAbstractIterator<ValueType> }

// procedure TAbstractIterator<ValueType>.Assign(const Iterator
// : TIterator<ValueType>);
// begin
//
// end;

// function TAbstractIterator<ValueType>.Clone: TIterator<ValueType>;
// begin
//
// end;
//
// function TAbstractIterator<ValueType>.Clone(const NextStep: Integer)
// : TIterator<ValueType>;
// begin
// Result := Self;
// Result.Next(NextStep);
// end;

function TAbstractIterator<ValueType>.Distance(const Iterator
  : TIterator<ValueType>): Integer;
begin
  Result := 0;
  while not IsEqual(Iterator) do
  begin
    Inc(Result);
    Next;
  end;
end;

function TAbstractIterator<ValueType>.GetNextValue(const Step: Integer)
  : ValueType;
begin
  Next(Step);
  Result := GetValue;
end;

function TAbstractIterator<ValueType>.IteratorTraits: TIteratorTraits;
begin
  Result := itTrivialTag;
end;

procedure TAbstractIterator<ValueType>.Next(const Step: Integer);
var
  I: Integer;
begin
  if Step >= 0 then
  begin
    for I := 0 to Step - 1 do
    begin
      Next;
    end;
  end
  else
  begin
    for I := 0 to -Step - 1 do
    begin
      Previous;
    end;
  end;
end;

procedure TAbstractIterator<ValueType>.SetNextValue(const Step: Integer;
  const aValue: ValueType);
begin
  Next(Step);
  SetValue(aValue);
end;

end.