unit FH.DeckLink.VirtualDevice;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.SyncObjs, System.Generics.Collections,
  Winapi.ActiveX, Winapi.DirectShow9, DeckLinkAPI_TLB_10_5, FH.DeckLink.DisplayMode, FH.DeckLink.InputFrame, FH.DeckLink.Device;

const
  WM_REFRESH_INPUT_STREAM_DATA_MESSAGE = 701;
  WM_SELECT_VIDEO_MODE_MESSAGE = 702;
  WM_ERROR_RESTARTING_CAPTURE_MESSAGE = 703;


const
  virtualCardName : string = 'Virtual card';


type
  TAVStream = class(TThread)
  private
    FHandles: array[0..1] of THandle;

    (* Video *)
    FEnabledVideo : boolean;
    FDisplayMode  : TDeckLinkDisplayMode;
    FPixelFormat  : _BMDPixelFormat;
    FFlags        : _BMDVideoInputFlags;

    (* Audio *)
    FEnabledAudio : boolean;
    FSampleRate   : _BMDAudioSampleRate;
    FSampleType   : _BMDAudioSampleType;
    FChannelCount : integer;


    FCallback     : IDeckLinkInputCallback;
  protected
    procedure Execute; override;
  public
    constructor create(); overload;
    destructor Destroy; override;
    procedure Terminate;

    function EnableVideoInput(displayMode: _BMDDisplayMode; pixelFormat: _BMDPixelFormat;
                              flags: _BMDVideoInputFlags): HResult;
    function DisableVideoInput: HResult;
    function GetAvailableVideoFrameCount(out availableFrameCount: SYSUINT): HResult;
    function SetVideoInputFrameMemoryAllocator(const theAllocator: IDeckLinkMemoryAllocator): HResult;
    function EnableAudioInput(sampleRate: _BMDAudioSampleRate; sampleType: _BMDAudioSampleType;
                              channelCount: Integer): HResult;
    function DisableAudioInput: HResult;
    function GetAvailableAudioSampleFrameCount(out availableSampleFrameCount: SYSUINT): HResult;
    function StartStreams: HResult;
    function StopStreams: HResult;
    function PauseStreams: HResult;
    function FlushStreams: HResult;
    function SetCallback(const theCallback: IDeckLinkInputCallback): HResult;
    function GetHardwareReferenceClock(desiredTimeScale: Int64; out hardwareTime: Int64;
                                       out timeInFrame: Int64; out ticksPerFrame: Int64): HResult;

  end;

 TVirtualDeviceDisplayModeIterator =  class(TInterfacedObject, IDeckLinkDisplayModeIterator)
    m_refCount            : integer;
    FPos                  : integer;
    FDisplayModes         : TList<TDeckLinkdisplayMode>;
  public
    constructor Create();
    destructor Destroy; override;

    function _Release: Integer; stdcall;
    function _AddRef: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HResult;  stdcall;

    (* IDeckLinkDisplayModeIterator methods *)
    function Next(out deckLinkDisplayMode: IDeckLinkDisplayMode): HResult; stdcall;
  end;


  TVirtualDevice = class(TInterfacedObject, IDeckLink, IDeckLinkInput, {IDeckLinkOutput,} IDeckLinkAttributes, IDeckLinkConfiguration, IDeckLinkStatus, IDeckLinkNotification)
    m_refCount                        : integer;
    FModelName                        : string;
    FDisplayName                      : string;

    FPreviewCallback                  : IDeckLinkScreenPreviewCallback;
    FVirtualDeviceDisplayModeIterator : TVirtualDeviceDisplayModeIterator;

    FAVStream                         : TAVStream;
  public
    constructor Create();
    destructor Destroy; override;

    function _Release: Integer; stdcall;
    function _AddRef: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HResult;  stdcall;

    (* IDeckLink methods *)
    function GetModelName(out modelName: WideString): HResult;  stdcall;
    function GetDisplayName(out displayName: WideString): HResult;  stdcall;


    (* IDeckLinkInput methods *)
    function DoesSupportVideoMode(displayMode: _BMDDisplayMode; pixelFormat: _BMDPixelFormat;
                                  flags: _BMDVideoInputFlags; out return: _BMDDisplayModeSupport;
                                  out resultDisplayMode: IDeckLinkDisplayMode): HResult; stdcall;
    function GetDisplayModeIterator(out iterator: IDeckLinkDisplayModeIterator): HResult; stdcall;
    function SetScreenPreviewCallback(const previewCallback: IDeckLinkScreenPreviewCallback): HResult; stdcall;
    function EnableVideoInput(displayMode: _BMDDisplayMode; pixelFormat: _BMDPixelFormat;
                              flags: _BMDVideoInputFlags): HResult; stdcall;
    function DisableVideoInput: HResult; stdcall;
    function GetAvailableVideoFrameCount(out availableFrameCount: SYSUINT): HResult; stdcall;
    function SetVideoInputFrameMemoryAllocator(const theAllocator: IDeckLinkMemoryAllocator): HResult; stdcall;
    function EnableAudioInput(sampleRate: _BMDAudioSampleRate; sampleType: _BMDAudioSampleType;
                              channelCount: SYSUINT): HResult; stdcall;
    function DisableAudioInput: HResult; stdcall;
    function GetAvailableAudioSampleFrameCount(out availableSampleFrameCount: SYSUINT): HResult; stdcall;
    function StartStreams: HResult; stdcall;
    function StopStreams: HResult; stdcall;
    function PauseStreams: HResult; stdcall;
    function FlushStreams: HResult; stdcall;
    function SetCallback(const theCallback: IDeckLinkInputCallback): HResult; stdcall;
    function GetHardwareReferenceClock(desiredTimeScale: Int64; out hardwareTime: Int64;
                                       out timeInFrame: Int64; out ticksPerFrame: Int64): HResult; stdcall;
    (* IDeckLinkAttributes methods *)
    function GetFlag(cfgID: _BMDDeckLinkAttributeID; out value: Integer): HResult; stdcall;
    function GetInt(cfgID: _BMDDeckLinkAttributeID; out value: Int64): HResult; stdcall;
    function GetFloat(cfgID: _BMDDeckLinkAttributeID; out value: Double): HResult; stdcall;
    function GetString(cfgID: _BMDDeckLinkAttributeID; out value: WideString): HResult; stdcall;

    (* IDeckLinkConfiguration methods *)
    function SetFlag2(cfgID: _BMDDeckLinkConfigurationID; value: Integer): HResult; stdcall;
    function GetFlag2(cfgID: _BMDDeckLinkConfigurationID; out value: Integer): HResult; stdcall;
    function SetInt2(cfgID: _BMDDeckLinkConfigurationID; value: Int64): HResult; stdcall;
    function GetInt2(cfgID: _BMDDeckLinkConfigurationID; out value: Int64): HResult; stdcall;
    function SetFloat2(cfgID: _BMDDeckLinkConfigurationID; value: Double): HResult; stdcall;
    function GetFloat2(cfgID: _BMDDeckLinkConfigurationID; out value: Double): HResult; stdcall;
    function SetString2(cfgID: _BMDDeckLinkConfigurationID; const value: WideString): HResult; stdcall;
    function GetString2(cfgID: _BMDDeckLinkConfigurationID; out value: WideString): HResult; stdcall;
    function WriteConfigurationToPreferences2: HResult; stdcall;
    function IDeckLinkConfiguration.SetFlag = SetFlag2;
    function IDeckLinkConfiguration.GetFlag = GetFlag2;
    function IDeckLinkConfiguration.SetInt = SetInt2;
    function IDeckLinkConfiguration.GetInt = GetInt2;
    function IDeckLinkConfiguration.SetFloat = SetFloat2;
    function IDeckLinkConfiguration.GetFloat = GetFloat2;
    function IDeckLinkConfiguration.SetString = SetString2;
    function IDeckLinkConfiguration.GetString = GetString2;
    function IDeckLinkConfiguration.WriteConfigurationToPreferences = WriteConfigurationToPreferences2;

    (* IDeckLinkStatus methods *)
    function GetFlag3(statusID: _BMDDeckLinkStatusID; out value: Integer): HResult; stdcall;
    function GetInt3(statusID: _BMDDeckLinkStatusID; out value: Int64): HResult; stdcall;
    function GetFloat3(statusID: _BMDDeckLinkStatusID; out value: Double): HResult; stdcall;
    function GetString3(statusID: _BMDDeckLinkStatusID; out value: WideString): HResult; stdcall;
    function GetBytes3(statusID: _BMDDeckLinkStatusID; out buffer: Pointer; out bufferSize: SYSUINT): HResult; stdcall;
    function IDeckLinkStatus.GetFlag =  GetFlag3;
    function IDeckLinkStatus.GetInt = GetInt3;
    function IDeckLinkStatus.GetFloat = GetFloat3;
    function IDeckLinkStatus.GetString = GetString3;
    function IDeckLinkStatus.GetBytes = GetBytes3;

    (* IDeckLinkNotification methods *)
    function Subscribe(topic: _BMDNotifications; const theCallback: IDeckLinkNotificationCallback): HResult; stdcall;
    function Unsubscribe(topic: _BMDNotifications; const theCallback: IDeckLinkNotificationCallback): HResult; stdcall;

  end;


