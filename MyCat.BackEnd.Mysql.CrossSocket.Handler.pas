unit MyCat.BackEnd.Mysql.CrossSocket.Handler;

interface

uses
  System.Generics.Collections, MyCat.Net.CrossSocket.Base, System.SysUtils;

type
  IResponseHandler = interface

    // *
    // * �޷���ȡ����
    // *
    // * @param e
    // * @param conn
    // *
    procedure ConnectionError(E: Exception; Connection: ICrossConnection);

    // *
    // * �ѻ����Ч���ӵ���Ӧ����
    // *
    procedure ConnectionAcquired(Connection: ICrossConnection);

    // *
    // * �յ��������ݰ�����Ӧ����
    // *
    procedure ErrorResponse(Err: TBytes; Connection: ICrossConnection);

    // *
    // * �յ�OK���ݰ�����Ӧ����
    // *
    procedure OkResponse(OK: TBytes; Connection: ICrossConnection);

    // *
    // * �յ��ֶ����ݰ���������Ӧ����
    // *
    procedure FieldEofResponse(Header: TBytes; Fields: TList<TBytes>;
      Eof: TBytes; Connection: ICrossConnection);

    // *
    // * �յ������ݰ�����Ӧ����
    // *
    procedure RowResponse(Row: TBytes; Connection: ICrossConnection);

    // *
    // * �յ������ݰ���������Ӧ����
    // *
    procedure RowEofResponse(Eof: TBytes; Connection: ICrossConnection);

    // *
    // * д����Ϊ�գ�����д������
    // *
    procedure WriteQueueAvailable;

    // *
    // * on connetion close event
    // *
    procedure ConnectionClose(Connection: ICrossConnection; Reason: string);
  end;

implementation

end.
