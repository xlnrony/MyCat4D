unit DSTL.STL.RBTree;

interface

uses
  SysUtils,
  DSTL.Utils.Pair, DSTL.Utils.Range,
  DSTL.STL.Iterator, DSTL.STL.TreeNode,
  Generics.Defaults;

type
  TRedBlackTree<K, V> = class
  protected
    FContainer: TContainer<K, V>;
    FHeader: TTreeNode<K, V>;
    FComparator: IComparer<K>;
    FNodeCount: Integer;
    FInsertAlways: Boolean;

    procedure RBInitNil;
    function RBMinimum(node: TTreeNode<K, V>): TTreeNode<K, V>;
    function RBMaximum(node: TTreeNode<K, V>): TTreeNode<K, V>;
    procedure RBLeftRotate(node: TTreeNode<K, V>);
    procedure RBRightRotate(node: TTreeNode<K, V>);
    procedure RBinsert(insertToLeft: Boolean; x, y, z: TTreeNode<K, V>);
    function RBErase(z: TTreeNode<K, V>): TTreeNode<K, V>;

    function RBInternalInsert(x, y: TTreeNode<K, V>;
      const Pair: TPair<K, V>): Boolean;
    procedure RBInitializeRoot;
    procedure RBInitializeHeader;
    procedure RBInitialize;
    function RBCopyTree(oldNode, parent: TTreeNode<K, V>): TTreeNode<K, V>;
    procedure RBCopy(tree: TRedBlackTree<K, V>);
    procedure RBEraseTree(node: TTreeNode<K, V>; direct: Boolean);
  public
    constructor Create(insideOf: TContainer<K, V>; always: Boolean;
      compare: IComparer<K>);
    destructor Destroy; override;

    function start: TIterator<K, V>;
    function finish: TIterator<K, V>;

    function empty: Boolean;
    function size: Integer;
    function maxSize: Integer;

    procedure swap(another: TRedBlackTree<K, V>);

    procedure RBIncrement(var node: TTreeNode<K, V>);
    procedure RBDecrement(var node: TTreeNode<K, V>);

    function insert(const Pair: TPair<K, V>): Boolean;
    function insertAt(pos: TIterator<K, V>; const Pair: TPair<K, V>): Boolean;
    function insertIn(_start, _finish: TIterator<K, V>): Boolean;

    procedure erase(direct: Boolean);
    procedure eraseAt(pos: TIterator<K, V>);
    function eraseKeyN(const obj: K; count: Integer): Integer;
    function eraseKey(const obj: K): Integer;
    function eraseIn(_start, _finish: TIterator<K, V>): Integer;

    function find(const obj: K): TIterator<K, V>;
    function count(const obj: K): Integer;
    function lower_bound(const obj: K): TIterator<K, V>;
    function upper_bound(const obj: K): TIterator<K, V>;
    function equal_range(const obj: K): TRange<K, V>;

    function StartNode: TTreeNode<K, V>;
    function EndNode: TTreeNode<K, V>;

  end;

implementation

constructor TRedBlackTree<K, V>.Create(insideOf: TContainer<K, V>;
  always: Boolean; compare: IComparer<K>);
begin
  FNodeCount := 0;
  FContainer := insideOf;
  FInsertAlways := always;
  FComparator := compare;
  RBInitialize;
end;

destructor TRedBlackTree<K, V>.Destroy;
begin
  erase(false);
  inherited;
end;

function TRedBlackTree<K, V>.start: TIterator<K, V>;
begin
  Result.handle := Self.FContainer;
  Result.node := FHeader.left;
end;

function TRedBlackTree<K, V>.finish: TIterator<K, V>;
begin
  Result.handle := Self.FContainer;
  Result.node := FHeader;
end;

function TRedBlackTree<K, V>.RBCopyTree(oldNode, parent: TTreeNode<K, V>)
  : TTreeNode<K, V>;
begin
  if oldNode = nil then
    result := nil
  else
  begin
    result := TTreeNode<K, V>.Create(oldNode.Pair);
    result.parent := parent;
    result.left := RBCopyTree(oldNode.left, result);
    result.right := RBCopyTree(oldNode.right, result);
    result.color := oldNode.color;
  end;
