unit FH.DeckLink;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, Winapi.ActiveX, System.syncobjs,
  DeckLinkAPI_TLB_10_5,
  FH.DeckLink.InputFrame,
  FH.DeckLink.Discovery,
  FH.DeckLink.Device,
  FH.DeckLink.Input,
  FH.DeckLink.Utils,
  FH.DeckLink.Notification,
  FH.DeckLink.DisplayMode;

type
  TDeckLinkHandler = class
  private
    FDeckLink               : TDeckLinkDevice;
    FInput                  : TDeckLinkInput;
    FLock                   : TCriticalSection;

    FDeckLinkConfiguration  : IDeckLinkConfiguration;
    FDeckLinkAttributes     : IDeckLinkAttributes;
    FDeckLinkStatus         : IDeckLinkStatus;

    FDeckLinkNotification   : TDeckLinkNotification;
    FPreferencesChanged     : TDeviceNotification;
    FDeviceRemoved          : TDeviceNotification;
    FHardwareConfigurationChanged : TDeviceNotification;
    FStatusChanged          : TDeviceNotification;

    procedure DoDebug(const Msg: String);
    procedure DoStatusChanged(param1: Largeuint; param2: Largeuint);
    procedure DoHardwareConfigurationChanged(param1: Largeuint; param2: Largeuint);
    procedure DoDeviceRemoved(param1: Largeuint; param2: Largeuint);
    procedure DoPreferencesChanged(param1: Largeuint; param2: Largeuint);


    function GetVideoIOSupport: _BMDVideoIOSupport;
    function GetDeviceBusyState: _BMDDeviceBusyState;
  public
    constructor Create(ADeckLink: IDeckLink);
    destructor Destroy; override;

    procedure SetParams(AName: string; AValue: integer); overload;
    procedure SetParams(AName: string; AValue: string); overload;
    procedure SetParams(AName: string; AValue: boolean); overload;

    property Input: TDeckLinkInput read FInput;

    function SupportsPlayback: boolean;
    function SupportsCapture: boolean;
    function SupportsBypass: boolean;
    function SupportsReference: boolean;
    function SupportsFullDuplex: boolean;
    function SupportsInputFormatDetection: boolean;
    function SupportsInternalKeying: boolean;
    function SupportsExternalKeying: boolean;
    function SupportsHDKeying: boolean;
    function GetReferenceSignalLocked: boolean;
    function GetDeviceIsAvailable: boolean;
    function GetDevicePlaybackBusy: boolean;
    function GetDeviceSerialPortBusy: boolean;
    function GetDeviceCaptureBusy: boolean;
    function GetSubDeviceIndex: integer;
    function GetNumberOfSubDevices: integer;
    function GetPersistentID: integer; // A device specific 32bit unique indentifier
    function GetTopologicalID: integer; // An identifier for DeckLink device
    function GetModelName: string;
    function GetDisplayName: string;

    property OnPreferencesChanged: TDeviceNotification read FPreferencesChanged write FPreferencesChanged;
    property OnDeviceRemoved: TDeviceNotification read FDeviceRemoved write FDeviceRemoved;
    property OnHardwareConfigurationChanged: TDeviceNotification read FHardwareConfigurationChanged write FHardwareConfigurationChanged;
    property OnStatusChanged: TDeviceNotification read FStatusChanged write FStatusChanged;
  end;

implementation

(* TDeckLinkDevice *)
constructor TDeckLinkHandler.Create(ADeckLink: IDeckLink);
var
  LHr : HResult;
