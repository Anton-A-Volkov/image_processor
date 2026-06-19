program ImageProcessor;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {frmMain},
  ProcessingUnit in 'ProcessingUnit.pas' {dmProcessing: TDataModule},
  ResizeThread in 'ResizeThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmProcessing, dmProcessing);
  Application.Run;
end.