end;

procedure TRedBlackTree<K, V>.RBCopy(tree: TRedBlackTree<K, V>);
begin
  FHeader.parent := RBCopyTree(tree.FHeader.parent, FHeader);
  FHeader.left := RBMinimum(tree.FHeader.parent);
  FHeader.right := RBMaximum(tree.FHeader.parent);
  FNodeCount := tree.FNodeCount;
end;

function TRedBlackTree<K, V>.empty: Boolean;
begin
  result := FNodeCount = 0;
end;

function TRedBlackTree<K, V>.size: Integer;
begin
  result := FNodeCount;
end;

function TRedBlackTree<K, V>.maxSize: Integer;
begin
  result := MaxInt;
end;

procedure TRedBlackTree<K, V>.swap(another: TRedBlackTree<K, V>);
var
  tb: Boolean;
  ti: Integer;
  tn: TTreeNode<K, V>;
  tc: IComparer<K>;
begin
  tn := FHeader;
  FHeader := another.FHeader;
  another.FHeader := tn;

  ti := FNodeCount;
  FNodeCount := another.FNodeCount;
  another.FNodeCount := ti;

  tb := FInsertAlways;
  FInsertAlways := another.FInsertAlways;
  another.FInsertAlways := tb;

  tc := FComparator;
  FComparator := another.FComparator;
  another.FComparator := tc;

end;

function TRedBlackTree<K, V>.RBInternalInsert(x, y: TTreeNode<K, V>;
  const Pair: TPair<K, V>): Boolean;
var
  z: TTreeNode<K, V>;
  toLeft: Boolean;
begin
  Inc(FNodeCount);

  z := TTreeNode<K, V>.Create(Pair);

  toLeft := (y = FHeader) or (x <> nil) or
    (FComparator.compare(z.Pair.first, y.Pair.first) < 0);

  RBinsert(toLeft, x, y, z);

  result := True;
end;

function TRedBlackTree<K, V>.insert(const Pair: TPair<K, V>): Boolean;
var
  x, y: TTreeNode<K, V>;
  cmp: Integer;
  comp: Boolean;
  j: TTreeNode<K, V>;
begin

  result := True;

  y := FHeader;
  x := FHeader.parent;
  comp := True;

  while x <> nil do
  begin
    y := x;

    cmp := FComparator.compare(Pair.first, x.Pair.first);
    if (cmp = 0) and (not FInsertAlways) then
    begin
      //x.Pair.second := Pair.second;
      Exit(false);
    end;

    comp := cmp < 0;
    if comp then
      x := x.left
    else
      x := x.right;
  end;

  if FInsertAlways then
  begin
    RBInternalInsert(x, y, Pair);
    Exit;
  end;

  j := y;

  if comp then
  begin
    if j = FHeader.left then
    begin
      RBInternalInsert(x, y, Pair);
      Exit;
    end
    else
      RBDecrement(j);
  end;

  if FComparator.compare(j.Pair.first, Pair.first) < 0 then
    RBInternalInsert(x, y, Pair)
  else
    result := false;
end;

function TRedBlackTree<K, V>.insertAt(pos: TIterator<K, V>;
  const Pair: TPair<K, V>): Boolean;
begin
  raise Exception.Create('Can''t insert to iterator in tree.');
end;

function TRedBlackTree<K, V>.insertIn(_start, _finish: TIterator<K, V>)
  : Boolean;
var
  Pair: TPair<K, V>;
  io: TIterOperations<K, V>;
begin
  result := True;
  while not io.equals(_start, finish) do
  begin
    Pair.first := io.get(_start).first;
    Pair.second := io.get(_start).second;
    result := result and insert(Pair);
    io.advance(_start);
  end;
end;

procedure TRedBlackTree<K, V>.RBEraseTree(node: TTreeNode<K, V>;
  direct: Boolean);
begin
  if node <> nil then
  begin
    RBEraseTree(node.left, direct);
    RBEraseTree(node.right, direct);

    node.free;
  end;
end;

