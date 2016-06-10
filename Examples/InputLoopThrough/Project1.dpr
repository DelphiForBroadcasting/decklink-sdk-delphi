program Project1;

uses
  Vcl.Forms,
  DeckLinkAPI_TLB_9_8 in '../../DeckLinkAPI_TLB_9_8.pas',
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
