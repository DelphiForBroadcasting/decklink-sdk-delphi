object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'DeckLink - InputLoopThrough'
  ClientHeight = 141
  ClientWidth = 447
  Color = clBtnFace
  DoubleBuffered = True
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
    Top = 103
    Width = 68
    Height = 13
    Caption = 'Capture Time:'
  end
  object m_CaptureTime: TLabel
    Left = 113
    Top = 103
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
  object Label3: TLabel
    Left = 32
    Top = 58
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
    OnChange = m_InputCardComboChange
  end
  object m_VideoFormatCombo: TComboBox
    Left = 136
    Top = 55
    Width = 289
    Height = 21
    Style = csDropDownList
    TabOrder = 1
    OnChange = m_VideoFormatComboChange
  end
  object m_StartButton: TButton
    Left = 350
    Top = 98
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 2
    OnClick = m_StartButtonClick
  end
end
