unit DeckLinkAPI_TLB_9_8;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// $Rev: 52393 $
// File generated on 23.01.2014 17:10:32 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Program Files (x86)\Blackmagic Design\Blackmagic Desktop Video\DeckLinkAPI.dll (1)
// LIBID: {D864517A-EDD5-466D-867D-C819F1C052BB}
// LCID: 0
// Helpfile: 
// HelpString: DeckLink API Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleServer, Winapi.ActiveX;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  DeckLinkAPIMajorVersion = 1;
  DeckLinkAPIMinorVersion = 0;

  LIBID_DeckLinkAPI: TGUID = '{D864517A-EDD5-466D-867D-C819F1C052BB}';

  IID_IDeckLinkTimecode: TGUID = '{BC6CFBD3-8317-4325-AC1C-1216391E9340}';
  IID_IDeckLinkDisplayModeIterator: TGUID = '{9C88499F-F601-4021-B80B-032E4EB41C35}';
  IID_IDeckLinkDisplayMode: TGUID = '{3EB2C1AB-0A3D-4523-A3AD-F40D7FB14E78}';
  IID_IDeckLink: TGUID = '{C418FBDD-0587-48ED-8FE5-640F0A14AF91}';
  IID_IDeckLinkConfiguration: TGUID = '{C679A35B-610C-4D09-B748-1D0478100FC0}';
  IID_IDeckLinkDeckControlStatusCallback: TGUID = '{53436FFB-B434-4906-BADC-AE3060FFE8EF}';
  IID_IDeckLinkDeckControl: TGUID = '{8E1C3ACE-19C7-4E00-8B92-D80431D958BE}';
  IID_IBMDStreamingDeviceNotificationCallback: TGUID = '{F9531D64-3305-4B29-A387-7F74BB0D0E84}';
  IID_IBMDStreamingH264InputCallback: TGUID = '{823C475F-55AE-46F9-890C-537CC5CEDCCA}';
  IID_IBMDStreamingH264NALPacket: TGUID = '{E260E955-14BE-4395-9775-9F02CC0A9D89}';
  IID_IBMDStreamingAudioPacket: TGUID = '{D9EB5902-1AD2-43F4-9E2C-3CFA50B5EE19}';
  IID_IBMDStreamingMPEG2TSPacket: TGUID = '{91810D1C-4FB3-4AAA-AE56-FA301D3DFA4C}';
  IID_IBMDStreamingDiscovery: TGUID = '{2C837444-F989-4D87-901A-47C8A36D096D}';
  IID_IBMDStreamingVideoEncodingMode: TGUID = '{1AB8035B-CD13-458D-B6DF-5E8F7C2141D9}';
  IID_IBMDStreamingMutableVideoEncodingMode: TGUID = '{19BF7D90-1E0A-400D-B2C6-FFC4E78AD49D}';
  IID_IBMDStreamingVideoEncodingModePresetIterator: TGUID = '{7AC731A3-C950-4AD0-804A-8377AA51C6C4}';
  IID_IBMDStreamingDeviceInput: TGUID = '{24B6B6EC-1727-44BB-9818-34FF086ACF98}';
  IID_IBMDStreamingH264NALParser: TGUID = '{5867F18C-5BFA-4CCC-B2A7-9DFD140417D2}';
  CLASS_CBMDStreamingDiscovery: TGUID = '{0CAA31F6-8A26-40B0-86A4-BF58DCCA710C}';
  CLASS_CBMDStreamingH264NALParser: TGUID = '{7753EFBD-951C-407C-97A5-23C737B73B52}';
  IID_IDeckLinkVideoOutputCallback: TGUID = '{20AA5225-1958-47CB-820B-80A8D521A6EE}';
  IID_IDeckLinkVideoFrame: TGUID = '{3F716FE0-F023-4111-BE5D-EF4414C05B17}';
  IID_IDeckLinkVideoFrameAncillary: TGUID = '{732E723C-D1A4-4E29-9E8E-4A88797A0004}';
  IID_IDeckLinkInputCallback: TGUID = '{DD04E5EC-7415-42AB-AE4A-E80C4DFC044A}';
  IID_IDeckLinkVideoInputFrame: TGUID = '{05CFE374-537C-4094-9A57-680525118F44}';
  IID_IDeckLinkAudioInputPacket: TGUID = '{E43D5870-2894-11DE-8C30-0800200C9A66}';
  IID_IDeckLinkMemoryAllocator: TGUID = '{B36EB6E7-9D29-4AA8-92EF-843B87A289E8}';
  IID_IDeckLinkAudioOutputCallback: TGUID = '{403C681B-7F46-4A12-B993-2BB127084EE6}';
  IID_IDeckLinkIterator: TGUID = '{50FB36CD-3063-4B73-BDBB-958087F2D8BA}';
  IID_IDeckLinkAPIInformation: TGUID = '{7BEA3C68-730D-4322-AF34-8A7152B532A4}';
  IID_IDeckLinkOutput: TGUID = '{A3EF0963-0862-44ED-92A9-EE89ABF431C7}';
  IID_IDeckLinkScreenPreviewCallback: TGUID = '{B1D3F49A-85FE-4C5D-95C8-0B5D5DCCD438}';
  IID_IDeckLinkMutableVideoFrame: TGUID = '{69E2639F-40DA-4E19-B6F2-20ACE815C390}';
  IID_IDeckLinkInput: TGUID = '{AF22762B-DFAC-4846-AA79-FA8883560995}';
  IID_IDeckLinkVideoFrame3DExtensions: TGUID = '{DA0F7E4A-EDC7-48A8-9CDD-2DB51C729CD7}';
  IID_IDeckLinkGLScreenPreviewHelper: TGUID = '{504E2209-CAC7-4C1A-9FB4-C5BB6274D22F}';
  IID_IDeckLinkDX9ScreenPreviewHelper: TGUID = '{2094B522-D1A1-40C0-9AC7-1C012218EF02}';
  IID_IDeckLinkNotificationCallback: TGUID = '{B002A1EC-070D-4288-8289-BD5D36E5FF0D}';
  IID_IDeckLinkNotification: TGUID = '{0A1FB207-E215-441B-9B19-6FA1575946C5}';
  IID_IDeckLinkAttributes: TGUID = '{ABC11843-D966-44CB-96E2-A1CB5D3135C4}';
  IID_IDeckLinkKeyer: TGUID = '{89AFCAF5-65F8-421E-98F7-96FE5F5BFBA3}';
  IID_IDeckLinkVideoConversion: TGUID = '{3BBCB8A2-DA2C-42D9-B5D8-88083644E99A}';
  CLASS_CDeckLinkIterator: TGUID = '{1F2E109A-8F4F-49E4-9203-135595CB6FA5}';
  CLASS_CDeckLinkAPIInformation: TGUID = '{263CA19F-ED09-482E-9F9D-84005783A237}';
  CLASS_CDeckLinkGLScreenPreviewHelper: TGUID = '{F63E77C7-B655-4A4A-9AD0-3CA85D394343}';
  CLASS_CDeckLinkDX9ScreenPreviewHelper: TGUID = '{CC010023-E01D-4525-9D59-80C8AB3DC7A0}';
  CLASS_CDeckLinkVideoConversion: TGUID = '{7DBBBB11-5B7B-467D-AEA4-CEA468FD368C}';
  IID_IDeckLinkInput_v9_2: TGUID = '{6D40EF78-28B9-4E21-990D-95BB7750A04F}';
  IID_IDeckLinkDeckControlStatusCallback_v8_1: TGUID = '{E5F693C1-4283-4716-B18F-C1431521955B}';
  IID_IDeckLinkDeckControl_v8_1: TGUID = '{522A9E39-0F3C-4742-94EE-D80DE335DA1D}';
  IID_IDeckLink_v8_0: TGUID = '{62BFF75D-6569-4E55-8D4D-66AA03829ABC}';
  IID_IDeckLinkIterator_v8_0: TGUID = '{74E936FC-CC28-4A67-81A0-1E94E52D4E69}';
  CLASS_CDeckLinkIterator_v8_0: TGUID = '{D9EDA3B3-2887-41FA-B724-017CF1EB1D37}';
  IID_IDeckLinkDeckControl_v7_9: TGUID = '{A4D81043-0619-42B7-8ED6-602D29041DF7}';
  IID_IDeckLinkDisplayModeIterator_v7_6: TGUID = '{455D741F-1779-4800-86F5-0B5D13D79751}';
  IID_IDeckLinkDisplayMode_v7_6: TGUID = '{87451E84-2B7E-439E-A629-4393EA4A8550}';
  IID_IDeckLinkOutput_v7_6: TGUID = '{29228142-EB8C-4141-A621-F74026450955}';
  IID_IDeckLinkScreenPreviewCallback_v7_6: TGUID = '{373F499D-4B4D-4518-AD22-6354E5A5825E}';
  IID_IDeckLinkVideoFrame_v7_6: TGUID = '{A8D8238E-6B18-4196-99E1-5AF717B83D32}';
  IID_IDeckLinkTimecode_v7_6: TGUID = '{EFB9BCA6-A521-44F7-BD69-2332F24D9EE6}';
  IID_IDeckLinkMutableVideoFrame_v7_6: TGUID = '{46FCEE00-B4E6-43D0-91C0-023A7FCEB34F}';
  IID_IDeckLinkVideoOutputCallback_v7_6: TGUID = '{E763A626-4A3C-49D1-BF13-E7AD3692AE52}';
  IID_IDeckLinkInput_v7_6: TGUID = '{300C135A-9F43-48E2-9906-6D7911D93CF1}';
  IID_IDeckLinkInputCallback_v7_6: TGUID = '{31D28EE7-88B6-4CB1-897A-CDBF79A26414}';
  IID_IDeckLinkVideoInputFrame_v7_6: TGUID = '{9A74FA41-AE9F-47AC-8CF4-01F42DD59965}';
  IID_IDeckLinkGLScreenPreviewHelper_v7_6: TGUID = '{BA575CD9-A15E-497B-B2C2-F9AFE7BE4EBA}';
  IID_IDeckLinkVideoConversion_v7_6: TGUID = '{3EB504C9-F97D-40FE-A158-D407D48CB53B}';
  IID_IDeckLinkConfiguration_v7_6: TGUID = '{B8EAD569-B764-47F0-A73F-AE40DF6CBF10}';
  CLASS_CDeckLinkGLScreenPreviewHelper_v7_6: TGUID = '{D398CEE7-4434-4CA3-9BA6-5AE34556B905}';
  CLASS_CDeckLinkVideoConversion_v7_6: TGUID = '{FFA84F77-73BE-4FB7-B03E-B5E44B9F759B}';
  IID_IDeckLinkInputCallback_v7_3: TGUID = '{FD6F311D-4D00-444B-9ED4-1F25B5730AD0}';
  IID_IDeckLinkVideoInputFrame_v7_3: TGUID = '{CF317790-2894-11DE-8C30-0800200C9A66}';
  IID_IDeckLinkOutput_v7_3: TGUID = '{271C65E3-C323-4344-A30F-D908BCB20AA3}';
  IID_IDeckLinkInput_v7_3: TGUID = '{4973F012-9925-458C-871C-18774CDBBECB}';
  IID_IDeckLinkDisplayModeIterator_v7_1: TGUID = '{B28131B6-59AC-4857-B5AC-CD75D5883E2F}';
  IID_IDeckLinkDisplayMode_v7_1: TGUID = '{AF0CD6D5-8376-435E-8433-54F9DD530AC3}';
  IID_IDeckLinkVideoFrame_v7_1: TGUID = '{333F3A10-8C2D-43CF-B79D-46560FEEA1CE}';
  IID_IDeckLinkVideoInputFrame_v7_1: TGUID = '{C8B41D95-8848-40EE-9B37-6E3417FB114B}';
  IID_IDeckLinkAudioInputPacket_v7_1: TGUID = '{C86DE4F6-A29F-42E3-AB3A-1363E29F0788}';
  IID_IDeckLinkVideoOutputCallback_v7_1: TGUID = '{EBD01AFA-E4B0-49C6-A01D-EDB9D1B55FD9}';
  IID_IDeckLinkInputCallback_v7_1: TGUID = '{7F94F328-5ED4-4E9F-9729-76A86BDC99CC}';
  IID_IDeckLinkOutput_v7_1: TGUID = '{AE5B3E9B-4E1E-4535-B6E8-480FF52F6CE5}';
  IID_IDeckLinkInput_v7_1: TGUID = '{2B54EDEF-5B32-429F-BA11-BB990596EACD}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum _BMDTimecodeFlags
type
  _BMDTimecodeFlags = TOleEnum;
const
  bmdTimecodeFlagDefault = $00000000;
  bmdTimecodeIsDropFrame = $00000001;

// Constants for enum _BMDVideoConnection
type
  _BMDVideoConnection = TOleEnum;
const
  bmdVideoConnectionSDI = $00000001;
  bmdVideoConnectionHDMI = $00000002;
  bmdVideoConnectionOpticalSDI = $00000004;
  bmdVideoConnectionComponent = $00000008;
  bmdVideoConnectionComposite = $00000010;
  bmdVideoConnectionSVideo = $00000020;

// Constants for enum _BMDDisplayModeFlags
type
  _BMDDisplayModeFlags = TOleEnum;
const
  bmdDisplayModeSupports3D = $00000001;
  bmdDisplayModeColorspaceRec601 = $00000002;
  bmdDisplayModeColorspaceRec709 = $00000004;

// Constants for enum _BMDDisplayMode
type
  _BMDDisplayMode = TOleEnum;
const
  bmdModeNTSC = $6E747363;
  bmdModeNTSC2398 = $6E743233;
  bmdModePAL = $70616C20;
  bmdModeNTSCp = $6E747370;
  bmdModePALp = $70616C70;
  bmdModeHD1080p2398 = $32337073;
  bmdModeHD1080p24 = $32347073;
  bmdModeHD1080p25 = $48703235;
  bmdModeHD1080p2997 = $48703239;
  bmdModeHD1080p30 = $48703330;
  bmdModeHD1080i50 = $48693530;
  bmdModeHD1080i5994 = $48693539;
  bmdModeHD1080i6000 = $48693630;
  bmdModeHD1080p50 = $48703530;
  bmdModeHD1080p5994 = $48703539;
  bmdModeHD1080p6000 = $48703630;
  bmdModeHD720p50 = $68703530;
  bmdModeHD720p5994 = $68703539;
  bmdModeHD720p60 = $68703630;
  bmdMode2k2398 = $326B3233;
  bmdMode2k24 = $326B3234;
  bmdMode2k25 = $326B3235;
  bmdMode4K2160p2398 = $346B3233;
  bmdMode4K2160p24 = $346B3234;
  bmdMode4K2160p25 = $346B3235;
  bmdMode4K2160p2997 = $346B3239;
  bmdMode4K2160p30 = $346B3330;
  bmdMode4kDCI2398 = $34643233;
  bmdMode4kDCI24 = $34643234;
  bmdMode4kDCI25 = $34643235;
  bmdModeUnknown = $69756E6B;

// Constants for enum _BMDFieldDominance
type
  _BMDFieldDominance = TOleEnum;
const
  bmdUnknownFieldDominance = $00000000;
  bmdLowerFieldFirst = $6C6F7772;
  bmdUpperFieldFirst = $75707072;
  bmdProgressiveFrame = $70726F67;
  bmdProgressiveSegmentedFrame = $70736620;

// Constants for enum _BMDPixelFormat
type
  _BMDPixelFormat = TOleEnum;
const
  bmdFormat8BitYUV = $32767579;
  bmdFormat10BitYUV = $76323130;
  bmdFormat8BitARGB = $00000020;
  bmdFormat8BitBGRA = $42475241;
  bmdFormat10BitRGB = $72323130;
  bmdFormat10BitRGBXLE = $5231306C;
  bmdFormat10BitRGBX = $52313062;

// Constants for enum _BMDDeckLinkConfigurationID
type
  _BMDDeckLinkConfigurationID = TOleEnum;