implementation

(* TAVStream *)
constructor TAVStream.create();
begin
  inherited Create(false);

  Priority := TThreadPriority.tpLower;

  FHandles[0] := CreateEvent(nil, False, False, 'FlushStreams');  // ”правление завершением потока
  FHandles[1] := CreateEvent(nil, True, False, 'StartStreams');  // ”правление паузой
  //FHandles[2] := CreateEvent(nil, True, True, 'StopStreams');  // ”правление паузой
  //FHandles[3] := CreateEvent(nil, True, False, 'PauseStreams');  // ”правление паузой
  FreeOnTerminate := True;

  FCallback :=  nil;
  FDisplayMode := nil;
  FPixelFormat := bmdFormat8BitYUV;
  FFlags := bmdVideoInputFlagDefault;
  FEnabledVideo := false;

  FSampleRate   := bmdAudioSampleRate48kHz;
  FSampleType   := bmdAudioSampleType16bitInteger;
  FChannelCount := 2;
  FEnabledAudio := false;

end;

destructor TAVStream.Destroy;
begin
  //CloseHandle(FHandles[3]);
  //CloseHandle(FHandles[2]);
  CloseHandle(FHandles[1]);
  CloseHandle(FHandles[0]);
  inherited Destroy;
end;

procedure TAVStream.Terminate;
begin
  inherited Terminate;
