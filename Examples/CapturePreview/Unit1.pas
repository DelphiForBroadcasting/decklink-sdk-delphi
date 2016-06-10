unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, System.SyncObjs, System.UITypes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Winapi.ActiveX,  Winapi.DirectShow9, DeckLinkAPI_TLB_10_3_1, DeckLinkDevice, PreviewWindow,
  Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    m_startStopButton: TButton;
    m_vitcTcF1: TLabel;
    m_vitcUbF1: TLabel;
    m_vitcTcF2: TLabel;
    m_vitcUbF2: TLabel;
    m_rp188Vitc1Tc: TLabel;
    m_rp188Vitc1Ub: TLabel;
    m_rp188Vitc2Tc: TLabel;
    m_rp188Vitc2Ub: TLabel;
    m_rp188LtcTc: TLabel;
    m_rp188LtcUb: TLabel;
    m_deviceListCombo: TComboBox;
    m_modeListCombo: TComboBox;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    m_applyDetectedInputModeCheckbox: TCheckBox;
    m_invalidInputLabel: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    m_previewBox: TPanel;
    procedure m_startStopButtonClick(Sender: TObject);
    procedure bmdDeviceDiscoveryDeviceChange(const status: _bmdDiscoverStatus; const deckLinkDevice: IDeckLink);
    procedure FormCreate(Sender: TObject);
    procedure m_deviceListComboChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RefreshVideoModeList();
    procedure EnableInterface(enabled: boolean);
    procedure StopCapture();
    procedure StartCapture();
    procedure AddDevice(deckLink: IDeckLink);
    procedure RemoveDevice(deckLink: IDeckLink);
    procedure OnRefreshInputStreamData(var AMessage : TMessageEx); message WM_REFRESH_INPUT_STREAM_DATA_MESSAGE;
    procedure OnErrorRestartingCapture(var AMessage : TMessage); message WM_ERROR_RESTARTING_CAPTURE_MESSAGE;
    procedure OnSelectVideoMode(var AMessage : TMessage); message WM_SELECT_VIDEO_MODE_MESSAGE;
    procedure FormDestroy(Sender: TObject);
  private

  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  m_deckLinkDiscovery : TDeckLinkDeviceDiscovery;
  m_selectedDevice    : TDeckLinkInputDevice;
  m_previewWindow     : TPreviewWindow;
  m_ancillaryData     : TAncillaryDataStruct;
  m_critSec           :  TCriticalSection;
implementation

{$R *.dfm}



procedure TForm1.OnRefreshInputStreamData(var AMessage : TMessageEx);
begin
	// Update the UI under protection of critsec object
	m_critSec.Acquire;
  try
    m_ancillaryData :=  AMessage.ads;
    m_vitcTcF1.Caption := m_ancillaryData.vitcF1Timecode;
    m_vitcUbF1.Caption := m_ancillaryData.vitcF1UserBits;
    m_vitcTcF2.Caption := m_ancillaryData.vitcF2Timecode;
    m_vitcUbF2.Caption := m_ancillaryData.vitcF2UserBits;

    m_rp188Vitc1Tc.Caption := m_ancillaryData.rp188vitc1Timecode;
    m_rp188Vitc1Ub.Caption := m_ancillaryData.rp188vitc1UserBits;
    m_rp188Vitc2Tc.Caption := m_ancillaryData.rp188vitc2Timecode;
    m_rp188Vitc2Ub.Caption := m_ancillaryData.rp188vitc2UserBits;
    m_rp188LtcTc.Caption := m_ancillaryData.rp188ltcTimecode;
    m_rp188LtcUb.Caption := m_ancillaryData.rp188ltcUserBits;
  finally
    m_critSec.Release;
  end;


	m_invalidInputLabel.Visible := AMessage.NoInputSource;
end;

procedure TForm1.OnErrorRestartingCapture(var AMessage : TMessage);
begin
	// A change in the input video mode was detected, but the capture could not be restarted.
	StopCapture();
  MessageDlg('This application was unable to apply the detected input video mode.', mtError , [mbOk], 0);
