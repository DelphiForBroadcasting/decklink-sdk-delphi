unit FH.DeckLink.Discovery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, Winapi.ActiveX, System.syncobjs,
  DeckLinkAPI_TLB_10_5,
  FH.DeckLink.VirtualDevice,
  FH.DeckLink.Utils;

type
  _bmdDiscoverStatus = (BMD_ADD_DEVICE, BMD_REMOVE_DEVICE);

  TDeviceChangeNotify = reference to procedure(const status: _bmdDiscoverStatus; const deckLinkDevice: IDeckLink);

  TBMDDiscovery = class(TInterfacedObject, IDeckLinkDeviceNotificationCallback)
  private
    m_deckLinkDiscovery : IDeckLinkDiscovery;
    m_refCount          : integer;

    FEnabledVirtual     : boolean;

    m_pDeckLink         : TList<IDeckLink>;

    FOnDeviceChange     : TDeviceChangeNotify;
    FLock               : TCriticalSection;
    procedure DoDeviceChange(const status: _bmdDiscoverStatus; const deckLinkDevice: IDeckLink);

  public
    constructor Create(AEnabledVirtual: boolean = false);
    destructor Destroy; override;
	  function Enable(): boolean;
	  procedure Disable();

    function GetDevice(const AId: integer): IDecklink; Overload;
    function GetDevice(const AName: string): IDecklink; Overload;


	  // IDeckLinkDeviceNotificationCallback methods
    function DeckLinkDeviceArrived(const deckLinkDevice: IDeckLink): HResult; stdcall;
    function DeckLinkDeviceRemoved(const deckLinkDevice: IDeckLink): HResult; stdcall;

    function _Release: Integer;  stdcall;
    function _AddRef: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;

    property OnDeviceChange: TDeviceChangeNotify read FOnDeviceChange write FOnDeviceChange;

    property Devices: TList<IDeckLink> read m_pDeckLink;
  end;

implementation

(* TBMDDiscovery *)
constructor TBMDDiscovery.Create(AEnabledVirtual: boolean = false);
begin
  FLock := TCriticalSection.Create;
  FEnabledVirtual := AEnabledVirtual;
  m_pDeckLink := TList<IDeckLink>.create;

  m_deckLinkDiscovery := nil;
  m_refCount := 1;

	if (CoCreateInstance(CLASS_CDeckLinkDiscovery, nil, CLSCTX_ALL, IID_IDeckLinkDiscovery, m_deckLinkDiscovery) <> S_OK) then
		m_deckLinkDiscovery := nil;
end;

destructor TBMDDiscovery.Destroy;
var
  i : integer;
begin
	if assigned(m_deckLinkDiscovery) then
  begin
		m_deckLinkDiscovery.UninstallDeviceNotifications();
		m_deckLinkDiscovery := nil;
  end;

  m_pDeckLink.Clear;
  FreeAndNil(m_pDeckLink);
  FreeAndNil(FLock);

  inherited;
end;

function TBMDDiscovery.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TBMDDiscovery._AddRef: Integer;
begin
  result := InterlockedIncrement(m_refCount);
end;

function TBMDDiscovery._Release: Integer;
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

function  TBMDDiscovery.Enable(): boolean;
var
  hr : HRESULT;
begin
  hr := E_FAIL;

	// Install device arrival notifications
	if (m_deckLinkDiscovery <> nil) then
		hr := m_deckLinkDiscovery.InstallDeviceNotifications(self);


  if FEnabledVirtual then
    DoDeviceChange(BMD_ADD_DEVICE, TVirtualDevice.Create);

	result:= hr = S_OK;
end;

procedure TBMDDiscovery.Disable();
begin
	// Uninstall device arrival notifications
	if assigned(m_deckLinkDiscovery) then
  begin
		m_deckLinkDiscovery.UninstallDeviceNotifications();
  end;
end;

function TBMDDiscovery.GetDevice(const AId: integer): IDecklink;
var
  i             : integer;
begin
  result := nil;
  for i := 0 to m_pDeckLink.Count - 1 do
  begin
    if i = AId then
    begin
      result :=  m_pDeckLink.Items[i];
      break
    end;
  end;
end;

function TBMDDiscovery.GetDevice(const AName: string): IDecklink;
var
  i             : integer;
  LModelName    : widestring;
  LDisplayName  : widestring;
begin
  result := nil;
  if AName.Length = 0 then exit;
  for i := 0 to m_pDeckLink.Count - 1 do
  begin
    m_pDeckLink.Items[i].GetModelName(LModelName);
    m_pDeckLink.Items[i].GetDisplayName(LDisplayName);
    if sametext(LModelName, AName) or sametext(LDisplayName, AName) then
    begin
      result :=  m_pDeckLink.Items[i];
      break
    end;
  end;
end;


function TBMDDiscovery.DeckLinkDeviceArrived(const deckLinkDevice: IDeckLink): HResult;
begin
	deckLinkDevice._AddRef;
  DoDeviceChange(BMD_ADD_DEVICE, deckLinkDevice);
	result := S_OK;
end;

function TBMDDiscovery.DeckLinkDeviceRemoved(const deckLinkDevice: IDeckLink): HResult;
var
  itemIndex : integer;
begin
  DoDeviceChange(BMD_REMOVE_DEVICE, deckLinkDevice);
	deckLinkDevice._Release();
	result := S_OK;
end;

procedure TBMDDiscovery.DoDeviceChange(const status: _bmdDiscoverStatus; const deckLinkDevice: IDeckLink);
var
  itemIndex : integer;
begin
  case status of
    BMD_ADD_DEVICE:
    begin
      m_pDeckLink.Add(deckLinkDevice);
    end;
    BMD_REMOVE_DEVICE:
    begin
      itemIndex := m_pDeckLink.IndexOf(deckLinkDevice);
      if itemIndex>=0 then
      begin
        m_pDeckLink.Delete(itemIndex);
      end;
    end;
  end;

  if assigned(FOnDeviceChange) then
  begin
    FLock.Acquire;
    try
      FOnDeviceChange(status, deckLinkDevice);
    finally
      FLock.Release;
    end;
  end;
end;


end.
