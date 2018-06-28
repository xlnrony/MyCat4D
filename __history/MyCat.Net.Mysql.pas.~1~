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
    procedure Write(const Stream: TStream); overload; virtual; abstract;
    procedure Write(const Connection: ICrossConnection); overload; virtual;
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
    procedure Write(const Stream: TStream); overload; override;
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
  private
    FData: TBytes;
  public
    procedure Read(const Stream: TStream);
    procedure Write(const Stream: TStream); overload; override;
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
    FCharsetIndex: SmallInt;
    FLength: Int64;
    FType: Integer;
    FFlags: SmallInt;
    FDecimals: Byte;
    FDefinition: TBytes;

    procedure ReadBody(const MM: TMySQLMessage);
    procedure WriteBody(const Stream: TStream);
  public

    // *
    // * 把字节数组转变成FieldPacket
    // *
    procedure Read(const Data: TBytes); overload;
    procedure Read(const BinaryPacket: TBinaryPacket); overload;
    procedure Write(const Stream: TStream); overload; override;
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
    constructor Create(const FieldCount: Integer);

    procedure Add(const Value: TBytes);
    procedure AddFieldCount(const Add: Integer);
    procedure Read(const Data: TBytes);
    procedure Write(const Stream: TStream); overload; override;

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
    procedure Read(const FieldPackets: TList<TFieldPacket>;
      const RowDataPacket: TRowDataPacket);
    procedure Write(const Stream: TStream); override;
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
    procedure Read(const Data: TBytes);
    procedure Write(const Stream: TStream); override;
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
    FWarningCount: SmallInt;
    FStatus: SmallInt;
  public
    constructor Create;
    procedure Read(const Data: TBytes);
    procedure Write(const Stream: TStream); override;
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
  private
    FFieldCount: Byte;
    FErrno: SmallInt;
    FMark: Byte;
    FSqlState: TBytes;
    FMessage: TBytes;
  public
    constructor Create;

    procedure Read(const BinaryPacket: TBinaryPacket); overload;
    procedure Read(const Data: TBytes); overload;
    procedure Write(const Stream: TStream); override;
    function CalcPacketSize: Integer; override;
  protected
    function GetPacketInfo: string; override;
  end;

  // *
  // *  Bytes                      Name
  // *  -----                      ----
  // *  1                          code
  // *  4                          statement_id
  // *  1                          flags
  // *  4                          iteration_count
  // *  (param_count+7)/8          null_bit_map
  // *  1                          new_parameter_bound_flag (if new_params_bound == 1:)
  // *  n*2                        type of parameters
  // *  n                          values for the parameters
  // *  --------------------------------------------------------------------------------
  // *  code:                      always COM_EXECUTE
  // *
  // *  statement_id:              statement identifier
  // *
  // *  flags:                     reserved for future use. In MySQL 4.0, always 0.
  // *                             In MySQL 5.0:
  // *                               0: CURSOR_TYPE_NO_CURSOR
  // *                               1: CURSOR_TYPE_READ_ONLY
  // *                               2: CURSOR_TYPE_FOR_UPDATE
  // *                               4: CURSOR_TYPE_SCROLLABLE
  // *
  // *  iteration_count:           reserved for future use. Currently always 1.
  // *
  // *  null_bit_map:              A bitmap indicating parameters that are NULL.
  // *                             Bits are counted from LSB, using as many bytes
  // *                             as necessary ((param_count+7)/8)
  // *                             i.e. if the first parameter (parameter 0) is NULL, then
  // *                             the least significant bit in the first byte will be 1.
  // *
  // *  new_parameter_bound_flag:  Contains 1 if this is the first time
  // *                             that "execute" has been called, or if
  // *                             the parameters have been rebound.
  // *
  // *  type:                      Occurs once for each parameter;
  // *                             The highest significant bit of this 16-bit value
  // *                             encodes the unsigned property. The other 15 bits
  // *                             are reserved for the type (only 8 currently used).
  // *                             This block is sent when parameters have been rebound
  // *                             or when a prepared statement is executed for the
  // *                             first time.
  // *
  // *  values:                    for all non-NULL values, each parameters appends its value
  // *                             as described in Row Data Packet: Binary (column values)
  // * @see https://dev.mysql.com/doc/internals/en/com-stmt-execute.html
  // *

  TExecutePacket = class(TMySQLPacket)
  private
    FCode: Byte;
    FStatementId: Int64;
    FFlags: Byte;
    FIterationCount: Int64;
    FNullBitMap: TBytes;
    FNewParameterBoundFlag: Byte;
    FValues: TArray<TBindValue>;
    FPStmt: TPreparedStatement;
  public
    constructor Create(PStmt: TPreparedStatement);
    procedure Read(Data: TBytes; Encoding: TEncoding);
    function CalcPacketSize: Integer; override;
  protected
    function GetPacketInfo: string; override;
  end;

  // *
  // * From server to client during initial handshake.
  // *
  // * Bytes                        Name
  // * -----                        ----
  // * 1                            protocol_version
  // * n (Null-Terminated String)   server_version
  // * 4                            thread_id
  // * 8                            scramble_buff
  // * 1                            (filler) always 0x00
  // * 2                            server_capabilities
  // * 1                            server_language
  // * 2                            server_status
  // * 13                           (filler) always 0x00 ...
  // * 13                           rest of scramble_buff (4.1)
  // *
  // * @see http://forge.mysql.com/wiki/MySQL_Internals_ClientServer_Protocol#Handshake_Initialization_Packet
  // *
  THandshakePacket = class(TMySQLPacket)
  private const
    FILLER_13: array [0 .. 12] of Byte = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0);
  private
    FProtocolVersion: Byte;
    FServerVersion: TBytes;
    FThreadId: Int64;
    FSeed: TBytes;
    FServerCapabilities: Integer;
    FServerCharsetIndex: Byte;
    FServerStatus: Integer;
    FRestOfScrambleBuff: TBytes;
  public
    procedure Read(const BinaryPacket: TBinaryPacket); overload;
    procedure Read(const Data: TBytes); overload;
    procedure Write(const Stream: TStream); override;
    function CalcPacketSize: Integer; override;
  protected
    function GetPacketInfo: string; override;
  end;

  // *
  // * From mycat server to client during initial handshake.
  // *
  // * Bytes                        Name
  // * -----                        ----
  // * 1                            protocol_version (always 0x0a)
  // * n (string[NULL])             server_version
  // * 4                            thread_id
  // * 8 (string[8])                auth-plugin-data-part-1
  // * 1                            (filler) always 0x00
  // * 2                            capability flags (lower 2 bytes)
  // *   if more data in the packet:
  // * 1                            character set
  // * 2                            status flags
  // * 2                            capability flags (upper 2 bytes)
  // *   if capabilities & CLIENT_PLUGIN_AUTH {
  // * 1                            length of auth-plugin-data
  // *   } else {
  // * 1                            0x00
  // *   }
  // * 10 (string[10])              reserved (all 0x00)
  // *   if capabilities & CLIENT_SECURE_CONNECTION {
  // * string[$len]   auth-plugin-data-part-2 ($len=MAX(13, length of auth-plugin-data - 8))
  // *   }
  // *   if capabilities & CLIENT_PLUGIN_AUTH {
  // * string[NUL]    auth-plugin name
  // * }
  // *
  // * @see http://dev.mysql.com/doc/internals/en/connection-phase-packets.html#Protocol::HandshakeV10
  // *
  THandshakeV10Packet = class(TMySQLPacket)
  private const
    FILLER_10: array [0 .. 9] of Byte = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    DEFAULT_AUTH_PLUGIN_NAME: TBytes = [Ord('m'), Ord('y'), Ord('s'), Ord('q'),
      Ord('l'), Ord('_'), Ord('n'), Ord('a'), Ord('t'), Ord('i'), Ord('v'),
      Ord('e'), Ord('_'), Ord('p'), Ord('a'), Ord('s'), Ord('s'), Ord('w'),
      Ord('o'), Ord('r'), Ord('d')];
  private
    FProtocolVersion: Byte;
    FServerVersion: TBytes;
    FThreadId: Int64;
    FSeed: TBytes; // auth-plugin-data-part-1
    FServerCapabilities: Integer;
    FServerCharsetIndex: Byte;
    FServerStatus: Integer;
    FRestOfScrambleBuff: TBytes; // auth-plugin-data-part-2
    FAuthPluginName: TBytes;
  public
    constructor Create;
    procedure Write(const Stream: TStream); override;
    function CalcPacketSize: Integer; override;
  protected
    function GetPacketInfo: string; override;
  end;

  // *
  // * From client to server when the client do heartbeat between mycat cluster.
  // *
  // * <pre>
  // * Bytes         Name
  // * -----         ----
  // * 1             command
  // * n             id
  // *
  THeartbeatPacket = class(TMySQLPacket)
  private
    FCommand: Byte;
    FID: Int64;
  public
    procedure Read(const Data: TBytes);
    procedure Write(const Stream: TStream); override;
    function CalcPacketSize: Integer; override;
  protected
    function GetPacketInfo: string; override;
  end;

  // *
  // * COM_STMT_SEND_LONG_DATA sends the data for a column. Repeating to send it, appends the data to the parameter.
  // * No response is sent back to the client.
  //
  // * COM_STMT_SEND_LONG_DATA:
  // * COM_STMT_SEND_LONG_DATA
  // * direction: client -> server
  // * response: none
  //
  // * payload:
  // *   1              [18] COM_STMT_SEND_LONG_DATA
  // *   4              statement-id
  // *   2              param-id
  // *   n              data
  // *
  // * </pre>
  // *
  // * @see https://dev.mysql.com/doc/internals/en/com-stmt-send-long-data.html
  // *
  TLongDataPacket = class(TMySQLPacket)
  private const
    PACKET_FALG: Byte = 24;
  private
    FPStmtID: Int64;
    FParamID: Int64;
    FLongData: TBytes;
  public
    procedure Read(const Data: TBytes);
    function CalcPacketSize: Integer; override;

    property PStmtID: Int64 read FPStmtID;
    property ParamID: Int64 read FParamID;
    property LongData: TBytes read FLongData;
  protected
    function GetPacketInfo: string; override;
  end;

  // *
  // * From server to client in response to command, if no error and no result set.
  // *
  // * Bytes                       Name
  // * -----                       ----
  // * 1                           field_count, always = 0
  // * 1-9 (Length Coded Binary)   affected_rows
  // * 1-9 (Length Coded Binary)   insert_id
  // * 2                           server_status
  // * 2                           warning_count
  // * n   (until end of packet)   message fix:(Length Coded String)
  // *
  // * @see http://forge.mysql.com/wiki/MySQL_Internals_ClientServer_Protocol#OK_Packet
  // *
  TOkPacket = class(TMySQLPacket)
  public const
    FIELD_COUNT: Byte = 0;
    OK: array [0 .. 10] of Byte = (7, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0);
  private
    FFieldCount: Byte;
    FAffectedRows: Int64;
    FInsertId: Int64;
    FServerStatus: Integer;
    FWarningCount: Integer;
    FMessage: TBytes;

  public
    constructor Create;
    procedure Read(const BinaryPacket: TBinaryPacket); overload;
    procedure Read(const Data: TBytes); overload;
    procedure Write(const Stream: TStream); override;
    function CalcPacketSize: Integer; override;
  protected
    function GetPacketInfo: string; override;
  end;

  TPingPacket = class(TMySQLPacket)
  public const
    PING: array [0 .. 4] of Byte = (1, 0, 0, 0, 14);
    function CalcPacketSize: Integer; override;
  protected
    function GetPacketInfo: string; override;
  end;

  // *
  // * From server to client, in response to prepared statement initialization packet.
  // * It is made up of:
  // *   1.a PREPARE_OK packet
  // *   2.if "number of parameters" > 0
  // *       (field packets) as in a Result Set Header Packet
  // *       (EOF packet)
  // *   3.if "number of columns" > 0
  // *       (field packets) as in a Result Set Header Packet
  // *       (EOF packet)
  // *
  // * -----------------------------------------------------------------------------------------
  // *
  // *  Bytes              Name
  // *  -----              ----
  // *  1                  0 - marker for OK packet
  // *  4                  statement_handler_id
  // *  2                  number of columns in result set
  // *  2                  number of parameters in query
  // *  1                  filler (always 0)
  // *  2                  warning count
  // *
  // *  @see http://dev.mysql.com/doc/internals/en/prepared-statement-initialization-packet.html
  // *

  TPreparedOkPacket = class(TMySQLPacket)
  private
    FFlag: Byte;
    FStatementId: Int64;
    FColumnsNumber: Integer;
    FParametersNumber: Integer;
    FFiller: Byte;
    FWarningCount: Integer;
  public
    constructor Create;
    procedure Write(const Stream: TStream); override;
    function CalcPacketSize: Integer; override;
  protected
    function GetPacketInfo: string; override;
  end;

  TQuitPacket = class(TMySQLPacket)
  public const
    QUIT: array [0 .. 4] of Byte = (1, 0, 0, 0, 1);
  public
    function CalcPacketSize: Integer; override;
  protected
    function GetPacketInfo: string; override;
  end;

  TReply323Packet = class(TMySQLPacket)
  private
    FSeed: TBytes;
  protected
    { protected declarations }
  public
    procedure Write(const Stream: TStream); override;
    function CalcPacketSize: Integer; override;
  protected
    function GetPacketInfo: string; override;
  end;

  /// **
  // * load data local infile 向客户端请求发送文件用
  // */
  TRequestFilePacket = class(TMySQLPacket)
  public const
    FIELD_COUNT: Byte = 251;
  private
    FCommand: Byte;
    FFileName: TBytes;
  public
    constructor Create;
    procedure Write(const Stream: TStream); override;
    function CalcPacketSize: Integer; override;
  protected
    function GetPacketInfo: string; override;
  end;

  // *
  // * COM_STMT_RESET resets the data of a prepared statement which was accumulated with COM_STMT_SEND_LONG_DATA commands and closes the cursor if it was opened with COM_STMT_EXECUTE
  //
  // * The server will send a OK_Packet if the statement could be reset, a ERR_Packet if not.
  // *
  // * COM_STMT_RESET:
  // * COM_STMT_RESET
  // * direction: client -> server
  // * response: OK or ERR
  //
  // * payload:
  // *   1              [1a] COM_STMT_RESET
  // *   4              statement-id
  // *
  TResetPacket = class(TMySQLPacket)
  private const
    PACKET_FALG: Byte = 26;
  private
    FPStmtID: Int64;
  public
    procedure Read(Data: TBytes);
    function CalcPacketSize: Integer; override;

    property PStmtID: Int64 read FPStmtID;
  protected
    function GetPacketInfo: string; override;
  end;

  // *
  // * From server to client after command, if no error and result set -- that is,
  // * if the command was a query which returned a result set. The Result Set Header
  // * Packet is the first of several, possibly many, packets that the server sends
  // * for result sets. The order of packets for a result set is:
  // *
  // * (Result Set Header Packet)   the number of columns
  // * (Field Packets)              column descriptors
  // * (EOF Packet)                 marker: end of Field Packets
  // * (Row Data Packets)           row contents
  // * (EOF Packet)                 marker: end of Data Packets
  // *
  // * Bytes                        Name
  // * -----                        ----
  // * 1-9   (Length-Coded-Binary)  field_count
  // * 1-9   (Length-Coded-Binary)  extra
  // *
  // * @see http://forge.mysql.com/wiki/MySQL_Internals_ClientServer_Protocol#Result_Set_Header_Packet
  // *
  TResultSetHeaderPacket = class(TMySQLPacket)
  private
    FFieldCount: Integer;
    FExtra: Int64;
  public
    procedure Read(const Data: TBytes); overload;
    procedure Write(const Stream: TStream); override;
    function CalcPacketSize: Integer; override;
  protected
    function GetPacketInfo: string; override;
  end;

