unit FH.DeckLink.DisplayMode;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.SyncObjs, System.Generics.Collections,
  Winapi.ActiveX, Winapi.DirectShow9, DeckLinkAPI_TLB_10_5, FH.DeckLink.Utils;

Type
  TDeckLinkDisplayMode = class(TInterfacedObject, IDeckLinkDisplayMode)
    FRefCount             : integer;

    FDisplayMode          : _BMDDisplayMode;
    FModeName             : WideString;

    FWidth                : integer;
    FHeight               : integer;


    FTimeScale            : Int64;
    FFrameDuration        : Int64;

    FFieldDominance       : _BMDFieldDominance;

    FFlags                : _BMDDisplayModeFlags;

    FDeckLinkDisplayMode  : IDeckLinkDisplayMode;
  public
    constructor Create(ADisplayMode: _BMDDisplayMode) overload;
    constructor Create(ADisplayMode: IDeckLinkdisplayMode) overload;

    destructor Destroy; override;
    procedure InitDisplayMode(ADisplayMode    : _BMDDisplayMode);

    function _Release: Integer; stdcall;
    function _AddRef: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HResult;  stdcall;

    (* IDeckLinkDisplayMode methods *)
    function GetName(out name: WideString): HResult; stdcall;
    function GetDisplayMode: _BMDDisplayMode; stdcall;
    function GetWidth: Integer; stdcall;
    function GetHeight: Integer; stdcall;
    function GetFrameRate(out frameDuration: Int64; out timeScale: Int64): HResult; stdcall;
    function GetFieldDominance: _BMDFieldDominance; stdcall;
    function GetFlags: _BMDDisplayModeFlags; stdcall;
  end;


implementation


(* TDeckLinkDisplayMode *)
constructor TDeckLinkDisplayMode.Create(ADisplayMode  : IDeckLinkDisplayMode);
begin
  FRefCount := 1;
  FDeckLinkDisplayMode := ADisplayMode;
end;

constructor TDeckLinkDisplayMode.Create(ADisplayMode: _BMDDisplayMode);
begin
  FRefCount := 1;
  FDeckLinkDisplayMode := nil;
  InitDisplayMode(ADisplayMode);
end;

destructor TDeckLinkdisplayMode.Destroy;
begin
  FRefCount := 0;
  inherited;
end;

function TDeckLinkDisplayMode.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TDeckLinkDisplayMode._AddRef: Integer;
begin
  result := InterlockedIncrement(FRefCount);
end;

function TDeckLinkDisplayMode._Release: Integer;
var
  newRefValue : integer;
begin
	newRefValue := InterlockedDecrement(FRefCount);
	if (newRefValue = 0) then
	begin
		//destroy;
		result := 0;
    exit;
	end;

	result := newRefValue;
end;

procedure TDeckLinkDisplayMode.InitDisplayMode(ADisplayMode    : _BMDDisplayMode);
begin
  FModeName := TBMDDisplayMode.Create(ADisplayMode).ModeName;
  FWidth := TBMDDisplayMode.Create(ADisplayMode).Width;
  FHeight := TBMDDisplayMode.Create(ADisplayMode).Height;
  FFrameDuration := TBMDDisplayMode.Create(ADisplayMode).FrameDuration;
  FTimeScale := TBMDDisplayMode.Create(ADisplayMode).TimeScale;
  FDisplayMode := TBMDDisplayMode.Create(ADisplayMode).DisplayMode;
end;

function TDeckLinkDisplayMode.GetName(out name: WideString): HResult; stdcall;
begin
  if assigned(FDeckLinkDisplayMode) then
  begin
    result := FDeckLinkDisplayMode.GetName(name);
  end else
  begin
    name := FModeName;
    result := S_OK;
  end;
end;

function TDeckLinkDisplayMode.GetDisplayMode: _BMDDisplayMode; stdcall;
begin
  if assigned(FDeckLinkDisplayMode) then
  begin
    result := FDeckLinkDisplayMode.GetDisplayMode
  end else
  begin
    result := FDisplayMode
  end;
end;

function TDeckLinkDisplayMode.GetWidth: Integer; stdcall;
begin
  if assigned(FDeckLinkDisplayMode) then
  begin
    result := FDeckLinkDisplayMode.GetWidth;
  end else
  begin
    result := FWidth;
  end;
end;

function TDeckLinkDisplayMode.GetHeight: Integer; stdcall;
begin
  if assigned(FDeckLinkDisplayMode) then
  begin
    result := FDeckLinkDisplayMode.GetHeight;
  end else
  begin
end;
  result := FHeight;
end;

function TDeckLinkDisplayMode.GetFrameRate(out frameDuration: Int64; out timeScale: Int64): HResult; stdcall;
begin
  if assigned(FDeckLinkDisplayMode) then
  begin
    result := FDeckLinkDisplayMode.GetFrameRate(frameDuration, timeScale);
  end else
  begin
    frameDuration := FFrameDuration;
    timeScale := FTimeScale;
    result := S_OK;
  end;
end;

function TDeckLinkDisplayMode.GetFieldDominance: _BMDFieldDominance; stdcall;
begin
  if assigned(FDeckLinkDisplayMode) then
  begin
    result := FDeckLinkDisplayMode.GetFieldDominance;
  end else
  begin
    result := FFieldDominance;
  end;
end;

function TDeckLinkDisplayMode.GetFlags: _BMDDisplayModeFlags;
begin
  if assigned(FDeckLinkDisplayMode) then
  begin
    result := FDeckLinkDisplayMode.GetFlags;
  end else
  begin
    result := FFlags;
  end;
end;

end.
