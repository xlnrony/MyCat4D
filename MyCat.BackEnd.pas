unit MyCat.BackEnd;

interface

uses
  System.SysUtils, MyCat.Net.CrossSocket.Base, MyCat.BackEnd.Interfaces,
  MyCat.BackEnd.Generics.BackEndConnection,
  MyCat.BackEnd.Generics.HeartBeatConnection, MyCat.Statistic,
  MyCat.Config.Model;

type

  // *
  // * heartbeat check for mysql connections
  // *
  TConnectionHeartBeatHandler = class(TInterfacedObject, IResponseHandler)
  private
    FAllConnections: IHeartBeatConnectionMap;

   private void executeException(BackendConnection c, Throwable e) {
   removeFinished(c);
   LOGGER.warn("executeException   ", e);
   c.close("heatbeat exception:" + e);

   }

  public
    constructor Create;

    procedure DoHeartBeat(Connection: IBackEndConnection; sql: string);

    // *
    // * remove timeout connections
    // *
    procedure AbandTimeOuttedConns();

    // *
    // * 无法获取连接
    // *
    // * @param e
    // * @param conn
    // *
    procedure ConnectionError(E: Exception; Connection: IBackEndConnection);

    // *
    // * 已获得有效连接的响应处理
    // *
    procedure ConnectionAcquired(Connection: IBackEndConnection);

    // *
    // * 收到错误数据包的响应处理
    // *
    procedure ErrorResponse(Err: TBytes; Connection: IBackEndConnection);

    // *
    // * 收到OK数据包的响应处理
    // *
    procedure OkResponse(OK: TBytes; Connection: IBackEndConnection);

    // *
    // * 收到字段数据包结束的响应处理
    // *
    procedure FieldEofResponse(Header: TBytes; Fields: TArray<TBytes>;
      Eof: TBytes; Connection: IBackEndConnection);

    // *
    // * 收到行数据包的响应处理
    // *
    procedure RowResponse(Row: TBytes; Connection: IBackEndConnection);

    // *
    // * 收到行数据包结束的响应处理
    // *
    procedure RowEofResponse(Eof: TBytes; Connection: IBackEndConnection);

    // *
    // * 写队列为空，可以写数据了
    // *
    procedure WriteQueueAvailable;

    // *
    // * on connetion close event
    // *
    procedure ConnectionClose(Connection: IBackEndConnection; reason: string);
  end;

  // public class ConnectionHeartBeatHandler implements ResponseHandler {
  //
  // public void doHeartBeat(BackendConnection conn, String sql) {
  // }
  //
  // /**
  // * remove timeout connections
  // */
  // public void abandTimeOuttedConns() {
  // }
  //
  // @Override
  // public void connectionAcquired(BackendConnection conn) {
  // // not called
  // }
  //
  // @Override
  // public void connectionError(Throwable e, BackendConnection conn) {
  // // not called
  //
  // }
  //
  // @Override
  // public void errorResponse(byte[] data, BackendConnection conn) {
  // removeFinished(conn);
  // ErrorPacket err = new ErrorPacket();
  // err.read(data);
  // LOGGER.warn("errorResponse " + err.errno + " "
  // + new String(err.message));
  // conn.release();
  //
  // }
  //
  // @Override
  // public void okResponse(byte[] ok, BackendConnection conn) {
  // boolean executeResponse = conn.syncAndExcute();
  // if (executeResponse) {
  // removeFinished(conn);
  // conn.release();
  // }
  //
  // }
  //
  // @Override
  // public void rowResponse(byte[] row, BackendConnection conn) {
  // }
  //
  // @Override
  // public void rowEofResponse(byte[] eof, BackendConnection conn) {
  // removeFinished(conn);
  // conn.release();
  // }
  //
  //
  // private void removeFinished(BackendConnection con) {
  // Long id = ((BackendConnection) con).getId();
  // this.allCons.remove(id);
  // }
  //
  // @Override
  // public void writeQueueAvailable() {
  //
  // }
  //
  // @Override
  // public void connectionClose(BackendConnection conn, String reason) {
  // removeFinished(conn);
  // LOGGER.warn("connection closed " + conn + " reason:" + reason);
  // }
  //
  // @Override
  // public void fieldEofResponse(byte[] header, List<byte[]> fields,
  // byte[] eof, BackendConnection conn) {
  // if (LOGGER.isDebugEnabled()) {
  // LOGGER.debug("received field eof  from " + conn);
  // }
  // }
  //
  // }
  //

  TConnectionQueue = class
  private
    FAutoCommitCons: TBackEndConnectionList;
    FManCommitCons: TBackEndConnectionList;
    FExecuteCount: Int64;
  public
    constructor Create;

    function TakeIdleCon(AutoCommit: Boolean): IBackEndConnection;
    function GetExecuteCount: Int64;
    procedure IncExecuteCount;
    function RemoveConnection(Connection: IBackEndConnection): Boolean;
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

