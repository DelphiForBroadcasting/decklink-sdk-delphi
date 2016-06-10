program Project1;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Classes,
  Windows,
  Variants,
  activex,
  directshow9,
  GDIPAPI,
  GDIPOBJ,
  GDIPUTIL,
  DeckLinkAPI_TLB_9_8 in '../../DeckLinkAPI_TLB_9_8.pas';

const
 bar1: array[0..6] of cardinal = ($c0c0c0, $00c0c0, $c0c000,$00c000, $c000c0, $0000c0, $c00000) ;
 bar2: array[0..6] of cardinal = ($c00000, $131313,  $c000c0, $131313, $c0c000, $131313, $c0c0c0);
 bar3: array[0..7] of cardinal = ($4c2100, $ffffff, $6a0032, $131313, $090909, $131313, $1d1d1d, $131313);


Procedure SMPTE_Test(theFrame : IDeckLinkVideoFrame);
  function GPColor(Col: cardinal): TGPColor;
  begin
    Result := MakeColor(GetRValue(Col), GetGValue(Col),GetBValue(Col));
  end;
var
  Graphics  : TGPGraphics;
  brushs : TGPSolidBrush;
  bmp : TGPBitmap;
  pbData, pbDestData : Pointer;
  k1: Integer;
  x,y:integer;
  w_bar1, w_bar2 : array[0..6] of cardinal;
  w_bar3 : array[0..7] of cardinal;
  h_bar1, h_bar2, h_bar3:integer ;
  stride:integer;
  SourceSize : LongInt;
  Width,Height : integer;
  EncoderParams : EncoderParameters;
  Quality : DWORD;
  GUID_Encoder_PNG : TGUID;
begin
  Width := theFrame.GetWidth;
  Height := theFrame.GetHeight;
  SourceSize := Width * Height *4;
  stride := SourceSize div Height;
  GetMem(pbData,SourceSize);
  bmp := TGPBitmap.create(Width, Height, stride, PixelFormat32bppARGB, pbData);
  x:=0;
  y:=0;
  w_bar1[0]:=(Width div 7);
  w_bar1[1]:=(Width div 7);
  w_bar1[2]:=(Width div 7);
  w_bar1[3]:=(Width div 7);
  w_bar1[4]:=(Width div 7);
  w_bar1[5]:=(Width div 7);
  w_bar1[6]:=Width-(w_bar1[0]+w_bar1[1]+w_bar1[2]+w_bar1[3]+w_bar1[4]+w_bar1[5]);
  w_bar2[0]:=(Width div 7);
  w_bar2[1]:=(Width div 7);
  w_bar2[2]:=(Width div 7);
  w_bar2[3]:=(Width div 7);
  w_bar2[4]:=(Width div 7);
  w_bar2[5]:=(Width div 7);
  w_bar2[6]:=Width-(w_bar2[0]+w_bar2[1]+w_bar2[2]+w_bar2[3]+w_bar2[4]+w_bar2[5]);
  w_bar3[4]:=(Width div 7) div 3;
  w_bar3[5]:=(Width div 7) div 3;
  w_bar3[6]:=(Width div 7) div 3;
  w_bar3[7]:=w_bar2[6];
  w_bar3[0]:=(Width-(w_bar3[4]+w_bar3[4]+w_bar3[5]+w_bar3[6]+w_bar3[7])) div 4;
  w_bar3[1]:=w_bar3[0];
  w_bar3[2]:=w_bar3[0];
  w_bar3[3]:=w_bar3[0]+w_bar3[4];
  h_bar1:=Height-(Height div 3);
  h_bar2:=(Height div 3) div 4;
  h_bar3:= Height-h_bar2-h_bar1;

  graphics := TGPGraphics.Create(bmp);

  Graphics.ScaleTransform(1.0, -1.0);
  Graphics.TranslateTransform(0, Height, MatrixOrderAppend);
  Graphics.SetCompositingQuality(CompositingQualityHighQuality);

  for k1 := 0 to 6 do
  begin
  Brushs := TGPSolidBrush.Create(GPColor(bar1[k1]));
  Graphics.FillRectangle(Brushs, x, y, w_bar1[k1], h_bar1);
  x:=x+w_bar1[k1];
  Brushs.Free ;
  end;

  y:=y+h_bar1;
  x:=0;
  for k1 := 0 to 6 do
  begin
  Brushs := TGPSolidBrush.Create(GPColor(bar2[k1]));
  Graphics.FillRectangle(Brushs, x, y, w_bar2[k1], h_bar2);
  x:=x+w_bar2[k1];
  Brushs.Free ;
  end;

  y:=y+h_bar2;
  x:=0;
  for k1 := 0 to 7 do
  begin
  Brushs := TGPSolidBrush.Create(GPColor(bar3[k1]));
  Graphics.FillRectangle(Brushs, x, y, w_bar3[k1], h_bar3);
  x:=x+w_bar3[k1];
  Brushs.Free ;
  end;

//SAVE-----------
  Quality:=100;
  GetEncoderCLSID('image/png', GUID_Encoder_PNG);
  Encoderparams.Count:=1;
  with encoderparams.parameter[0] do
  begin
    GUID  :=EncoderQuality;
    NumberOfValues  :=1;
    Type_ :=  EncoderParameterValueTypeLong;
    Value :=  @Quality;
  end;
  //bmp.Save('SMPTE.png', GUID_Encoder_PNG, @EncoderParams);
//----------

  theframe.GetBytes(pbDestData);
  CopyMemory(pbDestData, pbData, SourceSize);
  FreeMem(pbData);
  bmp.Free;
  graphics.Free;
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
      while (DisplayModeIterator.Next(DeckLinkdisplayMode) = S_OK)  do
      //if Succeeded(DisplayModeIterator.Next(DeckLinkdisplayMode))  then
      begin
       // if DeckLinkdisplayMode<>null then
        //begin
          if Succeeded(DeckLinkdisplayMode.GetName(modeNameBSTR)) then
          begin
            if modeNameBSTR='HD 1080i 50' then
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
                  SMPTE_Test(m_videoFrameGDI);
                  m_deckLinkOutput.DisplayVideoFrameSync(m_videoFrameGDI);
                  writeln('Press Enter to exit.');
                  ReadLN;
                end;
                m_deckLinkOutput.DisableVideoOutput;
              end;
              break;
            end;
          end;
          //writeln('Could not obtain a display mode');
        //end;
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
