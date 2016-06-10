unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Winapi.ActiveX, Winapi.DirectShow9,
  DeckLinkAPI_TLB_10_6_6, SignalGenerator3DVideoFrame;

type
  _OutputSignal = TOleEnum;

const
  kOutputSignalPip = $00000000;
  kOutputSignalDrop = $00000001;

const
  kAudioWaterlevel = 48000;

const
  // SD 75% Colour Bars
  gSD75pcColourBars : array[0..7] of cardinal	= ($eb80eb80, $a28ea22c, $832c839c, $703a7048, $54c654b8, $41d44164, $237223d4, $10801080);

const
  // HD 75% Colour Bars
  gHD75pcColourBars : array[0..7] of cardinal	= ($eb80eb80, $a888a82c, $912c9193, $8534853f, $3fcc3fc1, $33d4336d, $1c781cd4, $10801080);



 type
   TDeckLinkdisplayModeObject = class
   private
     fName: string;
     fvideoDisplayMode          : IDeckLinkdisplayMode;
   public
     property Name : string read fName;
     property videoDisplayMode : IDeckLinkdisplayMode read fvideoDisplayMode;
     constructor Create(const name : string; const videoDisplayMode : IDeckLinkdisplayMode) ;
   end;

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
    m_pixelFormatCombo: TComboBox;
    Label5: TLabel;
    procedure RefreshDisplayModeMenu();
    procedure FormCreate(Sender: TObject);
    procedure EnableInterface(enable : boolean);
    procedure m_startButtonClick(Sender: TObject);
    function GetBytesPerPixel(const pixelFormat: _BMDPixelFormat): integer;
    Procedure StartRunning();
    Procedure StopRunning();
    Procedure ScheduleNextFrame(prerolling : boolean);
    Procedure WriteNextAudioSamples();
    function CreateBlackFrame(): TSignalGenerator3DVideoFrame;
    function CreateBarsFrame(): TSignalGenerator3DVideoFrame;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  protected
    function QueryInterface1(const IID: TGUID; out Obj): HRESULT; stdcall;
    function IDeckLinkVideoOutputCallback.QueryInterface = QueryInterface1;
    function IDeckLinkAudioOutputCallback.QueryInterface = QueryInterface1;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function RenderAudioSamples(preroll: Integer): HResult; stdcall;
    function ScheduledFrameCompleted(const completedFrame: IDeckLinkVideoFrame; results: _BMDOutputFrameCompletionResult): HResult; stdcall;
    function ScheduledPlaybackHasStopped: HResult; stdcall;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  m_DeckLink                    : IDeckLink = nil;
  m_deckLinkOutput              : IDeckLinkOutput = nil;
  m_running                     : boolean = false;
  m_videoFrameBars              : TSignalGenerator3DVideoFrame = nil; //IDeckLinkMutableVideoFrame = nil;
  m_videoFrameBlack             : TSignalGenerator3DVideoFrame = nil; //IDeckLinkMutableVideoFrame = nil;
  m_audioBuffer                 : Pointer = nil;
  m_outputSignal                : _OutputSignal;
  m_audioSampleDepth            : _BMDAudioSampleType;
  m_audioSampleRate             : word;
  m_audioChannelCount           : integer;
  m_framesPerSecond             : Int64;
  m_frameDuration               : Int64;
  m_frameTimescale              : Int64;
  m_audioSamplesPerFrame        : cardinal;
  m_audioSamplesLength          : cardinal;
  m_audioBufferSampleLength     : int64;
  m_totalAudioSecondsScheduled  : int64;
  m_totalFramesScheduled        : Int64;
  m_frameWidth                  : integer;
  m_frameHeight                 : integer;

implementation

{$R *.dfm}

(* TVideoFormat *)
constructor TDeckLinkdisplayModeObject.Create(const name : string; const videoDisplayMode : IDeckLinkdisplayMode) ;
begin
   fName := name;
   fvideoDisplayMode := videoDisplayMode;
end;


Procedure FillSine(audioBuffer: Pointer; sampleToWrite: longint; channels : integer; samleDepth : integer);
var
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
  nextword        : pDWORD;
  width           : cardinal;
  height          : cardinal;
  wordsRemaining  : cardinal;