const
  bmdDeckLinkConfigSwapSerialRxTx = $73737274;
  bmdDeckLinkConfigUse1080pNotPsF = $6670726F;
  bmdDeckLinkConfigHDMI3DPackingFormat = $33647066;
  bmdDeckLinkConfigBypass = $62797073;
  bmdDeckLinkConfigClockTimingAdjustment = $63746164;
  bmdDeckLinkConfigAnalogAudioConsumerLevels = $6161636C;
  bmdDeckLinkConfigFieldFlickerRemoval = $66646672;
  bmdDeckLinkConfigHD1080p24ToHD1080i5994Conversion = $746F3539;
  bmdDeckLinkConfig444SDIVideoOutput = $3434346F;
  bmdDeckLinkConfig3GBpsVideoOutput = $33676273;
  bmdDeckLinkConfigBlackVideoOutputDuringCapture = $62766F63;
  bmdDeckLinkConfigLowLatencyVideoOutput = $6C6C766F;
  bmdDeckLinkConfigVideoOutputConnection = $766F636E;
  bmdDeckLinkConfigVideoOutputConversionMode = $766F636D;
  bmdDeckLinkConfigAnalogVideoOutputFlags = $61766F66;
  bmdDeckLinkConfigReferenceInputTimingOffset = $676C6F74;
  bmdDeckLinkConfigVideoOutputIdleOperation = $766F696F;
  bmdDeckLinkConfigDefaultVideoOutputMode = $64766F6D;
  bmdDeckLinkConfigDefaultVideoOutputModeFlags = $64766F66;
  bmdDeckLinkConfigVideoOutputComponentLumaGain = $6F636C67;
  bmdDeckLinkConfigVideoOutputComponentChromaBlueGain = $6F636362;
  bmdDeckLinkConfigVideoOutputComponentChromaRedGain = $6F636372;
  bmdDeckLinkConfigVideoOutputCompositeLumaGain = $6F696C67;
  bmdDeckLinkConfigVideoOutputCompositeChromaGain = $6F696367;
  bmdDeckLinkConfigVideoOutputSVideoLumaGain = $6F736C67;
  bmdDeckLinkConfigVideoOutputSVideoChromaGain = $6F736367;
  bmdDeckLinkConfigVideoInputScanning = $76697363;
  bmdDeckLinkConfigUseDedicatedLTCInput = $646C7463;
  bmdDeckLinkConfigVideoInputConnection = $7669636E;
  bmdDeckLinkConfigAnalogVideoInputFlags = $61766966;
  bmdDeckLinkConfigVideoInputConversionMode = $7669636D;
  bmdDeckLinkConfig32PulldownSequenceInitialTimecodeFrame = $70646966;
  bmdDeckLinkConfigVANCSourceLine1Mapping = $76736C31;
  bmdDeckLinkConfigVANCSourceLine2Mapping = $76736C32;
  bmdDeckLinkConfigVANCSourceLine3Mapping = $76736C33;
  bmdDeckLinkConfigVideoInputComponentLumaGain = $69636C67;
  bmdDeckLinkConfigVideoInputComponentChromaBlueGain = $69636362;
  bmdDeckLinkConfigVideoInputComponentChromaRedGain = $69636372;
  bmdDeckLinkConfigVideoInputCompositeLumaGain = $69696C67;
  bmdDeckLinkConfigVideoInputCompositeChromaGain = $69696367;
  bmdDeckLinkConfigVideoInputSVideoLumaGain = $69736C67;
  bmdDeckLinkConfigVideoInputSVideoChromaGain = $69736367;
  bmdDeckLinkConfigAudioInputConnection = $6169636E;
  bmdDeckLinkConfigAnalogAudioInputScaleChannel1 = $61697331;
  bmdDeckLinkConfigAnalogAudioInputScaleChannel2 = $61697332;
  bmdDeckLinkConfigAnalogAudioInputScaleChannel3 = $61697333;
  bmdDeckLinkConfigAnalogAudioInputScaleChannel4 = $61697334;
  bmdDeckLinkConfigDigitalAudioInputScale = $64616973;
  bmdDeckLinkConfigAudioOutputAESAnalogSwitch = $616F6161;
  bmdDeckLinkConfigAnalogAudioOutputScaleChannel1 = $616F7331;
  bmdDeckLinkConfigAnalogAudioOutputScaleChannel2 = $616F7332;
  bmdDeckLinkConfigAnalogAudioOutputScaleChannel3 = $616F7333;
  bmdDeckLinkConfigAnalogAudioOutputScaleChannel4 = $616F7334;
  bmdDeckLinkConfigDigitalAudioOutputScale = $64616F73;

// Constants for enum _BMDDeckControlStatusFlags
type
  _BMDDeckControlStatusFlags = TOleEnum;
const
  bmdDeckControlStatusDeckConnected = $00000001;
  bmdDeckControlStatusRemoteMode = $00000002;
  bmdDeckControlStatusRecordInhibited = $00000004;
  bmdDeckControlStatusCassetteOut = $00000008;

// Constants for enum _BMDDeckControlExportModeOpsFlags
type
  _BMDDeckControlExportModeOpsFlags = TOleEnum;
const
  bmdDeckControlExportModeInsertVideo = $00000001;
  bmdDeckControlExportModeInsertAudio1 = $00000002;
  bmdDeckControlExportModeInsertAudio2 = $00000004;
  bmdDeckControlExportModeInsertAudio3 = $00000008;
  bmdDeckControlExportModeInsertAudio4 = $00000010;
  bmdDeckControlExportModeInsertAudio5 = $00000020;
  bmdDeckControlExportModeInsertAudio6 = $00000040;
  bmdDeckControlExportModeInsertAudio7 = $00000080;
  bmdDeckControlExportModeInsertAudio8 = $00000100;
  bmdDeckControlExportModeInsertAudio9 = $00000200;
  bmdDeckControlExportModeInsertAudio10 = $00000400;
  bmdDeckControlExportModeInsertAudio11 = $00000800;
  bmdDeckControlExportModeInsertAudio12 = $00001000;
  bmdDeckControlExportModeInsertTimeCode = $00002000;
  bmdDeckControlExportModeInsertAssemble = $00004000;
  bmdDeckControlExportModeInsertPreview = $00008000;
  bmdDeckControlUseManualExport = $00010000;

// Constants for enum _BMDDeckControlMode
type
  _BMDDeckControlMode = TOleEnum;
const
  bmdDeckControlNotOpened = $6E746F70;
  bmdDeckControlVTRControlMode = $76747263;
  bmdDeckControlExportMode = $6578706D;
  bmdDeckControlCaptureMode = $6361706D;

// Constants for enum _BMDDeckControlEvent
type
  _BMDDeckControlEvent = TOleEnum;
const
  bmdDeckControlAbortedEvent = $61627465;
  bmdDeckControlPrepareForExportEvent = $70666565;
  bmdDeckControlExportCompleteEvent = $65786365;
  bmdDeckControlPrepareForCaptureEvent = $70666365;
  bmdDeckControlCaptureCompleteEvent = $63636576;

// Constants for enum _BMDDeckControlVTRControlState
type
  _BMDDeckControlVTRControlState = TOleEnum;
const
  bmdDeckControlNotInVTRControlMode = $6E76636D;
  bmdDeckControlVTRControlPlaying = $76747270;
  bmdDeckControlVTRControlRecording = $76747272;
  bmdDeckControlVTRControlStill = $76747261;
  bmdDeckControlVTRControlShuttleForward = $76747366;
  bmdDeckControlVTRControlShuttleReverse = $76747372;
  bmdDeckControlVTRControlJogForward = $76746A66;
  bmdDeckControlVTRControlJogReverse = $76746A72;
  bmdDeckControlVTRControlStopped = $7674726F;

// Constants for enum _BMDDeckControlError
type
  _BMDDeckControlError = TOleEnum;
const
  bmdDeckControlNoError = $6E6F6572;
  bmdDeckControlModeError = $6D6F6572;
  bmdDeckControlMissedInPointError = $6D696572;
  bmdDeckControlDeckTimeoutError = $64746572;
  bmdDeckControlCommandFailedError = $63666572;
  bmdDeckControlDeviceAlreadyOpenedError = $64616C6F;
  bmdDeckControlFailedToOpenDeviceError = $66646572;
  bmdDeckControlInLocalModeError = $6C6D6572;
  bmdDeckControlEndOfTapeError = $65746572;
  bmdDeckControlUserAbortError = $75616572;
  bmdDeckControlNoTapeInDeckError = $6E746572;
  bmdDeckControlNoVideoFromCardError = $6E766663;
  bmdDeckControlNoCommunicationError = $6E636F6D;
  bmdDeckControlBufferTooSmallError = $6274736D;
  bmdDeckControlBadChecksumError = $63686B73;
  bmdDeckControlUnknownError = $756E6572;

// Constants for enum _BMDStreamingDeviceMode
type
  _BMDStreamingDeviceMode = TOleEnum;
const
  bmdStreamingDeviceIdle = $69646C65;
  bmdStreamingDeviceEncoding = $656E636F;
  bmdStreamingDeviceStopping = $73746F70;
  bmdStreamingDeviceUnknown = $6D756E6B;

// Constants for enum _BMDStreamingEncodingFrameRate
type
  _BMDStreamingEncodingFrameRate = TOleEnum;
const
  bmdStreamingEncodedFrameRate50i = $65353069;
  bmdStreamingEncodedFrameRate5994i = $65353969;
  bmdStreamingEncodedFrameRate60i = $65363069;
  bmdStreamingEncodedFrameRate2398p = $65323370;
  bmdStreamingEncodedFrameRate24p = $65323470;
  bmdStreamingEncodedFrameRate25p = $65323570;
  bmdStreamingEncodedFrameRate2997p = $65323970;
  bmdStreamingEncodedFrameRate30p = $65333070;
  bmdStreamingEncodedFrameRate50p = $65353070;
  bmdStreamingEncodedFrameRate5994p = $65353970;
  bmdStreamingEncodedFrameRate60p = $65363070;

// Constants for enum _BMDStreamingEncodingSupport
type
  _BMDStreamingEncodingSupport = TOleEnum;
const
  bmdStreamingEncodingModeNotSupported = $00000000;
  bmdStreamingEncodingModeSupported = $00000001;
  bmdStreamingEncodingModeSupportedWithChanges = $00000002;

// Constants for enum _BMDStreamingVideoCodec
type
  _BMDStreamingVideoCodec = TOleEnum;
const
  bmdStreamingVideoCodecH264 = $48323634;

// Constants for enum _BMDStreamingH264Profile
type
  _BMDStreamingH264Profile = TOleEnum;
const
  bmdStreamingH264ProfileHigh = $68696768;
  bmdStreamingH264ProfileMain = $6D61696E;
  bmdStreamingH264ProfileBaseline = $62617365;

// Constants for enum _BMDStreamingH264Level
type
  _BMDStreamingH264Level = TOleEnum;
const
  bmdStreamingH264Level12 = $6C763132;
  bmdStreamingH264Level13 = $6C763133;
  bmdStreamingH264Level2 = $6C763220;
  bmdStreamingH264Level21 = $6C763231;
  bmdStreamingH264Level22 = $6C763232;
  bmdStreamingH264Level3 = $6C763320;
  bmdStreamingH264Level31 = $6C763331;
  bmdStreamingH264Level32 = $6C763332;
  bmdStreamingH264Level4 = $6C763420;
  bmdStreamingH264Level41 = $6C763431;
  bmdStreamingH264Level42 = $6C763432;

// Constants for enum _BMDStreamingH264EntropyCoding
type
  _BMDStreamingH264EntropyCoding = TOleEnum;
const
  bmdStreamingH264EntropyCodingCAVLC = $45564C43;
  bmdStreamingH264EntropyCodingCABAC = $45424143;

// Constants for enum _BMDStreamingAudioCodec
type
  _BMDStreamingAudioCodec = TOleEnum;
const
  bmdStreamingAudioCodecAAC = $41414320;

// Constants for enum _BMDStreamingEncodingModePropertyID
type
  _BMDStreamingEncodingModePropertyID = TOleEnum;
const
  bmdStreamingEncodingPropertyVideoFrameRate = $76667274;
  bmdStreamingEncodingPropertyVideoBitRateKbps = $76627274;
  bmdStreamingEncodingPropertyH264Profile = $68707266;
  bmdStreamingEncodingPropertyH264Level = $686C766C;
  bmdStreamingEncodingPropertyH264EntropyCoding = $68656E74;
  bmdStreamingEncodingPropertyH264HasBFrames = $68426672;
  bmdStreamingEncodingPropertyAudioCodec = $61636463;
  bmdStreamingEncodingPropertyAudioSampleRate = $61737274;
  bmdStreamingEncodingPropertyAudioChannelCount = $61636863;
  bmdStreamingEncodingPropertyAudioBitRateKbps = $61627274;

// Constants for enum _BMDFrameFlags
type
  _BMDFrameFlags = TOleEnum;
const
  bmdFrameFlagDefault = $00000000;
  bmdFrameFlagFlipVertical = $00000001;
  bmdFrameHasNoInputSource = $80000000;

// Constants for enum _BMDVideoInputFlags
type
  _BMDVideoInputFlags = TOleEnum;
const
  bmdVideoInputFlagDefault = $00000000;
  bmdVideoInputEnableFormatDetection = $00000001;
  bmdVideoInputDualStream3D = $00000002;

// Constants for enum _BMDVideoInputFormatChangedEvents
type
  _BMDVideoInputFormatChangedEvents = TOleEnum;
const
  bmdVideoInputDisplayModeChanged = $00000001;
  bmdVideoInputFieldDominanceChanged = $00000002;
  bmdVideoInputColorspaceChanged = $00000004;

// Constants for enum _BMDDetectedVideoInputFormatFlags
type
  _BMDDetectedVideoInputFormatFlags = TOleEnum;
const
  bmdDetectedVideoInputYCbCr422 = $00000001;
  bmdDetectedVideoInputRGB444 = $00000002;

// Constants for enum _BMDAnalogVideoFlags
type
  _BMDAnalogVideoFlags = TOleEnum;
const
  bmdAnalogVideoFlagCompositeSetup75 = $00000001;
  bmdAnalogVideoFlagComponentBetacamLevels = $00000002;

// Constants for enum _BMDDeviceBusyState
type
  _BMDDeviceBusyState = TOleEnum;
const
  bmdDeviceCaptureBusy = $00000001;
  bmdDevicePlaybackBusy = $00000002;
  bmdDeviceSerialPortBusy = $00000004;

// Constants for enum _BMDVideoOutputFlags
type
  _BMDVideoOutputFlags = TOleEnum;
const
  bmdVideoOutputFlagDefault = $00000000;
  bmdVideoOutputVANC = $00000001;
  bmdVideoOutputVITC = $00000002;
  bmdVideoOutputRP188 = $00000004;
  bmdVideoOutputDualStream3D = $00000010;

// Constants for enum _BMDOutputFrameCompletionResult
type
  _BMDOutputFrameCompletionResult = TOleEnum;
const
  bmdOutputFrameCompleted = $00000000;
  bmdOutputFrameDisplayedLate = $00000001;
  bmdOutputFrameDropped = $00000002;
  bmdOutputFrameFlushed = $00000003;

// Constants for enum _BMDReferenceStatus
type
  _BMDReferenceStatus = TOleEnum;
const
  bmdReferenceNotSupportedByHardware = $00000001;
  bmdReferenceLocked = $00000002;

// Constants for enum _BMDAudioSampleRate
type
  _BMDAudioSampleRate = TOleEnum;
const
  bmdAudioSampleRate48kHz = $0000BB80;

// Constants for enum _BMDAudioSampleType
type
  _BMDAudioSampleType = TOleEnum;
const
  bmdAudioSampleType16bitInteger = $00000010;
  bmdAudioSampleType32bitInteger = $00000020;

// Constants for enum _BMDAudioOutputStreamType
type
  _BMDAudioOutputStreamType = TOleEnum;
const
  bmdAudioOutputStreamContinuous = $00000000;
  bmdAudioOutputStreamContinuousDontResample = $00000001;
  bmdAudioOutputStreamTimestamped = $00000002;

// Constants for enum _BMDDisplayModeSupport
type
  _BMDDisplayModeSupport = TOleEnum;
const
  bmdDisplayModeNotSupported = $00000000;
  bmdDisplayModeSupported = $00000001;
  bmdDisplayModeSupportedWithConversion = $00000002;

// Constants for enum _BMDTimecodeFormat
type
  _BMDTimecodeFormat = TOleEnum;
const
  bmdTimecodeRP188VITC1 = $72707631;
  bmdTimecodeRP188VITC2 = $72703132;
  bmdTimecodeRP188LTC = $72706C74;
  bmdTimecodeRP188Any = $72703138;
  bmdTimecodeVITC = $76697463;
  bmdTimecodeVITCField2 = $76697432;
  bmdTimecodeSerial = $73657269;

// Constants for enum _BMDAudioConnection
type
  _BMDAudioConnection = TOleEnum;
