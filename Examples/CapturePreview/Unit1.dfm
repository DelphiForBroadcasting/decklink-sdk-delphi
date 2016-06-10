object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'CapturePreview'
  ClientHeight = 644
  ClientWidth = 899
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 361
    Height = 145
    Caption = 'Capture properties'
    TabOrder = 0
    object Label11: TLabel
      Left = 90
      Top = 27
      Width = 60
      Height = 13
      Caption = 'Input device'
    end
    object Label12: TLabel
      Left = 90
      Top = 86
      Width = 61
      Height = 13
      Caption = 'Video format'
    end
    object Label13: TLabel
      Left = 16
      Top = 53
      Width = 135
      Height = 13
      Caption = 'Apply detected input format'
    end
    object m_invalidInputLabel: TLabel
      Left = 24
      Top = 115
      Width = 95
      Height = 13
      Caption = 'No valid input signal'
      Visible = False
    end
    object m_startStopButton: TButton
      Left = 270
      Top = 110
      Width = 75
      Height = 25
      Caption = 'Start capture'
      TabOrder = 0
      OnClick = m_startStopButtonClick
    end
    object m_deviceListCombo: TComboBox
      Left = 184
      Top = 24
      Width = 161
      Height = 21
      Style = csDropDownList
      TabOrder = 1
      OnChange = m_deviceListComboChange
    end
    object m_modeListCombo: TComboBox
      Left = 184
      Top = 83
      Width = 161
      Height = 21
      Style = csDropDownList
      TabOrder = 2
    end
    object m_applyDetectedInputModeCheckbox: TCheckBox
      Left = 184
      Top = 52
      Width = 161
      Height = 17
      TabOrder = 3
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 159
    Width = 361
    Height = 265
    Caption = 'Ancillary data'
    TabOrder = 1
    object m_vitcTcF1: TLabel
      Left = 184
      Top = 24
      Width = 30
      Height = 13
      HelpType = htKeyword
      AutoSize = False
      Caption = '-'
    end
    object m_vitcUbF1: TLabel
      Left = 184
      Top = 43
      Width = 30
      Height = 13
      AutoSize = False
      Caption = '-'
    end
    object m_vitcTcF2: TLabel
      Left = 184
      Top = 62
      Width = 30
      Height = 13
      HelpType = htKeyword
      AutoSize = False
      Caption = '-'
    end
    object m_vitcUbF2: TLabel
      Left = 184
      Top = 81
      Width = 30
      Height = 13
      AutoSize = False
      Caption = '-'
    end
    object m_rp188Vitc1Tc: TLabel
      Left = 184
      Top = 116
      Width = 30
      Height = 13
      AutoSize = False
      Caption = '-'
    end
    object m_rp188Vitc1Ub: TLabel
      Left = 184
      Top = 135
      Width = 30
      Height = 13
      AutoSize = False
      Caption = '-'
    end
    object m_rp188Vitc2Tc: TLabel
      Left = 184
      Top = 154
      Width = 30
      Height = 13
      AutoSize = False
      Caption = '-'
    end
    object m_rp188Vitc2Ub: TLabel
      Left = 184
      Top = 173
      Width = 30
      Height = 13
      AutoSize = False
      Caption = '-'
    end
    object m_rp188LtcTc: TLabel
      Left = 184
      Top = 192
      Width = 30
      Height = 13
      AutoSize = False
      Caption = '-'
    end
    object m_rp188LtcUb: TLabel
      Left = 184
      Top = 211
      Width = 30
      Height = 13
      AutoSize = False
      Caption = '-'
    end
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 103
      Height = 13
      HelpType = htKeyword
      Caption = 'VITC Timecode field 1'
    end
    object Label2: TLabel
      Left = 16
      Top = 43
      Width = 97
      Height = 13
      Caption = 'VITC Userbits field 1'
    end
    object Label3: TLabel
      Left = 16
      Top = 62
      Width = 103
      Height = 13
      HelpType = htKeyword
      Caption = 'VITC Timecode field 2'
    end
    object Label4: TLabel
      Left = 16
      Top = 81
      Width = 97
      Height = 13
      Caption = 'VITC Userbits field 2'
    end
    object Label5: TLabel
      Left = 16
      Top = 116
      Width = 111
      Height = 13
      Caption = 'RP188 VITC1 Timecode'
    end
    object Label6: TLabel
      Left = 16
      Top = 135
      Width = 105
      Height = 13
      Caption = 'RP188 VITC1 Userbits'
    end
    object Label7: TLabel
      Left = 16
      Top = 154
      Width = 111
      Height = 13
      Caption = 'RP188 VITC2 Timecode'
    end
    object Label8: TLabel
      Left = 16
      Top = 173
      Width = 105
      Height = 13
      Caption = 'RP188 VITC2 Userbits'
    end
    object Label9: TLabel
      Left = 16
      Top = 192
      Width = 100
      Height = 13
      Caption = 'RP188 LTC Timecode'
    end
    object Label10: TLabel
      Left = 16
      Top = 211
      Width = 94
      Height = 13
      Caption = 'RP188 LTC Userbits'
    end
  end
  object GroupBox3: TGroupBox
    Left = 375
    Top = 8
    Width = 516
    Height = 416
    Caption = 'Preview'
    TabOrder = 2
    object m_previewBox: TPanel
      Left = 16
      Top = 24
      Width = 489
      Height = 377
      BevelOuter = bvNone
      Color = clBackground
      ParentBackground = False
      TabOrder = 0
    end
  end
  object GroupBox4: TGroupBox
    Left = 8
    Top = 440
    Width = 361
    Height = 105
    Caption = 'Locked Status'
    TabOrder = 3
    object Label14: TLabel
      Left = 16
      Top = 28
      Width = 83
      Height = 13
      Caption = 'Reference locked'
    end
    object sRefLocked: TShape
      Left = 184
      Top = 29
      Width = 15
      Height = 15
      Brush.Color = clGreen
      Pen.Color = clGray
      Shape = stRoundRect
      Visible = False
    end
    object sRefUnLocked: TShape
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
    object sInputLocked: TShape
      Left = 184
      Top = 58
      Width = 15
      Height = 15
      Brush.Color = clGreen
      Pen.Color = clGray
      Shape = stRoundRect
      Visible = False
    end
    object sInputUnLocked: TShape
      Left = 184
      Top = 58
      Width = 15
      Height = 15
      Brush.Color = clRed
      Pen.Color = clGray
      Shape = stRoundRect
    end
  end
end
