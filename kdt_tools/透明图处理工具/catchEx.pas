unit catchEx;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, ShellAPI,
  Vcl.StdCtrls, gdipapi, gdipobj, gdiputil, Vcl.OleCtnrs, Vcl.ToolWin, Vcl.ComCtrls,
  math, StrUtils;

var
  retX, retY, retWidth, retHeight, magnification: Integer;
  bSourceSelected, bDealWithSelected: Boolean;
  setBigDownX, setBigDownY: Integer;
  setBigUpX, setBigUpY: Integer;
  g_dealWithImg, g_twoValueImg: TImage;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    pnl1: TPanel;
    pnl2: TPanel;
    pnl3: TPanel;
    pnl4: TPanel;
    pnl5: TPanel;
    pnl6: TPanel;
    pnl7: TPanel;
    pnl8: TPanel;
    pnl9: TPanel;
    pnl10: TPanel;
    pnl11: TPanel;
    pnl12: TPanel;
    pnl13: TPanel;
    pnl14: TPanel;
    pnl15: TPanel;
    imgSource: TImage;
    imgTwoValue: TImage;
    imgDealWith: TImage;
    imgSetBig: TImage;
    btn1: TButton;
    btn2: TButton;
    dlgOpenImage: TOpenDialog;
    btn3: TButton;
    lstColorSelect: TColorListBox;
    AddColor: TButton;
    lbl1: TLabel;
    edtName: TEdit;
    btnGetColorValue: TButton;
    memoColor: TMemo;
    btnGetMainAndOfferColor: TButton;
    btnClear: TButton;
    btnAddAndCancel: TButton;
    lstColorDelete: TColorListBox;
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure imgSourceMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btn3Click(Sender: TObject);
    procedure AddColorClick(Sender: TObject);
    procedure imgSourceClick(Sender: TObject);
    procedure imgDealWithClick(Sender: TObject);
    procedure imgDealWithMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure imgSetBigMouseDown(Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer);
    procedure imgSetBigMouseUp(Sender: TObject; Button: TMouseButton; Shift:
      TShiftState; X, Y: Integer);
    procedure memoColorChange(Sender: TObject);
    procedure btnGetMainAndOfferColorClick(Sender: TObject);
    procedure edtNameKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnClearClick(Sender: TObject);
    procedure btnAddAndCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lstColorDeleteDblClick(Sender: TObject);
    procedure lstColorSelectDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DropFiles(var Msg: TMessage); message WM_DROPFILES;
    procedure selectAndSetToReadingGlass(X, Y: Integer); { 选择范围，切同步到放大镜 }
    function calcOffersetColor(): string;
    procedure PaintForImg(var img: TImage; aColor: TColor; x, y: Integer);
    procedure PaintForDealWithImg(aColor: TColor; x, y: Integer);
    procedure PaintForTwoValueImg(aColor: TColor; x, y: Integer);
    procedure calcOffersetColorWithDeleteColor(aColorStr: string);
  end;

var
  Form1: TForm1;
  index: Integer;
  g_X, g_Y: Integer;
  g_DrawSign: Boolean;
  btnAddAndCancelSign: Boolean;
  g_DrawPicSign: Boolean;

implementation

{$R *.dfm}

{
  绘制矩形：
  x,y为矩形的左上坐标
  retWidth,retHeight为程序初始化中设定的宽度和高度
  const Array中是虚线的样式
}
procedure myDrawRectangle();
var
  g: TGPGraphics;
  p: TGPPen;
const
  dash: array[0..3] of Single = (2, 1, 2, 1); { 虚线样式数组, 数组维数大小任意 }
begin
  if ((g_X >= Form1.imgSource.Left) and (g_Y >= Form1.imgSource.Top) and (g_X <=
    Form1.imgSource.width + Form1.imgSource.Left - 2) and (g_Y <= Form1.imgSource.height
    + Form1.imgSource.Top - 2)) or ((g_X >= Form1.imgDealWith.Left) and (g_Y >=
    Form1.imgDealWith.Top) and (g_X <= Form1.imgDealWith.width + Form1.imgDealWith.Left
    - 2) and (g_Y <= Form1.imgDealWith.height + Form1.imgDealWith.Top - 2)) then
  begin
    Form1.Repaint; { 重绘，清除画布 }
    g := TGPGraphics.Create(Form1.Canvas.Handle);
    p := TGPPen.Create(MakeColor(255, 0, 0), 1);
    p.SetDashPattern(@dash, Length(dash)); { 设置虚线 }
    g.DrawRectangle(p, g_X, g_Y, retWidth, retHeight); { 矩形描边 }
    p.Free;
    g.Free;

  end;

