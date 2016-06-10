unit FH.DeckLink.Input;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, Winapi.ActiveX, System.syncobjs,
  DeckLinkAPI_TLB_10_5,
  FH.DeckLink.InputFrame,
  FH.DeckLink.Utils;

const
  MSG_ONDEBUG           = 701;
  MSG_ONDROPFRAME       = 702;
  MSG_ONDROPVIDEOFRAME  = 703;

Type
  TfhVer = record
    name        : string;
    version     : cardinal;
    versionStr  : string;
    dateRelease : TDateTime;
  end;

Const
  FH_DeckLink_Input_ver : TfhVer = (Name : 'FH.DeckLink.Input'; version : $01000011; versionStr : ''; dateRelease : 41534.0);

type
  TFrameArrivedCall = reference to procedure(const videoFrame: TDeckLinkVideoInputFrame;
                                    const audioPacket: TDeckLinkAudioInputPacket; const frameIndex : Int64);

type
  TDeckLinkInput = class(TInterfacedObject, IDeckLinkInputCallback)
  private
    FRefCount               : integer;

    FDeckLink               : IDeckLink;
    FDeckLinkInput          : IDeckLinkInput;
    FDeckLinkConfiguration  : IDeckLinkConfiguration;
    FDeckLinkAttributes     : IDeckLinkAttributes;
    FDeckLinkStatus         : IDeckLinkStatus;

    FCapturing              : boolean;

    (* video *)
    FInputFlags             : _BMDVideoInputFlags;
    FDisplayMode            : _BMDDisplayMode;
    FPixelFormat            : _BMDPixelFormat;

    (* audio *)
    FSampleRate             : _BMDAudioSampleRate;
    FSampleType             : _BMDAudioSampleType;
    FChannelCount           : integer;

    (* Main *)
    FDetectionInputMode     : boolean;

    FLock                   : TCriticalSection;

    FOnFrameArrived         : TFrameArrivedCall;


    FOnStartCapture         : TNotifyEvent;
    FOnStopCapture          : TNotifyEvent;
    FOnDropVideoFrame       : TNotifyEvent;
    FOnDropFrame            : TNotifyEvent;
    FOnDebug                : TGetStrProc;

    FLastDebugStr           : string;


    procedure OnDebugEvents(var msg: dword); message MSG_ONDEBUG;
    procedure DoDebug(const str: string);
    procedure DoDropFrame;
    procedure OnDropFrameEvents(var msg: dword); message MSG_ONDROPFRAME;
    procedure DoDropVideoFrame;
    procedure OnDropVideoFrameEvents(var msg: dword); message MSG_ONDROPVIDEOFRAME;

    Function GetVersion   : TfhVer;
    Procedure DoFrameArrived(const videoFrame: TDeckLinkVideoInputFrame;
                                    const audioPacket: TDeckLinkAudioInputPacket; const frameIndex : Int64);

    function GetDeckLinkDisplayMode: IDeckLinkDisplayMode;

    Function GetModeList: TArray<IDeckLinkDisplayMode>;
    Function GetPixelFormatList: TArray<_BMDPixelFormat>;
    function GetVideoConnections: TArray<_BMDVideoConnection>;
    function GetAudioConnections: TArray<_BMDAudioConnection>;
    function GetSampleRates: TArray<_BMDAudioSampleRate>;
    function GetSampleTypes: TArray<_BMDAudioSampleType>;
    function GetChannelCounts: TArray<integer>;

  public
    constructor Create(ADevie: IDeckLink = nil); overload;
    destructor Destroy; override;

    procedure SetParams(AName: string; AValue: integer); overload;
    procedure SetParams(AName: string; AValue: string); overload;
    procedure SetParams(AName: string; AValue: boolean); overload;

    function GetParams(const AName: string; Out AValue: boolean): boolean; overload;
    function GetParams(const AName: string; Out AValue: integer): boolean; overload;
    function GetParams(const AName: string; Out AValue: string): boolean; overload;



    (* Decklink *)
    function SupportsFormatDetection: boolean;
    function GetVideoSignalLocked: boolean;

    function GetDetectedVideoFlags: boolean;
    function GetDetectedVideoMode: boolean;

    function GetCurrentVideoFlags: _BMDVideoInputFlags;
    function GetCurrentVideoPixelFormat: _BMDPixelFormat;
    function GetCurrentVideoMode: _BMDDisplayMode;

    function SupportVideoConnection(AVideoConnection: _BMDVideoConnection): boolean;
    function GetVideoConnection: _BMDVideoConnection;
    procedure SetVideoConnection(AValue: _BMDVideoConnection);

    function SupportAudioConnection(AAudioConnection: _BMDAudioConnection): boolean;
    procedure SetAudioConnection(AValue: _BMDAudioConnection);
    function GetAudioConnection: _BMDAudioConnection;

    function Init(ADeckLink: IDeckLink): boolean;
    function StartCapture(AScreenPreviewCallback: IDeckLinkScreenPreviewCallback = nil): boolean;
    procedure StopCapture();
    procedure ParamsChanged();
    function GetDisplayMode: _BMDDisplayMode;
    function GetPixelFormat: _BMDPixelFormat;



    (* VIDEO PROPERTY SUPPORT LIST *)
    property VideoConnections : TArray<_BMDVideoConnection> read GetVideoConnections;
    property DisplayModes : TArray<IDeckLinkDisplayMode> read GetModeList;
    property PixelFormats : TArray<_BMDPixelFormat> read GetPixelFormatList;

    (* AUDIO PROPERTY SUPPORT LIST *)
    property AudioConnections : TArray<_BMDAudioConnection> read GetAudioConnections;
    property SampleRates: TArray<_BMDAudioSampleRate> read GetSampleRates;
    property SampleTypes: TArray<_BMDAudioSampleType> read GetSampleTypes;
    property ChannelCounts: TArray<integer> read GetChannelCounts;

    property VideoConnection: _BMDVideoConnection read GetVideoConnection write SetVideoConnection;
    property DisplayMode : _BMDDisplayMode read GetDisplayMode write FDisplayMode;
    property PixelFormat : _BMDPixelFormat read GetPixelFormat write FPixelFormat;

    property AudioConnection: _BMDVideoConnection read GetAudioConnection write SetAudioConnection;
    property SampleRate   : _BMDAudioSampleRate read FSampleRate write FSampleRate;
    property SampleType   : _BMDAudioSampleType read FSampleType write FSampleType;
    property ChannelCount : integer read FChannelCount write FChannelCount;

    property DetectionInputMode : boolean read FDetectionInputMode write FDetectionInputMode;
    property IsCapturing : boolean read FCapturing;

    property DeckLinkInstance: IDeckLink read FDeckLink;
    property DeckLinkInputInstance: IDeckLinkInput read FDeckLinkInput;
    property DeckLinkDisplayModeInstance: IDeckLinkDisplayMode read GetDeckLinkDisplayMode;

    property OnFrameArrived : TFrameArrivedCall read FOnFrameArrived write FOnFrameArrived;

    property Version : TfhVer read GetVersion;

    (* Notify Event *)
    property OnStartCapture : TNotifyEvent read FOnStartCapture write FOnStartCapture;
    property OnStopCapture : TNotifyEvent read FOnStopCapture write FOnStopCapture;
    property OnDropFrame : TNotifyEvent read FOnDropFrame write FOnDropFrame;
    property OnDropVideoFrame : TNotifyEvent read FOnDropVideoFrame write FOnDropVideoFrame;
    property OnDebug : TGetStrProc read FOnDebug write FOnDebug;


    function _Release: Integer;  stdcall;
    function _AddRef: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;

	  (* IDeckLinkInputCallback methods *)
    function VideoInputFormatChanged(notificationEvents: _BMDVideoInputFormatChangedEvents;
                                     const newDisplayMode: IDeckLinkDisplayMode;
                                     detectedSignalFlags: _BMDDetectedVideoInputFormatFlags): HResult; stdcall;
    function VideoInputFrameArrived(const videoFrame: IDeckLinkVideoInputFrame;
                                    const audioPacket: IDeckLinkAudioInputPacket): HResult; stdcall;


  end;

