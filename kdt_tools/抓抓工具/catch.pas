unit catch;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.StdCtrls, data, Vcl.Imaging.pngimage, Vcl.Menus, Vcl.ToolWin, Vcl.Buttons,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdAuthentication, System.Math, GDIPOBJ, GDIPAPI, setLarge, Vcl.ActnMan,
  Vcl.ActnCtrls, System.ImageList, Vcl.ImgList;

type
  TImageData = record
    aPicture: TPicture; // 图片信息
    fullName: string; // 图片的全名称
    showName: string; // 图片的显示名称
    checked: Boolean; // 图片是否被选择
    show: Boolean; // 没有图片不显示
    showLableBtn: Boolean; // 显示标签
    checkBtn: TSpeedButton; // 控制选择图片的TSpeedButton
    closeBtn: TSpeedButton; // 控制关闭图片的TSpeedButton
    checkBtnWidth: Integer; // 控制选择图片的TSpeedButton 的 width
    checkBtnLeft: Integer; // 控制选择图片的TSpeedButton 的 left
    checkBtnTop: Integer; // 控制选择图片的TSpeedButton 的 top
    checkBtnHeight: Integer; // 控制选择图片的TSpeedButton 的 height
    closeBtnWidth: Integer;
    closeBtnLeft: Integer;
    closeBtnTop: Integer;
    closeBtnHeigth: Integer;
  end;

  TForm1 = class(TForm)
    pnlShowData: TPanel;
    imgShow: TImage;
    mmMenu: TMainMenu;
    N1: TMenuItem;
    mMenuFileOpen: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N15: TMenuItem;
    NCalcData: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    dlgOpenPic: TOpenDialog;
    NSetLarge: TMenuItem;
    showBar: TToolBar;
    btnOpen: TToolButton;
    toolBarImageList: TImageList;
    procedure btnTestClick(Sender: TObject);
    procedure imgFirstMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure hotkey(var msg: TMessage); message WM_HOTKEY;
    procedure FormDestroy(Sender: TObject);
    procedure setCurrentPicStartPos(aPoint: TPoint);
    function getCurrentPicStartPos(): TPoint;
    procedure btnFirstCloseClick(Sender: TObject);
    procedure OnChangDown(aSpeedBtn: TSpeedButton);
    procedure NCalcDataClick(Sender: TObject);
    procedure InitImageArr(var aImageArr: array of TImageData);
    procedure SetBtnsPos(var aImageArr: array of TImageData);
    procedure btnOpenClick(Sender: TObject);
    procedure mMenuFileOpenClick(Sender: TObject);
    procedure imgShowMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure NSetLargeClick(Sender: TObject);
  private
    { Private declarations }
    wtRangStart, wtRangEnd, wtClick: ATOM; { 数据处理窗口的 3 个 hotkey }
    { 放大镜窗口的 14 个 hotkey }
    wtZero, wtNine, wtEight, wtSeven, wtSix, wtFive, wtFour, wtThree, wtTwo,
      wtOne, wtHotKeyRight, wtHotKeyDown, wtHotKeyUp, wtHotKeyLeft: ATOM;

    wtLeft, wtTop: Integer;
    procedure setImageShowRect();
  public
    { Public declarations }
    procedure CalcBtnRang(); { 计算显示 图片名称的 标签的 rang }
    function ShowAImage(aFullName: string): Boolean; { 显示一个 image }
    function LoadAImage(aPicture: TPicture; aFullName: string): Boolean;
    function OpenAPicByOpenDlg(): Boolean;
    procedure OnChangeSpeedBtnDown(Sender: TObject);
    procedure OnCloseImageData(Sender: TObject);
    procedure SetSpeedBtnDown(aSpeedBtn: TSpeedButton);
    function ClacShowCaption(btnWidth: Integer; aFullName: string): string;
    procedure HideSpeedBtns(aSpeedBtn: TSpeedButton);
    procedure ShowDefaultImage();
  end;