implementation

uses MyCat.Config, MyCat.Util;

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

procedure TAuthPacket.Write(const Stream: TStream);
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
  Result := Length(FData);
end;

function TBinaryPacket.GetPacketInfo: String;
begin
  Result := 'MySQL Binary Packet';
end;

procedure TBinaryPacket.Read(const Stream: TStream);
begin
  FPacketLength := Stream.ReadUB3;
  FPacketId := Stream.ReadByte;
  Stream.ReadBuffer(FData, FPacketLength);
end;

procedure TBinaryPacket.Write(const Stream: TStream);
begin
  Stream.WriteUB3(CalcPacketSize);
  Stream.WriteData(FPacketId);
  Stream.WriteData(FData, Length(FData));
end;

{ TFieldPacket }

procedure TFieldPacket.Read(const Data: TBytes);

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

procedure TFieldPacket.Read(const BinaryPacket: TBinaryPacket);

var
  MM: TMySQLMessage;
begin
  FPacketLength := BinaryPacket.FPacketLength;
  FPacketId := BinaryPacket.FPacketId;
  MM := TMySQLMessage.Create(BinaryPacket.FData);
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

procedure TFieldPacket.Write(const Stream: TStream);
begin
  Stream.WriteUB3(CalcPacketSize);
  Stream.WriteData(FPacketId);
  WriteBody(Stream);
