program Project1;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Classes,
  Windows,
  Variants,
  activex,
  directshow9,
  math,
  DeckLinkAPI_TLB in '../../../DeckLinkAPI_TLB.pas';



Procedure FillBlack(theFrame : IDeckLinkVideoFrame);
var
  nextword        : Pointer;
  width           : integer;
  height          : integer;
  wordsRemaining  : int64;
  x,y,p           : integer;
  bytes           : PByte;
  bytesPerPixel   : integer;
begin
  theframe.GetBytes(nextword);
  case theFrame.GetPixelFormat of
    bmdFormat8BitYUV : bytesPerPixel:=2;
    bmdFormat10BitYUV : bytesPerPixel:=2;
    bmdFormat8BitARGB : bytesPerPixel:=4;
    bmdFormat8BitBGRA : bytesPerPixel:=4;
    bmdFormat10BitRGB : bytesPerPixel:=3;
  end;

  width:= theframe.GetWidth;
  height:= theframe.GetHeight;
  //FillChar(nextword,(width*height*bytesPerPixel),  #255);
  for y := 0 to height-1 do
    for x:=0 to width-1 do
      for p := 0 to bytesPerPixel-1 do
      begin
        pByte(nextword)^:=$FF;  inc(pByte(nextword),1);
      end;
end;


Procedure FillColourBars(theFrame : IDeckLinkVideoFrame);
const
 gSD75pcColourBars : array[0..7] of cardinal	= ($ffffffff, $ffffff00, $ff00ffff, $ff00ff00, $ffff00ff, $ffff0000, $ff0000ff, $ff000000);
 gHD75pcColourBars : array[0..7] of cardinal	= ($eb80eb80, $a888a82c, $912c9193, $8534853f, $3fcc3fc1, $33d4336d, $1c781cd4, $10801080);

function DarkerColor(const Color: cardinal; Percent: Integer): cardinal;
var
 A, R, G, B: Byte;
begin
  Result := Color;
  if Percent <= 0 then
    Exit;
  if Percent > 100 then
    Percent := 100;
  A := color;
  R := color shr 8;
  G := color shr 16;
  B := color shr 14;
  R := R - R * Percent div 100;
  G := G - G * Percent div 100;
  B := B - B * Percent div 100;
  result:=(a or (r shl 8) or (g shl 16) or (b shl 24));
end;

function LighterColor(const Color: cardinal; Percent: Integer): cardinal;
var
  A, R, G, B: Byte;
begin
  Result := Color;
  if Percent <= 0 then
    Exit;
  if Percent > 100 then
    Percent := 100;
  A := color;
  R := color shr 8;
  G := color shr 16;
  B := color shr 14;
  R := R + (255 - R) * Percent div 100;
  G := G + (255 - G) * Percent div 100;
  B := B + (255 - B) * Percent div 100;
    result:=(a or (r shl 8) or (g shl 16) or (b shl 24));
end;

var
  nextword        : Pointer;
  width           : integer;
  height          : integer;
  x,y             : integer;
begin
  theframe.GetBytes(nextword);
  width:= theframe.GetWidth;
  height:= theframe.GetHeight;
  for y := 0 to height-1 do
    for x:=0 to width-1 do
    begin
      pCardinal(nextword)^:=DarkerColor(gSD75pcColourBars[(x*8) div width],25);  inc(pCardinal(nextword),1);
    end;
end;



Procedure GDIDraw(theFrame : IDeckLinkVideoFrame);
var
  bmi : tagBITMAPINFO;
  dc : HDC;
  fillRect1, fillRect2, fillRect3, fillRect4 : TRECT;
  hbm : HBITMAP;
  pbData, pbDestData : Pointer;
  backBrush : HBRUSH;
begin
  //fillchar(bmi, sizeof(bmi),#0);
  bmi.bmiHeader.biSize:=sizeof(tagBITMAPINFOHEADER);
  bmi.bmiHeader.biWidth:=theFrame.GetWidth;
  bmi.bmiHeader.biHeight:=theFrame.GetHeight;
  bmi.bmiHeader.biPlanes:=1;
  bmi.bmiHeader.biBitCount:=32;
  bmi.bmiHeader.biCompression:=BI_RGB;
  bmi.bmiHeader.biSizeImage:=(bmi.bmiHeader.biWidth*bmi.bmiHeader.biHeight *4);
  fillRect1 := RECT(0,0,bmi.bmiHeader.biWidth,bmi.bmiHeader.biHeight);
  fillRect2 := RECT(50,50,100,100);
  fillRect3 := RECT(100,100,150,150);
  fillRect4 := RECT(150,150,200,200);
  DC := CreateCompatibleDC(0);
  hbm := CreateDIBSection( DC,bmi, DIB_RGB_COLORS,pbData,0,0);
  SelectObject(dc, hbm);
  backBrush := GetStockObject(DC_BRUSH);
  SetDCBrushColor(dc, RGB(50, 50, 110));
  FillRect(dc, fillRect1,backBrush);
  TextOut(dc, 30, 30, 'BlackMagic DeckLink SDK Delphi', 30);
  SetDCBrushColor(dc, RGB(222, 20, 0));
  FillRect(dc, fillRect2,backBrush);
  SetDCBrushColor(dc, RGB(0, 222, 0));
  FillRect(dc, fillRect3,backBrush);
  SetDCBrushColor(dc, RGB(0, 0, 222));
  FillRect(dc, fillRect4,backBrush);
  Ellipse(dc, 200, 200, 300, 300);
  theframe.GetBytes(pbDestData);
  CopyMemory(pbDestData, pbData, bmi.bmiHeader.biSizeImage);
  //memcopy();

  deleteObject(SelectObject(dc, hbm));
