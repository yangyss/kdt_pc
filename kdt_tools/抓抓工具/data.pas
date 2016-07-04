unit data;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Menus,
  Vcl.ComCtrls;

type
  TFormClacData = class(TForm)
    lbl1: TLabel;
    lbl2: TLabel;
    edt_x1: TEdit;
    lbl3: TLabel;
    edt_y1: TEdit;
    lbl4: TLabel;
    lbl5: TLabel;
    edt_x2: TEdit;
    edt_y2: TEdit;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    edt_clickx: TEdit;
    edt_clicky: TEdit;
    cbbSelet: TComboBox;
    lbl9: TLabel;
    edt_color: TEdit;
    redt_table: TRichEdit;
    lbl10: TLabel;
    edt_offersetColor: TEdit;
    btnClear: TButton;
    procedure cbbSeletChange(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  private
    { Private declarations }
    function getTableString: string;
  public
    { Public declarations }
  end;

var
  FormClacData: TFormClacData;
  g_strTable, g_colorTable: string;

implementation

{$R *.dfm}

function TFormClacData.getTableString: string;
var
  clickx, clicky, x1, y1, x2, y2: Integer;
  colorStr, offersetColor: string;
begin
  Result := '';
  if edt_x1.Text = '' then
    x1 := -1
  else
    x1 := StrToInt(edt_x1.Text);
  if edt_y1.Text = '' then
    y1 := -1
  else
    y1 := StrToInt(edt_y1.Text);
  if edt_x2.Text = '' then
    x2 := -1
  else
    x2 := StrToInt(edt_x2.Text);

  if edt_y2.Text = '' then
    y2 := -1
  else
    y2 := StrToInt(edt_y2.Text);

  if edt_clickx.Text = '' then
    clickx := -1
  else
    clickx := StrToInt(edt_clickx.Text);

  if edt_clicky.Text = '' then
    clicky := -1
  else
    clicky := StrToInt(edt_clicky.Text);

  colorStr := edt_color.Text;
  offersetColor := edt_offersetColor.Text;
  g_strTable := '{str = ''' + ''',' + 'x=' + inttostr(clickx) + ',y=' + inttostr
    (clicky) + ',x1=' + inttostr(x1) + ',y1=' + inttostr(y1) + ',x2=' + inttostr
    (x2) + ',y2=' + inttostr(y2) + ',cColor=''' + colorStr + ''',' +
    'cSim =0.9,cDir = 1' + '},';
  {str = '副本里',x = -1 ,y = -1 ,dDis =10,x1 =1023,y1 = 3,x2 = 1120,
  y2 = 54,firstClor = 0xffdb29,
  clor = "-3|-4|0x312421,3|-4|0x292021,0|5|0x946110,3|15|0x211818"}
  g_colorTable := '{str = ''' + ''',' + 'x=' + inttostr(clickx) + ',y=' +
    inttostr(clicky) + ',dDis = 10' + ',x1=' + inttostr(x1) + ',y1=' + inttostr(y1)
    + ',x2=' + inttostr(x2) + ',y2=' + inttostr(y2) + ',firstClor=' + colorStr +
    ',clor=''' + offersetColor + '''},';
end;

procedure TFormClacData.btnClearClick(Sender: TObject);
begin
  edt_x1.Clear;
  edt_y1.Clear;
  edt_x2.Clear;
  edt_y2.Clear;
  edt_clickx.Clear;
  edt_clicky.Clear;
  edt_color.Clear;
  edt_offersetColor.Clear;
  redt_table.Clear;
end;

procedure TFormClacData.cbbSeletChange(Sender: TObject);
begin
  Self.getTableString;
  if cbbSelet.ItemIndex = 0 then
  begin
    //ShowMessage('第一行');
    Self.redt_table.Text := g_strTable;
  end
  else if cbbSelet.ItemIndex = 1 then
  begin
    //ShowMessage('第二行');
    Self.redt_table.Text := g_colorTable;
  end;
end;

end.