type
  TDBHeartbeat = class
  public const
    DB_SYN_ERROR: Integer = -1;
    DB_SYN_NORMAL: Integer = 1;

    OK_STATUS: Integer = 1;
    ERROR_STATUS: Integer = -1;
    TIMEOUT_STATUS: Integer = -2;
    INIT_STATUS: Integer = 0;
  private const
    DEFAULT_HEARTBEAT_TIMEOUT: Int64 = 30 * 1000;
    DEFAULT_HEARTBEAT_RETRY: Integer = 10;
  protected
    // heartbeat config
    FHeartbeatTimeout: Int64; // 心跳超时时间
    FHeartbeatRetry: Integer; // 检查连接发生异常到切换，重试次数
    FHeartbeatSQL: string; // 静态心跳语句
    FIsStop: Boolean;
    FIsChecking: Boolean;
    FErrorCount: Integer;
    FStatus: Integer;
    FRecorder: THeartbeatRecorder;
    FAsynRecorder: TDataSourceSyncRecorder;
  public
    constructor Create;
  end;
  //
  // private volatile Integer slaveBehindMaster;
  // private volatile int dbSynStatus = DB_SYN_NORMAL;
  //
  // public Integer getSlaveBehindMaster() {
  // return slaveBehindMaster;
  // }
  //
  // public int getDbSynStatus() {
  // return dbSynStatus;
  // }
  //
  // public void setDbSynStatus(int dbSynStatus) {
  // this.dbSynStatus = dbSynStatus;
  // }
  //
  // public void setSlaveBehindMaster(Integer slaveBehindMaster) {
  // this.slaveBehindMaster = slaveBehindMaster;
  // }
  //
  // public int getStatus() {
  // return status;
  // }
  //
  // public boolean isChecking() {
  // return isChecking.get();
  // }
  //
  // public abstract void start();
  //
  // public abstract void stop();
  //
  // public boolean isStop() {
  // return isStop.get();
  // }
  //
  // public int getErrorCount() {
  // return errorCount.get();
  // }
  //
  // public HeartbeatRecorder getRecorder() {
  // return recorder;
  // }
  //
  // public abstract String getLastActiveTime();
  //
  // public abstract long getTimeout();
  //
  // public abstract void heartbeat();
  //
  // public long getHeartbeatTimeout() {
  // return heartbeatTimeout;
  // }
  //
  // public void setHeartbeatTimeout(long heartbeatTimeout) {
  // this.heartbeatTimeout = heartbeatTimeout;
  // }
  //
  // public int getHeartbeatRetry() {
  // return heartbeatRetry;
  // }
  //
  // public void setHeartbeatRetry(int heartbeatRetry) {
  // this.heartbeatRetry = heartbeatRetry;
  // }
  //
  // public String getHeartbeatSQL() {
  // return heartbeatSQL;
  // }
  //
  // public void setHeartbeatSQL(String heartbeatSQL) {
  // this.heartbeatSQL = heartbeatSQL;
  // }
  //
  // public boolean isNeedHeartbeat() {
  // return heartbeatSQL != null;
  // }
  //
  // public DataSourceSyncRecorder getAsynRecorder() {
  // return this.asynRecorder;
  // }

  TPhysicalDBPool = class
  public const
    BALANCE_NONE: Integer = 0;
    BALANCE_ALL_BACK: Integer = 1;
    BALANCE_ALL: Integer = 2;
    BALANCE_ALL_READ: Integer = 3;

    WRITE_ONLYONE_NODE: Integer = 0;
    WRITE_RANDOM_NODE: Integer = 1;
    WRITE_ALL_NODE: Integer = 2;

    LONG_TIME: Int64 = 300000;
    WEIGHT: Integer = 0;

  end;
  // public class PhysicalDBPool {
  //
  // protected static final Logger LOGGER = LoggerFactory.getLogger(PhysicalDBPool.class);
  //
  // public static final int BALANCE_NONE = 0;
  // public static final int BALANCE_ALL_BACK = 1;
  // public static final int BALANCE_ALL = 2;
  // public static final int BALANCE_ALL_READ = 3;
  //
  // public static final int WRITE_ONLYONE_NODE = 0;
  // public static final int WRITE_RANDOM_NODE = 1;
  // public static final int WRITE_ALL_NODE = 2;
  //
  // public static final long LONG_TIME = 300000;
  // public static final int WEIGHT = 0;
  //
  // private final String hostName;
  //
  // protected PhysicalDatasource[] writeSources;
  // protected Map<Integer, PhysicalDatasource[]> readSources;
  //
  // protected volatile int activedIndex;
  // protected volatile boolean initSuccess;
  //
  // protected final ReentrantLock switchLock = new ReentrantLock();
  // private final Collection<PhysicalDatasource> allDs;
  // private final int banlance;
  // private final int writeType;
  // private final Random random = new Random();
  // private final Random wnrandom = new Random();
  // private String[] schemas;
  // private final DataHostConfig dataHostConfig;
  // private String slaveIDs;
  //
  // public PhysicalDBPool(String name, DataHostConfig conf,
  // PhysicalDatasource[] writeSources,
  // Map<Integer, PhysicalDatasource[]> readSources, int balance,
  // int writeType) {
  //
  // this.hostName = name;
  // this.dataHostConfig = conf;
  // this.writeSources = writeSources;
  // this.banlance = balance;
  // this.writeType = writeType;
  //
  // Iterator<Map.Entry<Integer, PhysicalDatasource[]>> entryItor = readSources.entrySet().iterator();
  // while (entryItor.hasNext()) {
  // PhysicalDatasource[] values = entryItor.next().getValue();
  // if (values.length == 0) {
  // entryItor.remove();
  // }
  // }
  //
  // this.readSources = readSources;
  // this.allDs = this.genAllDataSources();
  //
  // LOGGER.info("total resouces of dataHost " + this.hostName + " is :" + allDs.size());
  //
  // setDataSourceProps();
  // }
  //
  // public int getWriteType() {
  // return writeType;
  // }
  //
  // private void setDataSourceProps() {
  // for (PhysicalDatasource ds : this.allDs) {
  // ds.setDbPool(this);
  // }
  // }
  //
  // public PhysicalDatasource findDatasouce(BackendConnection exitsCon) {
  // for (PhysicalDatasource ds : this.allDs) {
  // if ((ds.isReadNode() == exitsCon.isFromSlaveDB())
  // && ds.isMyConnection(exitsCon)) {
  // return ds;
  // }
  // }
  //
  // LOGGER.warn("can't find connection in pool " + this.hostName + " con:"	+ exitsCon);
  // return null;
  // }
  //
  // public String getSlaveIDs() {
  // return slaveIDs;
  // }
  //
  // public void setSlaveIDs(String slaveIDs) {
  // this.slaveIDs = slaveIDs;
  // }
  //
  // public String getHostName() {
  // return hostName;
  // }
  //
  // /**
  // * all write datanodes
  // * @return
  // */
  // public PhysicalDatasource[] getSources() {
  // return writeSources;
  // }
  //
  // public PhysicalDatasource getSource() {
  //
  // switch (writeType) {
  // case WRITE_ONLYONE_NODE: {
  // return writeSources[activedIndex];
  // }
  // case WRITE_RANDOM_NODE: {
  //
  // int index = Math.abs(wnrandom.nextInt(Integer.MAX_VALUE)) % writeSources.length;
  // PhysicalDatasource result = writeSources[index];
  // if (!this.isAlive(result)) {
  //
  // // find all live nodes
  // ArrayList<Integer> alives = new ArrayList<Integer>(writeSources.length - 1);
  // for (int i = 0; i < writeSources.length; i++) {
  // if (i != index
  // && this.isAlive(writeSources[i])) {
  // alives.add(i);
  // }
  // }
  //
  // if (alives.isEmpty()) {
  // result = writeSources[0];
  // } else {
  // // random select one
  // index = Math.abs(wnrandom.nextInt(Integer.MAX_VALUE)) % alives.size();
  // result = writeSources[alives.get(index)];
  //
  // }
  // }
  //
  // if (LOGGER.isDebugEnabled()) {
  // LOGGER.debug("select write source " + result.getName()
  // + " for dataHost:" + this.getHostName());
  // }
  // return result;
  // }
  // default: {
  // throw new java.lang.IllegalArgumentException("writeType is "
  // + writeType + " ,so can't return one write datasource ");
  // }
  // }
  //
  // }
  //
  // public int getActivedIndex() {
  // return activedIndex;
  // }
  //
  // public boolean isInitSuccess() {
  // return initSuccess;
  // }
  //
  // public int next(int i) {
  // if (checkIndex(i)) {
  // return (++i == writeSources.length) ? 0 : i;
  // } else {
  // return 0;
  // }
  // }
  //
  // public boolean switchSource(int newIndex, boolean isAlarm, String reason) {
  // if (this.writeType != PhysicalDBPool.WRITE_ONLYONE_NODE || !checkIndex(newIndex)) {
  // return false;
  // }
  //
  // final ReentrantLock lock = this.switchLock;
  // lock.lock();
  // try {
  // int current = activedIndex;
  // if (current != newIndex) {
  //
  // // switch index
  // activedIndex = newIndex;
  //
  // // init again
  // this.init(activedIndex);
  //
  // // clear all connections
  // this.getSources()[current].clearCons("switch datasource");
  //
  // // write log
  // LOGGER.warn(switchMessage(current, newIndex, false, reason));
  //
  // return true;
  // }
  // } finally {
  // lock.unlock();
  // }
  // return false;
  // }
  //
  // private String switchMessage(int current, int newIndex, boolean alarm, String reason) {
  // StringBuilder s = new StringBuilder();
  // if (alarm) {
  // s.append(Alarms.DATANODE_SWITCH);
  // }
  // s.append("[Host=").append(hostName).append(",result=[").append(current).append("->");
  // s.append(newIndex).append("],reason=").append(reason).append(']');
  // return s.toString();
  // }
  //
  // private int loop(int i) {
  // return i < writeSources.length ? i : (i - writeSources.length);
  // }
  //
  // public void init(int index) {
  //
  // if (!checkIndex(index)) {
  // index = 0;
  // }
  //
  // int active = -1;
  // for (int i = 0; i < writeSources.length; i++) {
  // int j = loop(i + index);
  // if ( initSource(j, writeSources[j]) ) {
  //
  // //不切换-1时，如果主写挂了   不允许切换过去
  // boolean isNotSwitchDs = ( dataHostConfig.getSwitchType() == DataHostConfig.NOT_SWITCH_DS );
  // if ( isNotSwitchDs && j > 0 ) {
  // break;
  // }
  //
  // active = j;
  // activedIndex = active;
  // initSuccess = true;
  // LOGGER.info(getMessage(active, " init success"));
  //
  // if (this.writeType == WRITE_ONLYONE_NODE) {
  // // only init one write datasource
  // MycatServer.getInstance().saveDataHostIndex(hostName, activedIndex);
  // break;
  // }
  // }
  // }
  //
  // if (!checkIndex(active)) {
  // initSuccess = false;
  // StringBuilder s = new StringBuilder();
  // s.append(Alarms.DEFAULT).append(hostName).append(" init failure");
  // LOGGER.error(s.toString());
  // }
  // }
  //
  // private boolean checkIndex(int i) {
  // return i >= 0 && i < writeSources.length;
  // }
  //
  // private String getMessage(int index, String info) {
  // return new StringBuilder().append(hostName).append(" index:").append(index).append(info).toString();
  // }
  //
  // private boolean initSource(int index, PhysicalDatasource ds) {
  // int initSize = ds.getConfig().getMinCon();
  //
  // LOGGER.info("init backend myqsl source ,create connections total " + initSize + " for " + ds.getName() + " index :" + index);
  //
  // CopyOnWriteArrayList<BackendConnection> list = new CopyOnWriteArrayList<BackendConnection>();
  // GetConnectionHandler getConHandler = new GetConnectionHandler(list, initSize);
  // // long start = System.currentTimeMillis();
  // // long timeOut = start + 5000 * 1000L;
  //
  // for (int i = 0; i < initSize; i++) {
  // try {
  // ds.getConnection(this.schemas[i % schemas.length], true, getConHandler, null);
  // } catch (Exception e) {
  // LOGGER.warn(getMessage(index, " init connection error."), e);
  // }
  // }
  // long timeOut = System.currentTimeMillis() + 60 * 1000;
  //
  // // waiting for finish
  // while (!getConHandler.finished() && (System.currentTimeMillis() < timeOut)) {
  // try {
  // Thread.sleep(100);
  //
  // } catch (InterruptedException e) {
  // LOGGER.error("initError", e);
  // }
  // }
  // LOGGER.info("init result :" + getConHandler.getStatusInfo());
  /// /		for (BackendConnection c : list) {
  /// /			c.release();
  /// /		}
  // return !list.isEmpty();
  // }
  //
  // public void doHeartbeat() {
  //
  //
  // if (writeSources == null || writeSources.length == 0) {
  // return;
  // }
  //
  // for (PhysicalDatasource source : this.allDs) {
  //
  // if (source != null) {
  // source.doHeartbeat();
  // } else {
  // StringBuilder s = new StringBuilder();
  // s.append(Alarms.DEFAULT).append(hostName).append(" current dataSource is null!");
  // LOGGER.error(s.toString());
  // }
  // }
  //
  // }
  //
  // /**
  // * back physical connection heartbeat check
  // */
  // public void heartbeatCheck(long ildCheckPeriod) {
  //
  // for (PhysicalDatasource ds : allDs) {
  // // only readnode or all write node or writetype=WRITE_ONLYONE_NODE
  // // and current write node will check
  // if (ds != null
  // && (ds.getHeartbeat().getStatus() == DBHeartbeat.OK_STATUS)
  // && (ds.isReadNode()
  // || (this.writeType != WRITE_ONLYONE_NODE)
  // || (this.writeType == WRITE_ONLYONE_NODE
  // && ds == this.getSource()))) {
  //
  // ds.heatBeatCheck(ds.getConfig().getIdleTimeout(), ildCheckPeriod);
  // }
  // }
  // }
  //
  // public void startHeartbeat() {
  // for (PhysicalDatasource source : this.allDs) {
  // source.startHeartbeat();
  // }
  // }
  //
  // public void stopHeartbeat() {
  // for (PhysicalDatasource source : this.allDs) {
  // source.stopHeartbeat();
  // }
  // }
  //
  // /**
  // *  强制清除 dataSources
  // * @param reason
  // */
  // public void clearDataSources(String reason) {
  // LOGGER.info("clear datasours of pool " + this.hostName);
  // for (PhysicalDatasource source : this.allDs) {
  // LOGGER.info("clear datasoure of pool  " + this.hostName + " ds:" + source.getConfig());
  // source.clearCons(reason);
  // source.stopHeartbeat();
  // }
  // }
  //
  // public Collection<PhysicalDatasource> genAllDataSources() {
  //
  // LinkedList<PhysicalDatasource> allSources = new LinkedList<PhysicalDatasource>();
  // for (PhysicalDatasource ds : writeSources) {
  // if (ds != null) {
  // allSources.add(ds);
  // }
  // }
  //
  // for (PhysicalDatasource[] dataSources : this.readSources.values()) {
  // for (PhysicalDatasource ds : dataSources) {
  // if (ds != null) {
  // allSources.add(ds);
  // }
  // }
  // }
  // return allSources;
  // }
  //
  // public Collection<PhysicalDatasource> getAllDataSources() {
  // return this.allDs;
  // }
  //
  // /**
  // * return connection for read balance
  // *
  // * @param handler
  // * @param attachment
  // * @param database
  // * @throws Exception
  // */
  // public void getRWBanlanceCon(String schema, boolean autocommit,
  // ResponseHandler handler, Object attachment, String database) throws Exception {
  //
  // PhysicalDatasource theNode = null;
  // ArrayList<PhysicalDatasource> okSources = null;
  // switch (banlance) {
  // case BALANCE_ALL_BACK: {
  // // all read nodes and the standard by masters
  // okSources = getAllActiveRWSources(true, false, checkSlaveSynStatus());
  // if (okSources.isEmpty()) {
  // theNode = this.getSource();
  //
  // } else {
  // theNode = randomSelect(okSources);
  // }
  // break;
  // }
  // case BALANCE_ALL: {
  // okSources = getAllActiveRWSources(true, true, checkSlaveSynStatus());
  // theNode = randomSelect(okSources);
  // break;
  // }
  // case BALANCE_ALL_READ: {
  // okSources = getAllActiveRWSources(false, false, checkSlaveSynStatus());
  // theNode = randomSelect(okSources);
  // break;
  // }
  // case BALANCE_NONE:
  // default:
  // // return default write data source
  // theNode = this.getSource();
  // }
  //
  // if (LOGGER.isDebugEnabled()) {
  // LOGGER.debug("select read source " + theNode.getName() + " for dataHost:" + this.getHostName());
  // }
  // //统计节点读操作次数
  // theNode.setReadCount();
  // theNode.getConnection(schema, autocommit, handler, attachment);
  // }
  //
  // /**
  // * slave 读负载均衡，也就是 readSource 之间实现负载均衡
  // * @param schema
  // * @param autocommit
  // * @param handler
  // * @param attachment
  // * @param database
  // * @throws Exception
  // */
  // public void getReadBanlanceCon(String schema, boolean autocommit, ResponseHandler handler,
  // Object attachment, String database)throws Exception {
  // PhysicalDatasource theNode = null;
  // ArrayList<PhysicalDatasource> okSources = null;
  // okSources = getAllActiveRWSources(false, false, checkSlaveSynStatus());
  // theNode = randomSelect(okSources);
  // //统计节点读操作次数
  // theNode.setReadCount();
  // theNode.getConnection(schema, autocommit, handler, attachment);
  // }
  //
  // /**
  // * 从 writeHost 下面的 readHost中随机获取一个 connection, 用于slave注解
  // * @param schema
  // * @param autocommit
  // * @param handler
  // * @param attachment
  // * @param database
  // * @return
  // * @throws Exception
  // */
  // public boolean getReadCon(String schema, boolean autocommit, ResponseHandler handler,
  // Object attachment, String database)throws Exception {
  // PhysicalDatasource theNode = null;
  //
  // LOGGER.debug("!readSources.isEmpty() " + !readSources.isEmpty());
  // if (!readSources.isEmpty()) {
  // int index = Math.abs(random.nextInt(Integer.MAX_VALUE)) % readSources.size();
  // PhysicalDatasource[] allSlaves = this.readSources.get(index);
  /// /			System.out.println("allSlaves.length " + allSlaves.length);
  // if (allSlaves != null) {
  // index = Math.abs(random.nextInt(Integer.MAX_VALUE)) % readSources.size();
  // PhysicalDatasource slave = allSlaves[index];
  //
  // for (int i=0; i<allSlaves.length; i++) {
  // LOGGER.debug("allSlaves.length i:::::: " + i);
  // if (isAlive(slave)) {
  // if (checkSlaveSynStatus()) {
  // if (canSelectAsReadNode(slave)) {
  // theNode = slave;
  // break;
  // } else {
  // continue;
  // }
  // } else {
  // theNode = slave;
  // break;
  // }
  // }
  /// /					index = Math.abs(random.nextInt()) % readSources.size();
  // }
  // }
  // //统计节点读操作次数
  // if(theNode != null) {
  // theNode.setReadCount();
  // theNode.getConnection(schema, autocommit, handler, attachment);
  // return true;
  // } else {
  // LOGGER.warn("readhost is notavailable.");
  // return false;
  // }
  // }else{
  // LOGGER.warn("readhost is empty, readSources is empty.");
  // return false;
  // }
  // }
  //
  // private boolean checkSlaveSynStatus() {
  // return ( dataHostConfig.getSlaveThreshold() != -1 )
  // && (dataHostConfig.getSwitchType() == DataHostConfig.SYN_STATUS_SWITCH_DS);
  // }
  //
  //
  // /**
  // * TODO: modify by zhuam
  // *
  // * 随机选择，按权重设置随机概率。
  // * 在一个截面上碰撞的概率高，但调用量越大分布越均匀，而且按概率使用权重后也比较均匀，有利于动态调整提供者权重。
  // * @param okSources
  // * @return
  // */
  // public PhysicalDatasource randomSelect(ArrayList<PhysicalDatasource> okSources) {
  //
  // if (okSources.isEmpty()) {
  // return this.getSource();
  //
  // } else {
  //
  // int length = okSources.size(); 	// 总个数
  // int totalWeight = 0; 			// 总权重
  // boolean sameWeight = true; 		// 权重是否都一样
  // for (int i = 0; i < length; i++) {
  // int weight = okSources.get(i).getConfig().getWeight();
  // totalWeight += weight; 		// 累计总权重
  // if (sameWeight && i > 0
  // && weight != okSources.get(i-1).getConfig().getWeight() ) {	  // 计算所有权重是否一样
  // sameWeight = false;
  // }
  // }
  //
  // if (totalWeight > 0 && !sameWeight ) {
  //
  // // 如果权重不相同且权重大于0则按总权重数随机
  // int offset = random.nextInt(totalWeight);
  //
  // // 并确定随机值落在哪个片断上
  // for (int i = 0; i < length; i++) {
  // offset -= okSources.get(i).getConfig().getWeight();
  // if (offset < 0) {
  // return okSources.get(i);
  // }
  // }
  // }
  //
  // // 如果权重相同或权重为0则均等随机
  // return okSources.get( random.nextInt(length) );
  //
  // //int index = Math.abs(random.nextInt()) % okSources.size();
  // //return okSources.get(index);
  // }
  // }
  //
  // //
  // public int getBalance() {
  // return banlance;
  // }
  //
  // private boolean isAlive(PhysicalDatasource theSource) {
  // return (theSource.getHeartbeat().getStatus() == DBHeartbeat.OK_STATUS);
  // }
  //
  // private boolean canSelectAsReadNode(PhysicalDatasource theSource) {
  //
  // Integer slaveBehindMaster = theSource.getHeartbeat().getSlaveBehindMaster();
  // int dbSynStatus = theSource.getHeartbeat().getDbSynStatus();
  //
  // if ( slaveBehindMaster == null || dbSynStatus == DBHeartbeat.DB_SYN_ERROR) {
  // return false;
  // }
  // boolean isSync = dbSynStatus == DBHeartbeat.DB_SYN_NORMAL;
  // boolean isNotDelay = slaveBehindMaster < this.dataHostConfig.getSlaveThreshold();
  // return isSync && isNotDelay;
  // }
  //
  // /**
  // * return all backup write sources
  // *
  // * @param includeWriteNode if include write nodes
  // * @param includeCurWriteNode if include current active write node. invalid when <code>includeWriteNode<code> is false
  // * @param filterWithSlaveThreshold
  // *
  // * @return
  // */
  // private ArrayList<PhysicalDatasource> getAllActiveRWSources(
  // boolean includeWriteNode, boolean includeCurWriteNode, boolean filterWithSlaveThreshold) {
  //
  // int curActive = activedIndex;
  // ArrayList<PhysicalDatasource> okSources = new ArrayList<PhysicalDatasource>(this.allDs.size());
  //
  // for (int i = 0; i < this.writeSources.length; i++) {
  // PhysicalDatasource theSource = writeSources[i];
  // if (isAlive(theSource)) {// write node is active
  //
  // if (includeWriteNode) {
  // boolean isCurWriteNode = ( i == curActive );
  // if ( isCurWriteNode && includeCurWriteNode == false) {
  // // not include cur active source
  // } else if (filterWithSlaveThreshold && theSource.isSalveOrRead() ) {
  // boolean selected = canSelectAsReadNode(theSource);
  // if ( selected ) {
  // okSources.add(theSource);
  // } else {
  // continue;
  // }
  // } else {
  // okSources.add(theSource);
  // }
  // }
  //
  // if (!readSources.isEmpty()) {
  // // check all slave nodes
  // PhysicalDatasource[] allSlaves = this.readSources.get(i);
  // if (allSlaves != null) {
  // for (PhysicalDatasource slave : allSlaves) {
  // if (isAlive(slave)) {
  // if (filterWithSlaveThreshold) {
  // boolean selected = canSelectAsReadNode(slave);
  // if ( selected ) {
  // okSources.add(slave);
  // } else {
  // continue;
  // }
  // } else {
  // okSources.add(slave);
  // }
  // }
  // }
  // }
  // }
  //
  // } else {
  //
  // // TODO : add by zhuam
  // // 如果写节点不OK, 也要保证临时的读服务正常
  // if ( this.dataHostConfig.isTempReadHostAvailable()
  // && !readSources.isEmpty()) {
  //
  // // check all slave nodes
  // PhysicalDatasource[] allSlaves = this.readSources.get(i);
  // if (allSlaves != null) {
  // for (PhysicalDatasource slave : allSlaves) {
  // if (isAlive(slave)) {
  //
  // if (filterWithSlaveThreshold) {
  // if (canSelectAsReadNode(slave)) {
  // okSources.add(slave);
  // } else {
  // continue;
  // }
  //
  // } else {
  // okSources.add(slave);
  // }
  // }
  // }
  // }
  // }
  // }
  //
  // }
  // return okSources;
  // }
  //
  // public String[] getSchemas() {
  // return schemas;
  // }
  //
  // public void setSchemas(String[] mySchemas) {
  // this.schemas = mySchemas;
  // }
  // }

  TPhysicalDatasource = class
  private
    FName: String;
    FSize: Integer;
    FConfig: TDBHostConfig;
    FConMap: TConMap;
    FHeartbeat: TDBHeartbeat;
    FReadNode: Boolean;
    FHeartbeatRecoveryTime: Int64;
    FHostConfig: TDataHostConfig;
    FConnHeartBeatHanler: TConnectionHeartBeatHandler;
    FDBPool: TPhysicalDBPool;

    // 添加DataSource读计数
    FReadCount: Int64; // = new AtomicLong(0);

    // 添加DataSource写计数
    FWriteCount: Int64; // = new AtomicLong(0);
  public
    constructor Create(Config: TDBHostConfig; HostConfig: TDataHostConfig;
      IsReadNode: Boolean);
  end;
  // = new ConMap();

  // public abstract class PhysicalDatasource {
  //
  // private static final Logger LOGGER = LoggerFactory.getLogger(PhysicalDatasource.class);
  //
  // private final String name;
  // private final int size;
  // private final DBHostConfig config;
  // private final ConMap conMap = new ConMap();
  // private DBHeartbeat heartbeat;
  // private final boolean readNode;
  // private volatile long heartbeatRecoveryTime;
  // private final DataHostConfig hostConfig;
  // private final ConnectionHeartBeatHandler conHeartBeatHanler = new ConnectionHeartBeatHandler();
  // private PhysicalDBPool dbPool;
  //
  // // 添加DataSource读计数
  // private AtomicLong readCount = new AtomicLong(0);
  //
  // // 添加DataSource写计数
  // private AtomicLong writeCount = new AtomicLong(0);
  //
  //
  // /**
  // *   edit by dingw at 2017.06.08
  // *   @see https://github.com/MyCATApache/Mycat-Server/issues/1524
  // *
  // */
  // // 当前活动连接
  // //private volatile AtomicInteger activeCount = new AtomicInteger(0);
  //
  // // 当前存活的总连接数,为什么不直接使用activeCount,主要是因为连接的创建是异步完成的
  // //private volatile AtomicInteger totalConnection = new AtomicInteger(0);
  //
  // /**
  // * 由于在Mycat中，returnCon被多次调用（与takeCon并没有成对调用）导致activeCount、totalConnection容易出现负数
  // */
  // //private static final String TAKE_CONNECTION_FLAG = "1";
  // //private ConcurrentMap<Long /* ConnectionId */, String /* 常量1*/> takeConnectionContext = new ConcurrentHashMap<>();
  //
  //
  //
  // public PhysicalDatasource(DBHostConfig config, DataHostConfig hostConfig,
  // boolean isReadNode) {
  // this.size = config.getMaxCon();
  // this.config = config;
  // this.name = config.getHostName();
  // this.hostConfig = hostConfig;
  // heartbeat = this.createHeartBeat();
  // this.readNode = isReadNode;
  // }
  //
  // public boolean isMyConnection(BackendConnection con) {
  // if (con instanceof MySQLConnection) {
  // return ((MySQLConnection) con).getPool() == this;
  // } else {
  // return false;
  // }
  //
  // }
  //
  // public long getReadCount() {
  // return readCount.get();
  // }
  //
  // public void setReadCount() {
  // readCount.addAndGet(1);
  // }
  //
  // public long getWriteCount() {
  // return writeCount.get();
  // }
  //
  // public void setWriteCount() {
  // writeCount.addAndGet(1);
  // }
  //
  // public DataHostConfig getHostConfig() {
  // return hostConfig;
  // }
  //
  // public boolean isReadNode() {
  // return readNode;
  // }
  //
  // public int getSize() {
  // return size;
  // }
  //
  // public void setDbPool(PhysicalDBPool dbPool) {
  // this.dbPool = dbPool;
  // }
  //
  // public PhysicalDBPool getDbPool() {
  // return dbPool;
  // }
  //
  // public abstract DBHeartbeat createHeartBeat();
  //
  // public String getName() {
  // return name;
  // }
  //
  // public long getExecuteCount() {
  // long executeCount = 0;
  // for (ConQueue queue : conMap.getAllConQueue()) {
  // executeCount += queue.getExecuteCount();
  //
  // }
  // return executeCount;
  // }
  //
  // public long getExecuteCountForSchema(String schema) {
  // return conMap.getSchemaConQueue(schema).getExecuteCount();
  //
  // }
  //
  // public int getActiveCountForSchema(String schema) {
  // return conMap.getActiveCountForSchema(schema, this);
  // }
  //
  // public int getIdleCountForSchema(String schema) {
  // ConQueue queue = conMap.getSchemaConQueue(schema);
  // int total = 0;
  // total += queue.getAutoCommitCons().size()
  // + queue.getManCommitCons().size();
  // return total;
  // }
  //
  // public DBHeartbeat getHeartbeat() {
  // return heartbeat;
  // }
  //
  // public int getIdleCount() {
  // int total = 0;
  // for (ConQueue queue : conMap.getAllConQueue()) {
  // total += queue.getAutoCommitCons().size()
  // + queue.getManCommitCons().size();
  // }
  // return total;
  // }
  //
  // /**
  // * 该方法也不是非常精确，因为该操作也不是一个原子操作,相对getIdleCount高效与准确一些
  // * @return
  // */
  /// /	public int getIdleCountSafe() {
  /// /		return getTotalConnectionsSafe() - getActiveCountSafe();
  /// /	}
  //
  // /**
  // * 是否需要继续关闭空闲连接
  // * @return
  // */
  /// /	private boolean needCloseIdleConnection() {
  /// /		return getIdleCountSafe() > hostConfig.getMinCon();
  /// /	}
  //
  // private boolean validSchema(String schema) {
  // String theSchema = schema;
  // return theSchema != null && !"".equals(theSchema)
  // && !"snyn...".equals(theSchema);
  // }
  //
  // private void checkIfNeedHeartBeat(
  // LinkedList<BackendConnection> heartBeatCons, ConQueue queue,
  // ConcurrentLinkedQueue<BackendConnection> checkLis,
  // long hearBeatTime, long hearBeatTime2) {
  // int maxConsInOneCheck = 10;
  // Iterator<BackendConnection> checkListItor = checkLis.iterator();
  // while (checkListItor.hasNext()) {
  // BackendConnection con = checkListItor.next();
  // if (con.isClosedOrQuit()) {
  // checkListItor.remove();
  // continue;
  // }
  // if (validSchema(con.getSchema())) {
  // if (con.getLastTime() < hearBeatTime
  // && heartBeatCons.size() < maxConsInOneCheck) {
  // if(checkLis.remove(con)) {
  // //如果移除成功，则放入到心跳连接中，如果移除失败，说明该连接已经被其他线程使用，忽略本次心跳检测
  // con.setBorrowed(true);
  // heartBeatCons.add(con);
  // }
  // }
  // } else if (con.getLastTime() < hearBeatTime2) {
  // // not valid schema conntion should close for idle
  // // exceed 2*conHeartBeatPeriod
  // // 同样，这里也需要先移除，避免被业务连接
  // if(checkLis.remove(con)) {
  // con.close(" heart beate idle ");
  // }
  // }
  //
  // }
  //
  // }
  //
  // public int getIndex() {
  // int currentIndex = 0;
  // for (int i = 0; i < dbPool.getSources().length; i++) {
  // PhysicalDatasource writeHostDatasource = dbPool.getSources()[i];
  // if (writeHostDatasource.getName().equals(getName())) {
  // currentIndex = i;
  // break;
  // }
  // }
  // return currentIndex;
  // }
  //
  // public boolean isSalveOrRead() {
  // int currentIndex = getIndex();
  // if (currentIndex != dbPool.activedIndex || this.readNode) {
  // return true;
  // }
  // return false;
  // }
  //
  // public void heatBeatCheck(long timeout, long conHeartBeatPeriod) {
  /// /		int ildeCloseCount = hostConfig.getMinCon() * 3;
  // int maxConsInOneCheck = 5;
  // LinkedList<BackendConnection> heartBeatCons = new LinkedList<BackendConnection>();
  //
  // long hearBeatTime = TimeUtil.currentTimeMillis() - conHeartBeatPeriod;
  // long hearBeatTime2 = TimeUtil.currentTimeMillis() - 2
  // * conHeartBeatPeriod;
  // for (ConQueue queue : conMap.getAllConQueue()) {
  // checkIfNeedHeartBeat(heartBeatCons, queue,
  // queue.getAutoCommitCons(), hearBeatTime, hearBeatTime2);
  // if (heartBeatCons.size() < maxConsInOneCheck) {
  // checkIfNeedHeartBeat(heartBeatCons, queue,
  // queue.getManCommitCons(), hearBeatTime, hearBeatTime2);
  // } else if (heartBeatCons.size() >= maxConsInOneCheck) {
  // break;
  // }
  // }
  //
  // if (!heartBeatCons.isEmpty()) {
  // for (BackendConnection con : heartBeatCons) {
  // conHeartBeatHanler
  // .doHeartBeat(con, hostConfig.getHearbeatSQL());
  // }
  // }
  //
  // // check if there has timeouted heatbeat cons
  // conHeartBeatHanler.abandTimeOuttedConns();
  // int idleCons = getIdleCount();
  // int activeCons = this.getActiveCount();
  // int createCount = (hostConfig.getMinCon() - idleCons) / 3;
  // // create if idle too little
  // if ((createCount > 0) && (idleCons + activeCons < size)
  // && (idleCons < hostConfig.getMinCon())) {
  // createByIdleLitte(idleCons, createCount);
  // } else if (idleCons > hostConfig.getMinCon()) {
  // closeByIdleMany(idleCons - hostConfig.getMinCon());
  // } else {
  // int activeCount = this.getActiveCount();
  // if (activeCount > size) {
  // StringBuilder s = new StringBuilder();
  // s.append(Alarms.DEFAULT).append("DATASOURCE EXCEED [name=")
  // .append(name).append(",active=");
  // s.append(activeCount).append(",size=").append(size).append(']');
  // LOGGER.warn(s.toString());
  // }
  // }
  // }
  //
  // /**
  // *
  // * @param ildeCloseCount
  // * 首先，从已创建的连接中选择本次心跳需要关闭的空闲连接数（由当前连接连接数-减去配置的最小连接数。
  // * 然后依次关闭这些连接。由于连接空闲心跳检测与业务是同时并发的，在心跳关闭阶段，可能有连接被使用，导致需要关闭的空闲连接数减少.
  // *
  // * 所以每次关闭新连接时，先判断当前空闲连接数是否大于配置的最少空闲连接，如果为否，则结束本次关闭空闲连接操作。
  // * 该方法修改之前：
  // *      首先从ConnMap中获取 ildeCloseCount 个连接，然后关闭；在关闭中，可能又有连接被使用，导致可能多关闭一些链接，
  // *      导致相对频繁的创建新连接和关闭连接
  // *
  // * 该方法修改之后：
  // *     ildeCloseCount 为预期要关闭的连接
  // *     使用循环操作，首先在关闭之前，先再一次判断是否需要关闭连接，然后每次从ConnMap中获取一个空闲连接，然后进行关闭
  // * edit by dingw at 2017.06.16
  // */
  // private void closeByIdleMany(int ildeCloseCount) {
  // LOGGER.info("too many ilde cons ,close some for datasouce  " + name);
  // List<BackendConnection> readyCloseCons = new ArrayList<BackendConnection>(
  // ildeCloseCount);
  // for (ConQueue queue : conMap.getAllConQueue()) {
  // readyCloseCons.addAll(queue.getIdleConsToClose(ildeCloseCount));
  // if (readyCloseCons.size() >= ildeCloseCount) {
  // break;
  // }
  // }
  //
  // for (BackendConnection idleCon : readyCloseCons) {
  // if (idleCon.isBorrowed()) {
  // LOGGER.warn("find idle con is using " + idleCon);
  // }
  // idleCon.close("too many idle con");
  // }
  //
  /// /		LOGGER.info("too many ilde cons ,close some for datasouce  " + name);
  /// /
  /// /		Iterator<ConQueue> conQueueIt = conMap.getAllConQueue().iterator();
  /// /		ConQueue queue = null;
  /// /		if(conQueueIt.hasNext()) {
  /// /			queue = conQueueIt.next();
  /// /		}
  /// /
  /// /		for(int i = 0; i < ildeCloseCount; i ++ ) {
  /// /
  /// /			if(!needCloseIdleConnection() || queue == null) {
  /// /				break; //如果当时空闲连接数没有超过最小配置连接数，则结束本次连接关闭
  /// /			}
  /// /
  /// /			LOGGER.info("cur conns:" + getTotalConnectionsSafe() );
  /// /
  /// /			BackendConnection idleCon = queue.takeIdleCon(false);
  /// /
  /// /			while(idleCon == null && conQueueIt.hasNext()) {
  /// /				queue = conQueueIt.next();
  /// /				idleCon = queue.takeIdleCon(false);
  /// /			}
  /// /
  /// /			if(idleCon == null) {
  /// /				break;
  /// /			}
  /// /
  /// /			if (idleCon.isBorrowed() ) {
  /// /				LOGGER.warn("find idle con is using " + idleCon);
  /// /			}
  /// /			idleCon.close("too many idle con");
  /// /
  /// /		}
  //
  // }
  //
  // private void createByIdleLitte(int idleCons, int createCount) {
  // LOGGER.info("create connections ,because idle connection not enough ,cur is "
  // + idleCons
  // + ", minCon is "
  // + hostConfig.getMinCon()
  // + " for "
  // + name);
  // NewConnectionRespHandler simpleHandler = new NewConnectionRespHandler();
  //
  // final String[] schemas = dbPool.getSchemas();
  // for (int i = 0; i < createCount; i++) {
  // if (this.getActiveCount() + this.getIdleCount() >= size) {
  // break;
  // }
  // try {
  // // creat new connection
  // this.createNewConnection(simpleHandler, null, schemas[i
  // % schemas.length]);
  // } catch (IOException e) {
  // LOGGER.warn("create connection err " + e);
  // }
  //
  // }
  // }
  //
  // public int getActiveCount() {
  // return this.conMap.getActiveCountForDs(this);
  // }
  //
  //
  //
  // public void clearCons(String reason) {
  // this.conMap.clearConnections(reason, this);
  // }
  //
  // public void startHeartbeat() {
  // heartbeat.start();
  // }
  //
  // public void stopHeartbeat() {
  // heartbeat.stop();
  // }
  //
  // public void doHeartbeat() {
  // // 未到预定恢复时间，不执行心跳检测。
  // if (TimeUtil.currentTimeMillis() < heartbeatRecoveryTime) {
  // return;
  // }
  //
  // if (!heartbeat.isStop()) {
  // try {
  // heartbeat.heartbeat();
  // } catch (Exception e) {
  // LOGGER.error(name + " heartbeat error.", e);
  // }
  // }
  // }
  //
  // private BackendConnection takeCon(BackendConnection conn,
  // final ResponseHandler handler, final Object attachment,
  // String schema) {
  //
  // conn.setBorrowed(true);
  //
  /// /		if(takeConnectionContext.putIfAbsent(conn.getId(), TAKE_CONNECTION_FLAG) == null) {
  /// /			incrementActiveCountSafe();
  /// /		}
  //
  //
  // if (!conn.getSchema().equals(schema)) {
  // // need do schema syn in before sql send
  // conn.setSchema(schema);
  // }
  // ConQueue queue = conMap.getSchemaConQueue(schema);
  // queue.incExecuteCount();
  // conn.setAttachment(attachment);
  // conn.setLastTime(System.currentTimeMillis()); // 每次取连接的时候，更新下lasttime，防止在前端连接检查的时候，关闭连接，导致sql执行失败
  // handler.connectionAcquired(conn);
  // return conn;
  // }
  //
  // private void createNewConnection(final ResponseHandler handler,
  // final Object attachment, final String schema) throws IOException {
  // // aysn create connection
  // MycatServer.getInstance().getBusinessExecutor().execute(new Runnable() {
  // public void run() {
  // try {
  // createNewConnection(new DelegateResponseHandler(handler) {
  // @Override
  // public void connectionError(Throwable e, BackendConnection conn) {
  // //decrementTotalConnectionsSafe(); // 如果创建连接失败，将当前连接数减1
  // handler.connectionError(e, conn);
  // }
  //
  // @Override
  // public void connectionAcquired(BackendConnection conn) {
  // takeCon(conn, handler, attachment, schema);
  // }
  // }, schema);
  // } catch (IOException e) {
  // handler.connectionError(e, null);
  // }
  // }
  // });
  // }
  //
  // public void getConnection(String schema, boolean autocommit,
  // final ResponseHandler handler, final Object attachment)
  // throws IOException {
  //
  // // 从当前连接map中拿取已建立好的后端连接
  // BackendConnection con = this.conMap.tryTakeCon(schema, autocommit);
  // if (con != null) {
  // //如果不为空，则绑定对应前端请求的handler
  // takeCon(con, handler, attachment, schema);
  // return;
  //
  // } else { // this.getActiveCount并不是线程安全的（严格上说该方法获取数量不准确），
  /// /			int curTotalConnection = this.totalConnection.get();
  /// /			while(curTotalConnection + 1 <= size) {
  /// /
  /// /				if (this.totalConnection.compareAndSet(curTotalConnection, curTotalConnection + 1)) {
  /// /					LOGGER.info("no ilde connection in pool,create new connection for "	+ this.name + " of schema " + schema);
  /// /					createNewConnection(handler, attachment, schema);
  /// /					return;
  /// /				}
  /// /
  /// /				curTotalConnection = this.totalConnection.get(); //CAS更新失败，则重新判断当前连接是否超过最大连接数
  /// /
  /// /			}
  /// /
  /// /			// 如果后端连接不足，立即失败,故直接抛出连接数超过最大连接异常
  /// /			LOGGER.error("the max activeConnnections size can not be max than maxconnections:" + curTotalConnection);
  /// /			throw new IOException("the max activeConnnections size can not be max than maxconnections:" + curTotalConnection);
  //
  // int activeCons = this.getActiveCount();// 当前最大活动连接
  // if (activeCons + 1 > size) {// 下一个连接大于最大连接数
  // LOGGER.error("the max activeConnnections size can not be max than maxconnections");
  // throw new IOException("the max activeConnnections size can not be max than maxconnections");
  // } else { // create connection
  // LOGGER.info("no ilde connection in pool,create new connection for "	+ this.name + " of schema " + schema);
  // createNewConnection(handler, attachment, schema);
  // }
  // }
  // }
  //
  // /**
  // * 是否超过最大连接数
  // * @return
  // */
  /// /	private boolean exceedMaxConnections() {
  /// /		return this.totalConnection.get() + 1 > size;
  /// /	}
  /// /
  /// /	public int decrementActiveCountSafe() {
  /// /		return this.activeCount.decrementAndGet();
  /// /	}
  /// /
  /// /	public int incrementActiveCountSafe() {
  /// /		return this.activeCount.incrementAndGet();
  /// /	}
  /// /
  /// /	public int getActiveCountSafe() {
  /// /		return this.activeCount.get();
  /// /	}
  /// /
  /// /	public int getTotalConnectionsSafe() {
  /// /		return this.totalConnection.get();
  /// /	}
  /// /
  /// /	public int decrementTotalConnectionsSafe() {
  /// /		return this.totalConnection.decrementAndGet();
  /// /	}
  /// /
  /// /	public int incrementTotalConnectionSafe() {
  /// /		return this.totalConnection.incrementAndGet();
  /// /	}
  //
  // private void returnCon(BackendConnection c) {
  //
  // c.setAttachment(null);
  // c.setBorrowed(false);
  // c.setLastTime(TimeUtil.currentTimeMillis());
  // ConQueue queue = this.conMap.getSchemaConQueue(c.getSchema());
  //
  // boolean ok = false;
  // if (c.isAutocommit()) {
  // ok = queue.getAutoCommitCons().offer(c);
  // } else {
  // ok = queue.getManCommitCons().offer(c);
  // }
  //
  /// /		if(c.getId() > 0 && takeConnectionContext.remove(c.getId(), TAKE_CONNECTION_FLAG) ) {
  /// /			decrementActiveCountSafe();
  /// /		}
  //
  // if(!ok) {
  // LOGGER.warn("can't return to pool ,so close con " + c);
  // c.close("can't return to pool ");
  //
  // }
  //
  // }
  //
  // public void releaseChannel(BackendConnection c) {
  // if (LOGGER.isDebugEnabled()) {
  // LOGGER.debug("release channel " + c);
  // }
  // // release connection
  // returnCon(c);
  // }
  //
  // public void connectionClosed(BackendConnection conn) {
  // ConQueue queue = this.conMap.getSchemaConQueue(conn.getSchema());
  // if (queue != null ) {
  // queue.removeCon(conn);
  // }
  //
  /// /		decrementTotalConnectionsSafe();
  // }
  //
  // /**
  // * 创建新连接
  // */
  // public abstract void createNewConnection(ResponseHandler handler, String schema) throws IOException;
  //
  // /**
  // * 测试连接，用于初始化及热更新配置检测
  // */
  // public abstract boolean testConnection(String schema) throws IOException;
  //
  // public long getHeartbeatRecoveryTime() {
  // return heartbeatRecoveryTime;
  // }
  //
  // public void setHeartbeatRecoveryTime(long heartbeatRecoveryTime) {
  // this.heartbeatRecoveryTime = heartbeatRecoveryTime;
  // }
  //
  // public DBHostConfig getConfig() {
  // return config;
  // }
  //
  // public boolean isAlive() {
  // return getHeartbeat().getStatus() == DBHeartbeat.OK_STATUS;
  // }
  // }

