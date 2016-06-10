unit FH.DeckLink.Utils;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Json, System.TypInfo,
  System.Generics.Collections, Winapi.ActiveX, System.syncobjs, DeckLinkAPI_TLB_10_5;

type
  TBMDLink = record
  strict private
    FBMD            : TOleEnum;
    FTypeStr        : string;
    FName           : string;
  public
    property BMD            : TOleEnum read FBMD;
    //property AsInt          : integer read integer(FBMD);
    property AsString       : string read FTypeStr;
    property Name           : string read FName;
  end;

(* _BMDVideoConnection *)
const
  _VideoConnectionLinks : array [0..5] of TBMDLink =  (
    (FBMD : bmdVideoConnectionSDI;        FTypeStr: 'bmdVideoConnectionSDI';        FName : 'SDI'),
    (FBMD : bmdVideoConnectionHDMI;       FTypeStr: 'bmdVideoConnectionHDMI';       FName : 'HDMI'),
    (FBMD : bmdVideoConnectionOpticalSDI; FTypeStr: 'bmdVideoConnectionOpticalSDI'; FName : 'Optical SDI'),
    (FBMD : bmdVideoConnectionComponent;  FTypeStr: 'bmdVideoConnectionComponent';  FName : 'Component'),
    (FBMD : bmdVideoConnectionComposite;  FTypeStr: 'bmdVideoConnectionComposite';  FName : 'Composite'),
    (FBMD : bmdVideoConnectionSVideo;     FTypeStr: 'bmdVideoConnectionSVideo';     FName : 'Video')
  );

(* _BMDAudioConnection *)
const
  _AudioConnectionLinks : array [0..4] of TBMDLink =  (
    (FBMD : bmdAudioConnectionEmbedded;   FTypeStr: 'bmdAudioConnectionEmbedded';   FName : 'Embedded'),
    (FBMD : bmdAudioConnectionAESEBU;     FTypeStr: 'bmdAudioConnectionAESEBU';     FName : 'AES/EBU'),
    (FBMD : bmdAudioConnectionAnalog;     FTypeStr: 'bmdAudioConnectionAnalog';     FName : 'Analog'),
    (FBMD : bmdAudioConnectionAnalogXLR;  FTypeStr: 'bmdAudioConnectionAnalogXLR';  FName : 'Analog XLR'),
    (FBMD : bmdAudioConnectionAnalogRCA;  FTypeStr: 'bmdAudioConnectionAnalogRCA';  FName : 'Analog RCA')
  );


(* _BMDDisplayMode *)
const
  _DisplayModeLinks : array [0..39] of TBMDLink =  (
    (FBMD : bmdModeNTSC;                  FName : 'NTSC'),
    (FBMD : bmdModeNTSC2398;              FName : 'NTSC 23.98'),
    (FBMD : bmdModePAL;                   FName : 'PAL'),
    (FBMD : bmdModeNTSCp;                 FName : 'NTSCp'),
    (FBMD : bmdModePALp;                  FName : 'PALp'),
    (FBMD : bmdModeHD1080p2398;           FName : '1080p23.98'),
    (FBMD : bmdModeHD1080p2398Pulldown;   FName : '1080p23.98 Pulldown'),
    (FBMD : bmdModeHD1080p24;             FName : '1080p24'),
    (FBMD : bmdModeHD1080p25;             FName : '1080p25'),
    (FBMD : bmdModeHD1080p2997;           FName : '1080p29.97'),
    (FBMD : bmdModeHD1080p30;             FName : '1080p30'),
    (FBMD : bmdModeHD1080i50;             FName : '1080i50'),
    (FBMD : bmdModeHD1080i5994;           FName : '1080i59.94'),
    (FBMD : bmdModeHD1080i6000;           FName : '1080i60'),
    (FBMD : bmdModeHD1080p50;             FName : '1080p50'),
    (FBMD : bmdModeHD1080p5994;           FName : '1080p59.94'),
    (FBMD : bmdModeHD1080p6000;           FName : '1080p60'),
    (FBMD : bmdModeHD720p50;              FName : '720p50'),
    (FBMD : bmdModeHD720p5994;            FName : '720p59.94'),
    (FBMD : bmdModeHD720p60;              FName : '720p60'),
    (FBMD : bmdMode2k2398;                FName : '2k23.98'),
    (FBMD : bmdMode2k24;                  FName : '2k24'),
    (FBMD : bmdMode2k25;                  FName : '2k25'),
    (FBMD : bmdMode2kDCI2398;             FName : '2kDCI23.98'),
    (FBMD : bmdMode2kDCI24;               FName : '2kDCI24'),
    (FBMD : bmdMode2kDCI25;               FName : '2kDCI25'),
    (FBMD : bmdModeRAW1366p24;            FName : 'RAW1366p24'),
    (FBMD : bmdModeRAW1112p24;            FName : 'RAW1112p24'),
    (FBMD : bmdMode4K2160p2398;           FName : '4K2160p23.98'),
    (FBMD : bmdMode4K2160p24;             FName : '4K2160p24'),
    (FBMD : bmdMode4K2160p25;             FName : '4K2160p25'),
    (FBMD : bmdMode4K2160p2997;           FName : '4K2160p29.97'),
    (FBMD : bmdMode4K2160p30;             FName : '4K2160p30'),
    (FBMD : bmdMode4K2160p50;             FName : '4K2160p50'),
    (FBMD : bmdMode4K2160p5994;           FName : '4K2160p59.94'),
    (FBMD : bmdMode4K2160p60;             FName : '4K2160p60'),
    (FBMD : bmdMode4kDCI2398;             FName : '4kDCI2398'),
    (FBMD : bmdMode4kDCI24;               FName : '4kDCI24'),
    (FBMD : bmdMode4kDCI25;               FName : '4kDCI25'),
    (FBMD : bmdModeUnknown;               FName : '')
  );


(* _BMDPixelFormat *)
const
  _PixelFormatLinks : array [0..13] of TBMDLink =  (
    (FBMD : bmdFormat8BitYUV;           FTypeStr: 'bmdFormat8BitYUV';           FName : 'YUV 8bit'),
    (FBMD : bmdFormat10BitYUV;          FTypeStr: 'bmdFormat10BitYUV';          FName : 'YUV 10bit'),
    (FBMD : bmdFormat8BitARGB;          FTypeStr: 'bmdFormat8BitARGB';          FName : 'ARGB 8bit'),
    (FBMD : bmdFormat8BitBGRA;          FTypeStr: 'bmdFormat8BitBGRA';          FName : 'BGRA 8bit'),
    (FBMD : bmdFormat10BitRGB;          FTypeStr: 'bmdFormat10BitRGB';          FName : 'RGB 10bit'),
    (FBMD : bmdFormat12BitRGB;          FTypeStr: 'bmdFormat12BitRGB';          FName : 'RGB 12bit'),
    (FBMD : bmdFormat12BitRGBLE;        FTypeStr: 'bmdFormat12BitRGBLE';        FName : 'RGBLE 12bit'),
    (FBMD : bmdFormat10BitXYZ;          FTypeStr: 'bmdFormat10BitXYZ';          FName : 'XYZ 10bit'),
    (FBMD : bmdFormat8BitRGBA;          FTypeStr: 'bmdFormat8BitRGBA';          FName : 'RGBA 8bit'),
    (FBMD : bmdFormat10BitRGBXLE;       FTypeStr: 'bmdFormat10BitRGBXLE';       FName : 'RGBXLE 10bit'),
    (FBMD : bmdFormat10BitRGBX;         FTypeStr: 'bmdFormat10BitRGBX';         FName : 'RGBX 10bit'),
    (FBMD : bmdFormat10BitRGBXLE_FULL;  FTypeStr: 'bmdFormat10BitRGBXLE_FULL';  FName : 'RGBXLE Full 10bit'),
    (FBMD : bmdFormat10BitRGBX_FULL;    FTypeStr: 'bmdFormat10BitRGBX_FULL';    FName : 'RGBX Full 10bit'),
    (FBMD : bmdFormat12BitRAW;          FTypeStr: 'bmdFormat12BitRAW';          FName : 'RAW 12bit')
  );



