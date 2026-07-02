unit ProcessingUnit;

{$MODE Delphi}

interface

uses
  SysUtils, Classes, ResizeThread, MakeICOThread;

type
  TOnProgressEvent = procedure(AIndex: Integer; const AMessage: string) of object;
  TOnCompleteEvent = procedure of object;

  TdmProcessing = class(TDataModule)
  private
    function GetImageFiles(const AFolder: string): TStringList;
  public
    function ProcessResize(ADirectory : string; ANewWidth, ANewHeight : Integer;
     ARewriteExisting : Boolean;AOnProgress : TOnProgressEvent; AOnComplete : TOnCompleteEvent) : Integer;
  function ProcessCreateICO(ADirectory : string; AOutputFile: string; AUniqueSizes: Boolean;
    AOnProgress: TOnProgressEvent; AOnComplete: TOnCompleteEvent) : Integer;
  end;

var
  dmProcessing: TdmProcessing;

implementation

{$R *.lfm}

{ TdmProcessing }

function TdmProcessing.GetImageFiles(const AFolder: string): TStringList;
var
  Ext: string;
  SearchRec: TSearchRec;
begin
  Result := TStringList.Create;
  try
    if not DirectoryExists(AFolder) then Exit;
    if FindFirst(AFolder + '\*.*', faAnyFile, SearchRec) = 0 then
    begin
      repeat
        if (SearchRec.Attr and faDirectory) = 0 then
        begin
          Ext := LowerCase(ExtractFileExt(SearchRec.Name));
          if (Ext = '.png') or (Ext = '.jpg') or (Ext = '.jpeg') or (Ext = '.bmp') then
            Result.Add(AFolder + '\' + SearchRec.Name);
        end;
      until FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
    end;
  except
    Result.Free;
    raise;
  end;
end;

function TdmProcessing.ProcessCreateICO(ADirectory, AOutputFile: string;
  AUniqueSizes: Boolean; AOnProgress: TOnProgressEvent;
  AOnComplete: TOnCompleteEvent): Integer;
var
  slFileList : TStringList;
  trThread : TMakeICOThread;
begin
  slFileList := GetImageFiles(ADirectory);
  Result := slFileList.Count;
  trThread := TMakeICOThread.Create(slFileList, AOutputFile, AUniqueSizes, AOnProgress, AOnComplete);
  trThread.Start;
end;

function TdmProcessing.ProcessResize(ADirectory: string; ANewWidth,
  ANewHeight: Integer; ARewriteExisting : Boolean; AOnProgress: TOnProgressEvent; AOnComplete: TOnCompleteEvent) : Integer;
var
  slFileList : TStringList;
  trThread : TResizeThread;
begin
  slFileList := GetImageFiles(ADirectory);
  Result := slFileList.Count;
  trThread := TResizeThread.Create(slFileList, ANewWidth, ANewHeight, ARewriteExisting, AOnProgress, AOnComplete);
  trThread.Start;
end;

end.
