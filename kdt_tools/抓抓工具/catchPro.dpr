program catchPro;

uses
  Vcl.Forms,
  catch in 'catch.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles,
  data in 'data.pas' {FormClacData},
  setLarge in 'setLarge.pas' {SetLargeForm},
  transfer in 'transfer.pas' {tranForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Sky');
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormClacData, FormClacData);
  Application.CreateForm(TSetLargeForm, SetLargeForm);
  Application.CreateForm(TtranForm, tranForm);
  Application.Run;
end.