end;

procedure TFieldPacket.WriteBody(const Stream: TStream);

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

procedure TMySQLPacket.Write(const Connection: ICrossConnection);

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

procedure TBinaryRowDataPacket.Read(const FieldPackets: TList<TFieldPacket>;
  const RowDataPacket: TRowDataPacket);

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

procedure TBinaryRowDataPacket.Write(const Stream: TStream);

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

procedure TRowDataPacket.Add(const Value: TBytes);
begin
  // 这里应该修改value
  FFieldValues.Add(Value);
end;

procedure TRowDataPacket.AddFieldCount(const Add: Integer);
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

constructor TRowDataPacket.Create(const FieldCount: Integer);
begin
  FFieldCount := FieldCount;
  FFieldValues := TList<TBytes>.Create;
end;

function TRowDataPacket.GetPacketInfo: string;
begin
  Result := 'MySQL RowData Packet';
end;

procedure TRowDataPacket.Read(const Data: TBytes);

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

procedure TRowDataPacket.Write(const Stream: TStream);

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

procedure TCommandPacket.Read(const Data: TBytes);

var
  MM: TMySQLMessage;
begin
  MM := TMySQLMessage.Create(Data);
  FPacketLength := MM.ReadUB3;
  FPacketId := MM.ReadByte;
  FCommand := MM.ReadByte;
  FArg := MM.ReadBytes;
