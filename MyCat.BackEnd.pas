unit MyCat.BackEnd;

interface

uses
  MyCat.Net.CrossSocket.Base, MyCat.Generics.ICrossConnection,
  MyCat.BackEnd.Mysql.CrossSocket.Handler.ResponseHandler;

type
  IBackEndConnection = interface(ICrossConnection)
    ['{534E64EC-D095-4CC2-B55E-99FE8AACE0C4}']
    function IsModifiedSQLExecuted: Boolean;
    function IsFromSlaveDB: Boolean;
    function GetSchema: string;
    procedure SetSchema(newSchema: string);
    function GetLastTime: Int64;
    function IsClosedOrQuit: Boolean;
    procedure SetAttachment(attachment: TObject);
    procedure Quit;
    procedure SetLastTime(currentTimeMillis: Int64);
    procedure Release;
    function SetResponseHandler(CommandHandler: IResponseHandler): Boolean;
    procedure Commit();
    procedure Query(sql: string);
    function GetAttachment: TObject;
    // procedure execute(node: RouteResultsetNode; source: ServerConnection;
    // autocommit: Boolean);
    procedure RecordSql(host: String; schema: String; statement: String);
    function SyncAndExcute: Boolean;
    procedure Rollback;
    function GetBorrowed: Boolean;
    procedure SetBorrowed(Borrowed: Boolean);
    function GetTxIsolation: Integer;
    function IsAutocommit: Boolean;
    function GetId: Int64;
    procedure DiscardClose(reason: string);

    property Borrowed: Boolean read GetBorrowed write SetBorrowed;
    property schema: string read GetSchema write SetSchema;
  end;

  TConQueue = class
  private
    FAutoCommitCons: TCrossConnectionList;
    FManCommitCons: TCrossConnectionList;
    FExecuteCount: Int64;
  public
    constructor Create;

    function TakeIdleCon(AutoCommit: Boolean): ICrossConnection;
    function GetExecuteCount: Int64;
    procedure IncExecuteCount;
    function RemoveConnection(Connection: ICrossConnection): Boolean;
  end;
  // public class ConQueue {
  //
  // public BackendConnection takeIdleCon(boolean autoCommit) {
  // }
  //
  // public long getExecuteCount() {
  // }
  //
  // public void incExecuteCount() {
  // }
  //
  // public boolean removeCon(BackendConnection con) {
  // }
  //
  // public boolean isSameCon(BackendConnection con) {
  // if (autoCommitCons.contains(con)) {
  // return true;
  // } else if (manCommitCons.contains(con)) {
  // return true;
  // }
  // return false;
  // }
  //
  // public ConcurrentLinkedQueue<BackendConnection> getAutoCommitCons() {
  // return autoCommitCons;
  // }
  //
  // public ConcurrentLinkedQueue<BackendConnection> getManCommitCons() {
  // return manCommitCons;
  // }
  //
  // public ArrayList<BackendConnection> getIdleConsToClose(int count) {
  // ArrayList<BackendConnection> readyCloseCons = new ArrayList<BackendConnection>(
  // count);
  // while (!manCommitCons.isEmpty() && readyCloseCons.size() < count) {
  // BackendConnection theCon = manCommitCons.poll();
  // if (theCon != null&&!theCon.isBorrowed()) {
  // readyCloseCons.add(theCon);
  // }
  // }
  // while (!autoCommitCons.isEmpty() && readyCloseCons.size() < count) {
  // BackendConnection theCon = autoCommitCons.poll();
  // if (theCon != null&&!theCon.isBorrowed()) {
  // readyCloseCons.add(theCon);
  // }
  //
  // }
  // return readyCloseCons;
  // }
  //
  // }

  TConMap = class
  private

  public
  end;
  // public class ConMap {
  //
  // // key -schema
  // private final ConcurrentHashMap<String, ConQueue> items = new ConcurrentHashMap<String, ConQueue>();
  //
  // public ConQueue getSchemaConQueue(String schema) {
  // ConQueue queue = items.get(schema);
  // if (queue == null) {
  // ConQueue newQueue = new ConQueue();
  // queue = items.putIfAbsent(schema, newQueue);
  // return (queue == null) ? newQueue : queue;
  // }
  // return queue;
  // }
  //
  // public BackendConnection tryTakeCon(final String schema, boolean autoCommit) {
  // final ConQueue queue = items.get(schema);
  // BackendConnection con = tryTakeCon(queue, autoCommit);
  // if (con != null) {
  // return con;
  // } else {
  // for (ConQueue queue2 : items.values()) {
  // if (queue != queue2) {
  // con = tryTakeCon(queue2, autoCommit);
  // if (con != null) {
  // return con;
  // }
  // }
  // }
  // }
  // return null;
  //
  // }
  //
  // private BackendConnection tryTakeCon(ConQueue queue, boolean autoCommit) {
  //
  // BackendConnection con = null;
  // if (queue != null && ((con = queue.takeIdleCon(autoCommit)) != null)) {
  // return con;
  // } else {
  // return null;
  // }
  //
  // }
  //
  // public Collection<ConQueue> getAllConQueue() {
  // return items.values();
  // }
  //
  // public int getActiveCountForSchema(String schema,
  // PhysicalDatasource dataSouce) {
  // int total = 0;
  // for (NIOProcessor processor : MycatServer.getInstance().getProcessors()) {
  // for (BackendConnection con : processor.getBackends().values()) {
  // if (con instanceof MySQLConnection) {
  // MySQLConnection mysqlCon = (MySQLConnection) con;
  //
  // if (mysqlCon.getSchema().equals(schema)
  // && mysqlCon.getPool() == dataSouce
  // && mysqlCon.isBorrowed()) {
  // total++;
  // }
  //
  // }else if (con instanceof JDBCConnection) {
  // JDBCConnection jdbcCon = (JDBCConnection) con;
  // if (jdbcCon.getSchema().equals(schema) && jdbcCon.getPool() == dataSouce
  // && jdbcCon.isBorrowed()) {
  // total++;
  // }
  // }
  // }
  // }
  // return total;
  // }
  //
  // public int getActiveCountForDs(PhysicalDatasource dataSouce) {
  // int total = 0;
  // for (NIOProcessor processor : MycatServer.getInstance().getProcessors()) {
  // for (BackendConnection con : processor.getBackends().values()) {
  // if (con instanceof MySQLConnection) {
  // MySQLConnection mysqlCon = (MySQLConnection) con;
  //
  // if (mysqlCon.getPool() == dataSouce
  // && mysqlCon.isBorrowed() && !mysqlCon.isClosed()) {
  // total++;
  // }
  //
  // } else if (con instanceof JDBCConnection) {
  // JDBCConnection jdbcCon = (JDBCConnection) con;
  // if (jdbcCon.getPool() == dataSouce
  // && jdbcCon.isBorrowed() && !jdbcCon.isClosed()) {
  // total++;
  // }
  // }
  // }
  // }
  // return total;
  // }
  //
  // public void clearConnections(String reason, PhysicalDatasource dataSouce) {
  // for (NIOProcessor processor : MycatServer.getInstance().getProcessors()) {
  // ConcurrentMap<Long, BackendConnection> map = processor.getBackends();
  // Iterator<Entry<Long, BackendConnection>> itor = map.entrySet().iterator();
  // while (itor.hasNext()) {
  // Entry<Long, BackendConnection> entry = itor.next();
  // BackendConnection con = entry.getValue();
  // if (con instanceof MySQLConnection) {
  // if (((MySQLConnection) con).getPool() == dataSouce) {
  // con.close(reason);
  // itor.remove();
  // }
  // }else if((con instanceof JDBCConnection)
  // && (((JDBCConnection) con).getPool() == dataSouce)){
  // con.close(reason);
  // itor.remove();
  // }
  // }
  //
  // }
  // items.clear();
  // }
  // }

