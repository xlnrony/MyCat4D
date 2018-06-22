unit MyCat.Net.Mysql;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections,
  Net.CrossSocket.Base, MyCat.BackEnd.Mysql;

type
  TMySQLPacket = class
  public const
    //
    // none, this is an internal thread state
    //
    COM_SLEEP: Byte = 0;
    //
    // mysql_close
    //
    COM_QUIT: Byte = 1;
    //
    // mysql_select_db
    //
    COM_INIT_DB: Byte = 2;
    //
    // mysql_real_query
    //
    COM_QUERY: Byte = 3;
    //
    // mysql_list_fields
    //
    COM_FIELD_LIST: Byte = 4;
    //
    // mysql_create_db (deprecated)
    //
    COM_CREATE_DB: Byte = 5;
    //
    // mysql_drop_db (deprecated)
    //
    COM_DROP_DB: Byte = 6;
    //
    // mysql_refresh
    //
    COM_REFRESH: Byte = 7;
    //
    // mysql_shutdown
    //
    COM_SHUTDOWN: Byte = 8;
    //
    // mysql_stat
    //
    COM_STATISTICS: Byte = 9;
    //
    // mysql_list_processes
    //
    COM_PROCESS_INFO: Byte = 10;
    //
    // none, this is an internal thread state
    //
    COM_CONNECT: Byte = 11;
    //
    // mysql_kill
    //
    COM_PROCESS_KILL: Byte = 12;
    //
    // mysql_dump_debug_info
    //
    COM_DEBUG: Byte = 13;
    //
    // mysql_ping
    //
    COM_PING: Byte = 14;
    //
    // none, this is an internal thread state
    //
    COM_TIME: Byte = 15;
    //
    // none, this is an internal thread state
    //
    COM_DELAYED_INSERT: Byte = 16;
    //
    // mysql_change_user
    //
    COM_CHANGE_USER: Byte = 17;
    //
    // used by slave server mysqlbinlog
    //
    COM_BINLOG_DUMP: Byte = 18;
    //
    // used by slave server to get master table
    //
    COM_TABLE_DUMP: Byte = 19;
    //
    // used by slave to log connection to master
    //
    COM_CONNECT_OUT: Byte = 20;
    //
    // used by slave to register to master
    //
    COM_REGISTER_SLAVE: Byte = 21;
    //
    // mysql_stmt_prepare
    //
    COM_STMT_PREPARE: Byte = 22;
    //
    // mysql_stmt_execute
    //
    COM_STMT_EXECUTE: Byte = 23;
    //
    // mysql_stmt_send_long_data
    //
    COM_STMT_SEND_LONG_DATA: Byte = 24;
    //
    // mysql_stmt_close
    //
    COM_STMT_CLOSE: Byte = 25;
    //
    // mysql_stmt_reset
    //
    COM_STMT_RESET: Byte = 26;
    //
    // mysql_set_server_option
    //
    COM_SET_OPTION: Byte = 27;
    //
    // mysql_stmt_fetch
    //
    COM_STMT_FETCH: Byte = 28;
    //
    // Mycat heartbeat
    //
    COM_HEARTBEAT: Byte = 64;

    // 包头大小
    PacketHeaderSize: Integer = 4;

  private
    FPacketLength: Integer;
    FPacketId: Byte;

  public
    //
    // 计算数据包大小，不包含包头长度。
    //
    function CalcPacketSize: Integer; virtual; abstract;
    procedure Write(Stream: TStream); overload; virtual; abstract;
    procedure Write(Connection: ICrossConnection); overload; virtual;
  protected
    //
    // 取得数据包信息
    //
    function GetPacketInfo: String; virtual; abstract;
  end;

  ///
  // @author mycat暂时只发现在load data infile时用到
  //
