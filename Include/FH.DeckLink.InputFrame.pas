unit FH.DeckLink.InputFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.SyncObjs, System.Generics.Collections,
  Winapi.ActiveX, Winapi.DirectShow9, DeckLinkAPI_TLB_10_5, FH.DeckLink.DisplayMode;

const
  bmdFrameHasVirtual = $90001000;


type
  TDeckLinkAudioInputPacket = class(TInterfacedObject, IDeckLinkAudioInputPacket)
  private
    m_refCount                  : integer;

    FSampleFrameCount           : integer;
    FBytes                      : Pointer;
    FDeckLinkAudioInputPacket   : IDeckLinkAudioInputPacket;
  public
    constructor Create(ADeckLinkAudioInputPacket: IDeckLinkAudioInputPacket = nil);  overload;
    destructor Destroy; override;

    procedure SetSampleFrameCount(SampleFrameCount: Integer);

    function _Release: Integer; stdcall;
    function _AddRef: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HResult;  stdcall;

    (* IDeckLinkAudioInputPacket *)
    function GetSampleFrameCount: Integer; stdcall;
    function GetBytes(out buffer: Pointer): HResult; stdcall;
    function GetPacketTime(out packetTime: Int64; timeScale: Int64): HResult; stdcall;
  end;



type
  TDeckLinkVideoInputFrame = class(TInterfacedObject, IDeckLinkVideoInputFrame, IDeckLinkVideoFrame)
  private
    m_refCount                  : integer;

    FWidth                      : integer;
    FHeight                     : integer;
    FPixelFormat                : _BMDPixelFormat;
    FFlags                      : _BMDFrameFlags;
    FRowBytes                   : integer;

    FBytes                      : Pointer;
    FDeckLinkVideoInputFrame    : IDeckLinkVideoInputFrame;
  public
    constructor Create(ADeckLinkVideoInputFrame: IDeckLinkVideoInputFrame = nil);
    destructor Destroy; override;

    function SetWidth(width: Integer): HResult;
    function SetHeight(height: Integer): HResult;
    function SetRowBytes(rowBytes: Integer): HResult;
    function SetPixelFormat(pixelFormat: _BMDPixelFormat): HResult;
    function SetFlags(flags: _BMDFrameFlags): HResult;


    function _Release: Integer; stdcall;
    function _AddRef: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HResult;  stdcall;

    (* IDeckLinkVideoInputFrame *)
    function GetStreamTime(out frameTime: Int64; out frameDuration: Int64; timeScale: Int64): HResult; stdcall;
    function GetHardwareReferenceTimestamp(timeScale: Int64; out frameTime: Int64;
                                           out frameDuration: Int64): HResult; stdcall;
    (* IDeckLinkVideoFrame *)
    function GetWidth: Integer; stdcall;
    function GetHeight: Integer; stdcall;
    function GetRowBytes: Integer; stdcall;
    function GetPixelFormat: _BMDPixelFormat; stdcall;
    function GetFlags: _BMDFrameFlags; stdcall;
    function GetBytes(out buffer: Pointer): HResult; stdcall;
    function GetTimecode(format: _BMDTimecodeFormat; out timecode: IDeckLinkTimecode): HResult; stdcall;
    function GetAncillaryData(out ancillary: IDeckLinkVideoFrameAncillary): HResult; stdcall;
  end;

type
  TDecklinkVideoFrameHelper = record
  public
    class function CreateVideoFrame(width: Integer; height: Integer; rowBytes: Integer;
                              pixelFormat: _BMDPixelFormat; flags: _BMDFrameFlags;
                              var outFrame: TDeckLinkVideoInputFrame): HResult; static;
    class function FillColourBars(theFrame : IDeckLinkVideoFrame; reversed : boolean): HResult; static;
    class function FillBlack(theFrame : IDeckLinkVideoFrame): HResult; static;
    class function GetBytesPerPixel(const pixelFormat: _BMDPixelFormat): integer; static;
  end;

implementation



class function TDecklinkVideoFrameHelper.CreateVideoFrame(width: Integer; height: Integer; rowBytes: Integer;
                              pixelFormat: _BMDPixelFormat; flags: _BMDFrameFlags;
                              var outFrame: TDeckLinkVideoInputFrame): HResult;
begin
  Result := E_NOINTERFACE;
  outFrame := TDeckLinkVideoInputFrame.Create();
  outFrame.SetWidth(width);
  outFrame.SetHeight(height);
  outFrame.SetRowBytes(rowBytes);
  outFrame.SetPixelFormat(pixelFormat);
  outFrame.SetFlags(flags);

  FillColourBars(outFrame, false);

  result := S_OK;
end;

class function TDecklinkVideoFrameHelper.GetBytesPerPixel(const pixelFormat: _BMDPixelFormat): integer;
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

class function TDecklinkVideoFrameHelper.FillBlack(theFrame : IDeckLinkVideoFrame): HResult;
var
  nextword        : pDWORD;
  width           : cardinal;
  height          : cardinal;
  wordsRemaining  : cardinal;
begin
  Result := E_NOINTERFACE;
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

  result := S_OK;