end;

procedure TAVStream.Execute;
var
  FInputFrame : TDeckLinkVideoInputFrame;
begin
  while not Terminated do
  begin
    case WaitForMultipleObjects(2, @FHandles[0], False, INFINITE) of
      WAIT_FAILED       : RaiseLastOsError;
      WAIT_OBJECT_0     : Terminate;
      WAIT_OBJECT_0 + 1 :
      begin
        if FEnabledVideo then
        begin
          if assigned(FDisplayMode) then
          begin
            TDecklinkVideoFrameHelper.CreateVideoFrame(FDisplayMode.GetWidth, FDisplayMode.GetHeight,  FDisplayMode.GetWidth * TDecklinkVideoFrameHelper.GetBytesPerPixel(FPixelFormat),
              FPixelFormat, FFlags, FInputFrame);

            try
              FCallback.VideoInputFrameArrived(FInputFrame, nil);
            finally
              FInputFrame.Destroy;
            end;
          end;
        end;
        if FEnabledAudio then
        begin
          ;
        end;
        sleep(40);
      end;
      WAIT_OBJECT_0 + 2 :
      begin
        sleep(40);
      end;
      WAIT_OBJECT_0 + 3 :
      begin
        sleep(40);
      end;
    end;
  end;
end;

function TAVStream.EnableVideoInput(displayMode: _BMDDisplayMode; pixelFormat: _BMDPixelFormat;
                              flags: _BMDVideoInputFlags): HResult;
begin
  result := E_NOINTERFACE;

  FDisplayMode := TDeckLinkDisplayMode.Create(displayMode);
  FPixelFormat := pixelFormat;
  FFlags := flags;
  FEnabledVideo := true;
  result := S_OK;

end;

function TAVStream.DisableVideoInput: HResult;
begin
  result := E_NOINTERFACE;

  if FEnabledVideo then
  begin
    FreeAndNil(FDisplayMode);
    FPixelFormat := bmdFormat8BitYUV;
    FFlags := bmdVideoInputFlagDefault;
    FEnabledVideo := false;
    result := S_OK;
  end;

end;

function TAVStream.GetAvailableVideoFrameCount(out availableFrameCount: SYSUINT): HResult;
begin
  result := E_NOINTERFACE;