type
  TEmptyPacket = class(TMySQLPacket)
  public const
    EMPTY: TBytes = [0, 0, 0, 3];
  public
    function CalcPacketSize: Integer; override;
  protected
    function GetPacketInfo: String; override;
  end;

  TAuthPacket = class(TMySQLPacket)
  public const
    FILLER: array [0 .. 22] of Byte = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0);
  public
    ClientFlags: Cardinal;
    MaxPacketSize: Cardinal;
    CharsetIndex: Integer;
    Extra: TBytes; // from FILLER(23)
    User: string;
    PassWord: TBytes;
    DataBase: string;

    procedure Read(Data: TBytes);
    procedure Write(Stream: TStream); overload; override;
    function CalcPacketSize: Integer; override;
  protected
    function GetPacketInfo: String; override;
  end;

  TBinaryPacket = class(TMySQLPacket)
  public const
    OK = 1;
    ERROR = 2;
    HEADER = 3;
    FIELD = 4;
    FIELD_EOF = 5;
    ROW = 6;
    PACKET_EOF = 7;
  public
    Data: TBytes;
  public
    procedure Read(Stream: TStream);
    procedure Write(Stream: TStream); overload; override;
    function CalcPacketSize: Integer; override;
  protected
    function GetPacketInfo: String; override;
  end;

  // *
  // * From Server To Client, part of Result Set Packets. One for each column in the
  // * result set. Thus, if the value of field_columns in the Result Set Header
  // * Packet is 3, then the Field Packet occurs 3 times.
  // *
  // * <pre>
  // * Bytes                      Name
  // * -----                      ----
  // * n (Length Coded String)    catalog
  // * n (Length Coded String)    db
  // * n (Length Coded String)    table
  // * n (Length Coded String)    org_table
  // * n (Length Coded String)    name
  // * n (Length Coded String)    org_name
  // * 1                          (filler)
  // * 2                          charsetNumber
  // * 4                          length
  // * 1                          type
  // * 2                          flags
  // * 1                          decimals
  // * 2                          (filler), always 0x00
  // * n (Length Coded Binary)    default
  // *
  // * @see http://forge.mysql.com/wiki/MySQL_Internals_ClientServer_Protocol#Field_Packet
  // * </pre>
  // *
  // * @author mycat
  // *
  TFieldPacket = class(TMySQLPacket)
  private const
    DEFAULT_CATALOG: TBytes = [Byte('d'), Byte('e'), Byte('f')];
    FILLER: array [0 .. 1] of Byte = (0, 0);

  private
    FCatalog: TBytes; // = DEFAULT_CATALOG;
    FDB: TBytes;
    FTable: TBytes;
    FOrgTable: TBytes;
    FName: TBytes;

    FOrgName: TBytes;
    FCharsetIndex: Integer;
    FLength: Int64;
    FType: Integer;
    FFlags: Integer;
    FDecimals: Byte;
    FDefinition: TBytes;

    procedure ReadBody(const MM: TMySQLMessage);
    procedure WriteBody(Stream: TStream);
  public

    // *
    // * 把字节数组转变成FieldPacket
    // *
    procedure Read(Data: TBytes); overload;
    procedure Read(Bin: TBinaryPacket); overload;
    procedure Write(Stream: TStream); overload; override;
    function CalcPacketSize: Integer; override;
  protected
    function GetPacketInfo: String; override;
  end;

  // *
  // * From server to client. One packet for each row in the result set.
  // *
  // * Bytes                   Name
  // * -----                   ----
  // * n (Length Coded String) (column value)
  // * ...
  // *
  // * (column value):         The data in the column, as a character string.
  // *                         If a column is defined as non-character, the
  // *                         server converts the value into a character
  // *                         before sending it. Since the value is a Length
  // *                         Coded String, a NULL can be represented with a
  // *                         single byte containing 251(see the description
  // *                         of Length Coded Strings in section "Elements" above).
  // *
  // * @see http://forge.mysql.com/wiki/MySQL_Internals_ClientServer_Protocol#Row_Data_Packet

  TRowDataPacket = class(TMySQLPacket)
  private const
    NULL_MARK: Byte = 251;
    EMPTY_MARK: Byte = 0;
  private
    FValue: TBytes;
    FFieldCount: Integer;
    FFieldValues: TList<TBytes>;
  public
    constructor Create(FieldCount: Integer);

    procedure Add(Value: TBytes);
    procedure AddFieldCount(Add: Integer);
    procedure Read(Data: TBytes);
    procedure Write(Stream: TStream); overload; override;

    function CalcPacketSize: Integer; override;
    // property Value: TBytes read FValue;
    // property FieldCount: Integer read FFieldCount;
    // property FieldValues: TList<TBytes> read FFieldValues;
  protected
    function GetPacketInfo: string; override;
  end;

  // *
  // * ProtocolBinary::ResultsetRow:
  // * row of a binary resultset (COM_STMT_EXECUTE)
  //
  // * Payload
  // * 1              packet header [00]
  // * string[$len]   NULL-bitmap, length: (column_count + 7 + 2) / 8
  // * string[$len]   values
  // *
  // * A Binary Protocol Resultset Row is made up of the NULL bitmap
  // * containing as many bits as we have columns in the resultset + 2
  // * and the values for columns that are not NULL in the Binary Protocol Value format.
  // *
  // * @see @http://dev.mysql.com/doc/internals/en/binary-protocol-resultset-row.html#packet-ProtocolBinary::ResultsetRow
  // * @see @http://dev.mysql.com/doc/internals/en/binary-protocol-value.html
  // * @author CrazyPig
  // *
  // *
  TBinaryRowDataPacket = class(TMySQLPacket)
  public const
    PACKET_HEADER: Byte = 0;
  private
    FFieldCount: Integer;
    FFieldValues: TList<TBytes>;
    FNullBitMap: TBytes;
    FFieldPackets: TList<TFieldPacket>;

    procedure StoreNullBitMap(I: Integer);
    // *
    // * 从RowDataPacket的fieldValue的数据转化成BinaryRowDataPacket的fieldValue数据
    // * @param fv
    // * @param fieldPk
    // *
    procedure Convert(FieldValue: TBytes; FieldPacket: TFieldPacket);

  public
    // *
    // * 从RowDataPacket转换成BinaryRowDataPacket
    // * @param fieldPackets 字段包集合
    // * @param rowDataPk 文本协议行数据包
    // *
    procedure Read(FieldPackets: TList<TFieldPacket>;
      RowDataPacket: TRowDataPacket);
    procedure Write(Stream: TStream); override;
    function CalcPacketSize: Integer; override;
  protected
    function GetPacketInfo: string; override;
  end;

  // *
  // * From client to server whenever the client wants the server to do something.
  // *
  // * <pre>
  // * Bytes         Name
  // * -----         ----
  // * 1             command
  // * n             arg
  // *
  // * command:      The most common value is 03 COM_QUERY, because
  // *               INSERT UPDATE DELETE SELECT etc. have this code.
  // *               The possible values at time of writing (taken
  // *               from /include/mysql_com.h for enum_server_command) are:
  // *
  // *               #      Name                Associated client function
  // *               -      ----                --------------------------
  // *               0x00   COM_SLEEP           (none, this is an internal thread state)
  // *               0x01   COM_QUIT            mysql_close
  // *               0x02   COM_INIT_DB         mysql_select_db
  // *               0x03   COM_QUERY           mysql_real_query
  // *               0x04   COM_FIELD_LIST      mysql_list_fields
  // *               0x05   COM_CREATE_DB       mysql_create_db (deprecated)
  // *               0x06   COM_DROP_DB         mysql_drop_db (deprecated)
  // *               0x07   COM_REFRESH         mysql_refresh
  // *               0x08   COM_SHUTDOWN        mysql_shutdown
  // *               0x09   COM_STATISTICS      mysql_stat
  // *               0x0a   COM_PROCESS_INFO    mysql_list_processes
  // *               0x0b   COM_CONNECT         (none, this is an internal thread state)
  // *               0x0c   COM_PROCESS_KILL    mysql_kill
  // *               0x0d   COM_DEBUG           mysql_dump_debug_info
  // *               0x0e   COM_PING            mysql_ping
  // *               0x0f   COM_TIME            (none, this is an internal thread state)
  // *               0x10   COM_DELAYED_INSERT  (none, this is an internal thread state)
  // *               0x11   COM_CHANGE_USER     mysql_change_user
  // *               0x12   COM_BINLOG_DUMP     sent by the slave IO thread to request a binlog
  // *               0x13   COM_TABLE_DUMP      LOAD TABLE ... FROM MASTER (deprecated)
  // *               0x14   COM_CONNECT_OUT     (none, this is an internal thread state)
  // *               0x15   COM_REGISTER_SLAVE  sent by the slave to register with the master (optional)
  // *               0x16   COM_STMT_PREPARE    mysql_stmt_prepare
  // *               0x17   COM_STMT_EXECUTE    mysql_stmt_execute
  // *               0x18   COM_STMT_SEND_LONG_DATA mysql_stmt_send_long_data
  // *               0x19   COM_STMT_CLOSE      mysql_stmt_close
  // *               0x1a   COM_STMT_RESET      mysql_stmt_reset
  // *               0x1b   COM_SET_OPTION      mysql_set_server_option
  // *               0x1c   COM_STMT_FETCH      mysql_stmt_fetch
  // *
  // * arg:          The text of the command is just the way the user typed it, there is no processing
  // *               by the client (except removal of the final ';').
  // *               This field is not a null-terminated string; however,
  // *               the size can be calculated from the packet size,
  // *               and the MySQL client appends '\0' when receiving.
  // *
  // * @see http://forge.mysql.com/wiki/MySQL_Internals_ClientServer_Protocol#Command_Packet_.28Overview.29
  // *

  TCommandPacket = class(TMySQLPacket)
  private
    FCommand: Byte;
    FArg: TBytes;
  public
    procedure Read(Data: TBytes);
    procedure Write(Stream: TStream); override;
    function CalcPacketSize: Integer; override;
  protected
    function GetPacketInfo: string; override;
  end;

  // *
  // * From Server To Client, at the end of a series of Field Packets, and at the
  // * end of a series of Data Packets.With prepared statements, EOF Packet can also
  // * end parameter information, which we'll describe later.
  // *
  // * <pre>
  // * Bytes                 Name
  // * -----                 ----
  // * 1                     field_count, always = 0xfe
  // * 2                     warning_count
  // * 2                     Status Flags
  // *
  // * @see http://forge.mysql.com/wiki/MySQL_Internals_ClientServer_Protocol#EOF_Packet
  // * </pre>
  // *
  TEOFPacket = class(TMySQLPacket)
  public const
    FIELD_COUNT: Byte = $FE;
  private
    FFieldCount: Byte;
    FWarningCount: Integer;
    FStatus: Integer;
  public
    constructor Create;
    procedure Read(Data: TBytes);
    procedure Write(Stream: TStream); override;
    function CalcPacketSize: Integer; override;
  protected
    function GetPacketInfo: string; override;
  end;

  // *
  // * From server to client in response to command, if error.
  // *
  // * <pre>
  // * Bytes                       Name
  // * -----                       ----
  // * 1                           field_count, always = 0xff
  // * 2                           errno
  // * 1                           (sqlstate marker), always '#'
  // * 5                           sqlstate (5 characters)
  // * n                           message
  // *
  // * @see http://forge.mysql.com/wiki/MySQL_Internals_ClientServer_Protocol#Error_Packet
  // * </pre>
  // *
  TErrorPacket = class(TMySQLPacket)
  public const
    FIELD_COUNT: Byte = $FF;
  private const
    SQLSTATE_MARKER: Byte = Ord('#');
    DEFAULT_SQLSTATE: TBytes = [Ord('H'), Ord('Y'), Ord('0'), Ord('0'),
      Ord('0')];

  end;
  // public class ErrorPacket extends MySQLPacket {
  //
  // public byte fieldCount = FIELD_COUNT;
  // public int errno;
  // public byte mark = SQLSTATE_MARKER;
  // public byte[] sqlState = DEFAULT_SQLSTATE;
  // public byte[] message;
  //
  // public void read(BinaryPacket bin) {
  // packetLength = bin.packetLength;
  // packetId = bin.packetId;
  // MySQLMessage mm = new MySQLMessage(bin.data);
  // fieldCount = mm.read();
  // errno = mm.readUB2();
  // if (mm.hasRemaining() && (mm.read(mm.position()) == SQLSTATE_MARKER)) {
  // mm.read();
  // sqlState = mm.readBytes(5);
  // }
  // message = mm.readBytes();
  // }
  //
  // public void read(byte[] data) {
  // MySQLMessage mm = new MySQLMessage(data);
  // packetLength = mm.readUB3();
  // packetId = mm.read();
  // fieldCount = mm.read();
  // errno = mm.readUB2();
  // if (mm.hasRemaining() && (mm.read(mm.position()) == SQLSTATE_MARKER)) {
  // mm.read();
  // sqlState = mm.readBytes(5);
  // }
  // message = mm.readBytes();
  // }
  //
  // public byte[] writeToBytes(FrontendConnection c) {
  // ByteBuffer buffer = c.allocate();
  // buffer = write(buffer, c, false);
  // buffer.flip();
  // byte[] data = new byte[buffer.limit()];
  // buffer.get(data);
  // c.recycle(buffer);
  // return data;
  // }
  // public byte[] writeToBytes() {
  // ByteBuffer buffer = ByteBuffer.allocate(calcPacketSize()+4);
  // int size = calcPacketSize();
  // BufferUtil.writeUB3(buffer, size);
  // buffer.put(packetId);
  // buffer.put(fieldCount);
  // BufferUtil.writeUB2(buffer, errno);
  // buffer.put(mark);
  // buffer.put(sqlState);
  // if (message != null) {
  // buffer.put(message);
  // }
  // buffer.flip();
  // byte[] data = new byte[buffer.limit()];
  // buffer.get(data);
  //
  // return data;
  // }
  // @Override
  // public ByteBuffer write(ByteBuffer buffer, FrontendConnection c,
  // boolean writeSocketIfFull) {
  // int size = calcPacketSize();
  // buffer = c.checkWriteBuffer(buffer, c.getPacketHeaderSize() + size,
  // writeSocketIfFull);
  // BufferUtil.writeUB3(buffer, size);
  // buffer.put(packetId);
  // buffer.put(fieldCount);
  // BufferUtil.writeUB2(buffer, errno);
  // buffer.put(mark);
  // buffer.put(sqlState);
  // if (message != null) {
  // buffer = c.writeToBuffer(message, buffer);
  // }
  // return buffer;
  // }
  //
  //
  //
  // public void write(FrontendConnection c) {
  // ByteBuffer buffer = c.allocate();
  // buffer = this.write(buffer, c, true);
  // c.write(buffer);
  // }
  //
  // @Override
  // public int calcPacketSize() {
  // int size = 9;// 1 + 2 + 1 + 5
  // if (message != null) {
  // size += message.length;
  // }
  // return size;
  // }
  //
  // @Override
  // protected String getPacketInfo() {
  // return "MySQL Error Packet";
  // }
  //
  // }