implementation

(* TDeckLinkDevice *)
constructor TDeckLinkInput.Create(ADevie: IDeckLink = nil);
begin
  FRefCount := 1;
  FDeckLink := nil;
  FDeckLinkInput := nil;

  FCapturing := false;
  FDisplayMode := bmdModePAL;
  FPixelFormat := bmdFormat8BitYUV;
  SampleRate   := bmdAudioSampleRate48kHz;
  SampleType   := bmdAudioSampleType16bitInteger;
  ChannelCount := 8;
  FDetectionInputMode := false;

  FLock := TCriticalSection.Create;

  if ADevie <> nil then
  begin
    Init(ADevie);
  end;
end;


destructor TDeckLinkInput.Destroy;
var
  i : integer;
begin

  if assigned(FDeckLinkInput) then  FDeckLinkInput := nil;

	if assigned(FDeckLink) then
  begin
		FDeckLink._Release;
		FDeckLink := nil;
  end;

  FreeAndNil(FLock);

  inherited;
end;

function TDeckLinkInput.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TDeckLinkInput._AddRef: Integer;
begin
  result := InterlockedIncrement(FRefCount);
end;

function TDeckLinkInput._Release: Integer;
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

procedure TDeckLinkInput.SetParams(AName: string; AValue: integer);
begin
  if SameText('_BMDDisplayMode', AName) then
  begin
    DisplayMode := _BMDDisplayMode(AValue);
  end else
  if SameText('_BMDPixelFormat', AName) then
  begin
    PixelFormat := _BMDPixelFormat(AValue);
  end else
  if SameText('_BMDAudioSampleRate', AName) then
  begin
    SampleRate := _BMDAudioSampleRate(AValue)
  end else
  if SameText('_BMDAudioSampleType', AName) then
  begin
    SampleType := _BMDAudioSampleType(AValue);
  end else
  if SameText('ChannelCount', AName) then
  begin
    if ((AValue = 2) or (AValue = 8) or (AValue = 16)) then
      ChannelCount := AValue
    else
      raise Exception.Create('Incorect ChannelCount params');
  end else
  if SameText('DetectionInputMode', AName) then
  begin
    FDetectionInputMode := boolean(AValue);
  end else
    raise Exception.Create('Error Message');
