unit FH.DeckLink.Vitrual.InputFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.SyncObjs, System.Generics.Collections,
  Winapi.ActiveX, Winapi.DirectShow9, DeckLinkAPI_TLB_10_3_1, FH.DeckLink.DisplayMode;

const
  // SD 75% Colour Bars
  gSD75pcColourBars : array[0..7] of cardinal	= ($eb80eb80, $a28ea22c, $832c839c, $703a7048, $54c654b8, $41d44164, $237223d4, $10801080);

const
  // HD 75% Colour Bars
  gHD75pcColourBars : array[0..7] of cardinal	= ($eb80eb80, $a888a82c, $912c9193, $8534853f, $3fcc3fc1, $33d4336d, $1c781cd4, $10801080);

type
  TVirtualInputFrame = class(TInterfacedObject, IDeckLinkVideoInputFrame)
  private
    m_refCount                  : integer;
    FWidth                      : integer;
    FHeight                     : integer;
    FPixelFormat                : _BMDPixelFormat
    FVirtualFrame               : boolean;
    FBytes                      : Pointer;
    FDeckLinkVideoInputFrame    : IDeckLinkVideoInputFrame;
    function GetBytesPerPixel(const pixelFormat: _BMDPixelFormat): integer;
    Procedure FillColourBars;
    Procedure FillBlack;;
  public
    constructor Create(ADeckLinkVideoInputFrame: IDeckLinkVideoInputFrame);  overload;
    constructor Create(const AWidth: integer; const AHeight: integer; const APixelFormat: _BMDPixelFormat = bmdFormat8BitYUV);  overload;
    destructor Destroy; override;

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

implementation

(* TVirtualInputFrame *)
constructor TVirtualInputFrame.Create(ADeckLinkVideoInputFrame: IDeckLinkVideoInputFrame);
begin
  m_refCount := 1;
  FBytes := nil;
  FDeckLinkVideoInputFrame := ADeckLinkVideoInputFrame;
	if assigned(FDeckLinkVideoInputFrame) then  FDeckLinkVideoInputFrame._AddRef();
end;

constructor TVirtualInputFrame.Create(ADeckLinkVideoInputFrame: IDeckLinkVideoInputFrame; const AWidth: integer; const AHeight: integer; const APixelFormat: _BMDPixelFormat = bmdFormat8BitYUV);
begin
  m_refCount := 1;
  FBytes := nil;
  FDeckLinkVideoInputFrame := nil;
  FWidth := AWidth;
  FHeight := AHeight;
  FPixelFormat := APixelFormat;
  FVirtualFrame:=true;

  FBytes:=AllocMem(FWidth * FHeight * GetBytesPerPixel(FPixelFormat));


end;

destructor TVirtualInputFrame.Destroy;
begin
  if assigned(FDeckLinkVideoInputFrame) then FDeckLinkVideoInputFrame._Release;
	FDeckLinkVideoInputFrame := nil;

  if FVirtualFrame then  freemem(fBytes);

  inherited;
end;

function TVirtualInputFrame.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TVirtualInputFrame._AddRef: Integer;
begin
  result := InterlockedIncrement(m_refCount);
end;

function TVirtualInputFrame._Release: Integer;
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


function TVirtualInputFrame.GetBytesPerPixel(const pixelFormat: _BMDPixelFormat): integer;
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

Procedure TVirtualInputFrame.FillBlack;
var
  nextword        : pDWORD;
  width           : cardinal;
  height          : cardinal;
  wordsRemaining  : cardinal;
begin
  FBytes := Pointer(nextword));
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

Procedure TVirtualInputFrame.FillColourBars;
var
  nextword        : pDWORD;
  bars            : array[0..7] of cardinal;
  width           : integer;
  height          : integer;
  x,y             : integer;
  colourBarCount  : integer;
  pos             : integer;
begin

	FBytes := Pointer(nextWord);
	width := GetWidth();
	height := GetHeight();

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

      nextword^:= bars[pos];
      inc(nextword, 1);

      inc(x, 2);
    end;
  end;
end;

(* IDeckLinkVideoInputFrame *)
function TVirtualInputFrame.GetStreamTime(out frameTime: Int64; out frameDuration: Int64; timeScale: Int64): HResult;
begin
  result := FDeckLinkVideoInputFrame.GetStreamTime(frameTime, frameDuration, timeScale);
end;

function TVirtualInputFrame.GetHardwareReferenceTimestamp(timeScale: Int64; out frameTime: Int64;
                                           out frameDuration: Int64): HResult;
begin
  result := FDeckLinkVideoInputFrame.GetHardwareReferenceTimestamp(timeScale, frameTime, frameDuration);
end;

(* IDeckLinkVideoFrame *)
function TVirtualInputFrame.GetWidth(): integer;
begin
	result := FDeckLinkVideoInputFrame.GetWidth();
end;

function TVirtualInputFrame.GetHeight(): integer;
begin
	result := FDeckLinkVideoInputFrame.GetHeight();
end;

function TVirtualInputFrame.GetRowBytes(): integer;
begin
	result := FDeckLinkVideoInputFrame.GetRowBytes();
end;

function TVirtualInputFrame.GetPixelFormat(): _BMDPixelFormat;
begin
	result := FDeckLinkVideoInputFrame.GetPixelFormat();
end;

function TVirtualInputFrame.GetFlags(): _BMDFrameFlags;
begin
	result := FDeckLinkVideoInputFrame.GetFlags();
end;

function TVirtualInputFrame.GetBytes(out buffer: Pointer): HResult;
begin
	result := FDeckLinkVideoInputFrame.GetBytes(buffer);
end;

function TVirtualInputFrame.GetTimecode(format: _BMDTimecodeFormat; out timecode: IDeckLinkTimecode): HResult;
begin
	result := FDeckLinkVideoInputFrame.GetTimecode(format, timecode);
end;

function TVirtualInputFrame.GetAncillaryData(out ancillary: IDeckLinkVideoFrameAncillary): HResult;
begin
	result := FDeckLinkVideoInputFrame.GetAncillaryData(ancillary);
end;


end.
