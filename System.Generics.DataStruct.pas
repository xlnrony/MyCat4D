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
  // 迭代器(iterator)的统一说明
  // ----------------------------------------------------------------------------
  // 作用描述: 用来遍历容器里面的元素
  // 主要方法：Value属性：用来读写迭代器引用的值
  // IsEqual方法：判断两个迭代器是否指向同一个位置
  // Distance方法: 返回自身位置减去传入的迭代器指向位置的差值
  // Assign方法：使自身与传入的迭代器指向同一个容器和引用位置
  // Next方法：指向下一个位置
  // Previous方法：指向上一个位置
  // Clone方法：创建一个新的迭代器，与自己指向同一个位置
  // GetSelfObj方法：返回接口存在的原始对象(self指针)，内部使用
  // Items属性: 根据偏移量快速的访问值(对于随机迭代器才有常数时间)
  // 使用方式：
  // 注意事项: 如果实现了单向链表，则其迭代器不会实现Previous方法,会触发异常
  // Distance方法在某些迭代器中的实现 时间复杂度可能为O(n);
  // 作    者: HouSisong ，2004.08.31
  // [相关资料]: (如果有的话)
  // [维护记录]: (类发布后，其修改需要记录下来：修改人、时间、主要原因内容)
  // ----------------------------------------------------------------------------
  // 迭代器分成TIterator结构和_DGL_TObjIterator类来实现是为了优化用纯接口(+类实现)实现迭代器的创建和销毁的开销
  // 实际测试中速度大幅提升!  2005.10.13
  // TObjIterator<KeyType, ValueType> = class;
  // TObjIteratorClass<KeyType, ValueType> = class<KeyType, ValueType> of TObjIterator<KeyType, ValueType>>;

  TIterator<ValueType> = class
    // private
    // FObjIteratorClass: TObjIteratorClass;
    // FData0: Integer;
    // FData1: Integer;
    // FData2: Integer;
    // 如果库有需要可以继续扩展
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

  // 容器(Container)的统一说明
  // ----------------------------------------------------------------------------
  // 作用描述: 用来保存和组织多个数据,是抽象出的存储概念，和实现无关
  // 主要方法：ItBegin方法：返回指向容器里第一个元素的 迭代器
  // ItEnd方法：返回指向容器里最后一个元素的后面一个位置的 迭代器
  // Clear方法：清空容器中的所有数据
  // Size方法：容器中的元素个数
  // IsEmpty方法：容器是否为空,返回值等价于(0=Size());
  // GetSelfObj方法：返回接口存在的原始对象(self指针)，内部使用
  // Erase方法：  删除容器中值等于参数Value的元素，返回删除的元素个数
  // Erase方法：  从容器中删除迭代器指向的元素
  // Insert方法： 在容器指定位置插入一个或多个元素
  // Assign方法: 整个容器清空重新赋值
  // Clone方法：创建一个新的容器，并拥有和自身一样的元素
  // 使用方式：
  // 注意事项:
  // 作    者: HouSisong ，2004.08.31
  // [相关资料]: (如果有的话)
  // [维护记录]: (类发布后，其修改需要记录下来：修改人、时间、主要原因内容)
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

  // 序列容器(SerialContainer)的统一说明
  // ----------------------------------------------------------------------------
  // 作用描述: 元素按顺序储存的容器
  // 主要方法：(参见_IContainer)
  // PushBack方法：在容器后部插入一个或多个元素
  // PopBack方法： 弹出最后一个元素
  // Back方法： 返回最后一个元素
  // PushFront方法：在容器的最前面插入一个元素
  // PopFront方法： 弹出第一个元素
  // Front方法： 返回第一个元素
  // IsEquals方法：判断两个容器中的元素是否完全相等
  // 使用方式：
  // 注意事项:
  // 作    者: HouSisong ，2004.09.09
  // [相关资料]: (如果有的话)
  // [维护记录]: (类发布后，其修改需要记录下来：修改人、时间、主要原因内容)
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

  // 向量(Vector)的统一说明
  // ----------------------------------------------------------------------------
  // 作用描述: 用线性的内存空间(数组)来组织数据，容器的一个具体实现
  // 主要方法：IndexOf方法：返回元素在容器中的位置
  // Items属性：以序号的方式快速的访问容器中的元素，时间复杂度O(1)
  // Reserve方法: 容器预留一些空间(减少动态分配)
  // Resize方法: 改变容器大小
  // 使用方式：
  // 注意事项:
  // 作    者: HouSisong ，2004.08.31
  // [相关资料]: (如果有的话)
  // [维护记录]: (类发布后，其修改需要记录下来：修改人、时间、主要原因内容)
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

  // 链表(List)的统一说明
  // ----------------------------------------------------------------------------
  // 作用描述: 数据以数据接点串连的方式组织，容器的一个具体实现
  // 主要方法：Unique方法：若相邻元素相同，只留下一个
  // Splice方法：将AContainer内的元素转移到自己的Pos处
  // Merge方法： 将AContainer内的已序元素转移到已序的自己，并且自己仍保持有序
  // Reverse方法: 将元素反序
  // 使用方式：
  // 注意事项: 作为参数的:_IList的实际类型必须和自身的类类型一致!
  // 作    者: HouSisong ，2004.08.31
  // [相关资料]: (如果有的话)
  // [维护记录]: (类发布后，其修改需要记录下来：修改人、时间、主要原因内容)
  // ----------------------------------------------------------------------------
  IList<ValueType> = interface(ISerialContainer<ValueType>)
    procedure Unique(); overload;
    procedure Unique(const TestBinaryFunction
      : TTestBinaryFunction<ValueType>); overload;
    procedure Unique(const TestBinaryFunction
      : TTestBinaryFunctionOfObject<ValueType>); overload;
    procedure Splice(const ItPos: TIterator<ValueType>;
      AList: IList<ValueType>); overload; // 全部转移
    procedure Splice(const ItPos: TIterator<ValueType>; AList: IList<ValueType>;
      const ACItPos: TIterator<ValueType>); overload; // 转移ACItPos一个
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

  // 单向链表(SList)的统一说明
  // ----------------------------------------------------------------------------
  // 作用描述: 数据以数据接点单向串连的方式组织，容器的一个具体实现
  // 主要方法：
  // 使用方式：
  // 注意事项:
  // 作    者: HouSisong ，2006.10.22
  // [相关资料]: (如果有的话)
  // [维护记录]: (类发布后，其修改需要记录下来：修改人、时间、主要原因内容)
  // ----------------------------------------------------------------------------
  ISList<ValueType> = interface(ISerialContainer<ValueType>)
  end;

  // 队列(Deque)的统一说明
  // ----------------------------------------------------------------------------
  // 作用描述: 与Vector相仿并能够在前端也快速插入和删除元素，容器的一个具体实现
  // 主要方法：
  // 使用方式：
  // 注意事项:
  // 作    者: HouSisong ，2004.08.31
  // [相关资料]: (如果有的话)
  // [维护记录]: (类发布后，其修改需要记录下来：修改人、时间、主要原因内容)
  // ----------------------------------------------------------------------------
  IDeque<ValueType> = interface(IVector<ValueType>)
  end;

  // 对堆栈(Stack)的统一说明
  // ----------------------------------------------------------------------------
  // 作用描述: 容器配接器的一种，一端开口，先进后出队列
  // 主要方法：Push方法：压入一个元素
  // Pop方法：弹出元素
  // Top方法：返回开口处的当前值
  // Clear方法：清空容器中的数据
  // Size方法：返回容器中的元素个数
  // IsEmpty方法：判断容器是否为空
  // IsEquals方法：判断两个容器中的元素是否完全相等
  // Clone方法：创建一个新的容器，并拥有和自身一样的元素
  // Assign方法: 整个容器清空重新赋值
  // GetSelfObj方法：返回接口存在的原始对象(self指针)，内部使用
  // 使用方式：
  // 注意事项:
  // 作    者: HouSisong ，2004.08.31
  // [相关资料]: (如果有的话)
  // [维护记录]: (类发布后，其修改需要记录下来：修改人、时间、主要原因内容)
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

  // 双端队列(Queue)的统一说明
  // ----------------------------------------------------------------------------
  // 作用描述: 容器配接器的一种，两端开口
  // 主要方法：Push方法：在容器后边压入一个元素
  // Pop方法：弹出最前面一个元素
  // Back方法：返回最后面元素的当前值
  // Front方法：返回最前面元素的当前值
  // Clear方法：清空容器中的数据
  // Size方法：返回容器中的元素个数
  // IsEmpty方法：判断容器是否为空
  // IsEquals方法：判断两个容器中的元素是否完全相等
  // Clone方法：创建一个新的容器，并拥有和自身一样的元素
  // Assign方法: 整个容器清空重新赋值
  // GetSelfObj方法：返回接口存在的原始对象(self指针)，内部使用
  // 使用方式：
  // 注意事项:
  // 作    者: HouSisong ，2004.08.31
  // [相关资料]: (如果有的话)
  // [维护记录]: (类发布后，其修改需要记录下来：修改人、时间、主要原因内容)
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

  // 优先级队列(PriorityQueue)的统一说明
  // ----------------------------------------------------------------------------
  // 作用描述: 容器配接器的一种
  // 主要方法：Push方法：向容器中压入一个元素
  // Pop方法：弹出最优先的一个元素
  // Top方法：返回最优先的值
  // Clear方法：清空容器中的数据
  // Size方法：返回容器中的元素个数
  // IsEmpty方法：判断容器是否为空
  // IsEquals方法：判断两个容器中的元素是否完全相等
  // Clone方法：创建一个新的容器，并拥有和自身一样的元素
  // Assign方法: 整个容器清空重新赋值
  // GetSelfObj方法：返回接口存在的原始对象(self指针)，内部使用
  // 使用方式：
  // 注意事项:
  // 作    者: HouSisong ，2005.03.26
  // [相关资料]: (如果有的话)
  // [维护记录]: (类发布后，其修改需要记录下来：修改人、时间、主要原因内容)
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

  // Set,MultiSet的统一说明
  // ----------------------------------------------------------------------------
  // 作用描述: 元素集合 (Set不允许有重复元素,MultiSet允许有重复元素)
  // 主要方法：(参见_IContainer的说明)
  // Count方法: 统计某元素的个数
  // Find方法: 查找某个元素的第一次出现位置
  // LowerBound方法: 返回某值的第一个可安插位置
  // UpperBound方法: 返回某值的最后一个可安插位置
  // EqualRange方法: 返回某值的可安插的第一个和最后一个位置
  // 使用方式：
  // 注意事项:
  // 作    者: HouSisong ，2004.09.08
  // [相关资料]: (如果有的话)
  // [维护记录]: (类发布后，其修改需要记录下来：修改人、时间、主要原因内容)
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

  // Map迭代器(Map Iterator)的统一说明
  // ----------------------------------------------------------------------------
  // 作用描述: 用来遍历map容器里面的元素
  // 主要方法：(参见对迭代器的统一说明)
  // Key属性：用来访问(只读)迭代器引用的键值
  // 使用方式：
  // 注意事项:
  // 作    者: HouSisong ，2004.09.09
  // [相关资料]: (如果有的话)
  // [维护记录]: (类发布后，其修改需要记录下来：修改人、时间、主要原因内容)
  // ----------------------------------------------------------------------------
  TMapIterator<KeyType, ValueType> = class(TIterator<ValueType>)
    function GetKey: KeyType; virtual; abstract;

    property Key: KeyType read GetKey;
  end;

  // Map,MultiMap的统一说明
  // ----------------------------------------------------------------------------
  // 作用描述: 键值/实值 映射 (Map不允许有键值重复,MultiMap允许有键值重复)
  // 主要方法：ItBegin方法：返回指向容器里第一个元素的 迭代器
  // ItEnd方法：返回指向容器里最后一个元素的后面一个位置的 迭代器
  // Clear方法：清空容器中的所有数据
  // Size方法：容器中的元素个数
  // IsEmpty方法：容器是否为空,返回值等价于(0=Size());
  // IsEquals方法：判断两个容器中的元素是否完全相等
  // GetSelfObj方法：返回接口存在的原始对象(self指针)，内部使用
  // Erase方法：  删除容器中值等于参数Value的元素，返回删除的元素个数
  // Erase方法：  从容器中删除迭代器指向的元素
  // Insert方法： 在容器指定位置插入一个或多个元素
  // Assign方法: 整个容器清空重新赋值
  // Clone方法：创建一个新的容器，并拥有和自身一样的元素
  // Count方法: 统计某键值的个数
  // Find方法: 查找某键值的第一次出现位置
  // LowerBound方法: 返回某键值的第一个可安插位置
  // UpperBound方法: 返回某键值的最后一个可安插位置
  // EqualRange方法: 返回某键值的可安插的第一个和最后一个位置
  // Items属性：以Key为序号的方式访问容器中的元素
  // 使用方式：
  // 注意事项:
  // 作    者: HouSisong ，2004.09.09
  // [相关资料]: (如果有的话)
  // [维护记录]: (类发布后，其修改需要记录下来：修改人、时间、主要原因内容)
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
  // // 迭代器类_TAbstractIterator
  // // ----------------------------------------------------------------------------
  // // 作用描述: 迭代器类的虚基类，实现TIterator接口
  // // 主要方法：参见接口单元对迭代器的说明
  // // 使用方式：
  // // 注意事项: 不要创建该类的实例
  // // 作    者: HouSisong, 2004.09.01
  // // [相关资料]: (如果有的话)
  // // [维护记录]: (类发布后，其修改需要记录下来：修改人、时间、主要原因内容)
  // // ----------------------------------------------------------------------------
  TAbstractIterator<ValueType> = class(TIterator<ValueType>)
    // 实现TIterator接口
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