end;

procedure TCommandPacket.Write(const Stream: TStream);
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

procedure TEOFPacket.Read(const Data: TBytes);

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

procedure TEOFPacket.Write(const Stream: TStream);
begin
  Stream.WriteUB3(CalcPacketSize);
  Stream.WriteData(FPacketId);
  Stream.WriteData(FFieldCount);
  Stream.WriteUB2(FWarningCount);
  Stream.WriteUB2(FStatus);
end;

{ TErrorPacket }

function TErrorPacket.CalcPacketSize: Integer;
begin
  Result := 1 + 2 + 1 + 5;
  if Assigned(FMessage) then
  begin
    Inc(Result, Length(FMessage));
  end;
end;

constructor TErrorPacket.Create;
begin
  FFieldCount := FIELD_COUNT;
  FMark := SQLSTATE_MARKER;
  FSqlState := DEFAULT_SQLSTATE;
end;

procedure TErrorPacket.Read(const BinaryPacket: TBinaryPacket);

var
  MM: TMySQLMessage;
begin
  FPacketLength := BinaryPacket.FPacketLength;
  FPacketId := BinaryPacket.FPacketId;
  MM := TMySQLMessage.Create(BinaryPacket.FData);
  FFieldCount := MM.ReadByte;
  FErrno := MM.ReadUB2;
  if MM.HasRemaining and (MM.ReadByte(MM.Position) = SQLSTATE_MARKER) then
  begin
    MM.ReadByte;
    FSqlState := MM.ReadBytes(5);
  end;
  FMessage := MM.ReadBytes();