var
  Form1: TForm1;
  g_ImageArr: array [0 .. 20] of TImageData; { 当前下，所有的imageData }
  g_BtnWidth, g_LastBtnWidth: Integer; { 当前情况下，标签的宽度 }
  g_ClickBtnDownSign: Boolean; { 当前 点击的 按钮的 Down 属性值 }
  g_ImgShowLarge: TGPImage;
  g_moveSign: Boolean; { mouse 移动的标志 }
  g_moveX, g_moveY: Integer; { mouse 移动到的坐标 }

const
  lableOfPicNameHeight = 20; { 图片的名字显示区的高度 }
  defaultWidth = 180; { 显示图片名称的标签的 默认width }
  defaultHeight = 20; { 显示图片名称的标签的 默认height }
  defaultTop = 24; { 显示图片名称的标签的 默认Top }
  defaultLeft = 0; { 显示图片名称的标签的 默认Left }

implementation

{$R *.dfm}

function TForm1.ShowAImage(aFullName: string): Boolean; { 显示一个 image }
var
  index: Integer;
  showIndex, sameTextIndex: Integer;
begin
  Result := False;
  showIndex := -1;
  sameTextIndex := -1;

  for index := 0 to Length(g_ImageArr) - 1 do
  begin
    if SameText(g_ImageArr[index].fullName, aFullName) and (sameTextIndex = -1)
    then
    begin
      sameTextIndex := index;
    end;

    if g_ImageArr[index].show and (showIndex = -1) then
    begin
      showIndex := index;
    end;
  end;

  if sameTextIndex = -1 then
  begin
    // 没有相同的字符串
    if showIndex = -1 then { 没有显示的 图片 ，退出 }
      Exit;

    for index := 0 to Length(g_ImageArr) do
    begin
      if index <> showIndex then { 非 显示的 图片都 置为 false }
        g_ImageArr[index].show := False
      else
      begin
        Self.SetSpeedBtnDown(g_ImageArr[index].checkBtn);
        g_ImageArr[index].showLableBtn := True;
      end;
    end;
  end
  else
  begin
    // 有相同的字符串
    for index := 0 to Length(g_ImageArr) do
    begin
      if index <> sameTextIndex then { 不相同字符串 图片都 置为 false }
        g_ImageArr[index].show := False
      else
      begin
        g_ImageArr[index].show := True; { 相同的字符串 图片显示 置为true }
        g_ImageArr[index].showLableBtn := True;
        Self.SetSpeedBtnDown(g_ImageArr[index].checkBtn);
      end;
    end;

    Self.imgShow.Picture.Assign(g_ImageArr[sameTextIndex].aPicture); { 图片中显示之 }
  end;
  Result := True;
end;

function TForm1.LoadAImage(aPicture: TPicture; aFullName: string): Boolean;
{ 加载一个图片到arr中 }
var
  index: Integer;
begin
  Result := False;
  for index := 0 to Length(g_ImageArr) - 1 do
  begin
    if SameText(g_ImageArr[index].fullName, aFullName) then
      Exit;
  end;

  for index := 0 to Length(g_ImageArr) - 1 do
  begin
    { fullName为'',表示 数组的此位置是可用的，可以增加图片 }
    if g_ImageArr[index].fullName = '' then
    begin
      Result := True;
      g_ImageArr[index].show := False;
      g_ImageArr[index].showLableBtn := True;
      g_ImageArr[index].aPicture.Assign(aPicture);
      g_ImageArr[index].fullName := aFullName;
      g_ImageArr[index].showName := ExtractFileName(aFullName);
      Break;
    end;
  end;
end;

{ aSpeedBtn 的 Down 属性 置为true }
procedure TForm1.SetSpeedBtnDown(aSpeedBtn: TSpeedButton);
begin
  aSpeedBtn.GroupIndex := 1;
  aSpeedBtn.Down := True;
end;

{ 书写标题的 speedBtn 的点击事件 }
procedure TForm1.OnChangeSpeedBtnDown(Sender: TObject);
var
  index: Integer;
begin
  for index := 0 to Length(g_ImageArr) - 1 do
  begin
    if g_ImageArr[index].checkBtn = TSpeedButton(Sender) then
    begin
      g_ImageArr[index].show := True;
      g_ImageArr[index].checkBtn.GroupIndex := 1;
      g_ImageArr[index].checkBtn.Down := True;
      imgShow.Picture.Assign(g_ImageArr[index].aPicture);
    end
    else
      g_ImageArr[index].show := False;
  end;

