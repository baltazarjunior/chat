unit uServer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Win.ScktComp, System.StrUtils;

type
  TOfflineMessages = record
    Code : HWND;
    Messages: TStringList;
  end;

  TForm1 = class(TForm)
    ServerSocket1: TServerSocket;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    GroupBox4: TGroupBox;
    Memo1: TMemo;
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FUpdatedUsers : Boolean;
    FOffilneMessages : array [0..10] of TOfflineMessages;
    procedure SendToAll(pMessage : string; pExcept : HWND = 0);
    function GetName(Id : HWND) : string;
    function GetHandle(pName : string): HWND;
    procedure SendTo(pMessage: string; pHandle: HWND);
    function GetItemIndex(pHandle: HWND) : Integer;
    function GetItemOfflineMessages(pHandle : HWND) : Integer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  uCommon;

{$R *.dfm}

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  vIndex: Integer;
begin
   for vIndex := 0 to Length(FOffilneMessages) - 1 do
     FreeAndNil(FOffilneMessages[vIndex].Messages);
end;

function TForm1.GetHandle(pName: string): HWND;
var
  vIndex : Integer;
begin
   for vIndex := 0 to ListBox1.Items.Count -1  do
     if ListBox1.Items[vIndex] = pName then
     begin
       Result := StrToInt(ListBox2.Items[vIndex]);
       Break;
     end;
end;

function TForm1.GetItemIndex(pHandle: HWND): Integer;
var
  vIndex : Integer;
begin
  for vIndex := 0 to ListBox2.Items.Count -1  do
     if ListBox2.Items[vIndex] = IntToStr(pHandle)then
     begin
       Result := vIndex;
       Break;
     end;
end;

function TForm1.GetItemOfflineMessages(pHandle: HWND): Integer;
var
  vIndex : Integer;
begin
  for vIndex := 0 to Length(FOffilneMessages) - 1 do
    if FOffilneMessages[vIndex].Code = pHandle then
    begin
      Result := vIndex;
      Break;
    end;
end;

function TForm1.GetName(Id: HWND): string;
var
  vIndex : Integer;
begin
   Result := 'Unknow';
   for vIndex := 0 to ListBox2.Items.Count -1  do
     if ListBox2.Items[vIndex] = IntToStr(Id)then
     begin
       Result := ListBox1.Items[vIndex];
       Break;
     end;
end;

procedure TForm1.SendToAll(pMessage : string; pExcept : HWND = 0);
var
  vIndex: Integer;
begin
 if ServerSocket1.Socket.ActiveConnections > 0  then
 begin
   for vIndex := 0 to ServerSocket1.Socket.ActiveConnections - 1 do
     if ServerSocket1.Socket.Connections[vIndex].Handle <> pExcept then
       ServerSocket1.Socket.Connections[vIndex].SendText(pMessage);
 end;
   memo1.Lines.Add(pMessage);
end;

procedure TForm1.SendTo(pMessage : string; pHandle : HWND);
var
  vIndex: Integer;
begin
 if ServerSocket1.Socket.ActiveConnections > 0  then
 begin
   for vIndex := 0 to ServerSocket1.Socket.ActiveConnections - 1 do
     if ServerSocket1.Socket.Connections[vIndex].Handle = pHandle then
       ServerSocket1.Socket.Connections[vIndex].SendText(pMessage);
 end;
   memo1.Lines.Add(pMessage);
end;

procedure TForm1.ServerSocket1ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  vIndex: Integer;
begin
  for vIndex := 0 to ListBox1.Items.Count - 1 do
    if ListBox2.Items[vIndex] = inttostr(Socket.Handle) then
    begin
      SendToAll(GetName(Socket.Handle) + ' left the room. ', Socket.Handle);
      SendToAll(cRemoveUser + GetName(Socket.Handle));
      ListBox1.Items.Delete(vIndex);
      ListBox2.Items.Delete(vIndex);
      ListBox3.Items.Delete(vIndex);
      Break;
    end;
end;

procedure TForm1.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  vReceiveText, vUsers, vUser : string;
  vIndex: Integer;
begin
 try
   vReceiveText := Socket.ReceiveText;
   Memo1.Lines.Add(vReceiveText);

   case TConvert.GetCode(vReceiveText) of
      tmNewUser:
        begin
          ListBox1.Items.Add(TConvert.Decode(vReceiveText));
          ListBox2.Items.Add(IntToStr(Socket.Handle));
          ListBox3.Items.Add('Offline');
          SendToAll(TConvert.Decode(vReceiveText) + ' joined the chat! ', Socket.Handle);
          Socket.SendText('Welcome ' + TConvert.Decode(vReceiveText));
          FUpdatedUsers := False;

          FOffilneMessages[ListBox1.Items.Count].Code := Socket.Handle;
          FOffilneMessages[ListBox1.Items.Count].Messages := TStringList.Create;
        end;
      tmNewMessage:
        begin
          SendToAll(GetName(Socket.Handle) + '>>' + TConvert.Decode(vReceiveText), Socket.Handle);
        end;
      tmNewMessageTo:
        begin
          vReceiveText := TConvert.Decode(vReceiveText);
          vUser := Copy(vReceiveText,0,Pos(';',vReceiveText) - 1);
          vReceiveText := Copy(vReceiveText, Pos(';',vReceiveText) + 1, Length(vReceiveText));

          if ListBox3.Items[GetItemIndex(GetHandle(vUser))] = 'Offline' then
            FOffilneMessages[GetItemOfflineMessages(GetHandle(vUser))].Messages.Add(GetName(Socket.Handle) + ' >> ' + vReceiveText)
          else
            SendTo(GetName(Socket.Handle) + ' >> ' + vReceiveText, GetHandle(vUser));
        end;
      tmUpdateUsers:
      begin
        for vIndex := 0 to ListBox1.Items.Count - 1 do
         vUsers := vUsers + ';' + ListBox1.Items[vIndex];

         if not FUpdatedUsers then
         begin
           SendToAll(cUpdateUsers + vUsers);
           FUpdatedUsers := True;
         end;
      end;
      tmUpdateStatus:
      begin
        ListBox3.Items[GetItemIndex(Socket.Handle)] := TConvert.Decode(vReceiveText);
        if TConvert.Decode(vReceiveText) = 'Online' then
        begin
          for vIndex := 0 to FOffilneMessages[GetItemOfflineMessages(Socket.Handle)].Messages.Count - 1 do
            Socket.SendText(FOffilneMessages[GetItemOfflineMessages(Socket.Handle)].Messages[vIndex] +
              ifthen(vIndex = FOffilneMessages[GetItemOfflineMessages(Socket.Handle)].Messages.Count - 1,'',#13#10));


          FOffilneMessages[GetItemOfflineMessages(Socket.Handle)].Messages.Clear;
        end;
      end;
   end;

 Except
   raise Exception.Create('could not conclude ');
 end;
end;
end.
