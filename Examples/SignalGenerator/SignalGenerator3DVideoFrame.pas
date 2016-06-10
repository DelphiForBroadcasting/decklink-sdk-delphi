unit SignalGenerator3DVideoFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Winapi.ActiveX, Winapi.DirectShow9, DeckLinkAPI_TLB_10_4_1;


type
  TSignalGenerator3DVideoFrame = class(TInterfacedObject, IDeckLinkVideoFrame, IDeckLinkVideoFrame3DExtensions)
  protected
    m_frameLeft   : IDeckLinkMutableVideoFrame;
	  m_frameRight  : IDeckLinkMutableVideoFrame;
    m_refCount    : integer;
  private
    { Private declarations }
  public
    constructor Create(left: IDeckLinkMutableVideoFrame; right : IDeckLinkMutableVideoFrame = nil);
    destructor Destroy; override;

    // IUnknown methods
    function QueryInterface(const IID: TGUID; out Obj): HRESULT; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

	  // IDeckLinkVideoFrame methods
    function GetWidth: Integer; stdcall;
    function GetHeight: Integer; stdcall;
    function GetRowBytes: Integer; stdcall;
    function GetPixelFormat: _BMDPixelFormat; stdcall;
    function GetFlags: _BMDFrameFlags; stdcall;
    function GetBytes(out buffer: Pointer): HResult; stdcall;
    function GetTimecode(format: _BMDTimecodeFormat; out timecode: IDeckLinkTimecode): HResult; stdcall;
    function GetAncillaryData(out ancillary: IDeckLinkVideoFrameAncillary): HResult; stdcall;

	  // IDeckLinkVideoFrame3DExtensions methods
    function Get3DPackingFormat: _BMDVideo3DPackingFormat; stdcall;
    function GetFrameForRightEye(out rightEyeFrame: IDeckLinkVideoFrame): HResult; stdcall;
  end;



implementation


function TSignalGenerator3DVideoFrame._AddRef: Integer;
begin
 Result := InterlockedIncrement(m_RefCount);
end;

function TSignalGenerator3DVideoFrame._Release: Integer;
var
  newRefValue : integer;
begin
  newRefValue:=InterlockedDecrement(m_RefCount);
  if newRefValue=0 then
  begin
    //Destroy;
    free;
    Result := 0;
  end;
  result:=newRefValue;
end;

function TSignalGenerator3DVideoFrame.QueryInterface(const IID: TGUID; out Obj): HRESULT;
const
  IID_IUnknown : TGUID = '{00000000-0000-0000-C000-000000000046}';
begin
  Result := E_NOINTERFACE;
  Pointer(Obj):=nil;
  if IsEqualGUID(IID, IID_IUnknown)then
  begin
    Pointer(Obj) := Self;
    _addRef;
    Result := S_OK;
  end else
  if IsEqualGUID(IID, IDeckLinkInputCallback)then
  begin
    //GetInterface(IDeckLinkInputCallback, obj);
    Pointer(Obj) := Pointer(IDeckLinkVideoFrame(self));
    _addRef;
    Result := S_OK;
  end;
end;

constructor TSignalGenerator3DVideoFrame.Create(left: IDeckLinkMutableVideoFrame; right : IDeckLinkMutableVideoFrame = nil);
begin
  m_frameLeft:=left;
  m_frameRight:=right;
  m_refCount:=1;

	if not assigned(m_frameLeft) then
		 raise Exception.Create('at minimum a left frame must be defined');

	m_frameLeft._AddRef();
	if assigned(m_frameRight) then
		m_frameRight._AddRef();
end;

destructor TSignalGenerator3DVideoFrame.Destroy;
begin

  if assigned(m_frameLeft) then
    m_frameLeft._Release;
	m_frameLeft := nil;

  if assigned(m_frameRight) then
    m_frameRight._Release;
	m_frameRight := nil;

  inherited;
end;

function TSignalGenerator3DVideoFrame.GetWidth(): integer;
begin
	result := m_frameLeft.GetWidth();
end;

function TSignalGenerator3DVideoFrame.GetHeight(): integer;
begin
	result := m_frameLeft.GetHeight();
end;

function TSignalGenerator3DVideoFrame.GetRowBytes(): integer;
begin
	result := m_frameLeft.GetRowBytes();
end;

function TSignalGenerator3DVideoFrame.GetPixelFormat(): _BMDPixelFormat;
begin
	result := m_frameLeft.GetPixelFormat();
end;

function TSignalGenerator3DVideoFrame.GetFlags(): _BMDFrameFlags;
begin
	result := m_frameLeft.GetFlags();
end;

function TSignalGenerator3DVideoFrame.GetBytes(out buffer: Pointer): HResult;
begin
	result := m_frameLeft.GetBytes(buffer);
end;

function TSignalGenerator3DVideoFrame.GetTimecode(format: _BMDTimecodeFormat; out timecode: IDeckLinkTimecode): HResult;
begin
	result := m_frameLeft.GetTimecode(format, timecode);
end;

function TSignalGenerator3DVideoFrame.GetAncillaryData(out ancillary: IDeckLinkVideoFrameAncillary): HResult;
begin
	result := m_frameLeft.GetAncillaryData(ancillary);
end;

function TSignalGenerator3DVideoFrame.Get3DPackingFormat: _BMDVideo3DPackingFormat;
begin
	result := bmdVideo3DPackingLeftOnly;
end;

function TSignalGenerator3DVideoFrame.GetFrameForRightEye(out rightEyeFrame: IDeckLinkVideoFrame): HResult;
begin
	if assigned(m_frameRight) then
		result := m_frameRight.QueryInterface(IID_IDeckLinkVideoFrame, rightEyeFrame)
	else
		result := S_FALSE;
end;


end.
