unit MainUnit;

interface

uses
  SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ComCtrls,
  ExtCtrls, Buttons, ImageList, ImgList, Mask, FileCtrl;

type
  TfrmMain = class(TForm)
    pnlGetDirectory: TPanel;
    eFolderPath: TLabeledEdit;
    btnSelectFolder: TButton;
    pcWorkspace: TPageControl;
    pnlLog: TPanel;
    pbProgress: TProgressBar;
    memLog: TMemo;
    tsResize: TTabSheet;
    eNewWidth: TLabeledEdit;
    eNewHeight: TLabeledEdit;
    btnResize: TButton;
    cbRewriteExisting: TCheckBox;
    btnLockDimensions: TSpeedButton;
    lblResizeDescription: TLabel;
    tsMakeICO: TTabSheet;
    eICOSaveFile: TLabeledEdit;
    btnSelectResultFile: TButton;
    cbICOFilterUniqueSizes: TCheckBox;
    btnMakeICO: TButton;
    ilIcons: TImageList;
    dlgSave: TSaveDialog;
    procedure btnSelectFolderClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnResizeClick(Sender: TObject);
    procedure btnLockDimensionsClick(Sender: TObject);
    procedure eNewWidthChange(Sender: TObject);
    procedure eNewHeightChange(Sender: TObject);
    procedure pcWorkspaceChange(Sender: TObject);
    procedure btnSelectResultFileClick(Sender: TObject);
    procedure btnMakeICOClick(Sender: TObject);
  private
    FSaveFileEdit : TLabeledEdit;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses ProcessingUnit;

{$R *.dfm}

procedure TfrmMain.btnLockDimensionsClick(Sender: TObject);
begin
  btnLockDimensions.ImageIndex := Integer(btnLockDimensions.Down);
end;

procedure TfrmMain.btnMakeICOClick(Sender: TObject);
var
  Folder: string;
  FileCount : Integer;
begin
  Folder := eFolderPath.Text;
  if not DirectoryExists(Folder) then
  begin
    memLog.Lines.Add('Folder not exists');
    Exit;
  end;

  pbProgress.Position := 0;
  memLog.Clear;
  btnMakeICO.Enabled := False;

  FileCount := dmProcessing.ProcessCreateICO(Folder, eICOSaveFile.Text,
    cbICOFilterUniqueSizes.Checked,
    procedure(AIndex: Integer; AMessage: string)
    begin
      pbProgress.Position := AIndex + 1;
      memLog.Lines.Add(AMessage);
    end,
    procedure
    begin
      btnMakeICO.Enabled := True;
      memLog.Lines.Add('SUCCESS: Icon creation is completed.');
    end);
  pbProgress.Max := FileCount;

  if FileCount = 0 then
  begin
    memLog.Lines.Add('ERROR: No files to make icon.');
    btnMakeICO.Enabled := True;
  end;
end;

procedure TfrmMain.btnResizeClick(Sender: TObject);
var
  Folder: string;
  FileCount : Integer;
begin
  Folder := eFolderPath.Text;
  if not DirectoryExists(Folder) then
  begin
    memLog.Lines.Add('Folder not exists');
    Exit;
  end;

  pbProgress.Position := 0;
  memLog.Clear;
  btnResize.Enabled := False;

  FileCount := dmProcessing.ProcessResize(Folder, StrToIntDef(eNewWidth.Text, 1024),
    StrToIntDef(eNewHeight.Text, 1024), cbRewriteExisting.Checked,
    procedure(AIndex: Integer; AMessage: string)
    begin
      pbProgress.Position := AIndex + 1;
      memLog.Lines.Add(AMessage);
    end,
    procedure
    begin
      btnResize.Enabled := True;
      memLog.Lines.Add('SUCCESS: Resizing is completed.');
    end);
  pbProgress.Max := FileCount;

  if FileCount = 0 then
  begin
    memLog.Lines.Add('ERROR: No files to resize.');
    btnResize.Enabled := True;
  end;
end;

procedure TfrmMain.btnSelectFolderClick(Sender: TObject);
var
  strSelectedDir : string;
  SelectDirOptions : TSelectDirOpts;
begin
  IF SelectDirectory(strSelectedDir, [sdAllowCreate, sdPrompt], 0) then
  begin
    eFolderPath.Text := strSelectedDir;
  end;
end;

procedure TfrmMain.btnSelectResultFileClick(Sender: TObject);
begin
  if dlgSave.Execute then
    if Assigned(FSaveFileEdit) then
      FSaveFileEdit.Text := dlgSave.FileName;
end;

procedure TfrmMain.eNewHeightChange(Sender: TObject);
begin
  if btnLockDimensions.Down then
    eNewWidth.Text := eNewHeight.Text;
end;

procedure TfrmMain.eNewWidthChange(Sender: TObject);
begin
  if btnLockDimensions.Down then
    eNewHeight.Text := eNewWidth.Text;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  btnSelectFolder.Parent := eFolderPath;
  btnSelectFolder.Align := alRight;
  pcWorkspaceChange(Sender);
end;

procedure TfrmMain.pcWorkspaceChange(Sender: TObject);
begin
  if pcWorkspace.ActivePage = tsMakeICO then
  begin
    btnSelectResultFile.Parent := eICOSaveFile;
    btnSelectResultFile.Align := alRight;
    dlgSave.Filter := 'ICO files|*.ico';
    dlgSave.DefaultExt := 'ico';
    FSaveFileEdit := eICOSaveFile;
  end;
end;

end.
