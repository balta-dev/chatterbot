unit historial;

interface

uses crt, SysUtils, procesamiento;

procedure logClosingHandling(var v:t_vector2; var auxDate:string; var auxTime:string; var autoSave:boolean; var m:byte; var save:boolean);
procedure logOpeningHandling(var auxDate:string; var auxTime:string);

implementation

procedure logClosingHandling(var v:t_vector2; var auxDate:string; var auxTime:string; var autoSave:boolean; var m:byte; var save:boolean);
var tiempoInicial:longString;
archTXT:textfile;
j:byte;
	begin


		tiempoInicial := DateTimeToStr(Now);
		
		if not autoSave then
			begin 
				assign (archTXT, '.\chatLog\log_' + auxDate + '-'  + auxTime + '.txt'); 
			end
			else assign (archTXT, '.\chatLog\log_' + auxDate + '-'  + auxTime + ' (AUTOGUARDADO).txt');
	
	rewrite(archTXT);

		if not autoSave then
			begin
				writeln(archTXT, 'HISTORIAL DE CHAT  ---  ' + tiempoInicial + ' hs.');
			end
			else writeln(archTXT, 'HISTORIAL DE CHAT (AUTOGUARDADO)  ---  ' + tiempoInicial + ' hs.');

		writeln(archTXT, '');

		for j:=1 to m do
			begin
			writeln(archTXT, v[j].Humano); //writeln(v[j].Humano);			//guardado en archivo
			writeln(archTXT, v[j].textoHumano); //writeln(v[j].textoHumano);
			writeln(archTXT, v[j].Bot); //writeln(v[j].Bot);
			writeln(archTXT, v[j].textoBot); //writeln(v[j].textoBot);
		end;
		
		close(archTXT);
		
		if not save then
			begin
				erase(archTXT);
			end;
//			else begin writeln('archivo GUARDADO'); readln; end;
		
	end;


procedure logOpeningHandling(var auxDate:string; var auxTime:string);
var year, month, day, hr, min, sec, ms:Word;

	begin

		DecodeDate(Date,year,month,day);
		auxDate:= Format('%d',[year])	+ '_' +	  Format('%d',[month])	+ '_' +	  Format('%d',[day]);
		DecodeTime(Time, hr, min, sec, ms);
		auxTime:= format('%d',[hr]) +  '-'  +  format('%d',[min]) + '-' + format('%d',[sec]) + '-' + format('%d', [ms]);
		clrscr;
	
	end;

begin
end.