end;

class function TDecklinkVideoFrameHelper.FillColourBars(theFrame : IDeckLinkVideoFrame; reversed : boolean): HResult;
const
  // SD 75% Colour Bars
  gSD75pcColourBars : array[0..7] of cardinal	= ($eb80eb80, $a28ea22c, $832c839c, $703a7048, $54c654b8, $41d44164, $237223d4, $10801080);
  // HD 75% Colour Bars
  gHD75pcColourBars : array[0..7] of cardinal	= ($eb80eb80, $a888a82c, $912c9193, $8534853f, $3fcc3fc1, $33d4336d, $1c781cd4, $10801080);

var
  nextword        : pDWORD;
  bars            : array[0..7] of cardinal;
  width           : integer;
  height          : integer;
  x,y             : integer;
  colourBarCount  : integer;
  pos             : integer;
begin
  Result := E_NOINTERFACE;
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
  result := S_OK;
end;



(* TDeckLinkAudioInputPacket *)
constructor TDeckLinkAudioInputPacket.Create(ADeckLinkAudioInputPacket: IDeckLinkAudioInputPacket = nil);
begin
  m_refCount := 1;
  FBytes := nil;
  FDeckLinkAudioInputPacket := ADeckLinkAudioInputPacket;
	if assigned(FDeckLinkAudioInputPacket) then  FDeckLinkAudioInputPacket._AddRef();
end;


destructor TDeckLinkAudioInputPacket.Destroy;
begin
  if (not assigned(FDeckLinkAudioInputPacket) and assigned(FBytes)) then
    freemem(fBytes);
  if assigned(FDeckLinkAudioInputPacket) then FDeckLinkAudioInputPacket._Release;
	FDeckLinkAudioInputPacket := nil;

  inherited;
end;

function TDeckLinkAudioInputPacket.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TDeckLinkAudioInputPacket._AddRef: Integer;
begin
  result := InterlockedIncrement(m_refCount);
end;

function TDeckLinkAudioInputPacket._Release: Integer;
var
  newRefValue : integer;
begin
	newRefValue := InterlockedDecrement(m_refCount);
	if (newRefValue = 0) then
	begin
		//destroy;
		result := 0;
    exit;
	end;

	result := newRefValue;
end;


procedure TDeckLinkAudioInputPacket.SetSampleFrameCount(SampleFrameCount: Integer);
begin
  FSampleFrameCount := SampleFrameCount;
end;

function TDeckLinkAudioInputPacket.GetSampleFrameCount: Integer; stdcall;
begin
  if assigned(FDeckLinkAudioInputPacket) then
  begin
    result := FDeckLinkAudioInputPacket.GetSampleFrameCount;
  end else
  begin
    result := FSampleFrameCount;
  end;
end;

function TDeckLinkAudioInputPacket.GetBytes(out buffer: Pointer): HResult; stdcall;
begin
  if assigned(FDeckLinkAudioInputPacket) then
  begin
    result := FDeckLinkAudioInputPacket.GetBytes(buffer);
  end else
  begin

    if not assigned(FBytes) then
    begin
      try
        GetMem(FBytes, 1024);
      except
        buffer := nil;
        result := E_NOINTERFACE;
        exit;
      end;
    end;

    buffer := FBytes;
    result := S_OK;
  end;
end;

function TDeckLinkAudioInputPacket.GetPacketTime(out packetTime: Int64; timeScale: Int64): HResult; stdcall;
begin
  if assigned(FDeckLinkAudioInputPacket) then
  begin
    result := FDeckLinkAudioInputPacket.GetPacketTime(packetTime, timeScale)
  end else
  begin
    packetTime  :=  0;
    result := E_NOINTERFACE;
  end;
end;

(* TDeckLinkVideoInputFrame *)
constructor TDeckLinkVideoInputFrame.Create(ADeckLinkVideoInputFrame: IDeckLinkVideoInputFrame = nil);
begin
  inherited Create;
  m_refCount := 1;
  FBytes := nil;
  FFlags := bmdFrameHasVirtual;
  FDeckLinkVideoInputFrame := nil;
  FDeckLinkVideoInputFrame := ADeckLinkVideoInputFrame;
	if assigned(FDeckLinkVideoInputFrame) then  FDeckLinkVideoInputFrame._AddRef();
end;


destructor TDeckLinkVideoInputFrame.Destroy;
begin
  if (not assigned(FDeckLinkVideoInputFrame) and assigned(FBytes)) then
    freemem(fBytes);
  if assigned(FDeckLinkVideoInputFrame) then FDeckLinkVideoInputFrame._Release;
	FDeckLinkVideoInputFrame := nil;

  inherited;
end;

function TDeckLinkVideoInputFrame.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TDeckLinkVideoInputFrame._AddRef: Integer;
begin
  result := InterlockedIncrement(m_refCount);
end;

function TDeckLinkVideoInputFrame._Release: Integer;
var
  newRefValue : integer;
begin
	newRefValue := InterlockedDecrement(m_refCount);
	if (newRefValue = 0) then
	begin
		//destroy;
		result := 0;
    exit;
	end;

	result := newRefValue;