end;

procedure TDeckLinkInput.SetParams(AName: string; AValue: string);
begin
  if AValue.IsEmpty then exit;
  if SameText('bmdVideoConnection', AName) then
  begin
    VideoConnection := TBMDConverts.BMDVideoConnection(AValue).BMD;
  end else
  if SameText('bmdDisplayMode', AName) then
  begin
    DisplayMode := TBMDConverts.BMDDisplayMode(AValue).BMD;
  end else
  if SameText('bmdPixelFormat', AName) then
  begin
    PixelFormat := TBMDConverts.BMDPixelFormat(AValue).BMD;
  end else
  if SameText('bmdAudioConnection', AName) then
  begin
    AudioConnection := TBMDConverts.BMDAudioConnection(AValue).BMD;
  end else
  if SameText('bmdAudioSampleRate', AName) then
  begin
    SampleRate := TBMDConverts.BMDAudioSampleRate(AValue).BMD;
  end else
  if SameText('bmdAudioSampleType', AName) then
  begin
    SampleType := TBMDConverts.BMDAudioSampleType(AValue).BMD;
  end else
  if SameText('bmdChannelCount', AName) then
  begin
    ChannelCount := strtoint(AValue);
  end else
  if SameText('bmdVideoInputFlags', AName) then
  begin
    if SameText('true', AValue) then
      DetectionInputMode := true else DetectionInputMode := false
  end else
    raise Exception.Create('Error Message');
end;

procedure TDeckLinkInput.SetParams(AName: string; AValue: boolean);
begin
  if SameText('bmdVideoInputFlags', AName) then
  begin
    DetectionInputMode := AValue;
  end else
    raise Exception.Create('Error Message');
end;


function  TDeckLinkInput.GetParams(const AName: string; Out AValue: boolean): boolean;
begin
  result := false;
  if SameText('DetectionInputMode', AName) then
  begin
    AValue := DetectionInputMode;
    result:= true;
  end else
  if SameText('SupportsDetectionInputMode', AName) then
  begin
    result:= true;
  end;
end;

function  TDeckLinkInput.GetParams(const AName: string; Out AValue: integer): boolean;
begin
  result := false;
end;

function  TDeckLinkInput.GetParams(const AName: string; Out AValue: string): boolean;
begin
  result := false;
end;

function TDeckLinkInput.GetVideoConnection: _BMDVideoConnection;
var
  LHr : HResult;
  LValueInt : int64;
begin
  (* Get current VideoInput Connection *)
  LHr := FDeckLinkConfiguration.GetInt(bmdDeckLinkConfigVideoInputConnection, LValueInt);
  case LHr of
    S_OK:
    begin
      result := _BMDVideoConnection(LValueInt);
    end;
    E_FAIL: raise Exception.CreateFmt('Could not get bmdDeckLinkConfigVideoInputConnection - result = %08x', [LHr]);
  end;
end;

procedure TDeckLinkInput.SetVideoConnection(AValue: _BMDVideoConnection);
var
  LHr : HResult;
begin
  (* Set current VideoInput Connection *)
  LHr := FDeckLinkConfiguration.SetInt(bmdDeckLinkConfigVideoInputConnection, AValue);
  case LHr of
    E_FAIL: raise Exception.CreateFmt('Could not set bmdDeckLinkConfigVideoInputConnection - result = %08x', [LHr]);
  end;
end;

function TDeckLinkInput.GetAudioConnection: _BMDAudioConnection;
var
  LHr : HResult;
  LValueInt : int64;
begin
  (* Get bmdDeckLinkConfigAudioInputConnection *)
  LHr := FDeckLinkConfiguration.GetInt(bmdDeckLinkConfigAudioInputConnection, LValueInt);
  case LHr of
    S_OK:
    begin
      result := _BMDAudioConnection(LValueInt);
    end;
    E_FAIL: raise Exception.CreateFmt('Could not get bmdDeckLinkConfigAudioInputConnection - result = %08x', [LHr]);
  end;
