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
    writeln('Введите сообщение:');
    readln(InMsg);
    writeln('Длина исходного сообщения: ', length(InMsg), 'байт');
    writeln;

    OutMsg := LZWEncode(InMsg);
    writeln('Длина закодированного сообщения: ', length(OutMsg), 'байт');
    InMsg := LZWDecode(OutMsg);
    writeln(InMsg);

    readln;
  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;

end.