end;


function TDeckLinkVideoInputFrame.SetWidth(width: Integer): HResult;
begin
  result := E_NOINTERFACE;
  if assigned(FDeckLinkVideoInputFrame) then
    exit;

  FWidth := width;
  result := S_OK;
end;

function TDeckLinkVideoInputFrame.SetHeight(height: Integer): HResult;
begin
  result := E_NOINTERFACE ;
  if assigned(FDeckLinkVideoInputFrame) then
    exit;

  FHeight := height;
  result := S_OK;
end;

function TDeckLinkVideoInputFrame.SetRowBytes(rowBytes: Integer): HResult;
begin
  result := E_NOINTERFACE ;
  if assigned(FDeckLinkVideoInputFrame) then
    exit;

  FRowBytes := rowBytes;
  result := S_OK;
end;

function TDeckLinkVideoInputFrame.SetPixelFormat(pixelFormat: _BMDPixelFormat): HResult;
begin
  result := E_NOINTERFACE ;
  if assigned(FDeckLinkVideoInputFrame) then
    exit;

  FPixelFormat := pixelFormat;
  result := S_OK;
end;

function TDeckLinkVideoInputFrame.SetFlags(flags: _BMDFrameFlags): HResult;
begin
  result := E_NOINTERFACE ;
  if assigned(FDeckLinkVideoInputFrame) then
    exit;

  FFlags := FFlags or flags;
  result := S_OK;
end;

(* IDeckLinkVideoInputFrame *)
function TDeckLinkVideoInputFrame.GetStreamTime(out frameTime: Int64; out frameDuration: Int64; timeScale: Int64): HResult;
begin
  if assigned(FDeckLinkVideoInputFrame) then
  begin
    result := FDeckLinkVideoInputFrame.GetStreamTime(frameTime, frameDuration, timeScale);
  end else
  begin
    frameTime := 1 * timeScale;
    result := S_OK;
  end;
end;

function TDeckLinkVideoInputFrame.GetHardwareReferenceTimestamp(timeScale: Int64; out frameTime: Int64;
                                           out frameDuration: Int64): HResult;
begin
  if assigned(FDeckLinkVideoInputFrame) then
  begin
    result := FDeckLinkVideoInputFrame.GetHardwareReferenceTimestamp(timeScale, frameTime, frameDuration);
  end else
  begin
    result := E_NOINTERFACE;
  end;
end;

(* IDeckLinkVideoFrame *)
function TDeckLinkVideoInputFrame.GetWidth(): integer;
begin
  if not assigned(FDeckLinkVideoInputFrame) then
    result := FWidth
  else
	  result := FDeckLinkVideoInputFrame.GetWidth();
end;

function TDeckLinkVideoInputFrame.GetHeight(): integer;
begin
  if not assigned(FDeckLinkVideoInputFrame) then
    result := FHeight
  else
	  result := FDeckLinkVideoInputFrame.GetHeight();
end;

function TDeckLinkVideoInputFrame.GetRowBytes(): integer;
begin
  if assigned(FDeckLinkVideoInputFrame) then
  result := FDeckLinkVideoInputFrame.GetRowBytes()
    else
  result :=FRowBytes
end;

function TDeckLinkVideoInputFrame.GetPixelFormat(): _BMDPixelFormat;
begin
  if not assigned(FDeckLinkVideoInputFrame) then
    result := FPixelFormat
  else
	  result := FDeckLinkVideoInputFrame.GetPixelFormat();
end;

function TDeckLinkVideoInputFrame.GetFlags(): _BMDFrameFlags;
begin
  if not assigned(FDeckLinkVideoInputFrame) then
    result := FFlags
  else
	  result := FDeckLinkVideoInputFrame.GetFlags();
end;

function TDeckLinkVideoInputFrame.GetBytes(out buffer: Pointer): HResult;
begin
  if assigned(FDeckLinkVideoInputFrame) then
  begin
    result := FDeckLinkVideoInputFrame.GetBytes(buffer);
  end else
  begin

    if not assigned(FBytes) then
    begin
      try
        GetMem(FBytes, FRowBytes * FHeight);
      except
        buffer := nil;
        result := E_NOINTERFACE;
        exit;
      end;
    end;


    buffer := FBytes;
    result := S_OK;
  end;
end;

function TDeckLinkVideoInputFrame.GetTimecode(format: _BMDTimecodeFormat; out timecode: IDeckLinkTimecode): HResult;
begin
  if not assigned(FDeckLinkVideoInputFrame) then
  begin
    timecode  :=  nil;
    result := E_NOINTERFACE;
  end else
	  result := FDeckLinkVideoInputFrame.GetTimecode(format, timecode);
end;

function TDeckLinkVideoInputFrame.GetAncillaryData(out ancillary: IDeckLinkVideoFrameAncillary): HResult;
begin
  if not assigned(FDeckLinkVideoInputFrame) then
  begin
    ancillary := nil;
    result := E_NOINTERFACE;
  end else
	  result := FDeckLinkVideoInputFrame.GetAncillaryData(ancillary);
end;


end.
