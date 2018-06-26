program MyCat;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  MyCat.Net.Mysql in 'MyCat.Net.Mysql.pas',
  MyCat.BackEnd.Mysql in 'MyCat.BackEnd.Mysql.pas',
  MyCat.BackEnd in 'MyCat.BackEnd.pas',
  Net.CrossSocket.Base in 'Net.CrossSocket.Base.pas',
  MyCat.Net in 'MyCat.Net.pas',
  Net.CrossSocket in 'Net.CrossSocket.pas',
  MyCat.BackEnd.Mysql.CrossSocket in 'MyCat.BackEnd.Mysql.CrossSocket.pas',
  MyCat.Config in 'MyCat.Config.pas',
  MyCat.Util in 'MyCat.Util.pas',
  MyCat.Config.Model in 'MyCat.Config.Model.pas',
  Mycat.SQLEngine in 'Mycat.SQLEngine.pas',
  System.Generics.Collections.ThreadSafe in 'System.Generics.Collections.ThreadSafe.pas',
  MyCat.BackEnd.Mysql.CrossSocket.Handler in 'MyCat.BackEnd.Mysql.CrossSocket.Handler.pas',
  MyCat.BackEnd.DataSource in 'MyCat.BackEnd.DataSource.pas',
  System.Generics.DataStruct in 'System.Generics.DataStruct.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
