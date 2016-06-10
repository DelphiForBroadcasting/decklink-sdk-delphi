unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, activex, directshow9, DeckLinkAPI_TLB_9_8,
  Vcl.StdCtrls, math;


 type
   TVideoFormat = class
   private
     fName: string;
     fvideoDisplayMode          : IDeckLinkdisplayMode;
   public
     property Name : string read fName;
     property videoDisplayMode : IDeckLinkdisplayMode read fvideoDisplayMode;
     constructor Create(const name : string; const videoDisplayMode : IDeckLinkdisplayMode) ;
   end;

type
  _OutputSignal = TOleEnum;
const
  kOutputSignalPip = $00000000;
  kOutputSignalDrop = $00000001;

type
  TForm1 = class(TForm, IDeckLinkVideoOutputCallback, IDeckLinkAudioOutputCallback)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    m_videoFormatCombo: TComboBox;
    m_outputSignalCombo: TComboBox;
    m_audioChannelCombo: TComboBox;
    m_audioSampleDepthCombo: TComboBox;
    m_startButton: TButton;
    procedure FormCreate(Sender: TObject);
    Procedure WriteNextAudioSamples();
    Procedure ScheduleNextFrame(prerolling : boolean);
    Procedure StartRunning();
    Procedure StopRunning();
    procedure EnableInterface(enable : boolean);
    procedure m_startButtonClick(Sender: TObject);
    function RenderAudioSamples(preroll: Integer): HResult; stdcall;
    function ScheduledFrameCompleted(const completedFrame: IDeckLinkVideoFrame; results: _BMDOutputFrameCompletionResult): HResult; stdcall;
    function ScheduledPlaybackHasStopped: HResult; stdcall;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  kAudioWaterlevel = 48000;

var
  Form1                         : TForm1;
  m_videoFrameBars              : IDeckLinkMutableVideoFrame = nil;
  m_videoFrameBlack             : IDeckLinkMutableVideoFrame = nil;
  hr                            : HRESULT;
  m_deckLinkOutput              : IDeckLinkOutput = nil;
  m_audioBuffer                 : Pointer;
  m_audioSamplesPerFrame        : cardinal;
  m_audioSamplesLength          : cardinal;
  m_totalAudioSecondsScheduled  : int64;
  m_audioBufferSampleLength     : int64;
  m_audioSampleRate             : word;
  m_running                     : boolean;
  m_totalFramesScheduled        : Int64;
  m_framesPerSecond             : Int64;
  m_frameDuration               : Int64;
  m_frameTimescale              : Int64;
  m_audioChannelCount           : integer;
  m_audioSampleDepth            : _BMDAudioSampleType;
  m_outputSignal                : _OutputSignal;
implementation

{$R *.dfm}

constructor TVideoFormat.Create(const name : string; const videoDisplayMode : IDeckLinkdisplayMode) ;
begin
   fName := name;
   fvideoDisplayMode := videoDisplayMode;
end;

function TForm1.RenderAudioSamples(preroll: Integer): HResult;
begin
  WriteNextAudiosamples;
  if preroll=1 then
    m_deckLinkOutput.StartScheduledPlayback(0,100,1.0);
  result:=S_OK;
end;

function TForm1.ScheduledPlaybackHasStopped: HResult;
begin
  result:=S_OK;
end;

function TForm1.ScheduledFrameCompleted(const completedFrame: IDeckLinkVideoFrame; results: _BMDOutputFrameCompletionResult): HResult;
begin
  ScheduleNextFrame(false);
  result:=S_OK;
end;

Procedure FillSine(audioBuffer: Pointer; sampleToWrite: longint; channels : integer; samleDepth : integer);
var
  nextBufer : PSmallInt;
  sample16    : SmallInt;
  sample32    : integer;
  i, ch       : longint;
begin

  case samleDepth of
    16 :
      begin
        for i:=0 to sampleToWrite-1 do
        begin
          sample16:=Round(24576.0 * sin((i*2.0*PI) / 48.0));
          for ch := 0 to channels-1 do
          begin
            PSmallInt(audioBuffer)^:=sample16;
            inc(PSmallInt(audioBuffer),1);
          end;
        end;
      end;
    32 :
      begin
        for i:=0 to sampleToWrite-1 do
        begin
          sample32:=Round(1610612736.0 * sin((i*2.0*PI) / 48.0));
          for ch := 0 to channels-1 do
          begin
            PInteger(audioBuffer)^:=sample32;
            inc(PInteger(audioBuffer),1);
          end;
        end;
      end;
  end;
end;


Procedure FillBlack(theFrame : IDeckLinkVideoFrame);
var
  nextword        : Pointer;
  width           : integer;
  height          : integer;
  wordsRemaining  : int64;
  x,y             : integer;
  bytes           : PByte;
