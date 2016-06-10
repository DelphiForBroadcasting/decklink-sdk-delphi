unit Unit1;

interface

  {$Define useFFMPEG}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, activex,
  DeckLinkAPI_TLB_10_5,
  FH.DeckLink.InputFrame,
  FH.DeckLink.Discovery,
  FH.DeckLink,
  FH.DeckLink.Utils,
  FH.DeckLink.Device,
  FH.DeckLink.ScreenPreview,
  FH.DeckLink.Helpers,
  {FH.DeckLink.Input,}
  FH.DeckLink.DisplayMode,
  avutil,
  avcodec,
  avformat,
  avfilter,
  swresample,
  postprocess,
  avdevice,
  swscale,
  {$IfDef useFFMPEG}

  {$Else}
    opt,
    fifo,
    file_,
    avdevice,
    postprocess,
  {$EndIf}

  Vcl.ExtCtrls, Vcl.Menus, Vcl.ComCtrls;

  {$IfDef useFFMPEG}
Const
 PIX_FMT_UYVY422 =   AV_PIX_FMT_UYVY422;
  {$EndIf}


Type


  TForm1 = class(TForm)
    Image1: TImage;
    Memo1: TMemo;
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    N1: TMenuItem;
    GroupBox4: TGroupBox;
    Label14: TLabel;
    sReferenceSignal: TShape;
    Label15: TLabel;
    sVideoInputSignal: TShape;
    GroupBox1: TGroupBox;
    Label11: TLabel;
    Label13: TLabel;
    m_applyDetectedInputModeCheckbox: TCheckBox;
    m_InputCardCombo: TComboBox;
    m_StartButton: TButton;
    Button1: TButton;
    m_invalidInputLabel: TLabel;
    ui_DeviceInfo: TLabel;
    GroupBox3: TGroupBox;
    m_previewBox: TPanel;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label12: TLabel;
    Label1: TLabel;
    m_VideoConnectionsCombo: TComboBox;
    m_VideoFormatCombo: TComboBox;
    m_PixelFormatCombo: TComboBox;
    GroupBox5: TGroupBox;
    Label3: TLabel;
    m_AudioConnectionsCombo: TComboBox;
    Label4: TLabel;
    m_AudioSampleRateCombo: TComboBox;
    Label5: TLabel;
    m_AudioSampleTypeCombo: TComboBox;
    Label6: TLabel;
    m_AudioChannelsCombo: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure m_StartButtonClick(Sender: TObject);
    procedure m_VideoFormatComboChange(Sender: TObject);
    procedure m_InputCardComboChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    Procedure OnFrameArrived(const videoFrame: TDeckLinkVideoInputFrame;
                                    const audioPacket: TDeckLinkAudioInputPacket;  const frameIndex : Int64);
    procedure OnAddFrame(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DoDebug(const Msg: String);
    procedure VideoInputSignal(ALocked: Boolean);
    procedure ReferenceSignal(ALocked: Boolean);
    procedure m_PixelFormatComboChange(Sender: TObject);
    procedure m_VideoConnectionsComboChange(Sender: TObject);
    procedure m_AudioConnectionsComboChange(Sender: TObject);
    procedure m_AudioSampleRateComboChange(Sender: TObject);
    procedure m_AudioSampleTypeComboChange(Sender: TObject);
    procedure m_AudioChannelsComboChange(Sender: TObject);
  private
    function GetDecklinkBasicInformation: string;
  public
      m_bRunning          : boolean;
      FDeckLinkHandler    : TDeckLinkHandler;
      FDeckLinkPreview    : TDeckLinkScreenPreviewCallback;
      FBMDDiscovery       : TBMDDiscovery;
  end;





var
  Form1                   : TForm1;

  sws_ctx_UYVY422toRGB    : PSwsContext;
  src_picture_UYVY422,
  RGB_picture             : TAVPicture;

implementation

{$R *.dfm}

procedure TForm1.DoDebug(const Msg: String);
begin
  memo1.Lines.Insert(0, formatdatetime('yyyy-MM-dd hh:mm:ss.zzz',now)+' - '+Msg);
end;

procedure TForm1.OnAddFrame(Sender: TObject);
begin
  ;
end;



Procedure FrameToBitmap(const frameRaw: Pointer; out frame: TBitmap);

function LimitByte(Value:nativeint):byte;
begin
  if Value<0 then Value:=0;
  if Value>255 then Value:=255;
  Result:=Value;
end;

function ByteTOARGB(const A, R, G, B: Byte): cardinal;
begin
  result:=(a or (r shl 8) or (g shl 16) or (b shl 24));
end;

type
  PPixelBMP32 = ^TPixelBMP32;
  TPixelBMP32 = packed record
    B: byte;
    G: byte;
    R: byte;
    A: byte;
end;

type
  PPixelBMP24 = ^TPixelBMP32;
  TPixelBMP24 = packed record
    B: byte;
    G: byte;
    R: byte;
end;

type
  PYUV=^TYUV;
  TYUV=packed record
    V     :byte;
    Y1    :byte;
    U     :byte;
    Y2    :byte;
  end;

var
  DP                  : PYUV;
  DP1                 : Pointer;
  test : Pointer;
  x,y,i               : integer;
  R1,G1,B1,R2,G2,B2   : byte;
  m_Width, m_Height   : integer;
  bmp                 : TBitmap;

FSS:TFileStream;
begin
  m_Width:=1920;
  m_Height:=1080;
  DP:=frameRaw;



  GetMem(DP1, m_Width*m_Height*4);
  for y := 0 to m_Height-1 do
    for x := 0 to (m_Width div 2) -1 do
    begin

      R1:=DP^.Y1+((DP^.U shl 1)-256);
      B1:=DP^.Y1+((DP^.V shl 1)-256);
      G1:=Trunc((Word(DP^.Y1)-0.299*Word(R1)-0.114*Word(B1))/0.587);
      R2:=DP^.Y2+((Word(DP^.U) shl 1)-256);
      B2:=DP^.Y2+((Word(DP^.V) shl 1)-256);
      G2:=Trunc((Word(DP^.Y2)-0.299*Word(R2)-0.114*Word(B2))/0.587);


      PPixelBMP32(DP1)^.A:=255;
      PPixelBMP32(DP1)^.R:=R1;
      PPixelBMP32(DP1)^.G:=G1;
      PPixelBMP32(DP1)^.B:=B1;
      Inc(PPixelBMP32(DP1),1);

      PPixelBMP32(DP1)^.A:=255;
      PPixelBMP32(DP1)^.R:=R2;
      PPixelBMP32(DP1)^.G:=G2;
      PPixelBMP32(DP1)^.B:=B2;
      Inc(PPixelBMP32(DP1),1);

      Inc(DP);
    end;




  test:=DP1;

FSS:=TFileStream.Create('data,raw', fmCreate);
try

  FSS.Write(test^,m_Width*m_Height*4);
finally
FSS.Free ;
end;


  bmp := TBitmap.Create;
  try
    bmp.PixelFormat := pf32bit;
    bmp.Width := m_Width;
    bmp.Height := m_Height;

    for i := 0 to bmp.Height - 1 do
    begin
      CopyMemory ( bmp.ScanLine [i], Pointer(test), bmp.Width * 4 );
      //CopyMemory ( bmp.ScanLine [i], pointer (integer (test) + bmp.Width * 4 * i), bmp.Width * 4 );
      inc(pInteger(test), bmp.Width);
    end;

    bmp.SaveToFile (format('example_%d.bmp', [GetTickCount]));
  finally
    bmp.free;
  end;


end;


Procedure TForm1.OnFrameArrived(const videoFrame: TDeckLinkVideoInputFrame;
                                    const audioPacket: TDeckLinkAudioInputPacket; const frameIndex : Int64);
var

  m_Width, m_Height, m_Stride       : integer;

  videoBytes, audioBytes            : pointer;
  m_BytesPerPixel                   : integer;
  bmp                               : TBitmap;

  bBitmap                           : TBitmap;

  temp_i_000                        : integer;

  i                                 : integer;

  frameVideoTime, frameAudioTime    : Int64;
  frameDuration                     : Int64;
  hours, minutes, seconds, frames   : integer;
begin
  exit;

  if assigned(videoFrame) then
  begin

    // videoFrame.GetHardwareReferenceTimestamp(DeckLinkInput.timeScale, frameVideoTime, frameDuration);
    if (videoFrame.GetFlags() and bmdFrameHasNoInputSource)>0 then
    begin
      ;
    end;

    if (videoFrame.GetFlags() and bmdFrameHasVirtual)>0 then
    begin
      ;
    end;

    m_Width := videoFrame.GetWidth;
    m_Height := videoFrame.GetHeight;
    m_Stride := videoFrame.GetRowBytes;

    case videoFrame.GetPixelFormat of
      bmdFormat8BitYUV  : m_BytesPerPixel:=2;
      bmdFormat10BitYUV : m_BytesPerPixel:=2;
      bmdFormat8BitARGB : m_BytesPerPixel:=4;
      bmdFormat8BitBGRA : m_BytesPerPixel:=4;
      bmdFormat10BitRGB : m_BytesPerPixel:=4;
    end;

    videoFrame.GetBytes(videoBytes);

   { videoFrame.GetStreamTime(frameVideoTime, frameDuration, 600);
    hours:=frameVideoTime div (600 * 60 * 60);
    minutes:=(frameVideoTime div (600 * 60)) mod 60;
    seconds:=(frameVideoTime div 600) mod 60;
    frames:=(frameVideoTime div 6) mod 100;
    StatusBar1.Panels[0].Text := Format('%02.2d:%02.2d:%02.2d:%02.2d',[hours, minutes, seconds, frames]);  }

  end else
  begin
    DoDebug('Drop frame');
  end;

  if assigned(audioPacket) then
  begin
    //audioPacket.GetPacketTime(frameAudioTime, 1000);

   //audioPacket.GetSampleFrameCount * 8 * (16 div 8);
    audioPacket.GetBytes(audioBytes);
  end;

  if ((m_Width = 1920) and (m_Height = 1080)) then
  begin
    try
        if assigned(sws_ctx_UYVY422toRGB) then
        begin
          src_picture_UYVY422.data[0]:= videoBytes;
          sws_scale(sws_ctx_UYVY422toRGB ,@src_picture_UYVY422.data, @src_picture_UYVY422.linesize,  0, 1080, @RGB_picture.data, @RGB_picture.linesize);
            bBitmap := TBitmap.Create;
            try
              bBitmap.PixelFormat := pf32bit;
              bBitmap.Width := 1920;
              bBitmap.Height := 1080;
              for i := 0 to bBitmap.Height - 1 do
                CopyMemory (bBitmap.ScanLine[i], pointer (NativeInt (RGB_picture.data [0]) + bBitmap.Width * 4 * i), bBitmap.Width * 4);


             Image1.Canvas.Lock;
             Image1.Picture.Bitmap.Assign(bBitmap);
             Image1.Canvas.Unlock;

            finally
              bBitmap.Free;
            end;
        end;
    except
     on E: Exception do
      begin
        exit;
      end;
    end;
  end;

end;










{function CVideoDelegate.VideoInputFrameArrived(const videoFrame: IDeckLinkVideoInputFrame;
                                    const audioPacket: IDeckLinkAudioInputPacket): HResult;


type
  PPixelBMP32 = ^TPixelBMP32;
  TPixelBMP32 = packed record
    B: byte;
    G: byte;
    R: byte;
    A: byte;
end;

type
  PPixelBMP24 = ^TPixelBMP32;
  TPixelBMP24 = packed record
    B: byte;
    G: byte;
    R: byte;
end;

type
  PYUV=^TYUV;
  TYUV=packed record
    V:byte;
    Y1:byte;
    U:byte;
    Y2:byte;
  end;

var
  frameTime, frameDuration        : Int64;
  hours, minutes, seconds, frames : integer;
  captureString                   : string;
  pbData                          : Pointer;
  m_Width, m_Height               : integer;
  x,y,i                           : integer;
  SDLNAme                         : string;
  DP                              : PYUV;
  DP1                             : PPixelBMP32;
  R1,G1,B1,R2,G2,B2               : byte;
  m_BytesPerPixel                 : integer;
  OperBegin, OperEnd: TTimeStamp;

begin
m_BytesPerPixel:=0;
if form1.m_bRunning then
begin
  videoFrame.GetStreamTime(frameTime, frameDuration, 600);
  hours:=frametime div (600 * 60 * 60);
  minutes:=(frametime div (600 * 60)) mod 60;
  seconds:=(frametime div 600) mod 60;
  frames:=(frametime div 6) mod 100;
  sdlname :=format('%d-%d-%d.bmp',[minutes,seconds,frames]);

  m_Width := videoFrame.GetWidth;
  m_Height := videoFrame.GetHeight;
  videoFrame.GetBytes(pbData);
  case videoFrame.GetPixelFormat of
    bmdFormat8BitYUV  : m_BytesPerPixel:=2;
    bmdFormat10BitYUV : m_BytesPerPixel:=2;
    bmdFormat8BitARGB : m_BytesPerPixel:=4;
    bmdFormat8BitBGRA : m_BytesPerPixel:=4;
    bmdFormat10BitRGB : m_BytesPerPixel:=4;
  end;


  SDL_LockSurface(m_pController.screen);
  OperBegin := DateTimeToTimeStamp(Now);

  DP:=pbData;
  DP1:=m_pController.screen.pixels;
  for y := 0 to m_Height-1 do
    for x := 0 to (m_Width div 2) -1 do
    begin

      R1:=LimitByte(DP^.Y1+((DP^.U shl 1)-256));
      B1:=LimitByte(DP^.Y1+((DP^.V shl 1)-256));
      G1:=LimitByte(Trunc((Word(DP^.Y1)-0.299*Word(R1)-0.114*Word(B1))/0.587));
      R2:=LimitByte(DP^.Y2+((Word(DP^.U) shl 1)-256));
      B2:=LimitByte(DP^.Y2+((Word(DP^.V) shl 1)-256));
      G2:=LimitByte(Trunc((Word(DP^.Y2)-0.299*Word(R2)-0.114*Word(B2))/0.587));


      DP1^.A:=255;
      DP1^.R:=R1;
      DP1^.G:=G1;
      DP1^.B:=B1;
      Inc(DP1);

      DP1^.A:=255;
      DP1^.R:=R2;
      DP1^.G:=G2;
      DP1^.B:=B2;
      Inc(DP1);

      Inc(DP);
    end;

   OperEnd := DateTimeToTimeStamp(Now);
   //m_pController.ListBox1.Items.Insert(0,inttostr(OperEnd.Time - OperBegin.Time));

  SDL_UnlockSurface(m_pController.screen);

  SDL_UpdateRect (m_pController.screen, 0, 0, 0, 0) ;

  captureString:=Format('%02.2d:%02.2d:%02.2d:%02.2d',[hours, minutes, seconds, frames]);
  m_pController.m_CaptureTime.Caption:=captureString;
end;

  RESULT:=S_OK;
end;
       }

procedure TForm1.Button1Click(Sender: TObject);
begin
  FDeckLinkHandler.Input.StopCapture;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i : integer;
begin

end;

procedure TForm1.FormCreate(Sender: TObject);
var
    i             : integer;
    cardname      : Widestring;
    find_deckLink : boolean;
    temp_i_000 : integer;
begin

	FDeckLinkPreview := TDeckLinkScreenPreviewCallback.Create;
	if (FDeckLinkPreview.init(m_previewBox) = false) then
	begin
    MessageDlg('This application was unable to initialise the preview window', mtError , [mbOk], 0);
  end;


  FBMDDiscovery := TBMDDiscovery.Create(true);
  FBMDDiscovery.Enable;
  sleep(1000);

  for I := 0 to FBMDDiscovery.Devices.Count-1 do
  begin
    find_deckLink:=true;
    FBMDDiscovery.Devices.Items[i].GetDisplayName(cardname);
    m_InputCardCombo.AddItem(cardname, TDeckLinkDevice.create(FBMDDiscovery.Devices.Items[i]));
  end;



  find_deckLink:=true;


  if not find_deckLink then
  begin
    m_InputCardCombo.Items.Add('No DeckLink Cards Found');
    m_StartButton.Enabled:=false;
  end;

  m_InputCardCombo.ItemIndex:=0;
  m_bRunning:=false;


  sws_ctx_UYVY422toRGB := sws_getContext(1920, 1080, PIX_FMT_UYVY422,
                                            1920, 1080, PIX_FMT_RGB32,
                                             SWS_BICUBIC, nil, nil, nil);

  if not Assigned(sws_ctx_UYVY422toRGB) then
  begin
          exit;
  end;


  //new(RGB_picture);
  temp_i_000 := avpicture_alloc(@RGB_picture, PIX_FMT_RGB32, 1920, 1080);
  if (temp_i_000 < 0) then
  begin
          exit
  end;

  //new(src_picture_UYVY422);
  (* Allocate the encoded raw picture. *)
  temp_i_000 := avpicture_alloc(@src_picture_UYVY422, PIX_FMT_UYVY422, 1920, 1080);
  if (temp_i_000 < 0) then
  begin
          exit
  end;

end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  i : integer;
begin

  for I := 0 to m_VideoFormatCombo.Items.Count - 1  do
    TDeckLinkDisplayMode(m_videoFormatCombo.Items.Objects[i]).Destroy;
  m_VideoFormatCombo.Clear;

  if assigned(FDeckLinkHandler) then
    FreeAndNil(FDeckLinkHandler);

  for I := 0 to m_InputCardCombo.Items.Count-1 do
    TDeckLinkDevice(m_InputCardCombo.Items.Objects[i]).Destroy;

  FBMDDiscovery.Destroy;

  FDeckLinkPreview.Destroy;

  sws_freeContext(sws_ctx_UYVY422toRGB);
  avpicture_free(@RGB_picture);
end;

function TForm1.GetDecklinkBasicInformation: string;
var
  LValueStr : string;
  LValueInt : integer;
begin
  result := '';

  try
    LValueStr := FDeckLinkHandler.GetModelName;
    result :=  result + Format('Model name:           %-s'+#13#10, [LValueStr]);
  except

  end;

  try
    LValueStr := FDeckLinkHandler.GetDisplayName;
    result :=  result + Format('Display name:         %-s'+#13#10, [LValueStr]);
  except

  end;

  try
    LValueInt := FDeckLinkHandler.GetTopologicalID;
    result :=  result + Format('Topological ID:       %-d'+#13#10, [LValueInt]);
  except

  end;

  try
    LValueInt := FDeckLinkHandler.GetPersistentID;
    result :=  result + Format('Persistent ID:        %-d'+#13#10, [LValueInt]);
  except

  end;

  try
    LValueInt := FDeckLinkHandler.GetSubDeviceIndex;
    result :=  result + Format('Sub Device Index:     %-d'+#13#10, [LValueInt]);
  except

  end;

end;


procedure TForm1.m_AudioChannelsComboChange(Sender: TObject);
var
  LAudioChannels : integer;
begin
  LAudioChannels := integer(m_AudioChannelsCombo.Items.Objects[m_AudioChannelsCombo.ItemIndex]);
  FDeckLinkHandler.Input.ChannelCount := LAudioChannels;

end;

procedure TForm1.m_AudioConnectionsComboChange(Sender: TObject);
var
  LCurrentAudioConnection : _BMDAudioConnection;
  i                       : integer;
  LDiplayName             : string;

  LAudioSampleRates: TArray<_BMDAudioSampleRate>;
  LAudioSampleTypes: TArray<_BMDAudioSampleType>;
  LAudioChannels: TArray<integer>;

begin
  (* SET AUDIO CONNECTION *)
  LCurrentAudioConnection := _BMDAudioConnection(m_AudioConnectionsCombo.Items.Objects[m_AudioConnectionsCombo.ItemIndex]);
  FDeckLinkHandler.Input.AudioConnection := LCurrentAudioConnection;

  (* LIST SUPPORT SAMPLE RATE *)
  LAudioSampleRates := FDeckLinkHandler.Input.SampleRates;
  for i := 0 to Length(LAudioSampleRates) - 1 do
  begin
    LDiplayName := '';
    LDiplayName := TBMDConverts.BMDAudioSampleRate(LAudioSampleRates[i]).Name;
    m_AudioSampleRateCombo.AddItem(LDiplayName, TObject(LAudioSampleRates[i]));
  end;

  (* LIST SUPPORT SAMPLE TYPE *)
  LAudioSampleTypes := FDeckLinkHandler.Input.SampleTypes;
  for i := 0 to Length(LAudioSampleTypes) - 1 do
  begin
    LDiplayName := '';
    LDiplayName := TBMDConverts.BMDAudioSampleType(LAudioSampleTypes[i]).Name;
    m_AudioSampleTypeCombo.AddItem(LDiplayName, TObject(LAudioSampleTypes[i]));
  end;

  (* LIST SUPPORT AUDIO CHANNELS *)
  LAudioChannels := FDeckLinkHandler.Input.ChannelCounts;
  for i := 0 to Length(LAudioChannels) - 1 do
  begin
    LDiplayName := '';
    LDiplayName := inttostr(LAudioChannels[i]);
    m_AudioChannelsCombo.AddItem(LDiplayName, TObject(LAudioChannels[i]));
  end;

  (* SELECT CURRENT SAMPLE RATE *)
  m_AudioSampleRateCombo.ItemIndex := m_AudioSampleRateCombo.Items.IndexOfObject(TObject(FDeckLinkHandler.Input.SampleRate));

  (* SELECT CURRENT SAMPLE TYPE *)
  m_AudioSampleTypeCombo.ItemIndex := m_AudioSampleTypeCombo.Items.IndexOfObject(TObject(FDeckLinkHandler.Input.SampleType));

  (* SELECT CURRENT AUDIO CHANNEL *)
  m_AudioChannelsCombo.ItemIndex := m_AudioChannelsCombo.Items.IndexOfObject(TObject(FDeckLinkHandler.Input.ChannelCount));
end;

procedure TForm1.m_AudioSampleRateComboChange(Sender: TObject);
var
  LAudioSampleRate : _BMDAudioSampleRate;
begin
  LAudioSampleRate := _BMDAudioSampleRate(m_AudioSampleRateCombo.Items.Objects[m_AudioSampleRateCombo.ItemIndex]);
  FDeckLinkHandler.Input.SampleRate := LAudioSampleRate;
end;

procedure TForm1.m_AudioSampleTypeComboChange(Sender: TObject);
var
  LAudioSampleType : _BMDAudioSampleType;
begin
  LAudioSampleType := _BMDAudioSampleType(m_AudioSampleTypeCombo.Items.Objects[m_AudioSampleTypeCombo.ItemIndex]);
  FDeckLinkHandler.Input.SampleType := LAudioSampleType;
end;

procedure TForm1.m_InputCardComboChange(Sender: TObject);
var
  i : integer;
  LValueBool : boolean;
  LDeckLinkDevice : IDecklink;

  LCurrentAudioConnection : _BMDAudioConnection;
  LAudioConnections : TArray<_BMDAudioConnection>;
  LAudioConnectionName : string;

  LCurrentVideoConnection : _BMDVideoConnection;
  LVideoConnections : TArray<_BMDVideoConnection>;
  LVideoConnectionName : string;
begin
  for I := 0 to m_VideoFormatCombo.Items.Count - 1  do
    TDeckLinkDisplayMode(m_videoFormatCombo.Items.Objects[i]).Destroy;
  m_VideoFormatCombo.Clear;

  LDeckLinkDevice := TDeckLinkDevice(m_InputCardCombo.Items.Objects[m_InputCardCombo.ItemIndex]);

  if assigned(FDeckLinkHandler) then
    FreeAndNil(FDeckLinkHandler);


  FDeckLinkHandler := TDeckLinkHandler.Create(LDeckLinkDevice);

  ui_DeviceInfo.Caption := GetDecklinkBasicInformation;

  if not FDeckLinkHandler.SupportsCapture then
  begin
    showmessage('Device not support capture');
    exit;
  end;

  if not FDeckLinkHandler.GetDeviceIsAvailable then
  begin
    showmessage('Device is busy');
    exit;
  end;


  FDeckLinkHandler.OnPreferencesChanged := procedure (param1: Largeuint; param2: Largeuint)
  begin
    DoDebug('OnPreferencesChanged');
  end;
  FDeckLinkHandler.OnDeviceRemoved := procedure (param1: Largeuint; param2: Largeuint)
  begin
    DoDebug('OnDeviceRemoved');
  end;
  FDeckLinkHandler.OnHardwareConfigurationChanged := procedure (param1: Largeuint; param2: Largeuint)
  begin
    DoDebug('OnHardwareConfigurationChanged');
  end;
  FDeckLinkHandler.OnStatusChanged := procedure (param1: Largeuint; param2: Largeuint)
  begin
    case param1 of
      bmdDeckLinkStatusVideoInputSignalLocked:
      begin
        DoDebug(Format('bmdDeckLinkStatusVideoInputSignalLocked: %s', [boolToStr(boolean(param2), true)]));
        VideoInputSignal(FDeckLinkHandler.Input.GetVideoSignalLocked);
      end;
      bmdDeckLinkStatusReferenceSignalLocked:
      begin
        DoDebug(Format('bmdDeckLinkStatusReferenceSignalLocked: %s', [boolToStr(boolean(param2), true)]));
        ReferenceSignal(FDeckLinkHandler.GetReferenceSignalLocked);
      end;
      bmdDeckLinkStatusDetectedVideoInputMode: DoDebug(Format('bmdDeckLinkStatusDetectedVideoInputMode: %d', [param2]));
      bmdDeckLinkStatusDetectedVideoInputFlags: DoDebug(Format('bmdDeckLinkStatusDetectedVideoInputFlags: %d', [param2]));
      bmdDeckLinkStatusCurrentVideoInputMode: DoDebug(Format('bmdDeckLinkStatusCurrentVideoInputMode: %d', [param2]));
      bmdDeckLinkStatusCurrentVideoInputPixelFormat: DoDebug(Format('bmdDeckLinkStatusCurrentVideoInputPixelFormat: %d', [param2]));
      bmdDeckLinkStatusCurrentVideoInputFlags: DoDebug(Format('bmdDeckLinkStatusCurrentVideoInputFlags: %d', [param2]));
      bmdDeckLinkStatusCurrentVideoOutputMode: DoDebug(Format('bmdDeckLinkStatusCurrentVideoOutputMode: %d', [param2]));
      bmdDeckLinkStatusCurrentVideoOutputFlags: DoDebug(Format('bmdDeckLinkStatusCurrentVideoOutputFlags: %d', [param2]));
      bmdDeckLinkStatusPCIExpressLinkWidth: DoDebug(Format('bmdDeckLinkStatusPCIExpressLinkWidth: %d', [param2]));
      bmdDeckLinkStatusPCIExpressLinkSpeed: DoDebug(Format('bmdDeckLinkStatusPCIExpressLinkSpeed: %d', [param2]));
      bmdDeckLinkStatusLastVideoOutputPixelFormat: DoDebug(Format('bmdDeckLinkStatusLastVideoOutputPixelFormat: %d', [param2]));
      bmdDeckLinkStatusReferenceSignalMode: DoDebug(Format('bmdDeckLinkStatusReferenceSignalMode: %d', [param2]));
      else DoDebug('OnStatusChanged');
    end;
  end;

  FDeckLinkHandler.Input.OnFrameArrived := OnFrameArrived;


  (* GET SUPPORTED VIDEO CONNECTIONS *)
  LVideoConnections := FDeckLinkHandler.Input.VideoConnections;
  for i := 0 to Length(LVideoConnections) - 1 do
  begin
    LVideoConnectionName := TBMDConverts.BMDVideoConnection(LVideoConnections[i]).Name;
    m_VideoConnectionsCombo.AddItem(LVideoConnectionName, TObject(LVideoConnections[i]));
  end;
  (* GET CURRENT VIDEO CONNECTION *)
  LCurrentVideoConnection := FDeckLinkHandler.Input.VideoConnection;
  m_VideoConnectionsCombo.ItemIndex := m_VideoConnectionsCombo.Items.IndexOfObject(TObject(LCurrentVideoConnection));



  (* GET SUPPORTED AUDIO CONNECTIONS *)
  LAudioConnections := FDeckLinkHandler.Input.AudioConnections;
  for i := 0 to Length(LAudioConnections) - 1 do
  begin
    LAudioConnectionName := TBMDConverts.BMDAudioConnection(LAudioConnections[i]).Name;
    m_AudioConnectionsCombo.AddItem(LAudioConnectionName, TObject(LAudioConnections[i]));
  end;
  (* GET CURRENT AUDIO CONNECTION *)
  LCurrentAudioConnection := FDeckLinkHandler.Input.AudioConnection;
  m_AudioConnectionsCombo.ItemIndex := m_AudioConnectionsCombo.Items.IndexOfObject(TObject(LCurrentAudioConnection));





  m_applyDetectedInputModeCheckbox.Checked := FDeckLinkHandler.Input.SupportsFormatDetection;

	ReferenceSignal(FDeckLinkHandler.GetReferenceSignalLocked);

end;

procedure TForm1.m_PixelFormatComboChange(Sender: TObject);
var
  LPixelFormat : _BMDPixelFormat;
begin
  LPixelFormat := _BMDPixelFormat(m_PixelFormatCombo.Items.Objects[m_PixelFormatCombo.ItemIndex]);
  FDeckLinkHandler.Input.PixelFormat := LPixelFormat;
end;

procedure TForm1.m_StartButtonClick(Sender: TObject);
begin
  FDeckLinkHandler.Input.DetectionInputMode := m_applyDetectedInputModeCheckbox.Checked;
  FDeckLinkHandler.Input.StartCapture(FDeckLinkPreview);
end;

procedure TForm1.m_VideoConnectionsComboChange(Sender: TObject);
var
  LCurrentVideoConnection : _BMDVideoConnection;
  LDisplayModeName        : wideString;
  LCurrentVideoMode       : _BMDDisplayMode;
  i                       : integer;
begin
  (* SET VIDEO CONNECTION *)
  LCurrentVideoConnection := _BMDVideoConnection(m_VideoConnectionsCombo.Items.Objects[m_VideoConnectionsCombo.ItemIndex]);
  FDeckLinkHandler.Input.VideoConnection := LCurrentVideoConnection;

  (* LIST SUPPORT DISPLAY MODES *)
  for i := 0 to Length(FDeckLinkHandler.Input.DisplayModes) - 1 do
  begin
    LDisplayModeName := TBMDConverts.BMDDisplayMode(FDeckLinkHandler.Input.DisplayModes[i].GetDisplayMode).Name;
    m_VideoFormatCombo.AddItem(LDisplayModeName, TDeckLinkDisplayMode.create(FDeckLinkHandler.Input.DisplayModes[i]));
  end;

  (* SELECT CURRENT DISPLAY MODE *)
  LCurrentVideoMode := FDeckLinkHandler.Input.GetCurrentVideoMode;
  LDisplayModeName:= TBMDConverts.BMDDisplayMode(LCurrentVideoMode).Name;
  m_videoFormatCombo.ItemIndex := m_videoFormatCombo.Items.IndexOf(LDisplayModeName);

end;

procedure TForm1.m_VideoFormatComboChange(Sender: TObject);
var
  LDisplayMode        : _BMDDisplayMode;
  LPixelFormat        : _BMDPixelFormat;
  LCurrentPixelFormat : _BMDPixelFormat;
  I                   : integer;
  LPixelFormatName    : string;
begin
  m_PixelFormatCombo.Items.Clear;

  (* SET Display Mode *)
  LDisplayMode := TDeckLinkDisplayMode(m_videoFormatCombo.Items.Objects[m_videoFormatCombo.ItemIndex]).GetDisplayMode;
  FDeckLinkHandler.Input.DisplayMode := LDisplayMode;

  (* LIST SUPPORT PIXEL FORMATS *)
  for i := 0 to length(FDeckLinkHandler.Input.PixelFormats) - 1 do
  begin
    LPixelFormat := FDeckLinkHandler.Input.PixelFormats[i];
    LPixelFormatName := TBMDConverts.BMDPixelFormat(LPixelFormat).Name;
    m_PixelFormatCombo.AddItem(LPixelFormatName, TObject(LPixelFormat));
  end;

  (* SELECT CURRENT PIXELFORMAT *)
  LCurrentPixelFormat := FDeckLinkHandler.Input.GetCurrentVideoPixelFormat;
  m_PixelFormatCombo.ItemIndex := m_videoFormatCombo.Items.IndexOfObject(TObject(LCurrentPixelFormat));


end;

procedure TForm1.ReferenceSignal(ALocked: Boolean);
begin
  if ALocked then
    sReferenceSignal.Brush.Color := clGreen
  else
    sReferenceSignal.Brush.Color := clRed;
end;

procedure TForm1.VideoInputSignal(ALocked: Boolean);
begin
  if ALocked then
    sVideoInputSignal.Brush.Color := clGreen
  else
    sVideoInputSignal.Brush.Color := clRed;
end;

end.
