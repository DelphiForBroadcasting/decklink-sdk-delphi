program Project1;

uses
  Vcl.Forms,
  DeckLinkAPI.Types in '../../Include/DeckLinkAPI.Types.pas',
  DeckLinkAPI.Modes in '../../Include/DeckLinkAPI.Modes.pas',
  DeckLinkAPI.Discovery in '../../Include/DeckLinkAPI.Discovery.pas',
  DeckLinkAPI.Configuration in '../../Include/DeckLinkAPI.Configuration.pas',
  DeckLinkAPI.DeckControl in '../../Include/DeckLinkAPI.DeckControl.pas',
  DeckLinkAPI.Streaming in '../../Include/DeckLinkAPI.Streaming.pas',
  DeckLinkAPI in '../../Include/DeckLinkAPI.pas',
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