end;

procedure TForm1.AddColorClick(Sender: TObject);
begin
  lstColorSelect.Clear;
  lstColorSelect.Items.AddObject('FF0000', TObject($FF0000));
  lstColorSelect.Items.AddObject('FFFF00', TObject($FFFF00));
  lstColorSelect.Items.AddObject('FFFFFF', TObject($FFFFFF));
  lstColorSelect.Items.AddObject('00FF00', TObject($00FF00));
  lstColorSelect.Items.AddObject('00FFFF', TObject($00FFFF));
  lstColorSelect.Items.AddObject('0000FF', TObject($0000FF));
  lstColorSelect.Items.AddObject('000000', TObject($000000));
  lstColorSelect.Items.AddObject('FF00FF', TObject($FF00FF));
  lstColorSelect.Items.AddObject('808080', TObject($808080));

  lstColorSelect.ItemIndex := 3;
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
  // g := TGPGraphics.Create(Canvas.Handle);
  // sb := TGPSolidBrush.Create(MakeColor(255, 255, 255));
  // p := TGPPen.Create(MakeColor(255, 0, 0), 1);
  // // g.FillRectangle(sb, 0, 0, Self.ClientWidth, Self.ClientHeight); { 填充窗体矩形 }
  // g.DrawRectangle(p, retX, retY, retWidth, retHeight); { 矩形描边 }
  // // sb.SetColor(MakeColor(255, 255, 0));
  // // g.FillRectangle(sb, 11, 11, 111, 111); { 填充矩形 }
  // // g.DrawRectangle(p, 120, 120, 155, 155); { 矩形描边 }
  // // g.Invalidate
  // p.Free;
  // sb.Free;
  // g.Free;
//  myDrawRectangle();
end;

{
  函数功能：
  -- 绘制 图片
  (绘制dealwithimg 和 twoValueImg 图片)
}
procedure PaintPic();
var
  width, height, index: Integer;
  mainColor, offerColor: string;
  mainR, mainG, mainB, offerR, offerG, offerB: Integer;
  bIn: Boolean;
  aR, aG, aB: Integer;
  aColor: TColor;
begin

  for height := 0 to Form1.imgSource.Height - 1 do
  begin
    for width := 0 to Form1.imgSource.Width - 1 do
    begin
      aColor := Form1.imgSource.Canvas.Pixels[width, height];
      bIn := False;
      for index := 0 to Form1.memoColor.Lines.Count - 1 do
      begin
        if Length(Form1.memoColor.Lines[index]) > 12 then
        begin

          mainColor := LeftStr(Form1.memoColor.Lines[index], 6);
          offerColor := RightStr(Form1.memoColor.Lines[index], 6);
          mainR := GetRValue(StrToInt('$' + mainColor));
          mainG := GetGValue(StrToInt('$' + mainColor));
          mainB := GetBValue(StrToInt('$' + mainColor));

          offerR := GetRValue(StrToInt('$' + offerColor));
          offerG := GetGValue(StrToInt('$' + offerColor));
          offerB := GetBValue(StrToInt('$' + offerColor));

          aR := GetRValue(aColor);
          aG := GetGValue(aColor);
          aB := GetBValue(aColor);

          if (aR >= mainR - offerR) and (aR <= mainR + offerR) and (aG >= mainG
            - offerG) and (aG <= mainG + offerG) and (aB >= mainB - offerB) and
            (aB <= mainB + offerB) then
          begin
            bIn := True;
            Break;
          end;
        end;
      end;

      if bIn then
      begin
        if not btnAddAndCancelSign then
          g_dealWithImg.Canvas.Pixels[width, height] := aColor
        else
          g_dealWithImg.Canvas.Pixels[width, height] := $000000;

        g_twoValueImg.Canvas.Pixels[width, height] := $000000;
      end
      else
      begin
        if not btnAddAndCancelSign then
          g_dealWithImg.Canvas.Pixels[width, height] := $000000
        else
          g_dealWithImg.Canvas.Pixels[width, height] := aColor;

        g_twoValueImg.Canvas.Pixels[width, height] := $FFFFFF;
      end;
    end;
  end;
  Form1.imgTwoValue.Picture.Assign(g_twoValueImg.Picture);
  Form1.imgDealWith.Picture.Assign(g_dealWithImg.Picture);

  Form1.Repaint;

  g_DrawPicSign := True;
  Form1.btnAddAndCancel.Enabled := True;