const
  bmdAudioConnectionEmbedded = $656D6264;
  bmdAudioConnectionAESEBU = $61657320;
  bmdAudioConnectionAnalog = $616E6C67;
  bmdAudioConnectionAnalogXLR = $61786C72;
  bmdAudioConnectionAnalogRCA = $61726361;

// Constants for enum _BMDAudioOutputAnalogAESSwitch
type
  _BMDAudioOutputAnalogAESSwitch = TOleEnum;
const
  bmdAudioOutputSwitchAESEBU = $61657320;
  bmdAudioOutputSwitchAnalog = $616E6C67;

// Constants for enum _BMDVideoOutputConversionMode
type
  _BMDVideoOutputConversionMode = TOleEnum;
const
  bmdNoVideoOutputConversion = $6E6F6E65;
  bmdVideoOutputLetterboxDownconversion = $6C746278;
  bmdVideoOutputAnamorphicDownconversion = $616D7068;
  bmdVideoOutputHD720toHD1080Conversion = $37323063;
  bmdVideoOutputHardwareLetterboxDownconversion = $48576C62;
  bmdVideoOutputHardwareAnamorphicDownconversion = $4857616D;
  bmdVideoOutputHardwareCenterCutDownconversion = $48576363;
  bmdVideoOutputHardware720p1080pCrossconversion = $78636170;
  bmdVideoOutputHardwareAnamorphic720pUpconversion = $75613770;
  bmdVideoOutputHardwareAnamorphic1080iUpconversion = $75613169;
  bmdVideoOutputHardwareAnamorphic149To720pUpconversion = $75343770;
  bmdVideoOutputHardwareAnamorphic149To1080iUpconversion = $75343169;
  bmdVideoOutputHardwarePillarbox720pUpconversion = $75703770;
  bmdVideoOutputHardwarePillarbox1080iUpconversion = $75703169;

// Constants for enum _BMDVideoInputConversionMode
type
  _BMDVideoInputConversionMode = TOleEnum;
const
  bmdNoVideoInputConversion = $6E6F6E65;
  bmdVideoInputLetterboxDownconversionFromHD1080 = $31306C62;
  bmdVideoInputAnamorphicDownconversionFromHD1080 = $3130616D;
  bmdVideoInputLetterboxDownconversionFromHD720 = $37326C62;
  bmdVideoInputAnamorphicDownconversionFromHD720 = $3732616D;
  bmdVideoInputLetterboxUpconversion = $6C627570;
  bmdVideoInputAnamorphicUpconversion = $616D7570;

// Constants for enum _BMDVideo3DPackingFormat
type
  _BMDVideo3DPackingFormat = TOleEnum;
const
  bmdVideo3DPackingSidebySideHalf = $73627368;
  bmdVideo3DPackingLinebyLine = $6C62796C;
  bmdVideo3DPackingTopAndBottom = $7461626F;
  bmdVideo3DPackingFramePacking = $6672706B;
  bmdVideo3DPackingLeftOnly = $6C656674;
  bmdVideo3DPackingRightOnly = $72696768;

// Constants for enum _BMDIdleVideoOutputOperation
type
  _BMDIdleVideoOutputOperation = TOleEnum;
const
  bmdIdleVideoOutputBlack = $626C6163;
  bmdIdleVideoOutputLastFrame = $6C616661;
  bmdIdleVideoOutputDesktop = $6465736B;

// Constants for enum _BMDDeckLinkAttributeID
type
  _BMDDeckLinkAttributeID = TOleEnum;
const
  BMDDeckLinkSupportsInternalKeying = $6B657969;
  BMDDeckLinkSupportsExternalKeying = $6B657965;
  BMDDeckLinkSupportsHDKeying = $6B657968;
  BMDDeckLinkSupportsInputFormatDetection = $696E6664;
  BMDDeckLinkHasReferenceInput = $6872696E;
  BMDDeckLinkHasSerialPort = $68737074;
  BMDDeckLinkHasAnalogVideoOutputGain = $61766F67;
  BMDDeckLinkCanOnlyAdjustOverallVideoOutputGain = $6F766F67;
  BMDDeckLinkHasVideoInputAntiAliasingFilter = $6161666C;
  BMDDeckLinkHasBypass = $62797073;
  BMDDeckLinkSupportsDesktopDisplay = $65787464;
  BMDDeckLinkSupportsClockTimingAdjustment = $63746164;
  BMDDeckLinkMaximumAudioChannels = $6D616368;
  BMDDeckLinkNumberOfSubDevices = $6E736264;
  BMDDeckLinkSubDeviceIndex = $73756269;
  BMDDeckLinkVideoOutputConnections = $766F636E;
  BMDDeckLinkVideoInputConnections = $7669636E;
  BMDDeckLinkDeviceBusyState = $64627374;
  BMDDeckLinkVideoIOSupport = $76696F73;
  BMDDeckLinkVideoInputGainMinimum = $7669676D;
  BMDDeckLinkVideoInputGainMaximum = $76696778;
  BMDDeckLinkVideoOutputGainMinimum = $766F676D;
  BMDDeckLinkVideoOutputGainMaximum = $766F6778;
  BMDDeckLinkSerialPortDeviceName = $736C706E;

// Constants for enum _BMDDeckLinkAPIInformationID
type
  _BMDDeckLinkAPIInformationID = TOleEnum;
const
  BMDDeckLinkAPIVersion = $76657273;

// Constants for enum _BMDVideoIOSupport
type
  _BMDVideoIOSupport = TOleEnum;
const
  bmdDeviceSupportsCapture = $00000001;
  bmdDeviceSupportsPlayback = $00000002;

// Constants for enum _BMD3DPreviewFormat
type
  _BMD3DPreviewFormat = TOleEnum;
const
  bmd3DPreviewFormatDefault = $64656661;
  bmd3DPreviewFormatLeftOnly = $6C656674;
  bmd3DPreviewFormatRightOnly = $72696768;
  bmd3DPreviewFormatSideBySide = $73696465;
  bmd3DPreviewFormatTopBottom = $746F7062;

// Constants for enum _BMDNotifications
type
  _BMDNotifications = TOleEnum;
const
  bmdPreferencesChanged = $70726566;

// Constants for enum _BMDDeckControlVTRControlState_v8_1
type
  _BMDDeckControlVTRControlState_v8_1 = TOleEnum;
const
  bmdDeckControlNotInVTRControlMode_v8_1 = $6E76636D;
  bmdDeckControlVTRControlPlaying_v8_1 = $76747270;
  bmdDeckControlVTRControlRecording_v8_1 = $76747272;
  bmdDeckControlVTRControlStill_v8_1 = $76747261;
  bmdDeckControlVTRControlSeeking_v8_1 = $76747273;
  bmdDeckControlVTRControlStopped_v8_1 = $7674726F;

// Constants for enum _BMDVideoConnection_v7_6
type
  _BMDVideoConnection_v7_6 = TOleEnum;
const
  bmdVideoConnectionSDI_v7_6 = $73646920;
  bmdVideoConnectionHDMI_v7_6 = $68646D69;
  bmdVideoConnectionOpticalSDI_v7_6 = $6F707469;
  bmdVideoConnectionComponent_v7_6 = $63706E74;
  bmdVideoConnectionComposite_v7_6 = $636D7374;
  bmdVideoConnectionSVideo_v7_6 = $73766964;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDeckLinkTimecode = interface;
  IDeckLinkDisplayModeIterator = interface;
  IDeckLinkDisplayMode = interface;
  IDeckLink = interface;
  IDeckLinkConfiguration = interface;
  IDeckLinkDeckControlStatusCallback = interface;
  IDeckLinkDeckControl = interface;
  IBMDStreamingDeviceNotificationCallback = interface;
  IBMDStreamingH264InputCallback = interface;
  IBMDStreamingH264NALPacket = interface;
  IBMDStreamingAudioPacket = interface;
  IBMDStreamingMPEG2TSPacket = interface;
  IBMDStreamingDiscovery = interface;
  IBMDStreamingVideoEncodingMode = interface;
  IBMDStreamingMutableVideoEncodingMode = interface;
  IBMDStreamingVideoEncodingModePresetIterator = interface;
  IBMDStreamingDeviceInput = interface;
  IBMDStreamingH264NALParser = interface;
  IDeckLinkVideoOutputCallback = interface;
  IDeckLinkVideoFrame = interface;
  IDeckLinkVideoFrameAncillary = interface;
  IDeckLinkInputCallback = interface;
  IDeckLinkVideoInputFrame = interface;
  IDeckLinkAudioInputPacket = interface;
  IDeckLinkMemoryAllocator = interface;
  IDeckLinkAudioOutputCallback = interface;
  IDeckLinkIterator = interface;
  IDeckLinkAPIInformation = interface;
  IDeckLinkOutput = interface;
  IDeckLinkScreenPreviewCallback = interface;
  IDeckLinkMutableVideoFrame = interface;
  IDeckLinkInput = interface;
  IDeckLinkVideoFrame3DExtensions = interface;
  IDeckLinkGLScreenPreviewHelper = interface;
  IDeckLinkDX9ScreenPreviewHelper = interface;
  IDeckLinkNotificationCallback = interface;
  IDeckLinkNotification = interface;
  IDeckLinkAttributes = interface;
  IDeckLinkKeyer = interface;
  IDeckLinkVideoConversion = interface;
  IDeckLinkInput_v9_2 = interface;
  IDeckLinkDeckControlStatusCallback_v8_1 = interface;
  IDeckLinkDeckControl_v8_1 = interface;
  IDeckLink_v8_0 = interface;
  IDeckLinkIterator_v8_0 = interface;
  IDeckLinkDeckControl_v7_9 = interface;
  IDeckLinkDisplayModeIterator_v7_6 = interface;
  IDeckLinkDisplayMode_v7_6 = interface;
  IDeckLinkOutput_v7_6 = interface;
  IDeckLinkScreenPreviewCallback_v7_6 = interface;
  IDeckLinkVideoFrame_v7_6 = interface;
  IDeckLinkTimecode_v7_6 = interface;
  IDeckLinkMutableVideoFrame_v7_6 = interface;
  IDeckLinkVideoOutputCallback_v7_6 = interface;
  IDeckLinkInput_v7_6 = interface;
  IDeckLinkInputCallback_v7_6 = interface;
  IDeckLinkVideoInputFrame_v7_6 = interface;
  IDeckLinkGLScreenPreviewHelper_v7_6 = interface;
  IDeckLinkVideoConversion_v7_6 = interface;
  IDeckLinkConfiguration_v7_6 = interface;
  IDeckLinkInputCallback_v7_3 = interface;
  IDeckLinkVideoInputFrame_v7_3 = interface;
  IDeckLinkOutput_v7_3 = interface;
  IDeckLinkInput_v7_3 = interface;
  IDeckLinkDisplayModeIterator_v7_1 = interface;
  IDeckLinkDisplayMode_v7_1 = interface;
  IDeckLinkVideoFrame_v7_1 = interface;
  IDeckLinkVideoInputFrame_v7_1 = interface;
  IDeckLinkAudioInputPacket_v7_1 = interface;
  IDeckLinkVideoOutputCallback_v7_1 = interface;
  IDeckLinkInputCallback_v7_1 = interface;
  IDeckLinkOutput_v7_1 = interface;
  IDeckLinkInput_v7_1 = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  CBMDStreamingDiscovery = IBMDStreamingDiscovery;
  CBMDStreamingH264NALParser = IBMDStreamingH264NALParser;
  CDeckLinkIterator = IDeckLinkIterator;
  CDeckLinkAPIInformation = IDeckLinkAPIInformation;
  CDeckLinkGLScreenPreviewHelper = IDeckLinkGLScreenPreviewHelper;
  CDeckLinkDX9ScreenPreviewHelper = IDeckLinkDX9ScreenPreviewHelper;
  CDeckLinkVideoConversion = IDeckLinkVideoConversion;
  CDeckLinkIterator_v8_0 = IDeckLinkIterator_v8_0;
  CDeckLinkGLScreenPreviewHelper_v7_6 = IDeckLinkGLScreenPreviewHelper_v7_6;
  CDeckLinkVideoConversion_v7_6 = IDeckLinkVideoConversion_v7_6;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PByte1 = ^Byte; {*}
  PUserType1 = ^tagRECT; {*}
  PPPrivateAlias1 = ^Pointer; {*}
  PComp1 = ^Int64; {*}
  PPUserType1 = ^IDeckLinkVideoFrame_v7_1; {*}

  tagRECT = record
    left: Integer;
    top: Integer;
    right: Integer;
    bottom: Integer;
  end;


