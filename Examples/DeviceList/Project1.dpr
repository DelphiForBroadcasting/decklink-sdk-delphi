program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Variants,
  Winapi.activex,
  Winapi.directshow9,
  DeckLinkAPI_TLB_10_3_1 in '../../../DeckLinkAPI_TLB_10_3_1.pas';

const
  gKnownPixelFormats: array[0..5] of _BMDPixelFormat		= (bmdFormat8BitYUV, bmdFormat10BitYUV, bmdFormat8BitARGB, bmdFormat8BitBGRA, bmdFormat10BitRGB, 0);
  gKnownPixelFormatNames: array[0..5] of string	= ('8-bit YUV', '10-bit YUV', '8-bit ARGB', '8-bit BGRA', '10-bit RGB', 'NULL');

procedure	print_attributes(var deckLink: IDeckLink);
var
  result                : HRESULT;
  supported             : integer;
  deckLinkAttributes    : IDeckLinkAttributes;
  portname              : WideString;
  value                 : Int64;
begin
  deckLinkAttributes := nil;
	// Query the DeckLink for its attributes interface
  result:=deckLink.QueryInterface(IID_IDeckLinkAttributes, deckLinkAttributes);
  if result<>S_OK then
  begin
		writeln(format('Could not obtain the IDeckLinkAttributes interface - result = %08x', [result]));
    exit;
  end;

	// List attributes and their value
  writeln('Attribute list:');

  //Serial port
  result:=deckLinkAttributes.GetFlag(BMDDeckLinkHasSerialPort, supported);
  if result = S_OK then
  begin
    if boolean(supported) then
      writeln(format(' %-40s YES', ['Serial port present:']))
    else
      writeln(format(' %-40s NO', ['Serial port present:']));

    if boolean(supported) then
    begin
      result:=deckLinkAttributes.GetString(BMDDeckLinkSerialPortDeviceName, portName);
      if result = S_OK then
        writeln(format(' %-40s %s', ['Serial port name:', portName]))
      else
        writeln(format('Could not query the serial port name attribute- result = %08x', [result]));
    end;
  end else
    writeln(format('Could not query the serial port presence attribute- result = %08x', [result]));

	result := deckLinkAttributes.GetInt(BMDDeckLinkPersistentID, value);
  if result = S_OK then
		writeln(format(' %-40s %llx', ['Device Persistent ID:', value]))
  else
		writeln(format(' %-40s %s', ['Device Persistent ID:', 'Not Supported on this device']));


	result := deckLinkAttributes.GetInt(BMDDeckLinkTopologicalID, value);
  if result = S_OK then
		writeln(format(' %-40s %06x', ['Device Topological ID:',  value]))
  else
		writeln(format(' %-40s %s', ['Device Topological ID:', 'Not Supported on this device']));


  result := deckLinkAttributes.GetInt(BMDDeckLinkNumberOfSubDevices, value);
  if result = S_OK then
  begin
    writeln(format(' %-40s %d', ['Number of sub-devices:', value]));
    if value<>0 then
    begin
      result := deckLinkAttributes.GetInt(BMDDeckLinkSubDeviceIndex, value);
      if result = S_OK then
        writeln(format(' %-40s %d', ['Sub-device index:', value]))
      else
        writeln(format('Could not query the sub-device index attribute- result = %08x', [result]));
    end;
  end else
    writeln(format('Could not query the number of sub-device attribute- result = %08x', [result]));

  //number of audio channels
  result := deckLinkAttributes.GetInt(BMDDeckLinkMaximumAudioChannels, value);
  if result = S_OK then
    writeln(format(' %-40s %d', ['Maximum number of audio channels:', value]))
  else
    writeln(format('Could not query the internal keying attribute- result = %08x', [result]));

  //Input mode detection supported
  result := deckLinkAttributes.GetFlag(BMDDeckLinkSupportsInputFormatDetection, supported);
  if result = S_OK then
  begin
    if boolean(supported) then
      writeln(format(' %-40s %s',['Input mode detection supported:', 'Yes']))
    else
      writeln(format(' %-40s %s',['Input mode detection supported:', 'No']));
  end else
    writeln(format('Could not query the input mode detection attribute- result = %08x', [result]));

  // Full duplex supported
	result := deckLinkAttributes.GetFlag(BMDDeckLinkSupportsFullDuplex, supported);
  if result = S_OK then
  begin
    if boolean(supported) then
      writeln(format(' %-40s %s',['Full duplex operation supported:', 'Yes']))
    else
      writeln(format(' %-40s %s',['Full duplex operation supported:', 'No']));
  end else
    writeln(format('Could not query the full duplex operation supported attribute- result = %08x', [result]));

  //Internal keying supported
  result := deckLinkAttributes.GetFlag(BMDDeckLinkSupportsInternalKeying, supported);
  if result = S_OK then
  begin
    if boolean(supported) then
      writeln(format(' %-40s %s',['Internal keying supported:', 'Yes']))
    else
      writeln(format(' %-40s %s',['Internal keying supported:', 'No']));
  end else
    writeln(format('Could not query the internal keying attribute- result = %08x', [result]));

  //External keying supported
  result := deckLinkAttributes.GetFlag(BMDDeckLinkSupportsExternalKeying, supported);
  if result = S_OK then
  begin
    if boolean(supported) then
      writeln(format(' %-40s %s',['External keying supported:', 'Yes']))
    else
      writeln(format(' %-40s %s',['External keying supported:', 'No']));
  end else
    writeln(format('Could not query the external keying attribute- result = %08x', [result]));

  //HD-mode keying supported
  result := deckLinkAttributes.GetFlag(BMDDeckLinkSupportsHDKeying, supported);
  if result = S_OK then
  begin
    if boolean(supported) then
      writeln(format(' %-40s %s',['HD-mode keying supported:', 'Yes']))
    else
      writeln(format(' %-40s %s',['HD-mode keying supported:', 'No']));
  end else
    writeln(format('Could not query the HD-mode keying attribute- result = %08x', [result]));