begin
  theframe.GetBytes(Pointer(nextword));
	width := theFrame.GetWidth();
	height := theFrame.GetHeight();

	wordsRemaining := (width*2 * height) div 4;

	while (wordsRemaining > 0) do
  begin
    nextword^:= $10801080;
    inc(nextword, 1);
    dec(wordsRemaining);
  end;
end;

Procedure FillColourBars(theFrame : IDeckLinkVideoFrame; reversed : boolean);
var
  nextword        : pDWORD;
  bars            : array[0..7] of cardinal;
  width           : integer;
  height          : integer;
  x,y             : integer;
  colourBarCount  : integer;
  pos             : integer;
begin

	theFrame.GetBytes(Pointer(nextWord));
	width := theFrame.GetWidth();
	height := theFrame.GetHeight();

	if (width > 720) then
	begin
    move(gHD75pcColourBars[0], bars[0], sizeof(gHD75pcColourBars));
		colourBarCount := sizeof(gHD75pcColourBars) div sizeof(gHD75pcColourBars[0]);
	end	else
	begin
    move(gSD75pcColourBars[0], bars[0], sizeof(gSD75pcColourBars));
		colourBarCount :=  sizeof(gSD75pcColourBars) div sizeof(gSD75pcColourBars[0]);
	end;

  for y := 0 to height-1 do
  begin
    x:=0;
    while x < width do
    begin
      pos := x * colourBarCount div width;
      if (reversed) then
				pos := colourBarCount - pos - 1;

      nextword^:= bars[pos];
      inc(nextword, 1);

      inc(x, 2);
    end;
  end;
end;

function TForm1.GetBytesPerPixel(const pixelFormat: _BMDPixelFormat): integer;
var
  bytesPerPixel : integer;
begin
	case pixelFormat of
    bmdFormat8BitYUV: bytesPerPixel := 2;
    bmdFormat10BitYUV: bytesPerPixel := 4;
    bmdFormat8BitARGB: bytesPerPixel := 4;
    bmdFormat10BitRGB: bytesPerPixel := 4;
    else  bytesPerPixel := 2;
  end;
	result:= bytesPerPixel;
end;

Procedure TForm1.WriteNextAudioSamples();
var
  sampleFramesWritten : SYSUINT;
begin
  // Write one second of audio to the DeckLink API.

	if (m_outputSignal = kOutputSignalPip) then
	begin
		// Schedule one-frame of audio tone
		if (m_deckLinkOutput.ScheduleAudioSamples(m_audioBuffer, m_audioSamplesPerFrame, (m_totalAudioSecondsScheduled * m_audioBufferSampleLength), m_audioSampleRate, sampleFramesWritten) <> S_OK) then
			exit;
	end	else
	begin
		// Schedule one-second (minus one frame) of audio tone
		if (m_deckLinkOutput.ScheduleAudioSamples(m_audioBuffer, (m_audioBufferSampleLength - m_audioSamplesPerFrame), (m_totalAudioSecondsScheduled * m_audioBufferSampleLength) + m_audioSamplesPerFrame, m_audioSampleRate, sampleFramesWritten) <> S_OK) then
			exit;
	end;

	inc(m_totalAudioSecondsScheduled);

end;

Procedure TForm1.ScheduleNextFrame(prerolling : boolean);
var
  result : HRESULT;
begin
  if not prerolling then
  begin
    // If not prerolling, make sure that playback is still active
    if not m_running then exit;
  end;

  if m_outputSignal = kOutputSignalPip then
  begin
    if (m_totalFramesScheduled mod m_framesPerSecond)=0 then
    begin
      // On each second, schedule a frame of bars
      result:=m_deckLinkOutput.ScheduleVideoFrame(m_videoFrameBars, (m_totalFramesScheduled * m_frameDuration), m_frameDuration, m_frameTimescale);
      if FAILED(result) then exit;
    end else
    begin
      // Schedue frames of black
      result := m_deckLinkOutput.ScheduleVideoFrame(m_videoFrameBlack, (m_totalFramesScheduled * m_frameDuration), m_frameDuration, m_frameTimescale);
      if FAILED(result) then exit;
    end;
  end else
  begin
    if (m_totalFramesScheduled mod m_framesPerSecond)=0 then
    begin
      // On each second, schedule a frame of black
      result := m_deckLinkOutput.ScheduleVideoFrame(m_videoFrameBlack, (m_totalFramesScheduled * m_frameDuration), m_frameDuration, m_frameTimescale);
      if FAILED(result) then exit;
    end else
    begin
      // Schedue frames of color bars
      result:=m_deckLinkOutput.ScheduleVideoFrame(m_videoFrameBars, (m_totalFramesScheduled * m_frameDuration), m_frameDuration, m_frameTimescale);
      if FAILED(result) then exit;
    end;
  end;

  inc(m_totalFramesScheduled);