end;

{
  拷贝imgDealWith或者imgSource中的选中部分，放大12倍至 放大镜 imgSetBig中 ：
  x,y为鼠标坐标
}
procedure CopyPic();
var
  width, height: Integer;
  intX, intY: Integer;
  n_x, n_y: Integer;
begin
  n_x := g_X;
  n_y := g_Y;
  if bSourceSelected then
  begin
    // sourceImage
    if Form1.imgSource.Picture = nil then
      Exit;
    for height := 0 to retHeight do
    begin
      for width := 0 to retWidth do
      begin
        for intY := 0 to 11 do
        begin
          for intX := 0 to 11 do
          begin
            Form1.Canvas.Lock;
//            Form1.imgSetBig.Canvas.Pixels[intX, intY] := Form1.imgSource.Canvas.Pixels
//              [width + n_x - Form1.imgSource.Left, height + n_y - Form1.imgSource.Top];
            Form1.imgSetBig.Canvas.Pixels[width * 12 + intX, height * 12 + intY]
              := Form1.imgSource.Canvas.Pixels[width + n_x - form1.imgSource.Left,
              height + n_y - Form1.imgSource.Top];
            Form1.Canvas.Unlock;
          end;
        end;
      end;
    end;
  end
  else if bDealWithSelected then
  begin
    // dealWithImage
    if Form1.imgDealWith.Picture = nil then
      Exit;
    for height := 0 to retHeight do
    begin
      for width := 0 to retWidth do
      begin
        for intY := magnification * height to magnification * (height + 1) do
        begin
          for intX := magnification * width to magnification * (width + 1) do
          begin
            Form1.Canvas.Lock;
            Form1.imgSetBig.Canvas.Pixels[intX, intY] := Form1.imgDealWith.Canvas.Pixels
              [width + n_x - Form1.imgDealWith.Left, height + n_y - Form1.imgDealWith.Top];
            Form1.Canvas.Unlock;
            Sleep(0);
          end;
        end;
      end;
    end;
  end;
end;



{
  打开bmp格式的图片：
  加载到 imgSource 控件中
}
procedure TForm1.btn2Click(Sender: TObject);
var
  filePath, fileName: string;
begin
  dlgOpenImage.Execute();
  filePath := ExtractFilePath(dlgOpenImage.fileName);
  fileName := ExtractFileName(dlgOpenImage.fileName);
  if Pos('.bmp', fileName) = 0 then
  begin
    ShowMessage('请打开bmp格式图片!');
    Exit;
  end;
  imgSource.Picture.LoadFromFile(filePath + fileName);

  g_dealWithImg.Picture.Bitmap.Width := imgSource.Picture.Bitmap.Width;
  g_dealWithImg.Picture.Bitmap.Height := imgSource.Picture.Bitmap.Height;

  g_twoValueImg.Picture.Bitmap.Width := imgSource.Picture.Bitmap.Width;
  g_twoValueImg.Picture.Bitmap.Height := imgSource.Picture.Bitmap.Height;

end;

procedure TForm1.btn3Click(Sender: TObject);
begin
  if not g_DrawSign then
  begin
    g_X := 35;
    g_Y := 35;
    TThread.CreateAnonymousThread(CopyPic).Start;
  end;
end;

