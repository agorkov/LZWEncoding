program PLZWEncoding;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils, ULZW in 'ULZW.pas';

var
  InMsg: ShortString;
  OutMsg: TEncodedString;

begin
  try
    writeln('������� ���������:');
    readln(InMsg);
    writeln('����� ��������� ���������: ', length(InMsg), '����');
    writeln;

    OutMsg := LZWEncode(InMsg);
    writeln('����� ��������������� ���������: ', length(OutMsg), '����');
    InMsg := LZWDecode(OutMsg);
    writeln(InMsg);

    readln;
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;

end.
