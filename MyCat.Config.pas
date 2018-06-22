unit MyCat.Config;

interface

type
  TCapabilities = class
  public const
    // new more secure passwords
    CLIENT_LONG_PASSWORD = 1;

    // Found instead of affected rows
    // �����ҵ���ƥ�䣩�������������Ǹı��˵�������
    CLIENT_FOUND_ROWS = 2;

    // Get all column flags
    CLIENT_LONG_FLAG = 4;

    // One can specify db on connect
    CLIENT_CONNECT_WITH_DB = 8;

    // Don't allow database.table.column
    // ���������ݿ���.����.�������������﷨�����Ƕ���ODBC�����á�
    // ��ʹ���������﷨ʱ�����������һ�����������һЩODBC�ĳ�������bug��˵�����õġ�
    CLIENT_NO_SCHEMA = 16;

    // Can use compression protocol
    // ʹ��ѹ��Э��
    CLIENT_COMPRESS = 32;

    // Odbc client
    CLIENT_ODBC = 64;

    // Can use LOAD DATA LOCAL
    CLIENT_LOCAL_FILES = 128;

    // Ignore spaces before '('
    // �����ں�������ʹ�ÿո����к���������Ԥ���֡�
    CLIENT_IGNORE_SPACE = 256;

    // New 4.1 protocol This is an interactive client
    CLIENT_PROTOCOL_41 = 512;

    // This is an interactive client
    // ����ʹ�ùر�����֮ǰ�Ĳ��������ʱ�������������ǵȴ���ʱ������
    // �ͻ��˵ĻỰ�ȴ���ʱ������Ϊ������ʱ������
    CLIENT_INTERACTIVE = 1024;

    // Switch to SSL after handshake
    // ʹ��SSL��������ò�Ӧ�ñ�Ӧ�ó������ã���Ӧ�����ڿͻ��˿��ڲ������õġ�
    // �����ڵ���mysql_real_connect()֮ǰ����mysql_ssl_set()���������á�
    CLIENT_SSL = 2048;

    // IGNORE sigpipes
    // ��ֹ�ͻ��˿ⰲװһ��SIGPIPE�źŴ�������
    // ����������ڵ�Ӧ�ó����Ѿ���װ�ô�������ʱ��������䷢����ͻ��
    CLIENT_IGNORE_SIGPIPE = 4096;

    // Client knows about transactions
    CLIENT_TRANSACTIONS = 8192;

    // Old flag for 4.1 protocol
    CLIENT_RESERVED = 16384;

    // New 4.1 authentication
    CLIENT_SECURE_CONNECTION = 32768;

    // Enable/disable multi-stmt support
    // ֪ͨ�������ͻ��˿��Է��Ͷ�����䣨�ɷֺŷָ���������ñ�־Ϊû�б����ã��������ִ�С�
    CLIENT_MULTI_STATEMENTS = 65536;

    // Enable/disable multi-results
    // ֪ͨ�������ͻ��˿��Դ����ɶ������ߴ洢����ִ�����ɵĶ�������
    // ����CLIENT_MULTI_STATEMENTSʱ�������־�Զ��ı��򿪡�
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
