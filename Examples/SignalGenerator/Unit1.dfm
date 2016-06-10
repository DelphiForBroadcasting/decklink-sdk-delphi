object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Signal generator'
  ClientHeight = 220
  ClientWidth = 290
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 265
    Height = 173
    Caption = 'Properties'
    TabOrder = 0
    object Label1: TLabel
      Left = 18
      Top = 108
      Width = 67
      Height = 13
      Caption = 'Video Format:'
    end
    object Label2: TLabel
      Left = 16
      Top = 27
      Width = 69
      Height = 13
      Caption = 'Output Signal:'
    end
    object Label3: TLabel
      Left = 13
      Top = 54
      Width = 73
      Height = 13
      Caption = 'Audio Channel:'
    end
    object Label4: TLabel
      Left = 22
      Top = 81
      Width = 63
      Height = 13
      Caption = 'Audio Depth:'
    end
    object Label5: TLabel
      Left = 22
      Top = 135
      Width = 63
      Height = 13
      Caption = 'Pixel Format:'
    end
    object m_videoFormatCombo: TComboBox
      Left = 104
      Top = 105
      Width = 129
      Height = 21
      Style = csDropDownList
      TabOrder = 0
    end
    object m_outputSignalCombo: TComboBox
      Left = 104
      Top = 24
      Width = 129
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 1
      Text = 'Pip'
      Items.Strings = (
        'Pip'
        'Drop')
    end
    object m_audioChannelCombo: TComboBox
      Left = 104
      Top = 51
      Width = 129
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 2
      Text = '2'
      Items.Strings = (
        '2'
        '8'
        '16')
    end
    object m_audioSampleDepthCombo: TComboBox
      Left = 104
      Top = 78
      Width = 129
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 3
      Text = '16 bit'
      Items.Strings = (
        '16 bit'
        '32 bit')
    end
    object m_pixelFormatCombo: TComboBox
      Left = 104
      Top = 132
      Width = 129
      Height = 21
      Style = csDropDownList
      TabOrder = 4
    end
  end
  object m_startButton: TButton
    Left = 96
    Top = 187
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 1
    OnClick = m_startButtonClick
  end
end
