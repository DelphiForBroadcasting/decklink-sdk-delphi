program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Winapi.Windows,
  Winapi.activex,
  Winapi.directshow9,
  DeckLinkAPI_TLB_10_4_1 in '../../DeckLinkAPI_TLB_10_4_1.pas';

const
  COMM_BUFFER_SIZE = 20;

var
  hCommPort           : THANDLE = INVALID_HANDLE_VALUE;
  deckLinkIterator    : IDeckLinkIterator;
  deckLink            : IDeckLink;
  numDevices          :integer = 0;
  hr                  : HResult;
  deviceNameBSTR      : wideString;
  deckLinkAttributes  : IDeckLinkAttributes;
  attributeResult     :HRESULT;
  serialNameBSTR      : wideString;
  serialSupported     : integer;

Procedure  errorMessage(dwError: integer);	// Provides a detailed error message
var
	lpMsgBuf: LPVOID;
begin
  lpMsgBuf := nil;
  FormatMessage(
        FORMAT_MESSAGE_ALLOCATE_BUFFER or
        FORMAT_MESSAGE_FROM_SYSTEM or
        FORMAT_MESSAGE_IGNORE_INSERTS,
        NIL,
        dwError,
        MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
        LPTSTR(lpMsgBuf),
        0, nil );

	writeln(Format('Error: %08X: %s', [dwError, LPCTSTR(lpMsgBuf)]));
	//LocalFree(lpMsgBuf);
end;

function	openSerialDevice(serialName: string): boolean;
label
  bail;
var
  serialOpen  : boolean;
	timeouts    : TCOMMTIMEOUTS;
begin
  serialOpen := false;
  writeln('Opening COM port for read/write ...');
  hCommPort:=Winapi.Windows.CreateFile(PChar(serialName), GENERIC_READ or   // comport - переменная типа string, номер компорта в формате 'COM3', 'COM11', 'COM1' и т.п.
                              GENERIC_WRITE,
                              FILE_SHARE_READ or FILE_SHARE_WRITE,
                              nil, OPEN_EXISTING,
                              FILE_ATTRIBUTE_NORMAL, 0);
  if hCommPort=INVALID_HANDLE_VALUE then
  begin
		writeln(format('FAIL: CreateFile(), LastError = %08X', [GetLastError()]));
		goto bail;
  end;
  serialOpen := TRUE;
  timeouts.ReadIntervalTimeout := 0;
	timeouts.ReadTotalTimeoutConstant := 15;	// standard says the deck should replies within 9 ms
	timeouts.ReadTotalTimeoutMultiplier := 0;

	// mark write timeouts as not used
	timeouts.WriteTotalTimeoutMultiplier := 0;
	timeouts.WriteTotalTimeoutConstant := 0;

	if SetCommTimeouts(hCommPort, timeouts)=FALSE then
		writeln('Error setting timeouts');

bail:
 	result:=serialOpen;
end;


Procedure closeSerialDevice();
begin
  if hCommPort <> INVALID_HANDLE_VALUE then
  begin
    writeln('Closing COM port ...');
		CloseHandle(hCommPort);
  end else
  begin
		writeln('Invalid serial handle');
	  writeln('Device closed');
  end;
end;


Procedure	playCommand();
var
  i     : integer;
  dwError : integer;
  byteCount :	cardinal;
  transmitBuffer: array[0..COMM_BUFFER_SIZE] of byte;
  receiveBuffer: array[0..COMM_BUFFER_SIZE] of byte;
begin
  byteCount := 0;
	writeln('Sending PlayCommand');
 	transmitBuffer[0] := $20;		// Play command
 	transmitBuffer[1] := $01;
 	transmitBuffer[2] := $21;

	try
		if (not WriteFile(hCommPort, transmitBuffer, 3, byteCount, nil)) then
			writeln('FAIL: WriteFile()');

		if (not ReadFile(hCommPort, receiveBuffer, COMM_BUFFER_SIZE, byteCount, nil)) then
			writeln('FAIL: ReadFile()');

		writeln('Received: ');
		for i:=0 to byteCount-1 do
			writeln(format(' %02X', [receiveBuffer[i]]));
  except
		dwError := GetLastError();					// additional debug information
		errorMessage(dwError);
  end;
end;

Procedure	stopCommand();
var
  i     : integer;
  dwError : integer;
  byteCount :	cardinal;
  transmitBuffer: array[0..COMM_BUFFER_SIZE] of byte;
  receiveBuffer: array[0..COMM_BUFFER_SIZE] of byte;
begin
  byteCount := 0;
	writeln('Sending StopCommand');
 	transmitBuffer[0] := $20;		// stop command
 	transmitBuffer[1] := $00;
 	transmitBuffer[2] := $21;

	try
		if (not WriteFile(hCommPort, transmitBuffer, 3, byteCount, nil)) then
			writeln('FAIL: WriteFile()');

		if (not ReadFile(hCommPort, receiveBuffer, COMM_BUFFER_SIZE, byteCount, nil)) then
			writeln('FAIL: ReadFile()');

		writeln('Received: ');
		for i:=0 to byteCount-1 do
			writeln(format(' %02X', [receiveBuffer[i]]));
  except
		dwError := GetLastError();					// additional debug information
		errorMessage(dwError);
  end;