(* _BMDAudioSampleRate *)
const
  _AudioSampleRateLinks : array [0..0] of TBMDLink =  (
    (FBMD : bmdAudioSampleRate48kHz;    FTypeStr: 'bmdAudioSampleRate48kHz';    FName : '48kHz')
  );

(* _BMDAudioSampleType *)
const
  _AudioSampleTypeLinks : array [0..1] of TBMDLink =  (
    (FBMD : bmdAudioSampleType16bitInteger;    FTypeStr: 'bmdAudioSampleType16bitInteger';    FName : '16 bit'),
    (FBMD : bmdAudioSampleType32bitInteger;    FTypeStr: 'bmdAudioSampleType32bitInteger';    FName : '32 bit')
  );



Type
  EBMDConverts = Exception;

  TBMDConverts = record
  public
    class function StringToBMDDisplayMode(AValue: string; out AOut: _BMDDisplayMode): boolean; static;
    class function BMDDisplayModeToString(AValue: _BMDDisplayMode; out AOut: string): boolean; static;
    class function StringToBMDPixelFormat(AValue: string; out AOut: _BMDPixelFormat): boolean; static;
    class function BMDPixelFormatToString(AValue: _BMDPixelFormat; out AOut: string): boolean; static;
    class function StringToBMDAudioSampleRate(AValue: string; out AOut: _BMDAudioSampleRate): boolean; static;
    class function BMDAudioSampleRateToString(AValue: _BMDAudioSampleRate; out AOut: string): boolean; static;
    class function StringToBMDAudioSampleType(AValue: string; out AOut: _BMDAudioSampleType): boolean; static;
    class function BMDAudioSampleTypeToString(AValue: _BMDAudioSampleType; out AOut: string): boolean; static;
    class function BMDVideoConnectionToString(AValue: _BMDVideoConnection; out AOut: string): boolean; static;

    class function BMDVideoConnection(AValue: string): TBMDLink;  overload; static;
    class function BMDVideoConnection(AValue: _BMDVideoConnection): TBMDLink; overload; static;
    class function BMDAudioConnection(AValue: string): TBMDLink;  overload; static;
    class function BMDAudioConnection(AValue: _BMDAudioConnection): TBMDLink; overload; static;
    class function BMDDisplayMode(AValue: string): TBMDLink;  overload; static;
    class function BMDDisplayMode(AValue: _BMDDisplayMode): TBMDLink; overload; static;
    class function BMDPixelFormat(AValue: string): TBMDLink;  overload; static;
    class function BMDPixelFormat(AValue: _BMDPixelFormat): TBMDLink; overload; static;



    class function BMDAudioSampleRate(AValue: string): TBMDLink;  overload; static;
    class function BMDAudioSampleRate(AValue: _BMDAudioSampleRate): TBMDLink; overload; static;

    class function BMDAudioSampleType(AValue: string): TBMDLink;  overload; static;
    class function BMDAudioSampleType(AValue: _BMDAudioSampleType): TBMDLink; overload; static;
  end;

type
  TDeckLink2Json = record
  private
  public
    class function IDeckLink2Json(ADeckLink: IDeckLink): TJsonObject; static;
    class function GetIDeckLink(var ADeckLink: IDeckLink): TJsonObject; static;
    class function GetIDeckLinkInput(var ADeckLink: IDeckLink): TJsonArray; static;
    class function GetIDeckLinkOutput(var ADeckLink: IDeckLink): TJsonArray; static;
    class function GetIDeckLinkAttributes(var ADeckLink: IDeckLink): TJsonObject; static;
  end;

Type
  TBMDUtils = record
  public
    class function GetDeviceIndex(ADeckLink: IDeckLink): integer; static;
    class function GetSubDeviceIndex(ADeckLink: IDeckLink): integer; static;
    class function DeviceIsBusy(ADeckLink: IDeckLink): boolean; static;
    class function GetDeviceModelName(ADeckLink: IDeckLink): string; static;
  end;


TBMDDisplayMode = record
  private
    FDisplayMode          : _BMDDisplayMode;
    FModeName             : string;
    FString               : string;
    FWidth                : integer;
    FHeight               : integer;
    FTimeScale            : Int64;
    FFrameDuration        : Int64;
  public
    class function Create(AValue: _BMDDisplayMode): TBMDDisplayMode; static;
    property DisplayMode          : _BMDDisplayMode read FDisplayMode write FDisplayMode;
    property ModeName             : string read FModeName write FModeName;
    property asString             : string read FString write FString;
    property Width                : integer read FWidth write FWidth;
    property Height               : integer read FHeight write FHeight;
    property TimeScale            : Int64 read FTimeScale write FTimeScale;
    property FrameDuration        : Int64 read FFrameDuration write FFrameDuration;
  end;

implementation