end;

procedure print_output_modes(var deckLink: IDeckLink);
var
  deckLinkOutput      : IDeckLinkOutput;
  displayModeIterator : IDeckLinkDisplayModeIterator;
  displayMode         : IDeckLinkDisplayMode;
  resultDisplayMode   : IDeckLinkDisplayMode;
  result              : HRESULT;
  modeName            : WideString;
  frameRateDuration,
  frameRateScale      : int64;
  modeWidth,
  modeHeight          : integer;
  pixelFormatIndex    : integer;
  PixelFormatNames    : string;
  FrameRate           : extended;
  displayModeSupport  : _BMDDisplayModeSupport;
begin
  deckLinkOutput := nil;
  displayModeIterator := nil;
  displayMode := nil;
  resultDisplayMode := nil;

	// Query the DeckLink for its configuration interface
  result := deckLink.QueryInterface(IID_IDeckLinkOutput, deckLinkOutput);
	if (result <> S_OK) then
	begin
    writeln(format('Could not obtain the IDeckLinkOutput interface - result = %08x', [result]));
    if assigned(displayModeIterator) then displayModeIterator:=nil;
    if assigned(deckLinkOutput) then deckLinkOutput:=nil;
		exit;
	end;

	// Obtain an IDeckLinkDisplayModeIterator to enumerate the display modes supported on output
  result := deckLinkOutput.GetDisplayModeIterator(displayModeIterator);
	if (result <> S_OK) then
	begin
    writeln(format('Could not obtain the video output display mode iterator - result = %08x', [result]));
    if assigned(displayModeIterator) then displayModeIterator:=nil;
    if assigned(deckLinkOutput) then deckLinkOutput:=nil;
		exit;
	end;

	// List all supported output display modes
  writeln('Supported video output display modes:');
  while (displayModeIterator.Next(displayMode) = S_OK)  do
  begin
    pixelFormatIndex:=0;
    PixelFormatNames:='';
    FrameRate:=0;
    result := displayMode.GetName(modeName);
    if (result = S_OK) then
		begin
      modeWidth:=displayMode.GetWidth;
      modeHeight:=displayMode.GetHeight;
      if Succeeded(displayMode.GetFrameRate(frameRateDuration, frameRateScale)) then
        FrameRate:=frameRateScale /frameRateDuration;
			writeln(format(' %-20s %d x %d %7g FPS', [modeName, modeWidth, modeHeight, FrameRate]));

      // Print the supported pixel formats for this display mode
      while ((gKnownPixelFormats[pixelFormatIndex] <> 0) and (gKnownPixelFormatNames[pixelFormatIndex] <> null)) do
      begin
        if ((deckLinkOutput.DoesSupportVideoMode(displayMode.GetDisplayMode, gKnownPixelFormats[pixelFormatIndex], bmdVideoOutputFlagDefault, displayModeSupport, resultDisplayMode) = S_OK) and (displayModeSupport <> bmdDisplayModeNotSupported)) then
        begin
         writeln(format('%s',[ gKnownPixelFormatNames[pixelFormatIndex]]));
        end;
        inc(pixelFormatIndex);
      end;
    end;
    // Release the IDeckLinkDisplayMode object to prevent a leak
    if assigned(displayMode) then displayMode:=nil;
  end;
end;