end;

function TForm1._AddRef: Integer;
begin
 Result := 1;
end;

function TForm1._Release: Integer;
begin
  result:=1;
end;

function TForm1.QueryInterface1(const IID: TGUID; out Obj): HRESULT;
begin
  Result := E_NOINTERFACE;
end;

function TForm1.RenderAudioSamples(preroll: Integer): HResult;
begin
	// Provide further audio samples to the DeckLink API until our preferred buffer waterlevel is reached
  WriteNextAudiosamples;

  // Start audio and video output
  if preroll > 0 then
    m_deckLinkOutput.StartScheduledPlayback(0,100,1.0);

  result:=S_OK;
end;

function TForm1.ScheduledPlaybackHasStopped: HResult;
begin
  result:=S_OK;
end;

function TForm1.ScheduledFrameCompleted(const completedFrame: IDeckLinkVideoFrame; results: _BMDOutputFrameCompletionResult): HResult;
begin
  // When a video frame has been
  ScheduleNextFrame(false);
  result:=S_OK;
end;

procedure TForm1.RefreshDisplayModeMenu();
var
	// Populate the display mode combo with a list of display modes supported by the installed DeckLink card
	displayModeIterator : IDeckLinkDisplayModeIterator;
	deckLinkDisplayMode : IDeckLinkDisplayMode;
  resultDisplayMode   : IDeckLinkDisplayMode;

	pixelFormat         : _BMDPixelFormat;
  i                   : integer;
  modeName            : widestring;
  hr                  : HRESULT;
  displayModeSupport  : _BMDDisplayModeSupport;
  videoOutputFlags    : _BMDVideoOutputFlags;
  VideoFormat         : TDeckLinkdisplayModeObject;
begin

	pixelFormat := _BMDPixelFormat(m_pixelFormatCombo.Items.Objects[m_pixelFormatCombo.ItemIndex]);

	for i := 0 to m_videoFormatCombo.Items.Count-1 do
	begin
    VideoFormat := m_videoFormatCombo.Items.Objects[i] as TDeckLinkdisplayModeObject;
    VideoFormat.Destroy;
	end;
	m_videoFormatCombo.Clear;

	if m_deckLinkOutput.GetDisplayModeIterator(displayModeIterator) <> S_OK then
		exit;

	while (displayModeIterator.Next(deckLinkDisplayMode) = S_OK) do
	begin

		videoOutputFlags := bmdVideoOutputDualStream3D;

		if (deckLinkDisplayMode.GetName(modeName) <> S_OK) then
		begin
			deckLinkDisplayMode._Release();
			continue;
		end;

    m_videoFormatCombo.Items.AddObject(modeName, TDeckLinkdisplayModeObject.Create(modeName, DeckLinkdisplayMode));

		hr := m_deckLinkOutput.DoesSupportVideoMode(deckLinkDisplayMode.GetDisplayMode(), pixelFormat, videoOutputFlags, displayModeSupport, resultDisplayMode);
		if ((hr <> S_OK) or (displayModeSupport = bmdDisplayModeNotSupported)) then
			continue;

    m_videoFormatCombo.Items.AddObject(modeName + ' 3D', TDeckLinkdisplayModeObject.Create(modeName, DeckLinkdisplayMode));

		deckLinkDisplayMode._AddRef();
	end;

	if assigned(displayModeIterator) then displayModeIterator := nil;

	m_videoFormatCombo.ItemIndex := 0;
end;


procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	if m_running then
		StopRunning();

	if Assigned(m_deckLinkOutput) then
	begin
		m_deckLinkOutput.SetScheduledFrameCompletionCallback(nil);
		m_deckLinkOutput.SetAudioCallback(nil);
	end;

end;

procedure TForm1.FormCreate(Sender: TObject);
label
  bail;

