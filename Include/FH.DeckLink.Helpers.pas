unit FH.DeckLink.Helpers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Json, System.TypInfo,
  System.Generics.Collections, Winapi.ActiveX, System.syncobjs,
  DeckLinkAPI_TLB_10_5,
  FH.DeckLink,
  FH.DeckLink.InputFrame,
  FH.DeckLink.Discovery,
  FH.DeckLink.Device,
  FH.DeckLink.Input,
  FH.DeckLink.Utils,
  FH.DeckLink.Notification,
  FH.DeckLink.DisplayMode;


type
  TBMDDiscoveryHelper = class helper for TBMDDiscovery
    function AsJson: TJsonObject;
  end;


type
  TDeckLinkDeviceHelper = class helper for TDeckLinkDevice
    function AsJson: TJsonObject;
  end;

type
  TDeckLinkHandlerHelper = class helper for TDeckLinkHandler


    function AsJson: TJsonObject;
  end;

type
  TDeckLinkInputHelper = class helper for TDeckLinkInput
    type
      TAsJsonRecord = record
      private
        FParent : TDeckLinkInput;
        class function Create(AParent : TDeckLinkInput): TAsJsonRecord;  static;
      public
        function Input: TJsonObject;
        function Video: TJsonObject;
        function VideoConnections: TJSONArray;
        function DisplayModes: TJSONArray;
        function PixelFormats: TJSONArray;
        function Audio: TJsonObject;
        function AudioConnections: TJSONArray;
        function SampleRates: TJSONArray;
        function SampleTypes: TJSONArray;
        function ChannelCounts: TJSONArray;
      end;
    function AsJson : TAsJsonRecord;
  end;

implementation

(*
{
    "DEVICE": {
      "ModelName": "DeckLink SDI",
      "DisplayName": "DeckLink SDI",
      "Attributes": {
          "SubDeviceIndex": 3,
          "NumberOfSubDevices": 4,
          "TopologicalID": 3147264,
          "SupportsPlayback": true,
          "SupportsCapture": true,
          "SupportsBypass": true,
          "SupportsFullDuplex": false,
          "SupportsInputFormatDetection": true,
          "SupportsInternalKeying": true,
          "SupportsHDKeying": false,
          "SupportsExternalKeying": false,
          "DeviceIsAvailable": true,
          "DevicePlaybackBusy": false,
          "DeviceSerialPortBusy": false,
          "DeviceCaptureBusy": false
      },
      "Input": {
          "Video": {
              "Connections": [
                  "SDI",
                  "SDI"
              ],
              "Connection": "SDI",
              "DisplayMode": "1080i50",
              "PixelFormat": "YUV 8Bit"
          },
          "Audio": {
              "Connection": "Embedded",
              "SampleRate": "48 kHz",
              "SampleType": "16 bit",
              "ChannelCount": 2
          }
      }
  }
}

*)


function TDeckLinkHandlerHelper.AsJson: TJsonObject;
var
  LJsonObject               : TJsonObject;
  LAttributes               : TJsonObject;
