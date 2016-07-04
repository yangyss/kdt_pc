unit setLarge;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, GDIPOBJ,
  GDIPAPI, Vcl.Imaging.pngimage, System.Math, Vcl.StdCtrls, Vcl.ComCtrls;

const
  WM_MyMessage = WM_USER + $201;

type
  TSetLargeForm = class(TForm)
    tmrSecond: TTimer;
    edtFirstPoint: TEdit;
    chkFirst: TCheckBox;
    edtSeondPoint: TEdit;
    edtThirdPoint: TEdit;
    edtFourPoint: TEdit;
    edtFivePoint: TEdit;
    edtSixPoint: TEdit;
    edtSevenPoint: TEdit;
    edtEightPoint: TEdit;
    edtNinePoint: TEdit;
    edtTenPoint: TEdit;
    pnlFirst: TPanel;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    lbl9: TLabel;
    lbl10: TLabel;
    pnlSecond: TPanel;
    pnlThree: TPanel;
    pnlFour: TPanel;
    pnlFive: TPanel;
    pnlSix: TPanel;
    pnlSeven: TPanel;
    pnlNine: TPanel;
    pnlTen: TPanel;
    pnlEight: TPanel;
    chkSecond: TCheckBox;
    chkThree: TCheckBox;
    chkFour: TCheckBox;
    chkFive: TCheckBox;
    chkSix: TCheckBox;
    chkSeven: TCheckBox;
    chkEight: TCheckBox;
    chkNine: TCheckBox;
    chkTen: TCheckBox;
    pgcOrder: TPageControl;
    tsFindColor: TTabSheet;
    tsFindStr: TTabSheet;
    tsOcr: TTabSheet;
    tsGetColor: TTabSheet;
    redtFindColor: TRichEdit;
    redtFindStr: TRichEdit;
    redtOcr: TRichEdit;
    redtGetColor: TRichEdit;
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrSecondTimer(Sender: TObject);
  private
    { Private declarations }
    procedure CreateParams(var Params: TCreateParams); override;

    procedure doMyMessage(var msg: TMessage); message WM_MyMessage;
  public
    { Public declarations }

  end;

var
  SetLargeForm: TSetLargeForm;
  aBitMap, showBitMap: TBitmap;
  Png: TPngObject;
  aStream: TStream;
  rt: TGPRectF;
  n: Single = 10.0; { 放大的倍数 }
  g_ThreadRunSign: Boolean;
  g_ThreadHaveRun: Boolean;
  g_ZanTing: Boolean;

implementation

{$R *.dfm}

uses
  catch;

var
  g_x, g_y: Integer;
  g_sign: Boolean;

  // 双缓冲？
procedure TSetLargeForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := 33554432; // 0x 02 00 00 00
end;

procedure TSetLargeForm.doMyMessage(var msg: TMessage);
begin

  if (msg.msg = WM_MyMessage) then
  begin

    g_x := msg.WParam;
    g_y := msg.LParam;
    if not Self.Showing then
      Exit;

    if Form1.imgShow.Picture.Graphic = nil then
      Exit;

    Png.Assign(Form1.imgShow.Picture);
    Png.SaveToStream(aStream);
    aBitMap.Assign(Png);

    Self.Repaint;

  end;

end;

procedure TSetLargeForm.FormCreate(Sender: TObject);
begin
  { 创建一个 TPNGObject 图片 ，用 TPicture 来赋值 }
  Png := TPngObject.Create;
  // Png.Assign(imgShow.Picture);

  { 创建一个 TStream 流,TPNGObjec图片存到流中 }
  aStream := TStream.Create;
  // Png.SaveToStream(aStream);

  { 创建一个 TBitmap,用流 TStream 给他赋值 }
  aBitMap := TBitmap.Create;
  // aBitMap.Assign(Png);
  showBitMap := TBitmap.Create;
  showBitMap.Height := 225;
  showBitMap.Width := 225;

  g_sign := False;
end;

procedure TSetLargeForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(aBitMap);
  FreeAndNil(Png);
  FreeAndNil(aStream);
  FreeAndNil(showBitMap);
end;

procedure TSetLargeForm.FormPaint(Sender: TObject);
var
  g: TGPGraphics;
  p: TGPPen;
  b: TGPSolidBrush;
  img: TGPImage;
  tmpRt: TGPRectF;
  Width, Height: Integer;
begin
  { 为什么 showBitMap 的值为 nil  奇怪？ }
  if showBitMap = nil then
    Exit;

  for Height := 0 to 225 - 1 do
    for Width := 0 to 225 - 1 do
    begin
      showBitMap.Canvas.Pixels[Width, Height] := aBitMap.Canvas.Pixels
        [Floor(Width / 15) + g_x - 7, Floor(Height / 15) + g_y - 7];
    end;

  img := TGPBitmap.Create(showBitMap.Handle, showBitMap.Palette);
  g := TGPGraphics.Create(Self.Canvas.Handle);
  p := TGPPen.Create(MakeColor(128, 255, 255, 255));

  tmpRt := MakeRect(3, 3, 224.0, 224);

  g.DrawImage(img, 3, 3, 0, 0, 224, 224, UnitPixel);

  g.DrawRectangle(p, tmpRt);

  FreeAndNil(p);
  g.Free;
  FreeAndNil(img);
end;

procedure TSetLargeForm.tmrSecondTimer(Sender: TObject);
begin

  // if not Self.Showing then
  // Exit;
  //
  // if Form1.imgShow.Picture.Graphic = nil then
  // Exit;
  //
  // Png.Assign(Form1.imgShow.Picture);
  // Png.SaveToStream(aStream);
  // aBitMap.Assign(Png);
  //
  // Self.Repaint;
end;

end.