class function TBMDDisplayMode.Create(AValue: _BMDDisplayMode): TBMDDisplayMode;
begin
  case AValue of
    bmdModeNTSC:
    begin
      result.DisplayMode := AValue;
      result.asString := 'bmdModeNTSC';
      result.ModeName:='NTSC';
      result.Width:=720;
      result.Height:=486;
      result.FrameDuration:=30000;
      result.TimeScale:=1001;
    end;
    bmdModeNTSC2398:
    begin
      result.DisplayMode := AValue;
      result.asString := 'bmdModeNTSC2398';
      result.ModeName:='NTSC 23.98';
      result.Width:=720;
      result.Height:=486;
      result.FrameDuration:=24000;
      result.TimeScale:=1001;
    end;
    bmdModeNTSCp:
    begin
      result.DisplayMode := AValue;
      result.asString := 'bmdModeNTSCp';
      result.ModeName:='NTSCp';
      result.Width:=720;
      result.Height:=486;
      result.FrameDuration:=60000;
       result.TimeScale:=1001;
    end;
    bmdModePAL:
    begin
      result.DisplayMode := AValue;
      result.asString := 'bmdModePAL';
      result.ModeName:='PAL';
      result.Width:=720;
      result.Height:=576;
      result.frameDuration:=25000;
      result.timeScale:=1000;
    end;
    bmdModePALp:
    begin
      result.DisplayMode := AValue;
      result.asString := 'bmdModePALp';
      result.ModeName:='PAL';
      result.Width:=720;
      result.Height:=576;
      result.frameDuration:=50000;
      result.timeScale:=1000;
    end;
    bmdModeHD1080p2398:
    begin
      result.DisplayMode := AValue;
      result.asString := 'bmdModeHD1080p2398';
      result.ModeName:='HD 1080p 23.98';
      result.Width:=1920;
      result.Height:=1080;
      result.frameDuration:=24000;
      result.timeScale:=1001;
    end;
    bmdModeHD1080p24:
    begin
      result.DisplayMode := AValue;
      result.asString := 'bmdModeHD1080p24';
      result.ModeName:='HD 1080p 24';
      result.Width:=1920;
      result.Height:=1080;
      result.frameDuration:=24000;
      result.timeScale:=1000;
    end;
    bmdModeHD1080p25:
    begin
      result.DisplayMode := AValue;
      result.asString := 'bmdModeHD1080p25';
      result.ModeName:='HD 1080p 25';
      result.Width:=1920;
      result.Height:=1080;
      result.frameDuration:=25000;
      result.timeScale:=1000;
    end;
    bmdModeHD1080p2997:
    begin
      result.DisplayMode := AValue;
      result.asString := 'bmdModeHD1080p2997';
      result.ModeName:='HD 1080p 29.97';
      result.Width:=1920;
      result.Height:=1080;
      result.frameDuration:=30000;
      result.timeScale:=1001;
    end;
    bmdModeHD1080p30:
    begin
      result.DisplayMode := AValue;
      result.asString := 'bmdModeHD1080p30';
      result.ModeName:='HD 1080p 30';
      result.Width:=1920;
      result.Height:=1080;
      result.frameDuration:=30000;
      result.timeScale:=1000;
    end;
    bmdModeHD1080i50:
    begin
      result.DisplayMode := AValue;
      result.asString := 'bmdModeHD1080i50';
      result.ModeName:='HD 1080i 50';
      result.Width:=1920;
      result.Height:=1080;
      result.frameDuration:=25000;
      result.timeScale:=1000;
    end;
    bmdModeHD1080i5994:
    begin
      result.DisplayMode := AValue;
      result.asString := 'bmdModeHD1080i5994';
      result.ModeName:='HD 1080i 59.94';
      result.Width:=1920;
      result.Height:=1080;
      result.frameDuration:=30000;
      result.timeScale:=1001;
    end;
    bmdModeHD1080i6000:
    begin
      result.DisplayMode := AValue;
      result.asString := 'bmdModeHD1080i6000';
      result.ModeName:='HD 1080i 60';
      result.Width:=1920;
      result.Height:=1080;
      result.frameDuration:=30000;
      result.timeScale:=1000;
    end;
    bmdModeHD1080p50:
    begin
      result.DisplayMode := AValue;
      result.asString := 'bmdModeHD1080p50';
      result.ModeName:='HD 1080p 50';
      result.Width:=1920;
      result.Height:=1080;
      result.frameDuration:=50000;
      result.timeScale:=1000;
    end;
    bmdModeHD1080p5994:
    begin
      result.DisplayMode := AValue;
      result.asString := 'bmdModeHD1080p5994';
      result.ModeName:='HD 1080i 59.94';
      result.Width:=1920;
      result.Height:=1080;
      result.frameDuration:=30000;
      result.timeScale:=1001;
    end;
    bmdModeHD1080p6000:
    begin
      result.DisplayMode := AValue;
      result.asString := 'bmdModeHD1080p6000';
      result.ModeName:='HD 1080i 60';
      result.Width:=1920;
      result.Height:=1080;
      result.frameDuration:=30000;
      result.timeScale:=1000;
    end;
    bmdModeHD720p50:
    begin
      result.DisplayMode := AValue;
      result.asString := 'bmdModeHD720p50';
      result.ModeName:='HD 720p 50';
      result.Width:=1280;
      result.Height:=720;
      result.frameDuration:=50000;
      result.timeScale:=1000;
    end;
    bmdModeHD720p5994:
    begin
      result.DisplayMode := AValue;
      result.asString := 'bmdModeHD720p5994';
      result.ModeName:='HD 720p 59.94';
      result.Width:=1280;
      result.Height:=720;
      result.frameDuration:=60000;
      result.timeScale:=1001;
    end;
    bmdModeHD720p60:
    begin
      result.DisplayMode := AValue;
      result.asString := 'bmdModeHD720p60';
      result.ModeName:='HD 720p 60';
      result.Width:=1280;
      result.Height:=720;
      result.frameDuration:=60000;
      result.timeScale:=1000;
    end;
    bmdMode2k2398:
    begin
      result.DisplayMode := AValue;
    end;
    bmdMode2k24:
    begin
      result.DisplayMode := AValue;
    end;
    bmdMode2k25:
    begin
      result.DisplayMode := AValue;
    end;
    bmdMode4K2160p2398:
    begin
      result.DisplayMode := AValue;
    end;
    bmdMode4K2160p24:
    begin
      result.DisplayMode := AValue;
    end;
    bmdMode4K2160p25:
    begin
      result.DisplayMode := AValue;
    end;
    bmdMode4K2160p2997:
    begin
      result.DisplayMode := AValue;
    end;
    bmdMode4K2160p30:
    begin
      result.DisplayMode := AValue;
    end;
    bmdMode4kDCI2398:
    begin
      result.DisplayMode := AValue;
    end;
    bmdMode4kDCI24:
    begin
      result.DisplayMode := AValue;
    end;
    bmdMode4kDCI25:
    begin
      result.DisplayMode := AValue;
    end;
    bmdModeUnknown:
    begin
      result.DisplayMode := AValue;
    end;
    else raise Exception.Create('_BMDDisplayMode not find');
  end;
end;



(* TBMDConverts *)

class function TBMDConverts.BMDDisplayModeToString(AValue: _BMDDisplayMode; out AOut: string): boolean;
begin
  result := true;
  case AValue of
    bmdModeNTSC: AOut := 'bmdModeNTSC';
    bmdModeNTSC2398: AOut := 'bmdModeNTSC2398';
    bmdModePAL: AOut := 'bmdModePAL';
    bmdModeNTSCp: AOut := 'bmdModeNTSCp';
    bmdModePALp: AOut := 'bmdModePALp';
    bmdModeHD1080p2398: AOut := 'bmdModeHD1080p2398';
    bmdModeHD1080p2398Pulldown: AOut := 'bmdModeHD1080p2398Pulldown';
    bmdModeHD1080p24: AOut := 'bmdModeHD1080p24';
    bmdModeHD1080p25: AOut := 'bmdModeHD1080p25';
    bmdModeHD1080p2997: AOut := 'bmdModeHD1080p2997';
    bmdModeHD1080p30: AOut := 'bmdModeHD1080p30';
    bmdModeHD1080i50: AOut := 'bmdModeHD1080i50';
    bmdModeHD1080i5994: AOut := 'bmdModeHD1080i5994';
    bmdModeHD1080i6000: AOut := 'bmdModeHD1080i6000';
    bmdModeHD1080p50: AOut := 'bmdModeHD1080p50';
    bmdModeHD1080p5994: AOut := 'bmdModeHD1080p5994';
    bmdModeHD1080p6000: AOut := 'bmdModeHD1080p6000';
    bmdModeHD720p50: AOut := 'bmdModeHD720p50';
    bmdModeHD720p5994: AOut := 'bmdModeHD720p5994';
    bmdModeHD720p60: AOut := 'bmdModeHD720p60';
    bmdMode2k2398: AOut := 'bmdMode2k2398';
    bmdMode2k24: AOut := 'bmdMode2k24';
    bmdMode2k25: AOut := 'bmdMode2k25';
    bmdMode2kDCI2398: AOut := 'bmdMode2kDCI2398';
    bmdMode2kDCI24: AOut := 'bmdMode2kDCI24';
    bmdMode2kDCI25: AOut := 'bmdMode2kDCI25';
    bmdModeRAW1366p24: AOut := 'bmdModeRAW1366p24';
    bmdModeRAW1112p24: AOut := 'bmdModeRAW1112p24';
    bmdMode4K2160p2398: AOut := 'bmdMode4K2160p2398';
    bmdMode4K2160p24: AOut := 'bmdMode4K2160p24';
    bmdMode4K2160p25: AOut := 'bmdMode4K2160p25';
    bmdMode4K2160p2997: AOut := 'bmdMode4K2160p2997';
    bmdMode4K2160p30: AOut := 'bmdMode4K2160p30';
    bmdMode4K2160p50: AOut := 'bmdMode4K2160p50';
    bmdMode4K2160p5994: AOut := 'bmdMode4K2160p5994';
    bmdMode4K2160p60: AOut := 'bmdMode4K2160p60';
    bmdMode4kDCI2398: AOut := 'bmdMode4kDCI2398';
    bmdMode4kDCI24: AOut := 'bmdMode4kDCI24';
    bmdMode4kDCI25: AOut := 'bmdMode4kDCI25';
    bmdModeUnknown: AOut := 'bmdModeUnknown';
    else result := false;
  end;
end;