begin
  LJsonObject := TJsonObject.Create;
  try
    LJsonObject.AddPair(TJsonPair.Create('modelName', TJsonString.Create(self.GetModelName)));
    LJsonObject.AddPair(TJsonPair.Create('displayName', TJsonString.Create(self.GetDisplayName)));
    LAttributes := TJsonObject.Create;
    try
      try
        LAttributes.AddPair(TJsonPair.Create('subDeviceIndex', TJsonNumber.Create(self.GetSubDeviceIndex)));
      except ; end;
      try
        LAttributes.AddPair(TJsonPair.Create('numberOfSubDevices', TJsonNumber.Create(self.GetNumberOfSubDevices)));
      except ; end;
      try
        LAttributes.AddPair(TJsonPair.Create('persistentID', TJsonNumber.Create(Self.GetPersistentID)));
      except ; end;
      try
        LAttributes.AddPair(TJsonPair.Create('topologicalID', TJsonNumber.Create(Self.GetTopologicalID)));
      except ; end;
      try
        if self.SupportsPlayback then
          LAttributes.AddPair(TJsonPair.Create('supportsPlayback', TJsonTrue.Create))
        else LAttributes.AddPair(TJsonPair.Create('supportsPlayback', TJsonFalse.Create));
      except ; end;
      try
        if self.SupportsCapture then
          LAttributes.AddPair(TJsonPair.Create('supportsCapture', TJsonTrue.Create))
        else LAttributes.AddPair(TJsonPair.Create('supportsCapture', TJsonFalse.Create));
      except ; end;
      try
        if self.SupportsBypass then
          LAttributes.AddPair(TJsonPair.Create('supportsBypass', TJsonTrue.Create))
        else LAttributes.AddPair(TJsonPair.Create('supportsBypass', TJsonFalse.Create));
      except ; end;
      try
        if self.SupportsFullDuplex then
          LAttributes.AddPair(TJsonPair.Create('supportsFullDuplex', TJsonTrue.Create))
        else LAttributes.AddPair(TJsonPair.Create('supportsFullDuplex', TJsonFalse.Create));
      except ; end;
      try
        if self.SupportsInputFormatDetection then
          LAttributes.AddPair(TJsonPair.Create('supportsInputFormatDetection', TJsonTrue.Create))
        else LAttributes.AddPair(TJsonPair.Create('supportsInputFormatDetection', TJsonFalse.Create));
      except ; end;
      try
        if self.SupportsInternalKeying then
          LAttributes.AddPair(TJsonPair.Create('supportsInternalKeying', TJsonTrue.Create))
        else LAttributes.AddPair(TJsonPair.Create('supportsInternalKeying', TJsonFalse.Create));
      except ; end;
      try
        if self.SupportsHDKeying then
          LAttributes.AddPair(TJsonPair.Create('supportsHDKeying', TJsonTrue.Create))
        else LAttributes.AddPair(TJsonPair.Create('supportsHDKeying', TJsonFalse.Create));
      except ; end;
      try
        if self.SupportsExternalKeying then
          LAttributes.AddPair(TJsonPair.Create('supportsExternalKeying', TJsonTrue.Create))
        else LAttributes.AddPair(TJsonPair.Create('supportsExternalKeying', TJsonFalse.Create));
      except ; end;
      try
        if self.GetDeviceIsAvailable then
          LAttributes.AddPair(TJsonPair.Create('deviceIsAvailable', TJsonTrue.Create))
        else LAttributes.AddPair(TJsonPair.Create('deviceIsAvailable', TJsonFalse.Create));
      except ; end;
      try
        if self.GetDevicePlaybackBusy then
          LAttributes.AddPair(TJsonPair.Create('devicePlaybackBusy', TJsonTrue.Create))
        else LAttributes.AddPair(TJsonPair.Create('devicePlaybackBusy', TJsonFalse.Create));
      except ; end;
      try
        if self.GetDeviceSerialPortBusy then
          LAttributes.AddPair(TJsonPair.Create('deviceSerialPortBusy', TJsonTrue.Create))
        else LAttributes.AddPair(TJsonPair.Create('deviceSerialPortBusy', TJsonFalse.Create));
      except ; end;
      try
        if self.GetDeviceCaptureBusy then
          LAttributes.AddPair(TJsonPair.Create('deviceCaptureBusy', TJsonTrue.Create))
        else LAttributes.AddPair(TJsonPair.Create('deviceCaptureBusy', TJsonFalse.Create));
      except ; end;
    finally
      LJsonObject.AddPair(TJsonPair.Create('attributes', LAttributes));
    end;

    LJsonObject.AddPair(TJsonPair.Create('input', self.Input.AsJson.Input));

    result := LJsonObject.Clone as TJsonObject;
  finally
    FreeAndNil(LJsonObject);
  end;
end;


(* TDeckLinkInputHelper *)
function TDeckLinkInputHelper.AsJson : TAsJsonRecord;
begin
  result := TAsJsonRecord.Create(Self);
end;

class function TDeckLinkInputHelper.TAsJsonRecord.Create(AParent : TDeckLinkInput): TAsJsonRecord;
begin
  result.FParent := AParent;
end;

function TDeckLinkInputHelper.TAsJsonRecord.VideoConnections: TJSONArray;
var
  I             : integer;
  LJsonArray    : TJSONArray;
  LArray        : TArray<_BMDVideoConnection>;
begin
  LJsonArray    := TJSONArray.Create;
  try
    LArray := FParent.VideoConnections;
    for i:= 0 to Length(LArray) - 1 do
    begin
      LJsonArray.AddElement(TJsonString.Create(TBMDConverts.BMDVideoConnection(LArray[i]).Name));
    end;
    result := LJsonArray.Clone as TJSONArray;
  finally
    FreeAndNil(LJsonArray);
  end;
end;

function TDeckLinkInputHelper.TAsJsonRecord.DisplayModes: TJSONArray;
var
  I             : integer;
  LJsonArray    : TJSONArray;
  LArray        : TArray<IDeckLinkDisplayMode>;
begin
  LJsonArray    := TJSONArray.Create;
  try
    LArray := FParent.DisplayModes;
    for i:= 0 to Length(LArray) - 1 do
    begin
      LJsonArray.AddElement(TJsonString.Create(TBMDConverts.BMDDisplayMode(LArray[i].GetDisplayMode).Name));
    end;
    result := LJsonArray.Clone as TJSONArray;
  finally
    FreeAndNil(LJsonArray);
  end;