end;

procedure TForm1.OnSelectVideoMode(var AMessage : TMessage);
begin
	// A new video mode was selected by the user
	m_modeListCombo.ItemIndex := AMessage.WParam;
end;

procedure TForm1.bmdDeviceDiscoveryDeviceChange(const status: _bmdDiscoverStatus; const deckLinkDevice: IDeckLink);
begin
  case status of
    BMD_ADD_DEVICE      :
    begin
      // A new device has been connected
      AddDevice(deckLinkDevice);
    end;
    BMD_REMOVE_DEVICE   :
    begin
    	// An existing device has been disconnected
      RemoveDevice(deckLinkDevice);
    end;
  end;
end;

procedure TForm1.m_deviceListComboChange(Sender: TObject);
var
  selectedDeviceIndex : integer;
begin

	selectedDeviceIndex := m_deviceListCombo.ItemIndex;
	if (selectedDeviceIndex < 0) then
		exit;

	m_selectedDevice := TDeckLinkinputDevice(m_deviceListCombo.Items.Objects[selectedDeviceIndex]);

	// Update the video mode popup menu
	RefreshVideoModeList();

	// Enable the interface
	EnableInterface(true);

	if m_selectedDevice.SupportsFormatDetection then
		m_applyDetectedInputModeCheckbox.Checked := true
  else
    m_applyDetectedInputModeCheckbox.Checked := false;
end;

procedure TForm1.m_startStopButtonClick(Sender: TObject);
begin
	if not assigned(m_selectedDevice) then
		exit;

	if m_selectedDevice.IsCapturing then
		StopCapture()
	else
		StartCapture();
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	// Stop the capture
	StopCapture();

	// Release all DeckLinkDevice instances
	while(m_deviceListCombo.ItemIndex > 0) do
	begin
		TDeckLinkinputDevice(m_deviceListCombo.Items.Objects[0]).Destroy;
		m_deviceListCombo.Items.Delete(0);
	end;


  if assigned(m_previewWindow) then
    m_previewWindow.Destroy;

 	// Release DeckLink discovery instance
	if assigned(m_deckLinkDiscovery) then
	begin
	 	m_deckLinkDiscovery.Disable();
		m_deckLinkDiscovery.Destroy;
	end;


end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  coinitialize(nil);

  m_critSec := TCriticalSection.Create;

  m_deckLinkDiscovery := nil;
  m_selectedDevice := nil;

	// Empty popup menus
	m_deviceListCombo.Clear;
	m_modeListCombo.Clear;;

	// Disable the interface
	m_startStopButton.Enabled := false;
	EnableInterface(false);

	// Create and initialise preview and DeckLink device discovery objects
	m_previewWindow := TPreviewWindow.Create;
	if (m_previewWindow.init(m_previewBox) = false) then
	begin
		 MessageDlg('This application was unable to initialise the preview window', mtError , [mbOk], 0);
    exit;
  end;


  m_deckLinkDiscovery := TDeckLinkDeviceDiscovery.Create;
  m_deckLinkDiscovery.OnDeviceChange := bmdDeviceDiscoveryDeviceChange;
  if not m_deckLinkDiscovery.Enable then
		MessageDlg('Please install the Blackmagic Desktop Video drivers to use the features of this application.', mtError , [mbOk], 0);

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  m_critSec.Free
end;

procedure TForm1.RefreshVideoModeList();
var
  modeNames : TArray<string>;
  modeIndex : integer;
begin
	// Clear the menu
	m_modeListCombo.clear;

	// Get the mode names
	m_selectedDevice.GetDisplayModeNames(modeNames);

	// Add them to the menu
  for modeIndex := 0 to length(modeNames)-1 do
		m_modeListCombo.Items.Add(modeNames[modeIndex]);

	m_modeListCombo.ItemIndex:=0;

end;

procedure TForm1.StartCapture();
var
  applyDetectedInputMode : boolean;
