unit DeckLinkDevice;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, System.SyncObjs, System.Generics.Collections,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Winapi.ActiveX, Winapi.DirectShow9,
  DeckLinkAPI, DeckLinkAPI.Discovery, DeckLinkAPI.Modes, DeckLinkAPI.Types;

const
  WM_REFRESH_INPUT_STREAM_DATA_MESSAGE = 701;
  WM_SELECT_VIDEO_MODE_MESSAGE = 702;
  WM_ERROR_RESTARTING_CAPTURE_MESSAGE = 703;


type
  TAncillaryDataStruct = record
    // VITC timecodes and user bits for field 1 & 2
    vitcF1Timecode      : string;
    vitcF1UserBits      : string;
    vitcF2Timecode      : string;
    vitcF2UserBits      : string;

    // RP188 timecodes and user bits (VITC1, VITC2 and LTC)
    rp188vitc1Timecode  : string;
    rp188vitc1UserBits  : string;
    rp188vitc2Timecode  : string;
    rp188vitc2UserBits  : string;
    rp188ltcTimecode    : string;
    rp188ltcUserBits    : string;
  end;

type
  TMessageEx = record
    msg           : cardinal;
    ads           : TAncillaryDataStruct;
    NoInputSource : boolean;
  end;

type
  TErrorNotify = procedure(const msg: string) of object;
  TVideoModeChangeNotify = procedure(const modeIndex: integer) of object;
  //TVideoModeChangeNotify = procedure(const modeIndex: integer) of object;

  TDeckLinkInputDevice = class(TInterfacedObject, IDeckLinkInputCallback)
  private
    m_uiDelegate                : TObject;
    m_refCount                  : integer;
    m_displayName               : string;
    m_modelName                 : string;
    m_deckLink                  : IDeckLink;
    m_deckLinkInput             : IDeckLinkInput;
    m_deckLinkStatus            : IDeckLinkStatus;
    m_modeList                  : TList<IDeckLinkDisplayMode>;
    m_supportsFormatDetection   : boolean;
    m_currentlyCapturing        : boolean;
    m_applyDetectedInputMode    : boolean;


    function GetReferenceSignalLocked: boolean;
    function GetVideoInputSignalLocked: boolean;
	  //
    procedure GetAncillaryDataFromFrame(const videoFrame: IDeckLinkVideoInputFrame; const timecodeFormat: _BMDTimecodeFormat; out timecodeString: string; out userBitsString: string);
  public
    constructor Create(uiDelegate : TObject; var device: IDeckLink);
    destructor Destroy; override;

    function Init: boolean;
    procedure GetDisplayModeNames(var modeNames: TArray<string>);
    function StartCapture(videoModeIndex: integer; screenPreviewCallback: IDeckLinkScreenPreviewCallback; applyDetectedInputMode: boolean): boolean;
    procedure StopCapture();

    property IsCapturing : boolean read m_currentlyCapturing;
    property SupportsFormatDetection : boolean read m_supportsFormatDetection;
    property ReferenceSignalLocked : boolean read GetReferenceSignalLocked;
    property VideoInputSignalLocked : boolean read GetVideoInputSignalLocked;
    property GetDeviceName: string read m_displayName;
    property DeckLinkInstance: IDeckLink read m_deckLink;

    function _Release: Integer; stdcall;
    function _AddRef: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;

	  // IDeckLinkInputCallback methods
    function VideoInputFormatChanged(notificationEvents: _BMDVideoInputFormatChangedEvents;
                                     const newDisplayMode: IDeckLinkDisplayMode;
                                     detectedSignalFlags: _BMDDetectedVideoInputFormatFlags): HResult; stdcall;
    function VideoInputFrameArrived(const videoFrame: IDeckLinkVideoInputFrame;
                                    const audioPacket: IDeckLinkAudioInputPacket): HResult; stdcall;

  end;

