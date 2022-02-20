object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Chat Server'
  ClientHeight = 596
  ClientWidth = 581
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 15
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 185
    Height = 329
    Caption = 'Names'
    TabOrder = 0
    object ListBox1: TListBox
      Left = 16
      Top = 24
      Width = 153
      Height = 289
      ItemHeight = 15
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 199
    Top = 8
    Width = 185
    Height = 329
    Caption = 'Socket Id'
    TabOrder = 1
    object ListBox2: TListBox
      Left = 16
      Top = 24
      Width = 153
      Height = 289
      ItemHeight = 15
      TabOrder = 0
    end
  end
  object GroupBox3: TGroupBox
    Left = 390
    Top = 8
    Width = 185
    Height = 329
    Caption = 'Status'
    TabOrder = 2
    object ListBox3: TListBox
      Left = 16
      Top = 24
      Width = 153
      Height = 289
      ItemHeight = 15
      TabOrder = 0
    end
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 343
    Width = 567
    Height = 250
    Caption = 'Log'
    TabOrder = 3
    object Memo1: TMemo
      Left = 16
      Top = 24
      Width = 535
      Height = 209
      TabOrder = 0
    end
  end
  object ServerSocket1: TServerSocket
    Active = True
    Port = 69
    ServerType = stNonBlocking
    OnClientDisconnect = ServerSocket1ClientDisconnect
    OnClientRead = ServerSocket1ClientRead
    Left = 40
    Top = 304
  end
end