end;

procedure TDeckLinkInput.SetAudioConnection(AValue: _BMDAudioConnection);
var
  LHr : HResult;
begin
  (* Set bmdDeckLinkConfigAudioInputConnection *)
  LHr := FDeckLinkConfiguration.SetInt(bmdDeckLinkConfigAudioInputConnection, AValue);
  case LHr of
    E_FAIL: raise Exception.CreateFmt('Could not set bmdDeckLinkConfigAudioInputConnection - result = %08x', [LHr]);
  end;
end;

function  TDeckLinkInput.SupportAudioConnection(AAudioConnection: _BMDAudioConnection): boolean;
var
  LHr : HResult;
  LValueInt : int64;
begin
  result := false;
  LHr := FDeckLinkAttributes.GetInt(BMDDeckLinkAudioInputConnections, LValueInt);
  case LHr of
    S_OK :
    begin
      if (LValueInt and AAudioConnection) > 0 then
        result := true;
    end;
    E_FAIL :
    begin
      ;
    end;
  end;
end;

function  TDeckLinkInput.SupportVideoConnection(AVideoConnection: _BMDVideoConnection): boolean;
var
  LHr : HResult;
  LValueInt : int64;
begin
  result := false;
  LHr := FDeckLinkAttributes.GetInt(BMDDeckLinkVideoInputConnections, LValueInt);
  case LHr of
    S_OK :
    begin
      if (LValueInt and  AVideoConnection) > 0 then
        result := true;
    end;
    E_FAIL :
    begin
      ;
    end;
  end;
end;

function TDeckLinkInput.SupportsFormatDetection: boolean;
var
  LHr : HResult;
  LValueFlag : integer;
begin
  result := false;
  (* Get BMDDeckLinkSupportsInputFormatDetection *)
  LHr := FDeckLinkAttributes.GetFlag(BMDDeckLinkSupportsInputFormatDetection, LValueFlag);
  case LHr of
    S_OK: result := Boolean(LValueFlag);
    E_FAIL: raise Exception.CreateFmt('Could not set bmdDeckLinkConfigVideoInputConnection - result = %08x', [LHr]);
  end;
end;

function TDeckLinkInput.GetVideoSignalLocked: boolean;
var
  LHr : HResult;
  LValueFlag : integer;
begin
  result := false;
  LHr := FDeckLinkStatus.GetFlag(bmdDeckLinkStatusVideoInputSignalLocked, LValueFlag);
  case LHr of
    S_OK: result := Boolean(LValueFlag);
    E_FAIL: raise Exception.CreateFmt('Could not set bmdDeckLinkStatusVideoInputSignalLocked - result = %08x', [LHr]);
  end;
end;

function TDeckLinkInput.GetDetectedVideoMode: boolean;
var
  LHr : HResult;
  LValueFlag : integer;
begin
  result := false;
  LHr := FDeckLinkStatus.GetFlag(bmdDeckLinkStatusDetectedVideoInputMode, LValueFlag);
  case LHr of
    S_OK: result := Boolean(LValueFlag);
    E_FAIL: raise Exception.CreateFmt('Could not set bmdDeckLinkStatusDetectedVideoInputMode - result = %08x', [LHr]);
  end;
end;

function TDeckLinkInput.GetDetectedVideoFlags: boolean;
var
  LHr : HResult;
  LValueFlag : integer;
begin
  result := false;
  LHr := FDeckLinkStatus.GetFlag(bmdDeckLinkStatusDetectedVideoInputFlags, LValueFlag);
  case LHr of
    S_OK: result := Boolean(LValueFlag);
    E_FAIL: raise Exception.CreateFmt('Could not set bmdDeckLinkStatusDetectedVideoInputFlags - result = %08x', [LHr]);
  end;
end;

function TDeckLinkInput.GetCurrentVideoMode: _BMDDisplayMode;
var
  LHr : HResult;
  LValueInt : int64;
begin
  result := 0;
  LHr := FDeckLinkStatus.GetInt(bmdDeckLinkStatusCurrentVideoInputMode, LValueInt);
  case LHr of
    S_OK: result := _BMDDisplayMode(LValueInt);
    E_FAIL: raise Exception.CreateFmt('Could not set bmdDeckLinkStatusCurrentVideoInputMode - result = %08x', [LHr]);
  end;
end;

function TDeckLinkInput.GetCurrentVideoPixelFormat: _BMDPixelFormat;
var
  LHr : HResult;
  LValueInt : int64;
begin
  result := 0;
  LHr := FDeckLinkStatus.GetInt(bmdDeckLinkStatusCurrentVideoInputPixelFormat, LValueInt);
  case LHr of
    S_OK: result := _BMDPixelFormat(LValueInt);
    E_FAIL: raise Exception.CreateFmt('Could not set bmdDeckLinkStatusCurrentVideoInputPixelFormat - result = %08x', [LHr]);
  end;