end;

procedure TForm1.HideSpeedBtns(aSpeedBtn: TSpeedButton);
var
  index: Integer;
begin
  for index := 0 to Length(g_ImageArr) - 1 do
  begin
    if (g_ImageArr[index].closeBtn = aSpeedBtn) and
      (g_ImageArr[index].fullName <> '') then
    begin
      g_ImageArr[index].fullName := '';
      g_ImageArr[index].show := False;
      g_ImageArr[index].showLableBtn := False;
      g_ImageArr[index].checkBtn.Visible := g_ImageArr[index].show;
      g_ImageArr[index].closeBtn.Visible := g_ImageArr[index].show;
      Break;
    end;
  end;
end;

procedure TForm1.ShowDefaultImage();
var
  index, waitShowIndex, haveShowIndex: Integer;
  aPicture: TPicture;
begin
  waitShowIndex := -1;
  haveShowIndex := -1;
  for index := 0 to Length(g_ImageArr) - 1 do
  begin
    if g_ImageArr[index].fullName <> '' then
    begin
      waitShowIndex := index;
      Break;
    end;
  end;

  for index := 0 to Length(g_ImageArr) - 1 do
  begin
    if g_ImageArr[index].show then
    begin
      haveShowIndex := index;
      Break
    end;
  end;

  if haveShowIndex >= 0 then
    Exit;

  if waitShowIndex < 0 then
  begin
    aPicture := TPicture.Create;
    Self.imgShow.Picture.Assign(aPicture); { 清除 showImage }
    FreeAndNil(aPicture);
  end
  else
  begin
    g_ImageArr[waitShowIndex].show := True;
    g_ImageArr[waitShowIndex].checkBtn.Visible :=
      g_ImageArr[waitShowIndex].show;
    g_ImageArr[waitShowIndex].closeBtn.Visible :=
      g_ImageArr[waitShowIndex].show;
    SetSpeedBtnDown(g_ImageArr[waitShowIndex].checkBtn);
    imgShow.Picture.Assign(g_ImageArr[waitShowIndex].aPicture);
  end;

end;

{
  函数名：标题为 'X' 的speedBtn 的点击事件
  函数功能：
  --1，隐藏对应的speedBtns
  --2，切换image
}
procedure TForm1.OnCloseImageData(Sender: TObject);
begin
  { TODO -oyangyss -c :  2016/6/25 21:32:58 }
  Self.HideSpeedBtns(TSpeedButton(Sender));
  Self.CalcBtnRang;
  g_ClickBtnDownSign := TSpeedButton(Sender).Down;
  Self.ShowDefaultImage;
end;

procedure TForm1.SetBtnsPos(var aImageArr: array of TImageData);
var
  index, numOfArr: Integer;
begin
  // numOfArr := Length(aImageArr);
  // if numOfArr * defaultWidth > Self.pnlShowData.Width then
  for index := 0 to Length(aImageArr) - 1 do
  begin
    { TODO -oyangyss -c :  2016/6/25 23:28:37 }
  end;
end;

procedure TForm1.InitImageArr(var aImageArr: array of TImageData);
var
  index: Integer;
