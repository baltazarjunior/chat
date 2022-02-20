unit uCommon;

interface

uses
  StrUtils, System.SysUtils;

type
  TTypeMessage = (tmNewUser, tmNewMessage, tmNewMessageTo, tmUpdateUsers, tmUpdateStatus, tmRemoveUser);
  TConvert = class
    public
    class function Encode(pTypeMessage : TTypeMessage; pValue: string) : string;
    class function Decode(pValue: string) : string;
    class function GetCode(pValue: string) : TTypeMessage;
  end;

const
  cNewUser = '<newUser>';
  cNewMessage = '<newMessage>';
  cNewMessageTo = '<newMessageTo>';
  cUpdateUsers = '<updateUsers>';
  cUpdateStatus = '<updateStatus>';
  cRemoveUser = '<removeUser>';

implementation

{ TProtocol }

class function TConvert.Decode(pValue: string): string;
begin
  if Pos(cNewUser, pValue) > 0 then
    Result := StringReplace(pValue, cNewUser, '', [])
  else if Pos(cNewMessage, pValue) > 0 then
    Result := StringReplace(pValue, cNewMessage, '', [])
  else if  Pos(cNewMessageTo, pValue) > 0 then
    Result := StringReplace(pValue, cNewMessageTo, '', [])
  else if  Pos(cUpdateUsers, pValue) > 0 then
    Result := StringReplace(pValue, cUpdateUsers, '', [])
  else if  Pos(cUpdateStatus, pValue) > 0 then
    Result := StringReplace(pValue, cUpdateStatus, '', [])
  else if  Pos(cRemoveUser, pValue) > 0 then
    Result := StringReplace(pValue, cRemoveUser, '', []);
end;

class function TConvert.Encode(pTypeMessage : TTypeMessage; pValue: string) : string;
begin
  case pTypeMessage of
    tmNewUser: Result := cNewUser + pValue;
    tmNewMessage: Result := cNewMessage + pValue;
    tmNewMessageTo: Result := cNewMessageTo + pValue;
    tmUpdateUsers: Result := cUpdateUsers + pValue;
    tmUpdateStatus: Result := cUpdateStatus + pValue;
    tmRemoveUser: Result := cRemoveUser + pValue;
  end;
end;

class function TConvert.GetCode(pValue: string): TTypeMessage;
var
   MessageType : string;
begin
  MessageType := Copy(pValue, 0, Pos('>',pValue));

  case AnsiIndexStr((MessageType), [cNewUser, cNewMessage, cNewMessageTo, cUpdateUsers, cUpdateStatus, cRemoveUser]) of
    0: Result := tmNewUser;
    1: Result := tmNewMessage;
    2: Result := tmNewMessageTo;
    3: Result := tmUpdateUsers;
    4: Result := tmUpdateStatus;
    5: Result := tmRemoveUser;
  end;
end;

end.
