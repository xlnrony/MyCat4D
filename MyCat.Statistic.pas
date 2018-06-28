unit MyCat.Statistic;

interface

uses
  MyCat.Statistic.Generics.HeartbeatRecord,
  MyCat.Statistic.Generics.DataSourceSyncRecord, DGL_String;

type
  // *
  // * 记录最近3个时段的平均响应时间，默认1，10，30分钟。
  // *
  THeartbeatRecorder = class
  private const
    MAX_RECORD_SIZE: Integer = 256;
    AVG1_TIME: Int64 = 60 * 1000;
    AVG2_TIME: Int64 = 10 * 60 * 1000;
    AVG3_TIME: Int64 = 30 * 60 * 1000;
    SWAP_TIME: Int64 = 24 * 60 * 60 * 1000;
  private
    FAvg1: Int64;
    FAvg2: Int64;
    FAvg3: Int64;
    FRecords: THeartbeatRecordList;
    FRecordsAll: THeartbeatRecordList;
    // *
    // * 计算记录的统计数据
    // *
    procedure Calculate(Time: Int64);
  public
    constructor Create;

    function Get: string;
    procedure &Set(Value: Int64);
    // *
    // * 删除超过统计时间段的数据
    // *
    procedure Remove(Time: Int64);
    function GetRecordsAll: THeartbeatRecordList;
  end;

  // *
  // * 记录最近3个时段的平均响应时间，默认1，10，30分钟。
  // *
  TDataSourceSyncRecorder = class
  private const
    SWAP_TIME: Int64 = 24 * 60 * 60 * 1000;
  private
    FRecords: TStrHashMap;
  private
    FAsynRecords: TDataSourceSyncRecordList; // value,time
    FSwitchType: Integer;
  public
    constructor Create;
  end;
  // public class                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          DataSourceSyncRecorder {
  //
  //
  // public DataSourceSyncRecorder() {
  // }
  //
  // public String get() {
  // return records.toString();
  // }
  //
  // public void set(Map<String, String> resultResult,int switchType) {
  // try{
  // long time = TimeUtil.currentTimeMillis();
  // this.switchType = switchType;
  //
  // remove(time);
  //
  // if (resultResult!=null && !resultResult.isEmpty()) {
  // this.records = resultResult;
  // if(switchType==DataHostConfig.SYN_STATUS_SWITCH_DS){  //slave
  // String sencords = resultResult.get("Seconds_Behind_Master");
  // long Seconds_Behind_Master = -1;
  // if(sencords!=null){
  // Seconds_Behind_Master = Long.parseLong(sencords);
  // }
  // this.asynRecords.add(new Record(TimeUtil.currentTimeMillis(),Seconds_Behind_Master));
  // }
  // if(switchType==DataHostConfig.CLUSTER_STATUS_SWITCH_DS){//cluster
  // double wsrep_local_recv_queue_avg = Double.valueOf(resultResult.get("wsrep_local_recv_queue_avg"));
  // this.asynRecords.add(new Record(TimeUtil.currentTimeMillis(),wsrep_local_recv_queue_avg));
  // }
  //
  // return;
  // }
  // }catch(Exception e){
  // LOGGER.error("record DataSourceSyncRecorder error " + e.getMessage());
  // }
  //
  // }
  //
  // /**
  // * 删除超过统计时间段的数据
  // */
  // private void remove(long time) {
  // final List<Record> recordsAll = this.asynRecords;
  // while (recordsAll.size() > 0) {
  // Record record = recordsAll.get(0);
  // if (time >= record.time + SWAP_TIME) {
  // recordsAll.remove(0);
  // } else {
  // break;
  // }
  // }
  // }
  //
  // public int getSwitchType() {
  // return this.switchType;
  // }
  // public void setSwitchType(int switchType) {
  // this.switchType = switchType;
  // }
  // public Map<String, String> getRecords() {
  // return this.records;
  // }
  // public List<Record> getAsynRecords() {
  // return this.asynRecords;
  // }
  // public static SimpleDateFormat getSdf() {
  // return sdf;
  // }
  //
  // /**
  // * @author mycat
  // */
  // }