begin
  inherited Create;
  FInput := nil;
  FDeckLink := nil;
  FDeckLinkAttributes := nil;
  FDeckLinkStatus := nil;
  FDeckLinkConfiguration := nil;
  FDeckLinkNotification := nil;
  FLock := TCriticalSection.Create;

  if ADeckLink = nil then
    Raise Exception.Create('IDeckLink is nil');

  FDeckLink := TDeckLinkDevice.Create(ADeckLink);

   // Query the DeckLink for its IID_IDeckLinkAttributes interface
  LHr := FDeckLink.QueryInterface(IID_IDeckLinkAttributes, FDeckLinkAttributes);
  if LHr<>S_OK then
  begin
    raise Exception.CreateFmt('Could not obtain the IDeckLinkAttributes interface - result = %08x', [LHr]);
  end;

   // Query the DeckLink for its IID_IDeckLinkAttributes interface
  LHr := FDeckLink.QueryInterface(IID_IDeckLinkStatus, FDeckLinkStatus);
  if LHr<>S_OK then
  begin
    raise Exception.CreateFmt('Could not obtain the IID_IDeckLinkStatus interface - result = %08x', [LHr]);
  end;

  // Query the DeckLink for its IID_IDeckLinkConfiguration interface
  LHr := FDeckLink.QueryInterface(IID_IDeckLinkConfiguration, FDeckLinkConfiguration);
  if LHr<>S_OK then
  begin
    raise Exception.CreateFmt('Could not obtain the IDeckLinkConfiguration interface - result = %08x', [LHr]);
  end;


  FDeckLinkNotification := TDeckLinkNotification.Create(FDeckLink);
  FDeckLinkNotification.OnPreferencesChanged := procedure (param1: Largeuint; param2: Largeuint)
  begin
    DoPreferencesChanged(param1, param2);
    DoDebug('OnPreferencesChanged');
  end;
  FDeckLinkNotification.OnDeviceRemoved := procedure (param1: Largeuint; param2: Largeuint)
  begin
    DoDeviceRemoved(param1, param2);
    DoDebug('OnDeviceRemoved');
  end;
  FDeckLinkNotification.OnHardwareConfigurationChanged := procedure (param1: Largeuint; param2: Largeuint)
  begin
    DoHardwareConfigurationChanged(param1, param2);
    DoDebug('OnHardwareConfigurationChanged');
  end;
  FDeckLinkNotification.OnStatusChanged := procedure (param1: Largeuint; param2: Largeuint)
  begin
    DoStatusChanged(param1, param2);
    DoDebug('OnStatusChanged');
  end;


  if SupportsCapture then
  begin
    FInput := TDeckLinkInput.Create;
    FInput.Init(FDeckLink);
  end;
end;


destructor TDeckLinkHandler.Destroy;
begin
  if assigned(FDeckLinkNotification) then
    FDeckLinkNotification.Destroy;

  if assigned(FInput) then
    FInput.Destroy;

  FDeckLink.Destroy;

  FreeAndNil(FLock);
  inherited;
end;

procedure TDeckLinkHandler.DoDebug(const Msg: String);
begin
  OutputDebugString(PChar(Msg))
end;

procedure TDeckLinkHandler.DoPreferencesChanged(param1: Largeuint; param2: Largeuint);
begin
  if assigned(FPreferencesChanged) then
    FPreferencesChanged(param1, param2);
end;

procedure TDeckLinkHandler.DoDeviceRemoved(param1: Largeuint; param2: Largeuint);
begin
  if assigned(FDeviceRemoved) then
    FDeviceRemoved(param1, param2);
end;

procedure TDeckLinkHandler.DoHardwareConfigurationChanged(param1: Largeuint; param2: Largeuint);
begin
  if assigned(FHardwareConfigurationChanged) then
    FHardwareConfigurationChanged(param1, param2);
end;

procedure TDeckLinkHandler.DoStatusChanged(param1: Largeuint; param2: Largeuint);
begin
  if assigned(FStatusChanged) then
    FStatusChanged(param1, param2);
end;

procedure TDeckLinkHandler.SetParams(AName: string; AValue: integer);
begin
  if SameText('DetectionInputMode', AName) then
  begin
    //FDetectionInputMode := boolean(AValue);
  end else
    raise Exception.Create('Error Message');
