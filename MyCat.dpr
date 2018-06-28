program MyCat;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  MyCat.BackEnd.DataSource in 'MyCat.BackEnd.DataSource.pas',
  MyCat.BackEnd.HeartBeat in 'MyCat.BackEnd.HeartBeat.pas',
  MyCat.BackEnd.Mysql.CrossSocket.Handler in 'MyCat.BackEnd.Mysql.CrossSocket.Handler.pas',
  MyCat.BackEnd.Mysql.CrossSocket in 'MyCat.BackEnd.Mysql.CrossSocket.pas',
  MyCat.BackEnd.Mysql in 'MyCat.BackEnd.Mysql.pas',
  MyCat.BackEnd in 'MyCat.BackEnd.pas',
  MyCat.Config.Model in 'MyCat.Config.Model.pas',
  MyCat.Config in 'MyCat.Config.pas',
  MyCat.Generics.ICrossConnection in 'MyCat.Generics.ICrossConnection.pas',
  MyCat.Memory.UnSafe.Row in 'MyCat.Memory.UnSafe.Row.pas',
  MyCat.Net.Mysql in 'MyCat.Net.Mysql.pas',
  MyCat.Net in 'MyCat.Net.pas',
  Mycat.SQLEngine in 'Mycat.SQLEngine.pas',
  MyCat.Statistic.Generics.DataSourceSyncRecord in 'MyCat.Statistic.Generics.DataSourceSyncRecord.pas',
  MyCat.Statistic.Generics.HeartBeatRecord in 'MyCat.Statistic.Generics.HeartBeatRecord.pas',
  MyCat.Statistic in 'MyCat.Statistic.pas',
  MyCat.Util in 'MyCat.Util.pas',
  MyCat.Net.CrossSocket.Base in 'MyCat.Net.CrossSocket.Base.pas',
  MyCat.Net.CrossSocket in 'MyCat.Net.CrossSocket.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
