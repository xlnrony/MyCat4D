unit DSTL.STL.HashNode;

interface

type
  THashNode<T> = class
    value: T;
    next: THashNode<T>;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

constructor THashNode<T>.Create;
begin
  self.next := nil;
end;

destructor THashNode<T>.Destroy;
begin
end;

end.
