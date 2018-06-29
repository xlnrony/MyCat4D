unit MyCat.BackEnd.HeartBeat;

interface

uses
  MyCat.Statistic;

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
    FHeartbeatTimeout: Int64; // ������ʱʱ��
    FHeartbeatRetry: Integer; // ������ӷ����쳣���л������Դ���
    FHeartbeatSQL: string; // ��̬�������
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

implementation

{ TDBHeartbeat }

constructor TDBHeartbeat.Create;
begin
  FHeartbeatTimeout := DEFAULT_HEARTBEAT_TIMEOUT; // ������ʱʱ��
  FHeartbeatRetry := DEFAULT_HEARTBEAT_RETRY; // ������ӷ����쳣���л������Դ���
  FIsStop := true;
  FIsChecking := false;
  FErrorCount := 0;
  FRecorder := THeartbeatRecorder.Create;
  FAsynRecorder := TDataSourceSyncRecorder.Create;
end;

end.