end;

function TDeckLinkInput.GetCurrentVideoFlags: _BMDVideoInputFlags;
var
  LHr : HResult;
  LValueInt : int64;
begin
  result := 0;
  LHr := FDeckLinkStatus.GetInt(bmdDeckLinkStatusCurrentVideoInputFlags, LValueInt);
  case LHr of
    S_OK: result := _BMDVideoInputFlags(LValueInt);
    E_FAIL: raise Exception.CreateFmt('Could not set bmdDeckLinkStatusCurrentVideoInputFlags - result = %08x', [LHr]);
  end;
end;


Function TDeckLinkInput.GetModeList: TArray<IDeckLinkDisplayMode>;
var
  LDisplayModeIterator : IDeckLinkDisplayModeIterator;
  LDisplayMode : IDeckLinkDisplayMode;
  LArray : TArray<IDeckLinkDisplayMode>;
begin
  LDisplayModeIterator := nil;
  LDisplayMode := nil;
	// GetDisplayModeIterator
	if (FDeckLinkInput.GetDisplayModeIterator(LDisplayModeIterator) = S_OK) then
	begin
		while (LDisplayModeIterator.Next(LDisplayMode) = S_OK) do
    begin
      SetLength(LArray, Length(LArray)+1);
      LArray[High(LArray)] := LDisplayMode;
      LDisplayMode := nil;
    end;
		if assigned(LDisplayModeIterator) then LDisplayModeIterator := nil;
	end;
  result :=  LArray;
end;

function TDeckLinkInput.GetSampleRates: TArray<_BMDAudioSampleRate>;
var
  LAudioSampleRates : TArray<_BMDAudioSampleRate>;
  i : integer;
begin
  SetLength(LAudioSampleRates, 0);
  for i := Low(_AudioSampleRateLinks) to High(_AudioSampleRateLinks) do
  begin
    SetLength(LAudioSampleRates, Length(LAudioSampleRates)+1);
    LAudioSampleRates[High(LAudioSampleRates)] := _AudioSampleRateLinks[i].BMD;
  end;
  result := LAudioSampleRates;
end;

function TDeckLinkInput.GetSampleTypes: TArray<_BMDAudioSampleType>;
var
  LAudioSampleTypes : TArray<_BMDAudioSampleType>;
  i : integer;
begin
  SetLength(LAudioSampleTypes, 0);
  for i := Low(_AudioSampleTypeLinks) to High(_AudioSampleTypeLinks) do
  begin
    SetLength(LAudioSampleTypes, Length(LAudioSampleTypes)+1);
    LAudioSampleTypes[High(LAudioSampleTypes)] := _AudioSampleTypeLinks[i].BMD;
  end;
  result := LAudioSampleTypes;
end;

function TDeckLinkInput.GetChannelCounts: TArray<integer>;
var
  LAudioChannelCounts : TArray<integer>;
  i : integer;
begin
  SetLength(LAudioChannelCounts, 4);
  LAudioChannelCounts[0] := 2;
  LAudioChannelCounts[1] := 4;
  LAudioChannelCounts[2] := 8;
  LAudioChannelCounts[3] := 16;
  result := LAudioChannelCounts;
end;

Function TDeckLinkInput.GetPixelFormatList: TArray<_BMDPixelFormat>;
var
  LPixelFormat          : _BMDPixelFormat;
  LDisplayModeSupport   : _BMDDisplayModeSupport;
  LResultDisplayMode    : IDeckLinkDisplayMode;
  LHr                   : HResult;
  i                     : integer;
  LArray                : TArray<_BMDPixelFormat>;
begin

  for i := Low(_PixelFormatLinks) to High(_PixelFormatLinks) do
  begin
    LHr := FDeckLinkInput.DoesSupportVideoMode(DisplayMode, _PixelFormatLinks[i].BMD, bmdVideoInputFlagDefault, LDisplayModeSupport, LResultDisplayMode);
    case LHr of
      S_OK:
      begin
        if LDisplayModeSupport = bmdDisplayModeSupported then
        begin
          SetLength(LArray, Length(LArray)+1);
          LArray[High(LArray)] := _PixelFormatLinks[i].BMD;
        end;
      end;
    end;
  end;

  result :=  LArray;
end;




function TDeckLinkInput.GetVideoConnections: TArray<_BMDVideoConnection>;
var
  LConnectios : TArray<_BMDVideoConnection>;
  i : integer;
begin
  SetLength(LConnectios, 0);
  for i := Low(_VideoConnectionLinks) to High(_VideoConnectionLinks) do
  begin
    if SupportVideoConnection(_VideoConnectionLinks[i].BMD) then
    begin
      SetLength(LConnectios, Length(LConnectios)+1);
      LConnectios[High(LConnectios)] := _VideoConnectionLinks[i].BMD;
    end;
  end;
  result := LConnectios;