implementation

uses
  MyCat.Util, MyCat.Util.Logger;

{ TConQueue }

constructor TConnectionQueue.Create;
begin
  FAutoCommitCons := TBackEndConnectionList.Create;
  FManCommitCons := TBackEndConnectionList.Create;
end;

function TConnectionQueue.GetExecuteCount: Int64;
begin
  Result := FExecuteCount;
end;

procedure TConnectionQueue.IncExecuteCount;
begin
  Inc(FExecuteCount);
end;

function TConnectionQueue.RemoveConnection(Connection
  : IBackEndConnection): Boolean;
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

function TConnectionQueue.TakeIdleCon(AutoCommit: Boolean): IBackEndConnection;
var
  List1: TBackEndConnectionList;
  List2: TBackEndConnectionList;
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

{ TConnectionHeartBeatHandler }

procedure TConnectionHeartBeatHandler.AbandTimeOuttedConns;
var
  AbandConnections: IBackEndConnectionList;
  CurTime: Int64;
  Iterator: IHeartBeatConnectionMapIterator;
  HeartBeatConnection: THeartBeatConnection;
  Connection: IBackEndConnection;
begin
  if FAllConnections.IsEmpty then
  begin
    Exit;
  end;

  AbandConnections := TBackEndConnectionList.Create;
  CurTime := TTimeUtil.CurrentTimeMillis;
  Iterator := FAllConnections.ItBegin;
  while not Iterator.IsEqual(FAllConnections.ItEnd) do
  begin
    HeartBeatConnection := Iterator.Value;
    if HeartBeatConnection.TimeOutTimestamp < CurTime then
    begin
      AbandConnections.Insert(HeartBeatConnection.Connection);
      FAllConnections.Erase(Iterator);
    end;
    Iterator.Next;
  end;

  if not AbandConnections.IsEmpty then
  begin
    for Connection in AbandConnections do
    begin
      try
        // if(con.isBorrowed())
        Connection.Close;
        AppendLog('heartbeat timeout');
      except
        on E: Exception do
        begin
          AppendLog('close Err: %s', [E.Message], ltWarning);
        end;
      end;
    end;
  end;