class function TBMDConverts.StringToBMDDisplayMode(AValue: string; out AOut: _BMDDisplayMode): boolean;
begin
  result := true;
  if SameText('bmdModeNTSC', AValue) then AOut := bmdModeNTSC else
  if SameText('bmdModeNTSC2398', AValue) then AOut := bmdModeNTSC2398 else
  if SameText('bmdModePAL', AValue) then AOut := bmdModePAL else
  if SameText('bmdModeNTSCp', AValue) then AOut := bmdModeNTSCp else
  if SameText('bmdModePALp', AValue) then AOut := bmdModePALp else
  if SameText('bmdModeHD1080p2398', AValue) then AOut := bmdModeHD1080p2398 else
  if SameText('bmdModeHD1080p2398Pulldown', AValue) then AOut := bmdModeHD1080p2398Pulldown else
  if SameText('bmdModeHD1080p24', AValue) then AOut := bmdModeHD1080p24 else
  if SameText('bmdModeHD1080p25', AValue) then AOut := bmdModeHD1080p25 else
  if SameText('bmdModeHD1080p2997', AValue) then AOut := bmdModeHD1080p2997 else
  if SameText('bmdModeHD1080p30', AValue) then AOut := bmdModeHD1080p30 else
  if SameText('bmdModeHD1080i50', AValue) then AOut := bmdModeHD1080i50 else
  if SameText('bmdModeHD1080i5994', AValue) then AOut := bmdModeHD1080i5994 else
  if SameText('bmdModeHD1080i6000', AValue) then AOut := bmdModeHD1080i6000 else
  if SameText('bmdModeHD1080p50', AValue) then AOut := bmdModeHD1080p50 else
  if SameText('bmdModeHD1080p5994', AValue) then AOut := bmdModeHD1080p5994 else
  if SameText('bmdModeHD1080p6000', AValue) then AOut := bmdModeHD1080p6000 else
  if SameText('bmdModeHD720p50', AValue) then AOut := bmdModeHD720p50 else
  if SameText('bmdModeHD720p5994', AValue) then AOut := bmdModeHD720p5994 else
  if SameText('bmdModeHD720p60', AValue) then AOut := bmdModeHD720p60 else
  if SameText('bmdMode2k2398', AValue) then AOut := bmdMode2k2398 else
  if SameText('bmdMode2k24', AValue) then AOut := bmdMode2k24 else
  if SameText('bmdMode2k25', AValue) then AOut := bmdMode2k25 else
  if SameText('bmdMode2kDCI2398', AValue) then AOut := bmdMode2kDCI2398 else
  if SameText('bmdMode2kDCI24', AValue) then AOut := bmdMode2kDCI24 else
  if SameText('bmdMode2kDCI25', AValue) then AOut := bmdMode2kDCI25 else
  if SameText('bmdModeRAW1366p24', AValue) then AOut := bmdModeRAW1366p24 else
  if SameText('bmdModeRAW1112p24', AValue) then AOut := bmdModeRAW1112p24 else
  if SameText('bmdMode4K2160p2398', AValue) then AOut := bmdMode4K2160p2398 else
  if SameText('bmdMode4K2160p24', AValue) then AOut := bmdMode4K2160p24 else
  if SameText('bmdMode4K2160p25', AValue) then AOut := bmdMode4K2160p25 else
  if SameText('bmdMode4K2160p2997', AValue) then AOut := bmdMode4K2160p2997 else
  if SameText('bmdMode4K2160p30', AValue) then AOut := bmdMode4K2160p30 else
  if SameText('bmdMode4K2160p50', AValue) then AOut := bmdMode4K2160p50 else
  if SameText('bmdMode4K2160p5994', AValue) then AOut := bmdMode4K2160p5994 else
  if SameText('bmdMode4K2160p60', AValue) then AOut := bmdMode4K2160p60 else
  if SameText('bmdMode4kDCI2398', AValue) then AOut := bmdMode4kDCI2398 else
  if SameText('bmdMode4kDCI24', AValue) then AOut := bmdMode4kDCI24 else
  if SameText('bmdMode4kDCI25', AValue) then AOut := bmdMode4kDCI25 else
  if SameText('bmdModeUnknown', AValue) then AOut := bmdModeUnknown else
  result := false;
end;

class function TBMDConverts.BMDPixelFormatToString(AValue: _BMDPixelFormat; out AOut: string): boolean;
begin
  result := true;
  case AValue of
    bmdFormat8BitYUV: AOut := 'bmdFormat8BitYUV';
    bmdFormat10BitYUV: AOut := 'bmdFormat10BitYUV';
    bmdFormat8BitARGB: AOut := 'bmdFormat8BitARGB';
    bmdFormat8BitBGRA: AOut := 'bmdFormat8BitBGRA';
    bmdFormat10BitRGB: AOut := 'bmdFormat10BitRGB';
    bmdFormat12BitRGB: AOut := 'bmdFormat12BitRGB';
    bmdFormat12BitRGBLE: AOut := 'bmdFormat12BitRGBLE';
    bmdFormat10BitXYZ: AOut := 'bmdFormat10BitXYZ';
    bmdFormat8BitRGBA: AOut := 'bmdFormat8BitRGBA';
    bmdFormat10BitRGBXLE: AOut := 'bmdFormat10BitRGBXLE';
    bmdFormat10BitRGBX: AOut := 'bmdFormat10BitRGBX';
    bmdFormat10BitRGBXLE_FULL: AOut := 'bmdFormat10BitRGBXLE_FULL';
    bmdFormat10BitRGBX_FULL: AOut := 'bmdFormat10BitRGBX_FULL';
    bmdFormat12BitRAW: AOut := 'bmdFormat12BitRAW';
    else result := false;
  end;
end;

class function TBMDConverts.StringToBMDPixelFormat(AValue: string; out AOut: _BMDPixelFormat): boolean;
begin
  result := true;
  if SameText('bmdFormat8BitYUV', AValue) then AOut := bmdFormat8BitYUV else
  if SameText('bmdFormat10BitYUV ', AValue) then AOut := bmdFormat10BitYUV else
  if SameText('bmdFormat8BitARGB', AValue) then AOut := bmdFormat8BitARGB else
  if SameText('bmdFormat8BitBGRA', AValue) then AOut := bmdFormat8BitBGRA else
  if SameText('bmdFormat10BitRGB', AValue) then AOut := bmdFormat10BitRGB else
  if SameText('bmdFormat12BitRGB', AValue) then AOut := bmdFormat12BitRGB else
  if SameText('bmdFormat12BitRGBLE', AValue) then AOut := bmdFormat12BitRGBLE else
  if SameText('bmdFormat10BitXYZ', AValue) then AOut := bmdFormat10BitXYZ else
  if SameText('bmdFormat8BitRGBA', AValue) then AOut := bmdFormat8BitRGBA else
  if SameText('bmdFormat10BitRGBXLE', AValue) then AOut := bmdFormat10BitRGBXLE else
  if SameText('bmdFormat10BitRGBX', AValue) then AOut := bmdFormat10BitRGBX else
  if SameText('bmdFormat10BitRGBXLE_FULL', AValue) then AOut := bmdFormat10BitRGBXLE_FULL else
  if SameText('bmdFormat10BitRGBX_FULL', AValue) then AOut := bmdFormat10BitRGBX_FULL else
  if SameText('bmdFormat12BitRAW', AValue) then AOut := bmdFormat12BitRAW else
  result := false;
end;

class function TBMDConverts.StringToBMDAudioSampleRate(AValue: string; out AOut: _BMDAudioSampleRate): boolean;
begin
  result := true;
  if SameText('bmdAudioSampleRate48kHz', AValue) then AOut := bmdAudioSampleRate48kHz else
  result := false;
end;

class function TBMDConverts.BMDAudioSampleRateToString(AValue: _BMDAudioSampleRate; out AOut: string): boolean;
begin
  result := true;
  case AValue of
    bmdAudioSampleRate48kHz: AOut := 'bmdAudioSampleRate48kHz';
    else result := false;
  end;
end;

class function TBMDConverts.StringToBMDAudioSampleType(AValue: string; out AOut: _BMDAudioSampleType): boolean;
begin
  result := true;
  if SameText('bmdAudioSampleType16bitInteger', AValue) then AOut := bmdAudioSampleType16bitInteger else
  if SameText('bmdAudioSampleType32bitInteger', AValue) then AOut := bmdAudioSampleType32bitInteger else
  result := false;
end;

class function TBMDConverts.BMDAudioSampleTypeToString(AValue: _BMDAudioSampleType; out AOut: string): boolean;
begin
  result := true;
  case AValue of
    bmdAudioSampleType16bitInteger: AOut := 'bmdAudioSampleType16bitInteger';
    bmdAudioSampleType32bitInteger: AOut := 'bmdAudioSampleType32bitInteger';
    else result := false;
  end;
end;

class function TBMDConverts.BMDVideoConnectionToString(AValue: _BMDVideoConnection; out AOut: string): boolean;
begin
  result := true;
  case AValue of
    bmdVideoConnectionSDI : AOut := 'bmdVideoConnectionSDI';
    bmdVideoConnectionHDMI : AOut := 'bmdVideoConnectionHDMI';
    bmdVideoConnectionOpticalSDI : AOut := 'bmdVideoConnectionOpticalSDI';
    bmdVideoConnectionComponent : AOut := 'bmdVideoConnectionComponent';
    bmdVideoConnectionComposite : AOut := 'bmdVideoConnectionComposite';
    bmdVideoConnectionSVideo : AOut := 'bmdVideoConnectionSVideo';
    else result := false;
  end;
