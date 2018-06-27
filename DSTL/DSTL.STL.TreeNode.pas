unit DSTL.STL.TreeNode;

interface

uses DSTL.Utils.Pair;

type
  TTreeNodeColor = (tncRed, tncBlack);

  TTreeNode<T1, T2> = class
  public
    Pair: TPair<T1, T2>;
    left, right, parent: TTreeNode<T1, T2>;
    color: TTreeNodeColor;

    constructor Create; overload;
    constructor Create(const Pair: TPair<T1, T2>); overload;
    constructor Create(const Pair: TPair<T1, T2>;
      parent: TTreeNode<T1, T2>); overload;
    constructor Create(const Pair: TPair<T1, T2>;
      left, right, parent: TTreeNode<T1, T2>); overload;
    destructor Destroy; override;
  end;

implementation

constructor TTreeNode<T1, T2>.Create;
begin
  Self.left := nil;
  Self.right := nil;
  Self.parent := nil;
  Self.color := tncBlack;
end;

constructor TTreeNode<T1, T2>.Create(const Pair: TPair<T1, T2>);
begin
  Self.Pair := Pair;
  Self.left := nil;
  Self.right := nil;
  Self.parent := nil;
  Self.color := tncBlack;
end;

constructor TTreeNode<T1, T2>.Create(const Pair: TPair<T1, T2>;
  parent: TTreeNode<T1, T2>);
begin
  Self.Pair := Pair;
  Self.left := nil;
  Self.right := nil;
  Self.parent := parent;
  Self.color := tncBlack;
end;

constructor TTreeNode<T1, T2>.Create(const Pair: TPair<T1, T2>;
  left, right, parent: TTreeNode<T1, T2>);
begin
  Self.Pair := Pair;
  Self.left := left;
  Self.right := right;
  Self.parent := parent;
  Self.color := tncBlack;
end;

destructor TTreeNode<T1, T2>.Destroy;
begin
  inherited;
end;

end.
