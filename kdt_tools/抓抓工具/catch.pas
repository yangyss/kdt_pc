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
    aPicture: TPicture; // ͼƬ��Ϣ
    fullName: string; // ͼƬ��ȫ����
    showName: string; // ͼƬ����ʾ����
    checked: Boolean; // ͼƬ�Ƿ�ѡ��
    show: Boolean; // û��ͼƬ����ʾ
    showLableBtn: Boolean; // ��ʾ��ǩ
    checkBtn: TSpeedButton; // ����ѡ��ͼƬ��TSpeedButton
    closeBtn: TSpeedButton; // ���ƹر�ͼƬ��TSpeedButton
    checkBtnWidth: Integer; // ����ѡ��ͼƬ��TSpeedButton �� width
    checkBtnLeft: Integer; // ����ѡ��ͼƬ��TSpeedButton �� left
    checkBtnTop: Integer; // ����ѡ��ͼƬ��TSpeedButton �� top
    checkBtnHeight: Integer; // ����ѡ��ͼƬ��TSpeedButton �� height
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
    wtRangStart, wtRangEnd, wtClick: ATOM; { ���ݴ����ڵ� 3 �� hotkey }
    { �Ŵ󾵴��ڵ� 14 �� hotkey }
    wtZero, wtNine, wtEight, wtSeven, wtSix, wtFive, wtFour, wtThree, wtTwo,
      wtOne, wtHotKeyRight, wtHotKeyDown, wtHotKeyUp, wtHotKeyLeft: ATOM;

    wtLeft, wtTop: Integer;
    procedure setImageShowRect();
  public
    { Public declarations }
    procedure CalcBtnRang(); { ������ʾ ͼƬ���Ƶ� ��ǩ�� rang }
    function ShowAImage(aFullName: string): Boolean; { ��ʾһ�� image }
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
  g_ImageArr: array [0 .. 20] of TImageData; { ��ǰ�£����е�imageData }
  g_BtnWidth, g_LastBtnWidth: Integer; { ��ǰ����£���ǩ�Ŀ�� }
  g_ClickBtnDownSign: Boolean; { ��ǰ ����� ��ť�� Down ����ֵ }
  g_ImgShowLarge: TGPImage;
  g_moveSign: Boolean; { mouse �ƶ��ı�־ }
  g_moveX, g_moveY: Integer; { mouse �ƶ��������� }

const
  lableOfPicNameHeight = 20; { ͼƬ��������ʾ���ĸ߶� }
  defaultWidth = 180; { ��ʾͼƬ���Ƶı�ǩ�� Ĭ��width }
  defaultHeight = 20; { ��ʾͼƬ���Ƶı�ǩ�� Ĭ��height }
  defaultTop = 24; { ��ʾͼƬ���Ƶı�ǩ�� Ĭ��Top }
  defaultLeft = 0; { ��ʾͼƬ���Ƶı�ǩ�� Ĭ��Left }

implementation

{$R *.dfm}

function TForm1.ShowAImage(aFullName: string): Boolean; { ��ʾһ�� image }
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
    // û����ͬ���ַ���
    if showIndex = -1 then { û����ʾ�� ͼƬ ���˳� }
      Exit;

    for index := 0 to Length(g_ImageArr) do
    begin
      if index <> showIndex then { �� ��ʾ�� ͼƬ�� ��Ϊ false }
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
    // ����ͬ���ַ���
    for index := 0 to Length(g_ImageArr) do
    begin
      if index <> sameTextIndex then { ����ͬ�ַ��� ͼƬ�� ��Ϊ false }
        g_ImageArr[index].show := False
      else
      begin
        g_ImageArr[index].show := True; { ��ͬ���ַ��� ͼƬ��ʾ ��Ϊtrue }
        g_ImageArr[index].showLableBtn := True;
        Self.SetSpeedBtnDown(g_ImageArr[index].checkBtn);
      end;
    end;

    Self.imgShow.Picture.Assign(g_ImageArr[sameTextIndex].aPicture); { ͼƬ����ʾ֮ }
  end;
  Result := True;
end;

function TForm1.LoadAImage(aPicture: TPicture; aFullName: string): Boolean;
{ ����һ��ͼƬ��arr�� }
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
    { fullNameΪ'',��ʾ ����Ĵ�λ���ǿ��õģ���������ͼƬ }
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

{ aSpeedBtn �� Down ���� ��Ϊtrue }
procedure TForm1.SetSpeedBtnDown(aSpeedBtn: TSpeedButton);
begin
  aSpeedBtn.GroupIndex := 1;
  aSpeedBtn.Down := True;
