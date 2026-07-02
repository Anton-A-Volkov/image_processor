program ImageProcessor;

{$MODE Delphi}

uses
  Forms,
  MainUnit in 'MainUnit.pas' {frmMain},
  ProcessingUnit in 'ProcessingUnit.pas' {dmProcessing: TDataModule},
  ResizeThread in 'ResizeThread.pas',
  Themes, Interfaces,
  MakeICOThread in 'MakeICOThread.pas';

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title:='Image Batch Processor';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmProcessing, dmProcessing);
  Application.Run;
end.