procedure TRedBlackTree<K, V>.erase(direct: Boolean);
begin
  RBEraseTree(FHeader.parent, direct);
  FHeader.left := FHeader;
  FHeader.parent := nil;
  FHeader.right := FHeader;
  FNodeCount := 0;
end;

procedure TRedBlackTree<K, V>.eraseAt(pos: TIterator<K, V>);
var
  node: TTreeNode<K, V>;
begin
  node := RBErase(pos.node);
  Dec(FNodeCount);
  node.free;
end;

function TRedBlackTree<K, V>.eraseKeyN(const obj: K; count: Integer): Integer;
var
  p: TRange<K, V>;
  io: TIterOperations<K, V>;
  i: integer;
begin
  p := equal_range(obj);

  if p.start.node = p.finish.node then
    result := 0
  else
  begin
    if count <> MaxInt then
    begin
      result := io.distance(p.start, p.finish);
      if result > count then
      begin
        for i := 1 to result - count do
          io.retreat(p.finish);
      end;
    end;
    result := eraseIn(p.start, p.finish);
  end;
end;

function TRedBlackTree<K, V>.eraseKey(const obj: K): Integer;
begin
  result := eraseKeyN(obj, MaxInt);
end;

function TRedBlackTree<K, V>.eraseIn(_start, _finish: TIterator<K, V>): Integer;
var
  iter: TIterator<K, V>;
  io: TIterOperations<K, V>;
begin
  result := 0;
  if io.equals(_start, start) and io.equals(_finish, finish) then
    erase(false)
  else
  begin
    while not io.equals(_start, _finish) do
    begin
      iter := _start;
      io.advance(iter);
      eraseAt(_start);
      Inc(result);
      _start := iter;
    end;
  end;
end;

function TRedBlackTree<K, V>.find(const obj: K): TIterator<K, V>;
var
  j: TIterator<K, V>;
  io: TIterOperations<K, V>;
begin
  j := lower_bound(obj);
  if io.at_end(j) or (FComparator.Compare(obj, j.node.Pair.first) < 0) then
    result := finish
  else
    result := j;
end;

function TRedBlackTree<K, V>.count(const obj: K): Integer;
var
  r: TRange<K, V>;
  io: TIterOperations<K, V>;
begin
  r := equal_range(obj);
  io := TIterOperations<K, V>.Create;
  result := io.distance(r.start, r.finish);
end;

function TRedBlackTree<K, V>.lower_bound(const obj: K): TIterator<K, V>;
var
  x, y: TTreeNode<K, V>;
  comp: Boolean;
  io: TIterOperations<K, V>;
begin

  y := FHeader;
  x := FHeader.parent;
  comp := false;

  while x <> nil do
  begin
    y := x;
    comp := FComparator.Compare(x.Pair.first, obj) < 0;
    if comp then
      x := x.right
    else
      x := x.left;
  end;

  result := start;

  if not io.at_end(result) then
  begin
    result.node := y;
    if start.node <> result.node then ;
    if finish.node = result.node then ;

    if comp then
      io.advance(result);
  end;
end;

function TRedBlackTree<K, V>.upper_bound(const obj: K): TIterator<K, V>;
var
  x, y: TTreeNode<K, V>;
  comp: Boolean;
  io: TIterOperations<K, V>;
begin
  y := FHeader;
  x := y.parent;
  comp := True;

  while x <> nil do
  begin
    y := x;
    comp := FComparator.Compare(obj, x.Pair.first) < 0;
    if comp then
      x := x.left
    else
      x := x.right;
  end;

  result := start;
  if not io.at_end(result) then
  begin
    result.node := y;

    if start.node <> result.node then ;
    if finish.node = result.node then ;

    if not comp then
      io.advance(result);
  end;
end;

function TRedBlackTree<K, V>.equal_range(const obj: K): TRange<K, V>;
begin
  Result.start := lower_bound(obj);
  Result.finish := upper_bound(obj);
end;

procedure TRedBlackTree<K, V>.RBInitializeRoot;
begin
  RBInitNil;
  FHeader.parent := nil;
  FHeader.left := FHeader;
  FHeader.right := FHeader;
end;