end;

{ ��д����� speedBtn �ĵ���¼� }
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
    Self.imgShow.Picture.Assign(aPicture); { ��� showImage }
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
  ������������Ϊ 'X' ��speedBtn �ĵ���¼�
  �������ܣ�
  --1�����ض�Ӧ��speedBtns
  --2���л�image
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
      OnClick := OnChangeSpeedBtnDown; // ָ��button click�¼�
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
      OnClick := OnCloseImageData; // ָ��button click�¼�
      Flat := True;
      Parent := Self;
      Caption := 'X';
      Visible := aImageArr[index].showLableBtn;
      ShowHint := True;
      Hint := '';
    end;
  end;
end;

// ���� speedBtn��ʾ�� caption ��������
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
    // ���е� ���ⳤ�� ֮�� ���� �ܵ�width�ĳ��ȣ���������ÿһ����width
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
  // ShowMessage('��һ��ͼƬ');
  Self.OpenAPicByOpenDlg; // ����һ��ͼƬ�� imageArr�� Ȼ�� �� ��ʾ�� Ϊ��ǰͼƬ
  Self.CalcBtnRang(); // ����ÿ��speedBtn�� range Ȼ�������ǵ�ָ��λ��
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

    Self.LoadAImage(aPicture, fullName); { ���� ͼƬ��Ϣ �� imageArr�У�ͬʱ����ʾΪ false }
    Self.ShowAImage(fullName); { ��ʾ imageArr �� �ַ���Ϊ fullName ��ͼƬ }
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
  // ע�� alt + 1 �ȼ�����ȡ ��Χ�ĵ�һ������
  if FindAtom('WThotKey_rangStart') = 0 then
  begin
    wtRangStart := GlobalAddAtom('WThotKey_rangStart');
  end;
  RegisterHotKey(Self.Handle, wtRangStart, MOD_ALT, $31);

  // ע�� alt + 2 �ȼ�����ȡ ��Χ�� �ڶ�������
  if FindAtom('WThotKey_rangEnd') = 0 then
  begin
    wtRangEnd := GlobalAddAtom('WThotKey_rangEnd');
  end;
  RegisterHotKey(Self.Handle, wtRangEnd, MOD_ALT, $32);

  // ע��alt + Q �ȼ�����ȡ �ҵ��� ���������
  if FindAtom('WThotKey_click') = 0 then
  begin
    wtClick := GlobalAddAtom('WThotKey_click');
  end;
  RegisterHotKey(Self.Handle, wtClick, MOD_ALT, $51);

  // ע�� С���� �� �ȼ�
  if FindAtom('WThotKey_left') = 0 then
  begin
    wtHotKeyLeft := GlobalAddAtom('WThotKey_left');
  end;
  RegisterHotKey(Self.Handle, wtHotKeyLeft, 0, VK_LEFT);
  // ע�� С���� �� �ȼ�
  if FindAtom('WThotKey_up') = 0 then
  begin
    wtHotKeyUp := GlobalAddAtom('WThotKey_up');
  end;
  RegisterHotKey(Self.Handle, wtHotKeyUp, 0, VK_UP);
  // ע�� С���� �� �ȼ�
  if FindAtom('WThotKey_down') = 0 then
  begin
    wtHotKeyDown := GlobalAddAtom('WThotKey_down');
  end;
  RegisterHotKey(Self.Handle, wtHotKeyDown, 0, VK_DOWN);
  // ע�� С���� �� �ȼ�
  if FindAtom('WThotKey_right') = 0 then
  begin
    wtHotKeyRight := GlobalAddAtom('WThotKey_right');
  end;
  RegisterHotKey(Self.Handle, wtHotKeyRight, 0, VK_RIGHT);
  // ע�� 1 �ȼ�
  if FindAtom('WThotKey_one') = 0 then
  begin
    wtOne := GlobalAddAtom('WThotKey_one');
  end;
  RegisterHotKey(Self.Handle, wtOne, 0, $31);
  // ע�� 2 �ȼ�
  if FindAtom('WThotKey_two') = 0 then
  begin
    wtTwo := GlobalAddAtom('WThotKey_two');
  end;
  RegisterHotKey(Self.Handle, wtTwo, 0, $31);
  // ע�� 3 �ȼ�
  if FindAtom('WThotKey_three') = 0 then
  begin
    wtThree := GlobalAddAtom('WThotKey_three');
  end;
  RegisterHotKey(Self.Handle, wtThree, 0, $31);
  // ע�� 4 �ȼ�
  if FindAtom('WThotKey_four') = 0 then
  begin
    wtFour := GlobalAddAtom('WThotKey_four');
  end;
  RegisterHotKey(Self.Handle, wtFour, 0, $31);
  // ע�� 5 �ȼ�
  if FindAtom('WThotKey_five') = 0 then
  begin
    wtFive := GlobalAddAtom('WThotKey_five');
  end;
  RegisterHotKey(Self.Handle, wtFive, 0, $31);
  // ע�� 6 �ȼ�
  if FindAtom('WThotKey_six') = 0 then
  begin
    wtSix := GlobalAddAtom('WThotKey_six');
  end;
  RegisterHotKey(Self.Handle, wtSix, 0, $31);
  // ע�� 7 �ȼ�
  if FindAtom('WThotKey_seven') = 0 then
  begin
    wtSeven := GlobalAddAtom('WThotKey_seven');
  end;
  RegisterHotKey(Self.Handle, wtSeven, 0, $31);
  // ע�� 8 �ȼ�
  if FindAtom('WThotKey_eight') = 0 then
  begin
    wtEight := GlobalAddAtom('WThotKey_eight');
  end;
  RegisterHotKey(Self.Handle, wtEight, 0, $31);
  // ע�� 9 �ȼ�
  if FindAtom('WThotKey_nine') = 0 then
  begin
    wtNine := GlobalAddAtom('WThotKey_nine');
  end;
  RegisterHotKey(Self.Handle, wtNine, 0, $31);
  // ע�� 0 �ȼ�
  if FindAtom('WThotKey_zero') = 0 then
  begin
    wtZero := GlobalAddAtom('WThotKey_zero');
  end;
  RegisterHotKey(Self.Handle, wtZero, 0, $31);

  Self.setImageShowRect;
  InitImageArr(g_ImageArr);

  g_ImgShowLarge := nil; // �Ŵ���ʾ��ͼƬ
  g_moveSign := False; { mouse �ƶ��ı�־ }
  g_moveX := -1;
  g_moveY := -1; { mouse �ƶ��������� }

  // toolBarImageList.GetBitmap(1,btnOpen.ImageIndex)    ;