implementation

uses
  MyCat.Config, MyCat.Util;

{ TEmptyPacket }

function TEmptyPacket.CalcPacketSize: Integer;
begin
  Result := 0;
end;

function TEmptyPacket.GetPacketInfo: String;
begin
  Result := 'MySQL Empty Packet';
end;

{ TAuthPacket }

function TAuthPacket.CalcPacketSize: Integer;
begin
  Result := 32; // 4+4+1+23;
  Inc(Result, Length(User) + 1);
  Inc(Result, TStream.GetLength(PassWord));
  Inc(Result, Length(DataBase) + 1);
end;

function TAuthPacket.GetPacketInfo: String;
begin
  Result := 'MySQL Authentication Packet';
end;

procedure TAuthPacket.Read(Data: TBytes);
var
  MM: TMySQLMessage;
  Current: Integer;
  Len: Integer;
begin
  MM := TMySQLMessage.Create(Data);
  FPacketLength := MM.ReadUB3;
  FPacketId := MM.ReadByte;
  ClientFlags := MM.ReadUB4;
  MaxPacketSize := MM.ReadUB4();
  CharsetIndex := MM.ReadByte and $FF;
  // read extra
  Current := MM.Position;
  Len := MM.ReadLength;
  if (Len > 0) and (Len < Length(FILLER)) then
  begin
    Extra := Copy(MM.Bytes, MM.Position, Len);
  end;
  MM.Position := Current + Length(FILLER);
  User := MM.readStringWithNull;
  PassWord := MM.ReadBytesWithLength();
  if ((ClientFlags and TCapabilities.CLIENT_CONNECT_WITH_DB) <> 0) and MM.HasRemaining
  then
  begin
    DataBase := MM.readStringWithNull;
  end;