end;

function TDeckLinkInputHelper.TAsJsonRecord.PixelFormats: TJSONArray;
var
  I             : integer;
  LJsonArray    : TJSONArray;
  LArray        : TArray<_BMDPixelFormat>;
begin
  LJsonArray    := TJSONArray.Create;
  try
    LArray := FParent.PixelFormats;
    for i:= 0 to Length(LArray) - 1 do
    begin
      LJsonArray.AddElement(TJsonString.Create(TBMDConverts.BMDPixelFormat(LArray[i]).Name));
    end;
    result := LJsonArray.Clone as TJSONArray;
  finally
    FreeAndNil(LJsonArray);
  end;
end;

function TDeckLinkInputHelper.TAsJsonRecord.Video: TJsonObject;
var
  LJsonObject               : TJsonObject;
  LItemValueStr             : string;
begin
  LJsonObject := TJsonObject.Create;
  try
    (* Input -> Video -> Connection *)
    LItemValueStr := TBMDConverts.BMDVideoConnection(Self.FParent.VideoConnection).Name;
    LJsonObject.AddPair(TJsonPair.Create('connection', TJsonString.Create(LItemValueStr)));
    (* Input -> Video -> DisplayMode *)
    LItemValueStr := TBMDConverts.BMDDisplayMode(Self.FParent.DisplayMode).Name;
    LJsonObject.AddPair(TJsonPair.Create('displayMode', TJsonString.Create(LItemValueStr)));
    (* Input -> Video -> PixelFormat *)
    LItemValueStr := TBMDConverts.BMDPixelFormat(Self.FParent.PixelFormat).Name;
    LJsonObject.AddPair(TJsonPair.Create('pixelFormat', TJsonString.Create(LItemValueStr)));
    (* Input -> Video -> Connections *)
    LJsonObject.AddPair(TJsonPair.Create('connections', Self.VideoConnections));
    (* Input -> Video -> DisplayModes *)
    LJsonObject.AddPair(TJsonPair.Create('displayModes', Self.DisplayModes));
    (* Input -> Video -> PixelFormats *)
    LJsonObject.AddPair(TJsonPair.Create('pixelFormats', Self.PixelFormats));

    result := LJsonObject.Clone as TJsonObject;
  finally
    FreeAndNil(LJsonObject);
  end;
end;














function TDeckLinkInputHelper.TAsJsonRecord.AudioConnections: TJSONArray;
var
  I             : integer;
  LJsonArray    : TJSONArray;
  LArray        : TArray<_BMDAudioConnection>;
begin
  LJsonArray    := TJSONArray.Create;
  try
    LArray := FParent.AudioConnections;
    for i:= 0 to Length(LArray) - 1 do
    begin
      LJsonArray.AddElement(TJsonString.Create(TBMDConverts.BMDAudioConnection(LArray[i]).Name));
    end;
    result := LJsonArray.Clone as TJSONArray;
  finally
    FreeAndNil(LJsonArray);
  end;
end;

function TDeckLinkInputHelper.TAsJsonRecord.SampleRates: TJSONArray;
var
  I             : integer;
  LJsonArray    : TJSONArray;
  LArray        : TArray<_BMDAudioSampleRate>;
begin
  LJsonArray    := TJSONArray.Create;
  try
    LArray := FParent.SampleRates;
    for i:= 0 to Length(LArray) - 1 do
    begin
      LJsonArray.AddElement(TJsonString.Create(TBMDConverts.BMDAudioSampleRate(LArray[i]).Name));
    end;
    result := LJsonArray.Clone as TJSONArray;
  finally
    FreeAndNil(LJsonArray);
  end;
end;


function TDeckLinkInputHelper.TAsJsonRecord.SampleTypes: TJSONArray;
var
  I             : integer;
  LJsonArray    : TJSONArray;
  LArray        : TArray<_BMDAudioSampleType>;
begin
  LJsonArray    := TJSONArray.Create;
  try
    LArray := FParent.SampleTypes;
    for i:= 0 to Length(LArray) - 1 do
    begin
      LJsonArray.AddElement(TJsonString.Create(TBMDConverts.BMDAudioSampleType(LArray[i]).Name));
    end;
    result := LJsonArray.Clone as TJSONArray;
  finally
    FreeAndNil(LJsonArray);
  end;
end;

function TDeckLinkInputHelper.TAsJsonRecord.ChannelCounts: TJSONArray;
var
  I             : integer;
  LJsonArray    : TJSONArray;
  LArray        : TArray<integer>;