begin
  theframe.GetBytes(nextword);
  width:= theframe.GetWidth;
  height:= theframe.GetHeight;
  wordsRemaining:= (width*2 * height) div 4;

  for x:=0 to width -1 do
    for y := 0 to height-1 do
    begin
      pByte(nextword)^:=$00;  inc(pByte(nextword),1);
      pByte(nextword)^:=$00;  inc(pByte(nextword),1);
      pByte(nextword)^:=$00;  inc(pByte(nextword),1);
      pByte(nextword)^:=$00;  inc(pByte(nextword),1);
    end;
end;


Procedure FillColourBars(theFrame : IDeckLinkVideoFrame);
const
 gSD75pcColourBars : array[0..7] of cardinal	= ($ffffffff, $ffffff00, $ff00ffff, $ff00ff00, $ffff00ff, $ffff0000, $ff0000ff, $ff000000);
 gHD75pcColourBars : array[0..7] of cardinal	= ($eb80eb80, $a888a82c, $912c9193, $8534853f, $3fcc3fc1, $33d4336d, $1c781cd4, $10801080);

function DarkerColor(const Color: cardinal; Percent: Integer): cardinal;
var
 A, R, G, B: Byte;
begin
  Result := Color;
  if Percent <= 0 then
    Exit;
  if Percent > 100 then
    Percent := 100;
  A := color;
  R := color shr 8;
  G := color shr 16;
  B := color shr 14;
  R := R - R * Percent div 100;
  G := G - G * Percent div 100;
  B := B - B * Percent div 100;
  result:=(a or (r shl 8) or (g shl 16) or (b shl 24));
end;

function LighterColor(const Color: cardinal; Percent: Integer): cardinal;
var
  A, R, G, B: Byte;
begin
  Result := Color;
  if Percent <= 0 then
    Exit;
  if Percent > 100 then
    Percent := 100;
  A := color;
  R := color shr 8;
  G := color shr 16;
  B := color shr 14;
  R := R + (255 - R) * Percent div 100;
  G := G + (255 - G) * Percent div 100;
  B := B + (255 - B) * Percent div 100;
    result:=(a or (r shl 8) or (g shl 16) or (b shl 24));
end;

var
  nextword        : Pointer;
  width           : integer;
  height          : integer;
  x,y             : integer;
begin
  theframe.GetBytes(nextword);
  width:= theframe.GetWidth;
  height:= theframe.GetHeight;
  for y := 0 to height-1 do
    for x:=0 to width-1 do
    begin
      pCardinal(nextword)^:=DarkerColor(gSD75pcColourBars[(x*8) div width],25);  inc(pCardinal(nextword),1);
    end;
end;


Procedure TForm1.WriteNextAudioSamples();
var
  sampleFramesWritten : cardinal;
  bufferedSamples : cardinal;
