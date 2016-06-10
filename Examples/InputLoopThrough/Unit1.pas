unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Winapi.ActiveX, Winapi.DirectShow9,DeckLinkAPI_TLB_10_3_1;

Const
  MAX_DECKLINK = 16;

type
  CVideoDelegate = class;

  TForm1 = class(TForm)
    m_CaptureTimeLabel: TLabel;
    m_CaptureTime: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    m_InputCardCombo: TComboBox;
    m_OutputCardCombo: TComboBox;
    m_VideoFormatCombo: TComboBox;
    m_StartButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure m_StartButtonClick(Sender: TObject);
    procedure m_VideoFormatComboChange(Sender: TObject);
  private
    { Private declarations }
  public
    m_pDelegate   : CVideoDelegate;
    m_bRunning    : boolean;
    m_pInputCard  : IDeckLinkInput;
    m_pOutputCard : IDeckLinkOutput;
    m_pDeckLink   : array[0..MAX_DECKLINK-1] of IDeckLink;
  end;

  CVideoDelegate = class(TInterfacedObject, IDeckLinkInputCallback)
  Private
    m_RefCount  : integer;
    m_pController: TForm1;
  Public
    constructor Create(pController : TForm1);
  protected
    function QueryInterface(const IID: TGUID; out Obj): HRESULT; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

    function VideoInputFormatChanged(notificationEvents: _BMDVideoInputFormatChangedEvents;
                                     const newDisplayMode: IDeckLinkDisplayMode;
                                     detectedSignalFlags: _BMDDetectedVideoInputFormatFlags): HResult; stdcall;
    function VideoInputFrameArrived(const videoFrame: IDeckLinkVideoInputFrame;
                                    const audioPacket: IDeckLinkAudioInputPacket): HResult; stdcall;

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

(* CVideoDelegate *)

function CVideoDelegate._AddRef: Integer;
begin
 Result := InterlockedIncrement(m_RefCount);
end;

function CVideoDelegate._Release: Integer;
begin
  result := InterlockedDecrement(m_RefCount);
  if Result = 0 then
    Destroy;
end;

constructor CVideoDelegate.Create(pController : TForm1);
begin
  m_pController :=pController;
  m_RefCount:=1;
end;

function CVideoDelegate.QueryInterface(const IID: TGUID; out Obj): HRESULT;
const
  IID_IUnknown : TGUID = '{00000000-0000-0000-C000-000000000046}';
begin
  Result := E_NOINTERFACE;
  Pointer(Obj):=nil;
  if IsEqualGUID(IID, IID_IUnknown)then
  begin
    Pointer(Obj) := Self;
    _addRef;
    Result := S_OK;
  end else
  if IsEqualGUID(IID, IDeckLinkInputCallback)then
  begin
    //GetInterface(IDeckLinkInputCallback, obj);
    Pointer(Obj) := Pointer(IDeckLinkInputCallback(self));
    _addRef;
    Result := S_OK;
  end;
end;

function CVideoDelegate.VideoInputFormatChanged(notificationEvents: _BMDVideoInputFormatChangedEvents;
                                     const newDisplayMode: IDeckLinkDisplayMode;
                                     detectedSignalFlags: _BMDDetectedVideoInputFormatFlags): HResult;
begin
  RESULT:=S_OK;
end;

function CVideoDelegate.VideoInputFrameArrived(const videoFrame: IDeckLinkVideoInputFrame;
                                    const audioPacket: IDeckLinkAudioInputPacket): HResult;
var
  frameTime, frameDuration        : Int64;
  hours, minutes, seconds, frames : integer;
  theResult                       : HResult;
  captureString                   : string;
begin
  if m_pController.m_bRunning then
  begin
    videoFrame.GetStreamTime(frameTime, frameDuration, 600);
    theResult := m_pController.m_pOutputCard.ScheduleVideoFrame(videoFrame, frameTime, frameDuration, 600);
    if theResult <> S_OK then
      showmessage(format('Scheduling failed with result 0x%08x',[theResult]));

    hours:=frametime div (600 * 60 * 60);
    minutes:=(frametime div (600 * 60)) mod 60;
    seconds:=(frametime div 600) mod 60;
    frames:=(frametime div 6) mod 100;
    captureString:=Format('%02.2d:%02.2d:%02.2d:%02.2d',[hours, minutes, seconds, frames]);
    m_pController.m_CaptureTime.Caption:=captureString;

  end;

  RESULT:=S_OK;
end;


procedure TForm1.FormCreate(Sender: TObject);
var
    i             : integer;
    cardname      : Widestring;
    find_deckLink : boolean;
    result        : HResult;
    pIterator     : IDeckLinkIterator;
