unit MyCat.BackEnd.Mysql.CrossSocket.Handler;

interface

uses
  System.Generics.Collections, MyCat.Net.CrossSocket.Base, System.SysUtils;

type
  IResponseHandler = interface

    // *
    // * 无法获取连接
    // *
    // * @param e
    // * @param conn
    // *
    procedure ConnectionError(E: Exception; Connection: ICrossConnection);

    // *
    // * 已获得有效连接的响应处理
    // *
    procedure ConnectionAcquired(Connection: ICrossConnection);

    // *
    // * 收到错误数据包的响应处理
    // *
    procedure ErrorResponse(Err: TBytes; Connection: ICrossConnection);

    // *
    // * 收到OK数据包的响应处理
    // *
    procedure OkResponse(OK: TBytes; Connection: ICrossConnection);

    // *
    // * 收到字段数据包结束的响应处理
    // *
    procedure FieldEofResponse(Header: TBytes; Fields: TList<TBytes>;
      Eof: TBytes; Connection: ICrossConnection);

    // *
    // * 收到行数据包的响应处理
    // *
    procedure RowResponse(Row: TBytes; Connection: ICrossConnection);

    // *
    // * 收到行数据包结束的响应处理
    // *
    procedure RowEofResponse(Eof: TBytes; Connection: ICrossConnection);

    // *
    // * 写队列为空，可以写数据了
    // *
    procedure WriteQueueAvailable;

    // *
    // * on connetion close event
    // *
    procedure ConnectionClose(Connection: ICrossConnection; Reason: string);
  end;

implementation

end.