end;

function TAVStream.SetVideoInputFrameMemoryAllocator(const theAllocator: IDeckLinkMemoryAllocator): HResult;
begin
  result := E_NOINTERFACE;
end;

function TAVStream.EnableAudioInput(sampleRate: _BMDAudioSampleRate; sampleType: _BMDAudioSampleType;
                              channelCount: Integer): HResult;
begin
  result := E_NOINTERFACE;

  FSampleRate   := sampleRate;
  FSampleType   := sampleType;
  FChannelCount := channelCount;
  if FChannelCount >=2 then
  begin
    FEnabledAudio := true;
    result := S_OK
  end;
end;

function TAVStream.DisableAudioInput: HResult;
begin
  result := E_NOINTERFACE;
  if FEnabledAudio then
  begin
    FEnabledAudio := false;
    FSampleRate   := bmdAudioSampleRate48kHz;
    FSampleType   := bmdAudioSampleType16bitInteger;
    FChannelCount := 2;
    result := S_OK
  end;
end;

function TAVStream.GetAvailableAudioSampleFrameCount(out availableSampleFrameCount: SYSUINT): HResult;
begin
  result := E_NOINTERFACE;
end;

function TAVStream.StartStreams: HResult;
begin
  result := E_NOINTERFACE;
  if SetEvent(FHandles[1]) then result := S_OK;
end;

function TAVStream.StopStreams: HResult;
begin
  result := E_NOINTERFACE;
  if ResetEvent(FHandles[1]) then result := S_OK;
end;

function TAVStream.PauseStreams: HResult;
begin
  result := E_NOINTERFACE;
  if ResetEvent(FHandles[1]) then result := S_OK;
end;

function TAVStream.FlushStreams: HResult;
begin
  result := E_NOINTERFACE;
  if SetEvent(FHandles[0]) then result := S_OK;
end;

function TAVStream.SetCallback(const theCallback: IDeckLinkInputCallback): HResult;
begin
  FCallback := theCallback;
  result := S_OK;
end;

function TAVStream.GetHardwareReferenceClock(desiredTimeScale: Int64; out hardwareTime: Int64;
                                       out timeInFrame: Int64; out ticksPerFrame: Int64): HResult;
begin
  ;
end;

(* TVirtualDeviceDisplayModeIterator *)
constructor TVirtualDeviceDisplayModeIterator.Create();
begin
  m_refCount := 1;
  FPos  :=  0;
  FDisplayModes  := TList<TDeckLinkdisplayMode>.create;

  FDisplayModes.Add(TDeckLinkdisplayMode.Create(bmdModePAL));
  FDisplayModes.Add(TDeckLinkdisplayMode.Create(bmdModeHD1080i50));
end;

destructor TVirtualDeviceDisplayModeIterator.Destroy;
var
  i : integer;
begin

  for I := 0 to FDisplayModes.Count-1 do
    FDisplayModes.Items[i].Destroy;
  FDisplayModes.free;

  inherited;
end;

function TVirtualDeviceDisplayModeIterator.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TVirtualDeviceDisplayModeIterator._AddRef: Integer;
begin
  result := InterlockedIncrement(m_refCount);
end;

function TVirtualDeviceDisplayModeIterator._Release: Integer;
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


function TVirtualDeviceDisplayModeIterator.Next(out deckLinkDisplayMode: IDeckLinkDisplayMode): HResult; stdcall;
begin
  deckLinkDisplayMode := nil;
  if FPos >= FDisplayModes.Count then
  begin
    result := E_NOINTERFACE;
    FPos := 0;
    exit;
  end;

  try
    deckLinkDisplayMode := FDisplayModes.Items[FPos];
    inc(FPos);
  except
    result := E_NOINTERFACE;
    FPos := 0;
    exit;
  end;

  result := S_OK;
end;

(* TDeckLinkDeviceDiscovery *)
constructor TVirtualDevice.Create();
begin
  //inherited create(virtualCardName, virtualCardName);
  m_refCount := 1;
  FPreviewCallback  :=  nil;
  FVirtualDeviceDisplayModeIterator := TVirtualDeviceDisplayModeIterator.Create;
  FModelName :=  virtualCardName;
  FDisplayName  := virtualCardName;
  FAVStream  :=  TAVStream.create;
