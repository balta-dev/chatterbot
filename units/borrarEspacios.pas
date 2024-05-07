unit borrarEspacios;

interface

uses
  SysUtils, crt; 

procedure RemoveEmptyLinesFromFile(const fileName: ansistring); 

implementation

procedure RemoveEmptyLinesFromFile(const fileName: ansistring);
var
  inputFile, outputFile: TextFile;
  line: ansistring;
begin
  Assign(inputFile, fileName);
  Assign(outputFile, 'temp.txt');
  
    Reset(inputFile);
    Rewrite(outputFile);
    
    while not EOF(inputFile) do
    begin

      ReadLn(inputFile, line);
      line := TrimLeft(line);
      if line <> '' then begin WriteLn(outputFile, line); end;

    end;
    
    Close(inputFile);
    Close(outputFile);

    DeleteFile(fileName);
  RenameFile('temp.txt', fileName);
  end;

begin
end.