end;

class function TBMDConverts.BMDVideoConnection(AValue: string): TBMDLink;
var
  i : integer;
begin
  for I := Low(_VideoConnectionLinks) to High(_VideoConnectionLinks) do
  begin
    if ((_VideoConnectionLinks[i].AsString = AValue) or (_VideoConnectionLinks[i].Name = AValue)) then
    begin
      result := _VideoConnectionLinks[i];
      exit;
    end;
  end;
  raise EBMDConverts.Create('Error get link');
end;


class function TBMDConverts.BMDVideoConnection(AValue: _BMDVideoConnection): TBMDLink;
var
  i : integer;
begin
  for I := Low(_VideoConnectionLinks) to High(_VideoConnectionLinks) do
  begin
    if _VideoConnectionLinks[i].BMD = AValue then
    begin
      result := _VideoConnectionLinks[i];
      exit;
    end;
  end;
  raise EBMDConverts.Create('Error get link');
end;

class function TBMDConverts.BMDAudioConnection(AValue: string): TBMDLink;
var
  i : integer;
begin
  for I := Low(_AudioConnectionLinks) to High(_AudioConnectionLinks) do
  begin
    if ((_AudioConnectionLinks[i].AsString = AValue) or (_AudioConnectionLinks[i].Name = AValue)) then
    begin
      result := _AudioConnectionLinks[i];
      exit;
    end;
  end;
  raise EBMDConverts.Create('Error get link');
end;

class function TBMDConverts.BMDAudioConnection(AValue: _BMDAudioConnection): TBMDLink;
var
  i : integer;
begin
  for I := Low(_AudioConnectionLinks) to High(_AudioConnectionLinks) do
  begin
    if _AudioConnectionLinks[i].BMD = AValue then
    begin
      result := _AudioConnectionLinks[i];
      exit;
    end;
  end;
  raise EBMDConverts.Create('Error get link');
end;



class function TBMDConverts.BMDDisplayMode(AValue: string): TBMDLink;
var
  i : integer;
begin
  for I := Low(_DisplayModeLinks) to High(_DisplayModeLinks) do
  begin
    if ((_DisplayModeLinks[i].AsString = AValue) or (_DisplayModeLinks[i].Name = AValue)) then
    begin
      result := _DisplayModeLinks[i];
      exit;
    end;
  end;
  raise EBMDConverts.Create('Error get link');
end;

class function TBMDConverts.BMDDisplayMode(AValue: _BMDDisplayMode): TBMDLink;
var
  i : integer;
begin
  for I := Low(_DisplayModeLinks) to High(_DisplayModeLinks) do
  begin
    if _DisplayModeLinks[i].BMD = AValue then
    begin
      result := _DisplayModeLinks[i];
      exit;
    end;
  end;
  raise EBMDConverts.Create('Error get link');
end;


class function TBMDConverts.BMDPixelFormat(AValue: string): TBMDLink;
var
  i : integer;
begin
  for I := Low(_PixelFormatLinks) to High(_PixelFormatLinks) do
  begin
    if ((_PixelFormatLinks[i].AsString = AValue) or (_PixelFormatLinks[i].Name = AValue)) then
    begin
      result := _PixelFormatLinks[i];
      exit;
    end;
  end;
  raise EBMDConverts.Create('Error get link');
end;

class function TBMDConverts.BMDPixelFormat(AValue: _BMDPixelFormat): TBMDLink;
var
  i : integer;
begin
  for I := Low(_PixelFormatLinks) to High(_PixelFormatLinks) do
  begin
    if _PixelFormatLinks[i].BMD = AValue then
    begin
      result := _PixelFormatLinks[i];
      exit;
    end;
  end;
  raise EBMDConverts.Create('Error get link');
end;

class function TBMDConverts.BMDAudioSampleRate(AValue: string): TBMDLink;
var
  i : integer;
begin
  for I := Low(_AudioSampleRateLinks) to High(_AudioSampleRateLinks) do
  begin
    if ((_AudioSampleRateLinks[i].AsString = AValue) or (_AudioSampleRateLinks[i].Name = AValue)) then
    begin
      result := _AudioSampleRateLinks[i];
      exit;
    end;
  end;
  raise EBMDConverts.Create('Error get link');
end;

class function TBMDConverts.BMDAudioSampleRate(AValue: _BMDAudioSampleRate): TBMDLink;
var
  i : integer;
begin
  for I := Low(_AudioSampleRateLinks) to High(_AudioSampleRateLinks) do
  begin
    if _AudioSampleRateLinks[i].BMD = AValue then
    begin
      result := _AudioSampleRateLinks[i];
      exit;
    end;
  end;
  raise EBMDConverts.Create('Error get link');
end;

class function TBMDConverts.BMDAudioSampleType(AValue: string): TBMDLink;
var
  i : integer;
begin
  for I := Low(_AudioSampleTypeLinks) to High(_AudioSampleTypeLinks) do
  begin
    if ((_AudioSampleTypeLinks[i].AsString = AValue) or (_AudioSampleTypeLinks[i].Name = AValue)) then
    begin
      result := _AudioSampleTypeLinks[i];
      exit;
    end;
  end;
  raise EBMDConverts.Create('Error get link');
end;

class function TBMDConverts.BMDAudioSampleType(AValue: _BMDAudioSampleType): TBMDLink;
var
  i : integer;
begin
  for I := Low(_AudioSampleTypeLinks) to High(_AudioSampleTypeLinks) do
  begin
    if _AudioSampleTypeLinks[i].BMD = AValue then
    begin
      result := _AudioSampleTypeLinks[i];
      exit;
    end;
  end;
  raise EBMDConverts.Create('Error get link');
end;

(* TBMDUtils *)
class function TBMDUtils.GetDeviceModelName(ADeckLink: IDeckLink): string;
var
  LHr : HResult;
  LModelName : widestring;
begin
  result := '';

  if ADeckLink = nil then
  begin
    raise Exception.Create('Could not obtain the IDeckLink interface');
  end;

  LHr := ADeckLink.GetModelName(LModelName);
  if LHr <> S_OK then
    raise Exception.CreateFmt('Could not GetModelName - result = %08x', [LHr]);

  result := LModelName
end;

class function TBMDUtils.GetSubDeviceIndex(ADeckLink: IDeckLink): integer;
var
  LDeckLinkAttributes   : IDeckLinkAttributes;
  LHr                   : HResult;
  LValue                : Int64;
begin
  result := -1;
  LDeckLinkAttributes := nil;
  try
    if ADeckLink = nil then
    begin
      raise Exception.Create('Could not obtain the IDeckLink interface');
    end;

    // Query the DeckLink for its attributes interface
    LHr := ADeckLink.QueryInterface(IID_IDeckLinkAttributes, LDeckLinkAttributes);
    if LHr <> S_OK then
        raise Exception.CreateFmt('Could not obtain the IDeckLinkAttributes interface - result = %08x', [LHr]);

    // BMDDeckLinkNumberOfSubDevices
    LHr := LDeckLinkAttributes.GetInt(BMDDeckLinkNumberOfSubDevices, LValue);
    if LHr = S_OK then
    begin
      if LValue <> 0 then
      begin
        LHr := LDeckLinkAttributes.GetInt(BMDDeckLinkSubDeviceIndex, LValue);
        if LHr = S_OK then
          result := LValue
        else raise Exception.CreateFmt('Could not query the sub-device index attribute- result = %08x', [LHr]);
      end else result := 0;
    end else raise Exception.CreateFmt('Could not query the number of sub-device attribute- result = %08x', [LHr]);
  except
    ;
  end;
end;

class function TBMDUtils.GetDeviceIndex(ADeckLink: IDeckLink): integer;
var
  LDeckLinkAttributes   : IDeckLinkAttributes;
  LHr                   : HResult;
  LValue                : Int64;
