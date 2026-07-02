unit MakeICOThread;

interface

uses
  Classes, SysUtils, Types, Generics.Collections,
  Img32, Img32.Fmt.BMP, Img32.Fmt.PNG, Img32.Fmt.JPG, Img32.Fmt.GIF, Img32.Transform;

type
  TMakeICOThread = class(TThread)
  private
    FFileList: TStringList;
    FOutputFile: string;
    FUniqueSizes: Boolean;
    FOnProgress: TProc<Integer, string>;
    FOnComplete: TProc;
    procedure DoProgress(AIndex: Integer; AMessage: string);
    procedure DoComplete;
    function LoadImage(const AFileName: string): TImage32;
    procedure WriteICO(const AImages: TDictionary<TSize, TImage32>);
  protected
    procedure Execute; override;
  public
    constructor Create(AFileList: TStringList; const AOutputFile: string;
      AUniqueSizes: Boolean; AOnProgress: TProc<Integer, string>;
      AOnComplete: TProc);
    destructor Destroy; override;
  end;

  ICONHEADER = packed record
    Reserved: Word;
    TypeID: Word;
    Count: Word;
  end;

  ICONDIRENTRY = packed record
    Width: Byte;
    Height: Byte;
    Colors: Byte;
    Reserved: Byte;
    Planes: Word;
    BitCount: Word;
    SizeInBytes: DWord;
    ImageOffset: DWord;
  end;

  BITMAPHEADER = packed record
    biSize: DWord;
    biWidth: Integer;
    biHeight: Integer;
    biPlanes: Word;
    biBitCount: Word;
    biCompression: DWord;
    biSizeImage: DWord;
    biXPelsPerMeter: Integer;
    biYPelsPerMeter: Integer;
    biClrUsed: DWord;
    biClrImportant: DWord;
  end;

implementation

{ TMakeICOThread }

constructor TMakeICOThread.Create(AFileList: TStringList;
  const AOutputFile: string; AUniqueSizes: Boolean;
  AOnProgress: TProc<Integer, string>; AOnComplete: TProc);
begin
  inherited Create(True);
  FFileList := AFileList;
  FOutputFile := AOutputFile;
  FUniqueSizes := AUniqueSizes;
  FOnProgress := AOnProgress;
  FOnComplete := AOnComplete;
  FreeOnTerminate := False;
end;

destructor TMakeICOThread.Destroy;
begin
  FFileList.Free;
  inherited;
end;

procedure TMakeICOThread.DoComplete;
begin
  if Assigned(FOnComplete) then
    TThread.Synchronize(nil,
      procedure
      begin
        FOnComplete;
      end
    );
end;

procedure TMakeICOThread.DoProgress(AIndex: Integer; AMessage: string);
begin
  if Assigned(FOnProgress) then
    TThread.Queue(nil,
      procedure
      begin
        FOnProgress(AIndex, AMessage);
      end
    );
end;

procedure TMakeICOThread.Execute;
var
  i: Integer;
  Img: TImage32;
  SizeKey: TSize;
  UniqueSizes: TDictionary<TSize, TImage32>;
  FileName: string;
begin
  NameThreadForDebugging('MakeICOThread');
  UniqueSizes := TDictionary<TSize, TImage32>.Create;
  try
    for i := 0 to FFileList.Count - 1 do
    begin
      if Terminated then Break;
      FileName := FFileList[i];
      try
        Img := LoadImage(FileName);
        SizeKey := TSize.Create(Img.Width, Img.Height);

        if FUniqueSizes then
        begin
          if not UniqueSizes.ContainsKey(SizeKey) then
            if (Img.Width <= 256) and (Img.Height <= 256) then
              UniqueSizes.Add(SizeKey, Img)
            else
              Img.Free
          else
            Img.Free;
        end
        else
          if (Img.Width <= 256) and (Img.Height <= 256) then
            UniqueSizes.Add(SizeKey, Img)
          else
            Img.Free;

        DoProgress(i, 'SUCCESS: ' + ExtractFileName(FileName));
      except
        on E: Exception do
          DoProgress(i, 'ERROR: ' + FileName + ' - ' + E.Message);
      end;
    end;

    if not Terminated and (UniqueSizes.Count > 0) then
    begin
      WriteICO(UniqueSizes);
    end
    else if UniqueSizes.Count = 0 then
      DoProgress(FFileList.Count, 'ERROR: There are no available images');

  finally
    for Img in UniqueSizes.Values do
      Img.Free;
    UniqueSizes.Free;
  end;

  DoComplete;
end;

function TMakeICOThread.LoadImage(const AFileName: string): TImage32;
begin
  Result := TImage32.Create;
  try
    Result.LoadFromFile(AFileName);
  except
    Result.Free;
    raise;
  end;
end;

procedure TMakeICOThread.WriteICO(const AImages: TDictionary<TSize, TImage32>);
var
  Stream: TFileStream;
  ImageData: TBytes;
  Pair: TPair<TSize, TImage32>;
  Header : ICONHEADER;
  Entry : ICONDIRENTRY;
  Img: TImage32;
  Offset: DWord;
  PngData: TMemoryStream;
begin
  Stream := TFileStream.Create(FOutputFile, fmCreate);
  try

    Header.Reserved := 0;
    Header.TypeID := 1;
    Header.Count := AImages.Count;
    Stream.Write(Header, SizeOf(Header));

    Offset := SizeOf(Header) + AImages.Count * SizeOf(Entry);

    for Pair in AImages do
    begin
      Img := Pair.Value;
      PngData := TMemoryStream.Create();
      try
        Img.SaveToStream(PngData, 'png');
        if Img.Width = 256 then
          Entry.Width := 0
        else
          Entry.Width := Img.Width;
        if Img.Height = 256 then
          Entry.Height := 0
        else
          Entry.Height := Img.Height;
        Entry.Colors := 0;
        Entry.Reserved := 0;
        Entry.Planes := 1;
        Entry.BitCount := 32;
        Entry.SizeInBytes := PngData.Size;
        Entry.ImageOffset := Offset;

        Stream.Write(Entry, SizeOf(Entry));
        Inc(Offset, Entry.SizeInBytes);
      finally
        PngData.Free;
      end;
    end;

    for Pair in AImages do
    begin
      Img := Pair.Value;
      PngData := TMemoryStream.Create();
      try
        Img.SaveToStream(PngData, 'png');
        Stream.Write(PngData.Memory^, PngData.Size);
      finally
        PngData.Free;
      end;
    end;
  finally
    Stream.Free;
  end;
end;

end.