end;

function TErrorPacket.GetPacketInfo: string;
begin
  Result := 'MySQL Error Packet';
end;

procedure TErrorPacket.Read(const Data: TBytes);

var
  MM: TMySQLMessage;
begin
  MM := TMySQLMessage.Create(Data);
  FPacketLength := MM.ReadUB3();
  FPacketId := MM.ReadByte;
  FFieldCount := MM.ReadByte;
  FErrno := MM.ReadUB2;
  if MM.HasRemaining and (MM.ReadByte(MM.Position) = SQLSTATE_MARKER) then
  begin
    MM.ReadByte;
    FSqlState := MM.ReadBytes(5);
  end;
  FMessage := MM.ReadBytes();
end;

procedure TErrorPacket.Write(const Stream: TStream);
begin
  Stream.WriteUB3(CalcPacketSize);
  Stream.WriteData(FPacketId);
  Stream.WriteData(FFieldCount);
  Stream.WriteUB2(FErrno);
  Stream.WriteData(FMark);
  Stream.WriteData(FSqlState);
  if Assigned(FMessage) then
  begin
    Stream.WriteData(FMessage, Length(FMessage));
  end;
end;

{ TExecutePacket }

function TExecutePacket.CalcPacketSize: Integer;
begin
  Result := 0;
end;

constructor TExecutePacket.Create(PStmt: TPreparedStatement);
begin
  FPStmt := PStmt;
  SetLength(FValues, PStmt.ParametersNumber);
end;

function TExecutePacket.GetPacketInfo: string;
begin
  Result := 'MySQL Execute Packet';
end;

procedure TExecutePacket.Read(Data: TBytes; Encoding: TEncoding);

var
  MM: TMySQLMessage;
  ParameterCount: Integer;
  I: Integer;
begin
  MM := TMySQLMessage.Create(Data);
  FPacketLength := MM.ReadUB3;
  FPacketId := MM.ReadByte;
  FCode := MM.ReadByte;
  FStatementId := MM.ReadUB4;
  FFlags := MM.ReadByte;
  FIterationCount := MM.ReadUB4;

  // 读取NULL指示器数据
  ParameterCount := Length(FValues);
  if ParameterCount > 0 then
  begin
    SetLength(FNullBitMap, (ParameterCount + 7) div 8);
    for I := 0 to Length(FNullBitMap) - 1 do
    begin
      FNullBitMap[I] := MM.ReadByte;
    end;

    // 当newParameterBoundFlag==1时，更新参数类型。
    FNewParameterBoundFlag := MM.ReadByte;
  end;
  if FNewParameterBoundFlag = 1 then
  begin
    for I := 0 to ParameterCount - 1 do
    begin
      FPStmt.ParametersType[I] := MM.ReadUB2;
    end;
  end;

  // 设置参数类型和读取参数值
  for I := 0 to ParameterCount - 1 do
  begin
    FValues[I].FType := FPStmt.ParametersType[I];
    if (FNullBitMap[I div 8] and (1 shl (I and 7))) <> 0 then
    begin
      FValues[I].FIsNull := True;
    end
    else
    begin
      FValues[I].Read(MM, Encoding);
      if FValues[I].FIsLongData then
      begin
        FValues[I].FLongDataBinding := FPStmt.LongData[I];
      end;
    end;
  end;
end;

{ THandshakePacket }

procedure THandshakePacket.Read(const BinaryPacket: TBinaryPacket);

var
  MM: TMySQLMessage;