end;

procedure TAuthPacket.Write(Stream: TStream);
begin
  Stream.WriteUB3(CalcPacketSize);
  Stream.WriteData(FPacketId);
  Stream.WriteUB4(ClientFlags);
  Stream.WriteUB4(MaxPacketSize);
  Stream.WriteData(Byte(CharsetIndex));
  Stream.WriteData(FILLER);
  if Length(User) = 0 then
  begin
    Stream.WriteData(Byte(0));
  end
  else
  begin
    Stream.WriteWithNull(TEncoding.ANSI.getBytes(User));
  end;
  if Length(PassWord) = 0 then
  begin
    Stream.WriteData(Byte(0));
  end
  else
  begin
    Stream.WriteWithLength(PassWord);
  end;
  if Length(DataBase) = 0 then
  begin
    Stream.WriteData(Byte(0));
  end
  else
  begin
    Stream.WriteWithNull(TEncoding.ANSI.getBytes(DataBase));
  end;
end;

{ TBinaryPacket }

function TBinaryPacket.CalcPacketSize: Integer;
begin
  Result := Length(Data);
end;

function TBinaryPacket.GetPacketInfo: String;
begin
  Result := 'MySQL Binary Packet';
end;

procedure TBinaryPacket.Read(Stream: TStream);
begin
  FPacketLength := Stream.ReadUB3;
  FPacketId := Stream.ReadByte;
  Stream.ReadBuffer(Data, FPacketLength);