end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  index: Integer;
begin
  UnRegisterHotKey(Self.Handle, wtClick); // �ͷ��ȼ�
  GlobalDeleteAtom(wtClick);

  UnRegisterHotKey(Self.Handle, wtRangStart); // �ͷ��ȼ�
  GlobalDeleteAtom(wtRangStart);

  UnRegisterHotKey(Self.Handle, wtRangEnd); // �ͷ��ȼ�
  GlobalDeleteAtom(wtRangEnd);


  UnregisterHotKey(Self.Handle,wtHotKeyRight);
  GlobalDeleteAtom(wtHotKeyRight)             ;

  UnregisterHotKey(Self.Handle,wtHotKeyLeft);
  GlobalDeleteAtom(wtHotKeyLeft);

  UnregisterHotKey(Self.Handle,wtHotKeyUp);
  GlobalDeleteAtom(wtHotKeyUp);

  UnregisterHotKey(Self.Handle,wtHotKeyDown);
  GlobalDeleteAtom(wtHotKeyDown);








  // FreeAndNil  g_ImageArra�����е����ж���
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
  // left �� top ��һ��С��0 ֱ���˳�
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
    // click ���ȼ�
    // imgFirst.Canvas.Pixels(x,y);
    FormClacData.edt_clickx.Text := IntToStr(X);
    FormClacData.edt_clicky.Text := IntToStr(Y);
  end
  else if TWMHotKey(msg).hotkey = wtRangStart then
  begin
    // ��ʼ����� �ȼ�
    FormClacData.edt_x1.Text := IntToStr(X);
    FormClacData.edt_y1.Text := IntToStr(Y);
  end
  else if TWMHotKey(msg).hotkey = wtRangEnd then
  begin
    // ��������� �ȼ�
    FormClacData.edt_x2.Text := IntToStr(X);
    FormClacData.edt_y2.Text := IntToStr(Y);
  end;

end;

procedure TForm1.imgFirstMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  // ��ʾ ���� ����ɫ��������
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
  pnlShowData.Caption := '����(' + IntToStr(X) + ',' + IntToStr(Y) + ')';
end;

procedure TForm1.mMenuFileOpenClick(Sender: TObject);
begin
  Self.OpenAPicByOpenDlg; // ����һ��ͼƬ�� imageArr�� Ȼ�� �� ��ʾ�� Ϊ��ǰͼƬ
  Self.CalcBtnRang(); // ����ÿ��speedBtn�� range Ȼ�������ǵ�ָ��λ��
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