procedure print_input_modes(var deckLink: IDeckLink);
var
  deckLinkInput       : IDeckLinkInput;
  displayModeIterator : IDeckLinkDisplayModeIterator;
	displayMode         : IDeckLinkDisplayMode;
  resultDisplayMode   : IDeckLinkDisplayMode;
	result              : HRESULT;
  modeName            : WideString;
  frameRateDuration,
  frameRateScale      : int64;
  modeWidth,
  modeHeight          : integer;
  pixelFormatIndex    : integer;
  PixelFormatNames    : string;
  FrameRate           : extended;
  displayModeSupport  : _BMDDisplayModeSupport;
begin
  deckLinkInput       := nil;
  displayModeIterator := nil;
	displayMode         := nil;
  resultDisplayMode   := nil;

	// Query the DeckLink for its configuration interface
	result := deckLink.QueryInterface(IID_IDeckLinkInput, deckLinkInput);
	if (result <> S_OK) then
  begin
		writeln(format('Could not obtain the IDeckLinkInput interface - result = %08x', [result]));
	  // Ensure that the interfaces we obtained are released to prevent a memory leak
	  if assigned(displayModeIterator) then	displayModeIterator:=nil;
	  if assigned(deckLinkInput) then deckLinkInput:=nil;
    exit;
  end;

	// Obtain an IDeckLinkDisplayModeIterator to enumerate the display modes supported on input
	result := deckLinkInput.GetDisplayModeIterator(displayModeIterator);
	if (result <> S_OK) then
	begin
		writeln(format('Could not obtain the video input display mode iterator - result = %08x', [result]));
	  if assigned(displayModeIterator) then	displayModeIterator:=nil;
	  if assigned(deckLinkInput) then deckLinkInput:=nil;
    exit;
  end;

	// List all supported input display modes
	writeln('Supported video input display modes:');
	while (displayModeIterator.Next(displayMode) = S_OK) do
	begin
    pixelFormatIndex := 0; // index into the gKnownPixelFormats / gKnownFormatNames arrays
    FrameRate:=0;
    PixelFormatNames:='';
		result := displayMode.GetName(modeName);
		if (result = S_OK) then
		begin
			// Obtain the display mode's properties
			modeWidth := displayMode.GetWidth();
			modeHeight := displayMode.GetHeight();
      if Succeeded(displayMode.GetFrameRate(frameRateDuration, frameRateScale)) then
        FrameRate:=frameRateScale /frameRateDuration;
			writeln(format(' %-20s %d x %d %7g FPS', [modeName, modeWidth, modeHeight, FrameRate]));

      // Print the supported pixel formats for this display mode
      while ((gKnownPixelFormats[pixelFormatIndex] <> 0) and (gKnownPixelFormatNames[pixelFormatIndex] <> null)) do
      begin
        if ((deckLinkInput.DoesSupportVideoMode(displayMode.GetDisplayMode, gKnownPixelFormats[pixelFormatIndex], bmdVideoOutputFlagDefault, displayModeSupport, resultDisplayMode) = S_OK) and (displayModeSupport <> bmdDisplayModeNotSupported)) then
        begin
         writeln(format('%s',[ gKnownPixelFormatNames[pixelFormatIndex]]));
        end;
        inc(pixelFormatIndex);
      end;
		end;
		// Release the IDeckLinkDisplayMode object to prevent a leak
		displayMode:=nil;
	end;
end;



procedure print_capabilities(var deckLink: IDeckLink);
var
	deckLinkAttributes : IDeckLinkAttributes;
	ports : int64;
	itemCount : integer;
  result  : HRESULT;