end;

procedure TDeckLinkHandler.SetParams(AName: string; AValue: string);
begin
  if AValue.IsEmpty then exit;
  if SameText('bmdDeckLinkConfigVideoInputConnection', AName) then
  begin
    Self.Input.SetParams('bmdDeckLinkConfigVideoInputConnection', AValue);
  end else
  if SameText('bmdDeckLinkConfigVideoInputDisplayMode', AName) then
  begin
    Self.Input.SetParams('bmdDeckLinkConfigVideoInputDisplayMode', AValue);
  end else
  if SameText('bmdDeckLinkConfigVideoInputPixelFormat', AName) then
  begin
    Self.Input.SetParams('bmdDeckLinkConfigVideoInputPixelFormat', AValue);
  end else
  if SameText('bmdDeckLinkConfigAudioInputConnection', AName) then
  begin
    Self.Input.SetParams('bmdDeckLinkConfigAudioInputConnection', AValue);
  end else
  if SameText('bmdDeckLinkConfigAudioInputSampleRate', AName) then
  begin
    Self.Input.SetParams('bmdDeckLinkConfigAudioInputSampleRate', AValue);
  end else
  if SameText('bmdDeckLinkConfigAudioInputSampleType', AName) then
  begin
    Self.Input.SetParams('bmdDeckLinkConfigAudioInputSampleType', AValue);
  end else
  if SameText('bmdDeckLinkConfigAudioInputChannelCount', AName) then
  begin
    Self.Input.SetParams('bmdDeckLinkConfigAudioInputChannelCount', AValue);
  end else
    raise Exception.Create('Error Message');
end;

procedure TDeckLinkHandler.SetParams(AName: string; AValue: boolean);
begin
  if SameText('DetectionInputMode', AName) then
  begin
    //DetectionInputMode := AValue;
  end else
    raise Exception.Create('Error Message');
end;


function TDeckLinkHandler.SupportsFullDuplex: boolean;
var
  LHr : HResult;
  LValueFlag : integer;
begin
  result := false;
  LHr := FDeckLinkAttributes.GetFlag(BMDDeckLinkSupportsFullDuplex, LValueFlag);
  if LHr = S_OK then result := Boolean(LValueFlag);
end;

function TDeckLinkHandler.SupportsReference: boolean;
var
  LHr : HResult;
  LValueFlag : integer;
begin
  result := false;
  LHr := FDeckLinkAttributes.GetFlag(BMDDeckLinkHasReferenceInput, LValueFlag);
  if LHr = S_OK then result := Boolean(LValueFlag);
end;

function TDeckLinkHandler.GetReferenceSignalLocked: boolean;
var
  LHr : HResult;
  LValueFlag : integer;
begin
  result := false;
  LHr := FDeckLinkStatus.GetFlag(bmdDeckLinkStatusReferenceSignalLocked, LValueFlag);
  if LHr = S_OK then result := Boolean(LValueFlag);
end;

function TDeckLinkHandler.SupportsBypass: boolean;
var
  LHr : HResult;
  LValueFlag : integer;
begin
  result := false;
  LHr := FDeckLinkAttributes.GetFlag(BMDDeckLinkHasBypass, LValueFlag);
  if LHr = S_OK then result := Boolean(LValueFlag);
end;


function TDeckLinkHandler.GetDeviceBusyState: _BMDDeviceBusyState;
var
  LHr : HResult;
  LValueInt : int64;
begin
  result := $00000010;
  LHr := FDeckLinkAttributes.GetInt(BMDDeckLinkDeviceBusyState, LValueInt);
  if LHr = S_OK then result := _BMDDeviceBusyState(LValueInt);
end;


function TDeckLinkHandler.GetDeviceIsAvailable: boolean;
var
  LHr : HResult;
  LValueInt : int64;
begin
  result := false;
  if GetDeviceBusyState = 0 then
    result := true;