end;

Procedure	timeCodeCommand();
var
  i     : integer;
  dwError : integer;
  byteCount :	cardinal;
  transmitBuffer: array[0..COMM_BUFFER_SIZE] of byte;
  receiveBuffer: array[0..COMM_BUFFER_SIZE] of byte;
begin
  byteCount := 0;
	writeln('Sending timeCodeCommand');
 	transmitBuffer[0] := $61;		// timeCode command
 	transmitBuffer[1] := $0c;
 	transmitBuffer[2] := $03;
 	transmitBuffer[3] := $70;
	try
		if (not WriteFile(hCommPort, transmitBuffer, 3, byteCount, nil)) then
			writeln('FAIL: WriteFile()');

		if (not ReadFile(hCommPort, receiveBuffer, COMM_BUFFER_SIZE, byteCount, nil)) then
			writeln('FAIL: ReadFile()');

		writeln('Received: ');
		for i:=0 to byteCount-1 do
			writeln(format(' %02X', [receiveBuffer[i]]));


    if (((receiveBuffer[0]=$74) and (receiveBuffer[1]=$04)) or (receiveBuffer[1]=$06))	then// LTC time data
    begin
          writeln(Format('TC %02x:%02x:%02x:%02x', [receiveBuffer[5],receiveBuffer[4],receiveBuffer[3],receiveBuffer[2]]));
    end;

  except
		dwError := GetLastError();					// additional debug information
		errorMessage(dwError);
  end;
end;

begin
  try

    writeln('DeckControl Test Application');
    writeln('');

    // Initialize COM on this thread
    hr:=CoInitialize(nil);
    if FAILED(hr) then
    begin
      writeln(format('Initialization of COM failed - result = %08x.', [hr]));
      exit;
    end;

	  // Create an IDeckLinkIterator object to enumerate all DeckLink cards in the system
    hr := CoCreateInstance(CLASS_CDeckLinkIterator, nil, CLSCTX_ALL, IID_IDeckLinkIterator,  DeckLinkIterator);
    if hr <> S_OK then
    begin
      // Uninitalize COM on this thread
      CoUninitialize();
      writeln(format('A DeckLink iterator could not be created.  The DeckLink drivers may not be installed. Result = %08x.', [hr]));
      exit;
    end;

	  // Enumerate all cards in this system
    while (deckLinkIterator.Next(deckLink) = S_OK)  do
    begin
      // Increment the total number of DeckLink cards found
      inc(numDevices);
      if numDevices>1 then
        writeln('');

      // Print the model name of the DeckLink card
      hr:=deckLink.GetModelName(deviceNameBSTR);
      if hr = S_OK then
      begin
        writeln(format('Found Blackmagic device: %s',[deviceNameBSTR]));
        attributeResult:=deckLink.QueryInterface(IID_IDeckLinkAttributes,deckLinkAttributes);
        if attributeResult <> S_OK then
        begin
          writeln('Could not obtain the IDeckLinkAttributes interface');
        end else
        begin
          attributeResult := deckLinkAttributes.GetFlag(BMDDeckLinkHasSerialPort, serialSupported);	// are serial ports supported on device?
          if (attributeResult =S_OK and serialSupported) then
          begin
            attributeResult := deckLinkAttributes.GetString(BMDDeckLinkSerialPortDeviceName, serialNameBSTR);	// get serial port name
            if (attributeResult = S_OK) then
            begin
              writeln(format('Serial port name: %s',[serialNameBSTR]));
              if (openSerialDevice(serialNameBSTR)= TRUE)then		// open serial port
              begin
                writeln('Device opened');

                playCommand();									// Play deck,

                writeln('Delay 3 seconds');
                Sleep(3000);

                timeCodeCommand();								// DisplayTC

                writeln('Delay 3 seconds');
                Sleep(3000);

                stopCommand();									// Stop deck

                closeSerialDevice();							// close serial port
              end else
                writeln('Device open fail');
            end	else
              writeln('Unable to get serial port device name');
          end else
            writeln('Serial port not supported');

          // Release the attribute interface
          if assigned(deckLinkAttributes) then   deckLinkAttributes:=nil;

        end;
      end;
      if assigned(deckLink) then   deckLink:=nil;
    end;

    // release the iterator
    if assigned(deckLinkIterator) then   deckLinkIterator:=nil;

    // Uninitalize COM on this thread
    CoUninitialize();

	  // If no DeckLink cards were found in the system, inform the users
	  if (numDevices = 0) then
		  writeln('No Blackmagic Design devices were found.');
    writeln('');
    writeln('Press ENTER to exit');
    ReadLN;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
