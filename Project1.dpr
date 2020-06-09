program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {FormMain} ,
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'GenQrCode';
  TStyleManager.TrySetStyle('Jet');
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;

end.
