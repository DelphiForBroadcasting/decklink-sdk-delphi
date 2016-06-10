unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DeckLinkAPI_TLB, Vcl.StdCtrls, activex, directshow9, SDL, sdlwindow;

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

Const
  MAX_DECKLINK = 16;


Type
  CVideoDelegate = class;

  TForm1 = class(TForm)
    m_InputCardCombo: TComboBox;
    m_VideoFormatCombo: TComboBox;
    m_CaptureTimeLabel: TLabel;
    m_StartButton: TButton;
    m_CaptureTime: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure m_StartButtonClick(Sender: TObject);
    procedure m_VideoFormatComboChange(Sender: TObject);
    procedure m_InputCardComboChange(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);

  private
    { Private declarations }
  public
      m_pDelegate     : CVideoDelegate;
      m_bRunning      : boolean;
      m_pInputCard    : IDeckLinkInput;
      m_pDeckLink     : array[0..MAX_DECKLINK-1] of IDeckLink;
      screen          : PSDL_Surface ;
      overlay         : PSDL_Overlay;
      m_configuration : IDeckLinkConfiguration;
  end;

  CVideoDelegate = class(TInterfacedObject, IDeckLinkInputCallback)
  Private
    m_RefCount  : integer;
    m_pController: TForm1;
  Public
    constructor Create(pController : TForm1);
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
  Form1         : TForm1;
  pIterator     : IDeckLinkIterator = nil;

implementation

{$R *.dfm}
//-----------------------TVideoFormat---------------------------------------
constructor TVideoFormat.Create(const name : string; const videoDisplayMode : IDeckLinkdisplayMode) ;
begin
   fName := name;
   fvideoDisplayMode := videoDisplayMode;
end;



//-----------------------CVideoDelegate---------------------------------------

function CVideoDelegate._AddRef: Integer;
begin
 Result := InterlockedIncrement(m_RefCount);
end;

function CVideoDelegate._Release: Integer;
var
  newRefValue : integer;
begin
  newRefValue:=InterlockedDecrement(m_RefCount);
  if newRefValue=0 then
  begin
    //Destroy;
    free;
    Result := 0;
  end;
  result:=newRefValue;
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
Type
  PAVPicture = ^TAVPicture;
  TAVPicture = record
    data: array [0..3] of System.SysUtils.PByteArray;
    linesize: array [0..3] of longint;       ///< number of bytes per line
  end; {TAVPicture}

function LimitByte(Value:Integer):byte;
begin
  if Value<0 then Value:=0;
  if Value>255 then Value:=255;
  Result:=Value;
end;

function ByteTOARGB(const A, R, G, B: Byte): cardinal;
begin
  result:=(a or (r shl 8) or (g shl 16) or (b shl 24));
end;

var
  frameTime, frameDuration        : Int64;
  hours, minutes, seconds, frames : integer;
  captureString                   : string;
  pbData                          : Pointer;
  m_Width, m_Height               : integer;
  i                           : integer;
  SDLNAme                         : string;
  m_BytesPerPixel                 : integer;
  OperBegin, OperEnd: TTimeStamp;
  rect         : TSDL_Rect;
  Dest     : TAVPicture;
begin
m_BytesPerPixel:=0;
if form1.m_bRunning then
begin
  OperBegin := DateTimeToTimeStamp(Now);
  videoFrame.GetStreamTime(frameTime, frameDuration, 600);
  hours:=frametime div (600 * 60 * 60);
  minutes:=(frametime div (600 * 60)) mod 60;
  seconds:=(frametime div 600) mod 60;
  frames:=(frametime div 6) mod 100;
  sdlname :=format('%d-%d-%d.bmp',[minutes,seconds,frames]);

  m_Width := videoFrame.GetWidth;
  m_Height := videoFrame.GetHeight;
  case videoFrame.GetPixelFormat of
    bmdFormat8BitYUV  : m_BytesPerPixel:=2;
    bmdFormat10BitYUV : m_BytesPerPixel:=2;
    bmdFormat8BitARGB : m_BytesPerPixel:=4;
    bmdFormat8BitBGRA : m_BytesPerPixel:=4;
    bmdFormat10BitRGB : m_BytesPerPixel:=3;
  end;
  videoFrame.GetBytes(pbData);

  SDL_LockYUVOverlay(m_pController.overlay);
  Dest.data[0] := System.SysUtils.PByteArray(m_pController.overlay.pixels^);
  inc(m_pController.overlay.pixels); inc(m_pController.overlay.pixels);
  Dest.data[1] := System.SysUtils.PByteArray(m_pController.overlay.pixels^);
  dec(m_pController.overlay.pixels);
  Dest.data[2] := System.SysUtils.PByteArray(m_pController.overlay.pixels^);
  dec(m_pController.overlay.pixels);
  Dest.linesize[0] := integer(m_pController.overlay.pitches^);
  inc(m_pController.overlay.pitches); inc(m_pController.overlay.pitches);
  Dest.linesize[1] := integer(m_pController.overlay.pitches^);
  dec(m_pController.overlay.pitches);
  Dest.linesize[2] := integer(m_pController.overlay.pitches^);
  dec(m_pController.overlay.pitches);


  for i := 0 to m_Height - 1 do
  begin
    move(pbData^, pointer(integer(Dest.data [0]) + m_Width * m_BytesPerPixel * i)^, m_Width * m_BytesPerPixel );
    inc(PByte(pbData), m_Width * m_BytesPerPixel);
  end;

  SDL_UnlockYUVOverlay(m_pController.overlay);
  OperEnd := DateTimeToTimeStamp(Now);
   //ListBox1.Items.Insert(0,inttostr(OperEnd.Time - OperBegin.Time));
  rect.x:=0;
  rect.y:=0;
  rect.w:=m_Width;
  rect.h:=m_Height;
  SDL_DisplayYUVOverlay(m_pController.overlay, @rect );
  //SDL_UpdateRect (screen, 0, 0, 0, 0) ;
  captureString:=Format('%02.2d:%02.2d:%02.2d:%02.2d',[hours, minutes, seconds, frames]);
  m_pController.m_CaptureTime.Caption:=captureString;
