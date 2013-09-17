program PLZWEncoding;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

const
  MAX_WORD_COUNT = 256;

type
  TDictionary = record
    WordCount: byte;
    Words: array of ShortString;
  end;

  TEncodedString = array of byte;

function FindInDict(D: TDictionary; str: ShortString): integer;
var
  r: integer;
  i: integer;
  fl: boolean;
begin
  r := -1;
  if D.WordCount > 0 then
  begin
    i := D.WordCount - 1;
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

procedure AddToDict(var D: TDictionary; str: ShortString);
begin
  if D.WordCount < MAX_WORD_COUNT then
  begin
    D.WordCount := D.WordCount + 1;
    SetLength(D.Words, D.WordCount);
    D.Words[D.WordCount - 1] := str;
  end;
end;

procedure InitDict(var D: TDictionary);
var
  c: ANSIChar;
begin
  D.WordCount := 0;
  D.Words := nil;
  for c := 'a' to 'z' do
    AddToDict(D, c);
end;

function LZWEncoding(InMsg: ShortString): TEncodedString;
var
  OutMsg: TEncodedString;
  tmpstr: ShortString;
  D: TDictionary;
  i, N: byte;
begin
  SetLength(OutMsg, length(InMsg));
  N := 0;
  InitDict(D);
  while length(InMsg) > 0 do
  begin
    tmpstr := InMsg[1];
    while (FindInDict(D, tmpstr) >= 0) and (length(InMsg) > length(tmpstr)) do
      tmpstr := tmpstr + InMsg[length(tmpstr) + 1];
    if FindInDict(D, tmpstr) < 0 then
      delete(tmpstr, length(tmpstr), 1);
    OutMsg[N] := FindInDict(D, tmpstr);
    N := N + 1;
    delete(InMsg, 1, length(tmpstr));
    if length(InMsg) > 0 then
      AddToDict(D, tmpstr + InMsg[1]);
  end;
  SetLength(OutMsg, N);
  LZWEncoding := OutMsg;
end;

begin
  try
    writeln(length(LZWEncoding('aaaaaaaaaabcd')));
    readln;
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;

end.