end;

constructor TConnectionHeartBeatHandler.Create;
begin
  FAllConnections := THeartBeatConnectionHashMap.Create;
end;

procedure TConnectionHeartBeatHandler.DoHeartBeat
  (Connection: IBackEndConnection; sql: string);
begin
  AppendLog('do heartbeat for con ' + Connection.PeerAddr);

  try
    if FAllConnections.Find(Connection.UID).IsEqual(FAllConnections.ItEnd) then
    begin
      FAllConnections.Insert(Connection.UID,
        THeartBeatConnection.Create(Connection));
      Connection.SetResponseHandler(Self);
      Connection.Query(sql);
    end;
  except
    on E: Exception do
    begin
      ExecuteException(conn, E);
    end;
  end;
end;

{ TDBHeartbeat }

constructor TDBHeartbeat.Create;
begin
  FHeartbeatTimeout := DEFAULT_HEARTBEAT_TIMEOUT; // 心跳超时时间
  FHeartbeatRetry := DEFAULT_HEARTBEAT_RETRY; // 检查连接发生异常到切换，重试次数
  FIsStop := true;
  FIsChecking := false;
  FErrorCount := 0;
  FRecorder := THeartbeatRecorder.Create;
  FAsynRecorder := TDataSourceSyncRecorder.Create;
end;

{ TPhysicalDatasource }

constructor TPhysicalDatasource.Create(Config: TDBHostConfig;
  HostConfig: TDataHostConfig; IsReadNode: Boolean);
begin
FConnHeartBeatHanler:
  TConnectionHeartBeatHandler = new ConnectionHeartBeatHandler();
end;

end.
