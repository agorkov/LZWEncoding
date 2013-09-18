unit ULZW;

interface

const
  MAX_DICT_LENGTH = 256;

type
  TDictionary = record
    WordCount: byte;
    Words: array of ShortString;
  end;

  TEncodedString = array of byte;

function LZWEncode(InMsg: ShortString): TEncodedString;
function LZWDecode(InMsg: TEncodedString): ShortString;

implementation

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
  if D.WordCount < MAX_DICT_LENGTH then
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

function LZWEncode(InMsg: ShortString): TEncodedString;
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
  LZWEncode := OutMsg;
end;

function LZWDecode(InMsg: TEncodedString): ShortString;
var
  D: TDictionary;
  OutMsg, tmpstr: ShortString;
  i: byte;
begin
  OutMsg := '';
  tmpstr := '';
  InitDict(D);
  for i := 0 to length(InMsg) - 1 do
  begin
    if InMsg[i] >= D.WordCount then
      tmpstr := D.Words[InMsg[i - 1]] + D.Words[InMsg[i - 1]][1]
    else
      tmpstr := D.Words[InMsg[i]];
    OutMsg := OutMsg + tmpstr;
    if i > 0 then
      AddToDict(D, D.Words[InMsg[i - 1]] + tmpstr[1]);
  end;
  LZWDecode := OutMsg;
end;

end.