end;

function TDeckLinkHandler.GetDeviceCaptureBusy: boolean;
var
  LHr : HResult;
  LValueInt : int64;
begin
  result := false;
  if GetDeviceBusyState = bmdDeviceCaptureBusy then
    result := true;
end;

function TDeckLinkHandler.GetDeviceSerialPortBusy: boolean;
var
  LHr : HResult;
  LValueInt : int64;
begin
  result := false;
  if GetDeviceBusyState = bmdDeviceSerialPortBusy then
    result := true;
end;

function TDeckLinkHandler.GetDevicePlaybackBusy: boolean;
var
  LHr : HResult;
  LValueInt : int64;
begin
  result := false;
  if GetDeviceBusyState = bmdDevicePlaybackBusy then
    result := true;
end;

function TDeckLinkHandler.GetPersistentID: integer;
var
  LHr : HResult;
  LValueInt : int64;
begin
  result := -1;
  (* Get BMDDeckLinkPersistentID *)
  LHr := FDeckLinkAttributes.GetInt(BMDDeckLinkPersistentID, LValueInt);
  case LHr of
    S_OK:
    begin
      result := LValueInt;
    end;
    E_FAIL: raise Exception.CreateFmt('Could not get BMDDeckLinkPersistentID - result = %08x', [LHr]);
  end;
end;

function TDeckLinkHandler.GetTopologicalID: integer;
var
  LHr : HResult;
  LValueInt : int64;
begin
  result := -1;
  (* Get BMDDeckLinkTopologicalID *)
  LHr := FDeckLinkAttributes.GetInt(BMDDeckLinkTopologicalID, LValueInt);
  case LHr of
    S_OK:
    begin
      result := LValueInt;
    end;
    E_FAIL: raise Exception.CreateFmt('Could not get BMDDeckLinkTopologicalID - result = %08x', [LHr]);
  end;
end;

function TDeckLinkHandler.SupportsInputFormatDetection: boolean;
var
  LHr : HResult;
  LValueFlag : integer;
begin
  result := false;
  (* Get BMDDeckLinkSupportsInputFormatDetection *)
  LHr := FDeckLinkAttributes.GetFlag(BMDDeckLinkSupportsInputFormatDetection, LValueFlag);
  case LHr of
    S_OK: result := Boolean(LValueFlag);
    E_FAIL: raise Exception.CreateFmt('Could not set BMDDeckLinkSupportsInputFormatDetection - result = %08x', [LHr]);
  end;
end;

function TDeckLinkHandler.SupportsInternalKeying: boolean;
var
  LHr : HResult;
  LValueFlag : integer;
begin
  result := false;
  (* Get BMDDeckLinkSupportsInternalKeying *)
  LHr := FDeckLinkAttributes.GetFlag(BMDDeckLinkSupportsInternalKeying, LValueFlag);
  case LHr of
    S_OK: result := Boolean(LValueFlag);
    E_FAIL: raise Exception.CreateFmt('Could not set BMDDeckLinkSupportsInternalKeying - result = %08x', [LHr]);
  end;
end;

function TDeckLinkHandler.SupportsExternalKeying: boolean;
var
  LHr : HResult;
  LValueFlag : integer;
begin
  result := false;
  (* Get BMDDeckLinkSupportsExternalKeying *)
  LHr := FDeckLinkAttributes.GetFlag(BMDDeckLinkSupportsExternalKeying, LValueFlag);
  case LHr of
    S_OK: result := Boolean(LValueFlag);
    E_FAIL: raise Exception.CreateFmt('Could not set BMDDeckLinkSupportsExternalKeying - result = %08x', [LHr]);
  end;
end;

function TDeckLinkHandler.SupportsHDKeying: boolean;
var
  LHr : HResult;
  LValueFlag : integer;