type
  _bmdDiscoverStatus = (BMD_ADD_DEVICE, BMD_REMOVE_DEVICE);
  TDeviceChangeNotify = procedure(const status: _bmdDiscoverStatus; const deckLinkDevice: IDeckLink) of object;

  TDeckLinkDeviceDiscovery = class(TInterfacedObject, IDeckLinkDeviceNotificationCallback)
  private
    m_deckLinkDiscovery : IDeckLinkDiscovery;
    m_refCount          : integer;
    FOnDeviceChange     : TDeviceChangeNotify;
    FLock               : TCriticalSection;
    procedure DoDeviceChange(const status: _bmdDiscoverStatus; const deckLinkDevice: IDeckLink);
  public
    constructor Create();
    destructor Destroy; override;
	  function Enable(): boolean;
	  procedure Disable();

	  // IDeckLinkDeviceNotificationCallback methods
    function DeckLinkDeviceArrived(const deckLinkDevice: IDeckLink): HResult; stdcall;
    function DeckLinkDeviceRemoved(const deckLinkDevice: IDeckLink): HResult; stdcall;

    function _Release: Integer;  stdcall;
    function _AddRef: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;


    property OnDeviceChange: TDeviceChangeNotify read FOnDeviceChange write FOnDeviceChange;
  end;



implementation

(* TDeckLinkDeviceDiscovery *)
constructor TDeckLinkDeviceDiscovery.Create();
begin
  FLock := TCriticalSection.Create;

  m_deckLinkDiscovery := nil;
  m_refCount := 1;

	if (CoCreateInstance(CLASS_CDeckLinkDiscovery, nil, CLSCTX_ALL, IID_IDeckLinkDiscovery, m_deckLinkDiscovery) <> S_OK) then
		m_deckLinkDiscovery := nil;
end;

destructor TDeckLinkDeviceDiscovery.Destroy;
begin
	if assigned(m_deckLinkDiscovery) then
  begin
		m_deckLinkDiscovery.UninstallDeviceNotifications();
		m_deckLinkDiscovery := nil;
  end;

  FLock.Free;

  inherited;
end;

function TDeckLinkDeviceDiscovery.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TDeckLinkDeviceDiscovery._AddRef: Integer;
begin
  result := InterlockedIncrement(m_refCount);
end;

function TDeckLinkDeviceDiscovery._Release: Integer;
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

function  TDeckLinkDeviceDiscovery.Enable(): boolean;
var
  hr : HRESULT;
begin
  hr := E_FAIL;

	// Install device arrival notifications
	if (m_deckLinkDiscovery <> nil) then
		hr := m_deckLinkDiscovery.InstallDeviceNotifications(self);

	result:= hr = S_OK;
end;

procedure TDeckLinkDeviceDiscovery.Disable();
begin
	// Uninstall device arrival notifications
	if assigned(m_deckLinkDiscovery) then
  begin
		m_deckLinkDiscovery.UninstallDeviceNotifications();
  end;
end;

function TDeckLinkDeviceDiscovery.DeckLinkDeviceArrived(const deckLinkDevice: IDeckLink): HResult;
begin
	deckLinkDevice._AddRef;
	// Update UI (add new device to menu) from main thread
  DoDeviceChange(BMD_ADD_DEVICE, deckLinkDevice);
	result := S_OK;
end;

function TDeckLinkDeviceDiscovery.DeckLinkDeviceRemoved(const deckLinkDevice: IDeckLink): HResult;
begin
	// Update UI (remove device from menu) from main thread
  DoDeviceChange(BMD_REMOVE_DEVICE, deckLinkDevice);
	deckLinkDevice._Release();
	result := S_OK;
end;

procedure TDeckLinkDeviceDiscovery.DoDeviceChange(const status: _bmdDiscoverStatus; const deckLinkDevice: IDeckLink);
begin
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



(* TDeckLinkDevice *)
constructor TDeckLinkInputDevice.Create(uiDelegate : TObject; var device: IDeckLink);
var
  LHr : HResult;