implementation

{ TConQueue }

constructor TConQueue.Create;
begin
  FAutoCommitCons := TCrossConnectionList.Create;
  FManCommitCons := TCrossConnectionList.Create;
end;

function TConQueue.GetExecuteCount: Int64;
begin
  Result := FExecuteCount;
end;

procedure TConQueue.IncExecuteCount;
begin
  Inc(FExecuteCount);
end;

function TConQueue.RemoveConnection(Connection: ICrossConnection): Boolean;
var
  Count: Integer;
begin
  TMonitor.Enter(FAutoCommitCons);
  try
    Count := FAutoCommitCons.EraseValue(Connection);
  finally
    TMonitor.Exit(FAutoCommitCons);
  end;
  if Count = 0 then
  begin
    TMonitor.Enter(FManCommitCons);
    try
      Count := FManCommitCons.EraseValue(Connection);
    finally
      TMonitor.Exit(FManCommitCons);
    end;
  end;
  Result := Count <> 0;
end;

function TConQueue.TakeIdleCon(AutoCommit: Boolean): ICrossConnection;
var
  List1: TCrossConnectionList;
  List2: TCrossConnectionList;
begin
  if AutoCommit then
  begin
    List1 := FAutoCommitCons;
    List2 := FManCommitCons;
  end
  else
  begin
    List1 := FManCommitCons;
    List2 := FAutoCommitCons;
  end;
  TMonitor.Enter(List1);
  try
    Result := List1.Front;
    List1.PopFront;
  finally
    TMonitor.Exit(List1);
  end;
  if (Result = nil) or (Result.ConnectStatus in [csDisconnected, csClosed]) then
  begin
    TMonitor.Enter(List2);
    try
      Result := List2.Front;
      List2.PopFront;
    finally
      TMonitor.Exit(List2);
    end;
  end;
  if Result.ConnectStatus in [csDisconnected, csClosed] then
  begin
    Result := nil;
  end;
end;

end.