begin
	applyDetectedInputMode := m_applyDetectedInputModeCheckbox.Checked;

	if (assigned(m_selectedDevice) and 	m_selectedDevice.StartCapture(m_modeListCombo.ItemIndex, m_previewWindow, applyDetectedInputMode)) then
 	begin
		// Update UI
		m_startStopButton.Caption := 'Stop capture';
		EnableInterface(false);
 	end;
end;

procedure TForm1.StopCapture();
begin
	if assigned(m_selectedDevice) then
		m_selectedDevice.StopCapture();

	// Update UI
  m_startStopButton.Caption := 'Start capture';
	EnableInterface(true);
	m_invalidInputLabel.Visible := false;
end;

procedure TForm1.EnableInterface(enabled: boolean);
begin
	m_deviceListCombo.Enabled := enabled;
	m_modeListCombo.Enabled := enabled;

	if (enabled) then
	begin
		if (assigned(m_selectedDevice) and m_selectedDevice.SupportsFormatDetection)  then
		begin
			m_applyDetectedInputModeCheckbox.Enabled := true;
		end else
		begin
			m_applyDetectedInputModeCheckbox.Enabled := false;
			m_applyDetectedInputModeCheckbox.Checked := false;
		end;
	end	else
		m_applyDetectedInputModeCheckbox.Enabled := false;
end;

procedure TForm1.AddDevice(deckLink: IDeckLink);
var
  deviceIndex : integer;
  newDevice   : TDeckLinkInputDevice;
begin

	newDevice := TDeckLinkInputDevice.Create(self, deckLink);

	// Initialise new DeckLinkDevice object
	if not newDevice.Init then
	begin
		newDevice.Destroy;
		exit;
	end;

	// Add this DeckLink device to the device list
	deviceIndex := m_deviceListCombo.Items.AddObject(newDevice.GetDeviceName, TObject(newDevice));
	if (deviceIndex < 0) then
		exit;

	if (m_deviceListCombo.Items.Count = 1) then
	begin
		// We have added our first item, refresh and enable UI
		m_deviceListCombo.ItemIndex:=0;
		m_deviceListComboChange(self);

		m_startStopButton.Enabled := true;
		EnableInterface(true);
	end;
end;

procedure TForm1.RemoveDevice(deckLink: IDeckLink);
var
  deviceIndex     : integer;
  deviceToRemove  : TDeckLinkInputDevice;
begin
  deviceIndex := -1;
  deviceToRemove  := nil;


	// Find the combo box entry to remove (there may be multiple entries with the same name, but each
	// will have a different data pointer).
	for deviceIndex := 0 to m_deviceListCombo.Items.Count-1 do
	begin
		deviceToRemove := TDeckLinkInputDevice(m_deviceListCombo.Items.Objects[deviceIndex]);
		if (deviceToRemove.DeckLinkInstance = deckLink) then
			break;
	end;

	if not assigned(deviceToRemove) then
		exit;;

	// Stop capturing before removal
	if deviceToRemove.IsCapturing then
		deviceToRemove.StopCapture();

	// Remove device from list
  m_deviceListCombo.Items.Delete(deviceIndex);

	// Refresh UI
	m_startStopButton.Caption := 'Start capture';

	// Check how many devices are left
	if (m_deviceListCombo.ItemIndex = 0) then
	begin
		// We have removed the last device, disable the interface.
		m_startStopButton.Enabled := false;
		EnableInterface(false);
		m_selectedDevice := nil;
	end
	else if (m_selectedDevice = deviceToRemove) then
	begin
		// The device that was removed was the one selected in the UI.
		// Select the first available device in the list and reset the UI.
		m_deviceListCombo.ItemIndex := 0;
		m_deviceListComboChange(self);

		m_startStopButton.Enabled := true;
		m_invalidInputLabel.Visible := false;
	end;

	// Release DeckLinkDevice instance
	//deviceToRemove->Release();
end;

end.