begin
  for index := 0 to Length(aImageArr) - 1 do
  begin

    aImageArr[index].aPicture := TPicture.Create();
    aImageArr[index].fullName := '';
    aImageArr[index].showName := '';
    aImageArr[index].checked := False;
    aImageArr[index].show := False;
    aImageArr[index].showLableBtn := False;

    aImageArr[index].checkBtn := TSpeedButton.Create(Self);

    aImageArr[index].checkBtnWidth := defaultWidth;
    aImageArr[index].checkBtnLeft := defaultLeft;
    aImageArr[index].checkBtnTop := defaultTop;
    aImageArr[index].checkBtnHeight := defaultHeight;
    with aImageArr[index].checkBtn do
    begin
      Width := aImageArr[index].checkBtnWidth;
      Left := aImageArr[index].checkBtnLeft;
      Top := aImageArr[index].checkBtnTop;
      Height := aImageArr[index].checkBtnHeight;
      Parent := Self;
      OnClick := OnChangeSpeedBtnDown; // 指定button click事件
      Caption := 'speedBtn:' + IntToStr(index);
      Visible := aImageArr[index].showLableBtn;
    end;

    aImageArr[index].closeBtn := TSpeedButton.Create(Self);

    aImageArr[index].closeBtnWidth := defaultHeight;
    aImageArr[index].closeBtnLeft := aImageArr[index].checkBtnWidth -
      defaultHeight;
    aImageArr[index].closeBtnTop := defaultTop;
    aImageArr[index].closeBtnHeigth := defaultHeight;

    with aImageArr[index].closeBtn do
    begin
      Width := aImageArr[index].closeBtnWidth;
      Left := aImageArr[index].closeBtnLeft;
      Top := aImageArr[index].closeBtnTop;
      Height := aImageArr[index].closeBtnHeigth;
      OnClick := OnCloseImageData; // 指定button click事件
      Flat := True;
      Parent := Self;
      Caption := 'X';
      Visible := aImageArr[index].showLableBtn;
      ShowHint := True;
      Hint := '';
    end;
  end;
end;

// 计算 speedBtn显示的 caption 具体内容
function TForm1.ClacShowCaption(btnWidth: Integer; aFullName: string): string;
var
  tmpStr: string;
begin
  Result := '';
  // IMG_14658073650037.png
  if btnWidth < 42 then
    tmpStr := '...'
  else if btnWidth < 84 then
  begin
    if Length(aFullName) > 7 then
      tmpStr := Copy(aFullName, 0, 4) + '...'
    else
      tmpStr := aFullName;
  end
  else if btnWidth < 126 then
  begin
    if Length(aFullName) > 14 then
      tmpStr := Copy(aFullName, 0, 8) + '...'
    else
      tmpStr := aFullName;
  end
  else if btnWidth < 164 then
  begin
    if Length(aFullName) > 21 then
      tmpStr := Copy(aFullName, 0, 15) + '...'
    else
      tmpStr := aFullName;
  end
  else
    tmpStr := aFullName;

  Result := tmpStr;
end;

procedure TForm1.CalcBtnRang();
var
  allWidth: Integer;
  imageBtnShowNum: Integer;
  index: Integer;
  showIndex: Integer;
begin
  showIndex := 0;
  imageBtnShowNum := 0;
  for index := 0 to Length(g_ImageArr) - 1 do
  begin
    if g_ImageArr[index].showLableBtn then
      imageBtnShowNum := imageBtnShowNum + 1;
  end;

  if imageBtnShowNum = 0 then
    Exit;
  allWidth := Self.pnlShowData.Width;
  if defaultWidth * imageBtnShowNum > allWidth then
  begin
    // 所有的 标题长度 之和 大于 总的width的长度，重新设置每一个的width
    g_BtnWidth := Floor(allWidth / imageBtnShowNum);
    g_LastBtnWidth := allWidth - (imageBtnShowNum - 1) * g_BtnWidth;
  end
  else
  begin
    g_BtnWidth := defaultWidth;
    g_LastBtnWidth := defaultWidth;
  end;

  for index := 0 to Length(g_ImageArr) - 1 do
  begin
    g_ImageArr[index].checkBtnLeft := showIndex * g_BtnWidth;
    if index = Length(g_ImageArr) - 1 then
    begin
      g_ImageArr[index].checkBtnWidth := g_LastBtnWidth;
    end
    else
      g_ImageArr[index].checkBtnWidth := g_BtnWidth;

    g_ImageArr[index].showName := Self.ClacShowCaption
      (g_ImageArr[index].checkBtnWidth,
      ExtractFileName(g_ImageArr[index].fullName));

    with g_ImageArr[index].checkBtn do
    begin
      Left := g_ImageArr[index].checkBtnLeft;
      Width := g_ImageArr[index].checkBtnWidth;
      Top := g_ImageArr[index].checkBtnTop;
      Height := g_ImageArr[index].checkBtnHeight;
      Visible := g_ImageArr[index].showLableBtn;
      Caption := g_ImageArr[index].showName;
      ShowHint := True;
      Hint := ExtractFileName(g_ImageArr[index].fullName);
    end;

    g_ImageArr[index].closeBtnLeft := g_ImageArr[index].checkBtnLeft +
      g_ImageArr[index].checkBtnWidth - defaultHeight;
    g_ImageArr[index].closeBtnWidth := defaultHeight;
    g_ImageArr[index].closeBtnTop := defaultTop;
    g_ImageArr[index].closeBtnHeigth := defaultHeight;

    with g_ImageArr[index].closeBtn do
    begin
      Left := g_ImageArr[index].closeBtnLeft;
      Width := g_ImageArr[index].closeBtnWidth;
      Top := g_ImageArr[index].closeBtnTop;
      Height := g_ImageArr[index].closeBtnHeigth;
      Visible := g_ImageArr[index].showLableBtn;
    end;

    if g_ImageArr[index].showLableBtn then
      showIndex := showIndex + 1;
  end;