procedure TForm1.btnAddAndCancelClick(Sender: TObject);
begin
  if g_DrawPicSign and (btnAddAndCancel.Enabled = True) then
  begin
    if not btnAddAndCancelSign then
    begin
      btnAddAndCancelSign := True;
      btnAddAndCancel.Caption := '增色';
    end
    else
    begin
      btnAddAndCancelSign := False;
      btnAddAndCancel.Caption := '删色';
    end;
    g_DrawPicSign := False;
    btnAddAndCancel.Enabled := False;
    TThread.Synchronize(nil, PaintPic);
  end;
end;

procedure TForm1.btnClearClick(Sender: TObject);
begin
  memoColor.Lines.Clear;
  lstColorSelect.Clear;
end;

procedure TForm1.btnGetMainAndOfferColorClick(Sender: TObject);
begin
end;

{
  函数功能:
  --通过GDI 选中范围，然后把该范围放大到放大镜中
  参数：
  --x,y为所选范围的左上坐标
}
procedure TForm1.selectAndSetToReadingGlass(X, Y: Integer);
begin

  if not g_DrawSign then
  begin
    g_X := x;
    g_Y := y;
    g_DrawSign := True;
    TThread.Synchronize(nil, CopyPic);
  end;

end;


{
  根据 lstColorSelect 中的颜色，计算主颜色和偏色
  返回值：
  --返回计算出来的的颜色；形如：A0A0A0-101010
}
function TForm1.calcOffersetColor(): string;
var
  index: Integer;
  tmpColor: string;
  tmpInt: Integer;
  lRValue, lGValue, lBValue: Integer;
  sRValue, sGValue, sBValue: Integer;
  mainR, mainG, mainB, offerR, offerG, offerB: Integer;
begin
  Result := '';
  lRValue := -1;
  lGValue := -1;
  lBValue := -1;
  sRValue := -1;
  sGValue := -1;
  sBValue := -1;
  for index := 0 to lstColorSelect.Count - 1 do
  begin
    tmpColor := lstColorSelect.Items[index];

    tmpInt := StrToInt('$' + tmpColor);

    if lRValue = -1 then
    begin
      lRValue := GetRValue(tmpInt);
      lGValue := GetGValue(tmpInt);
      lBValue := GetBValue(tmpInt);
    end;

    if sRValue = -1 then
    begin
      sRValue := GetRValue(tmpInt);
      sGValue := GetGValue(tmpInt);
      sBValue := GetBValue(tmpInt);
    end;

    if GetRValue(tmpInt) > lRValue then
      lRValue := GetRValue(tmpInt);

    if GetRValue(tmpInt) < sRValue then
      sRValue := GetRValue(tmpInt);

    if GetGValue(tmpInt) > lGValue then
      lGValue := GetGValue(tmpInt);

    if GetGValue(tmpInt) < sGValue then
      sGValue := GetGValue(tmpInt);

    if GetBValue(tmpInt) > lBValue then
      lBValue := GetBValue(tmpInt);

    if GetBValue(tmpInt) < sBValue then
      sBValue := GetBValue(tmpInt);

  end;

  if (lRValue = -1) or (sRValue = -1) then
    Exit;

  mainR := Floor((lRValue + sRValue) / 2);
  offerR := Floor((Abs(lRValue - sRValue) + 1) / 2);
  mainG := Floor((lGValue + sGValue) / 2);
  offerG := Floor((Abs(lGValue - sGValue) + 1) / 2);
  mainB := Floor((lBValue + sBValue) / 2);
  offerB := Floor((Abs(lBValue - sBValue) + 1) / 2);

  Result := IntToHex(mainB, 2) + IntToHex(mainG, 2) + IntToHex(mainR, 2) + '-' +
    IntToHex(offerB, 2) + IntToHex(offerG, 2) + IntToHex(offerR, 2);
end;

 {
 函数功能：
 -- 删除颜色时，计算偏色
 方法：
 --1，删除色，不在基本偏色范围内
 -----直接忽略
 --2，删除色，在基本偏色范围内
 -----从删除色开始，把基本色范围分为两部分。如：
 -----A0A0A0-202020，删除色为:A5A5A5。
 -----基本偏色范围为：808080 ~~~ C0C0C0 ，所以范围为：808080~~~A4A4A4 和 A6A6A6~~~C0C0C0
 -----两部分
 --3，范围为单的，-1取整，加上所减得单颜色
 -----如：101010~~~121213,那么取范围为 101010~~~121212，加单色121213
 -----即：111111-010101|121213-000000
 }
