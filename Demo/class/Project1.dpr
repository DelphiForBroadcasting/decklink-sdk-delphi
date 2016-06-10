program Project1;

uses
  Vcl.Forms,
  DeckLinkAPI_TLB_10_5 in '../../SDK 10.5/DeckLinkAPI_TLB_10_5.pas',
  FH.DeckLink.VirtualDevice in '../../FH.DeckLink.VirtualDevice.pas',
  FH.DeckLink.DisplayMode in '../../FH.DeckLink.DisplayMode.pas',
  FH.DeckLink.InputFrame in '../../FH.DeckLink.InputFrame.pas',
  FH.DeckLink.ScreenPreview in '../../FH.DeckLink.ScreenPreview.pas',
  FH.DeckLink.Discovery in '../../FH.DeckLink.Discovery.pas',
  FH.DeckLink.Device in '../../FH.DeckLink.Device.pas',
  FH.DeckLink.Input in '../../FH.DeckLink.Input.pas',
  FH.DeckLink.Utils in '../../FH.DeckLink.Utils.pas',
  FH.DeckLink.Notification in '../../FH.DeckLink.Notification.pas',
  FH.DeckLink.Helpers in '../../FH.DeckLink.Helpers.pas',
  FH.DeckLink in '../../FH.DeckLink.pas',


 {$Define useFFMPEG}

  {$IfDef useFFMPEG}
    avutil in '../../../../ffmpeg/trunk/ffmpeg-20140810-git-e18d9d9/libavutil/avutil.pas',
    avcodec in '../../../../ffmpeg/trunk/ffmpeg-20140810-git-e18d9d9/libavcodec/avcodec.pas',
    avformat in '../../../../ffmpeg/trunk/ffmpeg-20140810-git-e18d9d9/libavformat/avformat.pas',
    avfilter in '../../../../ffmpeg/trunk/ffmpeg-20140810-git-e18d9d9/libavfilter/avfilter.pas',
    swresample in '../../../../ffmpeg/trunk/ffmpeg-20140810-git-e18d9d9/libswresample/swresample.pas',
    postprocess in '../../../../ffmpeg/trunk/ffmpeg-20140810-git-e18d9d9/libpostproc/postprocess.pas',
    avdevice in '../../../../ffmpeg/trunk/ffmpeg-20140810-git-e18d9d9/libavdevice/avdevice.pas',
    swscale in '../../../../ffmpeg/trunk/ffmpeg-20140810-git-e18d9d9/libswscale/swscale.pas',
  {$Else}
    avcodec in '../../../../Projects/ffmbc/FFmbc-0.7-rc8/libavcodec/avcodec.pas',
    avformat in '../../../../Projects/ffmbc/FFmbc-0.7-rc8/libavformat/avformat.pas',
    avio in '../../../../Projects/ffmbc/FFmbc-0.7-rc8/libavformat/avio.pas',
    avutil in '../../../../Projects/ffmbc/FFmbc-0.7-rc8/libavutil/avutil.pas',
    opt in '../../../../Projects/ffmbc/FFmbc-0.7-rc8/libavutil/opt.pas',
    rational in '../../../../Projects/ffmbc/FFmbc-0.7-rc8/libavutil/rational.pas',
    imgutils in '../../../../Projects/ffmbc/FFmbc-0.7-rc8/libavutil/imgutils.pas',
    fifo in '../../../../Projects/ffmbc/FFmbc-0.7-rc8/libavutil/fifo.pas',
    file_ in '../../../../Projects/ffmbc/FFmbc-0.7-rc8/libavutil/file_.pas',
    ctypes in '../../../../Projects/ffmbc/FFmbc-0.7-rc8/ctypes.pas',
    swscale in '../../../../Projects/ffmbc/FFmbc-0.7-rc8/libswscale/swscale.pas',
    avdevice in '../../../../Projects/ffmbc/FFmbc-0.7-rc8/libavdevice/avdevice.pas',
    postprocess in '../../../../Projects/ffmbc/FFmbc-0.7-rc8/libpostproc/postprocess.pas',
  {$EndIf}
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