begin
  pIterator := nil;

  m_pDelegate := CVideoDelegate.create(self);

	// Setup video format combo
  m_VideoFormatCombo.Items.AddObject('NTSC', TObject(bmdModeNTSC));
  m_VideoFormatCombo.Items.AddObject('PAL', TObject(bmdModePAL));
  m_VideoFormatCombo.Items.AddObject('1080PsF 23.98', TObject(bmdModeHD1080p2398));
  m_VideoFormatCombo.Items.AddObject('1080PsF 24', TObject(bmdModeHD1080p24));
  m_VideoFormatCombo.Items.AddObject('1080i 50', TObject(bmdModeHD1080i50));
  m_VideoFormatCombo.Items.AddObject('1080i 59.94', TObject(bmdModeHD1080i5994));
  m_VideoFormatCombo.Items.AddObject('720p 50', TObject(bmdModeHD720p50));
  m_VideoFormatCombo.Items.AddObject('720p 59.94', TObject(bmdModeHD720p5994));
  m_VideoFormatCombo.Items.AddObject('720p 60', TObject(bmdModeHD720p60));
  m_VideoFormatCombo.Items.AddObject('2K 23.98', TObject(bmdMode2k2398));
  m_VideoFormatCombo.Items.AddObject('2K 24', TObject(bmdMode2k24));
  m_VideoFormatCombo.ItemIndex:=0;

  result := CoCreateInstance(CLASS_CDeckLinkIterator, nil, CLSCTX_ALL, IID_IDeckLinkIterator,  pIterator);
  if result<>S_OK then begin
    showmessage(format('This application requires the DeckLink drivers installed.'+#10#13+'Please install the Blackmagic DeckLink drivers to use the features of this application.'+#10#13+'result = %08x.', [result]));
    exit;
  end;

  for I := 0 to MAX_DECKLINK-1 do
  begin
    find_deckLink := true;
    if pIterator.Next(m_pDeckLink[i])<>S_OK then
      break;
    if m_pDeckLink[i].GetModelName(cardName)<>S_OK then
      cardName:='Unknown DeckLink';
    // Add this deckLink instance to the popup menus
    m_InputCardCombo.Items.AddObject(cardName, Pointer(m_pDeckLink[i]));
    m_OutputCardCombo.Items.AddObject(cardName, Pointer(m_pDeckLink[i]));
  end;

  if not find_deckLink then
  begin
    m_InputCardCombo.Items.Add('No DeckLink Cards Found');
    m_OutputCardCombo.Items.Add('No DeckLink Cards Found');
    m_StartButton.Enabled:=false;
  end;

  m_InputCardCombo.ItemIndex:=0;
  m_OutputCardCombo.ItemIndex:=0;

	// Hide the timecode
  m_captureTimeLabel.Visible:=false;
  m_CaptureTime.Visible:=false;

  m_bRunning:=false;

end;

procedure TForm1.m_StartButtonClick(Sender: TObject);
var
  Result : HResult;
  actualStopTime  : int64;
  displayMode   : _BMDDisplayMode;
begin
  actualStopTime:=0;
  // Obtain the input and output interfaces
  if not m_bRunning then
  begin
    if m_pDeckLink[m_InputCardCombo.ItemIndex].QueryInterface(IID_IDeckLinkInput, m_pInputCard)<>S_OK then
      exit;

    if m_pDeckLink[m_OutputCardCombo.ItemIndex].QueryInterface(IID_IDeckLinkOutput, m_pOutputCard)<>S_OK then
    begin
      if assigned(m_pInputCard) then   m_pInputCard:=nil;
      exit;
    end;

    displayMode:=_BMDDisplayMode(m_videoFormatCombo.Items.Objects[m_videoFormatCombo.ItemIndex]);

    // Turn on video input
    Result:=m_pInputCard.SetCallback(m_pDelegate);
    if Result<>S_OK then
      showmessage(format('SetDelegate failed with result 0x%08x',[Result]));

    Result:=m_pInputCard.EnableVideoInput(displayMode, bmdFormat8bitYUV, 0);
    if Result<>S_OK then
      showmessage(format('EnableVideoInput failed with result 0x%08x',[Result]));

    // Turn on video output
    Result:=m_pOutputCard.EnableVideoOutput(displayMode,bmdVideoOutputFlagDefault);
    if Result<>S_OK then
      showmessage(format('EnableVideoOutput failed with result 0x%08x',[Result]));

    Result:=m_pOutputCard.StartScheduledPlayback(0, 600, 1.0);
    if Result<>S_OK then
      showmessage(format('StartScheduledPlayback failed with result 0x%08x',[Result]));

    // Sart the input stream running
    Result:=m_pInputCard.StartStreams;
    if Result<>S_OK then
      showmessage(format('Input StartStreams failed with result 0x%08x',[Result]));

    m_bRunning:=true;
    m_CaptureTimeLabel.Visible:=true;
    m_CaptureTime.Visible:=true;
    m_CaptureTime.Caption:='';
    m_OutputCardCombo.Enabled:=false;
    m_InputCardCombo.Enabled:=false;
    m_StartButton.Caption:='Stop';

  end else
  begin
    m_bRunning:=false;

    m_pInputCard.StopStreams;
    m_pOutputCard.StopScheduledPlayback(0,actualStopTime, 600);

    m_pOutputCard.DisableVideoOutput;
    m_pInputCard.DisableVideoInput;

    m_CaptureTimeLabel.Visible:=false;
    m_CaptureTime.Visible:=false;
    m_OutputCardCombo.Enabled:=true;
    m_InputCardCombo.Enabled:=true;
    m_StartButton.Caption:='Start';
  end;

end;

procedure TForm1.m_VideoFormatComboChange(Sender: TObject);
var
  displayMode   : _BMDDisplayMode;
  actualStopTime  : int64;
begin
  if m_bRunning then
  begin
    displayMode:=_BMDDisplayMode(m_videoFormatCombo.Items.Objects[m_videoFormatCombo.ItemIndex]);

    m_pOutputCard.StopScheduledPlayback(0,actualStopTime, 600);
    m_pOutputCard.DisableVideoOutput;

    m_pInputCard.StopStreams;
    m_pInputCard.EnableVideoInput(displayMode, bmdFormat8bitYUV,0);
    m_pOutputCard.EnableVideoOutput(displayMode,bmdVideoOutputFlagDefault);
    m_pOutputCard.StartScheduledPlayback(0, 600, 1.0);
    m_pInputCard.StartStreams;
  end;

end;

end.
