unit ResizeThread;

{$MODE Delphi}

interface

uses
  Classes, SysUtils, Img32, Img32.Fmt.JPG, Img32.Fmt.BMP, Img32.Fmt.PNG;

type
  TOnProgressEvent = procedure(AIndex: Integer; const AMessage: string) of object;
  TOnCompleteEvent = procedure of object;

  TResizeThread = class(TThread)
  private
    FProgressIndex : Integer;
    FProgressMessage : string;
    FFileList: TStringList;
    FWidth, FHeight: Integer;
    FOnProgress: TOnProgressEvent;
    FOnComplete: TOnCompleteEvent;
    FRewriteExisting : Boolean;
    procedure DoProgress(AIndex: Integer; const AMessage: string);
    procedure DoComplete;
    procedure SyncComplete;
    procedure SyncProgress;
  protected
    procedure Execute; override;
  public
    constructor Create(AFileList: TStringList; AWidth, AHeight: Integer;
       ARewriteExisting : Boolean; AOnProgress: TOnProgressEvent; AOnComplete: TOnCompleteEvent);
    destructor Destroy; override;
  end;

implementation

{ TResizeThread }

constructor TResizeThread.Create(AFileList: TStringList; AWidth,
  AHeight: Integer; ARewriteExisting : Boolean; AOnProgress: TOnProgressEvent; AOnComplete: TOnCompleteEvent);
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
    TThread.Synchronize(nil, SyncComplete);
end;

procedure TResizeThread.SyncComplete;
begin
  if Assigned(FOnComplete) then
    FOnComplete;
end;

procedure TResizeThread.DoProgress(AIndex: Integer; const AMessage: string);
begin
  if Assigned(FOnProgress) then
  begin
    FProgressMessage := AMessage;
    FProgressIndex := AIndex;
    TThread.Queue(nil, SyncProgress);
  end;
end;

procedure TResizeThread.SyncProgress;
begin
  if Assigned(FOnProgress) then
    FOnProgress(FProgressIndex, FProgressMessage);
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
