program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Classes,
  Winapi.Windows,
  System.Variants,
  Winapi.Activex,
  DeckLinkAPI.Types in '../../Include/DeckLinkAPI.Types.pas',
  DeckLinkAPI.Modes in '../../Include/DeckLinkAPI.Modes.pas',
  DeckLinkAPI.Discovery in '../../Include/DeckLinkAPI.Discovery.pas',
  DeckLinkAPI.Configuration in '../../Include/DeckLinkAPI.Configuration.pas',
  DeckLinkAPI.DeckControl in '../../Include/DeckLinkAPI.DeckControl.pas',
  DeckLinkAPI.Streaming in '../../Include/DeckLinkAPI.Streaming.pas',
  DeckLinkAPI in '../../Include/DeckLinkAPI.pas';

// Use GDI to draw in video frame
Procedure GDIDraw(theFrame : IDeckLinkVideoFrame);
var
  bmi : BITMAPINFO;
  dc : HDC;
  fillRect1, fillRect2, fillRect3, fillRect4 : TRECT;
  hbm : HBITMAP;
  pbData, pbDestData : Pointer;
  backBrush : HBRUSH;
begin
	// This function create a GDI bitmap, draws basic shapes in it,
	// and copies its content to the buffer of the DeckLink frame given in argument.

	// setup the bitmap info header members
  fillchar(bmi, sizeof(bmi),#0);
  bmi.bmiHeader.biSize := sizeof(BITMAPINFOHEADER);
  bmi.bmiHeader.biWidth := theFrame.GetWidth;
  bmi.bmiHeader.biHeight := theFrame.GetHeight;
  bmi.bmiHeader.biPlanes := 1;
  bmi.bmiHeader.biBitCount := 32;
  bmi.bmiHeader.biCompression := BI_RGB;
  bmi.bmiHeader.biSizeImage := (bmi.bmiHeader.biWidth * bmi.bmiHeader.biHeight * 4);

  // create a device context
  DC := CreateCompatibleDC(0);

  // create background and foreground rectangles
  fillRect1 := RECT(0, 0, bmi.bmiHeader.biWidth, bmi.bmiHeader.biHeight);
  fillRect2 := RECT(50, 50, 100, 100);
  fillRect3 := RECT(100, 100, 150, 150);
  fillRect4 := RECT(150, 150, 200, 200);

	// pointer to the bitmap buffer
  pbData := nil;

	// create the bitmap and attach it to our device context
  hbm := CreateDIBSection(DC, bmi, DIB_RGB_COLORS, pbData, 0, 0);
  SelectObject(dc, hbm);

	// create a brush to draw objects with
  backBrush := GetStockObject(DC_BRUSH);
  SetDCBrushColor(dc, RGB(50, 50, 110));

	// draw background rectangle
  FillRect(dc, fillRect1,backBrush);

  // draw string in centre of screen
  TextOut(dc, 30, 30, 'BlackMagic DeckLink SDK Delphi', 30);

	// draw red, green and blue foreground rectangles
  SetDCBrushColor(dc, RGB(222, 20, 0));
  FillRect(dc, fillRect2,backBrush);
  SetDCBrushColor(dc, RGB(0, 222, 0));
  FillRect(dc, fillRect3,backBrush);
  SetDCBrushColor(dc, RGB(0, 0, 222));
  FillRect(dc, fillRect4,backBrush);

	// draw ellipse
  Ellipse(dc, 200, 200, 300, 300);

	// get a pointer to our DeckLink's frame buffer
	pbDestData := nil;

	// get a pointer to our DeckLink's frame buffer
  theframe.GetBytes(pbDestData);

	// copy the bitmap buffer content to the DeckLink frame buffer
  CopyMemory(pbDestData, pbData, bmi.bmiHeader.biSizeImage);

	// delete attached GDI object and free bitmap memory
  deleteObject(SelectObject(dc, hbm));
end;

// Prepare video output
Procedure OutputGraphic(DeckLink: IDeckLink);
var
  m_deckLinkOutput            : IDeckLinkOutput;
  m_videoFrameGDI             : IDeckLinkMutableVideoFrame;
  DisplayModeIterator         : IDeckLinkDisplayModeIterator;
  DeckLinkdisplayMode         : IDeckLinkdisplayMode;
  modeNameBSTR                : WideString;
  m_frameWidth, m_frameHeight : integer;
begin
  m_deckLinkOutput := nil;
  m_videoFrameGdi := nil;

 	// Obtain the audio/video output interface (IDeckLinkOutput)
  if (DeckLink.QueryInterface(IID_IDeckLinkOutput, m_deckLinkOutput) <> S_OK) then
    writeln('Could not obtain the IDeckLinkOutput interface')
  else begin
    displayModeIterator := nil;
    deckLinkDisplayMode := nil;

		// Obtain a display mode iterator
    if (m_deckLinkOutput.GetDisplayModeIterator(DisplayModeIterator) <> S_OK) then
      writeln('Could not obtain the display mode iterator')
    else begin
      // Get the first display mode
      if (DisplayModeIterator.Next(DeckLinkdisplayMode) = S_OK)  then
      begin
        if Assigned(DeckLinkdisplayMode) then
        begin
          if (DeckLinkdisplayMode.GetName(modeNameBSTR) = S_OK) then
          begin
            // prints information about the display mode
            m_frameWidth := DeckLinkdisplayMode.GetWidth;
            m_frameHeight := DeckLinkdisplayMode.GetHeight;
            writeln(format('Using video mode: %s, width: %d, height: %d', [modeNameBSTR, m_frameWidth, m_frameHeight]));

            // enables video output on the DeckLink card
            if (m_deckLinkOutput.EnableVideoOutput(deckLinkDisplayMode.GetDisplayMode, bmdVideoOutputFlagDefault)<>S_OK) then
              writeln('Could not enable Video output')
            else begin
              // Get a BGRA frame
              if (m_deckLinkOutput.CreateVideoFrame(m_frameWidth, m_frameHeight, m_frameWidth * 4, bmdFormat8bitBGRA, bmdFrameFlagFlipVertical, m_videoFrameGDI) <> S_OK) then
                writeln('Could not obtain the IDeckLinkOutput CreateVideoFrame interface')
              else begin

                // draw on the frame
                GdiDraw(m_videoFrameGDI);

                // display the frame
                m_deckLinkOutput.DisplayVideoFrameSync(m_videoFrameGDI);

                writeln('Press Enter to exit.');
                ReadLN;
                if assigned(m_videoFrameGdi) then m_videoFrameGdi := nil;
                
              end;

              // disable the video output
              m_deckLinkOutput.DisableVideoOutput;
            end;
          end;
        end;
        // release the display mode
				if assigned(deckLinkDisplayMode) then deckLinkDisplayMode := nil;
      end else
        writeln('Could not obtain a display mode');

      // release the display mode iterator
      if assigned(displayModeIterator) then displayModeIterator := nil;
    end;
    // release the DeckLink Output interface
		if assigned(m_deckLinkOutput) then m_deckLinkOutput := nil;
  end;
end;

var
  DeckLinkIterator        :IDeckLinkIterator;
  DeckLink                : IDeckLink;
  deckLinkAPIInformation  : IDeckLinkAPIInformation;
  numDevices              : integer = 0;
  deckLinkVersion         : int64;
	dlVerMajor,
  dlVerMinor,
  dlVerPoint              : integer;
  result                  : HRESULT;
  deviceNameBSTR          :Widestring;
begin
  try
	  writeln('GDI Sample Application');

	  // Initialize COM on this thread
    result := CoInitialize(nil);
    if FAILED(result) then
    begin
      writeln(format('Initialization of COM failed - result = %08x.', [result]));
      exit;
    end;

    result := CoCreateInstance(CLASS_CDeckLinkIterator, nil, CLSCTX_ALL, IID_IDeckLinkIterator,  DeckLinkIterator);
    if FAILED(result) then
    begin
      writeln('A DeckLink iterator could not be created.  The DeckLink drivers may not be installed.');
      if assigned(deckLinkIterator) then deckLinkIterator := nil;
    end;

    result:=DeckLinkIterator.QueryInterface(IID_IDeckLinkAPIInformation, deckLinkAPIInformation);
    if Succeeded(result) then
    begin
      deckLinkAPIInformation.GetInt(BMDDeckLinkAPIVersion, deckLinkVersion);
		  dlVerMajor := (deckLinkVersion and $FF000000) shr 24;
		  dlVerMinor := (deckLinkVersion and $00FF0000) shr 16;
		  dlVerPoint := (deckLinkVersion and $0000FF00) shr 8;
		  writeln(format('DeckLinkAPI version: %d.%d.%d', [dlVerMajor, dlVerMinor, dlVerPoint]));
    end;

    while (deckLinkIterator.Next(deckLink) = S_OK)  do
      begin
        // Increment the total number of DeckLink cards found
        inc(numDevices);
	      if (numDevices > 1) then writeln('');

        // Print the model name of the DeckLink card
        result := deckLink.GetModelName(deviceNameBSTR);
        if result = S_OK then
        begin
          writeln(format('Found Blackmagic device: %s',[deviceNameBSTR]));
          OutputGraphic(DeckLink);
        end;
        if assigned(deckLink) then deckLink := nil;

      end;

    if assigned(deckLinkIterator) then deckLinkIterator := nil;

	  // If no DeckLink cards were found in the system, inform the user
	  if (numDevices = 0) then
      writeln('No Blackmagic Design devices were found.');

	  // Uninitalize COM on this thread
	  CoUninitialize;

    writeln('Finish view.');

    ReadLN;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
