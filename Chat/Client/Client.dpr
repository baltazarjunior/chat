program Client;

uses
  Vcl.Forms,
  uClient in 'uClient.pas' {Form2},
  uCommon in '..\Common\uCommon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
