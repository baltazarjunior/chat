unit uClient;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Win.ScktComp, Vcl.StdCtrls,
  Vcl.ExtCtrls, System.StrUtils, uCommon, Vcl.WinXCtrls;

type
  TForm2 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Edit1: TEdit;
    btnSend: TButton;
    ClientSocket1: TClientSocket;
    ComboBox1: TComboBox;
    ToggleSwitch1: TToggleSwitch;
    procedure ClientSocket1Connect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocket1Disconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Connecting(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure btnSendClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure ToggleSwitch1Click(Sender: TObject);
  private
   FName : string;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.btnSendClick(Sender: TObject);
var
   vText :string;
begin
  if Edit1.CanFocus then
  edit1.SetFocus;

  if ComboBox1.ItemIndex = 0  then
    vText := cNewMessage + edit1.Text
  else
    vText := Format('%s;%s',[cNewMessageTo + ComboBox1.Items[ComboBox1.ItemIndex], Edit1.Text]);

  ClientSocket1.Socket.SendText(vText);

  edit1.Text := '';
end;

procedure TForm2.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  btnSend.Enabled := True;
  Edit1.Enabled := True;
  Edit1.Text := '';
  if Edit1.CanFocus then
    Edit1.SetFocus;

  Socket.SendText(cNewUser + FName);
end;

procedure TForm2.ClientSocket1Connecting(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Edit1.Text := 'Connecting...';
end;

procedure TForm2.ClientSocket1Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  btnSend.Enabled := False;
  Edit1.Enabled := False;
end;

procedure TForm2.ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
var
  vUser : string;
  vReceiveText : string;
  vReceiverList : TStringList;
  vIndex : integer;
begin
 vReceiveText :=  Socket.ReceiveText;

 case TConvert.GetCode(vReceiveText) of
    tmNewUser:
      begin
        Memo1.Lines.Add(vReceiveText);
        Socket.SendText(cUpdateUsers);
      end;
    tmNewMessage:
      begin
        Memo1.Lines.Add(vReceiveText);
      end;
    tmUpdateUsers:
      begin
        vReceiverList := TStringList.Create;
        vReceiverList.Delimiter := ';';
        vReceiverList.DelimitedText := vReceiveText;
        ComboBox1.Clear;
        ComboBox1.Items.Add('All');
        for vIndex := 0 to vReceiverList.Count -1  do
        begin
          if (vIndex <> 0) and (vReceiverList[vIndex] <> FName) and (vReceiverList[vIndex] <> cUpdateUsers) then
         ComboBox1.Items.Add(vReceiverList[vIndex]);
        end;
        freeAndNil(vReceiverList);
        ComboBox1.ItemIndex := 0;
      end;
    tmRemoveUser:
      begin
        for vIndex := 0 to ComboBox1.Items.Count - 1 do
          if ComboBox1.Items[vIndex] = TConvert.Decode(vReceiveText) then
          begin
            ComboBox1.Items.Delete(vIndex);
            Break;
          end;
      end;
  end;
end;

procedure TForm2.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #12 then
    btnSend.Click;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  fName := '';
  while fName = '' do
    fName := LowerCase(InputBox('Chat', 'Type your name', ''));

  ClientSocket1.Open;
end;

procedure TForm2.ToggleSwitch1Click(Sender: TObject);
var
  status : string;
begin
  if ToggleSwitch1.State = tssOff then
    status := 'Offline'
  else
    status := 'Online';

  ClientSocket1.Socket.SendText(cUpdateStatus + status);
end;

end.