begin
  m_deckLinkOutput.GetBufferedAudioSampleFrameCount(bufferedSamples);  //
  if (bufferedSamples > kAudioWaterlevel) then  exit;                  //

  if m_outputSignal=kOutputSignalPip then
  begin
    hr:=m_decklinkOutput.ScheduleAudioSamples(m_audioBuffer, m_audioSamplesPerFrame, (m_totalAudioSecondsScheduled * m_audioBufferSampleLength), m_audioSampleRate, sampleFramesWritten);
    if FAILED(hr) then begin
      showmessage(format('Could not obtain the IDeckLinkOutput.ScheduleAudioSamples interface.'+#10#13+'result = %08x.', [hr]));
      exit;
    end;
  end else
  begin
    hr:=m_decklinkOutput.ScheduleAudioSamples(m_audioBuffer, (m_audioSamplesLength - m_audioSamplesPerFrame), (m_totalAudioSecondsScheduled * m_audioBufferSampleLength) + m_audioSamplesPerFrame, m_audioSampleRate, sampleFramesWritten);
    if FAILED(hr) then begin
      showmessage(format('Could not obtain the IDeckLinkOutput.ScheduleAudioSamples interface.'+#10#13+'result = %08x.', [hr]));
      exit;
    end;
  end;
  m_totalAudioSecondsScheduled:=m_totalAudioSecondsScheduled+1;
end;

Procedure TForm1.ScheduleNextFrame(prerolling : boolean);
begin
  if not prerolling then
    if not m_running then exit;
  if m_outputSignal=kOutputSignalPip then
  begin
    if (m_totalFramesScheduled mod m_framesPerSecond)=0 then
    begin
      hr:=m_deckLinkOutput.ScheduleVideoFrame(m_videoFrameBars, (m_totalFramesScheduled * m_frameDuration), m_frameDuration, m_frameTimescale);
      if FAILED(hr) then exit;
    end else
    begin
      if FAILED(m_deckLinkOutput.ScheduleVideoFrame(m_videoFrameBlack, (m_totalFramesScheduled * m_frameDuration), m_frameDuration, m_frameTimescale)) then exit;
    end;
  end else
  begin
    if (m_totalFramesScheduled mod m_framesPerSecond)=0 then
    begin
      if FAILED(m_deckLinkOutput.ScheduleVideoFrame(m_videoFrameBlack, (m_totalFramesScheduled * m_frameDuration), m_frameDuration, m_frameTimescale)) then exit;
    end else
    begin
      hr:=m_deckLinkOutput.ScheduleVideoFrame(m_videoFrameBars, (m_totalFramesScheduled * m_frameDuration), m_frameDuration, m_frameTimescale);
      if FAILED(hr) then exit;
    end;
  end;
  m_totalFramesScheduled:=m_totalFramesScheduled+1;
end;


Procedure TForm1.StopRunning();
var
  actualStopTime: Int64;
begin
  m_deckLinkOutput.StopScheduledPlayback(0,actualStopTime,0);
  m_deckLinkOutput.DisableAudioOutput;
  m_deckLinkOutput.DisableVideoOutput;
  if assigned(m_videoFrameBlack) then m_videoFrameBlack:=nil;
  if assigned(m_videoFrameBars) then m_videoFrameBars:=nil;
  if assigned(m_audioBuffer) then HeapFree(GetProcessHeap,0,m_audioBuffer);
  m_running:=false;
  m_startButton.Caption:='Start';
  EnableInterface(true);

end;

Procedure TForm1.StartRunning();
label
  bail;
var
  videoDisplayMode          : IDeckLinkdisplayMode;
  DisplayModeIterator       : IDeckLinkDisplayModeIterator;
  m_frameWidth              : integer;
  m_frameHeight             : integer;
  i                         : integer;
  modeNameBSTR              : WideString;
  VideoFormat               : TVideoFormat;
begin
  videoDisplayMode := nil;
  DisplayModeIterator := nil;
  m_outputSignal := _OutputSignal(m_outputSignalCombo.ItemIndex);
  m_audioChannelCount:= strtoint(m_audioChannelCombo.Items.Strings[m_audioChannelCombo.ItemIndex]);
  m_audioSampleDepth := _BMDAudioSampleType(strtoint(m_audioSampleDepthCombo.Items.strings[m_audioSampleDepthCombo.ItemIndex]));
  m_audioSampleRate := bmdAudioSampleRate48kHz;
  try
    VideoFormat := m_videoFormatCombo.Items.Objects[m_videoFormatCombo.ItemIndex] as TVideoFormat;
    videodisplayMode:=VideoFormat.videoDisplayMode;
  except
    showmessage(format('Could not obtain the TVideoFormat interface.'+#10#13+'result = ', []));
    StopRunning;
    exit;
  end;

  m_frameWidth:= videoDisplayMode.GetWidth;
  m_frameHeight:= videoDisplayMode.GetHeight;
  videoDisplayMode.GetFrameRate(m_frameDuration, m_frameTimeScale);
  m_framesPerSecond := (m_frameTimeScale + (m_frameDuration-1)) div m_frameDuration;

  hr:=m_decklinkOutput.EnableVideoOutput(videoDisplayMode.GetDisplayMode, bmdVideoOutputFlagDefault);
  if FAILED(hr) then begin
    showmessage(format('Could not obtain the IDeckLinkOutput.EnableVideoOutput interface.'+#10#13+'result = %08x.', [hr]));
    goto bail;
  end;

  hr:=m_decklinkOutput.EnableAudioOutput(m_audioSampleRate ,m_audioSampleDepth,m_audioChannelCount,bmdAudioOutputStreamTimestamped);
  if FAILED(hr) then begin
    showmessage(format('Could not obtain the IDeckLinkOutput.EnableAudioOutput interface.'+#10#13+'result = %08x.', [hr]));
    goto bail;
  end;

  m_audioSamplesPerFrame:=(m_audioSampleRate * m_frameDuration) div m_frameTimescale;
  m_audioBufferSampleLength:= (m_framesPerSecond * m_audioSampleRate * m_frameDuration) div m_frameTimescale;
  m_audioBuffer := HeapAlloc(GetProcessHeap(),0, (m_audioBufferSampleLength * m_audioChannelCount * (m_audioSampleDepth div 8)));
  if not assigned(m_audioBuffer) then
    goto bail;;

  FillSine(m_audioBuffer, m_audioBufferSampleLength, m_audioChannelCount, m_audioSampleDepth);

  hr:=m_decklinkOutput.CreateVideoFrame(m_frameWidth, m_frameHeight, m_frameWidth*4, bmdFormat8bitBGRA, bmdFrameFlagFlipVertical, m_videoFrameBlack);
  if FAILED(hr) then begin
    showmessage(format('Could not obtain the IDeckLinkOutput.CreateVideoFrame interface.'+#10#13+'result = %08x.', [hr]));
    goto bail;
  end;
  FillBlack(m_videoFrameBlack);

  hr:=m_decklinkOutput.CreateVideoFrame(m_frameWidth, m_frameHeight, m_frameWidth*4, bmdFormat8bitBGRA, bmdFrameFlagDefault, m_videoFrameBars);
  if FAILED(hr) then begin
    showmessage(format('Could not obtain the IDeckLinkOutput.CreateVideoFrame interface.'+#10#13+'result = %08x.', [hr]));
    goto bail;
  end;
  FillColourBars(m_videoFrameBars);

  m_totalFramesScheduled :=1;
  for I := 0 to m_framesPerSecond-1 do
    ScheduleNextFrame(true);

  m_totalAudioSecondsScheduled :=0;
  hr:=m_deckLinkOutput.BeginAudioPreroll;
  if FAILED(hr) then begin
    showmessage(format('Could not obtain the IDeckLinkOutput.BeginAudioPreroll interface.'+#10#13+'result = %08x.', [hr]));
    goto bail;
    end;

    m_running := true;
    m_startButton.Caption:='Stop';
    enableInterface(false);
    exit;

    bail :
    begin
      StopRunning;
    end;

end;


procedure TForm1.m_startButtonClick(Sender: TObject);
begin
  if m_running then StopRunning else StartRunning;
end;

procedure TForm1.EnableInterface(enable : boolean);
begin
  m_outputSignalCombo.Enabled:=enable;
  m_audioChannelCombo.Enabled:=enable;
  m_audioSampleDepthCombo.Enabled:=enable;
  m_videoFormatCombo.Enabled:=enable;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
CoUnInitialize;
end;

procedure TForm1.FormCreate(Sender: TObject);
label
  bail;
var
  modeName                    : WideString;
  newindex                    : integer;
  DisplayModeIterator         : IDeckLinkDisplayModeIterator;
  DeckLinkdisplayMode         : IDeckLinkdisplayMode;
  m_DeckLink                  : IDeckLink;
  DeckLinkIterator            : IDeckLinkIterator;
  success                     : boolean;
begin
  m_DeckLink:=nil;
  DeckLinkdisplayMode:=nil;
  DisplayModeIterator:=nil;
  DeckLinkIterator:=nil;
  success:=false;
  CoInitialize(nil);
  hr := CoCreateInstance(CLASS_CDeckLinkIterator, nil, CLSCTX_ALL, IID_IDeckLinkIterator,  DeckLinkIterator);
  if FAILED(hr) then begin
    showmessage(format('This application requires the DeckLink drivers installed.'+#10#13+'Please install the Blackmagic DeckLink drivers to use the features of this application.'+#10#13+'result = %08x.', [hr]));
    goto bail;
  end;

  hr:=deckLinkIterator.Next(m_deckLink);
  if FAILED(hr) then begin
    showmessage(format('This application requires a DeckLink PCI card.'+#10#13+'You will not be able to use the features of this application until a DeckLink PCI card is installed.'+#10#13+'result = %08x.', [hr]));
    goto bail;
  end;

  hr:=m_DeckLink.QueryInterface(IID_IDeckLinkOutput, m_deckLinkOutput);
  if FAILED(hr) then begin
    showmessage(format('Could not obtain the IDeckLinkOutput interface.'+#10#13+'result = %08x.', [hr]));
    goto bail;
  end;

  m_deckLinkOutput.SetScheduledFrameCompletionCallback(Form1);
  m_deckLinkOutput.SetAudioCallback(Form1);

  m_videoFormatCombo.Clear;
  hr:=m_deckLinkOutput.GetDisplayModeIterator(DisplayModeIterator);
  if FAILED(hr) then begin
    showmessage(format('Could not obtain the IDeckLinkOutput.GetDisplayModeIterator interface.'+#10#13+'result = %08x.', [hr]));
    goto bail;
  end;

  while (DisplayModeIterator.Next(DeckLinkdisplayMode) = S_OK)  do
  begin
    if Succeeded(DeckLinkdisplayMode.GetName(modeName)) then
      m_videoFormatCombo.AddItem(modeName, TVideoFormat.Create(modeName, DeckLinkdisplayMode)) ;
  end;

  if m_videoFormatCombo.Items.Count>0 then m_videoFormatCombo.ItemIndex:=0;

  DisplayModeIterator:=nil;
  success:=true;

  bail:
    begin
      if not success then
      begin
        if assigned(m_deckLinkOutput) then m_deckLinkOutput:=nil;
        if assigned(m_deckLink) then  m_deckLink:=nil;
        m_startButton.Enabled:=false;
        EnableInterface(false);
      end;
      if assigned(deckLinkIterator) then   deckLinkIterator:=nil;
    end;
end;

end.