begin
  m_uiDelegate := uiDelegate;
  m_refCount:=1;
  m_deckLink := device;
  m_deckLinkInput := nil;
  m_supportsFormatDetection := false;
  m_currentlyCapturing := false;
  m_applyDetectedInputMode := false;

  // Query the DeckLink for its configuration interface
  LHr := m_deckLink.QueryInterface(IID_IDeckLinkStatus, m_deckLinkStatus);
  if (LHr <> S_OK) then
  begin
    raise Exception.CreateFmt('Could not obtain the IDeckLinkStatus interface - result = %08x', [LHr]);
  end;

  m_modeList := TList<IDeckLinkDisplayMode>.create;

	if not assigned(m_deckLink) then
		 raise Exception.Create('at device must be defined');
end;

destructor TDeckLinkInputDevice.Destroy;
var
  i : integer;
begin
  if assigned(m_deckLinkInput) then  m_deckLinkInput := nil;

  for I := 0 to m_modeList.Count-1 do
    m_modeList.Items[i]:=nil;
  m_modeList.Clear;

  m_modeList.Free;
    
  if assigned(m_deckLink) then  m_deckLink := nil;
  inherited;
end;

function TDeckLinkInputDevice.GetReferenceSignalLocked: boolean;
var
  LHr : HResult;
  LValueFlag : integer;
begin
  result := false;
  LHr := m_deckLinkStatus.GetFlag(bmdDeckLinkStatusReferenceSignalLocked, LValueFlag);
  if LHr = S_OK then result := Boolean(LValueFlag);
end;

function TDeckLinkInputDevice.GetVideoInputSignalLocked: boolean;
var
  LHr : HResult;
  LValueFlag : integer;
begin
  result := false;
  LHr := m_deckLinkStatus.GetFlag(bmdDeckLinkStatusVideoInputSignalLocked, LValueFlag);
  if LHr = S_OK then result := Boolean(LValueFlag);
end;



function TDeckLinkInputDevice.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TDeckLinkInputDevice._AddRef: Integer;
begin
  result := InterlockedIncrement(m_refCount);
end;

function TDeckLinkInputDevice._Release: Integer;
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


function TDeckLinkInputDevice.Init: boolean;
var
  deckLinkAttributes  : IDeckLinkAttributes;
  displayModeIterator : IDeckLinkDisplayModeIterator;
  displayMode         : IDeckLinkDisplayMode;
  deviceName          : wideString;
  modelName           : wideString;
  value               : Integer;
begin    
  result := false;
  deckLinkAttributes := nil;
  displayModeIterator := nil;
  displayMode := nil;
  deviceName := '';
  modelName := '';

	// Get input interface
	if (m_deckLink.QueryInterface(IID_IDeckLinkInput, m_deckLinkInput) <> S_OK) then
  begin
    raise Exception.Create('IID_IDeckLinkInput');  
  end;

	// Check if input mode detection is supported.
	if (m_deckLink.QueryInterface(IID_IDeckLinkAttributes, deckLinkAttributes) = S_OK) then
	begin
		if (deckLinkAttributes.GetFlag(BMDDeckLinkSupportsInputFormatDetection, value) = S_OK) then
      m_supportsFormatDetection := boolean(value)
    else
			m_supportsFormatDetection := false;

		if assigned(deckLinkAttributes) then 
      deckLinkAttributes := nil;
	end else
  begin
    raise Exception.Create('IID_IDeckLinkAttributes');   
  end;

	// Retrieve and cache mode list
	if (m_deckLinkInput.GetDisplayModeIterator(displayModeIterator) = S_OK) then
	begin
		while (displayModeIterator.Next(displayMode) = S_OK) do
      m_modeList.Add(displayMode);  

		if assigned(displayModeIterator) then displayModeIterator := nil;
	end;

	// Get DisplayName name
	if (m_deckLink.GetDisplayName(deviceName) = S_OK) then
	begin
		m_displayName := deviceName; 
	end	else
	begin
		m_displayName := 'DeckLink';
	end;

	// Get ModelName name
	if (m_deckLink.GetModelName(modelName) = S_OK) then
	begin
		m_modelName := modelName; 
	end	else
	begin
		m_modelName := 'DeckLink';
	end;  

	result := true;