end;

procedure TBinaryPacket.Write(Stream: TStream);
begin
  Stream.WriteUB3(CalcPacketSize);
  Stream.WriteData(FPacketId);
  Stream.WriteData(Data, Length(Data));
end;

{ TFieldPacket }

procedure TFieldPacket.Read(Data: TBytes);
var
  MM: TMySQLMessage;
begin
  MM := TMySQLMessage.Create(Data);
  FPacketLength := MM.ReadUB3;
  FPacketId := MM.ReadByte;
  ReadBody(MM);
end;

function TFieldPacket.CalcPacketSize: Integer;
begin
  Result := TStream.GetLength(FCatalog);
  Inc(Result, TStream.GetLength(FDB));
  Inc(Result, TStream.GetLength(FTable));
  Inc(Result, TStream.GetLength(FOrgTable));
  Inc(Result, TStream.GetLength(FName));
  Inc(Result, TStream.GetLength(FOrgName));
  Inc(Result, 13); // 1+2+4+1+2+1+2
  if Assigned(FDefinition) then
  begin
    Inc(Result, TStream.GetLength(FDefinition));
  end;
end;

function TFieldPacket.GetPacketInfo: String;
begin
  Result := 'MySQL Field Packet';
end;

procedure TFieldPacket.Read(Bin: TBinaryPacket);
var
  MM: TMySQLMessage;
begin
  FPacketLength := Bin.FPacketLength;
  FPacketId := Bin.FPacketId;
  MM := TMySQLMessage.Create(Bin.Data);
  ReadBody(MM);
end;

procedure TFieldPacket.ReadBody(const MM: TMySQLMessage);
begin
  FCatalog := MM.ReadBytesWithLength;
  FDB := MM.ReadBytesWithLength;
  FTable := MM.ReadBytesWithLength;
  FOrgTable := MM.ReadBytesWithLength;
  FName := MM.ReadBytesWithLength;
  FOrgName := MM.ReadBytesWithLength;
  MM.move(1);
  FCharsetIndex := MM.ReadUB2;
  FLength := MM.ReadUB4;

  FType := MM.ReadByte and $FF;
  FFlags := MM.ReadUB2;
  FDecimals := MM.ReadByte;
  MM.move(System.Length(FILLER));
  if MM.HasRemaining then
  begin
    FDefinition := MM.ReadBytesWithLength;
  end;
end;

procedure TFieldPacket.Write(Stream: TStream);
begin
  Stream.WriteUB3(CalcPacketSize);
  Stream.WriteData(FPacketId);
  WriteBody(Stream);
end;

procedure TFieldPacket.WriteBody(Stream: TStream);
const
  NullVal: Byte = 0;
begin
  Stream.WriteWithLength(FCatalog, NullVal);
  Stream.WriteWithLength(FCatalog, NullVal);
  Stream.WriteWithLength(FDB, NullVal);
  Stream.WriteWithLength(FTable, NullVal);
  Stream.WriteWithLength(FOrgTable, NullVal);
  Stream.WriteWithLength(FName, NullVal);
  Stream.WriteWithLength(FOrgName, NullVal);
  Stream.WriteData(Byte($0C));
  Stream.WriteUB2(FCharsetIndex);
  Stream.WriteUB4(FLength);
  Stream.WriteData(Byte(FType and $FF));
  Stream.WriteUB2(FFlags);
  Stream.WriteData(FDecimals);
  Stream.WriteData(Byte($00));
  Stream.WriteData(Byte($00));
  if Assigned(FDefinition) then
  begin
    Stream.WriteWithLength(FDefinition);
  end;