// *********************************************************************//
// Interface: IDeckLinkTimecode
// Flags:     (0)
// GUID:      {BC6CFBD3-8317-4325-AC1C-1216391E9340}
// *********************************************************************//
  IDeckLinkTimecode = interface(IUnknown)
    ['{BC6CFBD3-8317-4325-AC1C-1216391E9340}']
    function GetBCD: LongWord; stdcall;
    function GetComponents(out hours: Byte; out minutes: Byte; out seconds: Byte; out frames: Byte): HResult; stdcall;
    function GetString(out timecode: WideString): HResult; stdcall;
    function GetFlags: _BMDTimecodeFlags; stdcall;
    function GetTimecodeUserBits(out userBits: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkDisplayModeIterator
// Flags:     (0)
// GUID:      {9C88499F-F601-4021-B80B-032E4EB41C35}
// *********************************************************************//
  IDeckLinkDisplayModeIterator = interface(IUnknown)
    ['{9C88499F-F601-4021-B80B-032E4EB41C35}']
    function Next(out deckLinkDisplayMode: IDeckLinkDisplayMode): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkDisplayMode
// Flags:     (0)
// GUID:      {3EB2C1AB-0A3D-4523-A3AD-F40D7FB14E78}
// *********************************************************************//
  IDeckLinkDisplayMode = interface(IUnknown)
    ['{3EB2C1AB-0A3D-4523-A3AD-F40D7FB14E78}']
    function GetName(out name: WideString): HResult; stdcall;
    function GetDisplayMode: _BMDDisplayMode; stdcall;
    function GetWidth: Integer; stdcall;
    function GetHeight: Integer; stdcall;
    function GetFrameRate(out frameDuration: Int64; out timeScale: Int64): HResult; stdcall;
    function GetFieldDominance: _BMDFieldDominance; stdcall;
    function GetFlags: _BMDDisplayModeFlags; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLink
// Flags:     (0)
// GUID:      {C418FBDD-0587-48ED-8FE5-640F0A14AF91}
// *********************************************************************//
  IDeckLink = interface(IUnknown)
    ['{C418FBDD-0587-48ED-8FE5-640F0A14AF91}']
    function GetModelName(out modelName: WideString): HResult; stdcall;
    function GetDisplayName(out displayName: WideString): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkConfiguration
// Flags:     (0)
// GUID:      {C679A35B-610C-4D09-B748-1D0478100FC0}
// *********************************************************************//
  IDeckLinkConfiguration = interface(IUnknown)
    ['{C679A35B-610C-4D09-B748-1D0478100FC0}']
    function SetFlag(cfgID: _BMDDeckLinkConfigurationID; value: Integer): HResult; stdcall;
    function GetFlag(cfgID: _BMDDeckLinkConfigurationID; out value: Integer): HResult; stdcall;
    function SetInt(cfgID: _BMDDeckLinkConfigurationID; value: Int64): HResult; stdcall;
    function GetInt(cfgID: _BMDDeckLinkConfigurationID; out value: Int64): HResult; stdcall;
    function SetFloat(cfgID: _BMDDeckLinkConfigurationID; value: Double): HResult; stdcall;
    function GetFloat(cfgID: _BMDDeckLinkConfigurationID; out value: Double): HResult; stdcall;
    function SetString(cfgID: _BMDDeckLinkConfigurationID; const value: WideString): HResult; stdcall;
    function GetString(cfgID: _BMDDeckLinkConfigurationID; out value: WideString): HResult; stdcall;
    function WriteConfigurationToPreferences: HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkDeckControlStatusCallback
// Flags:     (0)
// GUID:      {53436FFB-B434-4906-BADC-AE3060FFE8EF}
// *********************************************************************//
  IDeckLinkDeckControlStatusCallback = interface(IUnknown)
    ['{53436FFB-B434-4906-BADC-AE3060FFE8EF}']
    function TimecodeUpdate(currentTimecode: LongWord): HResult; stdcall;
    function VTRControlStateChanged(newState: _BMDDeckControlVTRControlState; 
                                    error: _BMDDeckControlError): HResult; stdcall;
    function DeckControlEventReceived(event: _BMDDeckControlEvent; error: _BMDDeckControlError): HResult; stdcall;
    function DeckControlStatusChanged(flags: _BMDDeckControlStatusFlags; mask: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkDeckControl
// Flags:     (0)
// GUID:      {8E1C3ACE-19C7-4E00-8B92-D80431D958BE}
// *********************************************************************//
  IDeckLinkDeckControl = interface(IUnknown)
    ['{8E1C3ACE-19C7-4E00-8B92-D80431D958BE}']
    function Open(timeScale: Int64; timeValue: Int64; timecodeIsDropFrame: Integer; 
                  out error: _BMDDeckControlError): HResult; stdcall;
    function Close(standbyOn: Integer): HResult; stdcall;
    function GetCurrentState(out mode: _BMDDeckControlMode; 
                             out vtrControlState: _BMDDeckControlVTRControlState; 
                             out flags: _BMDDeckControlStatusFlags): HResult; stdcall;
    function SetStandby(standbyOn: Integer): HResult; stdcall;
    function SendCommand(var inBuffer: Byte; inBufferSize: LongWord; out outBuffer: Byte; 
                         out outDataSize: LongWord; outBufferSize: LongWord; 
                         out error: _BMDDeckControlError): HResult; stdcall;
    function Play(out error: _BMDDeckControlError): HResult; stdcall;
    function Stop(out error: _BMDDeckControlError): HResult; stdcall;
    function TogglePlayStop(out error: _BMDDeckControlError): HResult; stdcall;
    function Eject(out error: _BMDDeckControlError): HResult; stdcall;
    function GoToTimecode(timecode: LongWord; out error: _BMDDeckControlError): HResult; stdcall;
    function FastForward(viewTape: Integer; out error: _BMDDeckControlError): HResult; stdcall;
    function Rewind(viewTape: Integer; out error: _BMDDeckControlError): HResult; stdcall;
    function StepForward(out error: _BMDDeckControlError): HResult; stdcall;
    function StepBack(out error: _BMDDeckControlError): HResult; stdcall;
    function Jog(rate: Double; out error: _BMDDeckControlError): HResult; stdcall;
    function Shuttle(rate: Double; out error: _BMDDeckControlError): HResult; stdcall;
    function GetTimecodeString(out currentTimecode: WideString; out error: _BMDDeckControlError): HResult; stdcall;
    function GetTimecode(out currentTimecode: IDeckLinkTimecode; out error: _BMDDeckControlError): HResult; stdcall;
    function GetTimecodeBCD(out currentTimecode: LongWord; out error: _BMDDeckControlError): HResult; stdcall;
    function SetPreroll(prerollSeconds: LongWord): HResult; stdcall;
    function GetPreroll(out prerollSeconds: LongWord): HResult; stdcall;
    function SetExportOffset(exportOffsetFields: Integer): HResult; stdcall;
    function GetExportOffset(out exportOffsetFields: Integer): HResult; stdcall;
    function GetManualExportOffset(out deckManualExportOffsetFields: Integer): HResult; stdcall;
    function SetCaptureOffset(captureOffsetFields: Integer): HResult; stdcall;
    function GetCaptureOffset(out captureOffsetFields: Integer): HResult; stdcall;
    function StartExport(inTimecode: LongWord; outTimecode: LongWord; 
                         exportModeOps: _BMDDeckControlExportModeOpsFlags; 
                         out error: _BMDDeckControlError): HResult; stdcall;
    function StartCapture(useVITC: Integer; inTimecode: LongWord; outTimecode: LongWord; 
                          out error: _BMDDeckControlError): HResult; stdcall;
    function GetDeviceID(out deviceId: Word; out error: _BMDDeckControlError): HResult; stdcall;
    function Abort: HResult; stdcall;
    function CrashRecordStart(out error: _BMDDeckControlError): HResult; stdcall;
    function CrashRecordStop(out error: _BMDDeckControlError): HResult; stdcall;
    function SetCallback(const callback: IDeckLinkDeckControlStatusCallback): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IBMDStreamingDeviceNotificationCallback
// Flags:     (0)
// GUID:      {F9531D64-3305-4B29-A387-7F74BB0D0E84}
// *********************************************************************//
  IBMDStreamingDeviceNotificationCallback = interface(IUnknown)
    ['{F9531D64-3305-4B29-A387-7F74BB0D0E84}']
    function StreamingDeviceArrived(const device: IDeckLink): HResult; stdcall;
    function StreamingDeviceRemoved(const device: IDeckLink): HResult; stdcall;
    function StreamingDeviceModeChanged(const device: IDeckLink; mode: _BMDStreamingDeviceMode): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IBMDStreamingH264InputCallback
// Flags:     (0)
// GUID:      {823C475F-55AE-46F9-890C-537CC5CEDCCA}
// *********************************************************************//
  IBMDStreamingH264InputCallback = interface(IUnknown)
    ['{823C475F-55AE-46F9-890C-537CC5CEDCCA}']
    function H264NALPacketArrived(const nalPacket: IBMDStreamingH264NALPacket): HResult; stdcall;
    function H264AudioPacketArrived(const audioPacket: IBMDStreamingAudioPacket): HResult; stdcall;
    function MPEG2TSPacketArrived(const tsPacket: IBMDStreamingMPEG2TSPacket): HResult; stdcall;
    function H264VideoInputConnectorScanningChanged: HResult; stdcall;
    function H264VideoInputConnectorChanged: HResult; stdcall;
    function H264VideoInputModeChanged: HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IBMDStreamingH264NALPacket
// Flags:     (0)
// GUID:      {E260E955-14BE-4395-9775-9F02CC0A9D89}
// *********************************************************************//
  IBMDStreamingH264NALPacket = interface(IUnknown)
    ['{E260E955-14BE-4395-9775-9F02CC0A9D89}']
    function GetPayloadSize: Integer; stdcall;
    function GetBytes(out buffer: Pointer): HResult; stdcall;
    function GetBytesWithSizePrefix(out buffer: Pointer): HResult; stdcall;
    function GetDisplayTime(requestedTimeScale: Largeuint; out displayTime: Largeuint): HResult; stdcall;
    function GetPacketIndex(out packetIndex: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IBMDStreamingAudioPacket
// Flags:     (0)
// GUID:      {D9EB5902-1AD2-43F4-9E2C-3CFA50B5EE19}
// *********************************************************************//
  IBMDStreamingAudioPacket = interface(IUnknown)
    ['{D9EB5902-1AD2-43F4-9E2C-3CFA50B5EE19}']
    function GetCodec: _BMDStreamingAudioCodec; stdcall;
    function GetPayloadSize: Integer; stdcall;
    function GetBytes(out buffer: Pointer): HResult; stdcall;
    function GetPlayTime(requestedTimeScale: Largeuint; out playTime: Largeuint): HResult; stdcall;
    function GetPacketIndex(out packetIndex: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IBMDStreamingMPEG2TSPacket
// Flags:     (0)
// GUID:      {91810D1C-4FB3-4AAA-AE56-FA301D3DFA4C}
// *********************************************************************//
  IBMDStreamingMPEG2TSPacket = interface(IUnknown)
    ['{91810D1C-4FB3-4AAA-AE56-FA301D3DFA4C}']
    function GetPayloadSize: Integer; stdcall;
    function GetBytes(out buffer: Pointer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IBMDStreamingDiscovery
// Flags:     (0)
// GUID:      {2C837444-F989-4D87-901A-47C8A36D096D}
// *********************************************************************//
  IBMDStreamingDiscovery = interface(IUnknown)
    ['{2C837444-F989-4D87-901A-47C8A36D096D}']
    function InstallDeviceNotifications(const theCallback: IBMDStreamingDeviceNotificationCallback): HResult; stdcall;
    function UninstallDeviceNotifications: HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IBMDStreamingVideoEncodingMode
// Flags:     (0)
// GUID:      {1AB8035B-CD13-458D-B6DF-5E8F7C2141D9}
// *********************************************************************//
  IBMDStreamingVideoEncodingMode = interface(IUnknown)
    ['{1AB8035B-CD13-458D-B6DF-5E8F7C2141D9}']
    function GetName(out name: WideString): HResult; stdcall;
    function GetPresetID: SYSUINT; stdcall;
    function GetSourcePositionX: SYSUINT; stdcall;
    function GetSourcePositionY: SYSUINT; stdcall;
    function GetSourceWidth: SYSUINT; stdcall;
    function GetSourceHeight: SYSUINT; stdcall;
    function GetDestWidth: SYSUINT; stdcall;
    function GetDestHeight: SYSUINT; stdcall;
    function GetFlag(cfgID: _BMDStreamingEncodingModePropertyID; out value: Integer): HResult; stdcall;
    function GetInt(cfgID: _BMDStreamingEncodingModePropertyID; out value: Int64): HResult; stdcall;
    function GetFloat(cfgID: _BMDStreamingEncodingModePropertyID; out value: Double): HResult; stdcall;
    function GetString(cfgID: _BMDStreamingEncodingModePropertyID; out value: WideString): HResult; stdcall;
    function CreateMutableVideoEncodingMode(out newEncodingMode: IBMDStreamingMutableVideoEncodingMode): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IBMDStreamingMutableVideoEncodingMode
// Flags:     (0)
// GUID:      {19BF7D90-1E0A-400D-B2C6-FFC4E78AD49D}
// *********************************************************************//
  IBMDStreamingMutableVideoEncodingMode = interface(IBMDStreamingVideoEncodingMode)
    ['{19BF7D90-1E0A-400D-B2C6-FFC4E78AD49D}']
    function SetSourceRect(posX: LongWord; posY: LongWord; width: LongWord; height: LongWord): HResult; stdcall;
    function SetDestSize(width: LongWord; height: LongWord): HResult; stdcall;
    function SetFlag(cfgID: _BMDStreamingEncodingModePropertyID; value: Integer): HResult; stdcall;
    function SetInt(cfgID: _BMDStreamingEncodingModePropertyID; value: Int64): HResult; stdcall;
    function SetFloat(cfgID: _BMDStreamingEncodingModePropertyID; value: Double): HResult; stdcall;
    function SetString(cfgID: _BMDStreamingEncodingModePropertyID; const value: WideString): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IBMDStreamingVideoEncodingModePresetIterator
// Flags:     (0)
// GUID:      {7AC731A3-C950-4AD0-804A-8377AA51C6C4}
// *********************************************************************//
  IBMDStreamingVideoEncodingModePresetIterator = interface(IUnknown)
    ['{7AC731A3-C950-4AD0-804A-8377AA51C6C4}']
    function Next(out videoEncodingMode: IBMDStreamingVideoEncodingMode): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IBMDStreamingDeviceInput
// Flags:     (0)
// GUID:      {24B6B6EC-1727-44BB-9818-34FF086ACF98}
// *********************************************************************//
  IBMDStreamingDeviceInput = interface(IUnknown)
    ['{24B6B6EC-1727-44BB-9818-34FF086ACF98}']
    function DoesSupportVideoInputMode(inputMode: _BMDDisplayMode; out result: Integer): HResult; stdcall;
    function GetVideoInputModeIterator(out iterator: IDeckLinkDisplayModeIterator): HResult; stdcall;
    function SetVideoInputMode(inputMode: _BMDDisplayMode): HResult; stdcall;
    function GetCurrentDetectedVideoInputMode(out detectedMode: _BMDDisplayMode): HResult; stdcall;
    function GetVideoEncodingMode(out encodingMode: IBMDStreamingVideoEncodingMode): HResult; stdcall;
    function GetVideoEncodingModePresetIterator(inputMode: _BMDDisplayMode; 
                                                out iterator: IBMDStreamingVideoEncodingModePresetIterator): HResult; stdcall;
    function DoesSupportVideoEncodingMode(inputMode: _BMDDisplayMode; 
                                          const encodingMode: IBMDStreamingVideoEncodingMode; 
                                          out result: _BMDStreamingEncodingSupport; 
                                          out changedEncodingMode: IBMDStreamingVideoEncodingMode): HResult; stdcall;
    function SetVideoEncodingMode(const encodingMode: IBMDStreamingVideoEncodingMode): HResult; stdcall;
    function StartCapture: HResult; stdcall;
    function StopCapture: HResult; stdcall;
    function SetCallback(const theCallback: IUnknown): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IBMDStreamingH264NALParser
// Flags:     (0)
// GUID:      {5867F18C-5BFA-4CCC-B2A7-9DFD140417D2}
// *********************************************************************//
  IBMDStreamingH264NALParser = interface(IUnknown)
    ['{5867F18C-5BFA-4CCC-B2A7-9DFD140417D2}']
    function IsNALSequenceParameterSet(const nal: IBMDStreamingH264NALPacket): HResult; stdcall;
    function IsNALPictureParameterSet(const nal: IBMDStreamingH264NALPacket): HResult; stdcall;
    function GetProfileAndLevelFromSPS(const nal: IBMDStreamingH264NALPacket; 
                                       out profileIdc: LongWord; 
                                       out profileCompatability: LongWord; out levelIdc: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkVideoOutputCallback
// Flags:     (0)
// GUID:      {20AA5225-1958-47CB-820B-80A8D521A6EE}
// *********************************************************************//
  IDeckLinkVideoOutputCallback = interface(IUnknown)
    ['{20AA5225-1958-47CB-820B-80A8D521A6EE}']
    function ScheduledFrameCompleted(const completedFrame: IDeckLinkVideoFrame; 
                                     result: _BMDOutputFrameCompletionResult): HResult; stdcall;
    function ScheduledPlaybackHasStopped: HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkVideoFrame
// Flags:     (0)
// GUID:      {3F716FE0-F023-4111-BE5D-EF4414C05B17}
// *********************************************************************//
  IDeckLinkVideoFrame = interface(IUnknown)
    ['{3F716FE0-F023-4111-BE5D-EF4414C05B17}']
    function GetWidth: Integer; stdcall;
    function GetHeight: Integer; stdcall;
    function GetRowBytes: Integer; stdcall;
    function GetPixelFormat: _BMDPixelFormat; stdcall;
    function GetFlags: _BMDFrameFlags; stdcall;
    function GetBytes(out buffer: Pointer): HResult; stdcall;
    function GetTimecode(format: _BMDTimecodeFormat; out timecode: IDeckLinkTimecode): HResult; stdcall;
    function GetAncillaryData(out ancillary: IDeckLinkVideoFrameAncillary): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkVideoFrameAncillary
// Flags:     (0)
// GUID:      {732E723C-D1A4-4E29-9E8E-4A88797A0004}
// *********************************************************************//
  IDeckLinkVideoFrameAncillary = interface(IUnknown)
    ['{732E723C-D1A4-4E29-9E8E-4A88797A0004}']
    function GetBufferForVerticalBlankingLine(lineNumber: LongWord; out buffer: Pointer): HResult; stdcall;
    function GetPixelFormat: _BMDPixelFormat; stdcall;
    function GetDisplayMode: _BMDDisplayMode; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkInputCallback
// Flags:     (0)
// GUID:      {DD04E5EC-7415-42AB-AE4A-E80C4DFC044A}
// *********************************************************************//
  IDeckLinkInputCallback = interface(IUnknown)
    ['{DD04E5EC-7415-42AB-AE4A-E80C4DFC044A}']
    function VideoInputFormatChanged(notificationEvents: _BMDVideoInputFormatChangedEvents; 
                                     const newDisplayMode: IDeckLinkDisplayMode; 
                                     detectedSignalFlags: _BMDDetectedVideoInputFormatFlags): HResult; stdcall;
    function VideoInputFrameArrived(const videoFrame: IDeckLinkVideoInputFrame; 
                                    const audioPacket: IDeckLinkAudioInputPacket): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkVideoInputFrame
// Flags:     (0)
// GUID:      {05CFE374-537C-4094-9A57-680525118F44}
// *********************************************************************//
  IDeckLinkVideoInputFrame = interface(IDeckLinkVideoFrame)
    ['{05CFE374-537C-4094-9A57-680525118F44}']
    function GetStreamTime(out frameTime: Int64; out frameDuration: Int64; timeScale: Int64): HResult; stdcall;
    function GetHardwareReferenceTimestamp(timeScale: Int64; out frameTime: Int64; 
                                           out frameDuration: Int64): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkAudioInputPacket
// Flags:     (0)
// GUID:      {E43D5870-2894-11DE-8C30-0800200C9A66}
// *********************************************************************//
  IDeckLinkAudioInputPacket = interface(IUnknown)
    ['{E43D5870-2894-11DE-8C30-0800200C9A66}']
    function GetSampleFrameCount: Integer; stdcall;
    function GetBytes(out buffer: Pointer): HResult; stdcall;
    function GetPacketTime(out packetTime: Int64; timeScale: Int64): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkMemoryAllocator
// Flags:     (0)
// GUID:      {B36EB6E7-9D29-4AA8-92EF-843B87A289E8}
// *********************************************************************//
  IDeckLinkMemoryAllocator = interface(IUnknown)
    ['{B36EB6E7-9D29-4AA8-92EF-843B87A289E8}']
    function AllocateBuffer(bufferSize: LongWord; out allocatedBuffer: Pointer): HResult; stdcall;
    function ReleaseBuffer(buffer: Pointer): HResult; stdcall;
    function Commit: HResult; stdcall;
    function Decommit: HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkAudioOutputCallback
// Flags:     (0)
// GUID:      {403C681B-7F46-4A12-B993-2BB127084EE6}
// *********************************************************************//
  IDeckLinkAudioOutputCallback = interface(IUnknown)
    ['{403C681B-7F46-4A12-B993-2BB127084EE6}']
    function RenderAudioSamples(preroll: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkIterator
// Flags:     (0)
// GUID:      {50FB36CD-3063-4B73-BDBB-958087F2D8BA}
// *********************************************************************//
  IDeckLinkIterator = interface(IUnknown)
    ['{50FB36CD-3063-4B73-BDBB-958087F2D8BA}']
    function Next(out deckLinkInstance: IDeckLink): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkAPIInformation
// Flags:     (0)
// GUID:      {7BEA3C68-730D-4322-AF34-8A7152B532A4}
// *********************************************************************//
  IDeckLinkAPIInformation = interface(IUnknown)
    ['{7BEA3C68-730D-4322-AF34-8A7152B532A4}']
    function GetFlag(cfgID: _BMDDeckLinkAPIInformationID; out value: Integer): HResult; stdcall;
    function GetInt(cfgID: _BMDDeckLinkAPIInformationID; out value: Int64): HResult; stdcall;
    function GetFloat(cfgID: _BMDDeckLinkAPIInformationID; out value: Double): HResult; stdcall;
    function GetString(cfgID: _BMDDeckLinkAPIInformationID; out value: WideString): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkOutput
// Flags:     (0)
// GUID:      {A3EF0963-0862-44ED-92A9-EE89ABF431C7}
// *********************************************************************//
  IDeckLinkOutput = interface(IUnknown)
    ['{A3EF0963-0862-44ED-92A9-EE89ABF431C7}']
    function DoesSupportVideoMode(displayMode: _BMDDisplayMode; pixelFormat: _BMDPixelFormat; 
                                  flags: _BMDVideoOutputFlags; out result: _BMDDisplayModeSupport; 
                                  out resultDisplayMode: IDeckLinkDisplayMode): HResult; stdcall;
    function GetDisplayModeIterator(out iterator: IDeckLinkDisplayModeIterator): HResult; stdcall;
    function SetScreenPreviewCallback(const previewCallback: IDeckLinkScreenPreviewCallback): HResult; stdcall;
    function EnableVideoOutput(displayMode: _BMDDisplayMode; flags: _BMDVideoOutputFlags): HResult; stdcall;
    function DisableVideoOutput: HResult; stdcall;
    function SetVideoOutputFrameMemoryAllocator(const theAllocator: IDeckLinkMemoryAllocator): HResult; stdcall;
    function CreateVideoFrame(width: Integer; height: Integer; rowBytes: Integer; 
                              pixelFormat: _BMDPixelFormat; flags: _BMDFrameFlags; 
                              out outFrame: IDeckLinkMutableVideoFrame): HResult; stdcall;
    function CreateAncillaryData(pixelFormat: _BMDPixelFormat; 
                                 out outBuffer: IDeckLinkVideoFrameAncillary): HResult; stdcall;
    function DisplayVideoFrameSync(const theFrame: IDeckLinkVideoFrame): HResult; stdcall;
    function ScheduleVideoFrame(const theFrame: IDeckLinkVideoFrame; displayTime: Int64; 
                                displayDuration: Int64; timeScale: Int64): HResult; stdcall;
    function SetScheduledFrameCompletionCallback(const theCallback: IDeckLinkVideoOutputCallback): HResult; stdcall;
    function GetBufferedVideoFrameCount(out bufferedFrameCount: LongWord): HResult; stdcall;
    function EnableAudioOutput(sampleRate: _BMDAudioSampleRate; sampleType: _BMDAudioSampleType; 
                               channelCount: LongWord; streamType: _BMDAudioOutputStreamType): HResult; stdcall;
    function DisableAudioOutput: HResult; stdcall;
    function WriteAudioSamplesSync(buffer: Pointer; sampleFrameCount: LongWord; 
                                   out sampleFramesWritten: LongWord): HResult; stdcall;
    function BeginAudioPreroll: HResult; stdcall;
    function EndAudioPreroll: HResult; stdcall;
    function ScheduleAudioSamples(buffer: Pointer; sampleFrameCount: LongWord; streamTime: Int64; 
                                  timeScale: Int64; out sampleFramesWritten: LongWord): HResult; stdcall;
    function GetBufferedAudioSampleFrameCount(out bufferedSampleFrameCount: LongWord): HResult; stdcall;
    function FlushBufferedAudioSamples: HResult; stdcall;
    function SetAudioCallback(const theCallback: IDeckLinkAudioOutputCallback): HResult; stdcall;
    function StartScheduledPlayback(playbackStartTime: Int64; timeScale: Int64; 
                                    playbackSpeed: Double): HResult; stdcall;
    function StopScheduledPlayback(stopPlaybackAtTime: Int64; out actualStopTime: Int64; 
                                   timeScale: Int64): HResult; stdcall;
    function IsScheduledPlaybackRunning(out active: Integer): HResult; stdcall;
    function GetScheduledStreamTime(desiredTimeScale: Int64; out streamTime: Int64; 
                                    out playbackSpeed: Double): HResult; stdcall;
    function GetReferenceStatus(out referenceStatus: _BMDReferenceStatus): HResult; stdcall;
    function GetHardwareReferenceClock(desiredTimeScale: Int64; out hardwareTime: Int64; 
                                       out timeInFrame: Int64; out ticksPerFrame: Int64): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkScreenPreviewCallback
// Flags:     (0)
// GUID:      {B1D3F49A-85FE-4C5D-95C8-0B5D5DCCD438}
// *********************************************************************//
  IDeckLinkScreenPreviewCallback = interface(IUnknown)
    ['{B1D3F49A-85FE-4C5D-95C8-0B5D5DCCD438}']
    function DrawFrame(const theFrame: IDeckLinkVideoFrame): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkMutableVideoFrame
// Flags:     (0)
// GUID:      {69E2639F-40DA-4E19-B6F2-20ACE815C390}
// *********************************************************************//
  IDeckLinkMutableVideoFrame = interface(IDeckLinkVideoFrame)
    ['{69E2639F-40DA-4E19-B6F2-20ACE815C390}']
    function SetFlags(newFlags: _BMDFrameFlags): HResult; stdcall;
    function SetTimecode(format: _BMDTimecodeFormat; const timecode: IDeckLinkTimecode): HResult; stdcall;
    function SetTimecodeFromComponents(format: _BMDTimecodeFormat; hours: Byte; minutes: Byte; 
                                       seconds: Byte; frames: Byte; flags: _BMDTimecodeFlags): HResult; stdcall;
    function SetAncillaryData(const ancillary: IDeckLinkVideoFrameAncillary): HResult; stdcall;
    function SetTimecodeUserBits(format: _BMDTimecodeFormat; userBits: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkInput
// Flags:     (0)
// GUID:      {AF22762B-DFAC-4846-AA79-FA8883560995}
// *********************************************************************//
  IDeckLinkInput = interface(IUnknown)
    ['{AF22762B-DFAC-4846-AA79-FA8883560995}']
    function DoesSupportVideoMode(displayMode: _BMDDisplayMode; pixelFormat: _BMDPixelFormat; 
                                  flags: _BMDVideoInputFlags; out result: _BMDDisplayModeSupport; 
                                  out resultDisplayMode: IDeckLinkDisplayMode): HResult; stdcall;
    function GetDisplayModeIterator(out iterator: IDeckLinkDisplayModeIterator): HResult; stdcall;
    function SetScreenPreviewCallback(const previewCallback: IDeckLinkScreenPreviewCallback): HResult; stdcall;
    function EnableVideoInput(displayMode: _BMDDisplayMode; pixelFormat: _BMDPixelFormat; 
                              flags: _BMDVideoInputFlags): HResult; stdcall;
    function DisableVideoInput: HResult; stdcall;
    function GetAvailableVideoFrameCount(out availableFrameCount: LongWord): HResult; stdcall;
    function SetVideoInputFrameMemoryAllocator(const theAllocator: IDeckLinkMemoryAllocator): HResult; stdcall;
    function EnableAudioInput(sampleRate: _BMDAudioSampleRate; sampleType: _BMDAudioSampleType; 
                              channelCount: LongWord): HResult; stdcall;
    function DisableAudioInput: HResult; stdcall;
    function GetAvailableAudioSampleFrameCount(out availableSampleFrameCount: LongWord): HResult; stdcall;
    function StartStreams: HResult; stdcall;
    function StopStreams: HResult; stdcall;
    function PauseStreams: HResult; stdcall;
    function FlushStreams: HResult; stdcall;
    function SetCallback(const theCallback: IDeckLinkInputCallback): HResult; stdcall;
    function GetHardwareReferenceClock(desiredTimeScale: Int64; out hardwareTime: Int64; 
                                       out timeInFrame: Int64; out ticksPerFrame: Int64): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkVideoFrame3DExtensions
// Flags:     (0)
// GUID:      {DA0F7E4A-EDC7-48A8-9CDD-2DB51C729CD7}
// *********************************************************************//
  IDeckLinkVideoFrame3DExtensions = interface(IUnknown)
    ['{DA0F7E4A-EDC7-48A8-9CDD-2DB51C729CD7}']
    function Get3DPackingFormat: _BMDVideo3DPackingFormat; stdcall;
    function GetFrameForRightEye(out rightEyeFrame: IDeckLinkVideoFrame): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkGLScreenPreviewHelper
// Flags:     (0)
// GUID:      {504E2209-CAC7-4C1A-9FB4-C5BB6274D22F}
// *********************************************************************//
  IDeckLinkGLScreenPreviewHelper = interface(IUnknown)
    ['{504E2209-CAC7-4C1A-9FB4-C5BB6274D22F}']
    function InitializeGL: HResult; stdcall;
    function PaintGL: HResult; stdcall;
    function SetFrame(const theFrame: IDeckLinkVideoFrame): HResult; stdcall;
    function Set3DPreviewFormat(previewFormat: _BMD3DPreviewFormat): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkDX9ScreenPreviewHelper
// Flags:     (0)
// GUID:      {2094B522-D1A1-40C0-9AC7-1C012218EF02}
// *********************************************************************//
  IDeckLinkDX9ScreenPreviewHelper = interface(IUnknown)
    ['{2094B522-D1A1-40C0-9AC7-1C012218EF02}']
    function Initialize(device: Pointer): HResult; stdcall;
    function Render(var rc: tagRECT): HResult; stdcall;
    function SetFrame(const theFrame: IDeckLinkVideoFrame): HResult; stdcall;
    function Set3DPreviewFormat(previewFormat: _BMD3DPreviewFormat): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkNotificationCallback
// Flags:     (0)
// GUID:      {B002A1EC-070D-4288-8289-BD5D36E5FF0D}
// *********************************************************************//
  IDeckLinkNotificationCallback = interface(IUnknown)
    ['{B002A1EC-070D-4288-8289-BD5D36E5FF0D}']
    function Notify(topic: _BMDNotifications; param1: Largeuint; param2: Largeuint): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkNotification
// Flags:     (0)
// GUID:      {0A1FB207-E215-441B-9B19-6FA1575946C5}
// *********************************************************************//
  IDeckLinkNotification = interface(IUnknown)
    ['{0A1FB207-E215-441B-9B19-6FA1575946C5}']
    function Subscribe(topic: _BMDNotifications; const theCallback: IDeckLinkNotificationCallback): HResult; stdcall;
    function Unsubscribe(topic: _BMDNotifications; const theCallback: IDeckLinkNotificationCallback): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkAttributes
// Flags:     (0)
// GUID:      {ABC11843-D966-44CB-96E2-A1CB5D3135C4}
// *********************************************************************//
  IDeckLinkAttributes = interface(IUnknown)
    ['{ABC11843-D966-44CB-96E2-A1CB5D3135C4}']
    function GetFlag(cfgID: _BMDDeckLinkAttributeID; out value: Integer): HResult; stdcall;
    function GetInt(cfgID: _BMDDeckLinkAttributeID; out value: Int64): HResult; stdcall;
    function GetFloat(cfgID: _BMDDeckLinkAttributeID; out value: Double): HResult; stdcall;
    function GetString(cfgID: _BMDDeckLinkAttributeID; out value: WideString): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkKeyer
// Flags:     (0)
// GUID:      {89AFCAF5-65F8-421E-98F7-96FE5F5BFBA3}
// *********************************************************************//
  IDeckLinkKeyer = interface(IUnknown)
    ['{89AFCAF5-65F8-421E-98F7-96FE5F5BFBA3}']
    function Enable(isExternal: Integer): HResult; stdcall;
    function SetLevel(level: Byte): HResult; stdcall;
    function RampUp(numberOfFrames: LongWord): HResult; stdcall;
    function RampDown(numberOfFrames: LongWord): HResult; stdcall;
    function Disable: HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkVideoConversion
// Flags:     (0)
// GUID:      {3BBCB8A2-DA2C-42D9-B5D8-88083644E99A}
// *********************************************************************//
  IDeckLinkVideoConversion = interface(IUnknown)
    ['{3BBCB8A2-DA2C-42D9-B5D8-88083644E99A}']
    function ConvertFrame(const srcFrame: IDeckLinkVideoFrame; const dstFrame: IDeckLinkVideoFrame): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkInput_v9_2
// Flags:     (0)
// GUID:      {6D40EF78-28B9-4E21-990D-95BB7750A04F}
// *********************************************************************//
  IDeckLinkInput_v9_2 = interface(IUnknown)
    ['{6D40EF78-28B9-4E21-990D-95BB7750A04F}']
    function DoesSupportVideoMode(displayMode: _BMDDisplayMode; pixelFormat: _BMDPixelFormat; 
                                  flags: _BMDVideoInputFlags; out result: _BMDDisplayModeSupport; 
                                  out resultDisplayMode: IDeckLinkDisplayMode): HResult; stdcall;
    function GetDisplayModeIterator(out iterator: IDeckLinkDisplayModeIterator): HResult; stdcall;
    function SetScreenPreviewCallback(const previewCallback: IDeckLinkScreenPreviewCallback): HResult; stdcall;
    function EnableVideoInput(displayMode: _BMDDisplayMode; pixelFormat: _BMDPixelFormat; 
                              flags: _BMDVideoInputFlags): HResult; stdcall;
    function DisableVideoInput: HResult; stdcall;
    function GetAvailableVideoFrameCount(out availableFrameCount: LongWord): HResult; stdcall;
    function EnableAudioInput(sampleRate: _BMDAudioSampleRate; sampleType: _BMDAudioSampleType; 
                              channelCount: LongWord): HResult; stdcall;
    function DisableAudioInput: HResult; stdcall;
    function GetAvailableAudioSampleFrameCount(out availableSampleFrameCount: LongWord): HResult; stdcall;
    function StartStreams: HResult; stdcall;
    function StopStreams: HResult; stdcall;
    function PauseStreams: HResult; stdcall;
    function FlushStreams: HResult; stdcall;
    function SetCallback(const theCallback: IDeckLinkInputCallback): HResult; stdcall;
    function GetHardwareReferenceClock(desiredTimeScale: Int64; out hardwareTime: Int64; 
                                       out timeInFrame: Int64; out ticksPerFrame: Int64): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkDeckControlStatusCallback_v8_1
// Flags:     (0)
// GUID:      {E5F693C1-4283-4716-B18F-C1431521955B}
// *********************************************************************//
  IDeckLinkDeckControlStatusCallback_v8_1 = interface(IUnknown)
    ['{E5F693C1-4283-4716-B18F-C1431521955B}']
    function TimecodeUpdate(currentTimecode: LongWord): HResult; stdcall;
    function VTRControlStateChanged(newState: _BMDDeckControlVTRControlState_v8_1; 
                                    error: _BMDDeckControlError): HResult; stdcall;
    function DeckControlEventReceived(event: _BMDDeckControlEvent; error: _BMDDeckControlError): HResult; stdcall;
    function DeckControlStatusChanged(flags: _BMDDeckControlStatusFlags; mask: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkDeckControl_v8_1
// Flags:     (0)
// GUID:      {522A9E39-0F3C-4742-94EE-D80DE335DA1D}
// *********************************************************************//
  IDeckLinkDeckControl_v8_1 = interface(IUnknown)
    ['{522A9E39-0F3C-4742-94EE-D80DE335DA1D}']
    function Open(timeScale: Int64; timeValue: Int64; timecodeIsDropFrame: Integer; 
                  out error: _BMDDeckControlError): HResult; stdcall;
    function Close(standbyOn: Integer): HResult; stdcall;
    function GetCurrentState(out mode: _BMDDeckControlMode; 
                             out vtrControlState: _BMDDeckControlVTRControlState_v8_1; 
                             out flags: _BMDDeckControlStatusFlags): HResult; stdcall;
    function SetStandby(standbyOn: Integer): HResult; stdcall;
    function SendCommand(var inBuffer: Byte; inBufferSize: LongWord; out outBuffer: Byte; 
                         out outDataSize: LongWord; outBufferSize: LongWord; 
                         out error: _BMDDeckControlError): HResult; stdcall;
    function Play(out error: _BMDDeckControlError): HResult; stdcall;
    function Stop(out error: _BMDDeckControlError): HResult; stdcall;
    function TogglePlayStop(out error: _BMDDeckControlError): HResult; stdcall;
    function Eject(out error: _BMDDeckControlError): HResult; stdcall;
    function GoToTimecode(timecode: LongWord; out error: _BMDDeckControlError): HResult; stdcall;
    function FastForward(viewTape: Integer; out error: _BMDDeckControlError): HResult; stdcall;
    function Rewind(viewTape: Integer; out error: _BMDDeckControlError): HResult; stdcall;
    function StepForward(out error: _BMDDeckControlError): HResult; stdcall;
    function StepBack(out error: _BMDDeckControlError): HResult; stdcall;
    function Jog(rate: Double; out error: _BMDDeckControlError): HResult; stdcall;
    function Shuttle(rate: Double; out error: _BMDDeckControlError): HResult; stdcall;
    function GetTimecodeString(out currentTimecode: WideString; out error: _BMDDeckControlError): HResult; stdcall;
    function GetTimecode(out currentTimecode: IDeckLinkTimecode; out error: _BMDDeckControlError): HResult; stdcall;
    function GetTimecodeBCD(out currentTimecode: LongWord; out error: _BMDDeckControlError): HResult; stdcall;
    function SetPreroll(prerollSeconds: LongWord): HResult; stdcall;
    function GetPreroll(out prerollSeconds: LongWord): HResult; stdcall;
    function SetExportOffset(exportOffsetFields: Integer): HResult; stdcall;
    function GetExportOffset(out exportOffsetFields: Integer): HResult; stdcall;
    function GetManualExportOffset(out deckManualExportOffsetFields: Integer): HResult; stdcall;
    function SetCaptureOffset(captureOffsetFields: Integer): HResult; stdcall;
    function GetCaptureOffset(out captureOffsetFields: Integer): HResult; stdcall;
    function StartExport(inTimecode: LongWord; outTimecode: LongWord; 
                         exportModeOps: _BMDDeckControlExportModeOpsFlags; 
                         out error: _BMDDeckControlError): HResult; stdcall;
    function StartCapture(useVITC: Integer; inTimecode: LongWord; outTimecode: LongWord; 
                          out error: _BMDDeckControlError): HResult; stdcall;
    function GetDeviceID(out deviceId: Word; out error: _BMDDeckControlError): HResult; stdcall;
    function Abort: HResult; stdcall;
    function CrashRecordStart(out error: _BMDDeckControlError): HResult; stdcall;
    function CrashRecordStop(out error: _BMDDeckControlError): HResult; stdcall;
    function SetCallback(const callback: IDeckLinkDeckControlStatusCallback_v8_1): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLink_v8_0
// Flags:     (0)
// GUID:      {62BFF75D-6569-4E55-8D4D-66AA03829ABC}
// *********************************************************************//
  IDeckLink_v8_0 = interface(IUnknown)
    ['{62BFF75D-6569-4E55-8D4D-66AA03829ABC}']
    function GetModelName(out modelName: WideString): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkIterator_v8_0
// Flags:     (0)
// GUID:      {74E936FC-CC28-4A67-81A0-1E94E52D4E69}
// *********************************************************************//
  IDeckLinkIterator_v8_0 = interface(IUnknown)
    ['{74E936FC-CC28-4A67-81A0-1E94E52D4E69}']
    function Next(out deckLinkInstance: IDeckLink_v8_0): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkDeckControl_v7_9
// Flags:     (0)
// GUID:      {A4D81043-0619-42B7-8ED6-602D29041DF7}
// *********************************************************************//
  IDeckLinkDeckControl_v7_9 = interface(IUnknown)
    ['{A4D81043-0619-42B7-8ED6-602D29041DF7}']
    function Open(timeScale: Int64; timeValue: Int64; timecodeIsDropFrame: Integer; 
                  out error: _BMDDeckControlError): HResult; stdcall;
    function Close(standbyOn: Integer): HResult; stdcall;
    function GetCurrentState(out mode: _BMDDeckControlMode; 
                             out vtrControlState: _BMDDeckControlVTRControlState; 
                             out flags: _BMDDeckControlStatusFlags): HResult; stdcall;
    function SetStandby(standbyOn: Integer): HResult; stdcall;
    function Play(out error: _BMDDeckControlError): HResult; stdcall;
    function Stop(out error: _BMDDeckControlError): HResult; stdcall;
    function TogglePlayStop(out error: _BMDDeckControlError): HResult; stdcall;
    function Eject(out error: _BMDDeckControlError): HResult; stdcall;
    function GoToTimecode(timecode: LongWord; out error: _BMDDeckControlError): HResult; stdcall;
    function FastForward(viewTape: Integer; out error: _BMDDeckControlError): HResult; stdcall;
    function Rewind(viewTape: Integer; out error: _BMDDeckControlError): HResult; stdcall;
    function StepForward(out error: _BMDDeckControlError): HResult; stdcall;
    function StepBack(out error: _BMDDeckControlError): HResult; stdcall;
    function Jog(rate: Double; out error: _BMDDeckControlError): HResult; stdcall;
    function Shuttle(rate: Double; out error: _BMDDeckControlError): HResult; stdcall;
    function GetTimecodeString(out currentTimecode: WideString; out error: _BMDDeckControlError): HResult; stdcall;
    function GetTimecode(out currentTimecode: IDeckLinkTimecode; out error: _BMDDeckControlError): HResult; stdcall;
    function GetTimecodeBCD(out currentTimecode: LongWord; out error: _BMDDeckControlError): HResult; stdcall;
    function SetPreroll(prerollSeconds: LongWord): HResult; stdcall;
    function GetPreroll(out prerollSeconds: LongWord): HResult; stdcall;
    function SetExportOffset(exportOffsetFields: Integer): HResult; stdcall;
    function GetExportOffset(out exportOffsetFields: Integer): HResult; stdcall;
    function GetManualExportOffset(out deckManualExportOffsetFields: Integer): HResult; stdcall;
    function SetCaptureOffset(captureOffsetFields: Integer): HResult; stdcall;
    function GetCaptureOffset(out captureOffsetFields: Integer): HResult; stdcall;
    function StartExport(inTimecode: LongWord; outTimecode: LongWord; 
                         exportModeOps: _BMDDeckControlExportModeOpsFlags; 
                         out error: _BMDDeckControlError): HResult; stdcall;
    function StartCapture(useVITC: Integer; inTimecode: LongWord; outTimecode: LongWord; 
                          out error: _BMDDeckControlError): HResult; stdcall;
    function GetDeviceID(out deviceId: Word; out error: _BMDDeckControlError): HResult; stdcall;
    function Abort: HResult; stdcall;
    function CrashRecordStart(out error: _BMDDeckControlError): HResult; stdcall;
    function CrashRecordStop(out error: _BMDDeckControlError): HResult; stdcall;
    function SetCallback(const callback: IDeckLinkDeckControlStatusCallback): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkDisplayModeIterator_v7_6
// Flags:     (0)
// GUID:      {455D741F-1779-4800-86F5-0B5D13D79751}
// *********************************************************************//
  IDeckLinkDisplayModeIterator_v7_6 = interface(IUnknown)
    ['{455D741F-1779-4800-86F5-0B5D13D79751}']
    function Next(out deckLinkDisplayMode: IDeckLinkDisplayMode_v7_6): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkDisplayMode_v7_6
// Flags:     (0)
// GUID:      {87451E84-2B7E-439E-A629-4393EA4A8550}
// *********************************************************************//
  IDeckLinkDisplayMode_v7_6 = interface(IUnknown)
    ['{87451E84-2B7E-439E-A629-4393EA4A8550}']
    function GetName(out name: WideString): HResult; stdcall;
    function GetDisplayMode: _BMDDisplayMode; stdcall;
    function GetWidth: Integer; stdcall;
    function GetHeight: Integer; stdcall;
    function GetFrameRate(out frameDuration: Int64; out timeScale: Int64): HResult; stdcall;
    function GetFieldDominance: _BMDFieldDominance; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkOutput_v7_6
// Flags:     (0)
// GUID:      {29228142-EB8C-4141-A621-F74026450955}
// *********************************************************************//
  IDeckLinkOutput_v7_6 = interface(IUnknown)
    ['{29228142-EB8C-4141-A621-F74026450955}']
    function DoesSupportVideoMode(displayMode: _BMDDisplayMode; pixelFormat: _BMDPixelFormat; 
                                  out result: _BMDDisplayModeSupport): HResult; stdcall;
    function GetDisplayModeIterator(out iterator: IDeckLinkDisplayModeIterator_v7_6): HResult; stdcall;
    function SetScreenPreviewCallback(const previewCallback: IDeckLinkScreenPreviewCallback_v7_6): HResult; stdcall;
    function EnableVideoOutput(displayMode: _BMDDisplayMode; flags: _BMDVideoOutputFlags): HResult; stdcall;
    function DisableVideoOutput: HResult; stdcall;
    function SetVideoOutputFrameMemoryAllocator(const theAllocator: IDeckLinkMemoryAllocator): HResult; stdcall;
    function CreateVideoFrame(width: Integer; height: Integer; rowBytes: Integer; 
                              pixelFormat: _BMDPixelFormat; flags: _BMDFrameFlags; 
                              out outFrame: IDeckLinkMutableVideoFrame_v7_6): HResult; stdcall;
    function CreateAncillaryData(pixelFormat: _BMDPixelFormat; 
                                 out outBuffer: IDeckLinkVideoFrameAncillary): HResult; stdcall;
    function DisplayVideoFrameSync(const theFrame: IDeckLinkVideoFrame_v7_6): HResult; stdcall;
    function ScheduleVideoFrame(const theFrame: IDeckLinkVideoFrame_v7_6; displayTime: Int64; 
                                displayDuration: Int64; timeScale: Int64): HResult; stdcall;
    function SetScheduledFrameCompletionCallback(const theCallback: IDeckLinkVideoOutputCallback_v7_6): HResult; stdcall;
    function GetBufferedVideoFrameCount(out bufferedFrameCount: LongWord): HResult; stdcall;
    function EnableAudioOutput(sampleRate: _BMDAudioSampleRate; sampleType: _BMDAudioSampleType; 
                               channelCount: LongWord; streamType: _BMDAudioOutputStreamType): HResult; stdcall;
    function DisableAudioOutput: HResult; stdcall;
    function WriteAudioSamplesSync(buffer: Pointer; sampleFrameCount: LongWord; 
                                   out sampleFramesWritten: LongWord): HResult; stdcall;
    function BeginAudioPreroll: HResult; stdcall;
    function EndAudioPreroll: HResult; stdcall;
    function ScheduleAudioSamples(buffer: Pointer; sampleFrameCount: LongWord; streamTime: Int64; 
                                  timeScale: Int64; out sampleFramesWritten: LongWord): HResult; stdcall;
    function GetBufferedAudioSampleFrameCount(out bufferedSampleFrameCount: LongWord): HResult; stdcall;
    function FlushBufferedAudioSamples: HResult; stdcall;
    function SetAudioCallback(const theCallback: IDeckLinkAudioOutputCallback): HResult; stdcall;
    function StartScheduledPlayback(playbackStartTime: Int64; timeScale: Int64; 
                                    playbackSpeed: Double): HResult; stdcall;
    function StopScheduledPlayback(stopPlaybackAtTime: Int64; out actualStopTime: Int64; 
                                   timeScale: Int64): HResult; stdcall;
    function IsScheduledPlaybackRunning(out active: Integer): HResult; stdcall;
    function GetScheduledStreamTime(desiredTimeScale: Int64; out streamTime: Int64; 
                                    out playbackSpeed: Double): HResult; stdcall;
    function GetHardwareReferenceClock(desiredTimeScale: Int64; out hardwareTime: Int64; 
                                       out timeInFrame: Int64; out ticksPerFrame: Int64): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkScreenPreviewCallback_v7_6
// Flags:     (0)
// GUID:      {373F499D-4B4D-4518-AD22-6354E5A5825E}
// *********************************************************************//
  IDeckLinkScreenPreviewCallback_v7_6 = interface(IUnknown)
    ['{373F499D-4B4D-4518-AD22-6354E5A5825E}']
    function DrawFrame(const theFrame: IDeckLinkVideoFrame_v7_6): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkVideoFrame_v7_6
// Flags:     (0)
// GUID:      {A8D8238E-6B18-4196-99E1-5AF717B83D32}
// *********************************************************************//
  IDeckLinkVideoFrame_v7_6 = interface(IUnknown)
    ['{A8D8238E-6B18-4196-99E1-5AF717B83D32}']
    function GetWidth: Integer; stdcall;
    function GetHeight: Integer; stdcall;
    function GetRowBytes: Integer; stdcall;
    function GetPixelFormat: _BMDPixelFormat; stdcall;
    function GetFlags: _BMDFrameFlags; stdcall;
    function GetBytes(out buffer: Pointer): HResult; stdcall;
    function GetTimecode(format: _BMDTimecodeFormat; out timecode: IDeckLinkTimecode_v7_6): HResult; stdcall;
    function GetAncillaryData(out ancillary: IDeckLinkVideoFrameAncillary): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkTimecode_v7_6
// Flags:     (0)
// GUID:      {EFB9BCA6-A521-44F7-BD69-2332F24D9EE6}
// *********************************************************************//
  IDeckLinkTimecode_v7_6 = interface(IUnknown)
    ['{EFB9BCA6-A521-44F7-BD69-2332F24D9EE6}']
    function GetBCD: LongWord; stdcall;
    function GetComponents(out hours: Byte; out minutes: Byte; out seconds: Byte; out frames: Byte): HResult; stdcall;
    function GetString(out timecode: WideString): HResult; stdcall;
    function GetFlags: _BMDTimecodeFlags; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkMutableVideoFrame_v7_6
// Flags:     (0)
// GUID:      {46FCEE00-B4E6-43D0-91C0-023A7FCEB34F}
// *********************************************************************//
  IDeckLinkMutableVideoFrame_v7_6 = interface(IDeckLinkVideoFrame_v7_6)
    ['{46FCEE00-B4E6-43D0-91C0-023A7FCEB34F}']
    function SetFlags(newFlags: _BMDFrameFlags): HResult; stdcall;
    function SetTimecode(format: _BMDTimecodeFormat; const timecode: IDeckLinkTimecode_v7_6): HResult; stdcall;
    function SetTimecodeFromComponents(format: _BMDTimecodeFormat; hours: Byte; minutes: Byte; 
                                       seconds: Byte; frames: Byte; flags: _BMDTimecodeFlags): HResult; stdcall;
    function SetAncillaryData(const ancillary: IDeckLinkVideoFrameAncillary): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkVideoOutputCallback_v7_6
// Flags:     (0)
// GUID:      {E763A626-4A3C-49D1-BF13-E7AD3692AE52}
// *********************************************************************//
  IDeckLinkVideoOutputCallback_v7_6 = interface(IUnknown)
    ['{E763A626-4A3C-49D1-BF13-E7AD3692AE52}']
    function ScheduledFrameCompleted(const completedFrame: IDeckLinkVideoFrame_v7_6; 
                                     result: _BMDOutputFrameCompletionResult): HResult; stdcall;
    function ScheduledPlaybackHasStopped: HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkInput_v7_6
// Flags:     (0)
// GUID:      {300C135A-9F43-48E2-9906-6D7911D93CF1}
// *********************************************************************//
  IDeckLinkInput_v7_6 = interface(IUnknown)
    ['{300C135A-9F43-48E2-9906-6D7911D93CF1}']
    function DoesSupportVideoMode(displayMode: _BMDDisplayMode; pixelFormat: _BMDPixelFormat; 
                                  out result: _BMDDisplayModeSupport): HResult; stdcall;
    function GetDisplayModeIterator(out iterator: IDeckLinkDisplayModeIterator_v7_6): HResult; stdcall;
    function SetScreenPreviewCallback(const previewCallback: IDeckLinkScreenPreviewCallback_v7_6): HResult; stdcall;
    function EnableVideoInput(displayMode: _BMDDisplayMode; pixelFormat: _BMDPixelFormat; 
                              flags: _BMDVideoInputFlags): HResult; stdcall;
    function DisableVideoInput: HResult; stdcall;
    function GetAvailableVideoFrameCount(out availableFrameCount: LongWord): HResult; stdcall;
    function EnableAudioInput(sampleRate: _BMDAudioSampleRate; sampleType: _BMDAudioSampleType; 
                              channelCount: LongWord): HResult; stdcall;
    function DisableAudioInput: HResult; stdcall;
    function GetAvailableAudioSampleFrameCount(out availableSampleFrameCount: LongWord): HResult; stdcall;
    function StartStreams: HResult; stdcall;
    function StopStreams: HResult; stdcall;
    function PauseStreams: HResult; stdcall;
    function FlushStreams: HResult; stdcall;
    function SetCallback(const theCallback: IDeckLinkInputCallback_v7_6): HResult; stdcall;
    function GetHardwareReferenceClock(desiredTimeScale: Int64; out hardwareTime: Int64; 
                                       out timeInFrame: Int64; out ticksPerFrame: Int64): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkInputCallback_v7_6
// Flags:     (0)
// GUID:      {31D28EE7-88B6-4CB1-897A-CDBF79A26414}
// *********************************************************************//
  IDeckLinkInputCallback_v7_6 = interface(IUnknown)
    ['{31D28EE7-88B6-4CB1-897A-CDBF79A26414}']
    function VideoInputFormatChanged(notificationEvents: _BMDVideoInputFormatChangedEvents; 
                                     const newDisplayMode: IDeckLinkDisplayMode_v7_6; 
                                     detectedSignalFlags: _BMDDetectedVideoInputFormatFlags): HResult; stdcall;
    function VideoInputFrameArrived(const videoFrame: IDeckLinkVideoInputFrame_v7_6; 
                                    const audioPacket: IDeckLinkAudioInputPacket): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkVideoInputFrame_v7_6
// Flags:     (0)
// GUID:      {9A74FA41-AE9F-47AC-8CF4-01F42DD59965}
// *********************************************************************//
  IDeckLinkVideoInputFrame_v7_6 = interface(IDeckLinkVideoFrame_v7_6)
    ['{9A74FA41-AE9F-47AC-8CF4-01F42DD59965}']
    function GetStreamTime(out frameTime: Int64; out frameDuration: Int64; timeScale: Int64): HResult; stdcall;
    function GetHardwareReferenceTimestamp(timeScale: Int64; out frameTime: Int64; 
                                           out frameDuration: Int64): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkGLScreenPreviewHelper_v7_6
// Flags:     (0)
// GUID:      {BA575CD9-A15E-497B-B2C2-F9AFE7BE4EBA}
// *********************************************************************//
  IDeckLinkGLScreenPreviewHelper_v7_6 = interface(IUnknown)
    ['{BA575CD9-A15E-497B-B2C2-F9AFE7BE4EBA}']
    function InitializeGL: HResult; stdcall;
    function PaintGL: HResult; stdcall;
    function SetFrame(const theFrame: IDeckLinkVideoFrame_v7_6): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkVideoConversion_v7_6
// Flags:     (0)
// GUID:      {3EB504C9-F97D-40FE-A158-D407D48CB53B}
// *********************************************************************//
  IDeckLinkVideoConversion_v7_6 = interface(IUnknown)
    ['{3EB504C9-F97D-40FE-A158-D407D48CB53B}']
    function ConvertFrame(const srcFrame: IDeckLinkVideoFrame_v7_6; 
                          const dstFrame: IDeckLinkVideoFrame_v7_6): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkConfiguration_v7_6
// Flags:     (0)
// GUID:      {B8EAD569-B764-47F0-A73F-AE40DF6CBF10}
// *********************************************************************//
  IDeckLinkConfiguration_v7_6 = interface(IUnknown)
    ['{B8EAD569-B764-47F0-A73F-AE40DF6CBF10}']
    function GetConfigurationValidator(out configObject: IDeckLinkConfiguration_v7_6): HResult; stdcall;
    function WriteConfigurationToPreferences: HResult; stdcall;
    function SetVideoOutputFormat(videoOutputConnection: _BMDVideoConnection_v7_6): HResult; stdcall;
    function IsVideoOutputActive(videoOutputConnection: _BMDVideoConnection_v7_6; 
                                 out active: Integer): HResult; stdcall;
    function SetAnalogVideoOutputFlags(analogVideoFlags: _BMDAnalogVideoFlags): HResult; stdcall;
    function GetAnalogVideoOutputFlags(out analogVideoFlags: _BMDAnalogVideoFlags): HResult; stdcall;
    function EnableFieldFlickerRemovalWhenPaused(Enable: Integer): HResult; stdcall;
    function IsEnabledFieldFlickerRemovalWhenPaused(out enabled: Integer): HResult; stdcall;
    function Set444And3GBpsVideoOutput(enable444VideoOutput: Integer; enable3GbsOutput: Integer): HResult; stdcall;
    function Get444And3GBpsVideoOutput(out is444VideoOutputEnabled: Integer; 
                                       out threeGbsOutputEnabled: Integer): HResult; stdcall;
    function SetVideoOutputConversionMode(conversionMode: _BMDVideoOutputConversionMode): HResult; stdcall;
    function GetVideoOutputConversionMode(out conversionMode: _BMDVideoOutputConversionMode): HResult; stdcall;
    function Set_HD1080p24_to_HD1080i5994_Conversion(Enable: Integer): HResult; stdcall;
    function Get_HD1080p24_to_HD1080i5994_Conversion(out enabled: Integer): HResult; stdcall;
    function SetVideoInputFormat(videoInputFormat: _BMDVideoConnection_v7_6): HResult; stdcall;
    function GetVideoInputFormat(out videoInputFormat: _BMDVideoConnection_v7_6): HResult; stdcall;
    function SetAnalogVideoInputFlags(analogVideoFlags: _BMDAnalogVideoFlags): HResult; stdcall;
    function GetAnalogVideoInputFlags(out analogVideoFlags: _BMDAnalogVideoFlags): HResult; stdcall;
    function SetVideoInputConversionMode(conversionMode: _BMDVideoInputConversionMode): HResult; stdcall;
    function GetVideoInputConversionMode(out conversionMode: _BMDVideoInputConversionMode): HResult; stdcall;
    function SetBlackVideoOutputDuringCapture(blackOutInCapture: Integer): HResult; stdcall;
    function GetBlackVideoOutputDuringCapture(out blackOutInCapture: Integer): HResult; stdcall;
    function Set32PulldownSequenceInitialTimecodeFrame(aFrameTimecode: LongWord): HResult; stdcall;
    function Get32PulldownSequenceInitialTimecodeFrame(out aFrameTimecode: LongWord): HResult; stdcall;
    function SetVancSourceLineMapping(activeLine1VANCsource: LongWord; 
                                      activeLine2VANCsource: LongWord; 
                                      activeLine3VANCsource: LongWord): HResult; stdcall;
    function GetVancSourceLineMapping(out activeLine1VANCsource: LongWord; 
                                      out activeLine2VANCsource: LongWord; 
                                      out activeLine3VANCsource: LongWord): HResult; stdcall;
    function SetAudioInputFormat(audioInputFormat: _BMDAudioConnection): HResult; stdcall;
    function GetAudioInputFormat(out audioInputFormat: _BMDAudioConnection): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkInputCallback_v7_3
// Flags:     (0)
// GUID:      {FD6F311D-4D00-444B-9ED4-1F25B5730AD0}
// *********************************************************************//
  IDeckLinkInputCallback_v7_3 = interface(IUnknown)
    ['{FD6F311D-4D00-444B-9ED4-1F25B5730AD0}']
    function VideoInputFormatChanged(notificationEvents: _BMDVideoInputFormatChangedEvents; 
                                     const newDisplayMode: IDeckLinkDisplayMode_v7_6; 
                                     detectedSignalFlags: _BMDDetectedVideoInputFormatFlags): HResult; stdcall;
    function VideoInputFrameArrived(const videoFrame: IDeckLinkVideoInputFrame_v7_3; 
                                    const audioPacket: IDeckLinkAudioInputPacket): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkVideoInputFrame_v7_3
// Flags:     (0)
// GUID:      {CF317790-2894-11DE-8C30-0800200C9A66}
// *********************************************************************//
  IDeckLinkVideoInputFrame_v7_3 = interface(IDeckLinkVideoFrame_v7_6)
    ['{CF317790-2894-11DE-8C30-0800200C9A66}']
    function GetStreamTime(out frameTime: Int64; out frameDuration: Int64; timeScale: Int64): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkOutput_v7_3
// Flags:     (0)
// GUID:      {271C65E3-C323-4344-A30F-D908BCB20AA3}
// *********************************************************************//
  IDeckLinkOutput_v7_3 = interface(IUnknown)
    ['{271C65E3-C323-4344-A30F-D908BCB20AA3}']
    function DoesSupportVideoMode(displayMode: _BMDDisplayMode; pixelFormat: _BMDPixelFormat; 
                                  out result: _BMDDisplayModeSupport): HResult; stdcall;
    function GetDisplayModeIterator(out iterator: IDeckLinkDisplayModeIterator_v7_6): HResult; stdcall;
    function SetScreenPreviewCallback(const previewCallback: IDeckLinkScreenPreviewCallback): HResult; stdcall;
    function EnableVideoOutput(displayMode: _BMDDisplayMode; flags: _BMDVideoOutputFlags): HResult; stdcall;
    function DisableVideoOutput: HResult; stdcall;
    function SetVideoOutputFrameMemoryAllocator(const theAllocator: IDeckLinkMemoryAllocator): HResult; stdcall;
    function CreateVideoFrame(width: Integer; height: Integer; rowBytes: Integer; 
                              pixelFormat: _BMDPixelFormat; flags: _BMDFrameFlags; 
                              out outFrame: IDeckLinkMutableVideoFrame_v7_6): HResult; stdcall;
    function CreateAncillaryData(pixelFormat: _BMDPixelFormat; 
                                 out outBuffer: IDeckLinkVideoFrameAncillary): HResult; stdcall;
    function DisplayVideoFrameSync(const theFrame: IDeckLinkVideoFrame_v7_6): HResult; stdcall;
    function ScheduleVideoFrame(const theFrame: IDeckLinkVideoFrame_v7_6; displayTime: Int64; 
                                displayDuration: Int64; timeScale: Int64): HResult; stdcall;
    function SetScheduledFrameCompletionCallback(const theCallback: IDeckLinkVideoOutputCallback): HResult; stdcall;
    function GetBufferedVideoFrameCount(out bufferedFrameCount: LongWord): HResult; stdcall;
    function EnableAudioOutput(sampleRate: _BMDAudioSampleRate; sampleType: _BMDAudioSampleType; 
                               channelCount: LongWord; streamType: _BMDAudioOutputStreamType): HResult; stdcall;
    function DisableAudioOutput: HResult; stdcall;
    function WriteAudioSamplesSync(buffer: Pointer; sampleFrameCount: LongWord; 
                                   out sampleFramesWritten: LongWord): HResult; stdcall;
    function BeginAudioPreroll: HResult; stdcall;
    function EndAudioPreroll: HResult; stdcall;
    function ScheduleAudioSamples(buffer: Pointer; sampleFrameCount: LongWord; streamTime: Int64; 
                                  timeScale: Int64; out sampleFramesWritten: LongWord): HResult; stdcall;
    function GetBufferedAudioSampleFrameCount(out bufferedSampleFrameCount: LongWord): HResult; stdcall;
    function FlushBufferedAudioSamples: HResult; stdcall;
    function SetAudioCallback(const theCallback: IDeckLinkAudioOutputCallback): HResult; stdcall;
    function StartScheduledPlayback(playbackStartTime: Int64; timeScale: Int64; 
                                    playbackSpeed: Double): HResult; stdcall;
    function StopScheduledPlayback(stopPlaybackAtTime: Int64; out actualStopTime: Int64; 
                                   timeScale: Int64): HResult; stdcall;
    function IsScheduledPlaybackRunning(out active: Integer): HResult; stdcall;
    function GetHardwareReferenceClock(desiredTimeScale: Int64; 
                                       out elapsedTimeSinceSchedulerBegan: Int64): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkInput_v7_3
// Flags:     (0)
// GUID:      {4973F012-9925-458C-871C-18774CDBBECB}
// *********************************************************************//
  IDeckLinkInput_v7_3 = interface(IUnknown)
    ['{4973F012-9925-458C-871C-18774CDBBECB}']
    function DoesSupportVideoMode(displayMode: _BMDDisplayMode; pixelFormat: _BMDPixelFormat; 
                                  out result: _BMDDisplayModeSupport): HResult; stdcall;
    function GetDisplayModeIterator(out iterator: IDeckLinkDisplayModeIterator_v7_6): HResult; stdcall;
    function SetScreenPreviewCallback(const previewCallback: IDeckLinkScreenPreviewCallback): HResult; stdcall;
    function EnableVideoInput(displayMode: _BMDDisplayMode; pixelFormat: _BMDPixelFormat; 
                              flags: _BMDVideoInputFlags): HResult; stdcall;
    function DisableVideoInput: HResult; stdcall;
    function GetAvailableVideoFrameCount(out availableFrameCount: LongWord): HResult; stdcall;
    function EnableAudioInput(sampleRate: _BMDAudioSampleRate; sampleType: _BMDAudioSampleType; 
                              channelCount: LongWord): HResult; stdcall;
    function DisableAudioInput: HResult; stdcall;
    function GetAvailableAudioSampleFrameCount(out availableSampleFrameCount: LongWord): HResult; stdcall;
    function StartStreams: HResult; stdcall;
    function StopStreams: HResult; stdcall;
    function PauseStreams: HResult; stdcall;
    function FlushStreams: HResult; stdcall;
    function SetCallback(const theCallback: IDeckLinkInputCallback_v7_3): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkDisplayModeIterator_v7_1
// Flags:     (0)
// GUID:      {B28131B6-59AC-4857-B5AC-CD75D5883E2F}
// *********************************************************************//
  IDeckLinkDisplayModeIterator_v7_1 = interface(IUnknown)
    ['{B28131B6-59AC-4857-B5AC-CD75D5883E2F}']
    function Next(out deckLinkDisplayMode: IDeckLinkDisplayMode_v7_1): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkDisplayMode_v7_1
// Flags:     (0)
// GUID:      {AF0CD6D5-8376-435E-8433-54F9DD530AC3}
// *********************************************************************//
  IDeckLinkDisplayMode_v7_1 = interface(IUnknown)
    ['{AF0CD6D5-8376-435E-8433-54F9DD530AC3}']
    function GetName(out name: WideString): HResult; stdcall;
    function GetDisplayMode: _BMDDisplayMode; stdcall;
    function GetWidth: Integer; stdcall;
    function GetHeight: Integer; stdcall;
    function GetFrameRate(out frameDuration: Int64; out timeScale: Int64): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkVideoFrame_v7_1
// Flags:     (0)
// GUID:      {333F3A10-8C2D-43CF-B79D-46560FEEA1CE}
// *********************************************************************//
  IDeckLinkVideoFrame_v7_1 = interface(IUnknown)
    ['{333F3A10-8C2D-43CF-B79D-46560FEEA1CE}']
    function GetWidth: Integer; stdcall;
    function GetHeight: Integer; stdcall;
    function GetRowBytes: Integer; stdcall;
    function GetPixelFormat: _BMDPixelFormat; stdcall;
    function GetFlags: _BMDFrameFlags; stdcall;
    function GetBytes(buffer: PPPrivateAlias1): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkVideoInputFrame_v7_1
// Flags:     (0)
// GUID:      {C8B41D95-8848-40EE-9B37-6E3417FB114B}
// *********************************************************************//
  IDeckLinkVideoInputFrame_v7_1 = interface(IDeckLinkVideoFrame_v7_1)
    ['{C8B41D95-8848-40EE-9B37-6E3417FB114B}']
    function GetFrameTime(var frameTime: Int64; var frameDuration: Int64; timeScale: Int64): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkAudioInputPacket_v7_1
// Flags:     (0)
// GUID:      {C86DE4F6-A29F-42E3-AB3A-1363E29F0788}
// *********************************************************************//
  IDeckLinkAudioInputPacket_v7_1 = interface(IUnknown)
    ['{C86DE4F6-A29F-42E3-AB3A-1363E29F0788}']
    function GetSampleCount: Integer; stdcall;
    function GetBytes(buffer: PPPrivateAlias1): HResult; stdcall;
    function GetAudioPacketTime(var packetTime: Int64; timeScale: Int64): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkVideoOutputCallback_v7_1
// Flags:     (0)
// GUID:      {EBD01AFA-E4B0-49C6-A01D-EDB9D1B55FD9}
// *********************************************************************//
  IDeckLinkVideoOutputCallback_v7_1 = interface(IUnknown)
    ['{EBD01AFA-E4B0-49C6-A01D-EDB9D1B55FD9}']
    function ScheduledFrameCompleted(const completedFrame: IDeckLinkVideoFrame_v7_1; 
                                     result: _BMDOutputFrameCompletionResult): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkInputCallback_v7_1
// Flags:     (0)
// GUID:      {7F94F328-5ED4-4E9F-9729-76A86BDC99CC}
// *********************************************************************//
  IDeckLinkInputCallback_v7_1 = interface(IUnknown)
    ['{7F94F328-5ED4-4E9F-9729-76A86BDC99CC}']
    function VideoInputFrameArrived(const videoFrame: IDeckLinkVideoInputFrame_v7_1; 
                                    const audioPacket: IDeckLinkAudioInputPacket_v7_1): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkOutput_v7_1
// Flags:     (0)
// GUID:      {AE5B3E9B-4E1E-4535-B6E8-480FF52F6CE5}
// *********************************************************************//
  IDeckLinkOutput_v7_1 = interface(IUnknown)
    ['{AE5B3E9B-4E1E-4535-B6E8-480FF52F6CE5}']
    function DoesSupportVideoMode(displayMode: _BMDDisplayMode; pixelFormat: _BMDPixelFormat; 
                                  out result: _BMDDisplayModeSupport): HResult; stdcall;
    function GetDisplayModeIterator(out iterator: IDeckLinkDisplayModeIterator_v7_1): HResult; stdcall;
    function EnableVideoOutput(displayMode: _BMDDisplayMode): HResult; stdcall;
    function DisableVideoOutput: HResult; stdcall;
    function SetVideoOutputFrameMemoryAllocator(const theAllocator: IDeckLinkMemoryAllocator): HResult; stdcall;
    function CreateVideoFrame(width: Integer; height: Integer; rowBytes: Integer; 
                              pixelFormat: _BMDPixelFormat; flags: _BMDFrameFlags; 
                              var outFrame: IDeckLinkVideoFrame_v7_1): HResult; stdcall;
    function CreateVideoFrameFromBuffer(buffer: Pointer; width: Integer; height: Integer; 
                                        rowBytes: Integer; pixelFormat: _BMDPixelFormat; 
                                        flags: _BMDFrameFlags; 
                                        var outFrame: IDeckLinkVideoFrame_v7_1): HResult; stdcall;
    function DisplayVideoFrameSync(const theFrame: IDeckLinkVideoFrame_v7_1): HResult; stdcall;
    function ScheduleVideoFrame(const theFrame: IDeckLinkVideoFrame_v7_1; displayTime: Int64; 
                                displayDuration: Int64; timeScale: Int64): HResult; stdcall;
    function SetScheduledFrameCompletionCallback(const theCallback: IDeckLinkVideoOutputCallback_v7_1): HResult; stdcall;
    function EnableAudioOutput(sampleRate: _BMDAudioSampleRate; sampleType: _BMDAudioSampleType; 
                               channelCount: LongWord): HResult; stdcall;
    function DisableAudioOutput: HResult; stdcall;
    function WriteAudioSamplesSync(buffer: Pointer; sampleFrameCount: LongWord; 
                                   out sampleFramesWritten: LongWord): HResult; stdcall;
    function BeginAudioPreroll: HResult; stdcall;
    function EndAudioPreroll: HResult; stdcall;
    function ScheduleAudioSamples(buffer: Pointer; sampleFrameCount: LongWord; streamTime: Int64; 
                                  timeScale: Int64; out sampleFramesWritten: LongWord): HResult; stdcall;
    function GetBufferedAudioSampleFrameCount(out bufferedSampleCount: LongWord): HResult; stdcall;
    function FlushBufferedAudioSamples: HResult; stdcall;
    function SetAudioCallback(const theCallback: IDeckLinkAudioOutputCallback): HResult; stdcall;
    function StartScheduledPlayback(playbackStartTime: Int64; timeScale: Int64; 
                                    playbackSpeed: Double): HResult; stdcall;
    function StopScheduledPlayback(stopPlaybackAtTime: Int64; var actualStopTime: Int64; 
                                   timeScale: Int64): HResult; stdcall;
    function GetHardwareReferenceClock(desiredTimeScale: Int64; 
                                       var elapsedTimeSinceSchedulerBegan: Int64): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IDeckLinkInput_v7_1
// Flags:     (0)
// GUID:      {2B54EDEF-5B32-429F-BA11-BB990596EACD}
// *********************************************************************//
  IDeckLinkInput_v7_1 = interface(IUnknown)
    ['{2B54EDEF-5B32-429F-BA11-BB990596EACD}']
    function DoesSupportVideoMode(displayMode: _BMDDisplayMode; pixelFormat: _BMDPixelFormat; 
                                  out result: _BMDDisplayModeSupport): HResult; stdcall;
    function GetDisplayModeIterator(out iterator: IDeckLinkDisplayModeIterator_v7_1): HResult; stdcall;
    function EnableVideoInput(displayMode: _BMDDisplayMode; pixelFormat: _BMDPixelFormat; 
                              flags: _BMDVideoInputFlags): HResult; stdcall;
    function DisableVideoInput: HResult; stdcall;
    function EnableAudioInput(sampleRate: _BMDAudioSampleRate; sampleType: _BMDAudioSampleType; 
                              channelCount: LongWord): HResult; stdcall;
    function DisableAudioInput: HResult; stdcall;
    function ReadAudioSamples(buffer: Pointer; sampleFrameCount: LongWord; 
                              out sampleFramesRead: LongWord; out audioPacketTime: Int64; 
                              timeScale: Int64): HResult; stdcall;
    function GetBufferedAudioSampleFrameCount(out bufferedSampleCount: LongWord): HResult; stdcall;
    function StartStreams: HResult; stdcall;
    function StopStreams: HResult; stdcall;
    function PauseStreams: HResult; stdcall;
    function SetCallback(const theCallback: IDeckLinkInputCallback_v7_1): HResult; stdcall;
  end;

// *********************************************************************//
// The Class CoCBMDStreamingDiscovery provides a Create and CreateRemote method to          
// create instances of the default interface IBMDStreamingDiscovery exposed by              
// the CoClass CBMDStreamingDiscovery. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCBMDStreamingDiscovery = class
    class function Create: IBMDStreamingDiscovery;
    class function CreateRemote(const MachineName: string): IBMDStreamingDiscovery;
  end;

// *********************************************************************//
// The Class CoCBMDStreamingH264NALParser provides a Create and CreateRemote method to          
// create instances of the default interface IBMDStreamingH264NALParser exposed by              
// the CoClass CBMDStreamingH264NALParser. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCBMDStreamingH264NALParser = class
    class function Create: IBMDStreamingH264NALParser;
    class function CreateRemote(const MachineName: string): IBMDStreamingH264NALParser;
  end;

// *********************************************************************//
// The Class CoCDeckLinkIterator provides a Create and CreateRemote method to          
// create instances of the default interface IDeckLinkIterator exposed by              
// the CoClass CDeckLinkIterator. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCDeckLinkIterator = class
    class function Create: IDeckLinkIterator;
    class function CreateRemote(const MachineName: string): IDeckLinkIterator;
  end;

// *********************************************************************//
// The Class CoCDeckLinkAPIInformation provides a Create and CreateRemote method to          
// create instances of the default interface IDeckLinkAPIInformation exposed by              
// the CoClass CDeckLinkAPIInformation. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCDeckLinkAPIInformation = class
    class function Create: IDeckLinkAPIInformation;
    class function CreateRemote(const MachineName: string): IDeckLinkAPIInformation;
  end;

// *********************************************************************//
// The Class CoCDeckLinkGLScreenPreviewHelper provides a Create and CreateRemote method to          
// create instances of the default interface IDeckLinkGLScreenPreviewHelper exposed by              
// the CoClass CDeckLinkGLScreenPreviewHelper. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCDeckLinkGLScreenPreviewHelper = class
    class function Create: IDeckLinkGLScreenPreviewHelper;
    class function CreateRemote(const MachineName: string): IDeckLinkGLScreenPreviewHelper;
  end;

// *********************************************************************//
// The Class CoCDeckLinkDX9ScreenPreviewHelper provides a Create and CreateRemote method to          
// create instances of the default interface IDeckLinkDX9ScreenPreviewHelper exposed by              
// the CoClass CDeckLinkDX9ScreenPreviewHelper. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCDeckLinkDX9ScreenPreviewHelper = class
    class function Create: IDeckLinkDX9ScreenPreviewHelper;
    class function CreateRemote(const MachineName: string): IDeckLinkDX9ScreenPreviewHelper;
  end;

// *********************************************************************//
// The Class CoCDeckLinkVideoConversion provides a Create and CreateRemote method to          
// create instances of the default interface IDeckLinkVideoConversion exposed by              
// the CoClass CDeckLinkVideoConversion. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCDeckLinkVideoConversion = class
    class function Create: IDeckLinkVideoConversion;
    class function CreateRemote(const MachineName: string): IDeckLinkVideoConversion;
  end;

// *********************************************************************//
// The Class CoCDeckLinkIterator_v8_0 provides a Create and CreateRemote method to          
// create instances of the default interface IDeckLinkIterator_v8_0 exposed by              
// the CoClass CDeckLinkIterator_v8_0. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCDeckLinkIterator_v8_0 = class
    class function Create: IDeckLinkIterator_v8_0;
    class function CreateRemote(const MachineName: string): IDeckLinkIterator_v8_0;
  end;

// *********************************************************************//
// The Class CoCDeckLinkGLScreenPreviewHelper_v7_6 provides a Create and CreateRemote method to          
// create instances of the default interface IDeckLinkGLScreenPreviewHelper_v7_6 exposed by              
// the CoClass CDeckLinkGLScreenPreviewHelper_v7_6. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCDeckLinkGLScreenPreviewHelper_v7_6 = class
    class function Create: IDeckLinkGLScreenPreviewHelper_v7_6;
    class function CreateRemote(const MachineName: string): IDeckLinkGLScreenPreviewHelper_v7_6;
  end;

// *********************************************************************//
// The Class CoCDeckLinkVideoConversion_v7_6 provides a Create and CreateRemote method to          
// create instances of the default interface IDeckLinkVideoConversion_v7_6 exposed by              
// the CoClass CDeckLinkVideoConversion_v7_6. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCDeckLinkVideoConversion_v7_6 = class
    class function Create: IDeckLinkVideoConversion_v7_6;
    class function CreateRemote(const MachineName: string): IDeckLinkVideoConversion_v7_6;
  end;

implementation

uses System.Win.ComObj;

class function CoCBMDStreamingDiscovery.Create: IBMDStreamingDiscovery;
begin
  Result := CreateComObject(CLASS_CBMDStreamingDiscovery) as IBMDStreamingDiscovery;
end;

class function CoCBMDStreamingDiscovery.CreateRemote(const MachineName: string): IBMDStreamingDiscovery;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CBMDStreamingDiscovery) as IBMDStreamingDiscovery;
end;

class function CoCBMDStreamingH264NALParser.Create: IBMDStreamingH264NALParser;
begin
  Result := CreateComObject(CLASS_CBMDStreamingH264NALParser) as IBMDStreamingH264NALParser;
end;

class function CoCBMDStreamingH264NALParser.CreateRemote(const MachineName: string): IBMDStreamingH264NALParser;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CBMDStreamingH264NALParser) as IBMDStreamingH264NALParser;
end;

class function CoCDeckLinkIterator.Create: IDeckLinkIterator;
begin
  Result := CreateComObject(CLASS_CDeckLinkIterator) as IDeckLinkIterator;
end;

class function CoCDeckLinkIterator.CreateRemote(const MachineName: string): IDeckLinkIterator;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CDeckLinkIterator) as IDeckLinkIterator;
end;

class function CoCDeckLinkAPIInformation.Create: IDeckLinkAPIInformation;
begin
  Result := CreateComObject(CLASS_CDeckLinkAPIInformation) as IDeckLinkAPIInformation;
end;

class function CoCDeckLinkAPIInformation.CreateRemote(const MachineName: string): IDeckLinkAPIInformation;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CDeckLinkAPIInformation) as IDeckLinkAPIInformation;
end;

class function CoCDeckLinkGLScreenPreviewHelper.Create: IDeckLinkGLScreenPreviewHelper;
begin
  Result := CreateComObject(CLASS_CDeckLinkGLScreenPreviewHelper) as IDeckLinkGLScreenPreviewHelper;
end;

class function CoCDeckLinkGLScreenPreviewHelper.CreateRemote(const MachineName: string): IDeckLinkGLScreenPreviewHelper;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CDeckLinkGLScreenPreviewHelper) as IDeckLinkGLScreenPreviewHelper;
end;

class function CoCDeckLinkDX9ScreenPreviewHelper.Create: IDeckLinkDX9ScreenPreviewHelper;
begin
  Result := CreateComObject(CLASS_CDeckLinkDX9ScreenPreviewHelper) as IDeckLinkDX9ScreenPreviewHelper;
end;

class function CoCDeckLinkDX9ScreenPreviewHelper.CreateRemote(const MachineName: string): IDeckLinkDX9ScreenPreviewHelper;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CDeckLinkDX9ScreenPreviewHelper) as IDeckLinkDX9ScreenPreviewHelper;
end;

class function CoCDeckLinkVideoConversion.Create: IDeckLinkVideoConversion;
begin
  Result := CreateComObject(CLASS_CDeckLinkVideoConversion) as IDeckLinkVideoConversion;
end;

class function CoCDeckLinkVideoConversion.CreateRemote(const MachineName: string): IDeckLinkVideoConversion;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CDeckLinkVideoConversion) as IDeckLinkVideoConversion;
end;

class function CoCDeckLinkIterator_v8_0.Create: IDeckLinkIterator_v8_0;
begin
  Result := CreateComObject(CLASS_CDeckLinkIterator_v8_0) as IDeckLinkIterator_v8_0;
end;

class function CoCDeckLinkIterator_v8_0.CreateRemote(const MachineName: string): IDeckLinkIterator_v8_0;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CDeckLinkIterator_v8_0) as IDeckLinkIterator_v8_0;
end;

class function CoCDeckLinkGLScreenPreviewHelper_v7_6.Create: IDeckLinkGLScreenPreviewHelper_v7_6;
begin
  Result := CreateComObject(CLASS_CDeckLinkGLScreenPreviewHelper_v7_6) as IDeckLinkGLScreenPreviewHelper_v7_6;
end;

class function CoCDeckLinkGLScreenPreviewHelper_v7_6.CreateRemote(const MachineName: string): IDeckLinkGLScreenPreviewHelper_v7_6;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CDeckLinkGLScreenPreviewHelper_v7_6) as IDeckLinkGLScreenPreviewHelper_v7_6;
end;

class function CoCDeckLinkVideoConversion_v7_6.Create: IDeckLinkVideoConversion_v7_6;
begin
  Result := CreateComObject(CLASS_CDeckLinkVideoConversion_v7_6) as IDeckLinkVideoConversion_v7_6;
end;

class function CoCDeckLinkVideoConversion_v7_6.CreateRemote(const MachineName: string): IDeckLinkVideoConversion_v7_6;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CDeckLinkVideoConversion_v7_6) as IDeckLinkVideoConversion_v7_6;
end;

end.