begin
  result := false;
  (* Get BMDDeckLinkSupportsHDKeying *)
  LHr := FDeckLinkAttributes.GetFlag(BMDDeckLinkSupportsHDKeying, LValueFlag);
  case LHr of
    S_OK: result := Boolean(LValueFlag);
    E_FAIL: raise Exception.CreateFmt('Could not set BMDDeckLinkSupportsHDKeying - result = %08x', [LHr]);
  end;
end;

function TDeckLinkHandler.GetDisplayName: string;
var
  LHr : HResult;
  LValueStr : widestring;
begin
  result := '';
  (* Get BMDDeckLinkTopologicalID *)
  LHr := FDeckLink.GetDisplayName(LValueStr);
  case LHr of
    S_OK:
    begin
      result := LValueStr;
    end;
    E_FAIL: raise Exception.CreateFmt('Could not get DisplayName - result = %08x', [LHr]);
  end;
end;

function TDeckLinkHandler.GetModelName: string;
var
  LHr : HResult;
  LValueStr : widestring;
begin
  result := '';
  (* Get BMDDeckLinkTopologicalID *)
  LHr := FDeckLink.GetModelName(LValueStr);
  case LHr of
    S_OK:
    begin
      result := LValueStr;
    end;
    E_FAIL: raise Exception.CreateFmt('Could not get ModelName - result = %08x', [LHr]);
  end;
end;

function TDeckLinkHandler.GetSubDeviceIndex: integer;
var
  LHr : HResult;
  LValueInt : int64;
begin
  result := -1;
  (* Get current VideoInput Connection *)
  LHr := FDeckLinkAttributes.GetInt(BMDDeckLinkNumberOfSubDevices, LValueInt);
  case LHr of
    S_OK:
    begin
      if LValueInt > 0 then
      begin
        (* Get current VideoInput Connection *)
        LHr := FDeckLinkAttributes.GetInt(BMDDeckLinkSubDeviceIndex, LValueInt);
        case LHr of
          S_OK:
          begin
            result := LValueInt;
          end;
          E_FAIL: raise Exception.CreateFmt('Could not get BMDDeckLinkSubDeviceIndex - result = %08x', [LHr]);
        end;
      end else
      begin
        result := 0;
      end;
    end;
    E_FAIL: raise Exception.CreateFmt('Could not get BMDDeckLinkNumberOfSubDevices - result = %08x', [LHr]);
  end;
end;

function TDeckLinkHandler.GetNumberOfSubDevices: integer;
var
  LHr : HResult;
  LValueInt : int64;
begin
  result := -1;
  (* Get BMDDeckLinkNumberOfSubDevices  *)
  LHr := FDeckLinkAttributes.GetInt(BMDDeckLinkNumberOfSubDevices, LValueInt);
  case LHr of
    S_OK:
    begin
      result := LValueInt;
    end;
    E_FAIL: raise Exception.CreateFmt('Could not get BMDDeckLinkNumberOfSubDevices - result = %08x', [LHr]);
  end;
end;

function TDeckLinkHandler.GetVideoIOSupport: _BMDVideoIOSupport;
var
  LHr : HResult;
  LValueInt : int64;
begin
  (* Get current VideoInput Connection *)
  LHr := FDeckLinkAttributes.GetInt(BMDDeckLinkVideoIOSupport, LValueInt);
  case LHr of
    S_OK:
    begin
      result := _BMDVideoIOSupport(LValueInt);
    end;
    E_FAIL: raise Exception.CreateFmt('Could not get BMDDeckLinkVideoIOSupport - result = %08x', [LHr]);
  end;
end;

function TDeckLinkHandler.SupportsCapture: boolean;
begin
  if (GetVideoIOSupport and bmdDeviceSupportsCapture) > 0 then
    result:= true else result := false;
end;

function TDeckLinkHandler.SupportsPlayback: boolean;
begin
  if (GetVideoIOSupport and bmdDeviceSupportsPlayback) > 0 then
    result:= true else result := false;
end;

end.
