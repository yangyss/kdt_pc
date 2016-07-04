object Form1: TForm1
  Left = 566
  Top = 225
  BorderStyle = bsDialog
  Caption = #36879#26126#22270#21046#20316#24037#20855'-By'#21475#34955#20820
  ClientHeight = 402
  ClientWidth = 753
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object imgSource: TImage
    Left = 13
    Top = 13
    Width = 254
    Height = 180
    OnClick = imgSourceClick
    OnMouseMove = imgSourceMouseMove
  end
  object imgTwoValue: TImage
    Left = 485
    Top = 13
    Width = 254
    Height = 180
  end
  object imgDealWith: TImage
    Left = 13
    Top = 209
    Width = 254
    Height = 180
    OnClick = imgDealWithClick
    OnMouseMove = imgDealWithMouseMove
  end
  object imgSetBig: TImage
    Left = 291
    Top = 8
    Width = 180
    Height = 180
    OnMouseDown = imgSetBigMouseDown
    OnMouseUp = imgSetBigMouseUp
  end
  object lbl1: TLabel
    Left = 558
    Top = 249
    Width = 36
    Height = 13
    BiDiMode = bdLeftToRight
    Caption = #20559#33394#65306
    ParentBiDiMode = False
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 5
    Height = 190
    TabOrder = 0
  end
  object pnl1: TPanel
    Left = 12
    Top = 8
    Width = 260
    Height = 5
    TabOrder = 1
  end
  object pnl2: TPanel
    Left = 12
    Top = 193
    Width = 260
    Height = 5
    TabOrder = 2
  end
  object pnl3: TPanel
    Left = 269
    Top = 8
    Width = 5
    Height = 190
    TabOrder = 3
  end
  object pnl4: TPanel
    Left = 280
    Top = 8
    Width = 5
    Height = 190
    TabOrder = 4
  end
  object pnl5: TPanel
    Left = 284
    Top = 8
    Width = 185
    Height = 5
    TabOrder = 5
  end
  object pnl6: TPanel
    Left = 284
    Top = 193
    Width = 185
    Height = 5
    TabOrder = 6
  end
  object pnl7: TPanel
    Left = 465
    Top = 8
    Width = 5
    Height = 190
    TabOrder = 7
  end
  object pnl8: TPanel
    Left = 267
    Top = 204
    Width = 5
    Height = 190
    TabOrder = 8
  end
  object pnl9: TPanel
    Left = 12
    Top = 389
    Width = 260
    Height = 5
    TabOrder = 9
  end
  object pnl10: TPanel
    Left = 12
    Top = 204
    Width = 260
    Height = 5
    TabOrder = 10
  end
  object pnl11: TPanel
    Left = 8
    Top = 204
    Width = 5
    Height = 190
    TabOrder = 11
  end
  object pnl12: TPanel
    Left = 739
    Top = 8
    Width = 5
    Height = 190
    TabOrder = 12
  end
  object pnl13: TPanel
    Left = 484
    Top = 193
    Width = 260
    Height = 5
    TabOrder = 13
  end
  object pnl14: TPanel
    Left = 484
    Top = 8
    Width = 260
    Height = 5
    TabOrder = 14
  end
  object pnl15: TPanel
    Left = 480
    Top = 8
    Width = 5
    Height = 190
    TabOrder = 15
  end
  object btn1: TButton
    Left = 64
    Top = 472
    Width = 49
    Height = 25
    Caption = 'btn1'
    TabOrder = 16
    OnClick = btn1Click
  end
  object btn2: TButton
    Left = 420
    Top = 344
    Width = 65
    Height = 33
    Caption = #21152#36733#22270#29255
    TabOrder = 17
    OnClick = btn2Click
  end
  object btn3: TButton
    Left = 384
    Top = 472
    Width = 49
    Height = 25
    Caption = 'copyPic'
    TabOrder = 18
    OnClick = btn3Click
  end
  object lstColorSelect: TColorListBox
    Left = 282
    Top = 227
    Width = 127
    Height = 167
    TabOrder = 19
    OnDblClick = lstColorSelectDblClick
  end
  object AddColor: TButton
    Left = 448
    Top = 472
    Width = 57
    Height = 25
    Caption = 'AddColor'
    TabOrder = 20
    OnClick = AddColorClick
  end
  object edtName: TEdit
    Left = 616
    Top = 246
    Width = 113
    Height = 21
    TabOrder = 21
    OnKeyUp = edtNameKeyUp
  end
  object btnGetColorValue: TButton
    Left = 297
    Top = 424
    Width = 57
    Height = 25
    Caption = 'btnGetColorValue'
    TabOrder = 22
  end
  object memoColor: TMemo
    Left = 616
    Top = 288
    Width = 113
    Height = 106
    Lines.Strings = (
      'FFA0B0-101010')
    TabOrder = 23
    OnChange = memoColorChange
  end
  object btnGetMainAndOfferColor: TButton
    Left = 400
    Top = 424
    Width = 129
    Height = 25
    Caption = #33719#24471#20027#33394#21644#20559#33394
    TabOrder = 24
    OnClick = btnGetMainAndOfferColorClick
  end
  object btnClear: TButton
    Left = 420
    Top = 286
    Width = 65
    Height = 35
    Caption = #28165#31354
    TabOrder = 25
    OnClick = btnClearClick
  end
  object btnAddAndCancel: TButton
    Left = 420
    Top = 227
    Width = 65
    Height = 33
    Caption = #21024#38500
    TabOrder = 26
    OnClick = btnAddAndCancelClick
  end
  object lstColorDelete: TColorListBox
    Left = 670
    Top = 519
    Width = 91
    Height = 167
    TabOrder = 27
    OnDblClick = lstColorDeleteDblClick
  end
  object dlgOpenImage: TOpenDialog
    Left = 320
    Top = 464
  end
end