procedure TForm1.calcOffersetColorWithDeleteColor(aColorStr: string);
var
  aTStr: TStrings;
  maxColor, minColor, index, index_i, index_j, tmpInt: Integer;
  tmpStr: string;
  intArr: array of Integer;
begin
  aTStr := TStrings.Create;
  aTStr.Clear;
  // 得打颜色范围的 最小值 和 最大值
  maxColor := StrToInt('$' + LeftStr(aColorStr, 6)) + StrToInt('$' + RightStr(aColorStr,
    6));
  minColor := StrToInt('$' + LeftStr(aColorStr, 6)) - StrToInt('$' + RightStr(aColorStr,
    6));

  // 遍历 等待删除区，添加在范围内的颜色到 待处理 aTStr中
  for index := 0 to lstColorDelete.Count - 1 do
  begin
    tmpStr := lstColorDelete.Items[index];
    if tmpStr <> '' then
    begin
      if (StrToInt('$' + tmpStr) >= minColor) and (StrToInt('$' + tmpStr) <=
        maxColor) then
        aTStr.Add(tmpStr);
    end;
  end;

  if aTStr.Count = 0 then
  begin
    edtName.Clear;
    edtName.Text := aColorStr;
    Exit;
  end;


  // 根据 aTStr 的count 设置 intArr 的长度
  SetLength(intArr, aTStr.Count);

  // 把对应到 的 aTStr的 每一项，转化为 integer 填写到intArr中
  for index := 0 to aTStr.Count - 1 do
    intArr[index] := StrToInt('$' + aTStr[index]);

  // 冒泡法，从小到大排列
  if aTStr.Count > 2 then
  begin
    for index_j := 0 to aTStr.Count - 2 do
      for index_i := 1 to aTStr.Count - 1 do
      begin
        if intArr[index_j] > intArr[index_i] then
        begin
          tmpInt := intArr[index_j];
          intArr[index_j] := intArr[index_i];
          intArr[index_i] := tmpInt;
        end;
      end;
  end
  else if aTStr.Count = 2 then
  begin
    if intArr[0] > intArr[1] then
    begin
      tmpInt := intArr[0];
      intArr[0] := intArr[1];
      intArr[1] := tmpInt;
    end;
  end;

  if (intArr[0] = minColor) and (intArr[aTStr.Count - 1] < maxColor) then
  begin

  end
  else if (intArr[0] > minColor) and (intArr[aTStr.Count - 1] = maxColor) then
  begin

  end
  else
  begin

  end;

  SetLength(intArr, 0);

  FreeAndNil(aTStr);
end;


{
  函数功能:
  --从程序外部，拖拽一个图片到程序中:
  注意：
  --buffer为拖拽的文件路径+文件名称
}
procedure TForm1.DropFiles(var Msg: TMessage);
var
  buffer: array[0..1024] of Char;
begin
  inherited;
  buffer[0] := #0;
  DragQueryFile(Msg.WParam, 0, buffer, sizeof(buffer)); // 第一个文件
  ShowMessage('当前文件路径为：' + buffer);
end;

procedure TForm1.edtNameKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
  begin
    memoColor.Lines.Add(edtName.Text);
    edtName.Clear;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  { 第二个参数为False时，不启用文件拖放 }
  DragAcceptFiles(Handle, True);
  { 初始化：
    默认选取的范围
  }
  index := 0;
  retX := 13;
  retY := 13;
  retWidth := 14;
  retHeight := 14;
  magnification := 12;
  lstColorSelect.Clear; // 清空 lstColorSelect
  lstColorDelete.Clear;
  bSourceSelected := False;
  bDealWithSelected := False;

  setBigDownX := -1;
  setBigDownY := -1;

  g_DrawSign := False;

  memoColor.Clear;

  btnAddAndCancel.Caption := '删色';
  btnAddAndCancelSign := False;

  g_DrawPicSign := True;

  imgDealWith.Cursor := crHandpoint;
  imgSource.Cursor := crHandpoint;

  g_dealWithImg := TImage.Create(nil);
  g_twoValueImg := TImage.Create(nil);

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(g_dealWithImg);
  FreeAndNil(g_twoValueImg);
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  // 重绘所有的GDI图形
  { TODO -oyangyss -c :  2016/5/19 16:18:39 }