end;

destructor TVirtualDevice.Destroy;
begin
  if assigned(FAVStream) then
  begin
    FAVStream.Terminate;
    FAVStream.WaitFor;
    FAVStream.Free;
  end;
  FVirtualDeviceDisplayModeIterator.Free;
  inherited;
end;

function TVirtualDevice.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TVirtualDevice._AddRef: Integer;
begin
  result := InterlockedIncrement(m_refCount);
end;

function TVirtualDevice._Release: Integer;
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

function TVirtualDevice.GetModelName(out modelName: WideString): HResult;
begin
  modelName := WideString(FModelName);
end;

function TVirtualDevice.GetDisplayName(out displayName: WideString): HResult;
begin
  displayName := WideString(FDisplayName);
end;


function TVirtualDevice.DoesSupportVideoMode(displayMode: _BMDDisplayMode; pixelFormat: _BMDPixelFormat;
                                  flags: _BMDVideoInputFlags; out return: _BMDDisplayModeSupport;
                                  out resultDisplayMode: IDeckLinkDisplayMode): HResult;
begin
  result := E_NOINTERFACE;
  resultDisplayMode := nil;
  return :=  bmdDisplayModeNotSupported;

  if (((displayMode = bmdModePAL) or (displayMode = bmdModeHD1080i50)) and
     (pixelFormat = bmdFormat8BitYUV) and
     (((flags and bmdVideoInputFlagDefault) = bmdVideoInputFlagDefault) or ((flags and bmdVideoInputEnableFormatDetection) = bmdVideoInputEnableFormatDetection) or ((flags and bmdVideoInputDualStream3D) = bmdVideoInputDualStream3D)))  then
  begin
    resultDisplayMode := TDeckLinkDisplayMode.Create(displayMode);
    return :=  bmdDisplayModeSupported;
  end;

  result := S_OK
end;

function TVirtualDevice.GetDisplayModeIterator(out iterator: IDeckLinkDisplayModeIterator): HResult;
begin
  iterator := FVirtualDeviceDisplayModeIterator;
  result := S_OK;
end;

function TVirtualDevice.SetScreenPreviewCallback(const previewCallback: IDeckLinkScreenPreviewCallback): HResult;
begin
  FPreviewCallback := previewCallback;
  result := S_OK;
end;

function TVirtualDevice.EnableVideoInput(displayMode: _BMDDisplayMode; pixelFormat: _BMDPixelFormat;
                              flags: _BMDVideoInputFlags): HResult;
begin
  result := FAVStream.EnableVideoInput(displayMode, pixelFormat, flags);
end;

function TVirtualDevice.DisableVideoInput: HResult;
begin
  result := FAVStream.DisableVideoInput;
end;

function TVirtualDevice.GetAvailableVideoFrameCount(out availableFrameCount: SYSUINT): HResult;
begin
  result := FAVStream.GetAvailableVideoFrameCount(availableFrameCount);
end;

function TVirtualDevice.SetVideoInputFrameMemoryAllocator(const theAllocator: IDeckLinkMemoryAllocator): HResult;
begin
  result := E_NOINTERFACE;
end;

function TVirtualDevice.EnableAudioInput(sampleRate: _BMDAudioSampleRate; sampleType: _BMDAudioSampleType;
                              channelCount: SYSUINT): HResult;
begin
  result := FAVStream.EnableAudioInput(sampleRate, sampleType, channelCount);
end;

function TVirtualDevice.DisableAudioInput: HResult;
begin
  result := FAVStream.DisableAudioInput;
end;

function TVirtualDevice.GetAvailableAudioSampleFrameCount(out availableSampleFrameCount: SYSUINT): HResult; stdcall;
begin
  result := FAVStream.GetAvailableAudioSampleFrameCount(availableSampleFrameCount);
end;

function TVirtualDevice.StartStreams: HResult;
begin
  result := FAVStream.StartStreams;
end;

function TVirtualDevice.StopStreams: HResult;
begin
  result := FAVStream.StopStreams;
end;

function TVirtualDevice.PauseStreams: HResult;
begin
  result := FAVStream.PauseStreams;
end;

function TVirtualDevice.FlushStreams: HResult;
begin
  result := FAVStream.FlushStreams;
end;