begin
  FPacketLength := BinaryPacket.FPacketLength;
  FPacketId := BinaryPacket.FPacketId;
  MM := TMySQLMessage.Create(BinaryPacket.FData);
  FProtocolVersion := MM.ReadByte;
  FServerVersion := MM.ReadBytesWithNull;
  FThreadId := MM.ReadUB4;
  FSeed := MM.ReadBytesWithNull;
  FServerCapabilities := MM.ReadUB2;
  FServerCharsetIndex := MM.ReadByte;
  FServerStatus := MM.ReadUB2;
  MM.move(13);
  FRestOfScrambleBuff := MM.ReadBytesWithNull;
end;

function THandshakePacket.CalcPacketSize: Integer;
begin
  Result := 1;
  Inc(Result, Length(FServerVersion)); // n
  Inc(Result, 5); // 1+4
  Inc(Result, Length(FSeed)); // 8
  Inc(Result, 19); // 1+2+1+2+13
  Inc(Result, Length(FRestOfScrambleBuff)); // 12
  Inc(Result, 1); // 1
end;

function THandshakePacket.GetPacketInfo: string;
begin
  Result := 'MySQL Handshake Packet';
end;

procedure THandshakePacket.Read(const Data: TBytes);

var
  MM: TMySQLMessage;
begin
  MM := TMySQLMessage.Create(Data);
  FPacketLength := MM.ReadUB3;
  FPacketId := MM.ReadByte;
  FProtocolVersion := MM.ReadByte;
  FServerVersion := MM.ReadBytesWithNull;
  FThreadId := MM.ReadUB4;
  FSeed := MM.ReadBytesWithNull;
  FServerCapabilities := MM.ReadUB2;
  FServerCharsetIndex := MM.ReadByte;
  FServerStatus := MM.ReadUB2;
  MM.move(13);
  FRestOfScrambleBuff := MM.ReadBytesWithNull;
end;

procedure THandshakePacket.Write(const Stream: TStream);
begin
  Stream.WriteUB3(CalcPacketSize);
  Stream.WriteData(FPacketId);
  Stream.WriteData(FProtocolVersion);
  Stream.WriteWithNull(FServerVersion);
  Stream.WriteUB4(FThreadId);
  Stream.WriteWithNull(FSeed);
  Stream.WriteUB2(FServerCapabilities);
  Stream.WriteData(FServerCharsetIndex);
  Stream.WriteUB2(FServerStatus);
  Stream.WriteData(FILLER_13);
  Stream.WriteWithNull(FRestOfScrambleBuff);
end;

{ THeartbeatPacket }

function THeartbeatPacket.CalcPacketSize: Integer;
begin
  Result := 1 + TStream.GetLength(FID);
end;

function THeartbeatPacket.GetPacketInfo: string;
begin
  Result := 'Mycat Heartbeat Packet';
end;

procedure THeartbeatPacket.Read(const Data: TBytes);

var
  MM: TMySQLMessage;
begin
  MM := TMySQLMessage.Create(Data);
  FPacketLength := MM.ReadUB3;
  FPacketId := MM.ReadByte;
  FCommand := MM.ReadByte;
  FID := MM.ReadLength;
end;

procedure THeartbeatPacket.Write(const Stream: TStream);
begin
  Stream.WriteUB3(CalcPacketSize);
  Stream.WriteData(FPacketId);
  Stream.WriteData(FCommand);
  Stream.WriteLength(FID);
end;

{ TLongDataPacket }

function TLongDataPacket.CalcPacketSize: Integer;
begin
  Result := 1 + 4 + 2 + Length(FLongData);
end;

function TLongDataPacket.GetPacketInfo: string;
begin
  Result := 'MySQL Long Data Packet';
end;

procedure TLongDataPacket.Read(const Data: TBytes);

var
  MM: TMySQLMessage;
begin
  MM := TMySQLMessage.Create(Data);
  FPacketLength := MM.ReadUB3;
  FPacketId := MM.ReadByte;
  Assert(MM.ReadByte = PACKET_FALG);
  FPStmtID := MM.ReadUB4;
  FParamID := MM.ReadUB2;
  FLongData := MM.ReadBytes(FPacketLength - (1 + 4 + 2));
end;

{ TOkPacket }

function TOkPacket.CalcPacketSize: Integer;
begin
  Result := 1;
  Inc(Result, TStream.GetLength(FAffectedRows));
  Inc(Result, TStream.GetLength(FInsertId));
  Inc(Result, 4);
  if Assigned(FMessage) then
  begin
    Inc(Result, TStream.GetLength(FMessage));
  end;
end;

constructor TOkPacket.Create;
begin
  FFieldCount := FIELD_COUNT;
end;

function TOkPacket.GetPacketInfo: string;
begin
  Result := 'MySQL OK Packet';
end;

procedure TOkPacket.Read(const Data: TBytes);

var
  MM: TMySQLMessage;