end;

procedure TForm1.imgDealWithClick(Sender: TObject);
begin
  bDealWithSelected := not bDealWithSelected;

  if bDealWithSelected then
  begin
    bSourceSelected := False;

    imgDealWith.Cursor := crDefault;
    imgSource.Cursor := crHandpoint;
  end
  else
  begin
    imgDealWith.Cursor := crHandpoint;
    imgSource.Cursor := crHandpoint;
  end;
end;

procedure TForm1.imgDealWithMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if not bDealWithSelected then
    Exit;

  g_X := X + imgDealWith.Left - 7;
  g_Y := Y + imgDealWith.Top - 7;
  TThread.Synchronize(nil, CopyPic);
end;

procedure TForm1.imgSetBigMouseDown(Sender: TObject; Button: TMouseButton; Shift:
  TShiftState; X, Y: Integer);
begin
  setBigDownX := X;
  setBigDownY := Y;
end;

procedure AddColorToColorListBox();
var
  index_width, index_height, index: Integer;
  min_x, min_y, max_x, max_y: Integer;
  aColor: TColor;
  index_width_max, index_height_max: Integer;
  bIn: Boolean;
begin
  { TODO -oyangyss -c :  2016/5/20 19:03:32 }
  if (setBigDownX = -1) or (setBigDownY = -1) then
    Exit;

  if setBigDownX >= setBigUpX then
  begin
    max_x := setBigDownX;
    min_x := setBigUpX;
  end
  else
  begin
    max_x := setBigUpX;
    min_x := setBigDownX;
  end;

  if min_x < 0 then
    min_x := 0;
  if max_x > 180 then
    max_x := 180;

  if setBigDownY >= setBigUpY then
  begin
    max_y := setBigDownY;
    min_y := setBigUpY;
  end
  else
  begin
    max_y := setBigUpY;
    min_y := setBigDownY;
  end;

  if min_y < 0 then
    min_y := 0;
  if max_y > 180 then
    max_y := 180;

  index_width_max := floor((max_x - min_x) div 12);
  index_height_max := floor((max_y - min_y) div 12);
  for index_width := 0 to index_width_max do
  begin
    for index_height := 0 to index_height_max do
    begin
      aColor := Form1.imgSetBig.Canvas.Pixels[min_x + index_width * 12, min_y +
        index_height * 12];
      bIn := False;

      for index := Form1.lstColorSelect.Count - 1 downto 0 do
      begin
        if SameText(Form1.lstColorSelect.Items[index], IntToHex(aColor, 6)) then
        begin
          bIn := True;
        end;
      end;
      if (bIn = False) then
        Form1.lstColorSelect.AddItem(IntToHex(aColor, 6), TObject(aColor));
    end;
  end;
  Form1.edtName.Clear;
  Form1.edtName.Text := Form1.calcOffersetColor;
end;

procedure TForm1.imgSetBigMouseUp(Sender: TObject; Button: TMouseButton; Shift:
  TShiftState; X, Y: Integer);
begin
  setBigUpX := X;
  setBigUpY := Y;
  TThread.Synchronize(nil, AddColorToColorListBox);
end;

procedure TForm1.imgSourceClick(Sender: TObject);
begin

  bSourceSelected := not bSourceSelected;
  if bSourceSelected then
  begin
    bDealWithSelected := False;
    imgSource.Cursor := crDefault;
    imgDealWith.Cursor := crHandpoint;
  end
  else
  begin
    imgSource.Cursor := crHandpoint;
    imgDealWith.Cursor := crHandpoint;
  end;
end;

procedure TForm1.imgSourceMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if not bSourceSelected then
    Exit;

  g_X := X + imgSource.Left - 7;
  g_Y := Y + imgSource.Top - 7;
//  g_X := X + imgSource.Left;
//  g_Y := Y + imgSource.Top;
  TThread.Synchronize(nil, CopyPic);
end;

procedure TForm1.lstColorDeleteDblClick(Sender: TObject);
begin
  lstColorDelete.DeleteSelected;