end;

procedure TForm1.setImageShowRect();
begin
  Self.imgShow.Top := Self.showBar.Top + Self.showBar.Height +
    lableOfPicNameHeight;
  Self.imgShow.Left := 0;
  Self.imgShow.Width := Self.showBar.Width;

  Self.imgShow.Height := Self.pnlShowData.Top - Self.imgShow.Top;
end;

procedure TForm1.setCurrentPicStartPos(aPoint: TPoint);
begin
  Self.Left := aPoint.X;
  Self.Top := aPoint.Y;
end;

function TForm1.getCurrentPicStartPos(): TPoint;
var
  aPoint: TPoint;
begin
  aPoint.X := Self.Left;
  aPoint.Y := Self.Top;
  Result := aPoint;
end;

procedure TForm1.btnFirstCloseClick(Sender: TObject);
begin
  ShowMessage('click speedbutton');
end;

procedure TForm1.btnOpenClick(Sender: TObject);
begin
  // ShowMessage('打开一个图片');
  Self.OpenAPicByOpenDlg; // 加载一张图片到 imageArr中 然后 置 显示的 为当前图片
  Self.CalcBtnRang(); // 计算每个speedBtn的 range 然后置他们到指定位置
end;

function TForm1.OpenAPicByOpenDlg(): Boolean;
var
  fullName: string;
  aPicture: TPicture;
  index: Integer;
begin
  Result := False;
  aPicture := TPicture.Create;

  dlgOpenPic.Execute();
  if dlgOpenPic.Files.Count < 1 then
    Exit;

  for index := 0 to dlgOpenPic.Files.Count - 1 do
  begin
    fullName := dlgOpenPic.Files[index];
    aPicture.LoadFromFile(fullName);

    Self.LoadAImage(aPicture, fullName); { 加载 图片信息 到 imageArr中，同时置显示为 false }
    Self.ShowAImage(fullName); { 显示 imageArr 中 字符串为 fullName 的图片 }
  end;

  aPicture.Free;
  Result := True;
end;

procedure TForm1.OnChangDown(aSpeedBtn: TSpeedButton);
begin
  if not aSpeedBtn.Down then
    aSpeedBtn.GroupIndex := 1;
end;

