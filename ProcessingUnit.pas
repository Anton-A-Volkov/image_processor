unit ProcessingUnit;

interface

uses
  System.SysUtils, System.Classes, ResizeThread;

type
  TdmProcessing = class(TDataModule)
  private
    function GetImageFiles(const AFolder: string): TStringList;
  public
  end;

var
  dmProcessing: TdmProcessing;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

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

end.
