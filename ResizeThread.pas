unit ResizeThread;

interface

uses
  System.Classes, System.SysUtils, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg, Vcl.Graphics;

type
  TResizeThread = class(TThread)
  private
    FFileList: TStringList;
    FWidth, FHeight: Integer;
    FOnProgress: TProc<Integer, string>;
    FOnComplete: TProc;
    procedure DoProgress(AIndex: Integer; const AMessage: string);
    procedure DoComplete;
  protected
    procedure Execute; override;
  public
    constructor Create(AFileList: TStringList; AWidth, AHeight: Integer;
      AOnProgress: TProc<Integer, string>; AOnComplete: TProc);
    destructor Destroy; override;
  end;

implementation

{ TResizeThread }

constructor TResizeThread.Create(AFileList: TStringList; AWidth,
  AHeight: Integer; AOnProgress: TProc<Integer, string>; AOnComplete: TProc);
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
    TThread.Queue(nil,
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
  Picture: TPicture;
  Bitmap: TBitmap;
  OutputFileName: string;
begin
  NameThreadForDebugging('ResizeThread');
  Picture := TPicture.Create;
  Bitmap := TBitmap.Create;
  try
    for i := 0 to FFileList.Count - 1 do
    begin
      if Terminated then Break;
      try
        Picture.LoadFromFile(FFileList[i]);
        Bitmap.SetSize(FWidth, FHeight);
        Bitmap.Canvas.StretchDraw(Rect(0, 0, FWidth, FHeight), Picture.Graphic);
        OutputFileName := FFileList[i];
        if SameText(ExtractFileExt(OutputFileName), '.png') then
          Bitmap.SaveToFile(OutputFileName)
        else
        begin
          Picture.Graphic := Bitmap;
          Picture.SaveToFile(OutputFileName);
        end;
      except
        on E: Exception do
          DoProgress(i, 'ERROR: ' + FFileList[i] + ' - ' + E.Message);
      end;
      DoProgress(i, 'SUCCESS: ' + ExtractFileName(FFileList[i]));
    end;
  finally
    Picture.Free;
    Bitmap.Free;
  end;
  DoComplete;
end;

end.