end;

{ TMySQLPacket }

procedure TMySQLPacket.Write(Connection: ICrossConnection);
var
  MemoryStream: TMemoryStream;
begin
  MemoryStream := TMemoryStream.Create;
  try
    Write(MemoryStream);
    MemoryStream.Position := 0;
    Connection.SendStream(MemoryStream);
  finally
    MemoryStream.Free;
  end;
end;

{ TBinaryRowDataPacket }

function TBinaryRowDataPacket.CalcPacketSize: Integer;
var
  I: Integer;
  N: Integer;
  FieldValue: TBytes;
begin
  Result := 1 + Length(FNullBitMap);
  N := FFieldValues.Count - 1;
  for I := 0 to N do
  begin
    FieldValue := FFieldValues[I];
    if Assigned(FieldValue) then
    begin
      case FFieldPackets[I].FType of
        TFields.FIELD_TYPE_STRING, TFields.FIELD_TYPE_VARCHAR,
          TFields.FIELD_TYPE_VAR_STRING, TFields.FIELD_TYPE_ENUM,
          TFields.FIELD_TYPE_SET, TFields.FIELD_TYPE_LONG_BLOB,
          TFields.FIELD_TYPE_MEDIUM_BLOB, TFields.FIELD_TYPE_BLOB,
          TFields.FIELD_TYPE_TINY_BLOB, TFields.FIELD_TYPE_GEOMETRY,
          TFields.FIELD_TYPE_BIT, TFields.FIELD_TYPE_DECIMAL,
          TFields.FIELD_TYPE_NEW_DECIMAL:
          begin
            // *
            // * 长度编码的字符串需要计算存储长度, 根据mysql协议文档描述
            // * To convert a length-encoded integer into its numeric value, check the first byte:
            // * If it is < 0xfb, treat it as a 1-byte integer.
            // * If it is 0xfc, it is followed by a 2-byte integer.
            // * If it is 0xfd, it is followed by a 3-byte integer.
            // * If it is 0xfe, it is followed by a 8-byte integer.
            // *
            // *
            if Length(FieldValue) <> 0 then
            begin
              // *
              // * 长度编码的字符串需要计算存储长度,不能简单默认只有1个字节是表示长度,当数据足够长,占用的就不止1个字节
              // *
              Inc(Result, TStream.GetLength(FieldValue));
            end
            else
            begin
              Inc(Result); // 处理空字符串,只计算长度1个字节
            end;
          end;
      else
        begin
          Inc(Result, Length(FieldValue));
        end;
      end;
    end;
  end;
end;

procedure TBinaryRowDataPacket.Convert(FieldValue: TBytes;
  FieldPacket: TFieldPacket);
var
  Bytes: TBytes;
  DateTime: TDateTime;
  DateTimeStr: string;
  TimeStr: string;