end;

procedure TDeckLinkInputDevice.GetDisplayModeNames(var modeNames: TArray<string>);
var
  modeIndex   : cardinal;
  modeName   : wideString;  
begin
  setLength(modeNames, m_modeList.Count);
	for modeIndex:=0 to m_modeList.Count-1 do
	begin			
		if (m_modeList.Items[modeIndex].GetName(modeName) = S_OK) then
		begin
			modeNames[modeIndex]:=modeName;
		end else 
    begin
			modeNames[modeIndex]:='Unknown mode';
		end;
  end;
end;


function TDeckLinkInputDevice.StartCapture(videoModeIndex: integer; screenPreviewCallback: IDeckLinkScreenPreviewCallback; applyDetectedInputMode: boolean): boolean;
var
  BMDDisplayMode : _BMDDisplayMode;
  videoInputFlags : _BMDVideoInputFlags;
begin
  videoInputFlags := bmdVideoInputFlagDefault;
  result := false;
	m_applyDetectedInputMode := applyDetectedInputMode;

	// Enable input video mode detection if the device supports it
 	if m_supportsFormatDetection then
		videoInputFlags :=  videoInputFlags or bmdVideoInputEnableFormatDetection;

	// Get the IDeckLinkDisplayMode from the given index
	if ((videoModeIndex < 0) or  (videoModeIndex >= m_modeList.Count-1)) then
	begin
    raise Exception.Create('An invalid display mode was selected');
	end;

	// Set the screen preview
	m_deckLinkInput.SetScreenPreviewCallback(screenPreviewCallback);

	// Set capture callback
	m_deckLinkInput.SetCallback(self);

  BMDDisplayMode := m_modeList.Items[videoModeIndex].GetDisplayMode();
	// Set the video input mode
	if (m_deckLinkInput.EnableVideoInput(BMDDisplayMode, bmdFormat8BitYUV, videoInputFlags) <> S_OK) then
	begin
    raise Exception.Create('This application was unable to select the chosen video mode. Perhaps, the selected device is currently in-use.');
	end;

	// Start the capture
	if (m_deckLinkInput.StartStreams() <> S_OK) then
	begin
    raise Exception.Create('This application was unable to start the capture. Perhaps, the selected device is currently in-use.');
	end;

	m_currentlyCapturing := true;

	result := true;
end;

procedure TDeckLinkInputDevice.StopCapture();
begin
	if assigned(m_deckLinkInput) then
	begin
		// Stop the capture
		m_deckLinkInput.StopStreams();

		//
		m_deckLinkInput.SetScreenPreviewCallback(nil);

		// Delete capture callback
	 	m_deckLinkInput.SetCallback(nil);
	end;

	m_currentlyCapturing := false;
end;



function TDeckLinkInputDevice.VideoInputFormatChanged(notificationEvents: _BMDVideoInputFormatChangedEvents;
                                     const newDisplayMode: IDeckLinkDisplayMode;
                                     detectedSignalFlags: _BMDDetectedVideoInputFormatFlags): HResult;
var
  modeIndex     : integer;
  pixelFormat   : _BMDPixelFormat;
  FMSG          : TMessage;