begin
  deckLinkAttributes := nil;
	// Query the DeckLink for its configuration interface
  result:=deckLink.QueryInterface(IID_IDeckLinkAttributes, deckLinkAttributes);
  if result<>S_OK then
  begin
		writeln(format('Could not obtain the IDeckLinkAttributes interface - result = %08x', [result]));
    exit;
  end;

	writeln('Supported video output connections: ');
	itemCount := 0;
	result := deckLinkAttributes.GetInt(BMDDeckLinkVideoOutputConnections, ports);
	if (result = S_OK) then
	begin
		if (ports and bmdVideoConnectionSDI)>0 then
		begin
			inc(itemCount);
			write('SDI');
		end;

		if (ports and bmdVideoConnectionHDMI)>0 then
    begin
      inc(itemCount);
			if (itemCount > 0) then write(', ');
			write('HDMI');
		end;

		if (ports and bmdVideoConnectionOpticalSDI)>0 then
		begin
      inc(itemCount);
			if (itemCount > 0) then write(', ');
			write('Optical SDI');
		end;

		if (ports and bmdVideoConnectionComponent)>0 then
		begin
      inc(itemCount);
			if (itemCount > 0) then write(', ');
			write('Component');
		end;

		if (ports and bmdVideoConnectionComposite)>0 then
		begin
      inc(itemCount);
			if (itemCount > 0) then write(', ');
			write('Composite');
		end;

		if (ports and bmdVideoConnectionSVideo)>0 then
		begin
      inc(itemCount);
			if (itemCount > 0) then write(', ');
			write('S-Video');
		end;
	end	else
	begin
		writeln(format('Could not obtain the list of output ports - result = %08x', [result]));
    if assigned(deckLinkAttributes) then		deckLinkAttributes:=nil;
    exit;
	end;

  writeln('');

	writeln('Supported video input connections:  ');
	itemCount := 0;
	result := deckLinkAttributes.GetInt(BMDDeckLinkVideoInputConnections, ports);
	if (result = S_OK) then
	begin
		if (ports and bmdVideoConnectionSDI)>0 then
		begin
			inc(itemCount);
			write('SDI');
		end;

		if (ports and bmdVideoConnectionHDMI)>0 then
    begin
      inc(itemCount);
			if (itemCount > 0) then write(', ');
			write('HDMI');
		end;

		if (ports and bmdVideoConnectionOpticalSDI)>0 then
		begin
      inc(itemCount);
			if (itemCount > 0) then write(', ');
			write('Optical SDI');
		end;

		if (ports and bmdVideoConnectionComponent)>0 then
		begin
      inc(itemCount);
			if (itemCount > 0) then write(', ');
			write('Component');
		end;

		if (ports and bmdVideoConnectionComposite)>0 then
		begin
      inc(itemCount);
			if (itemCount > 0) then write(', ');
			write('Composite');
		end;

		if (ports and bmdVideoConnectionSVideo)>0 then
		begin
      inc(itemCount);
			if (itemCount > 0) then write(', ');
			write('S-Video');
		end
	end	else
  begin
		writeln(format('Could not obtain the list of input ports - result = %08x', [result]));
    if assigned(deckLinkAttributes) then		deckLinkAttributes:=nil;
    exit;
	end;
end;

var
  DeckLink_               : IDeckLink;
  deckLinkAPIInformation  : IDeckLinkAPIInformation;
  deckLinkIterator        : IDeckLinkIterator;
  deviceName              : WideString;
  result                  : HRESULT;
  deckLinkVersion         : int64;
	dlVerMajor,
  dlVerMinor,
  dlVerPoint              : integer;
  numDevices              : integer;
begin
  try
    numDevices := 0;
    DeckLink_ := nil;
    deckLinkIterator := nil;
    deckLinkAPIInformation := nil;
  	// Initialize COM on this thread
    result:=CoInitialize(nil);
    if FAILED(result) then
    begin
      writeln(format('Initialization of COM failed - result = %08x.', [result]));
      exit;
    end;

  	// Create an IDeckLinkIterator object to enumerate all DeckLink cards in the system
    result := CoCreateInstance(CLASS_CDeckLinkIterator, nil, CLSCTX_ALL, IID_IDeckLinkIterator,  DeckLinkIterator);
    if FAILED(result) then
    begin
      writeln('A DeckLink iterator could not be created.  The DeckLink drivers may not be installed.');
      exit;
    end;

	  // We can get the version of the API like this:
    result:=DeckLinkIterator.QueryInterface(IID_IDeckLinkAPIInformation, deckLinkAPIInformation);
    if result = S_OK then
    begin
      deckLinkAPIInformation.GetInt(BMDDeckLinkAPIVersion, deckLinkVersion);
		  dlVerMajor := (deckLinkVersion and $FF000000) shr 24;
		  dlVerMinor := (deckLinkVersion and $00FF0000) shr 16;
		  dlVerPoint := (deckLinkVersion and $0000FF00) shr 8;
		  writeln(format('DeckLinkAPI version: %d.%d.%d', [dlVerMajor, dlVerMinor, dlVerPoint]));
      deckLinkAPIInformation:=nil;
    end;

    // Enumerate all cards in this system
    while (deckLinkIterator.Next(deckLink_) = S_OK)  do
    begin
      inc(numDevices);
      writeln('');
      result:=deckLink_.GetModelName(deviceName);
      if result = S_OK then
        writeln(format('=============== %s ===============', [deviceName]));

		  // ** Print all DeckLink Attributes
      print_attributes(deckLink_);

		  // ** List the video output display modes supported by the card
      print_output_modes(deckLink_);

		  // ** List the video input display modes supported by the card
		  print_input_modes(deckLink_);

		  // ** List the input and output capabilities of the card
		  print_capabilities(deckLink_);

		  // Release the IDeckLink instance when we've finished with it to prevent leaks
		  if assigned(deckLink_) then  deckLink_:=nil;

      writeln('');
    end;

	  // If no DeckLink cards were found in the system, inform the user
	  if (numDevices = 0) then
      writeln('No Blackmagic Design devices were found.');

	  // Uninitalize COM on this thread
	  CoUninitialize;

    ReadLN;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