begin
  MM := TMySQLMessage.Create(Data);
  FPacketLength := MM.ReadUB3;
  FPacketId := MM.ReadByte;
  FFieldCount := MM.ReadByte;
  FAffectedRows := MM.ReadLength;
  FInsertId := MM.ReadLength;
  FServerStatus := MM.ReadUB2;
  FWarningCount := MM.ReadUB2;
  if MM.HasRemaining then
  begin
    FMessage := MM.ReadBytesWithLength;
  end;
end;

procedure TOkPacket.Read(const BinaryPacket: TBinaryPacket);

var
  MM: TMySQLMessage;
begin
  FPacketLength := BinaryPacket.FPacketLength;
  FPacketId := BinaryPacket.FPacketId;
  MM := TMySQLMessage.Create(BinaryPacket.FData);
  FFieldCount := MM.ReadByte;
  FAffectedRows := MM.ReadLength;
  FInsertId := MM.ReadLength;
  FServerStatus := MM.ReadUB2;
  FWarningCount := MM.ReadUB2;
  if MM.HasRemaining then
  begin
    FMessage := MM.ReadBytesWithLength;
  end;
end;

procedure TOkPacket.Write(const Stream: TStream);
begin
  Stream.WriteUB3(CalcPacketSize);
  Stream.WriteData(FPacketId);
  Stream.WriteData(FFieldCount);
  Stream.WriteLength(FAffectedRows);
  Stream.WriteLength(FInsertId);
  Stream.WriteUB2(FServerStatus);
  Stream.WriteUB2(FWarningCount);
  if Assigned(FMessage) then
  begin
    Stream.WriteWithLength(FMessage);
  end;
end;

{ TPingPacket }

function TPingPacket.CalcPacketSize: Integer;
begin
  Result := 1;
end;

function TPingPacket.GetPacketInfo: string;
begin
  Result := 'MySQL Ping Packet';
end;

{ TPreparedOkPacket }

function TPreparedOkPacket.CalcPacketSize: Integer;
begin
  Result := 12;
end;

constructor TPreparedOkPacket.Create;
begin
  FFlag := 0;
  FFiller := 0;
end;

function TPreparedOkPacket.GetPacketInfo: string;
begin
  Result := 'MySQL PreparedOk Packet';
end;

procedure TPreparedOkPacket.Write(const Stream: TStream);
begin
  // int size = ();
  // buffer = c.checkWriteBuffer(buffer, c.getPacketHeaderSize() + size,writeSocketIfFull);
  Stream.WriteUB3(CalcPacketSize);
  Stream.WriteData(FPacketId);
  Stream.WriteData(FFlag);
  Stream.WriteUB4(FStatementId);
  Stream.WriteUB2(FColumnsNumber);
  Stream.WriteUB2(FParametersNumber);
  Stream.WriteData(FFiller);
  Stream.WriteUB2(FWarningCount);
end;

{ TQuitPacket }

function TQuitPacket.CalcPacketSize: Integer;
begin
  Result := 1;
end;

function TQuitPacket.GetPacketInfo: string;
begin
  Result := 'MySQL Quit Packet';
end;

{ TReply323Packet }

function TReply323Packet.CalcPacketSize: Integer;
begin
  if FSeed = nil then
  begin
    Result := 1;
  end
  else
  begin
    Result := Length(FSeed) + 1;
  end;
end;

function TReply323Packet.GetPacketInfo: string;
begin
  Result := 'MySQL Auth323 Packet';
end;

procedure TReply323Packet.Write(const Stream: TStream);
begin
  Stream.WriteUB3(CalcPacketSize);
  Stream.WriteData(FPacketId);
  if FSeed = nil then
  begin
    Stream.WriteData(Byte(0));
  end
  else
  begin
    Stream.WriteWithNull(FSeed);
  end;
end;

{ THandshakeV10Packet }

function THandshakeV10Packet.CalcPacketSize: Integer;
begin
  Result := 1; // protocol version
  Inc(Result, Length(FServerVersion) + 1); // server version
  Inc(Result, 4); // connection id
  Inc(Result, Length(FSeed));
  Inc(Result, 1); // [00] filler
  Inc(Result, 2); // capability flags (lower 2 bytes)
  Inc(Result, 1); // character set
  Inc(Result, 2); // status flags
  Inc(Result, 2); // capability flags (upper 2 bytes)
  Inc(Result, 1);
  Inc(Result, 10); // reserved (all [00])
  if (FServerCapabilities and TCapabilities.CLIENT_SECURE_CONNECTION) <> 0 then
  begin
    // restOfScrambleBuff.length always to be 12
    if Length(FRestOfScrambleBuff) <= 13 then
    begin
      Inc(Result, 13);
    end
    else
    begin
      Inc(Result, Length(FRestOfScrambleBuff));
    end;
  end;
  if (FServerCapabilities and TCapabilities.CLIENT_PLUGIN_AUTH) <> 0 then
  begin
    Inc(Result, Length(FAuthPluginName) + 1); // auth-plugin name
  end;