begin
  case FieldPacket.FType of
    TFields.FIELD_TYPE_STRING, TFields.FIELD_TYPE_VARCHAR,
      TFields.FIELD_TYPE_VAR_STRING, TFields.FIELD_TYPE_ENUM,
      TFields.FIELD_TYPE_SET, TFields.FIELD_TYPE_LONG_BLOB,
      TFields.FIELD_TYPE_MEDIUM_BLOB, TFields.FIELD_TYPE_BLOB,
      TFields.FIELD_TYPE_TINY_BLOB, TFields.FIELD_TYPE_GEOMETRY,
      TFields.FIELD_TYPE_BIT, TFields.FIELD_TYPE_DECIMAL,
      TFields.FIELD_TYPE_NEW_DECIMAL:
      begin
        // Fields
        // value (lenenc_str) -- string

        // Example
        // 03 66 6f 6f -- string = "foo"
        FFieldValues.Add(FieldValue);
      end;
    TFields.FIELD_TYPE_LONGLONG:
      begin
        // Fields
        // value (8) -- integer

        // Example
        // 01 00 00 00 00 00 00 00 -- int64 = 1

        FFieldValues.Add(TByteUtil.getBytes(TByteUtil.GetLong(FieldValue)));
      end;
    TFields.FIELD_TYPE_LONG, TFields.FIELD_TYPE_INT24:
      begin
        // Fields
        // value (4) -- integer

        // Example
        // 01 00 00 00 -- int32 = 1
        FFieldValues.Add(TByteUtil.getBytes(TByteUtil.GetInt(FieldValue)));
      end;
    TFields.FIELD_TYPE_SHORT, TFields.FIELD_TYPE_YEAR:
      begin
        // Fields
        // value (2) -- integer

        // Example
        // 01 00 -- int16 = 1
        FFieldValues.Add(TByteUtil.getBytes(TByteUtil.GetShort(FieldValue)));
      end;
    TFields.FIELD_TYPE_TINY:
      begin
        // Fields
        // value (1) -- integer

        // Example
        // 01 -- int8 = 1
        // int tinyVar = ;
        SetLength(Bytes, 1);
        Bytes[0] := Byte(TByteUtil.GetInt(FieldValue));
        FFieldValues.Add(Bytes);
      end;
    TFields.FIELD_TYPE_DOUBLE:
      begin
        // Fields
        // value (string.fix_len) -- (len=8) double

        // Example
        // 66 66 66 66 66 66 24 40 -- double = 10.2
        FFieldValues.Add(TByteUtil.getBytes(TByteUtil.GetDouble(FieldValue)));
      end;
    TFields.FIELD_TYPE_FLOAT:
      begin
        // Fields
        // value (string.fix_len) -- (len=4) float

        // Example
        // 33 33 23 41 -- float = 10.2
        FFieldValues.Add(TByteUtil.getBytes(TByteUtil.GetFloat(FieldValue)));
      end;
    TFields.FIELD_TYPE_DATE:
      begin
        try
          DateTime := TDateTimeUtil.ParseDateTime(TByteUtil.GetDate(FieldValue),
            TDateTimeUtil.ONLY_DATE_PATTERN);
          FFieldValues.Add(TByteUtil.getBytes(DateTime, False));
        except
          // 当时间为 0000-00-00 00:00:00 的时候, 默认返回 1970-01-01 08:00:00.0
          FFieldValues.Add(TByteUtil.getBytes(0, False));
        end;
      end;
    TFields.FIELD_TYPE_DATETIME, TFields.FIELD_TYPE_TIMESTAMP:
      begin
        DateTimeStr := TByteUtil.GetDate(FieldValue);
        // Date dateTimeVar = null;
        try
          if Pos('.', DateTimeStr) > 0 then
          begin
            FFieldValues.Add
              (TByteUtil.getBytes(TDateTimeUtil.ParseDateTime(DateTimeStr,
              TDateTimeUtil.FULL_DATETIME_PATTERN), False));
          end
          else
          begin
            FFieldValues.Add
              (TByteUtil.getBytes(TDateTimeUtil.ParseDateTime(DateTimeStr,
              TDateTimeUtil.DEFAULT_DATETIME_PATTERN), False));
          end;
        except
          // 当时间为 0000-00-00 00:00:00 的时候, 默认返回 1970-01-01 08:00:00.0
          FFieldValues.Add(TByteUtil.getBytes(0, False));
        end;
      end;
    TFields.FIELD_TYPE_TIME:
      begin
        TimeStr := TByteUtil.GetTime(FieldValue);
        // Date timeVar = null;
        try
          if Pos('.', TimeStr) > 0 then
          begin
            FFieldValues.Add
              (TByteUtil.getBytes(TDateTimeUtil.ParseDateTime(TimeStr,
              TDateTimeUtil.FULL_TIME_PATTERN), True));
          end
          else
          begin
            FFieldValues.Add
              (TByteUtil.getBytes(TDateTimeUtil.ParseDateTime(TimeStr,
              TDateTimeUtil.DEFAULT_TIME_PATTERN), True));
          end;
        except
          // 当时间为 0000-00-00 00:00:00 的时候, 默认返回 1970-01-01 08:00:00.0
          FFieldValues.Add(TByteUtil.getBytes(0, True)); //
        end;
      end;
  end;
end;

function TBinaryRowDataPacket.GetPacketInfo: string;
begin
  Result := 'MySQL Binary RowData Packet';
end;

procedure TBinaryRowDataPacket.Read(FieldPackets: TList<TFieldPacket>;
  RowDataPacket: TRowDataPacket);
var
  fieldValues: TList<TBytes>;
  FieldValue: TBytes;
  FieldPacket: TFieldPacket;
  I: Integer;
begin
  FFieldPackets := FieldPackets;
  FFieldCount := RowDataPacket.FFieldCount;
  FFieldValues := TList<TBytes>.Create;
  FPacketId := RowDataPacket.FPacketId;
  SetLength(FNullBitMap, (FFieldCount + 7 + 2) div 8);

  fieldValues := RowDataPacket.FFieldValues;
  for I := 0 to FFieldCount - 1 do
  begin
    FieldValue := FFieldValues[I];
    FieldPacket := FieldPackets[I];
    if FieldPacket = nil then
    begin // 字段值为null,根据协议规定存储nullBitMap
      StoreNullBitMap(I);
      fieldValues.Add(FieldValue);
    end
    else
    begin
      Convert(FieldValue, FieldPacket);
    end;
  end;
end;

procedure TBinaryRowDataPacket.StoreNullBitMap(I: Integer);
var
  BitMapPos: Integer;
  BitPos: Integer;
begin
  BitMapPos := (I + 2) div 8;
  BitPos := (I + 2) mod 8;
  FNullBitMap[BitMapPos] := FNullBitMap[BitMapPos] or (Byte(1 shl BitPos));
end;

procedure TBinaryRowDataPacket.Write(Stream: TStream);
var
  I: Integer;
  FieldValue: TBytes;
  FieldPacket: TFieldPacket;