procedure TRedBlackTree<K, V>.RBInitializeHeader;
begin
  FHeader := TTreeNode<K, V>.Create;
  FHeader.color := tncRed;
end;

procedure TRedBlackTree<K, V>.RBInitialize;
begin
  RBInitializeHeader;
  RBInitializeRoot;
end;

procedure TRedBlackTree<K, V>.RBInitNil;
begin

end;

procedure TRedBlackTree<K, V>.RBIncrement(var node: TTreeNode<K, V>);
var
  y: TTreeNode<K, V>;
begin

  if node.right <> nil then
  begin
    node := node.right;
    while node.left <> nil do
      node := node.left;
  end
  else
  begin
    y := node.parent;
    while node = y.right do
    begin
      node := y;
      y := y.parent;
    end;
    if node.right <> y then
      node := y;
  end;
end;

procedure TRedBlackTree<K, V>.RBDecrement(var node: TTreeNode<K, V>);
var
  y: TTreeNode<K, V>;
begin

  if (node.color = tncRed) and (node.parent.parent = node) then
    node := node.right
  else if node.left <> nil then
  begin
    y := node.left;
    while y.right <> nil do
      y := y.right;
    node := y;
  end
  else
  begin
    y := node.parent;
    while node = y.left do
    begin
      node := y;
      y := y.parent;
    end;
    node := y;
  end;
end;

function TRedBlackTree<K, V>.RBMinimum(node: TTreeNode<K, V>): TTreeNode<K, V>;
begin
  if node = nil then
    result := FHeader
  else
  begin
    while node.left <> nil do
      node := node.left;
    result := node;
  end;
end;

function TRedBlackTree<K, V>.RBMaximum(node: TTreeNode<K, V>): TTreeNode<K, V>;
begin
  if node = nil then
    result := FHeader
  else
  begin
    while node.right <> nil do
      node := node.right;
    result := node;
  end;
end;

procedure TRedBlackTree<K, V>.RBLeftRotate(node: TTreeNode<K, V>);
var
  y: TTreeNode<K, V>;
begin
  y := node.right;
  node.right := y.left;
  if y.left <> nil then
    y.left.parent := node;
  y.parent := node.parent;
  if node = FHeader.parent then
    FHeader.parent := y
  else if node = node.parent.left then
    node.parent.left := y
  else
    node.parent.right := y;

  y.left := node;
  node.parent := y;

end;

procedure TRedBlackTree<K, V>.RBRightRotate(node: TTreeNode<K, V>);
var
  y: TTreeNode<K, V>;
begin
  y := node.left;
  node.left := y.right;
  if y.right <> nil then
    y.right.parent := node;
  y.parent := node.parent;

  if node = FHeader.parent then
    FHeader.parent := y
  else if node = node.parent.right then
    node.parent.right := y
  else
    node.parent.left := y;

  y.right := node;
  node.parent := y;

end;

procedure TRedBlackTree<K, V>.RBinsert(insertToLeft: Boolean;
  x, y, z: TTreeNode<K, V>);
begin

  if insertToLeft then
  begin
    y.left := z;
    if y = FHeader then
    begin
      FHeader.parent := z;
      FHeader.right := z;
    end
    else if y = FHeader.left then
      FHeader.left := z;
  end
  else
  begin
    y.right := z;
    if y = FHeader.right then
      FHeader.right := z;
  end;

  z.parent := y;
  z.left := nil;
  z.right := nil;
  x := z;
  x.color := tncRed;

  while (x <> FHeader.parent) and (x.parent.color = tncRed) do
  begin
    if x.parent = x.parent.parent.left then
    begin
      y := x.parent.parent.right;
      if y.color = tncRed then
      begin
        x.parent.color := tncBlack;
        y.color := tncBlack;
        x.parent.parent.color := tncRed;
        x := x.parent.parent;
      end
      else
      begin
        if x = x.parent.right then
        begin
          x := x.parent;
          RBLeftRotate(x);
        end;
        x.parent.color := tncBlack;
        x.parent.parent.color := tncRed;
        RBRightRotate(x.parent.parent);
      end;
    end
    else
    begin
      y := x.parent.parent.left;
      if y.color = tncRed then
      begin
        x.parent.color := tncBlack;
        y.color := tncBlack;
        x.parent.parent.color := tncRed;
        x := x.parent.parent;
      end
      else
      begin
        if x = x.parent.left then
        begin
          x := x.parent;
          RBRightRotate(x);
        end;
        x.parent.color := tncBlack;
        x.parent.parent.color := tncRed;
        RBLeftRotate(x.parent.parent);

      end;
    end;
  end;
  FHeader.parent.color := tncBlack;

