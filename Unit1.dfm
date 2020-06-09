object FormMain: TFormMain
  Left = 0
  Top = 0
  ActiveControl = edtText
  Caption = 'GenQrCode'
  ClientHeight = 489
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 288
    Top = 8
    Width = 336
    Height = 329
    PopupMenu = PopupMenu1
    OnPaint = PaintBox1Paint
  end
  object Image1: TImage
    Left = 16
    Top = 200
    Width = 233
    Height = 225
    Stretch = True
  end
  object edtText: TLabeledEdit
    Left = 16
    Top = 24
    Width = 225
    Height = 21
    EditLabel.Width = 26
    EditLabel.Height = 13
    EditLabel.Caption = 'Value'
    TabOrder = 0
    Text = '123456'
    OnChange = edtTextChange
  end
  object edtQuietZone: TLabeledEdit
    Left = 16
    Top = 104
    Width = 225
    Height = 21
    EditLabel.Width = 35
    EditLabel.Height = 13
    EditLabel.Caption = 'Q Zone'
    TabOrder = 1
    Text = '1'
    OnChange = edtQuietZoneChange
  end
  object cmbEncoding: TComboBox
    Left = 16
    Top = 64
    Width = 225
    Height = 21
    ItemIndex = 0
    TabOrder = 2
    Text = 'Auto'
    OnChange = cmbEncodingChange
    Items.Strings = (
      'Auto'
      'Numeric'
      'Alphanumeric'
      'ISO-8859-1'
      'UTF-8 without BOM'
      'UTF-8 with BOM')
  end
  object Button1: TButton
    Left = 16
    Top = 144
    Width = 113
    Height = 41
    Caption = 'Save Image'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 16
    Top = 431
    Width = 233
    Height = 42
    Caption = 'Load Image'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 144
    Top = 144
    Width = 113
    Height = 41
    Caption = 'Clipboard'
    TabOrder = 5
    OnClick = Button3Click
  end
  object FDConn: TFDConnection
    Params.Strings = (
      'Database=E:\QRCode\Source code\GenQrCode\Win32\Debug\db1.mdb'
      'DriverID=MSAcc')
    LoginPrompt = False
    Left = 472
    Top = 296
  end
  object FDQuery: TFDQuery
    Connection = FDConn
    SQL.Strings = (
      'SELECT * FROM table1')
    Left = 480
    Top = 336
  end
  object WaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 480
    Top = 384
  end
  object MSAccess: TFDPhysMSAccessDriverLink
    Left = 480
    Top = 432
  end
  object FDQuery2: TFDQuery
    Connection = FDConn
    SQL.Strings = (
      'SELECT * FROM table1 where ID=1')
    Left = 120
    Top = 328
  end
  object PopupMenu1: TPopupMenu
    Left = 488
    Top = 64
    object SaveAsImage1: TMenuItem
      Caption = 'Clipboard As Image'
      OnClick = Button3Click
    end
    object SaveAsImage2: TMenuItem
      Caption = 'Save As Image'
      OnClick = SaveAsImage2Click
    end
  end
  object SavePicture: TSavePictureDialog
    DefaultExt = '.bmp'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Save As Image'
    Left = 488
    Top = 144
  end
end