begin

  modeIndex := 0;
  pixelFormat   := bmdFormat10BitYUV;
	// Restart capture with the new video mode if told to
	if not (m_applyDetectedInputMode) then
  begin
    exit(S_OK);
  end;

  if (detectedSignalFlags and bmdDetectedVideoInputRGB444)>0 then
		pixelFormat := bmdFormat10BitRGB;

	// Stop the capture
	m_deckLinkInput.StopStreams();

	// Set the video input mode
	if (m_deckLinkInput.EnableVideoInput(newDisplayMode.GetDisplayMode(), pixelFormat, bmdVideoInputEnableFormatDetection) <> S_OK) then
	begin
    FMSG.msg := WM_ERROR_RESTARTING_CAPTURE_MESSAGE;
		// Let the UI know we couldnt restart the capture with the detected input mode
    m_uiDelegate.Dispatch(FMSG);
		exit(S_OK);
	end;

	// Start the capture
	if (m_deckLinkInput.StartStreams() <> S_OK) then
	begin
    FMSG.msg := WM_ERROR_RESTARTING_CAPTURE_MESSAGE;
		// Let the UI know we couldnt restart the capture with the detected input mode
    m_uiDelegate.Dispatch(FMSG);
		exit(S_OK);
	end;

	// Find the index of the new mode in the mode list so we can update the UI
	while modeIndex < m_modeList.Count-1 do
  begin
		if (m_modeList.Items[modeIndex].GetDisplayMode() = newDisplayMode.GetDisplayMode()) then
		begin
      FMSG.msg := WM_SELECT_VIDEO_MODE_MESSAGE;
      FMSG.WParam := modeIndex;
      m_uiDelegate.Dispatch(FMSG);
			break;
		end;
		inc(modeIndex);
	end;


  RESULT:=S_OK;
end;

function TDeckLinkInputDevice.VideoInputFrameArrived(const videoFrame: IDeckLinkVideoInputFrame;
                                    const audioPacket: IDeckLinkAudioInputPacket): HResult;
var

  FMsg : TMessageEx;
  ancillaryData : TAncillaryDataStruct;
begin
	if assigned(videoFrame) then
  begin
    // Get the various timecodes and userbits attached to this frame
    GetAncillaryDataFromFrame(videoFrame, bmdTimecodeVITC, ancillaryData.vitcF1Timecode, ancillaryData.vitcF1UserBits);
    GetAncillaryDataFromFrame(videoFrame, bmdTimecodeVITCField2, ancillaryData.vitcF2Timecode, ancillaryData.vitcF2UserBits);
    GetAncillaryDataFromFrame(videoFrame, bmdTimecodeRP188VITC1, ancillaryData.rp188vitc1Timecode, ancillaryData.rp188vitc1UserBits);
    GetAncillaryDataFromFrame(videoFrame, bmdTimecodeRP188LTC, ancillaryData.rp188ltcTimecode, ancillaryData.rp188ltcUserBits);
    GetAncillaryDataFromFrame(videoFrame, bmdTimecodeRP188VITC2, ancillaryData.rp188vitc2Timecode, ancillaryData.rp188vitc2UserBits);

    // Update the UI
    FMsg.Msg := WM_REFRESH_INPUT_STREAM_DATA_MESSAGE;
    FMsg.NoInputSource := (videoFrame.GetFlags() and bmdFrameHasNoInputSource) > 0;
    FMsg.ads := ancillaryData;
    m_uiDelegate.Dispatch(FMsg);
  end;
  
  RESULT:=S_OK;
end;

procedure TDeckLinkInputDevice.GetAncillaryDataFromFrame(const videoFrame: IDeckLinkVideoInputFrame; const timecodeFormat: _BMDTimecodeFormat; out timecodeString: string; out userBitsString: string);
var
  timecode        : IDeckLinkTimecode;
  timecodeStr     : wideString;
  userBits        : SYSUINT;
begin
  timecode := nil;
  userBits := 0;
  timecodeString := ''; 
  userBitsString := '';
  
	if (assigned(videoFrame) and (not timecodeString.IsEmpty) and (not userBitsString.IsEmpty)) then
  begin
    if (videoFrame.GetTimecode(timecodeFormat, timecode) = S_OK) then
    begin
      if (timecode.GetString(timecodeStr) = S_OK) then
        timecodeString := timecodeStr;

		timecode.GetTimecodeUserBits(userBits);
		userBitsString.Format('0x%08X', [userBits]);

		if assigned(timecode) then timecode := nil;
  end;
  end;
end;


end.
