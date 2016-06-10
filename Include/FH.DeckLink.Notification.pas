unit FH.DeckLink.Notification;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, Winapi.ActiveX, System.syncobjs, DeckLinkAPI_TLB_10_5;

type
  TDeviceNotification = reference to procedure(param1: Largeuint; param2: Largeuint);


  TDeckLinkNotification = class(TInterfacedObject, IDeckLinkNotificationCallback)
  private
    FRefCount             : integer;
    FDeckLink             : IDecklink;
    FDeckLinkNotification : IDeckLinkNotification;

    FPreferencesChanged   : TDeviceNotification;
    FDeviceRemoved        : TDeviceNotification;
    FHardwareConfigurationChanged : TDeviceNotification;
    FStatusChanged        : TDeviceNotification;

    procedure DoStatusChanged(param1: Largeuint; param2: Largeuint);
    procedure DoHardwareConfigurationChanged(param1: Largeuint; param2: Largeuint);
    procedure DoDeviceRemoved(param1: Largeuint; param2: Largeuint);
    procedure DoPreferencesChanged(param1: Largeuint; param2: Largeuint);

    procedure SetStatusChanged(AValue: TDeviceNotification);
    procedure SetHardwareConfigurationChanged(AValue: TDeviceNotification);
    procedure SetDeviceRemoved(AValue: TDeviceNotification);
    procedure SetPreferencesChanged(AValue: TDeviceNotification);
  public
    constructor Create(ADeckLink: IDecklink);
    destructor Destroy; override;

    property OnPreferencesChanged: TDeviceNotification read FPreferencesChanged write SetPreferencesChanged;
    property OnDeviceRemoved: TDeviceNotification read FDeviceRemoved write SetDeviceRemoved;
    property OnHardwareConfigurationChanged: TDeviceNotification read FHardwareConfigurationChanged write SetHardwareConfigurationChanged;
    property OnStatusChanged: TDeviceNotification read FStatusChanged write SetStatusChanged;

    function _Release: Integer;  stdcall;
    function _AddRef: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;

	  (* IDeckLinkNotificationCallback methods *)
    function Notify(topic: _BMDNotifications; param1: Largeuint; param2: Largeuint): HResult; stdcall;

  end;

implementation

(* TDeckLinkDevice *)
constructor TDeckLinkNotification.Create(ADeckLink: IDecklink);
var
  LHr : HResult;
begin
  FRefCount := 1;
  FDeckLink := nil;
  FDeckLink := ADeckLink;

  if FDeckLink = nil then
    Exception.Create('IDecklink is nil');

  // Query the DeckLink for its IID_IDeckLinkNotification interface
  LHr := FDeckLink.QueryInterface(IID_IDeckLinkNotification, FDeckLinkNotification);
  if LHr<>S_OK then
  begin
    raise Exception.CreateFmt('Could not obtain the IDeckLinkNotification interface - result = %08x', [LHr]);
  end;

end;


destructor TDeckLinkNotification.Destroy;
begin
  if assigned(FPreferencesChanged) then
    FDeckLinkNotification.Unsubscribe(bmdPreferencesChanged, self);
  if assigned(FDeviceRemoved) then
    FDeckLinkNotification.Unsubscribe(bmdDeviceRemoved, self);
  if assigned(FHardwareConfigurationChanged) then
    FDeckLinkNotification.Unsubscribe(bmdHardwareConfigurationChanged, self);
  if assigned(FStatusChanged) then
    FDeckLinkNotification.Unsubscribe(bmdStatusChanged, self);
  FRefCount := 0;
  inherited;
end;


function TDeckLinkNotification.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TDeckLinkNotification._AddRef: Integer;
begin
  result := InterlockedIncrement(FRefCount);
end;

function TDeckLinkNotification._Release: Integer;
var
  newRefValue : integer;
begin
	newRefValue := InterlockedDecrement(FRefCount);
	if (newRefValue = 0) then
	begin
		result := 0;
    exit;
	end;
	result := newRefValue;
end;


procedure TDeckLinkNotification.SetPreferencesChanged(AValue: TDeviceNotification);
var
  LHr : HResult;
begin
  LHr := FDeckLinkNotification.Subscribe(bmdPreferencesChanged, self);
  if LHr = S_OK then FPreferencesChanged := AValue;
end;

procedure TDeckLinkNotification.SetDeviceRemoved(AValue: TDeviceNotification);
var
  LHr : HResult;
begin
  LHr := FDeckLinkNotification.Subscribe(bmdDeviceRemoved, self);
  if LHr = S_OK then FDeviceRemoved := AValue;
end;

procedure TDeckLinkNotification.SetHardwareConfigurationChanged(AValue: TDeviceNotification);
var
  LHr : HResult;
begin
  LHr := FDeckLinkNotification.Subscribe(bmdHardwareConfigurationChanged, self);
  if LHr = S_OK then FHardwareConfigurationChanged := AValue;
end;

procedure TDeckLinkNotification.SetStatusChanged(AValue: TDeviceNotification);
var
  LHr : HResult;
begin
  LHr := FDeckLinkNotification.Subscribe(bmdStatusChanged, self);
  if LHr = S_OK then FStatusChanged := AValue;
end;


procedure TDeckLinkNotification.DoPreferencesChanged(param1: Largeuint; param2: Largeuint);
begin
  if assigned(FPreferencesChanged) then
    FPreferencesChanged(param1, param2);
end;

procedure TDeckLinkNotification.DoDeviceRemoved(param1: Largeuint; param2: Largeuint);
begin
  if assigned(FDeviceRemoved) then
    FDeviceRemoved(param1, param2);
end;

procedure TDeckLinkNotification.DoHardwareConfigurationChanged(param1: Largeuint; param2: Largeuint);
begin
  if assigned(FHardwareConfigurationChanged) then
    FHardwareConfigurationChanged(param1, param2);
end;

procedure TDeckLinkNotification.DoStatusChanged(param1: Largeuint; param2: Largeuint);
begin
  if assigned(FStatusChanged) then
    FStatusChanged(param1, param2);
end;

function TDeckLinkNotification.Notify(topic: _BMDNotifications; param1: Largeuint; param2: Largeuint): HResult;
begin
  case topic of
    bmdPreferencesChanged : DoPreferencesChanged(param1, param2);
    bmdDeviceRemoved : DoDeviceRemoved(param1, param2);
    bmdHardwareConfigurationChanged : DoHardwareConfigurationChanged(param1, param2);
    bmdStatusChanged : DoStatusChanged(param1, param2);
  end;
  result := S_OK;
end;


end.