procedure TForm1.btnTestClick(Sender: TObject);
begin
  if FormClacData.Showing then
    FormClacData.Hide
  else
    FormClacData.show;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // 注册 alt + 1 热键，提取 范围的第一个坐标
  if FindAtom('WThotKey_rangStart') = 0 then
  begin
    wtRangStart := GlobalAddAtom('WThotKey_rangStart');
  end;
  RegisterHotKey(Self.Handle, wtRangStart, MOD_ALT, $31);

  // 注册 alt + 2 热键，提取 范围的 第二个坐标
  if FindAtom('WThotKey_rangEnd') = 0 then
  begin
    wtRangEnd := GlobalAddAtom('WThotKey_rangEnd');
  end;
  RegisterHotKey(Self.Handle, wtRangEnd, MOD_ALT, $32);

  // 注册alt + Q 热键，提取 找到后 点击的坐标
  if FindAtom('WThotKey_click') = 0 then
  begin
    wtClick := GlobalAddAtom('WThotKey_click');
  end;
  RegisterHotKey(Self.Handle, wtClick, MOD_ALT, $51);

  // 注册 小键盘 ← 热键
  if FindAtom('WThotKey_left') = 0 then
  begin
    wtHotKeyLeft := GlobalAddAtom('WThotKey_left');
  end;
  RegisterHotKey(Self.Handle, wtHotKeyLeft, 0, VK_LEFT);
  // 注册 小键盘 ↑ 热键
  if FindAtom('WThotKey_up') = 0 then
  begin
    wtHotKeyUp := GlobalAddAtom('WThotKey_up');
  end;
  RegisterHotKey(Self.Handle, wtHotKeyUp, 0, VK_UP);
  // 注册 小键盘 ↓ 热键
  if FindAtom('WThotKey_down') = 0 then
  begin
    wtHotKeyDown := GlobalAddAtom('WThotKey_down');
  end;
  RegisterHotKey(Self.Handle, wtHotKeyDown, 0, VK_DOWN);
  // 注册 小键盘 → 热键
  if FindAtom('WThotKey_right') = 0 then
  begin
    wtHotKeyRight := GlobalAddAtom('WThotKey_right');
  end;
  RegisterHotKey(Self.Handle, wtHotKeyRight, 0, VK_RIGHT);
  // 注册 1 热键
  if FindAtom('WThotKey_one') = 0 then
  begin
    wtOne := GlobalAddAtom('WThotKey_one');
  end;
  RegisterHotKey(Self.Handle, wtOne, 0, $31);
  // 注册 2 热键
  if FindAtom('WThotKey_two') = 0 then
  begin
    wtTwo := GlobalAddAtom('WThotKey_two');
  end;
  RegisterHotKey(Self.Handle, wtTwo, 0, $31);
  // 注册 3 热键
  if FindAtom('WThotKey_three') = 0 then
  begin
    wtThree := GlobalAddAtom('WThotKey_three');
  end;
  RegisterHotKey(Self.Handle, wtThree, 0, $31);
  // 注册 4 热键
  if FindAtom('WThotKey_four') = 0 then
  begin
    wtFour := GlobalAddAtom('WThotKey_four');
  end;
  RegisterHotKey(Self.Handle, wtFour, 0, $31);
  // 注册 5 热键
  if FindAtom('WThotKey_five') = 0 then
  begin
    wtFive := GlobalAddAtom('WThotKey_five');
  end;
  RegisterHotKey(Self.Handle, wtFive, 0, $31);
  // 注册 6 热键
  if FindAtom('WThotKey_six') = 0 then
  begin
    wtSix := GlobalAddAtom('WThotKey_six');
  end;
  RegisterHotKey(Self.Handle, wtSix, 0, $31);
  // 注册 7 热键
  if FindAtom('WThotKey_seven') = 0 then
  begin
    wtSeven := GlobalAddAtom('WThotKey_seven');
  end;
  RegisterHotKey(Self.Handle, wtSeven, 0, $31);
  // 注册 8 热键
  if FindAtom('WThotKey_eight') = 0 then
  begin
    wtEight := GlobalAddAtom('WThotKey_eight');
  end;
  RegisterHotKey(Self.Handle, wtEight, 0, $31);
  // 注册 9 热键
  if FindAtom('WThotKey_nine') = 0 then
  begin
    wtNine := GlobalAddAtom('WThotKey_nine');
  end;
  RegisterHotKey(Self.Handle, wtNine, 0, $31);
  // 注册 0 热键
  if FindAtom('WThotKey_zero') = 0 then
  begin
    wtZero := GlobalAddAtom('WThotKey_zero');
  end;
  RegisterHotKey(Self.Handle, wtZero, 0, $31);

  Self.setImageShowRect;
  InitImageArr(g_ImageArr);

  g_ImgShowLarge := nil; // 放大镜显示的图片
  g_moveSign := False; { mouse 移动的标志 }
  g_moveX := -1;
  g_moveY := -1; { mouse 移动到的坐标 }

  // toolBarImageList.GetBitmap(1,btnOpen.ImageIndex)    ;