implementation

uses
  System.SysUtils, MyCat.Util, Utils.Logger;

{ THeartbeatRecorder }

procedure THeartbeatRecorder.&Set(Value: Int64);
var
  Time: Int64;
  Size: Integer;
begin
  try
    Time := TTimeUtil.currentTimeMillis();
    if Value < 0 then
    begin
      FRecordsAll.PushBack(THeartBeatRecord.Create(Time, 0));
      Exit;
    end;
    Remove(Time);
    Size := FRecords.Size;
    if Size = 0 then
    begin
      FRecords.PushBack(THeartBeatRecord.Create(Time, Value));
      FAvg1 := Value;
      FAvg2 := Value;
      FAvg3 := Value;
      Exit;
    end;
    if Size >= MAX_RECORD_SIZE then
    begin
      FRecords.PopFront;
    end;
    FRecords.PushBack(THeartBeatRecord.Create(Time, Value));
    FRecordsAll.PushBack(THeartBeatRecord.Create(Time, Value));
    Calculate(Time);
  except
    on E: Exception do
    begin
      AppendLog('Record HeartbeatRecorder Error (%s)', [E.Message], ltError);
    end;
  end;
end;

procedure THeartbeatRecorder.Calculate(Time: Int64);
var
  V1: Int64;
  V2: Int64;
  V3: Int64;
  C1: Integer;
  C2: Integer;
  C3: Integer;
  R: THeartBeatRecord;
  T: Int64;
begin
  V1 := 0;
  V2 := 0;
  V3 := 0;

  C1 := 0;
  C2 := 0;
  C3 := 0;
  for R in FRecords do
  begin
    T := Time - R.Time;
    if (T <= AVG1_TIME) then
    begin
      Inc(V1, R.Value);
      Inc(C1);
    end;
    if (T <= AVG2_TIME) then
    begin
      Inc(V2, R.Value);
      Inc(C2);
    end;
    if (T <= AVG3_TIME) then
    begin
      Inc(V3, R.Value);
      Inc(C3);
    end;
  end;
  FAvg1 := V1 div C1;
  FAvg2 := V2 div C2;
  FAvg3 := V3 div C3;
end;

constructor THeartbeatRecorder.Create;
begin
  FRecords := THeartbeatRecordList.Create;
  FRecordsAll := THeartbeatRecordList.Create;
end;

function THeartbeatRecorder.Get: string;
begin
  Result := Format('%d,%d,%d', [FAvg1, FAvg2, FAvg3]);
end;

function THeartbeatRecorder.GetRecordsAll: THeartbeatRecordList;
begin
  Result := FRecordsAll;
end;

procedure THeartbeatRecorder.Remove(Time: Int64);
var
  R: THeartbeatRecord;
begin
  while FRecords.Size > 0 do
  begin
    TMonitor.Enter(FRecords);
    try
      R := FRecords.Front;
      if (Time >= R.Time + AVG3_TIME) then
      begin
        FRecords.PopFront;
      end
      else
      begin
        break;
      end;
    finally
      TMonitor.Exit(FRecords);
    end;
  end;

  while FRecordsAll.Size > 0 do
  begin
    TMonitor.Enter(FRecords);
    try
      R := FRecordsAll.Front;
      if Time >= (R.Time + SWAP_TIME) then
      begin
        FRecordsAll.PopFront;
      end
      else
      begin
        break;
      end;
    finally
      TMonitor.Exit(FRecords);
    end;
  end;
end;

{ TDataSourceSyncRecorder }

constructor TDataSourceSyncRecorder.Create;
begin
  FSwitchType := 2;
  FRecords := TStrHashMap.Create;
  FAsynRecords := TDataSourceSyncRecordList.Create;
end;

end.