function TVirtualDevice.SetCallback(const theCallback: IDeckLinkInputCallback): HResult;
begin
  result := FAVStream.SetCallback(theCallback);
end;

function TVirtualDevice.GetHardwareReferenceClock(desiredTimeScale: Int64; out hardwareTime: Int64;
                                       out timeInFrame: Int64; out ticksPerFrame: Int64): HResult;
begin
  result := FAVStream.GetHardwareReferenceClock(desiredTimeScale, hardwareTime, timeInFrame, ticksPerFrame);
end;


function TVirtualDevice.GetFlag(cfgID: _BMDDeckLinkAttributeID; out value: Integer): HResult;
begin
  result := S_OK;
  case cfgID of
    BMDDeckLinkSupportsInternalKeying : value := 0;
    BMDDeckLinkSupportsExternalKeying : value := 0;
    BMDDeckLinkSupportsHDKeying : value := 0;
    BMDDeckLinkSupportsInputFormatDetection : value := 0;
    BMDDeckLinkHasReferenceInput : value := 0;
    BMDDeckLinkHasSerialPort : value := 0;
    BMDDeckLinkHasAnalogVideoOutputGain : value := 0;
    BMDDeckLinkCanOnlyAdjustOverallVideoOutputGain : value := 0;
    BMDDeckLinkHasVideoInputAntiAliasingFilter : value := 0;
    BMDDeckLinkHasBypass : value := 0;
    BMDDeckLinkSupportsDesktopDisplay : value := 0;
    BMDDeckLinkSupportsClockTimingAdjustment : value := 0;
    BMDDeckLinkSupportsFullDuplex : value := 0;
    BMDDeckLinkSupportsFullFrameReferenceInputTimingOffset : value := 0;
    BMDDeckLinkMaximumAudioChannels : value := 0;
    BMDDeckLinkMaximumAnalogAudioChannels : value := 0;
    BMDDeckLinkNumberOfSubDevices : value := 0;
    BMDDeckLinkSubDeviceIndex : value := 0;
    BMDDeckLinkPersistentID : value := 0;
    BMDDeckLinkTopologicalID : value := 0;
    BMDDeckLinkVideoOutputConnections : value := 0;
    BMDDeckLinkVideoInputConnections : value := 0;
    BMDDeckLinkAudioOutputConnections : value := 0;
    BMDDeckLinkAudioInputConnections : value := 0;
    BMDDeckLinkDeviceBusyState : value := 0;
    BMDDeckLinkVideoInputGainMinimum : value := 0;
    BMDDeckLinkVideoInputGainMaximum : value := 0;
    BMDDeckLinkVideoOutputGainMinimum : value := 0;
    BMDDeckLinkVideoOutputGainMaximum : value := 0;
    BMDDeckLinkSerialPortDeviceName : value := 0;
    else   result := E_FAIL;
  end;
end;

function TVirtualDevice.GetInt(cfgID: _BMDDeckLinkAttributeID; out value: Int64): HResult;
begin
  result := S_OK;
  case cfgID of
    BMDDeckLinkSupportsInternalKeying : value := 0;
    BMDDeckLinkSupportsExternalKeying : value := 0;
    BMDDeckLinkSupportsHDKeying : value := 0;
    BMDDeckLinkSupportsInputFormatDetection : value := 0;
    BMDDeckLinkHasReferenceInput : value := 0;
    BMDDeckLinkHasSerialPort : value := 0;
    BMDDeckLinkHasAnalogVideoOutputGain : value := 0;
    BMDDeckLinkCanOnlyAdjustOverallVideoOutputGain : value := 0;
    BMDDeckLinkHasVideoInputAntiAliasingFilter : value := 0;
    BMDDeckLinkHasBypass : value := 0;
    BMDDeckLinkSupportsDesktopDisplay : value := 0;
    BMDDeckLinkSupportsClockTimingAdjustment : value := 0;
    BMDDeckLinkSupportsFullDuplex : value := 0;
    BMDDeckLinkSupportsFullFrameReferenceInputTimingOffset : value := 0;
    BMDDeckLinkMaximumAudioChannels : value := 0;
    BMDDeckLinkMaximumAnalogAudioChannels : value := 0;
    BMDDeckLinkNumberOfSubDevices : value := 0;
    BMDDeckLinkSubDeviceIndex : value := 0;
    BMDDeckLinkPersistentID : value := 0;
    BMDDeckLinkTopologicalID : value := 0;
    BMDDeckLinkVideoOutputConnections : value := 0;
    BMDDeckLinkVideoInputConnections :
    begin
      value := 0;
      value := value or bmdVideoConnectionSDI;
      value := value or bmdVideoConnectionHDMI;
    end;
    BMDDeckLinkAudioOutputConnections : value := 0;
    BMDDeckLinkAudioInputConnections :
    begin
      value := 0;
      value := value or bmdAudioConnectionEmbedded;
      value := value or bmdAudioConnectionAnalog;
    end;
    BMDDeckLinkDeviceBusyState : value := 0;
    BMDDeckLinkVideoIOSupport :
    begin
      value := 0;
      value := bmdDeviceSupportsCapture;
    end;
    BMDDeckLinkVideoInputGainMinimum : value := 0;
    BMDDeckLinkVideoInputGainMaximum : value := 0;
    BMDDeckLinkVideoOutputGainMinimum : value := 0;
    BMDDeckLinkVideoOutputGainMaximum : value := 0;
    BMDDeckLinkSerialPortDeviceName : value := 0;
    else   result := E_FAIL;
  end;
