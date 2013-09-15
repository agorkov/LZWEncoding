program PLZWEncoding;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

const
  MAX_WORD_COUNT = 128;

type
  TDictionary = record
    WordCount: byte;
    Words: array of string;
  end;

function FindInDict(D: TDictionary; str: string): shortint;
var
  r: shortint;
  i: shortint;
  fl: boolean;
begin
  r := -1;
  if D.WordCount > 0 then
  begin
    i := D.WordCount;
    fl := false;
    while (not fl) and (i >= 0) do
    begin
      if D.Words[i] = str then
      begin
        fl := true;
        r := i;
      end;
      i := i - 1;
    end;
  end;
  FindInDict := r;
end;

procedure AddToDict(var D: TDictionary; str: string);
begin
  if D.WordCount < MAX_WORD_COUNT - 1 then
  begin
    D.WordCount := D.WordCount + 1;
    SetLength(D.Words, D.WordCount);
    D.Words[D.WordCount - 1] := str;
  end;
end;

function LZWEncoding(InMsg: string): string;
var
  OutMsg: string;
  tmpstr: string;
  D: TDictionary;
  i: byte;
begin
  OutMsg := '';
  D.WordCount := 0;
  D.Words := nil;
  for i := 1 to length(InMsg) do
    if FindInDict(D, InMsg[i]) = -1 then
      AddToDict(D, InMsg[i]);

  while length(InMsg) > 0 do
  begin
    tmpstr := InMsg[1];
    while (FindInDict(D, tmpstr) >= 0) and (length(InMsg) > length(tmpstr)) do
      tmpstr := tmpstr + InMsg[length(tmpstr) + 1];
    if length(tmpstr) < length(InMsg) then
      delete(tmpstr, length(tmpstr), 1);
    OutMsg := OutMsg + IntToStr(FindInDict(D, tmpstr)) + ' ';
    delete(InMsg, 1, length(tmpstr));
    if length(InMsg) > 0 then
      AddToDict(D, tmpstr + InMsg[1]);
  end;
  LZWEncoding := OutMsg;
end;

begin
  try
    writeln(LZWEncoding('mamamamamama'));
    readln;
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;

end.
