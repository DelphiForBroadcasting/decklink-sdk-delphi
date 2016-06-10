program Project1;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Variants,
  activex,
  directshow9,
  DeckLinkAPI_TLB_9_8 in '../../DeckLinkAPI_TLB_9_8.pas';

const
  gKnownPixelFormats: array[0..5] of _BMDPixelFormat		= (bmdFormat8BitYUV, bmdFormat10BitYUV, bmdFormat8BitARGB, bmdFormat8BitBGRA, bmdFormat10BitRGB, 0);
  gKnownPixelFormatNames:array[0..5] of string	= ('8-bit YUV', '10-bit YUV', '8-bit ARGB', '8-bit BGRA', '10-bit RGB', 'NULL');

var
  DeckLinkIterator:IDeckLinkIterator;
  DeckLink: IDeckLink;
  deckLinkAttributes:IdeckLinkAttributes;
  deckLinkOutput:IdeckLinkOutput;
  DeckLinkDisplayModeIterator:IDeckLinkDisplayModeIterator;
  DeckLinkdisplayMode:IDeckLinkdisplayMode;
  displayModeSupport:_BMDDisplayModeSupport;
  resultDeckLinkdisplayMode:IDeckLinkdisplayMode;
  deckLinkAPIInformation  : IDeckLinkAPIInformation;
  hr: HRESULT;
  deviceNameBSTR:Widestring;
  portname:WideString;
  supported:integer;
  count:int64;
  ports:int64;
  frameRateDuration, frameRateScale:int64;
  Width,Height:integer;
  modeName:WideString;
  pixelFormatIndex:integer;
  PixelFormatNames:string;
  FrameRate:extended;
  deckLinkVersion : int64;
	dlVerMajor, dlVerMinor, dlVerPoint : integer;
  numDevices : integer=0;
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
      if Succeeded(hr) then writeln(format('=============== %s ===============',[deviceNameBSTR]));
      supported:=-2;
      writeln('');
      //-----------------------------print_attributes
      hr:=deckLink.QueryInterface(IID_IDeckLinkAttributes,deckLinkAttributes);
      if Succeeded(hr) then
      begin
        writeln('Attribute list:');

        //Serial port
        if Succeeded(deckLinkAttributes.GetFlag(BMDDeckLinkHasSerialPort, supported)) then

        if supported=1 then
        begin
          writeln(format(' %-40s %s', ['Serial port present:', 'Yes']));
          if Succeeded(deckLinkAttributes.GetString(BMDDeckLinkSerialPortDeviceName,portName)) then
            writeln(format(' %-40s %s', ['Serial port name:', portName]));
        end else
        if supported=0 then
          writeln(format(' %-40s %s',['Serial port present:', 'No']));


         //sub-devices
        if Succeeded(deckLinkAttributes.GetInt(BMDDeckLinkNumberOfSubDevices, count)) then
        begin
          writeln(format(' %-40s %d', ['Number of sub-devices:', count]));
          if count<>0 then
          if Succeeded(deckLinkAttributes.GetInt(BMDDeckLinkSubDeviceIndex, count)) then
            writeln(format(' %-40s %d', ['Sub-device index:', count]));
        end;


        //number of audio channels
        if Succeeded(deckLinkAttributes.GetInt(BMDDeckLinkMaximumAudioChannels, count)) then
          writeln(format(' %-40s %d', ['Maximum number of audio channels:', count]));

        //Input mode detection supported
        if Succeeded(deckLinkAttributes.GetFlag(BMDDeckLinkSupportsInputFormatDetection, supported)) then
        if supported=0 then
          writeln(format(' %-40s %s',['Input mode detection supported:', 'No'])) else
        if supported=1 then
          writeln(format(' %-40s %s',['Input mode detection supported:', 'Yes']));



        //Internal keying supported
        if Succeeded(deckLinkAttributes.GetFlag(BMDDeckLinkSupportsInternalKeying, supported)) then
        if supported=0 then
          writeln(format(' %-40s %s',['Internal keying supported:', 'No'])) else
        if supported=1 then
          writeln(format(' %-40s %s', ['Internal keying supported:', 'Yes']));

          //External keying supported
        if Succeeded(deckLinkAttributes.GetFlag(BMDDeckLinkSupportsExternalKeying, supported)) then
        if supported=0 then
          writeln(format(' %-40s %s', ['External keying supported:', 'No'])) else
        if supported=1 then
          writeln(format(' %-40s %s', ['External keying supported:', 'Yes']));


          //HD-mode keying supported
        if Succeeded(deckLinkAttributes.GetFlag(BMDDeckLinkSupportsHDKeying, supported)) then
        if supported=0 then
          writeln(format(' %-40s %s', ['HD-mode keying supported:', 'No'])) else
        if supported=1 then
          writeln(format(' %-40s %s', ['HD-mode keying supported:', 'Yes']));


        //Supported video output connections
        if Succeeded(deckLinkAttributes.GetInt(BMDDeckLinkVideoOutputConnections, ports)) then
        begin
          case ports of
            bmdVideoConnectionSDI         : writeln(format(' %-40s %s', ['Supported video output connections:', 'SDI']));
            bmdVideoConnectionHDMI        : writeln(format(' %-40s %s', ['Supported video output connections:', 'HDMI']));
            bmdVideoConnectionOpticalSDI  : writeln(format(' %-40s %s', ['Supported video output connections:', 'Optical SDI']));
            bmdVideoConnectionComponent   : writeln(format(' %-40s %s', ['Supported video output connections:', 'Component']));
            bmdVideoConnectionComposite   : writeln(format(' %-40s %s', ['Supported video output connections:', 'Composite']));
            bmdVideoConnectionSVideo      : writeln(format(' %-40s %s', ['Supported video output connections:', 'SVideo']));
          end;
        end;

        // Supported video input connections
        if Succeeded(deckLinkAttributes.GetInt(BMDDeckLinkVideoInputConnections, ports)) then
        begin
          case ports of
            bmdVideoConnectionSDI         : writeln(format(' %-40s %s', ['Supported video input connections:', 'SDI']));
            bmdVideoConnectionHDMI        : writeln(format(' %-40s %s', ['Supported video input connections:', 'HDMI']));
            bmdVideoConnectionOpticalSDI  : writeln(format(' %-40s %s', ['Supported video input connections:', 'Optical SDI']));
            bmdVideoConnectionComponent   : writeln(format(' %-40s %s', ['Supported video input connections:', 'Component']));
            bmdVideoConnectionComposite   : writeln(format(' %-40s %s', ['Supported video input connections:', 'Composite']));
            bmdVideoConnectionSVideo      : writeln(format(' %-40s %s', ['Supported video input connections:', 'SVideo']));
          end;
        end;
      end;  //-----------------end print_attributes




    //--------------start print_output_modes-----------------

      hr:=deckLink.QueryInterface(IID_IDeckLinkOutput, deckLinkOutput);
      if Succeeded(deckLinkOutput.GetDisplayModeIterator(DeckLinkDisplayModeIterator)) then
      begin
        writeln('');
        writeln('Supported video output display modes:');
        while (DeckLinkDisplayModeIterator.Next(DeckLinkdisplayMode) = S_OK)  do
        begin
          hr:=DeckLinkdisplayMode.GetName(modeName);
          Width:=DeckLinkdisplayMode.GetWidth;
          Height:=DeckLinkdisplayMode.GetHeight;
          if Succeeded(DeckLinkdisplayMode.GetFrameRate(frameRateDuration, frameRateScale)) then FrameRate:=frameRateScale /frameRateDuration;
          pixelFormatIndex:=0;
          PixelFormatNames:='';
          // Print the supported pixel formats for this display mode
          while ((gKnownPixelFormats[pixelFormatIndex] <> 0) and (gKnownPixelFormatNames[pixelFormatIndex] <> null)) do
          begin
            if (Succeeded(deckLinkOutput.DoesSupportVideoMode(DeckLinkdisplayMode.GetDisplayMode, gKnownPixelFormats[pixelFormatIndex], bmdVideoOutputFlagDefault, displayModeSupport,resultDeckLinkdisplayMode))   and (displayModeSupport <> bmdDisplayModeNotSupported)) then
            begin
              PixelFormatNames:=PixelFormatNames+' '+gKnownPixelFormatNames[pixelFormatIndex];
            end;
            inc(pixelFormatIndex);
          end;
          writeln(format(' %-15s %d x %-15d %f FPS  %s',[modeName, Width, Height, FrameRate, PixelFormatNames]));
        end;
      end;
    //--------------END print_output_modes-----------------
end;

	// If no DeckLink cards were found in the system, inform the user
	if (numDevices = 0) then writeln('No Blackmagic Design devices were found.');
	// Uninitalize COM on this thread
	 CoUninitialize;
   ReadLN;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