begin
  LJsonArray    := TJSONArray.Create;
  try
    LArray := FParent.ChannelCounts;
    for i:= 0 to Length(LArray) - 1 do
    begin
      LJsonArray.AddElement(TJsonNumber.Create(LArray[i]));
    end;
    result := LJsonArray.Clone as TJSONArray;
  finally
    FreeAndNil(LJsonArray);
  end;
end;

function TDeckLinkInputHelper.TAsJsonRecord.Audio: TJsonObject;
var
  LJsonObject               : TJsonObject;
  LItemValueStr             : string;
  LItemValueInt             : integer;
begin
  LJsonObject := TJsonObject.Create;
  try
    (* Input -> Audio -> Connection *)
    LItemValueStr := TBMDConverts.BMDAudioConnection(Self.FParent.AudioConnection).Name;
    LJsonObject.AddPair(TJsonPair.Create('connection', TJsonString.Create(LItemValueStr)));
    (* Input -> Audio -> SampleRate *)
    LItemValueStr := TBMDConverts.BMDAudioSampleRate(Self.FParent.SampleRate).Name;
    LJsonObject.AddPair(TJsonPair.Create('sampleRate', TJsonString.Create(LItemValueStr)));
    (* Input -> Audio -> SampleType *)
    LItemValueStr := TBMDConverts.BMDAudioSampleType(Self.FParent.SampleType).Name;
    LJsonObject.AddPair(TJsonPair.Create('sampleType', TJsonString.Create(LItemValueStr)));
    (* Input -> Audio -> ChannelCount *)
    LItemValueInt := Self.FParent.ChannelCount;
    LJsonObject.AddPair(TJsonPair.Create('channelCount', TJsonNumber.Create(LItemValueInt)));
    (* Input -> Audio -> connections *)
    LJsonObject.AddPair(TJsonPair.Create('connections', Self.AudioConnections));
    (* Input -> Audio -> sampleRates *)
    LJsonObject.AddPair(TJsonPair.Create('sampleRates', Self.SampleRates));
    (* Input -> Audio -> sampleTypes *)
    LJsonObject.AddPair(TJsonPair.Create('sampleTypes', Self.SampleTypes));
    (* Input -> Audio -> channelCounts *)
    LJsonObject.AddPair(TJsonPair.Create('channelCounts', Self.ChannelCounts));

    result := LJsonObject.Clone as TJsonObject;
  finally
    FreeAndNil(LJsonObject);
  end;
end;

function TDeckLinkInputHelper.TAsJsonRecord.Input: TJsonObject;
var
  LJsonObject : TJsonObject;
begin
  LJsonObject := TJsonObject.Create;
  try
    LJsonObject.AddPair(TJsonPair.Create('video', Self.Video));
    LJsonObject.AddPair(TJsonPair.Create('audio', Self.Audio));
    result := LJsonObject.Clone as TJsonObject;
  finally
    FreeAndNil(LJsonObject);
  end;
end;



function TDeckLinkDeviceHelper.AsJson: TJsonObject;
var
  LJsonObject : TJsonObject;
  LModelName, LDisplayName : widestring;
begin
  LJsonObject := TJsonObject.Create;
  try
    self.GetModelName(LModelName);
    self.GetDisplayName(LDisplayName);
    LJsonObject.AddPair(TJsonPair.Create('modelName', TJsonString.Create(LModelName)));
    LJsonObject.AddPair(TJsonPair.Create('displayName', TJsonString.Create(LDisplayName)));
    result := LJsonObject.Clone as TJsonObject;
  finally
    FreeAndNil(LJsonObject);
  end;
end;

function TBMDDiscoveryHelper.AsJson: TJsonObject;
var
  LJsonObject         : TJsonObject;
  LDevicesJson        : TJsonArray;
  i                   : integer;
  LDeckLinkDevice     : TDeckLinkDevice;
  LDeckLinkInterface  : IDeckLink;
begin
  LJsonObject := TJsonObject.Create();
  try
    LDevicesJson := TJSONArray.Create();
    try
      for i:= 0 to self.Devices.Count - 1 do
      begin
        LDeckLinkInterface := nil;
        LDeckLinkInterface := self.Devices.Items[i];
        if assigned(LDeckLinkInterface) then
        begin
          LDeckLinkDevice := TDeckLinkDevice.Create(LDeckLinkInterface);
          try
            LDevicesJson.AddElement(LDeckLinkDevice.AsJson);
          finally
            LDeckLinkDevice.Destroy;
          end;
        end;
      end;
    finally
      LJsonObject.AddPair('items', LDevicesJson);
    end;
    result := LJsonObject.Clone as TJsonObject;
  finally
    LJsonObject.Free;
  end;
end;



end.
