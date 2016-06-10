unit FH.DeckLink.Device;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, Winapi.ActiveX, System.syncobjs, DeckLinkAPI_TLB_10_5;

type
  TDeckLinkDevice = class(TInterfacedObject, IDeckLink)
  private
    m_refCount          : integer;

    FModelName          : string;
    FDisplayName        : string;

    FDeckLink           : IDeckLink;
    FLock               : TCriticalSection;
  public
    constructor Create(); overload;
    constructor Create(ADeckLink: IDeckLink); overload;
    constructor Create(AModelName: string; ADisplayName : string); overload;
    destructor Destroy; override;

    function _Release: Integer;  stdcall;
    function _AddRef: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;

	  (* IDeckLink methods *)
    function GetModelName(out modelName: WideString): HResult; stdcall;
    function GetDisplayName(out displayName: WideString): HResult; stdcall;

    property DeckLinkInstance: IDeckLink read FDeckLink;
  end;

implementation

(* TDeckLinkDevice *)
constructor TDeckLinkDevice.Create();
begin
  inherited Create;

  m_refCount := 1;
  FDeckLink := nil;
  FLock := TCriticalSection.Create;
end;

constructor TDeckLinkDevice.Create(ADeckLink: IDeckLink);
begin
  Create;

  FDeckLink := ADeckLink;

	if assigned(FDeckLink) then
    FDeckLink._AddRef();

  if not assigned(FDeckLink) then
    Raise Exception.Create('IDeckLink is nil');

end;

constructor TDeckLinkDevice.Create(AModelName: string; ADisplayName : string);
begin
  Create;

  FModelName := AModelName;
  FDisplayName := ADisplayName;

end;

destructor TDeckLinkDevice.Destroy;
begin
	if assigned(FDeckLink) then
  begin
		FDeckLink._Release;
		FDeckLink := nil;
  end;

  FLock.Free;

  inherited;
end;

function TDeckLinkDevice.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  result := FDeckLink.QueryInterface(IID, Obj);
  exit;
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TDeckLinkDevice._AddRef: Integer;
begin
  result := InterlockedIncrement(m_refCount);
end;

function TDeckLinkDevice._Release: Integer;
var
  newRefValue : integer;
begin
	newRefValue := InterlockedDecrement(m_refCount);
	if (newRefValue = 0) then
	begin
		result := 0;
    exit;
	end;
	result := newRefValue;
end;

function TDeckLinkDevice.GetModelName(out modelName: WideString): HResult;
begin
  if assigned(FDeckLink) then
  begin
    result := FDeckLink.GetModelName(modelName)
  end else
  begin
    modelName := WideString(FModelName);
    result := S_OK;
  end;
end;

function TDeckLinkDevice.GetDisplayName(out displayName: WideString): HResult;
begin
  if assigned(FDeckLink) then
  begin
    result := FDeckLink.GetDisplayName(displayName)
  end else
  begin
    displayName := WideString(FDisplayName);
    result := S_OK;
  end;
end;


end.
