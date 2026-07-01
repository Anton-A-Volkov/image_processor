program ImageProcessor;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {frmMain},
  ProcessingUnit in 'ProcessingUnit.pas' {dmProcessing: TDataModule},
  ResizeThread in 'ResizeThread.pas',
  Vcl.Themes,
  Vcl.Styles,
  MakeICOThread in 'MakeICOThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Image Batch Processor';
  TStyleManager.TrySetStyle('Tablet Dark');
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmProcessing, dmProcessing);
  Application.Run;
end.