begin
  result := -1;
  LDeckLinkAttributes := nil;

  if ADeckLink = nil then
  begin
    raise Exception.Create('Could not obtain the IDeckLink interface');
  end;

  // Query the DeckLink for its attributes interface
  LHr := ADeckLink.QueryInterface(IID_IDeckLinkAttributes, LDeckLinkAttributes);
  if LHr <> S_OK then
    raise Exception.CreateFmt('Could not obtain the IDeckLinkAttributes interface - result = %08x', [LHr]);

  // BMDDeckLinkNumberOfSubDevices
  LHr := LDeckLinkAttributes.GetInt(BMDDeckLinkNumberOfSubDevices, LValue);
  if LHr = S_OK then
  begin
    if LValue <> 0 then
    begin
      LHr := LDeckLinkAttributes.GetInt(BMDDeckLinkSubDeviceIndex, LValue);
      if LHr <> S_OK then
        raise Exception.CreateFmt('Could not query the sub-device index attribute- result = %08x', [LHr]);
    end else result := 0;
  end
    else raise Exception.CreateFmt('Could not query the number of sub-device attribute- result = %08x', [LHr]);
end;

class function TBMDUtils.DeviceIsBusy(ADeckLink: IDeckLink): boolean;
var
  LDeckLinkAttributes   : IDeckLinkAttributes;
  LHr                   : HResult;
  LValue                : Int64;
begin
  result := false;
  LDeckLinkAttributes := nil;
  try
    if ADeckLink = nil then
    begin
      raise Exception.Create('Could not obtain the IDeckLink interface');
    end;

    // Query the DeckLink for its attributes interface
    LHr := ADeckLink.QueryInterface(IID_IDeckLinkAttributes, LDeckLinkAttributes);
    if LHr <> S_OK then
        raise Exception.CreateFmt('Could not obtain the IDeckLinkAttributes interface - result = %08x', [LHr]);

    // BMDDeckLinkDeviceBusyState
    LHr := LDeckLinkAttributes.GetInt(BMDDeckLinkDeviceBusyState, LValue);
    if LHr = S_OK then
    begin
      case _BMDDeviceBusyState(LValue) of
        bmdDeviceCaptureBusy: result := false;
        bmdDevicePlaybackBusy: result := false;
        else result := true;
      end;
    end else raise Exception.CreateFmt('Could not query the BMDDeckLinkDeviceBusyState attribute- result = %08x', [LHr]);
  except
    ;
  end;
end;

(* TDeckLink2Json *)
class function	TDeckLink2Json.GetIDeckLink(var ADeckLink: IDeckLink): TJsonObject;
var
  LJsonObject           : TJsonObject;
  LHr                   : HRESULT;
  LDisplayName          : WideString;
  LModelName            : WideString;
begin
  if ADeckLink = nil then
  begin
    raise Exception.Create('Could not obtain the IDeckLink interface');
  end;

  LJsonObject := TJsonObject.Create;
  try
    LHr := ADeckLink.GetModelName(LModelName);
    if LHr = S_OK then
      LJsonObject.AddPair(TJsonPair.Create('ModelName', TJsonString.Create(LModelName)));

    LHr := ADeckLink.GetDisplayName(LDisplayName);
    if LHr = S_OK then
      LJsonObject.AddPair(TJsonPair.Create('DisplayName', TJsonString.Create(LDisplayName)));

    result := LJsonObject.Clone as TJsonObject;
  finally
    FreeAndNil(LJsonObject);
  end;
end;

class function	TDeckLink2Json.GetIDeckLinkAttributes(var ADeckLink: IDeckLink): TJsonObject;
var
  LJsonObject           : TJsonObject;
  LHr                   : HRESULT;
  LSupported            : integer;
  LDeckLinkAttributes   : IDeckLinkAttributes;
  LPortName             : WideString;
  LValue                : Int64;
  LVideoOutputJson      : TJsonArray;
  LVideoInputJson       : TJsonArray;
