unit MyCat.BackEnd.Mysql.CrossSocket.Handler;

interface

uses
  System.Generics.Collections, MyCat.Net.CrossSocket.Base, System.SysUtils,
  MyCat.BackEnd.Mysql.CrossSocket.Handler.Generics.HeartBeatConnection,
  MyCat.BackEnd, MyCat.BackEnd.Mysql.CrossSocket.Handler.ResponseHandler;

type
  /// **
  // * heartbeat check for mysql connections
  // *
  // * @author wuzhih
  // *
  // */
  TConnectionHeartBeatHandler = class(TObject, IResponseHandler)
  private
    FAllConnections: THeartBeatConnectionHashMap;
  public
    constructor Create;

    procedure DoHeartBeat(Connection: IBackEndConnection; SQL: string);
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
  // if (allCons.isEmpty()) {
  // return;
  // }
  // Collection<BackendConnection> abandCons = new LinkedList<BackendConnection>();
  // long curTime = System.currentTimeMillis();
  // Iterator<Entry<Long, HeartBeatCon>> itors = allCons.entrySet()
  // .iterator();
  // while (itors.hasNext()) {
  // HeartBeatCon hbCon = itors.next().getValue();
  // if (hbCon.timeOutTimestamp < curTime) {
  // abandCons.add(hbCon.conn);
  // itors.remove();
  // }
  // }
  //
  // if (!abandCons.isEmpty()) {
  // for (BackendConnection con : abandCons) {
  // try {
  // // if(con.isBorrowed())
  // con.close("heartbeat timeout ");
  // } catch (Exception e) {
  // LOGGER.warn("close err:" + e);
  // }
  // }
  // }
  //
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
  // private void executeException(BackendConnection c, Throwable e) {
  // removeFinished(c);
  // LOGGER.warn("executeException   ", e);
  // c.close("heatbeat exception:" + e);
  //
  // }
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

implementation

uses
  MyCat.Util.Logger;

{ TConnectionHeartBeatHandler }

constructor TConnectionHeartBeatHandler.Create;
begin
  FAllConnections := THeartBeatConnectionHashMap.Create;
end;

procedure TConnectionHeartBeatHandler.DoHeartBeat
  (Connection: IBackEndConnection; SQL: string);
begin
  AppendLog('do heartbeat for con ' + Connection.PeerAddr);

  try
    // HeartBeatCon hbCon = new HeartBeatCon(conn);
    if FAllConnections.Find(Connection.UID) = FAllConnections.ItEnd then
    begin
      FAllConnections.Insert(Connection.UID,
        THeartBeatConnection.Create(Connection));
      Connection.SetResponseHandler(this);
      Connection.query(SQL);
    end;
  except
    on E: Exception do
    begin
      executeException(conn, E);
    end;
  end;
end;

end.
