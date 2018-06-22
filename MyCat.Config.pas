unit MyCat.Config;

interface

type
  TCapabilities = class
  public const
    // new more secure passwords
    CLIENT_LONG_PASSWORD = 1;

    // Found instead of affected rows
    // 返回找到（匹配）的行数，而不是改变了的行数。
    CLIENT_FOUND_ROWS = 2;

    // Get all column flags
    CLIENT_LONG_FLAG = 4;

    // One can specify db on connect
    CLIENT_CONNECT_WITH_DB = 8;

    // Don't allow database.table.column
    // 不允许“数据库名.表名.列名”这样的语法。这是对于ODBC的设置。
    // 当使用这样的语法时解析器会产生一个错误，这对于一些ODBC的程序限制bug来说是有用的。
    CLIENT_NO_SCHEMA = 16;

    // Can use compression protocol
    // 使用压缩协议
    CLIENT_COMPRESS = 32;

    // Odbc client
    CLIENT_ODBC = 64;

    // Can use LOAD DATA LOCAL
    CLIENT_LOCAL_FILES = 128;

    // Ignore spaces before '('
    // 允许在函数名后使用空格。所有函数名可以预留字。
    CLIENT_IGNORE_SPACE = 256;

    // New 4.1 protocol This is an interactive client
    CLIENT_PROTOCOL_41 = 512;

    // This is an interactive client
    // 允许使用关闭连接之前的不活动交互超时的描述，而不是等待超时秒数。
    // 客户端的会话等待超时变量变为交互超时变量。
    CLIENT_INTERACTIVE = 1024;

    // Switch to SSL after handshake
    // 使用SSL。这个设置不应该被应用程序设置，他应该是在客户端库内部是设置的。
    // 可以在调用mysql_real_connect()之前调用mysql_ssl_set()来代替设置。
    CLIENT_SSL = 2048;

    // IGNORE sigpipes
    // 阻止客户端库安装一个SIGPIPE信号处理器。
    // 这个可以用于当应用程序已经安装该处理器的时候避免与其发生冲突。
    CLIENT_IGNORE_SIGPIPE = 4096;

    // Client knows about transactions
    CLIENT_TRANSACTIONS = 8192;

    // Old flag for 4.1 protocol
    CLIENT_RESERVED = 16384;

    // New 4.1 authentication
    CLIENT_SECURE_CONNECTION = 32768;

    // Enable/disable multi-stmt support
    // 通知服务器客户端可以发送多条语句（由分号分隔）。如果该标志为没有被设置，多条语句执行。
    CLIENT_MULTI_STATEMENTS = 65536;

    // Enable/disable multi-results
    // 通知服务器客户端可以处理由多语句或者存储过程执行生成的多结果集。
    // 当打开CLIENT_MULTI_STATEMENTS时，这个标志自动的被打开。
    CLIENT_MULTI_RESULTS = 131072;

    CLIENT_PLUGIN_AUTH = $00080000; // 524288
  end;

  TFields = class
  public const
    FIELD_TYPE_DECIMAL = 0;
    FIELD_TYPE_TINY = 1;
    FIELD_TYPE_SHORT = 2;
    FIELD_TYPE_LONG = 3;
    FIELD_TYPE_FLOAT = 4;
    FIELD_TYPE_DOUBLE = 5;
    FIELD_TYPE_NULL = 6;
    FIELD_TYPE_TIMESTAMP = 7;
    FIELD_TYPE_LONGLONG = 8;
    FIELD_TYPE_INT24 = 9;
    FIELD_TYPE_DATE = 10;
    FIELD_TYPE_TIME = 11;
    FIELD_TYPE_DATETIME = 12;
    FIELD_TYPE_YEAR = 13;
    FIELD_TYPE_NEWDATE = 14;
    FIELD_TYPE_VARCHAR = 15;
    FIELD_TYPE_BIT = 16;
    FIELD_TYPE_NEW_DECIMAL = 246;
    FIELD_TYPE_ENUM = 247;
    FIELD_TYPE_SET = 248;
    FIELD_TYPE_TINY_BLOB = 249;
    FIELD_TYPE_MEDIUM_BLOB = 250;
    FIELD_TYPE_LONG_BLOB = 251;
    FIELD_TYPE_BLOB = 252;
    FIELD_TYPE_VAR_STRING = 253;
    FIELD_TYPE_STRING = 254;
    FIELD_TYPE_GEOMETRY = 255;

    NOT_NULL_FLAG = $0001;
    PRI_KEY_FLAG = $0002;
    UNIQUE_KEY_FLAG = $0004;
    MULTIPLE_KEY_FLAG = $0008;
    BLOB_FLAG = $0010;
    UNSIGNED_FLAG = $0020;
    ZEROFILL_FLAG = $0040;
    BINARY_FLAG = $0080;
    ENUM_FLAG = $0100;
    AUTO_INCREMENT_FLAG = $0200;
    TIMESTAMP_FLAG = $0400;
    SET_FLAG = $0800;
  end;

implementation

end.
