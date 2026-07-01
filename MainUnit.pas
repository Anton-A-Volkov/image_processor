unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.Buttons, System.ImageList, Vcl.ImgList, PngImageList;

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
    dlgSelectFolder: TFileOpenDialog;
    cbRewriteExisting: TCheckBox;
    ilIcons: TPngImageList;
    btnLockDimensions: TSpeedButton;
    lblResizeDescription: TLabel;
    procedure btnSelectFolderClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnResizeClick(Sender: TObject);
    procedure btnLockDimensionsClick(Sender: TObject);
    procedure eNewWidthChange(Sender: TObject);
    procedure eNewHeightChange(Sender: TObject);
  private
    { Private declarations }
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
begin
  if dlgSelectFolder.Execute then
  begin
    eFolderPath.Text := dlgSelectFolder.FileName;
  end;
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
end;

end.