var
  DisplayModeIterator         : IDeckLinkDisplayModeIterator;
  DeckLinkdisplayMode         : IDeckLinkdisplayMode;
  DeckLinkIterator            : IDeckLinkIterator;
  success                     : boolean;

  result                      : HRESULT;
begin

	// Initialize instance variables
	m_running := false;
	m_deckLink := nil;
	m_deckLinkOutput := nil;

	m_videoFrameBlack := nil;
	m_videoFrameBars := nil;
	m_audioBuffer := nil;

  DeckLinkdisplayMode := nil;
  DisplayModeIterator := nil;
  DeckLinkIterator := nil;
  success := false;

	// Initialize the DeckLink API
  result:= CoInitialize(nil);
  result := CoCreateInstance(CLASS_CDeckLinkIterator, nil, CLSCTX_ALL, IID_IDeckLinkIterator,  DeckLinkIterator);
  if result <> S_OK then
  begin
    showmessage(format('This application requires the DeckLink drivers installed.'+#10#13+'Please install the Blackmagic DeckLink drivers to use the features of this application.'+#10#13+'result = %08x.', [result]));
    goto bail;
  end;

	// Connect to the first DeckLink instance
  result:=deckLinkIterator.Next(m_deckLink);
  if result <> S_OK then
  begin
    showmessage(format('This application requires a DeckLink PCI card.'+#10#13+'You will not be able to use the features of this application until a DeckLink PCI card is installed.'+#10#13+'result = %08x.', [result]));
    goto bail;
  end;

	// Obtain the audio/video output interface (IDeckLinkOutput)
  result:=m_DeckLink.QueryInterface(IID_IDeckLinkOutput, m_deckLinkOutput);
  if result <> S_OK then
  begin
    showmessage(format('Could not obtain the IDeckLinkOutput interface.'+#10#13+'result = %08x.', [result]));
    goto bail;
  end;

	// Provide this class as a delegate to the audio and video output interfaces
  m_deckLinkOutput.SetScheduledFrameCompletionCallback(Form1);
  m_deckLinkOutput.SetAudioCallback(Form1);


  m_outputSignalCombo.Clear;
  m_audioChannelCombo.Clear;
  m_audioSampleDepthCombo.Clear;
  m_pixelFormatCombo.Clear;

	// Set the item data for combo box entries to store audio channel count and sample depth information
	m_outputSignalCombo.Items.AddObject('Pip', TObject(kOutputSignalPip));
	m_outputSignalCombo.Items.AddObject('Drop', TObject(kOutputSignalDrop));
	//
	m_audioChannelCombo.Items.AddObject('2 channels', TObject(2));		// 2 channels
	m_audioChannelCombo.Items.AddObject('8 channels', TObject(8));		// 8 channels
	m_audioChannelCombo.Items.AddObject('16 channels', TObject(16));		// 16 channels
	//
	m_audioSampleDepthCombo.Items.AddObject('16-bit', TObject(16));	// 16-bit samples
	m_audioSampleDepthCombo.Items.AddObject('32-bit', TObject(32));	// 32-bit samples

	m_pixelFormatCombo.Items.AddObject('8Bit YUV', TObject(bmdFormat8BitYUV));
	m_pixelFormatCombo.Items.AddObject('10Bit YUV', TObject(bmdFormat10BitYUV));
	m_pixelFormatCombo.Items.AddObject('8Bit ARGB', TObject(bmdFormat8BitARGB));
	m_pixelFormatCombo.Items.AddObject('10Bit RGB', TObject(bmdFormat10BitRGB));


	// Select the first item in each combo box
	m_outputSignalCombo.ItemIndex := 0;
	m_audioChannelCombo.ItemIndex := 0;
	m_audioSampleDepthCombo.ItemIndex := 0;
	m_pixelFormatCombo.ItemIndex := 0;

	RefreshDisplayModeMenu();

  success:=true;

  bail:
    begin
      if not success then
      begin
        if assigned(m_deckLinkOutput) then m_deckLinkOutput:=nil;
        if assigned(m_deckLink) then  m_deckLink:=nil;

        // Disable the user interface if we could not succsssfully connect to a DeckLink device
        m_startButton.Enabled:=false;
        EnableInterface(false);
      end;
      if assigned(deckLinkIterator) then   deckLinkIterator:=nil;
    end;

end;

procedure TForm1.EnableInterface(enable : boolean);
begin
	// Set the enable state of user interface elements
  m_outputSignalCombo.Enabled:=enable;
  m_audioChannelCombo.Enabled:=enable;
  m_audioSampleDepthCombo.Enabled:=enable;
  m_videoFormatCombo.Enabled:=enable;
  m_pixelFormatCombo.Enabled:=enable;
end;



function TForm1.CreateBlackFrame(): TSignalGenerator3DVideoFrame;
label
  bail;
var
  referenceBlack  : IDeckLinkMutableVideoFrame;
  scheduleBlack   : IDeckLinkMutableVideoFrame;
  pixelFormat     : _BMDPixelFormat;
  HR              : HRESULT;
  bytesPerPixel   : integer;
  frameConverter  : IDeckLinkVideoConversion;
  ret             : TSignalGenerator3DVideoFrame;
begin
  referenceBlack := nil;
  scheduleBlack := nil;
  frameConverter  :=  nil;
  ret :=  nil;

  pixelFormat := _BMDPixelFormat(m_pixelFormatCombo.Items.Objects[m_pixelFormatCombo.ItemIndex]);
	bytesPerPixel := GetBytesPerPixel(pixelFormat);

	hr := m_deckLinkOutput.CreateVideoFrame(m_frameWidth, m_frameHeight, m_frameWidth*bytesPerPixel, pixelFormat, bmdFrameFlagDefault, scheduleBlack);
	if (hr <> S_OK) then
		goto bail;

	if (pixelFormat = bmdFormat8BitYUV) then
	begin
		FillBlack(scheduleBlack);
	end	else
	begin
		hr := m_deckLinkOutput.CreateVideoFrame(m_frameWidth, m_frameHeight, m_frameWidth*2, bmdFormat8BitYUV, bmdFrameFlagDefault, referenceBlack);
	  if (hr <> S_OK) then
			goto bail;
		FillBlack(referenceBlack);

		hr := CoCreateInstance(CLASS_CDeckLinkVideoConversion, nil, CLSCTX_ALL, IID_IDeckLinkVideoConversion, frameConverter);
	  if (hr <> S_OK) then
			goto bail;

		hr := frameConverter.ConvertFrame(referenceBlack, scheduleBlack);
	  if (hr <> S_OK) then
			goto bail;
	end;

	ret := TSignalGenerator3DVideoFrame.Create(scheduleBlack);

bail:
	if assigned(referenceBlack) then
  referenceBlack := nil;

	if assigned(scheduleBlack) then
  scheduleBlack := nil;

	if assigned(frameConverter) then
  frameConverter := nil;

	result := ret;
end;


function TForm1.CreateBarsFrame(): TSignalGenerator3DVideoFrame;
label
  bail;

var
  referenceBarsLeft : IDeckLinkMutableVideoFrame;
  referenceBarsRight : IDeckLinkMutableVideoFrame;
  scheduleBarsLeft : IDeckLinkMutableVideoFrame;
  scheduleBarsRight : IDeckLinkMutableVideoFrame;

  pixelFormat     : _BMDPixelFormat;
  HR              : HRESULT;
  bytesPerPixel   : integer;
  frameConverter  : IDeckLinkVideoConversion;
  ret             : TSignalGenerator3DVideoFrame;
begin
  referenceBarsLeft := nil;
  referenceBarsRight := nil;
  scheduleBarsLeft := nil;
  scheduleBarsRight := nil;
  frameConverter  :=  nil;
  ret :=  nil;

  pixelFormat := _BMDPixelFormat(m_pixelFormatCombo.Items.Objects[m_pixelFormatCombo.ItemIndex]);
	bytesPerPixel := GetBytesPerPixel(pixelFormat);

	hr := m_deckLinkOutput.CreateVideoFrame(m_frameWidth, m_frameHeight, m_frameWidth*bytesPerPixel, pixelFormat, bmdFrameFlagDefault, scheduleBarsLeft);
	if (hr <> S_OK) then
		goto bail;

	hr := m_deckLinkOutput.CreateVideoFrame(m_frameWidth, m_frameHeight, m_frameWidth*bytesPerPixel, pixelFormat, bmdFrameFlagDefault, scheduleBarsRight);
	if (hr <> S_OK) then
		goto bail;

	if (pixelFormat = bmdFormat8BitYUV) then
	begin
		FillColourBars(scheduleBarsLeft, false);
		FillColourBars(scheduleBarsRight, true);
	end	else
	begin
		hr := m_deckLinkOutput.CreateVideoFrame(m_frameWidth, m_frameHeight, m_frameWidth*2, bmdFormat8BitYUV, bmdFrameFlagDefault, referenceBarsLeft);
	  if (hr <> S_OK) then
			goto bail;

		hr := m_deckLinkOutput.CreateVideoFrame(m_frameWidth, m_frameHeight, m_frameWidth*2, bmdFormat8BitYUV, bmdFrameFlagDefault, referenceBarsRight);
	  if (hr <> S_OK) then
			goto bail;

		FillColourBars(referenceBarsLeft, false);
		FillColourBars(referenceBarsRight, true);

		hr := CoCreateInstance(CLASS_CDeckLinkVideoConversion, nil, CLSCTX_ALL, IID_IDeckLinkVideoConversion, frameConverter);
	  if (hr <> S_OK) then
			goto bail;

		hr := frameConverter.ConvertFrame(referenceBarsLeft, scheduleBarsLeft);
	  if (hr <> S_OK) then
			goto bail;

		hr := frameConverter.ConvertFrame(referenceBarsRight, scheduleBarsRight);
	  if (hr <> S_OK) then
			goto bail;
	end;

	ret := TSignalGenerator3DVideoFrame.Create(scheduleBarsLeft, scheduleBarsRight);

bail:
	if assigned(scheduleBarsLeft) then
		scheduleBarsLeft := nil;
	if assigned(scheduleBarsRight) then
		scheduleBarsRight := nil;
	if assigned(referenceBarsLeft) then
		scheduleBarsLeft := nil;
	if assigned(referenceBarsRight) then
		referenceBarsRight := nil;
	if assigned(frameConverter) then
		frameConverter := nil;

	result := ret;
end;

procedure TForm1.m_startButtonClick(Sender: TObject);
begin
  if m_running then StopRunning else StartRunning;
end;

Procedure TForm1.StopRunning();
var
  actualStopTime: Int64;
begin
	// Stop the audio and video output streams immediately
  m_deckLinkOutput.StopScheduledPlayback(0,actualStopTime,0);
  //
  m_deckLinkOutput.DisableAudioOutput;
  m_deckLinkOutput.DisableVideoOutput;

  if assigned(m_videoFrameBlack) then
    m_videoFrameBars._Release;
  m_videoFrameBlack:=nil;

  if assigned(m_videoFrameBars) then
    m_videoFrameBars._Release;
  m_videoFrameBars:=nil;

  if assigned(m_audioBuffer) then HeapFree(GetProcessHeap,0,m_audioBuffer);

  // Success; update the UI
  m_running:=false;
  m_startButton.Caption:='Start';
	// Re-enable the user interface when stopped
  EnableInterface(true);

end;

Procedure TForm1.StartRunning();
label
  bail;
var
  videoDisplayMode          : IDeckLinkdisplayMode;
  DisplayModeIterator       : IDeckLinkDisplayModeIterator;
  videoOutputFlags          : _BMDVideoOutputFlags;
  i                         : integer;
  videoFormatName           : string;
  result                    : HRESULT;
  VideoFormat               : TDeckLinkdisplayModeObject;
begin
  videoDisplayMode := nil;
  DisplayModeIterator := nil;
  videoOutputFlags := bmdVideoOutputFlagDefault;

  videoFormatName:=m_videoFormatCombo.Items.Strings[m_videoFormatCombo.ItemIndex];
  if videoFormatName.Contains(' 3D') then
    videoOutputFlags := bmdVideoOutputDualStream3D;

	// Determine the audio and video properties for the output stream
  m_outputSignal := _OutputSignal(m_outputSignalCombo.ItemIndex);
  m_audioChannelCount:= Integer(m_audioChannelCombo.Items.Objects[m_audioChannelCombo.ItemIndex]);
  m_audioSampleDepth := _BMDAudioSampleType(m_audioSampleDepthCombo.Items.Objects[m_audioSampleDepthCombo.ItemIndex]);
  m_audioSampleRate := bmdAudioSampleRate48kHz;

	//
	// - Extract the IDeckLinkDisplayMode from the display mode popup menu (stashed in the item's tag)
  VideoFormat := m_videoFormatCombo.items.Objects[m_videoFormatCombo.ItemIndex] as TDeckLinkdisplayModeObject;
	videoDisplayMode :=  VideoFormat.videoDisplayMode;
	m_frameWidth := videoDisplayMode.GetWidth();
	m_frameHeight := videoDisplayMode.GetHeight();
	videoDisplayMode.GetFrameRate(m_frameDuration, m_frameTimescale);
	// Calculate the number of frames per second, rounded up to the nearest integer.  For example, for NTSC (29.97 FPS), framesPerSecond == 30.
  m_framesPerSecond := (m_frameTimeScale + (m_frameDuration-1)) div m_frameDuration;

	// Set the video output mode
  result := m_decklinkOutput.EnableVideoOutput(videoDisplayMode.GetDisplayMode, bmdVideoOutputFlagDefault);
  if result <> S_OK then
  begin
    showmessage(format('Could not obtain the IDeckLinkOutput.EnableVideoOutput interface.'+#10#13+'result = %08x.', [result]));
    goto bail;
  end;

	// Set the audio output mode
  result:=m_decklinkOutput.EnableAudioOutput(m_audioSampleRate, m_audioSampleDepth, m_audioChannelCount, bmdAudioOutputStreamTimestamped);
  if result <> S_OK then
  begin
    showmessage(format('Could not obtain the IDeckLinkOutput.EnableAudioOutput interface.'+#10#13+'result = %08x.', [result]));
    goto bail;
  end;

	// Generate one second of audio tone
  m_audioSamplesPerFrame:=(m_audioSampleRate * m_frameDuration) div m_frameTimescale;
  m_audioBufferSampleLength:= (m_framesPerSecond * m_audioSampleRate * m_frameDuration) div m_frameTimescale;
  m_audioBuffer := HeapAlloc(GetProcessHeap(),0, (m_audioBufferSampleLength * m_audioChannelCount * (m_audioSampleDepth div 8)));
  if not assigned(m_audioBuffer) then
    goto bail;

  FillSine(m_audioBuffer, m_audioBufferSampleLength, m_audioChannelCount, m_audioSampleDepth);


	// Generate a frame of black
	m_videoFrameBlack := CreateBlackFrame();
	if not assigned(m_videoFrameBlack) then
		goto bail;

  {result:=m_decklinkOutput.CreateVideoFrame(m_frameWidth, m_frameHeight, m_frameWidth*4, bmdFormat8bitBGRA, bmdFrameFlagFlipVertical, m_videoFrameBlack);
  if result <> S_OK then
  begin
    showmessage(format('Could not obtain the IDeckLinkOutput.CreateVideoFrame interface.'+#10#13+'result = %08x.', [result]));
    goto bail;
  end;
  FillBlack(m_videoFrameBlack); }

  {result:=m_decklinkOutput.CreateVideoFrame(m_frameWidth, m_frameHeight, m_frameWidth*4, bmdFormat8bitBGRA, bmdFrameFlagDefault, m_videoFrameBars);
  if result <> S_OK then
  begin
    showmessage(format('Could not obtain the IDeckLinkOutput.CreateVideoFrame interface.'+#10#13+'result = %08x.', [result]));
    goto bail;
  end;
  FillColourBars(m_videoFrameBars);}

	// Generate a frame of colour bars
	m_videoFrameBars := CreateBarsFrame();
	if not assigned(m_videoFrameBars) then
		goto bail;

	// Begin video preroll by scheduling a second of frames in hardware
  m_totalFramesScheduled :=1;
  for I := 0 to m_framesPerSecond-1 do
    ScheduleNextFrame(true);

	// Begin audio preroll.  This will begin calling our audio callback, which will start the DeckLink output stream.
  m_totalAudioSecondsScheduled :=0;
  result:=m_deckLinkOutput.BeginAudioPreroll;
  if result <> S_OK then
  begin
    showmessage(format('Could not obtain the IDeckLinkOutput.BeginAudioPreroll interface.'+#10#13+'result = %08x.', [result]));
    goto bail;
  end;

	// Success; update the UI
  m_running := true;
  m_startButton.Caption:='Stop';
	// Disable the user interface while running (prevent the user from making changes to the output signal)
  enableInterface(false);
  exit;

  bail :
  begin
	  // *** Error-handling code.  Cleanup any resources that were allocated. *** //
    StopRunning;
  end;

end;


end.
