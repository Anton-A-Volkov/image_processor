unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Mask,
  Vcl.ExtCtrls;

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
    procedure btnSelectFolderClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnResizeClick(Sender: TObject);
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

  // Сброс состояния
  pbProgress.Position := 0;
  memLog.Clear;
  btnResize.Enabled := False;

  // Запускаем обработку
  FileCount := dmProcessing.ProcessResize(Folder, StrToIntDef(eNewWidth.Text, 1024),
    StrToIntDef(eNewHeight.Text, 1024),
    procedure(AIndex: Integer; AMessage: string)
    begin
      // Обновление прогресса и лога
      pbProgress.Position := AIndex + 1;
      memLog.Lines.Add(AMessage);
    end,
    procedure
    begin
      // По завершении
      btnResize.Enabled := True;
      memLog.Lines.Add('Обработка завершена.');
    end);
  pbProgress.Max := FileCount;
  begin
    memLog.Lines.Add('Нет подходящих файлов.');
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

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  btnSelectFolder.Parent := eFolderPath;
  btnSelectFolder.Align := alRight;
end;

end.