end;


Procedure OutputGraphic(DeckLink: IDeckLink);
var
  m_deckLinkOutput            : IDeckLinkOutput;
  m_videoFrameGDI             : IDeckLinkMutableVideoFrame;
  DisplayModeIterator         : IDeckLinkDisplayModeIterator;
  DeckLinkdisplayMode         : IDeckLinkdisplayMode;
  modeNameBSTR                : WideString;
  m_frameWidth, m_frameHeight : integer;
begin
  if Failed(DeckLink.QueryInterface(IID_IDeckLinkOutput, m_deckLinkOutput)) then
    writeln('Could not obtain the IDeckLinkOutput interface')
  else begin
    if Failed(m_deckLinkOutput.GetDisplayModeIterator(DisplayModeIterator)) then
      writeln('Could not obtain the display mode iterator')
    else begin
      if Succeeded(DisplayModeIterator.Next(DeckLinkdisplayMode))  then
      begin
       // if DeckLinkdisplayMode<>null then
        //begin
          if Succeeded(DeckLinkdisplayMode.GetName(modeNameBSTR)) then
          begin
            m_frameWidth := DeckLinkdisplayMode.GetWidth;
            m_frameHeight := DeckLinkdisplayMode.GetHeight;
            writeln(format('Using video mode: %s, width: %d, height: %d', [modeNameBSTR, m_frameWidth, m_frameHeight]));
            if Failed(m_deckLinkOutput.EnableVideoOutput(deckLinkDisplayMode.GetDisplayMode, bmdVideoOutputFlagDefault)) then
              writeln('Could not enable Video output')
            else begin
              if Failed(m_deckLinkOutput.CreateVideoFrame(m_frameWidth, m_frameHeight, m_frameWidth*4, bmdFormat8bitBGRA, bmdFrameFlagFlipVertical, m_videoFrameGDI)) then
                writeln('Could not obtain the IDeckLinkOutput CreateVideoFrame interface')
              else begin
                FillColourBars(m_videoFrameGDI);
                m_deckLinkOutput.DisplayVideoFrameSync(m_videoFrameGDI);
                writeln('Press Enter to exit.');
                ReadLN;
              end;
              m_deckLinkOutput.DisableVideoOutput;
            end;
          end;
        //end;
        writeln('Could not obtain a display mode')
      end;
    end;
  end;
end;


var
  DeckLinkIterator:IDeckLinkIterator;
  DeckLink: IDeckLink;
  deckLinkAPIInformation  : IDeckLinkAPIInformation;
  numDevices : integer=0;
  deckLinkVersion : int64;
	dlVerMajor, dlVerMinor, dlVerPoint : integer;
  hr: HRESULT;
  deviceNameBSTR:Widestring;
begin
  try
    CoInitialize(nil);
    hr := CoCreateInstance(CLASS_CDeckLinkIterator, nil, CLSCTX_ALL, IID_IDeckLinkIterator,  DeckLinkIterator);
    if FAILED(hr) then begin
      writeln(format('Initialization of COM failed - result = %08x.', [hr]));
      exit;
    end;

    hr:=DeckLinkIterator.QueryInterface(IID_IDeckLinkAPIInformation, deckLinkAPIInformation);
    if Succeeded(hr) then
    begin
      deckLinkAPIInformation.GetInt(BMDDeckLinkAPIVersion, deckLinkVersion);
		  dlVerMajor := (deckLinkVersion and $FF000000) shr 24;
		  dlVerMinor := (deckLinkVersion and $00FF0000) shr 16;
		  dlVerPoint := (deckLinkVersion and $0000FF00) shr 8;
		  writeln(format('DeckLinkAPI version: %d.%d.%d', [dlVerMajor, dlVerMinor, dlVerPoint]));
    end;

    while (deckLinkIterator.Next(deckLink) = S_OK)  do
      begin
        numDevices:=numDevices+1;
        writeln('');
        hr:=deckLink.GetModelName(deviceNameBSTR);
        if Succeeded(hr) then writeln(format('Found Blackmagic device: %s',[deviceNameBSTR]));
        writeln('');
        OutputGraphic(DeckLink);
      end;

	  // If no DeckLink cards were found in the system, inform the user
	  if (numDevices = 0) then writeln('No Blackmagic Design devices were found.');
	  // Uninitalize COM on this thread
	  CoUninitialize;
    writeln('Finish view.');
    ReadLN;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
