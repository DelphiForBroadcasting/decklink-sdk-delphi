object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'DeckLink - InputLoopThrough'
  ClientHeight = 200
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object m_CaptureTimeLabel: TLabel
    Left = 32
    Top = 152
    Width = 68
    Height = 13
    Caption = 'Capture Time:'
  end
  object m_CaptureTime: TLabel
    Left = 113
    Top = 152
    Width = 113
    Height = 13
    AutoSize = False
    Caption = '00:00:00:00'
  end
  object Label1: TLabel
    Left = 32
    Top = 24
    Width = 56
    Height = 13
    Caption = 'Input Card:'
  end
  object Label2: TLabel
    Left = 32
    Top = 56
    Width = 64
    Height = 13
    Caption = 'Output Card:'
  end
  object Label3: TLabel
    Left = 32
    Top = 107
    Width = 67
    Height = 13
    Caption = 'Video Format:'
  end
  object m_InputCardCombo: TComboBox
    Left = 136
    Top = 21
    Width = 289
    Height = 21
    Style = csDropDownList
    TabOrder = 0
  end
  object m_OutputCardCombo: TComboBox
    Left = 136
    Top = 53
    Width = 289
    Height = 21
    Style = csDropDownList
    TabOrder = 1
  end
  object m_VideoFormatCombo: TComboBox
    Left = 136
    Top = 104
    Width = 289
    Height = 21
    Style = csDropDownList
    TabOrder = 2
    OnChange = m_VideoFormatComboChange
  end
  object m_StartButton: TButton
    Left = 350
    Top = 147
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 3
    OnClick = m_StartButtonClick
  end
end