end;

function TDeckLinkInput.GetAudioConnections: TArray<_BMDAudioConnection>;
var
  LConnectios : TArray<_BMDAudioConnection>;
  i : integer;
begin
  SetLength(LConnectios, 0);
  for i := Low(_AudioConnectionLinks) to High(_AudioConnectionLinks) do
  begin
    if SupportAudioConnection(_AudioConnectionLinks[i].BMD) then
    begin
      SetLength(LConnectios, Length(LConnectios)+1);
      LConnectios[High(LConnectios)] := _AudioConnectionLinks[i].BMD;
    end;
  end;
  result := LConnectios;
end;


function TDeckLinkInput.Init(ADeckLink: IDeckLink): boolean;
var
  deviceName          : wideString;
  modelName           : wideString;
  value               : Integer;
begin
  result := false;

  (* Release and nil old device *)
  if assigned(FDeckLink) then
  begin
		FDeckLink._Release;
		FDeckLink := nil;
  end;

  (* Select new device *)
  if Assigned(ADeckLink) then
  begin
    FDeckLink := ADeckLink;
    FDeckLink._AddRef();
  end;

  deviceName := '';
  modelName := '';

	// Get IDeckLinkAttributes interface
	if (FDeckLink.QueryInterface(IID_IDeckLinkAttributes, FDeckLinkAttributes) <> S_OK) then
  begin
    raise Exception.Create('IID_IDeckLinkAttributes');
  end;

	// Get IDeckLinkConfiguration interface
	if (FDeckLink.QueryInterface(IID_IDeckLinkConfiguration, FDeckLinkConfiguration) <> S_OK) then
  begin
    raise Exception.Create('IID_IDeckLinkConfiguration');
  end;

	// Get IDeckLinkConfiguration interface
	if (FDeckLink.QueryInterface(IID_IDeckLinkStatus, FDeckLinkStatus) <> S_OK) then
  begin
    raise Exception.Create('IID_IDeckLinkStatus');
  end;

	// Get IDeckLinkInput interface
	if (FDeckLink.QueryInterface(IID_IDeckLinkInput, FDeckLinkInput) <> S_OK) then
  begin
    raise Exception.Create('IID_IDeckLinkInput');
  end;

	result := true;
end;

function TDeckLinkInput.GetDisplayMode: _BMDDisplayMode;
var
  LCurrentVideoMode : _BMDDisplayMode;
begin
  LCurrentVideoMode := self.GetCurrentVideoMode;
  if LCurrentVideoMode <> bmdModeUnknown then
  begin
    FDisplayMode := LCurrentVideoMode;
  end;

  result := FDisplayMode
end;

function TDeckLinkInput.GetPixelFormat: _BMDPixelFormat;
var
  LCurrentPixelFormat : _BMDPixelFormat;
begin
  LCurrentPixelFormat := self.GetCurrentVideoPixelFormat;
  if LCurrentPixelFormat <> FPixelFormat then
  begin
    FPixelFormat := FPixelFormat;
  end;

  result := FPixelFormat
end;

function TDeckLinkInput.StartCapture(AScreenPreviewCallback: IDeckLinkScreenPreviewCallback = nil): boolean;
var
  LDeckLinkDisplayMode  : IDeckLinkDisplayMode;
  LHr                   : HResult;
begin

  result := false;

	// Set the screen preview
	FDeckLinkInput.SetScreenPreviewCallback(AScreenPreviewCallback);

	// Set capture callback
	FDeckLinkInput.SetCallback(self);

  // Get DeckLinkDisplayMode
  LDeckLinkDisplayMode := GetDeckLinkDisplayMode;

	// Enable Video Input
	LHr := FDeckLinkInput.EnableVideoInput(LDeckLinkDisplayMode.GetDisplayMode, FPixelFormat, FInputFlags);
  case LHr of
    E_FAIL :  raise Exception.CreateFmt('Failure - result = %08x', [LHr]);
    E_INVALIDARG :  raise Exception.CreateFmt('Is returned on invalid mode or video flags - result = %08x', [LHr]);
    E_ACCESSDENIED :  raise Exception.CreateFmt('Unable to access the hardware or input stream curently active - result = %08x', [LHr]);
    E_OUTOFMEMORY : raise Exception.CreateFmt('Unable to create new frame - result = %08x', [LHr]);
  end;

	// Enable Audio Input
  LHr := FDeckLinkInput.EnableAudioInput(FSampleRate, FSampleType, FChannelCount);
  case LHr of
    E_FAIL :  raise Exception.CreateFmt('Failure - result = %08x', [LHr]);
    E_INVALIDARG :  raise Exception.CreateFmt('Invalid number of channels requested - result = %08x', [LHr]);
  end;

	// Start the capture
	LHr := FDeckLinkInput.StartStreams();
  case LHr of
    E_FAIL :  raise Exception.CreateFmt('Failure - result = %08x', [LHr]);
    E_INVALIDARG :  raise Exception.CreateFmt('Is returned on invalid mode or video flags - result = %08x', [LHr]);
    E_ACCESSDENIED :  raise Exception.CreateFmt('Unable to access the hardware or input stream curently active - result = %08x', [LHr]);
    E_OUTOFMEMORY : raise Exception.CreateFmt('Unable to create new frame - result = %08x', [LHr]);
  end;

	FCapturing := true;

	result := true;
