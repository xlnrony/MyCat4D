unit MyCat.BackEnd.Interfaces;

interface

uses
  System.SysUtils, MyCat.Net.CrossSocket.Base;

type
  IResponseHandler = interface;

  IBackEndConnection = interface(ICrossConnection)
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

  IResponseHandler = interface

    // *
    // * �޷���ȡ����
    // *
    // * @param e
    // * @param conn
    // *
    procedure ConnectionError(E: Exception; Connection: IBackEndConnection);

    // *
    // * �ѻ����Ч���ӵ���Ӧ����
    // *
    procedure ConnectionAcquired(Connection: IBackEndConnection);

    // *
    // * �յ��������ݰ�����Ӧ����
    // *
    procedure ErrorResponse(Err: TBytes; Connection: IBackEndConnection);

    // *
    // * �յ�OK���ݰ�����Ӧ����
    // *
    procedure OkResponse(OK: TBytes; Connection: IBackEndConnection);

    // *
    // * �յ��ֶ����ݰ���������Ӧ����
    // *
    procedure FieldEofResponse(Header: TBytes; Fields: TArray<TBytes>;
      Eof: TBytes; Connection: IBackEndConnection);

    // *
    // * �յ������ݰ�����Ӧ����
    // *
    procedure RowResponse(Row: TBytes; Connection: IBackEndConnection);

    // *
    // * �յ������ݰ���������Ӧ����
    // *
    procedure RowEofResponse(Eof: TBytes; Connection: IBackEndConnection);

    // *
    // * д����Ϊ�գ�����д������
    // *
    procedure WriteQueueAvailable;

    // *
    // * on connetion close event
    // *
    procedure ConnectionClose(Connection: IBackEndConnection; reason: string);
  end;

implementation

end.