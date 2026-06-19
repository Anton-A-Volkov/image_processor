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
    ProgressBar1: TProgressBar;
    memLog: TMemo;
    tsResize: TTabSheet;
    eNewWidth: TLabeledEdit;
    LabeledEdit1: TLabeledEdit;
    btnResize: TButton;
    dlgSelectFolder: TFileOpenDialog;
    procedure btnSelectFolderClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

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
