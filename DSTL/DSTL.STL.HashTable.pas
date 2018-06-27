unit DSTL.STL.HashTable;

interface
uses DSTL.STL.Iterator, DSTL.STL.Vector, DSTL.STL.HashNode, DSTL.Types, DSTL.Utils.Pair;

const
  NUM_PRIMES = 26;
  PRIME_LIST: array [1..NUM_PRIMES] of longint = (
    53,         97,         193,       389,       769,
    1543,       3079,       6151,      12289,     24593,
    49157,      98317,      196613,    393241,    786433,
    1572869,    3145739,    6291469,   12582917,  25165843,
    50331653,   100663319,  201326611, 402653189, 805306457,
    1610612741
  );

type

  THashType = integer;

  THasher<K> = function (key: K): THashType;
  TEqualKey<K> = function (key1, key2: K): boolean;
  TKeyExtractor<K, V> = function (obj: V): K;

  THashTable<K, V> = class(TContainer<K, V>)
  protected
    hash: THasher<K>;
    equals: TEqualKey<K>;
    get_key: TKeyExtractor<K, V>;

    buckets: TVector<THashNode<V>>;
    num_elements: TSizeType;

    procedure iadvance(var Iterator: TIterator<K, V>);  override;
    procedure initialize_buckets(n: TSizeType);
    function get_bucket(key: K; size: TSizeType): TSizeType;  overload;
    function get_bucket(obj: V; size: TSizeType): TSizeType;  overload;
    function get_bucket(key: K): TSizeType;  overload;
    function get_bucket(obj: V): TSizeType;  overload;
    function new_iterator(node: THashNode<V>): TIterator<K, V>;
    function new_node(obj: V): THashNode<V>;
  public
    constructor Create(n: TSizeType; hash_func: THasher<K>; eql: TEqualKey<K>);

    function bucket_count: TSizeType;
    class function max_bucket_size: TSizeType;
    procedure resize(num_elements: TSizeType);
    function insert_unique(obj: V): TPair<TIterator<K, V>, boolean>;
  end;

function next_prime(n: longint): longint;

implementation

function next_prime(n: longint): longint;
var
  i: integer;
begin
  for i := 1 to NUM_PRIMES do
  begin
    if PRIME_LIST[i] > n then
      exit(PRIME_LIST[i]);
  end;
  exit(PRIME_LIST[NUM_PRIMES]);
end;

constructor THashTable<K, V>.Create(n: TSizeType; hash_func: THasher<K>; eql: TEqualKey<K>);
begin
  self.hash := hash_func;
  self.equals := eql;
  self.initialize_buckets(n);
end;

procedure THashTable<K, V>.iadvance(var Iterator: TIterator<K, V>);
var
  ht: ^THashTable<K, V>;
begin
  ht := Iterator.ht;
  if Iterator.hnode.next <> nil then
  begin
    Iterator.hnode := Iterator.hnode.next;
    Iterator.handle := self;
    exit;
  end;
end;

procedure THashTable<K, V>.initialize_buckets(n: TSizeType);
begin
  buckets := TVector<THashNode<V>>.Create(next_prime(n), nil);
  num_elements := 0;
end;

function THashTable<K, V>.get_bucket(key: K; size: TSizeType): TSizeType;
begin
  exit(hash(key) mod size);
end;

function THashTable<K, V>.get_bucket(obj: V; size: TSizeType): TSizeType;
begin
  exit(hash(get_key(obj)) mod size);
end;

function THashTable<K, V>.get_bucket(key: K): TSizeType;
begin
  exit(hash(key) mod buckets.size);
end;

function THashTable<K, V>.get_bucket(obj: V): TSizeType;
begin
  exit(hash(get_key(obj)) mod buckets.size);
end;

function THashTable<K, V>.new_iterator(node: THashNode<V>): TIterator<K, V>;
var
  iter: TIterator<K, V>;
begin
  iter.hnode := node;
  iter.ht := self;
  iter.handle := self;
end;

function THashTable<K, V>.new_node(obj: V): THashNode<V>;
var
  node: THashNode<V>;
begin
  node := THashNode<V>.Create;
  node.value := obj;
  exit(node);
end;

function THashTable<K, V>.bucket_count: TSizeType;
begin
  exit(self.buckets.size);
end;

class function THashTable<K, V>.max_bucket_size: TSizeType;
begin
  exit(PRIME_LIST[NUM_PRIMES]);
end;

procedure THashTable<K, V>.resize(num_elements: TSizeType);
var
  old_size: TSizeType;
  n, bucket: TSizeType;
  tmp: TVector<THashNode<V>>;
  first: THashNode<V>;
  i: integer;
begin
  old_size := buckets.size;
  if num_elements > old_size then
  begin
    n := next_prime(num_elements);
    if n > old_size then
    begin
      tmp := TVector<THashNode<V>>.Create(n, nil);
      for i := 1 to old_size do
      begin
        first := buckets[i];
        while first <> nil do
        begin
          bucket := get_bucket(first.value, n);
          buckets[i] := first.next;
          first.next := tmp[bucket];
          tmp[bucket] := first;
          first := buckets[i];
        end;
      end;
      buckets.swap(tmp);
    end;
  end;
end;

function THashTable<K, V>.insert_unique(obj: V): TPair<TIterator<K, V>, boolean>;
var
  buc: TSizeType;
  first, cur: THashNode<V>;
  tmp: THashNode<V>;
begin
  resize(num_elements + 1);  // if we have enough space
  buc := get_bucket(obj);
  first := buckets[buc];
  cur := first;

  while cur <> nil do
  begin
    // exists
    if equals(get_key(cur.value), get_key(obj)) then exit(TPair<TIterator<K, V>, boolean>.Create(new_iterator(cur), false));
  end;
  tmp := new_node(obj);
  tmp.next := buckets[buc];
  buckets[buc] := tmp;
  inc(num_elements);
  exit(TPair<TIterator<K, V>, boolean>.Create(new_iterator(tmp), true);
end;

end.
