program Project1;

uses
  Vcl.Forms,
  DeckLinkAPI_TLB_10_4_1 in '../../DeckLinkAPI_TLB_10_4_1.pas',
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