end;



procedure TDeckLinkInput.StopCapture();
var
  LHr : HResult;
begin
	if assigned(FDeckLinkInput) then
	begin
		// Flush
    LHr := FDeckLinkInput.FlushStreams();
    case LHr of
      E_FAIL : raise Exception.CreateFmt('Failure - result = %08x', [LHr]);
    end;
    // Stop the capture
    LHr := FDeckLinkInput.StopStreams();
    case LHr of
      E_FAIL : raise Exception.CreateFmt('Failure - result = %08x', [LHr]);
    end;
    // Disable video input
    LHr := FDeckLinkInput.DisableVideoInput;
    case LHr of
      E_FAIL : raise Exception.CreateFmt('Failure - result = %08x', [LHr]);
    end;
    // Disable audio input
    LHr := FDeckLinkInput.DisableAudioInput;
    case LHr of
      E_FAIL : raise Exception.CreateFmt('Failure - result = %08x', [LHr]);
    end;
    // Delete preview callback
		FDeckLinkInput.SetScreenPreviewCallback(nil);
		// Delete capture callback
	 	FDeckLinkInput.SetCallback(nil);
	end;
	FCapturing := false;
end;


procedure TDeckLinkInput.ParamsChanged();
var
  LHr : HResult;
  LCapturing : boolean;
begin
  LCapturing := FCapturing;

  // Stop the capture
	LHr := FDeckLinkInput.StopStreams();
  case LHr of
    S_OK :
    begin
      FCapturing := false;
      if LCapturing then
        StartCapture();
    end;
    E_FAIL : raise Exception.CreateFmt('Failure - result = %08x', [LHr]);
  end;
end;

function TDeckLinkInput.GetDeckLinkDisplayMode: IDeckLinkDisplayMode;
var
  LModeSupport    : _BMDDisplayModeSupport;
  LDisplayMode    : IDeckLinkDisplayMode;
begin
  result := nil;

  FInputFlags := bmdVideoInputFlagDefault;
 	if SupportsFormatDetection and FDetectionInputMode then
		FInputFlags :=  FInputFlags or bmdVideoInputEnableFormatDetection;

  if (FDeckLinkInput.DoesSupportVideoMode(FDisplayMode, FPixelFormat, FInputFlags, LModeSupport, LDisplayMode) <> S_OK) then
	begin
    raise Exception.Create('DoesSupportVideoMode');
	end;

  case LModeSupport of
    bmdDisplayModeNotSupported: raise Exception.Create('bmdDisplayModeNotSupported');
    bmdDisplayModeSupported: result := LDisplayMode;
    bmdDisplayModeSupportedWithConversion: raise Exception.Create('bmdDisplayModeSupportedWithConversion');
  end;

end;

function TDeckLinkInput.VideoInputFormatChanged(notificationEvents: _BMDVideoInputFormatChangedEvents;
                                     const newDisplayMode: IDeckLinkDisplayMode;
                                     detectedSignalFlags: _BMDDetectedVideoInputFormatFlags): HResult;
var
  LFieldDominance : _BMDFieldDominance;
begin
  case notificationEvents of
    bmdVideoInputDisplayModeChanged:
    begin
      FDisplayMode := newDisplayMode.GetDisplayMode;
      ParamsChanged;
    end;
    bmdVideoInputFieldDominanceChanged:
    begin
      LFieldDominance := newDisplayMode.GetFieldDominance;
      case LFieldDominance of
        bmdUnknownFieldDominance:;
        bmdLowerFieldFirst:;
        bmdUpperFieldFirst:;
        bmdProgressiveFrame:;
        bmdProgressiveSegmentedFrame:;
      end;
    end;
    bmdVideoInputColorspaceChanged:
    begin
      case detectedSignalFlags of
        bmdDetectedVideoInputYCbCr422:;
        bmdDetectedVideoInputRGB444:;
        bmdDetectedVideoInputDualStream3D:;
      end;
    end;
  end;

  RESULT:=S_OK;
end;


Procedure TDeckLinkInput.DoFrameArrived(const videoFrame: TDeckLinkVideoInputFrame;
                                    const audioPacket: TDeckLinkAudioInputPacket; const frameIndex : Int64);