begin
  Stream.WriteUB3(CalcPacketSize);
  Stream.WriteData(FPacketId);
  Stream.WriteData(PACKET_HEADER); // packet header [00]
  Stream.WriteData(FNullBitMap); // NULL-Bitmap
  for I := 0 to FFieldCount - 1 do
  begin
    FieldValue := FFieldValues[I];
    if Assigned(FieldValue) then
    begin
      FieldPacket := FFieldPackets[I];
      case FieldPacket.FType of
        TFields.FIELD_TYPE_STRING, TFields.FIELD_TYPE_VARCHAR,
          TFields.FIELD_TYPE_VAR_STRING, TFields.FIELD_TYPE_ENUM,
          TFields.FIELD_TYPE_SET, TFields.FIELD_TYPE_LONG_BLOB,
          TFields.FIELD_TYPE_MEDIUM_BLOB, TFields.FIELD_TYPE_BLOB,
          TFields.FIELD_TYPE_TINY_BLOB, TFields.FIELD_TYPE_GEOMETRY,
          TFields.FIELD_TYPE_BIT, TFields.FIELD_TYPE_DECIMAL,
          TFields.FIELD_TYPE_NEW_DECIMAL:
          begin
            // 长度编码的字符串需要一个字节来存储长度(0表示空字符串)
            Stream.WriteLength(Length(FieldValue));
          end;
      end;
      if Length(FieldValue) > 0 then
      begin
        Stream.WriteData(FieldValue, Length(FieldValue));
      end;
    end;
  end;
end;

{ TRowDataPacket }

procedure TRowDataPacket.Add(Value: TBytes);
begin
  // 这里应该修改value
  FFieldValues.Add(Value);
end;

procedure TRowDataPacket.AddFieldCount(Add: Integer);
begin
  // 这里应该修改field
  FFieldCount := FFieldCount + Add;
end;

function TRowDataPacket.CalcPacketSize: Integer;
var
  I: Integer;
  V: TBytes;
begin
  Result := 0;
  for I := 0 to FFieldCount - 1 do
  begin
    V := FFieldValues[I];
    if Length(V) = 0 then
    begin
      Inc(Result, 1);
    end
    else
    begin
      Inc(Result, TStream.GetLength(V));
    end;
  end;
end;

constructor TRowDataPacket.Create(FieldCount: Integer);
begin
  FFieldCount := FieldCount;
  FFieldValues := TList<TBytes>.Create;
end;

function TRowDataPacket.GetPacketInfo: string;
begin
  Result := 'MySQL RowData Packet';
end;

procedure TRowDataPacket.Read(Data: TBytes);
var
  MM: TMySQLMessage;
  I: Integer;
begin
  FValue := Data;
  MM := TMySQLMessage.Create(Data);
  FPacketLength := MM.ReadUB3;
  FPacketId := MM.ReadByte;
  for I := 0 to FFieldCount - 1 do
  begin
    FFieldValues.Add(MM.ReadBytesWithLength);
  end;
end;

procedure TRowDataPacket.Write(Stream: TStream);
var
  I: Integer;
  FieldValue: TBytes;
begin
  Stream.WriteUB3(CalcPacketSize);
  Stream.WriteData(FPacketId);
  for I := 0 to FFieldCount - 1 do
  begin
    FieldValue := FFieldValues[I];
    if FieldValue = nil then
    begin
      Stream.WriteData(TRowDataPacket.NULL_MARK);
    end
    else if Length(FieldValue) = 0 then
    begin
      Stream.WriteData(TRowDataPacket.EMPTY_MARK);
    end
    else
    begin
      Stream.WriteLength(Length(FieldValue));
      Stream.WriteData(FieldValue, Length(FieldValue));
    end
  end;
end;

{ TCommandPacket }

function TCommandPacket.CalcPacketSize: Integer;
begin
  Result := 1 + Length(FArg);
end;

function TCommandPacket.GetPacketInfo: string;
begin
  Result := 'MySQL Command Packet';
end;

procedure TCommandPacket.Read(Data: TBytes);
var
  MM: TMySQLMessage;
begin
  MM := TMySQLMessage.Create(Data);
  FPacketLength := MM.ReadUB3;
  FPacketId := MM.ReadByte;
  FCommand := MM.ReadByte;
  FArg := MM.ReadBytes;
end;

procedure TCommandPacket.Write(Stream: TStream);
begin
  Stream.WriteUB3(CalcPacketSize);
  Stream.WriteData(FPacketId);
  Stream.WriteData(FCommand);
  Stream.WriteData(FArg, Length(FArg));
end;

{ TEOFPacket }

function TEOFPacket.CalcPacketSize: Integer;
begin
  Result := 5; // 1+2+2;
end;

constructor TEOFPacket.Create;
begin
  FFieldCount := FIELD_COUNT;
  FStatus := 2;
end;

function TEOFPacket.GetPacketInfo: string;
begin
  Result := 'MySQL EOF Packet';
end;

procedure TEOFPacket.Read(Data: TBytes);
var
  MM: TMySQLMessage;
begin
  MM := TMySQLMessage.Create(Data);
  FPacketLength := MM.ReadUB3;
  FPacketId := MM.ReadByte;
  FFieldCount := MM.ReadByte;
  FWarningCount := MM.ReadUB2;
  FStatus := MM.ReadUB2;
end;

procedure TEOFPacket.Write(Stream: TStream);
begin
  Stream.WriteUB3(CalcPacketSize);
  Stream.WriteData(FPacketId);
  Stream.WriteData(FFieldCount);
  Stream.WriteUB2(FWarningCount);
  Stream.WriteUB2(FStatus);
end;

end.