begin
  LDeckLinkAttributes := nil;
  LJsonObject := TJsonObject.Create;
  try
    // Query the DeckLink for its attributes interface
    LHr:=ADeckLink.QueryInterface(IID_IDeckLinkAttributes, LDeckLinkAttributes);
    if LHr<>S_OK then
    begin
      raise Exception.CreateFmt('Could not obtain the IDeckLinkAttributes interface - result = %08x', [LHr]);
    end;

    //BMDDeckLinkDeviceBusyState
    LHr:=LDeckLinkAttributes.GetInt(BMDDeckLinkDeviceBusyState, LValue);
    if LHr = S_OK then
    begin
      case _BMDDeviceBusyState(LValue) of
        bmdDeviceCaptureBusy: LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkDeviceBusyState', TJsonString.Create('bmdDeviceCaptureBusy')));
        bmdDevicePlaybackBusy: LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkDeviceBusyState', TJsonString.Create('bmdDevicePlaybackBusy')));
        bmdDeviceSerialPortBusy: LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkDeviceBusyState', TJsonString.Create('bmdDeviceSerialPortBusy')));
      end;
   end else
      raise Exception.CreateFmt('Could not query the BMDDeckLinkDeviceBusyState attribute- result = %08x', [LHr]);

    //BMDDeckLinkHasSerialPort
    LHr:=LDeckLinkAttributes.GetFlag(BMDDeckLinkHasSerialPort, LSupported);
    if LHr = S_OK then
    begin
      if boolean(LSupported) then
        LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkHasSerialPort', TJsonTrue.Create))
      else
        LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkHasSerialPort', TJsonFalse.Create));

      if boolean(LSupported) then
      begin
        LHr:=LDeckLinkAttributes.GetString(BMDDeckLinkSerialPortDeviceName, LPortName);
        if LHr = S_OK then
          LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkSerialPortDeviceName', TJsonString.Create(LPortName)))
        else
          raise Exception.CreateFmt('Could not query the serial port name attribute- result = %08x', [LHr]);
      end;
    end else
      raise Exception.CreateFmt('Could not query the serial port presence attribute- result = %08x', [LHr]);

    // BMDDeckLinkPersistentID
    LHr := LDeckLinkAttributes.GetInt(BMDDeckLinkPersistentID, LValue);
    if LHr = S_OK then
      LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkPersistentID', TJsonNumber.Create(LValue)));

    // BMDDeckLinkTopologicalID
    LHr := LDeckLinkAttributes.GetInt(BMDDeckLinkTopologicalID, LValue);
    if LHr = S_OK then
      LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkTopologicalID', TJsonNumber.Create(LValue)));

    // BMDDeckLinkNumberOfSubDevices
    LHr := LDeckLinkAttributes.GetInt(BMDDeckLinkNumberOfSubDevices, LValue);
    if LHr = S_OK then
    begin
      LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkNumberOfSubDevices', TJsonNumber.Create(LValue)));
      if LValue<>0 then
      begin
        LHr := LDeckLinkAttributes.GetInt(BMDDeckLinkSubDeviceIndex, LValue);
        if LHr = S_OK then
          LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkSubDeviceIndex', TJsonNumber.Create(LValue)))
        else
          raise Exception.CreateFmt('Could not query the sub-device index attribute- result = %08x', [LHr]);
      end;
    end else
      raise Exception.CreateFmt('Could not query the number of sub-device attribute- result = %08x', [LHr]);

    //BMDDeckLinkMaximumAudioChannels
    LHr := LDeckLinkAttributes.GetInt(BMDDeckLinkMaximumAudioChannels, LValue);
    if LHr = S_OK then
      LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkMaximumAudioChannels', TJsonNumber.Create(LValue)))
    else
      raise Exception.CreateFmt('Could not query the internal keying attribute- result = %08x', [LHr]);

    //BMDDeckLinkSupportsInputFormatDetection
    LHr := LDeckLinkAttributes.GetFlag(BMDDeckLinkSupportsInputFormatDetection, LSupported);
    if LHr = S_OK then
    begin
      if boolean(LSupported) then
        LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkSupportsInputFormatDetection', TJsonTrue.Create))
      else
        LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkSupportsInputFormatDetection', TJsonFalse.Create));
    end else
      raise Exception.CreateFmt('Could not query the input mode detection attribute- result = %08x', [LHr]);

    // BMDDeckLinkSupportsFullDuplex
    LHr := LDeckLinkAttributes.GetFlag(BMDDeckLinkSupportsFullDuplex, LSupported);
    if LHr = S_OK then
    begin
      if boolean(LSupported) then
        LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkSupportsFullDuplex', TJsonTrue.Create))
      else
        LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkSupportsFullDuplex', TJsonFalse.Create));
    end else
      raise Exception.CreateFmt('Could not query the full duplex operation supported attribute- result = %08x', [LHr]);

    // BMDDeckLinkSupportsInternalKeying
    LHr := LDeckLinkAttributes.GetFlag(BMDDeckLinkSupportsInternalKeying, LSupported);
    if LHr = S_OK then
    begin
      if boolean(LSupported) then
        LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkSupportsInternalKeying', TJsonTrue.Create))
      else
        LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkSupportsInternalKeying', TJsonFalse.Create));
    end else
      raise Exception.CreateFmt('Could not query the internal keying attribute- result = %08x', [LHr]);

    // BMDDeckLinkSupportsExternalKeying
    LHr := LDeckLinkAttributes.GetFlag(BMDDeckLinkSupportsExternalKeying, LSupported);
    if LHr = S_OK then
    begin
      if boolean(LSupported) then
        LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkSupportsExternalKeying', TJsonTrue.Create))
      else
        LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkSupportsExternalKeying', TJsonFalse.Create));
    end else
      raise Exception.CreateFmt('Could not query the external keying attribute- result = %08x', [LHr]);

    // BMDDeckLinkSupportsHDKeying
    LHr := LDeckLinkAttributes.GetFlag(BMDDeckLinkSupportsHDKeying, LSupported);
    if LHr = S_OK then
    begin
      if boolean(LSupported) then
        LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkSupportsHDKeying', TJsonTrue.Create))
      else
        LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkSupportsHDKeying', TJsonFalse.Create));
    end else
      raise Exception.CreateFmt('Could not query the HD-mode keying attribute- result = %08x', [LHr]);

    // BMDDeckLinkHasReferenceInput
    LHr := LDeckLinkAttributes.GetFlag(BMDDeckLinkHasReferenceInput, LSupported);
    if LHr = S_OK then
    begin
      if boolean(LSupported) then
        LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkHasReferenceInput', TJsonTrue.Create))
      else
        LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkHasReferenceInput', TJsonFalse.Create));
    end else
      raise Exception.CreateFmt('Could not query the reference input supported attribute- result = %08x', [LHr]);

    // BMDDeckLinkHasBypass
    LHr := LDeckLinkAttributes.GetFlag(BMDDeckLinkHasBypass, LSupported);
    if LHr = S_OK then
    begin
      if boolean(LSupported) then
        LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkHasBypass', TJsonTrue.Create))
      else
        LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkHasBypass', TJsonFalse.Create));
    end else
      raise Exception.CreateFmt('Could not query the bypass supported attribute- result = %08x', [LHr]);


    LVideoOutputJson := TJsonArray.Create;
    try
      LHr := LDeckLinkAttributes.GetInt(BMDDeckLinkVideoOutputConnections, LValue);
      if (LHr = S_OK) then
      begin
        if (LValue and bmdVideoConnectionSDI)>0 then
        begin
          LVideoOutputJson.Add('bmdVideoConnectionSDI');
        end;
        if (LValue and bmdVideoConnectionHDMI)>0 then
        begin
          LVideoOutputJson.Add('bmdVideoConnectionHDMI');
        end;
        if (LValue and bmdVideoConnectionOpticalSDI)>0 then
        begin
          LVideoOutputJson.Add('bmdVideoConnectionOpticalSDI');
        end;
        if (LValue and bmdVideoConnectionComponent)>0 then
        begin
          LVideoOutputJson.Add('bmdVideoConnectionComponent');
        end;
        if (LValue and bmdVideoConnectionComposite)>0 then
        begin
          LVideoOutputJson.Add('bmdVideoConnectionComposite');
        end;
        if (LValue and bmdVideoConnectionSVideo)>0 then
        begin
          LVideoOutputJson.Add('bmdVideoConnectionSVideo');
        end;
      end	else
      begin
        if assigned(LDeckLinkAttributes) then		LDeckLinkAttributes:=nil;
        raise Exception.CreateFmt('Could not obtain the list of output ports - result = %08x', [LHr]);
      end;
    finally
      LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkVideoOutputConnections', LVideoOutputJson));
    end;
    LVideoInputJson := TJsonArray.Create;
    try
      LHr := LDeckLinkAttributes.GetInt(BMDDeckLinkVideoInputConnections, LValue);
      if (LHr = S_OK) then
      begin
        if (LValue and bmdVideoConnectionSDI)>0 then
        begin
          LVideoInputJson.Add('bmdVideoConnectionSDI');
        end;
        if (LValue and bmdVideoConnectionHDMI)>0 then
        begin
          LVideoInputJson.Add('bmdVideoConnectionSDI');
        end;
        if (LValue and bmdVideoConnectionOpticalSDI)>0 then
        begin
          LVideoInputJson.Add('bmdVideoConnectionOpticalSDI');
        end;
        if (LValue and bmdVideoConnectionComponent)>0 then
        begin
          LVideoInputJson.Add('bmdVideoConnectionComponent');
        end;
        if (LValue and bmdVideoConnectionComposite)>0 then
        begin
          LVideoInputJson.Add('bmdVideoConnectionComposite');
        end;
        if (LValue and bmdVideoConnectionSVideo)>0 then
        begin
          LVideoInputJson.Add('bmdVideoConnectionSVideo');
        end
      end	else
      begin
        if assigned(LDeckLinkAttributes) then		LDeckLinkAttributes:=nil;
        raise Exception.CreateFmt('Could not obtain the list of input ports - result = %08x', [LHr]);
      end;
    finally
      LJsonObject.AddPair(TJsonPair.Create('BMDDeckLinkVideoInputConnections', LVideoInputJson));
    end;
    result := LJsonObject.Clone as TJsonObject;
  finally
    FreeAndNil(LJsonObject);
  end;
end;


class function TDeckLink2Json.GetIDeckLinkOutput(var ADeckLink: IDeckLink): TJsonArray;
var
  i                     : integer;
  LDeckLinkOutput       : IDeckLinkOutput;
  LDisplayModeIterator  : IDeckLinkDisplayModeIterator;
  LDisplayMode          : IDeckLinkDisplayMode;
  LResultDisplayMode    : IDeckLinkDisplayMode;
  LHr                   : HRESULT;
  LModeName             : WideString;
  LFrameRateDuration,
  LFrameRateScale       : int64;
  LModeWidth,
  LModeHeight           : integer;
  LPixelFormatNames     : string;
  LDisplayModeStr       : string;
  LFrameRate            : extended;
  LDisplayModeSupport   : _BMDDisplayModeSupport;
  LModeIteratorJson     : TJsonArray;
  LDisplayModeJson      : TJsonObject;
  LPixelFormatJson      : TJsonArray;