end;

procedure TForm1.lstColorSelectDblClick(Sender: TObject);
var
  offStr: string;
begin
  lstColorSelect.DeleteSelected;
  offStr := calcOffersetColor;
  edtName.Clear;
  edtName.Text := offStr;
end;

procedure TForm1.PaintForImg(var img: TImage; aColor: TColor; x, y: Integer);
begin
  img.Canvas.Pixels[x, y] := aColor;
end;

procedure TForm1.PaintForDealWithImg(aColor: TColor; x, y: Integer);
var
  index: Integer;
  mainColor, offerColor: string;
  mainR, mainG, mainB, offerR, offerG, offerB: Integer;
  bIn: Boolean;
begin
  bIn := False;
  for index := 0 to memoColor.Lines.Count - 1 do
  begin
    mainColor := LeftStr(memoColor.Lines[index], 6);
    offerColor := RightStr(memoColor.Lines[index], 6);
    mainR := GetRValue(StrToInt('$' + mainColor));
    mainG := GetGValue(StrToInt('$' + mainColor));
    mainB := GetBValue(StrToInt('$' + mainColor));

    offerR := GetRValue(StrToInt('$' + offerColor));
    offerG := GetGValue(StrToInt('$' + offerColor));
    offerB := GetBValue(StrToInt('$' + offerColor));

    if (GetRValue(aColor) >= mainR - offerR) and (GetRValue(aColor) <= mainR -
      offerR) and (GetGValue(aColor) >= mainG - offerG) and (GetGValue(aColor)
      <= mainG + offerG) and (GetBValue(aColor) >= mainB - offerB) and (GetBValue
      (aColor) <= mainB + offerB) then
    begin
      bIn := True;
      Break;
    end;
  end;
  if bIn then
    Self.PaintForImg(imgDealWith, aColor, x, y)
  else
    Self.PaintForImg(imgDealWith, $000000, x, y);
end;

procedure TForm1.PaintForTwoValueImg(aColor: TColor; x, y: Integer);
var
  index: Integer;
  mainColor, offerColor: string;
  mainR, mainG, mainB, offerR, offerG, offerB: Integer;
  bIn: Boolean;
  aR, aG, aB: Integer;
begin

  bIn := False;
  for index := 0 to memoColor.Lines.Count - 1 do
  begin
    mainColor := LeftStr(memoColor.Lines[index], 6);
    offerColor := RightStr(memoColor.Lines[index], 6);
    mainR := GetRValue(StrToInt('$' + mainColor));
    mainG := GetGValue(StrToInt('$' + mainColor));
    mainB := GetBValue(StrToInt('$' + mainColor));

    offerR := GetRValue(StrToInt('$' + offerColor));
    offerG := GetGValue(StrToInt('$' + offerColor));
    offerB := GetBValue(StrToInt('$' + offerColor));

    aR := GetRValue(aColor);
    aG := GetGValue(aColor);
    aB := GetBValue(aColor);

    if (aR >= mainR - offerR) and (aR <= mainR + offerR) and (aG >= mainG -
      offerG) and (aG <= mainG + offerG) and (aB >= mainB - offerB) and (aB <=
      mainB + offerB) then
    begin
      bIn := True;
      Break;
    end;
  end;

  Canvas.Lock;

  if bIn then
  begin
    if not btnAddAndCancelSign then
      self.PaintForImg(imgDealWith, aColor, x, y)
    else
      Self.PaintForImg(imgDealWith, $000000, x, y);

    Self.PaintForImg(imgTwoValue, $000000, x, y);
  end
  else
  begin
    if not btnAddAndCancelSign then
      Self.PaintForImg(imgDealWith, $000000, x, y)
    else
      self.PaintForImg(imgDealWith, aColor, x, y);

    Self.PaintForImg(imgTwoValue, $FFFFFF, x, y);
  end;

  Canvas.Unlock;
end;

procedure TForm1.memoColorChange(Sender: TObject);
begin
  if g_DrawPicSign then
  begin
    g_DrawPicSign := False;
    TThread.Synchronize(nil, PaintPic);
//    TThread.CreateAnonymousThread(PaintPic).Start;
  end;
end;

end.