end;

constructor THandshakeV10Packet.Create;
begin
  FAuthPluginName := DEFAULT_AUTH_PLUGIN_NAME;
end;

function THandshakeV10Packet.GetPacketInfo: string;
begin
  Result := 'MySQL HandshakeV10 Packet';
end;

procedure THandshakeV10Packet.Write(const Stream: TStream);
var
  I: Integer;
begin
  Stream.WriteUB3(CalcPacketSize);
  Stream.WriteData(FPacketId);
  Stream.WriteData(FProtocolVersion);
  Stream.WriteWithNull(FServerVersion);
  Stream.WriteUB4(FThreadId);
  Stream.WriteData(FSeed, Length(FSeed));
  Stream.WriteData(Byte(0)); // [00] filler
  Stream.WriteUB2(FServerCapabilities);
  // capability flags (lower 2 bytes)
  Stream.WriteData(FServerCharsetIndex);
  Stream.WriteUB2(FServerStatus);
  Stream.WriteUB2(FServerCapabilities shr 16);
  // capability flags (upper 2 bytes)
  if (FServerCapabilities and TCapabilities.CLIENT_PLUGIN_AUTH) <> 0 then
  begin
    if Length(FRestOfScrambleBuff) <= 13 then
    begin
      Stream.WriteData(Byte(Length(FSeed) + 13));
    end
    else
    begin
      Stream.WriteData(Byte(Length(FSeed) + Length(FRestOfScrambleBuff)));
    end;
  end
  else
  begin
    Stream.WriteData(Byte(0));
  end;
  Stream.WriteData(FILLER_10);
  if (FServerCapabilities and TCapabilities.CLIENT_SECURE_CONNECTION) <> 0 then
  begin
    Stream.WriteData(FRestOfScrambleBuff);
    // restOfScrambleBuff.length always to be 12
    if Length(FRestOfScrambleBuff) < 13 then
    begin
      for I := 13 - Length(FRestOfScrambleBuff) downto 1 do
      begin
        Stream.WriteData(Byte(0));
      end;
    end;
  end;
  if (FServerCapabilities and TCapabilities.CLIENT_PLUGIN_AUTH) <> 0 then
  begin
    Stream.WriteWithNull(FAuthPluginName);
  end;
end;

{ TRequestFilePacket }

function TRequestFilePacket.CalcPacketSize: Integer;
begin
  Result := 1 + Length(FFileName);
end;

constructor TRequestFilePacket.Create;
begin
  FCommand := FIELD_COUNT;
end;

function TRequestFilePacket.GetPacketInfo: string;
begin
  Result := 'MySQL Request File Packet';
end;

procedure TRequestFilePacket.Write(const Stream: TStream);
begin
  Stream.WriteUB3(CalcPacketSize);
  Stream.WriteData(FPacketId);
  Stream.WriteData(FCommand);
  if FFileName <> nil then
  begin
    Stream.WriteData(FFileName, Length(FFileName));
  end;
end;

{ TResetPacket }

function TResetPacket.CalcPacketSize: Integer;
begin
  Result := 1 + 4;
end;

function TResetPacket.GetPacketInfo: string;
begin
  Result := 'MySQL Reset Packet';
end;

procedure TResetPacket.Read(Data: TBytes);
var
  MM: TMySQLMessage;
begin
  MM := TMySQLMessage.Create(Data);
  FPacketLength := MM.ReadUB3();
  FPacketId := MM.ReadByte;
  Assert(MM.ReadByte = PACKET_FALG);
  FPStmtID := MM.ReadUB4;
end;

{ TResultSetHeaderPacket }

function TResultSetHeaderPacket.CalcPacketSize: Integer;
begin
  Result := TStream.GetLength(FFieldCount);
  if FExtra > 0 then
  begin
    Inc(Result, TStream.GetLength(FExtra));
  end;
end;

function TResultSetHeaderPacket.GetPacketInfo: string;
begin
  Result := 'MySQL ResultSetHeader Packet';
end;

procedure TResultSetHeaderPacket.Read(const Data: TBytes);
var
  MM: TMySQLMessage;
begin
  MM := TMySQLMessage.Create(Data);
  FPacketLength := MM.ReadUB3;
  FPacketId := MM.ReadByte;
  FFieldCount := Integer(MM.ReadLength);
  if MM.HasRemaining then
  begin
    FExtra := MM.ReadLength;
  end;
end;

procedure TResultSetHeaderPacket.Write(const Stream: TStream);
begin
  Stream.WriteUB3(CalcPacketSize);
  Stream.WriteData(FPacketId);
  Stream.WriteLength(FFieldCount);
  if FExtra > 0 then
  begin
    Stream.WriteLength(FExtra);
  end;
end;

end.