begin
  LDeckLinkOutput := nil;
  LDisplayModeIterator := nil;
  LDisplayMode := nil;
  LResultDisplayMode := nil;
  LModeIteratorJson := TJsonArray.Create;
  try
    // Query the DeckLink for its configuration interface
    LHr := ADeckLink.QueryInterface(IID_IDeckLinkOutput, LDeckLinkOutput);
    if (LHr <> S_OK) then
    begin
      if assigned(LDisplayModeIterator) then LDisplayModeIterator:=nil;
      if assigned(LDeckLinkOutput) then LDeckLinkOutput:=nil;
      raise Exception.CreateFmt('Could not obtain the IDeckLinkOutput interface - result = %08x', [LHr]);
    end;

    // Obtain an IDeckLinkDisplayModeIterator to enumerate the display modes supported on output
    LHr := LDeckLinkOutput.GetDisplayModeIterator(LDisplayModeIterator);
    if (LHr <> S_OK) then
    begin
      if assigned(LDisplayModeIterator) then LDisplayModeIterator:=nil;
      if assigned(LDeckLinkOutput) then LDeckLinkOutput:=nil;
      raise Exception.CreateFmt('Could not obtain the video output display mode iterator - result = %08x', [LHr]);
    end;

    // List all supported output display modes
    while (LDisplayModeIterator.Next(LDisplayMode) = S_OK)  do
    begin
        LPixelFormatNames:='';
        LFrameRate:=0;
        LHr := LDisplayMode.GetName(LModeName);
        if (LHr = S_OK) then
        begin
          LDisplayModeJson := TJsonObject.Create;
          try
            TBMDConverts.BMDDisplayModeToString(LDisplayMode.GetDisplayMode, LDisplayModeStr);
            LModeWidth:=LDisplayMode.GetWidth;
            LModeHeight:=LDisplayMode.GetHeight;
            if Succeeded(LDisplayMode.GetFrameRate(LFrameRateDuration, LFrameRateScale)) then
              LFrameRate:=LFrameRateScale / LFrameRateDuration;

            LDisplayModeJson.AddPair(TJsonPair.Create('Name',TJsonString.Create(LModeName)));
            LDisplayModeJson.AddPair(TJsonPair.Create('Width',TJsonNumber.Create(LModeWidth)));
            LDisplayModeJson.AddPair(TJsonPair.Create('Height',TJsonNumber.Create(LModeHeight)));
            LDisplayModeJson.AddPair(TJsonPair.Create('FrameRate',TJsonNumber.Create(LFrameRate)));
            LDisplayModeJson.AddPair(TJsonPair.Create('BMDDisplayMode',TJsonString.Create(LDisplayModeStr)));
            LPixelFormatJson := TJsonArray.Create;
            try
              // Print the supported pixel formats for this display mode
              for i := low(_PixelFormatLinks) to High(_PixelFormatLinks) do
              begin
                if ((LDeckLinkOutput.DoesSupportVideoMode(LDisplayMode.GetDisplayMode, _PixelFormatLinks[i].BMD, bmdVideoOutputFlagDefault, LDisplayModeSupport, LResultDisplayMode) = S_OK) and (LDisplayModeSupport <> bmdDisplayModeNotSupported)) then
                begin
                  LPixelFormatNames := _PixelFormatLinks[i].AsString;
                  LPixelFormatJson.Add(LPixelFormatNames);
                end;
              end;
            finally
              LDisplayModeJson.AddPair('PixelFormats', LPixelFormatJson);
            end;
          finally
            LModeIteratorJson.Add(LDisplayModeJson);
          end;
        end;
        // Release the IDeckLinkDisplayMode object to prevent a leak
        if assigned(LDisplayMode) then LDisplayMode:=nil;
    end;
    result := LModeIteratorJson.Clone as TJsonArray;
  finally
    FreeAndNil(LModeIteratorJson);
  end;
end;


class function TDeckLink2Json.GetIDeckLinkInput(var ADeckLink: IDeckLink): TJsonArray;
var
  i                     : integer;
  LDeckLinkInput        : IDeckLinkInput;
  LDisplayModeIterator  : IDeckLinkDisplayModeIterator;
	LDisplayMode          : IDeckLinkDisplayMode;
  LResultDisplayMode    : IDeckLinkDisplayMode;
	LHr                   : HRESULT;
  LModeName             : WideString;
  LFrameRateDuration,
  LFrameRateScale       : int64;
  LModeWidth,
  LModeHeight           : integer;
  LPixelFormatNames     : string;
  LDisplayModeStr       : string;
  LFrameRate            : extended;
  LDisplayModeSupport   : _BMDDisplayModeSupport;
  LModeIteratorJson     : TJsonArray;
  LDisplayModeJson      : TJsonObject;
  LPixelFormatJson      : TJsonArray;
begin
  LDeckLinkInput       := nil;
  LDisplayModeIterator := nil;
	LDisplayMode         := nil;
  LResultDisplayMode   := nil;
  LModeIteratorJson := TJsonArray.Create;
  try
    // Query the DeckLink for its configuration interface
    LHr := ADeckLink.QueryInterface(IID_IDeckLinkInput, LDeckLinkInput);
    if (LHr <> S_OK) then
    begin
      if assigned(LDisplayModeIterator) then LDisplayModeIterator:=nil;
      if assigned(LDeckLinkInput) then LDeckLinkInput:=nil;
      raise Exception.CreateFmt('Could not obtain the IDeckLinkInput interface - result = %08x', [LHr]);
    end;

    // Obtain an IDeckLinkDisplayModeIterator to enumerate the display modes supported on output
    LHr := LDeckLinkInput.GetDisplayModeIterator(LDisplayModeIterator);
    if (LHr <> S_OK) then
    begin
      if assigned(LDisplayModeIterator) then LDisplayModeIterator:=nil;
      if assigned(LDeckLinkInput) then LDeckLinkInput:=nil;
      raise Exception.CreateFmt('Could not obtain the video input display mode iterator - result = %08x', [LHr]);
    end;

    // List all supported output display modes
    while (LDisplayModeIterator.Next(LDisplayMode) = S_OK)  do
    begin
        LPixelFormatNames:='';
        LFrameRate:=0;
        LHr := LDisplayMode.GetName(LModeName);
        if (LHr = S_OK) then
        begin
          LDisplayModeJson := TJsonObject.Create;
          try
            TBMDConverts.BMDDisplayModeToString(LDisplayMode.GetDisplayMode, LDisplayModeStr);
            LModeWidth:=LDisplayMode.GetWidth;
            LModeHeight:=LDisplayMode.GetHeight;
            if Succeeded(LDisplayMode.GetFrameRate(LFrameRateDuration, LFrameRateScale)) then
              LFrameRate:=LFrameRateScale / LFrameRateDuration;

            LDisplayModeJson.AddPair(TJsonPair.Create('Name',TJsonString.Create(LModeName)));
            LDisplayModeJson.AddPair(TJsonPair.Create('Width',TJsonNumber.Create(LModeWidth)));
            LDisplayModeJson.AddPair(TJsonPair.Create('Height',TJsonNumber.Create(LModeHeight)));
            LDisplayModeJson.AddPair(TJsonPair.Create('FrameRate',TJsonNumber.Create(LFrameRate)));
            LDisplayModeJson.AddPair(TJsonPair.Create('BMDDisplayMode',TJsonString.Create(LDisplayModeStr)));

            LPixelFormatJson := TJsonArray.Create;
            try
              // Print the supported pixel formats for this display mode
              for i := low(_PixelFormatLinks) to High(_PixelFormatLinks) do
              begin
                if ((LDeckLinkInput.DoesSupportVideoMode(LDisplayMode.GetDisplayMode, _PixelFormatLinks[i].BMD, bmdVideoInputFlagDefault, LDisplayModeSupport, LResultDisplayMode) = S_OK) and (LDisplayModeSupport <> bmdDisplayModeNotSupported)) then
                begin
                  LPixelFormatNames := _PixelFormatLinks[i].AsString;
                  LPixelFormatJson.Add(LPixelFormatNames);
                end;
              end;
            finally
              LDisplayModeJson.AddPair('PixelFormats', LPixelFormatJson);
            end;
          finally
            LModeIteratorJson.Add(LDisplayModeJson);
          end;
        end;
        // Release the IDeckLinkDisplayMode object to prevent a leak
        if assigned(LDisplayMode) then LDisplayMode:=nil;
    end;
    result := LModeIteratorJson.Clone as TJsonArray;
  finally
    FreeAndNil(LModeIteratorJson);
  end;
end;


class function TDeckLink2Json.IDeckLink2Json(ADeckLink: IDeckLink): TJsonObject;
var
  LJsonObject             : TJsonObject;
begin
  CoInitialize(nil);
  try
    LJsonObject := TJsonObject.Create;
    try
      LJsonObject.AddPair(TJsonPair.Create('IDeckLink', TDeckLink2Json.GetIDeckLink(ADeckLink)));
      LJsonObject.AddPair(TJsonPair.Create('IDeckLinkAttributes', TDeckLink2Json.GetIDeckLinkAttributes(ADeckLink)));
      LJsonObject.AddPair(TJsonPair.Create('IDeckLinkOutput', TDeckLink2Json.GetIDeckLinkOutput(ADeckLink)));
      LJsonObject.AddPair(TJsonPair.Create('IDeckLinkInput', TDeckLink2Json.GetIDeckLinkInput(ADeckLink)));
      result := LJsonObject.Clone as TJsonObject;
    finally
      FreeAndNil(LJsonObject);
    end;
  finally
	  CoUninitialize;
  end;
end;

end.
