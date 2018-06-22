unit MyCat.BackEnd;

interface

uses
  Net.CrossSocket.Base;

type
  IBackEndConnection = interface(ICrossConnection)
    ['{534E64EC-D095-4CC2-B55E-99FE8AACE0C4}']
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
    // function setResponseHandler(commandHandler: ResponseHandler): Boolean;
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

implementation

end.