end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  index: Integer;
begin
  UnRegisterHotKey(Self.Handle, wtClick); // 释放热键
  GlobalDeleteAtom(wtClick);

  UnRegisterHotKey(Self.Handle, wtRangStart); // 释放热键
  GlobalDeleteAtom(wtRangStart);

  UnRegisterHotKey(Self.Handle, wtRangEnd); // 释放热键
  GlobalDeleteAtom(wtRangEnd);


  UnregisterHotKey(Self.Handle,wtHotKeyRight);
  GlobalDeleteAtom(wtHotKeyRight)             ;

  UnregisterHotKey(Self.Handle,wtHotKeyLeft);
  GlobalDeleteAtom(wtHotKeyLeft);

  UnregisterHotKey(Self.Handle,wtHotKeyUp);
  GlobalDeleteAtom(wtHotKeyUp);

  UnregisterHotKey(Self.Handle,wtHotKeyDown);
  GlobalDeleteAtom(wtHotKeyDown);








  // FreeAndNil  g_ImageArra数组中的所有对象
  for index := 0 to Length(g_ImageArr) - 1 do
  begin
    FreeAndNil(g_ImageArr[index].closeBtn);
    FreeAndNil(g_ImageArr[index].checkBtn);
    FreeAndNil(g_ImageArr[index].aPicture);
  end;
end;

procedure TForm1.hotkey(var msg: TMessage);
var
  P: TPoint;
  X, Y, frame, Caption: Integer;
begin
  GetCursorPos(P);
  // left 和 top 有一个小于0 直接退出
  if (Self.Left < 0) or (Self.Top < 0) then
    Exit;

  frame := (Width - ClientWidth) div 2;
  Caption := Height - ClientHeight - frame * 2;
  frame := GetSystemMetrics(SM_CXFRAME);
  Caption := GetSystemMetrics(SM_CYCAPTION);
  X := P.X - Self.Left - frame - Self.imgShow.Left + 1;
  Y := P.Y - Self.Top - Caption - frame - Self.imgShow.Top + 2 -
    lableOfPicNameHeight;

  if TWMHotKey(msg).hotkey = wtClick then
  begin
    // click 的热键
    // imgFirst.Canvas.Pixels(x,y);
    FormClacData.edt_clickx.Text := IntToStr(X);
    FormClacData.edt_clicky.Text := IntToStr(Y);
  end
  else if TWMHotKey(msg).hotkey = wtRangStart then
  begin
    // 起始坐标的 热键
    FormClacData.edt_x1.Text := IntToStr(X);
    FormClacData.edt_y1.Text := IntToStr(Y);
  end
  else if TWMHotKey(msg).hotkey = wtRangEnd then
  begin
    // 结束坐标的 热键
    FormClacData.edt_x2.Text := IntToStr(X);
    FormClacData.edt_y2.Text := IntToStr(Y);
  end;

end;

procedure TForm1.imgFirstMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  // 显示 坐标 和颜色到任务栏
end;

procedure TForm1.imgShowMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if g_ImgShowLarge <> nil then
    Exit;
  if SetLargeForm.Showing then
  begin

    g_moveX := X;
    g_moveY := Y;

    PostMessage(SetLargeForm.Handle, WM_USER + $201, g_moveX, g_moveY);

  end;
  pnlShowData.Caption := '坐标(' + IntToStr(X) + ',' + IntToStr(Y) + ')';
end;

procedure TForm1.mMenuFileOpenClick(Sender: TObject);
begin
  Self.OpenAPicByOpenDlg; // 加载一张图片到 imageArr中 然后 置 显示的 为当前图片
  Self.CalcBtnRang(); // 计算每个speedBtn的 range 然后置他们到指定位置
end;

procedure TForm1.NCalcDataClick(Sender: TObject);
begin
  Self.NCalcData.checked := not Self.NCalcData.checked;
  if Self.NCalcData.checked then
    FormClacData.show
  else
    FormClacData.Hide;

end;

procedure TForm1.NSetLargeClick(Sender: TObject);
begin
  NSetLarge.checked := not NSetLarge.checked;
  if NSetLarge.checked then
  begin
    SetLargeForm.show;
  end
  else
  begin
    SetLargeForm.Hide;
  end;

end;

end.