end;

  RESULT:=S_OK;
end;



procedure TForm1.CheckBox1Click(Sender: TObject);
const
  BYPASS_TIMEOUT_MS = 40;
begin
  if m_bRunning then
  begin
    if CheckBox1.Checked then
    begin
      if (m_configuration.SetInt(bmdDeckLinkConfigBypass, BYPASS_TIMEOUT_MS)<>S_OK) then
      begin
        showmessage('Error resetting the bypass timeout value');
      end;
    end else
    begin
      if (m_configuration.SetInt(bmdDeckLinkConfigBypass, -1)<>S_OK) then
      begin
        showmessage('Error resetting the bypass timeout value');
      end;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
    i             : integer;
    cardname      : Widestring;
    find_deckLink : boolean;
    hr            : HResult;
begin
  m_pDelegate := CVideoDelegate.create(self);
  CoInitialize(nil);
  hr := CoCreateInstance(CLASS_CDeckLinkIterator, nil, CLSCTX_ALL, IID_IDeckLinkIterator,  pIterator);
  if hr<>S_OK then begin
    showmessage(format('This application requires the DeckLink drivers installed.'+#10#13+'Please install the Blackmagic DeckLink drivers to use the features of this application.'+#10#13+'result = %08x.', [hr]));
    exit;
  end;


  for I := 0 to MAX_DECKLINK-1 do
  begin
    find_deckLink := true;
    if pIterator.Next(m_pDeckLink[i])<>S_OK then break;
    if m_pDeckLink[i].GetModelName(cardName)<>S_OK then  cardName:='Unknown DeckLink';
    m_InputCardCombo.Items.AddObject(cardName, Pointer(m_pDeckLink[i]));
  end;

  if not find_deckLink then
  begin
    m_InputCardCombo.Items.Add('No DeckLink Cards Found');
    m_StartButton.Enabled:=false;
  end;

  m_InputCardCombo.ItemIndex:=0;
  m_captureTimeLabel.Visible:=false;
  m_CaptureTime.Visible:=false;
  m_bRunning:=false;


end;

procedure TForm1.m_InputCardComboChange(Sender: TObject);
var
    hr                          : HResult;
    DisplayModeIterator         : IDeckLinkDisplayModeIterator;
    DeckLinkdisplayMode         : IDeckLinkdisplayMode;
    ModeName                    : widestring;
    m_attributes                : IDeckLinkAttributes;
    hasBypass                   : integer;
begin
  ModeName:='';
  m_attributes:=nil;
  hasBypass:=0;

	// Get the IDeckLinkAttributes interface
	if (m_pDeckLink[m_InputCardCombo.ItemIndex].QueryInterface(IID_IDeckLinkAttributes, m_attributes)<> S_OK) then
	begin
		showmessage('Could not get the IdeckLinkAttributes interface');
	end else
  begin
    	// Make sure the DeckLink device has a bypass
	  if (m_attributes.GetFlag(BMDDeckLinkHasBypass, hasBypass) = S_OK) then
    begin
      if hasBypass=0 then checkbox1.Enabled:=false
    else
      if hasBypass=1 then checkbox1.Enabled:=true;
    end;
  end;

  if m_pDeckLink[m_InputCardCombo.ItemIndex].QueryInterface(IID_IDeckLinkConfiguration, m_configuration)<>S_OK then
    showmessage('Could not get the IDeckLinkConfiguration interface');


if m_pDeckLink[m_InputCardCombo.ItemIndex].QueryInterface(IID_IDeckLinkInput, m_pInputCard)=S_OK then
begin

  m_videoFormatCombo.Clear;
  hr:=m_pInputCard.GetDisplayModeIterator(DisplayModeIterator);
  if FAILED(hr) then begin
    showmessage(format('Could not obtain the IDeckLinkOutput.GetDisplayModeIterator interface.'+#10#13+'result = %08x.', [hr]));
    exit;
  end;

  while (DisplayModeIterator.Next(DeckLinkdisplayMode) = S_OK)  do
  begin
    if Succeeded(DeckLinkdisplayMode.GetName(modeName)) then
      m_videoFormatCombo.AddItem(modeName, TVideoFormat.Create(modeName, DeckLinkdisplayMode)) ;
      m_VideoFormatCombo.ItemIndex:=0;
  end;

  if ModeName<>'' then m_VideoFormatCombo.ItemIndex:=0;
end;

  if assigned(m_attributes) then  m_attributes:=nil;
end;

procedure TForm1.m_StartButtonClick(Sender: TObject);
label
  bail;
var
  theResult         : HResult;
  videoDisplayMode  : IDeckLinkdisplayMode;
  VideoFormat       : TVideoFormat;
begin
theResult:=S_OK;

if not m_bRunning then
begin
  SDL_Init (SDL_INIT_VIDEO) ;

  if m_pDeckLink[m_InputCardCombo.ItemIndex].QueryInterface(IID_IDeckLinkInput, m_pInputCard)<>S_OK then
    goto bail;

  try
    VideoFormat := m_videoFormatCombo.Items.Objects[m_videoFormatCombo.ItemIndex] as TVideoFormat;
    videodisplayMode:=VideoFormat.videoDisplayMode;
  except
    showmessage(format('Could not obtain the TVideoFormat interface.'+#10#13+'result = ', []));
    exit;
  end;

   //------------SDL INIT----------------------------
  screen := SDL_SetVideoMode (videodisplayMode.GetWidth, videodisplayMode.GetHeight, 0, SDL_SWSURFACE) ;
  if screen = nil then
  Begin
    showmessage(format('SDL_SetVideoMode failed with result 0x%08x',[theResult]));
  End ;
  SDL_WM_SetCaption(PWideChar('test'), nil);
  overlay  := SDL_CreateYUVOverlay(videodisplayMode.GetWidth, videodisplayMode.GetHeight, SDL_UYVY_OVERLAY , screen );
  //-----------------SDL-----------------------------

  theResult:=m_pInputCard.SetCallback(m_pDelegate);
  if theResult<>S_OK then
    showmessage(format('SetDelegate failed with result 0x%08x',[theResult]));

  theResult:=m_pInputCard.EnableVideoInput(videodisplayMode.GetDisplayMode, bmdFormat8BitYUV, bmdVideoInputFlagDefault);
  if theResult<>S_OK then
    showmessage(format('EnableVideoInput failed with result 0x%08x',[theResult]));

  theResult:=m_pInputCard.StartStreams;
  if theResult<>S_OK then
    showmessage(format('Input StartStreams failed with result 0x%08x',[theResult]));

  m_bRunning:=true;
  m_CaptureTimeLabel.Visible:=true;
  m_CaptureTime.Visible:=true;
  m_CaptureTime.Caption:='';
  m_InputCardCombo.Enabled:=false;
  m_StartButton.Caption:='Stop';

end else
begin
  m_bRunning:=false;
  m_pInputCard.StopStreams;
  m_pInputCard.DisableVideoInput;
  SDL_FreeYUVOverlay(overlay);
  SDL_FreeSurface (screen) ;
  SDL_Quit();
  m_CaptureTimeLabel.Visible:=false;
  m_CaptureTime.Visible:=false;
  m_InputCardCombo.Enabled:=true;
  m_StartButton.Caption:='Start';
end;

bail : exit;
end;

procedure TForm1.m_VideoFormatComboChange(Sender: TObject);
var
  displayMode   : _BMDDisplayMode;
begin
if m_bRunning then
begin
  displayMode:=_BMDDisplayMode(m_videoFormatCombo.Items.Objects[m_videoFormatCombo.ItemIndex]);
  m_pInputCard.StopStreams;
  m_pInputCard.EnableVideoInput(displayMode, bmdFormat8bitYUV,0);
  m_pInputCard.StartStreams;
end;
end;

end.
