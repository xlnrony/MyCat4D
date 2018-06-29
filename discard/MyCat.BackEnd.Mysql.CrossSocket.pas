unit MyCat.BackEnd.Mysql.CrossSocket;

interface

uses
  Net.CrossSocket, MyCat.BackEnd;

type
  TMySQLConnection = class(TCrossConnection, IBackEndConnection)
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

{ TMySQLConnection }

procedure TMySQLConnection.Commit;
begin

end;

procedure TMySQLConnection.DiscardClose(reason: string);
begin

end;

function TMySQLConnection.GetAttachment: TObject;
begin

end;

function TMySQLConnection.GetBorrowed: Boolean;
begin

end;

function TMySQLConnection.GetId: Int64;
begin

end;

function TMySQLConnection.GetLastTime: Int64;
begin

end;

function TMySQLConnection.GetSchema: string;
begin

end;

function TMySQLConnection.GetTxIsolation: Integer;
begin

end;

function TMySQLConnection.IsAutocommit: Boolean;
begin

end;

function TMySQLConnection.IsClosedOrQuit: Boolean;
begin

end;

function TMySQLConnection.IsFromSlaveDB: Boolean;
begin

end;

function TMySQLConnection.IsModifiedSQLExecuted: Boolean;
begin

end;

procedure TMySQLConnection.Query(sql: string);
begin

end;

procedure TMySQLConnection.Quit;
begin

end;

procedure TMySQLConnection.RecordSql(host, schema, statement: String);
begin

end;

procedure TMySQLConnection.Release;
begin

end;

procedure TMySQLConnection.Rollback;
begin

end;

procedure TMySQLConnection.SetAttachment(attachment: TObject);
begin

end;

procedure TMySQLConnection.SetBorrowed(Borrowed: Boolean);
begin

end;

procedure TMySQLConnection.SetLastTime(currentTimeMillis: Int64);
begin

end;

procedure TMySQLConnection.SetSchema(newSchema: string);
begin

end;

function TMySQLConnection.SyncAndExcute: Boolean;
begin

end;

end.
