program Project1;

uses
  Vcl.Forms,
  DeckLinkAPI_TLB_10_6_6 in '../../Include/DeckLinkAPI_TLB_10_6_6.pas',
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