end;

function TVirtualDevice.GetFloat(cfgID: _BMDDeckLinkAttributeID; out value: Double): HResult;
begin
  result := S_OK;
end;

function TVirtualDevice.GetString(cfgID: _BMDDeckLinkAttributeID; out value: WideString): HResult;
begin
  result := S_OK;
end;



function TVirtualDevice.SetFlag2(cfgID: _BMDDeckLinkConfigurationID; value: Integer): HResult;
begin
  result := S_OK;
end;

function TVirtualDevice.GetFlag2(cfgID: _BMDDeckLinkConfigurationID; out value: Integer): HResult;
begin
  result := S_OK;
end;

function TVirtualDevice.SetInt2(cfgID: _BMDDeckLinkConfigurationID; value: Int64): HResult;
begin
  result := S_OK;
end;

function TVirtualDevice.GetInt2(cfgID: _BMDDeckLinkConfigurationID; out value: Int64): HResult;
begin
  case cfgID of
    bmdDeckLinkConfigVideoInputConnection : value := bmdVideoConnectionSDI;
  end;

  result := S_OK;
end;

function TVirtualDevice.SetFloat2(cfgID: _BMDDeckLinkConfigurationID; value: Double): HResult;
begin
  result := S_OK;
end;

function TVirtualDevice.GetFloat2(cfgID: _BMDDeckLinkConfigurationID; out value: Double): HResult;
begin
  result := S_OK;
end;

function TVirtualDevice.SetString2(cfgID: _BMDDeckLinkConfigurationID; const value: WideString): HResult;
begin
  result := S_OK;
end;

function TVirtualDevice.GetString2(cfgID: _BMDDeckLinkConfigurationID; out value: WideString): HResult;
begin
  result := S_OK;
end;

function TVirtualDevice.WriteConfigurationToPreferences2: HResult;
begin
  result := S_OK;
end;

function TVirtualDevice.GetFlag3(statusID: _BMDDeckLinkStatusID; out value: Integer): HResult; stdcall;
begin
  result := S_OK;
end;

function TVirtualDevice.GetInt3(statusID: _BMDDeckLinkStatusID; out value: Int64): HResult; stdcall;
begin
  result := S_OK;
end;

function TVirtualDevice.GetFloat3(statusID: _BMDDeckLinkStatusID; out value: Double): HResult; stdcall;
begin
  result := S_OK;
end;

function TVirtualDevice.GetString3(statusID: _BMDDeckLinkStatusID; out value: WideString): HResult; stdcall;
begin
  result := S_OK;
end;

function TVirtualDevice.GetBytes3(statusID: _BMDDeckLinkStatusID; out buffer: Pointer; out bufferSize: SYSUINT): HResult; stdcall;
begin
  result := S_OK;
end;

function TVirtualDevice.Subscribe(topic: _BMDNotifications; const theCallback: IDeckLinkNotificationCallback): HResult; stdcall;
begin
  result := S_OK;
end;

function TVirtualDevice.Unsubscribe(topic: _BMDNotifications; const theCallback: IDeckLinkNotificationCallback): HResult; stdcall;
begin
  result := S_OK;
end;

end.
