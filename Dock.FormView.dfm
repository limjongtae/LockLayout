object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 545
  ClientWidth = 861
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 448
    Width = 861
    Height = 97
    Align = alBottom
    Caption = 'GroupBox1'
    TabOrder = 0
    DesignSize = (
      861
      97)
    object Button1: TButton
      Left = 616
      Top = 13
      Width = 75
      Height = 34
      Anchors = [akTop, akRight, akBottom]
      Caption = #46973#52852#49373#49457
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 777
      Top = 13
      Width = 80
      Height = 80
      Anchors = [akTop, akRight, akBottom]
      Caption = #51200#51109
      TabOrder = 1
    end
    object Button3: TButton
      Left = 486
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Button3'
      TabOrder = 2
    end
    object Button4: TButton
      Left = 616
      Top = 53
      Width = 75
      Height = 38
      Anchors = [akTop, akRight, akBottom]
      Caption = #51204#52404#49325#51228
      TabOrder = 3
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 486
      Top = 47
      Width = 75
      Height = 25
      Caption = 'Button5'
      TabOrder = 4
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 695
      Top = 13
      Width = 80
      Height = 80
      Anchors = [akTop, akRight, akBottom]
      Caption = #49352#47196#44256#52840
      TabOrder = 5
      OnClick = Button6Click
    end
    object TrackBar1: TTrackBar
      Left = 312
      Top = 16
      Width = 150
      Height = 45
      Min = 1
      Position = 1
      TabOrder = 6
      OnChange = TrackBar1Change
    end
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 861
    Height = 448
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    Color = clBtnHighlight
    ParentColor = False
    TabOrder = 1
    OnMouseDown = ScrollBox1MouseDown
    OnMouseMove = ScrollBox1MouseMove
    OnMouseUp = ScrollBox1MouseUp
  end
end
