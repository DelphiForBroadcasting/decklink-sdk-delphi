unit PreviewWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, System.SyncObjs, System.Generics.Collections,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Winapi.ActiveX, Winapi.DirectShow9,
  DeckLinkAPI;


type
  TPreviewWindow = class(TInterfacedObject, IDeckLinkScreenPreviewCallback)
  private
    m_refCount                  : integer;

	  m_deckLinkScreenPreviewHelper : IDeckLinkGLScreenPreviewHelper;
    m_previewBox          : TPanel;
    m_previewBoxDC        : HDC;
	  m_openGLctx           : HGLRC;


	  function initOpenGL(): boolean;

  public
    constructor Create();
    destructor Destroy; override;

    function _Release: Integer; stdcall;
    function _AddRef: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HResult;  stdcall;

	  // Initialise members and OpenGL rendering context
	  function init(previewBox : TPanel): boolean;

	  // IDeckLinkScreenPreviewCallback methods
    function DrawFrame(const theFrame: IDeckLinkVideoFrame): HResult; stdcall;

  end;


implementation

(* TDeckLinkDevice *)
constructor TPreviewWindow.Create();
begin
  m_deckLinkScreenPreviewHelper := nil;
  m_refCount:=1;
  m_previewBox := nil;
  m_previewBoxDC := 0;
  m_openGLctx := 0;
end;

destructor TPreviewWindow.Destroy;
begin
  if assigned(m_deckLinkScreenPreviewHelper) then  m_deckLinkScreenPreviewHelper := nil;

	if (m_openGLctx <> 0) then
	begin
		wglDeleteContext(m_openGLctx);
		m_openGLctx := 0;
	end;

	if (m_previewBoxDC <> 0) then
	begin
		ReleaseDC(0, m_previewBoxDC);
		m_previewBoxDC := 0
	end;

  inherited;
end;

function TPreviewWindow.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TPreviewWindow._AddRef: Integer;
begin
  result := InterlockedIncrement(m_refCount);
end;

function TPreviewWindow._Release: Integer;
var
  newRefValue : integer;
begin
	newRefValue := InterlockedDecrement(m_refCount);
	if (newRefValue = 0) then
	begin
		result := 0;
    exit;
	end;
	result := newRefValue;
end;

function TPreviewWindow.Init(previewBox : TPanel): boolean;
begin    
  result := false;

	m_previewBox := previewBox;

	// Create the DeckLink screen preview helper
	if (CoCreateInstance(CLASS_CDeckLinkGLScreenPreviewHelper, nil, CLSCTX_ALL, IID_IDeckLinkGLScreenPreviewHelper, m_deckLinkScreenPreviewHelper) <> S_OK) then
		exit;

	// Initialise OpenGL
	result := initOpenGL();
end;


function TPreviewWindow.initOpenGL(): boolean;
var
	pixelFormatDesc : TPixelFormatDescriptor;
	pixelFormat     : integer;
begin

	//
	// Here, we create an OpenGL context attached to the screen preview box
	// so we can use it later on when we need to draw preview frames.
  result := false;
	// Get the preview box drawing context
	m_previewBoxDC := GetDC(m_previewBox.Handle);
	if (m_previewBoxDC = 0) then
		exit(false);

	// Ensure the preview box DC uses ARGB pixel format

	fillchar(pixelFormatDesc, sizeof(pixelFormatDesc), #0);
	pixelFormatDesc.nSize := sizeof(pixelFormatDesc);
	pixelFormatDesc.nVersion := 1;
	pixelFormatDesc.dwFlags := PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL;
	pixelFormatDesc.iPixelType := PFD_TYPE_RGBA;
	pixelFormatDesc.cColorBits := 32;
	pixelFormatDesc.cDepthBits := 16;
	pixelFormatDesc.cAlphaBits := 8;
	pixelFormatDesc.iLayerType := PFD_MAIN_PLANE;
	pixelFormat := ChoosePixelFormat(m_previewBoxDC, @pixelFormatDesc);
	if not SetPixelFormat(m_previewBoxDC, pixelFormat, @pixelFormatDesc) then
		exit(false);

	// Create OpenGL rendering context
	m_openGLctx := wglCreateContext(m_previewBoxDC);
	if (m_openGLctx = 0) then
		exit(false);

	// Make the new OpenGL context the current rendering context so
	// we can initialise the DeckLink preview helper
	if not wglMakeCurrent(m_previewBoxDC, m_openGLctx) then
		exit(false);

	if (m_deckLinkScreenPreviewHelper.InitializeGL() = S_OK) then
		result := true;

	// Reset the OpenGL rendering context
	wglMakeCurrent(0, 0);

end;


function TPreviewWindow.DrawFrame(const theFrame: IDeckLinkVideoFrame): HResult;
begin
	// Make sure we are initialised
	if ( (not assigned(m_deckLinkScreenPreviewHelper)) or (m_previewBoxDC = 0) or (m_openGLctx = 0)) then
  begin
		exit(E_FAIL);
  end;

	// First, pass the frame to the DeckLink screen preview helper
	m_deckLinkScreenPreviewHelper.SetFrame(theFrame);

	// Then set the OpenGL rendering context to the one we created before
	wglMakeCurrent(m_previewBoxDC, m_openGLctx);

	// and let the helper take care of the drawing
	m_deckLinkScreenPreviewHelper.PaintGL();

	// Last, reset the OpenGL rendering context
	wglMakeCurrent(0, 0);

  RESULT:=S_OK;
end;


end.
