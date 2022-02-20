object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Chat'
  ClientHeight = 320
  ClientWidth = 878
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 878
    Height = 279
    Align = alClient
    ReadOnly = True
    TabOrder = 0
    ExplicitWidth = 833
    ExplicitHeight = 281
  end
  object Panel1: TPanel
    Left = 0
    Top = 279
    Width = 878
    Height = 41
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 281
    ExplicitWidth = 833
    object Edit1: TEdit
      Left = 106
      Top = 6
      Width = 489
      Height = 23
      TabOrder = 0
      Text = 'Edit1'
      OnKeyPress = Edit1KeyPress
    end
    object btnSend: TButton
      Left = 747
      Top = 6
      Width = 78
      Height = 25
      Caption = 'Send'
      Enabled = False
      TabOrder = 1
      OnClick = btnSendClick
    end
    object ComboBox1: TComboBox
      Left = 601
      Top = 7
      Width = 140
      Height = 23
      TabOrder = 2
    end
  end
  object ToggleSwitch1: TToggleSwitch
    Left = 7
    Top = 288
    Width = 92
    Height = 20
    StateCaptions.CaptionOn = 'Online'
    StateCaptions.CaptionOff = 'Offline'
    TabOrder = 2
    OnClick = ToggleSwitch1Click
  end
  object ClientSocket1: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Host = '127.0.0.1'
    Port = 69
    OnConnecting = ClientSocket1Connecting
    OnConnect = ClientSocket1Connect
    OnDisconnect = ClientSocket1Disconnect
    OnRead = ClientSocket1Read
    Left = 24
    Top = 208
  end
end
