unit ResizeThread;

interface

uses
  System.Classes, System.SysUtils, Img32, Img32.Fmt.JPG, Img32.Fmt.BMP, Img32.Fmt.PNG, Img32.Fmt.GIF;

type
  TResizeThread = class(TThread)
  private
    FFileList: TStringList;
    FWidth, FHeight: Integer;
    FOnProgress: TProc<Integer, string>;
    FOnComplete: TProc;
    FRewriteExisting : Boolean;
    procedure DoProgress(AIndex: Integer; const AMessage: string);
    procedure DoComplete;
  protected
    procedure Execute; override;
  public
    constructor Create(AFileList: TStringList; AWidth, AHeight: Integer;
       ARewriteExisting : Boolean; AOnProgress: TProc<Integer, string>; AOnComplete: TProc);
    destructor Destroy; override;
  end;

implementation

{ TResizeThread }

constructor TResizeThread.Create(AFileList: TStringList; AWidth,
  AHeight: Integer; ARewriteExisting : Boolean; AOnProgress: TProc<Integer, string>; AOnComplete: TProc);
begin
  inherited Create(True);
  FFileList := AFileList;
  FWidth := AWidth;
  FHeight := AHeight;
  FOnProgress := AOnProgress;
  FOnComplete := AOnComplete;
  FreeOnTerminate := True;
end;

destructor TResizeThread.Destroy;
begin
  if Assigned(FFileList) then
    FFileList.Free;
  inherited;
end;

procedure TResizeThread.DoComplete;
begin
  if Assigned(FOnComplete) then
    TThread.Synchronize(nil,
      procedure
      begin
        FOnComplete;
      end
    );
end;

procedure TResizeThread.DoProgress(AIndex: Integer; const AMessage: string);
begin
  if Assigned(FOnProgress) then
    TThread.Queue(nil,
      procedure
      begin
        FOnProgress(AIndex, AMessage);
      end
    );
end;

procedure TResizeThread.Execute;
var
  i: Integer;
  imgNewImage : TImage32;
  strOutputFileName: string;
  strSuffix : string;
begin
  NameThreadForDebugging('ResizeThread');
  imgNewImage := TImage32.Create;
  if FRewriteExisting then
    strSuffix := ''
  else
    strSuffix := '_resized';
  try
    for i := 0 to FFileList.Count - 1 do
    begin
      if Terminated then Break;
      try
        imgNewImage.LoadFromFile(FFileList[i]);
        imgNewImage.ScaleToFit(FWidth, FHeight);
        strOutputFileName := ChangeFileExt(FFileList[i], '') + strSuffix + ExtractFileExt(FFileList[i]);
        imgNewImage.SaveToFile(strOutputFileName);
      except
        on E: Exception do
          DoProgress(i, 'ERROR: ' + FFileList[i] + ' - ' + E.Message);
      end;
      DoProgress(i, 'SUCCESS: ' + ExtractFileName(FFileList[i]));
    end;
  finally
    imgNewImage.Free;
  end;
  DoComplete;
end;

end.
