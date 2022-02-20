program Server;

uses
  Vcl.Forms,
  uServer in 'uServer.pas' {Form1},
  uCommon in '..\Common\uCommon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