begin
  if assigned(FOnFrameArrived) then
  begin
    FOnFrameArrived(videoFrame, audioPacket, frameIndex);
  end;
end;

function TDeckLinkInput.VideoInputFrameArrived(const videoFrame: IDeckLinkVideoInputFrame;
                                    const audioPacket: IDeckLinkAudioInputPacket): HResult;
var
  _videoFrame   : TDeckLinkVideoInputFrame;
  _audioPacket  : TDeckLinkAudioInputPacket;
  LTimecode     : IDeckLinkTimecode;
begin
  _videoFrame := nil;
  _audioPacket := nil;

  if assigned(videoFrame) then
  begin
    if (videoFrame.GetFlags() and bmdFrameHasNoInputSource) > 0 then
    begin
      //DoNoInputSource;
    end;

    if (videoFrame.GetTimecode(bmdTimecodeRP188VITC1, LTimecode) = S_OK) then
    begin
      //DoTimecodeRP188VITC1;
    end;
    if (videoFrame.GetTimecode(bmdTimecodeRP188VITC2, LTimecode) = S_OK) then
    begin
      //DoTimecodeRP188VITC2;
    end;
    if (videoFrame.GetTimecode(bmdTimecodeRP188LTC, LTimecode) = S_OK) then
    begin
      //DoTimecodeRP188LTC;
    end;
    if (videoFrame.GetTimecode(bmdTimecodeRP188Any, LTimecode) = S_OK) then
    begin
      //DoTimecodeRP188Any;
    end;
    if (videoFrame.GetTimecode(bmdTimecodeLTC, LTimecode) = S_OK) then
    begin
      //DoTimecodeLTC;
    end;
    if (videoFrame.GetTimecode(bmdTimecodeVITC, LTimecode) = S_OK) then
    begin
      //DoTimecodeVITC;
    end;
    if (videoFrame.GetTimecode(bmdTimecodeVITCField2, LTimecode) = S_OK) then
    begin
      //DoTimecodeVITCField2;
    end;
    if (videoFrame.GetTimecode(bmdTimecodeSerial, LTimecode) = S_OK) then
    begin
      //DoTimecodeSerial;
    end;
	  if assigned(LTimecode) then LTimecode := nil;

  end else
  begin
    //DoDropVideoFrame;
  end;


  if assigned(videoFrame) then
    _videoFrame:=TDeckLinkVideoInputFrame.Create(videoFrame);
  if assigned(audioPacket) then
    _audioPacket:=TDeckLinkAudioInputPacket.Create(audioPacket);

  DoFrameArrived(_videoFrame, _audioPacket, 0);

  if assigned(_videoFrame) then
    _videoFrame.Destroy;
  if assigned(_audioPacket) then
    _audioPacket.Destroy;

  RESULT:=S_OK;
end;

Function TDeckLinkInput.GetVersion : TfhVer;
begin
  result.name:=FH_DeckLink_Input_ver.name;
  result.version:=FH_DeckLink_Input_ver.version;
  result.versionStr:=format('%s-%d.%d.%d.%d', [FH_DeckLink_Input_ver.name,
  FH_DeckLink_Input_ver.version shr 24 and $FF,
  FH_DeckLink_Input_ver.version shr 16 and $FF,
  FH_DeckLink_Input_ver.version shr 8 and $FF,
  FH_DeckLink_Input_ver.version and $FF]);
  result.dateRelease:=FH_DeckLink_Input_ver.dateRelease;
end;

procedure TDeckLinkInput.OnDebugEvents(var msg: dword);
begin
  if assigned(FOnDebug) then
  begin
    FOnDebug(FLastDebugStr);
  end;
end;

procedure TDeckLinkInput.DoDebug(const str: string);
var
  FMSG  : DWORD;
begin
  FLastDebugStr:=str;
  FMSG:=MSG_ONDEBUG;
  self.Dispatch(FMSG);
end;


procedure TDeckLinkInput.OnDropVideoFrameEvents(var msg: dword);
begin
  if assigned(FOnDropVideoFrame) then
  begin
    FOnDropVideoFrame(self);
  end;
end;


procedure TDeckLinkInput.DoDropVideoFrame;
var
  FMSG  : DWORD;
begin
  FMSG:=MSG_ONDROPVIDEOFRAME;
  self.Dispatch(FMSG);
end;


procedure TDeckLinkInput.OnDropFrameEvents(var msg: dword);
begin
  if assigned(FOnDropFrame) then
  begin
    FOnDropFrame(self);
  end;
end;

procedure TDeckLinkInput.DoDropFrame;
var
  FMSG  : DWORD;
begin
  FMSG:=MSG_ONDROPFRAME;
  self.Dispatch(FMSG);
end;



end.