end;

function TRedBlackTree<K, V>.RBErase(z: TTreeNode<K, V>): TTreeNode<K, V>;
var
  w, x, y: TTreeNode<K, V>;
  tmp: TTreeNodeColor;
begin
  y := z;

  if y.left = nil then
    x := y.right
  else if y.right = nil then
    x := y.left
  else
  begin
    y := y.right;
    while y.left <> nil do
      y := y.left;
    x := y.right;
  end;

  // No way should x be the nil_node at this point.
  // assert(x <> nil_node);

  if y <> z then
  begin
    z.left.parent := y;
    y.left := z.left;
    if y <> z.right then
    begin
      x.parent := y.parent;
      y.parent.left := x;
      y.right := z.right;
      z.right.parent := y;
    end
    else
      x.parent := y;

    if FHeader.parent = z then
      FHeader.parent := y
    else if z.parent.left = z then
      z.parent.left := y
    else
      z.parent.right := y;

    y.parent := z.parent;
    tmp := y.color;
    y.color := z.color;
    z.color := tmp;
    y := z;

  end
  else
  begin
    x.parent := y.parent;
    if FHeader.parent = z then
      FHeader.parent := x
    else if z.parent.left = z then
      z.parent.left := x
    else
      z.parent.right := x;

    if FHeader.left = z then
      if z.right = nil then
        FHeader.left := z.parent
      else
        FHeader.left := RBMinimum(x);

    if FHeader.right = z then
      if z.left = nil then
        FHeader.right := z.parent
      else
        FHeader.right := RBMaximum(x);

  end;

  if y.color <> tncRed then
  begin
    while (x <> FHeader.parent) and (x.color = tncBlack) do
    begin

      if x = x.parent.left then
      begin
        w := x.parent.right;
        if w.color = tncRed then
        begin
          w.color := tncBlack;
          x.parent.color := tncRed;
          RBLeftRotate(x.parent);
          w := x.parent.right;
        end;

        if (w.left.color = tncBlack) and (w.right.color = tncBlack) then
        begin
          w.color := tncRed;
          x := x.parent;
        end
        else
        begin
          if w.right.color = tncBlack then
          begin
            w.left.color := tncBlack;
            w.color := tncRed;
            RBRightRotate(w);
            w := x.parent.right;
          end;

          w.color := x.parent.color;
          x.parent.color := tncBlack;
          w.right.color := tncBlack;
          RBLeftRotate(x.parent);
          break;
        end;

      end
      else
      begin
        w := x.parent.left;
        if w.color = tncRed then
        begin
          w.color := tncBlack;
          x.parent.color := tncRed;
          RBRightRotate(x.parent);
          w := x.parent.left; // TODO: w becomes nil_node?
        end;

        if (w.right.color = tncBlack) and (w.left.color = tncBlack) then
        begin
          w.color := tncRed;
          x := x.parent;
        end
        else
        begin
          if w.left.color = tncBlack then
          begin
            w.right.color := tncBlack;
            w.color := tncRed;
            RBLeftRotate(w);
            w := x.parent.left;
          end;
          w.color := x.parent.color;
          x.parent.color := tncBlack;
          w.left.color := tncBlack;
          RBRightRotate(x.parent);
          break;
        end;
      end;

    end;
    x.color := tncBlack;
  end;

  result := y;

end;

function TRedBlackTree<K, V>.StartNode: TTreeNode<K, V>;
begin
  result := FHeader.left;
end;

function TRedBlackTree<K, V>.EndNode: TTreeNode<K, V>;
begin
  result := FHeader;
end;

end.
