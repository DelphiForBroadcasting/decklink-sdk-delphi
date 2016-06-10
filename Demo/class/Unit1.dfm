object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'FH.DeckLink'
  ClientHeight = 683
  ClientWidth = 965
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 519
    Top = 269
    Width = 384
    Height = 216
    Stretch = True
  end
  object Memo1: TMemo
    Left = 0
    Top = 517
    Width = 965
    Height = 147
    Align = alBottom
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 664
    Width = 965
    Height = 19
    Panels = <
      item
        Width = 100
      end
      item
        Width = 100
      end
      item
        Width = 100
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 501
    Width = 965
    Height = 16
    Align = alBottom
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = '  Log:'
    TabOrder = 2
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 343
    Width = 505
    Height = 122
    Caption = 'Status'
    TabOrder = 3
    object Label14: TLabel
      Left = 16
      Top = 28
      Width = 83
      Height = 13
      Caption = 'Reference locked'
    end
    object sReferenceSignal: TShape
      Left = 184
      Top = 29
      Width = 15
      Height = 15
      Brush.Color = clRed
      Pen.Color = clGray
      Shape = stRoundRect
    end
    object Label15: TLabel
      Left = 16
      Top = 60
      Width = 89
      Height = 13
      Caption = 'Video signal locked'
    end
    object sVideoInputSignal: TShape
      Left = 184
      Top = 58
      Width = 15
      Height = 15
      Brush.Color = clRed
      Pen.Color = clGray
      Shape = stRoundRect
    end
    object m_invalidInputLabel: TLabel
      Left = 16
      Top = 95
      Width = 95
      Height = 13
      Caption = 'No valid input signal'
      Visible = False
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 505
    Height = 329
    Caption = 'Capture properties'
    TabOrder = 4
    object Label11: TLabel
      Left = 16
      Top = 27
      Width = 60
      Height = 13
      Caption = 'Input device'
    end
    object Label13: TLabel
      Left = 16
      Top = 296
      Width = 135
      Height = 13
      Caption = 'Apply detected input format'
    end
    object ui_DeviceInfo: TLabel
      Left = 94
      Top = 51
      Width = 395
      Height = 54
      AutoSize = False
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -9
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object m_applyDetectedInputModeCheckbox: TCheckBox
      Left = 184
      Top = 295
      Width = 161
      Height = 17
      TabOrder = 0
    end
    object m_InputCardCombo: TComboBox
      Left = 95
      Top = 24
      Width = 396
      Height = 21
      Style = csDropDownList
      TabOrder = 1
      OnChange = m_InputCardComboChange
    end
    object m_StartButton: TButton
      Left = 325
      Top = 291
      Width = 75
      Height = 25
      Caption = 'Start'
      TabOrder = 2
      OnClick = m_StartButtonClick
    end
    object Button1: TButton
      Left = 416
      Top = 291
      Width = 75
      Height = 25
      Caption = 'Stop'
      TabOrder = 3
      OnClick = Button1Click
    end
    object GroupBox2: TGroupBox
      Left = 13
      Top = 111
      Width = 236
      Height = 156
      Caption = 'VIDEO'
      TabOrder = 4
      object Label2: TLabel
        Left = 18
        Top = 31
        Width = 54
        Height = 13
        Caption = 'Connection'
      end
      object Label12: TLabel
        Left = 18
        Top = 58
        Width = 61
        Height = 13
        Caption = 'Video format'
      end
      object Label1: TLabel
        Left = 18
        Top = 85
        Width = 59
        Height = 13
        Caption = 'Pixel Format'
      end
      object m_VideoConnectionsCombo: TComboBox
        Left = 96
        Top = 28
        Width = 129
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        OnChange = m_VideoConnectionsComboChange
      end
      object m_VideoFormatCombo: TComboBox
        Left = 96
        Top = 55
        Width = 129
        Height = 21
        Style = csDropDownList
        TabOrder = 1
        OnChange = m_VideoFormatComboChange
      end
      object m_PixelFormatCombo: TComboBox
        Left = 96
        Top = 82
        Width = 129
        Height = 21
        Style = csDropDownList
        TabOrder = 2
        OnChange = m_PixelFormatComboChange
      end
    end
    object GroupBox5: TGroupBox
      Left = 255
      Top = 111
      Width = 236
      Height = 156
      Caption = 'AUDIO'
      TabOrder = 5
      object Label3: TLabel
        Left = 18
        Top = 31
        Width = 54
        Height = 13
        Caption = 'Connection'
      end
      object Label4: TLabel
        Left = 18
        Top = 58
        Width = 60
        Height = 13
        Caption = 'Sample Rate'
      end
      object Label5: TLabel
        Left = 18
        Top = 85
        Width = 61
        Height = 13
        Caption = 'Sample Type'
      end
      object Label6: TLabel
        Left = 18
        Top = 112
        Width = 44
        Height = 13
        Caption = 'Channels'
      end
      object m_AudioConnectionsCombo: TComboBox
        Left = 96
        Top = 28
        Width = 129
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        OnChange = m_AudioConnectionsComboChange
      end
      object m_AudioSampleRateCombo: TComboBox
        Left = 96
        Top = 55
        Width = 129
        Height = 21
        Style = csDropDownList
        TabOrder = 1
        OnChange = m_AudioSampleRateComboChange
      end
      object m_AudioSampleTypeCombo: TComboBox
        Left = 96
        Top = 82
        Width = 129
        Height = 21
        Style = csDropDownList
        TabOrder = 2
        OnChange = m_AudioSampleTypeComboChange
      end
      object m_AudioChannelsCombo: TComboBox
        Left = 96
        Top = 109
        Width = 129
        Height = 21
        Style = csDropDownList
        TabOrder = 3
        OnChange = m_AudioChannelsComboChange
      end
    end
  end
  object GroupBox3: TGroupBox
    Left = 519
    Top = 8
    Width = 418
    Height = 255
    Caption = 'Preview'
    TabOrder = 5
    object m_previewBox: TPanel
      Left = 16
      Top = 24
      Width = 384
      Height = 216
      BevelOuter = bvNone
      Color = clBackground
      ParentBackground = False
      TabOrder = 0
    end
  end
  object MainMenu1: TMainMenu
    Left = 416
    Top = 96
    object File1: TMenuItem
      Caption = 'File'
    end
    object N1: TMenuItem
      Caption = '?'
    end
  end
end
