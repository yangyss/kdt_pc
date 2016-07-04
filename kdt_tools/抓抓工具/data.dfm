object FormClacData: TFormClacData
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = #25968#25454#22788#29702#30028#38754
  ClientHeight = 276
  ClientWidth = 188
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 8
    Top = 8
    Width = 60
    Height = 13
    Caption = #22352#26631#33539#22260#65306
  end
  object lbl2: TLabel
    Left = 13
    Top = 30
    Width = 16
    Height = 13
    Caption = 'x1:'
  end
  object lbl3: TLabel
    Left = 104
    Top = 30
    Width = 16
    Height = 13
    Caption = 'y1:'
  end
  object lbl4: TLabel
    Left = 13
    Top = 58
    Width = 16
    Height = 13
    Caption = 'x2:'
  end
  object lbl5: TLabel
    Left = 104
    Top = 58
    Width = 16
    Height = 13
    Caption = 'y2:'
  end
  object lbl6: TLabel
    Left = 38
    Top = 77
    Width = 60
    Height = 13
    Caption = #28857#20987#22352#26631#65306
  end
  object lbl7: TLabel
    Left = 15
    Top = 96
    Width = 10
    Height = 13
    Caption = 'x:'
  end
  object lbl8: TLabel
    Left = 107
    Top = 96
    Width = 10
    Height = 13
    Caption = 'y:'
  end
  object lbl9: TLabel
    Left = 8
    Top = 119
    Width = 48
    Height = 13
    Caption = #20027#39068#33394#65306
  end
  object lbl10: TLabel
    Left = 8
    Top = 161
    Width = 48
    Height = 13
    Caption = #20559#39068#33394#65306
  end
  object edt_x1: TEdit
    Left = 38
    Top = 27
    Width = 44
    Height = 21
    TabOrder = 0
  end
  object edt_y1: TEdit
    Left = 129
    Top = 27
    Width = 44
    Height = 21
    TabOrder = 1
  end
  object edt_x2: TEdit
    Left = 38
    Top = 52
    Width = 44
    Height = 21
    TabOrder = 2
  end
  object edt_y2: TEdit
    Left = 129
    Top = 52
    Width = 44
    Height = 21
    TabOrder = 3
  end
  object edt_clickx: TEdit
    Left = 38
    Top = 94
    Width = 44
    Height = 21
    TabOrder = 4
  end
  object edt_clicky: TEdit
    Left = 129
    Top = 94
    Width = 44
    Height = 21
    TabOrder = 5
  end
  object cbbSelet: TComboBox
    Left = 8
    Top = 203
    Width = 66
    Height = 21
    ItemIndex = 0
    TabOrder = 6
    Text = #23383#31526#20018
    OnChange = cbbSeletChange
    Items.Strings = (
      #23383#31526#20018
      #22270'    '#33394)
  end
  object edt_color: TEdit
    Left = 19
    Top = 136
    Width = 154
    Height = 21
    TabOrder = 7
  end
  object redt_table: TRichEdit
    Left = 19
    Top = 228
    Width = 154
    Height = 41
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    Zoom = 100
  end
  object edt_offersetColor: TEdit
    Left = 19
    Top = 178
    Width = 154
    Height = 21
    TabOrder = 9
  end
  object btnClear: TButton
    Left = 129
    Top = 7
    Width = 49
    Height = 17
    Caption = #28165#31354
    TabOrder = 10
    OnClick = btnClearClick
  end
end
