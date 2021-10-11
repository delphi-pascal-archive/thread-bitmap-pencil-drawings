object Form1: TForm1
  Left = 238
  Top = 130
  Width = 637
  Height = 427
  Caption = 'Thread Bitmap (pencil drawings)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 360
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 74
      Height = 16
      Caption = 'Contrast: 0%'
    end
    object Label2: TLabel
      Left = 8
      Top = 56
      Width = 89
      Height = 16
      Caption = 'Luminosite: 0%'
    end
    object Label3: TLabel
      Left = 8
      Top = 104
      Width = 109
      Height = 16
      Caption = 'Taille du crayon: 3'
    end
    object Label4: TLabel
      Left = 8
      Top = 152
      Width = 114
      Height = 16
      Caption = 'Angle Principal: 45'#176
    end
    object Label5: TLabel
      Left = 8
      Top = 200
      Width = 77
      Height = 16
      Caption = 'Variation: '#177'0'#176
    end
    object Label6: TLabel
      Left = 8
      Top = 248
      Width = 118
      Height = 16
      Caption = 'Longueur du trait: 10'
    end
    object Label7: TLabel
      Left = 8
      Top = 296
      Width = 123
      Height = 16
      Caption = 'Quantite de Trait: 5%'
    end
    object ScrollBar1: TScrollBar
      Left = 8
      Top = 32
      Width = 169
      Height = 16
      Max = 1024
      Min = -255
      PageSize = 0
      TabOrder = 0
      OnChange = ScrollBar1Change
    end
    object ScrollBar2: TScrollBar
      Left = 8
      Top = 80
      Width = 169
      Height = 16
      Max = 255
      Min = -255
      PageSize = 0
      TabOrder = 1
      OnChange = ScrollBar1Change
    end
    object ScrollBar3: TScrollBar
      Left = 8
      Top = 128
      Width = 169
      Height = 16
      Max = 50
      Min = 1
      PageSize = 0
      Position = 3
      TabOrder = 2
      OnChange = ScrollBar1Change
    end
    object ScrollBar4: TScrollBar
      Left = 8
      Top = 176
      Width = 169
      Height = 16
      Max = 360
      PageSize = 0
      Position = 45
      TabOrder = 3
      OnChange = ScrollBar1Change
    end
    object ScrollBar5: TScrollBar
      Left = 8
      Top = 224
      Width = 169
      Height = 16
      Max = 90
      PageSize = 0
      TabOrder = 4
      OnChange = ScrollBar1Change
    end
    object ScrollBar6: TScrollBar
      Left = 8
      Top = 272
      Width = 169
      Height = 16
      Max = 60
      Min = 1
      PageSize = 0
      Position = 10
      TabOrder = 5
      OnChange = ScrollBar1Change
    end
    object ScrollBar7: TScrollBar
      Left = 8
      Top = 320
      Width = 169
      Height = 16
      Min = 1
      PageSize = 0
      Position = 5
      TabOrder = 6
      OnChange = ScrollBar1Change
    end
  end
  object ScrollBox1: TScrollBox
    Left = 185
    Top = 0
    Width = 444
    Height = 360
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    Align = alClient
    TabOrder = 1
    object PaintBox1: TPaintBox
      Left = 0
      Top = 0
      Width = 417
      Height = 305
      OnPaint = PaintBox1Paint
    end
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 360
    Width = 629
    Height = 15
    Align = alBottom
    TabOrder = 2
  end
  object MainMenu1: TMainMenu
    Left = 328
    Top = 48
    object Fichier1: TMenuItem
      Caption = 'File'
      object Ouvrir1: TMenuItem
        Caption = 'Open'
        ShortCut = 16463
        OnClick = Ouvrir1Click
      end
      object Enregistrer1: TMenuItem
        Caption = 'Save'
        ShortCut = 16467
        OnClick = Enregistrer1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Quitter1: TMenuItem
        Caption = 'Exit'
      end
    end
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 265
    Top = 48
  end
  object SavePictureDialog1: TSavePictureDialog
    Left = 297
    Top = 48
  end
end
