unit Mycat.SQLEngine;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections,
  MyCat.Net.CrossSocket.Base,
  Mycat.BackEnd.Mysql.CrossSocket.Handler, Mycat.BackEnd.DataSource;

type
  TEngineCtx = class;

  IAllJobFinishedListener = interface
    procedure OnAllJobFinished(Ctx: TEngineCtx);
  end;

  ISQLJobHandler = interface
    procedure OnHeader(DataNode: string; Header: Tbytes; Fields: TList<Tbytes>);

    function OnRowData(DataNode: string; RowData: Tbytes): Boolean;

    procedure Finished(DataNode: string; Failed: Boolean; ErrorMsg: String);
  end;

  TSQLJob = class(TThread, IResponseHandler)
  private
    FSql: string;
    FdataNodeOrDatabase: string;
    FConnection: ICrossConnection;
    FJobHandler: ISQLJobHandler;
    FCtx: TEngineCtx;
    FDS: TPhysicalDataSource;
    FID: Integer;
    Finished: Boolean;

  end;

  TBatchSQLJob = class
  private
    FRunningJobs: TThreadDictionary<Integer, TSQLJob>;
  protected
    { protected declarations }
  public
    { public declarations }

  published
    { published declarations }
  end;
  // public class  {
  //
  // private ConcurrentHashMap<Integer, SQLJob>  = new ConcurrentHashMap<Integer, SQLJob>();
  // private ConcurrentLinkedQueue<SQLJob> waitingJobs = new ConcurrentLinkedQueue<SQLJob>();
  // private volatile boolean noMoreJobInput = false;
  // /*
  // *
  // * parallExecute: 是否可以并行执行
  // * */
  // public void addJob(SQLJob newJob, boolean parallExecute) {
  //
  // if (parallExecute) {
  // runJob(newJob);
  // } else {
  // waitingJobs.offer(newJob);
  // if (runningJobs.isEmpty()) {
  // SQLJob job = waitingJobs.poll();
  // if (job != null) {
  // runJob(job);
  // }
  // }
  // }
  // }
  // //设置批量任务已经不会在添加任务了。
  // public void setNoMoreJobInput(boolean noMoreJobInput) {
  // this.noMoreJobInput = noMoreJobInput;
  // }
  // //执行任务
  // private void runJob(SQLJob newJob) {
  // // EngineCtx.LOGGER.info("run job " + newJob);
  // runningJobs.put(newJob.getId(), newJob);
  // MycatServer.getInstance().getBusinessExecutor().execute(newJob);
  // }
  // //单个的任务执行完毕。 等待任务列表中有任务，  继续执行下一个任务。
  // //返回： 是否所有的任务执行完毕。
  // public boolean jobFinished(SQLJob sqlJob) {
  // if (EngineCtx.LOGGER.isDebugEnabled()) {
  // EngineCtx.LOGGER.info("job finished " + sqlJob);
  // }
  // runningJobs.remove(sqlJob.getId());
  // SQLJob job = waitingJobs.poll();
  // if (job != null) {
  // runJob(job);
  // return false;
  // } else {
  // if (noMoreJobInput) {
  // return runningJobs.isEmpty() && waitingJobs.isEmpty();
  // } else {
  // return false;
  // }
  // }
  //
  // }
  // }

  //
  // 任务的进行的调用，
  // 向mysqlClient 写数据。
  TEngineCtx = class
  private
    // private final BatchSQLJob bachJob;
    // private AtomicInteger jobId = new AtomicInteger(0);
    // AtomicInteger packetId = new AtomicInteger(0);
    // private final NonBlockingSession session;
    // private AtomicBoolean finished = new AtomicBoolean(false);
    // private AllJobFinishedListener allJobFinishedListener;
    // private AtomicBoolean headerWrited = new AtomicBoolean();
    // private final ReentrantLock writeLock = new ReentrantLock();
    // private volatile boolean hasError = false;
    // private volatile RouteResultset rrs;
    // private volatile boolean isStreamOutputResult = true; //是否流式输出。
  protected
    { protected declarations }
  public
    { public declarations }

  published
    { published declarations }
  end;

  // public class EngineCtx {
  // public static final Logger LOGGER = LoggerFactory.getLogger(ConfFileHandler.class);

  // public EngineCtx(NonBlockingSession session) {
  // this.bachJob = new BatchSQLJob();
  // this.session = session;
  // }
  //
  // public boolean getIsStreamOutputResult(){
  // return isStreamOutputResult;
  // }
  // public void setIsStreamOutputResult(boolean isStreamOutputResult){
  // this. isStreamOutputResult = isStreamOutputResult;
  // }
  // public byte incPackageId() {
  // return (byte) packetId.incrementAndGet();
  // }
  // /*
  // * 将sql 发送到所有的dataNodes分片
  // * 顺序执行
  // * */
  // public void executeNativeSQLSequnceJob(String[] dataNodes, String sql,
  // SQLJobHandler jobHandler) {
  // for (String dataNode : dataNodes) {
  // SQLJob job = new SQLJob(jobId.incrementAndGet(), sql, dataNode,
  // jobHandler, this);
  // bachJob.addJob(job, false);
  //
  // }
  // }
  //
  // public ReentrantLock getWriteLock() {
  // return writeLock;
  // }
  // /*
  // * 所有任务完成的回调
  // * */
  // public void setAllJobFinishedListener(
  // AllJobFinishedListener allJobFinishedListener) {
  // this.allJobFinishedListener = allJobFinishedListener;
  // }
  // /*
  // * 将sql 发送到所有的dataNodes分片
  // * 可以并行执行
  // * */
  // public void executeNativeSQLParallJob(String[] dataNodes, String sql,
  // SQLJobHandler jobHandler) {
  // for (String dataNode : dataNodes) {
  // SQLJob job = new SQLJob(jobId.incrementAndGet(), sql, dataNode,
  // jobHandler, this);
  // bachJob.addJob(job, true);
  //
  // }
  // }
  //
  // /**
  // * set no more jobs created
  // */
  // public void endJobInput() {
  // bachJob.setNoMoreJobInput(true);
  // }
  // //a 表和 b表的字段的信息合并在一块。
  // //向mysql client 输出。
  // public void writeHeader(List<byte[]> afields, List<byte[]> bfields) {
  // if (headerWrited.compareAndSet(false, true)) {
  // try {
  // writeLock.lock();
  // // write new header
  // ResultSetHeaderPacket headerPkg = new ResultSetHeaderPacket();
  // headerPkg.fieldCount = afields.size() +bfields.size()-1;
  // headerPkg.packetId = incPackageId();
  // LOGGER.debug("packge id " + headerPkg.packetId);
  // ServerConnection sc = session.getSource();
  // ByteBuffer buf = headerPkg.write(sc.allocate(), sc, true);
  // // wirte a fields
  // for (byte[] field : afields) {
  // field[3] = incPackageId();
  // buf = sc.writeToBuffer(field, buf);
  // }
  // // write b field
  // for (int i=1;i<bfields.size();i++) {
  // byte[] bfield = bfields.get(i);
  // bfield[3] = incPackageId();
  // buf = sc.writeToBuffer(bfield, buf);
  // }
  // // write field eof
  // EOFPacket eofPckg = new EOFPacket();
  // eofPckg.packetId = incPackageId();
  // buf = eofPckg.write(buf, sc, true);
  // sc.write(buf);
  // //LOGGER.info("header outputed ,packgId:" + eofPckg.packetId);
  // } finally {
  // writeLock.unlock();
  // }
  // }
  //
  // }
  //
  // public void writeHeader(List<byte[]> afields) {
  // if (headerWrited.compareAndSet(false, true)) {
  // try {
  // writeLock.lock();
  // // write new header
  // ResultSetHeaderPacket headerPkg = new ResultSetHeaderPacket();
  // headerPkg.fieldCount = afields.size();// -1;
  // headerPkg.packetId = incPackageId();
  // LOGGER.debug("packge id " + headerPkg.packetId);
  // ServerConnection sc = session.getSource();
  // ByteBuffer buf = headerPkg.write(sc.allocate(), sc, true);
  // // wirte a fields
  // for (byte[] field : afields) {
  // field[3] = incPackageId();
  // buf = sc.writeToBuffer(field, buf);
  // }
  //
  // // write field eof
  // EOFPacket eofPckg = new EOFPacket();
  // eofPckg.packetId = incPackageId();
  // buf = eofPckg.write(buf, sc, true);
  // sc.write(buf);
  // //LOGGER.info("header outputed ,packgId:" + eofPckg.packetId);
  // } finally {
  // writeLock.unlock();
  // }
  // }
  //
  // }
  //
  // public void writeRow(RowDataPacket rowDataPkg) {
  // ServerConnection sc = session.getSource();
  // try {
  // writeLock.lock();
  // rowDataPkg.packetId = incPackageId();
  // // 输出完整的 记录到客户端
  // ByteBuffer buf = rowDataPkg.write(sc.allocate(), sc, true);
  // sc.write(buf);
  // //LOGGER.info("write  row ,packgId:" + rowDataPkg.packetId);
  // } finally {
  // writeLock.unlock();
  // }
  // }
  //
  // public void writeEof() {
  // ServerConnection sc = session.getSource();
  // EOFPacket eofPckg = new EOFPacket();
  // eofPckg.packetId = incPackageId();
  // ByteBuffer buf = eofPckg.write(sc.allocate(), sc, false);
  // sc.write(buf);
  // LOGGER.info("write  eof ,packgId:" + eofPckg.packetId);
  // }
  //
  //
  // public NonBlockingSession getSession() {
  // return session;
  // }
  // //单个sqlJob任务完成之后调用的。
  // //全部任务完成之后 回调allJobFinishedListener 这个函数。
  // public void onJobFinished(SQLJob sqlJob) {
  //
  // boolean allFinished = bachJob.jobFinished(sqlJob);
  // if (allFinished && finished.compareAndSet(false, true)) {
  // if(!hasError){
  // LOGGER.info("all job finished  for front connection: "
  // + session.getSource());
  // allJobFinishedListener.onAllJobFinished(this);
  // }else{
  // LOGGER.info("all job finished with error for front connection: "
  // + session.getSource());
  // }
  // }
  //
  // }
  //
  // public boolean isHasError() {
  // return hasError;
  // }
  //
  // public void setHasError(boolean hasError) {
  // this.hasError = hasError;
  // }
  //
  // public void setRouteResultset(RouteResultset rrs){
  // this.rrs = rrs;
  // }
  // }

implementation

end.
