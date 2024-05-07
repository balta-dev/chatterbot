unit procesamiento;

interface

uses crt, Keyboard, SysUtils, administrador, music, dia, box;

type 

	longString = AnsiString;

	t_reg = record
		humano : string;
		textoHumano : string;
		bot : string;
		textoBot : string;
	end;

	t_vector2 = array [1..3000] of t_reg;


procedure animation(var aux:longString; var ms:integer; var completition_type:boolean);
procedure wLine(var word:ansistring; var result:string; var reg:t_reg; var v:t_vector2; var completition_type:boolean; var username:string; var m:byte; var colorTextoBYTE:byte; var save:boolean; var doneProgram:boolean);

implementation

procedure animation(var aux:longString; var ms:integer; var completition_type:boolean);
var i:integer;
x:integer;
y:integer;
auxiliarMS:integer;

	begin

		x:=whereX;
		y:=whereY;

		InitKeyboard;
		auxiliarMS := ms;

		if completition_type then
		begin

			for i:=1 to length(aux) do
			begin

				delay(ms);
				
				if x>110 then 
				begin
					if copy(aux, i, 1)<>' ' then write('-');
					y+=1;
					x:=18;
				end;
				
				gotoxy(x,y);
				write(copy(aux, i, 1));
				x:=x+1;

		//		SendMCICommand('play "text_sound.mp3"');  sonido de prueba para la escritura
     			if keyPressed then
     			begin			
     				ms := 0;
     			end;
  
			end;

		end
		else write(aux);

		ms := auxiliarMS;
		DoneKeyboard;

	end;


procedure wLine(var word:ansistring; var result:string; var reg:t_reg; var v:t_vector2; var completition_type:boolean; var username:string; var m:byte; var colorTextoBYTE:byte; var save:boolean; var doneProgram:boolean);
var aux:longString;
	int:integer;
	rand:integer;
	datos, generic:textfile;
	vectorTotal:t_vector;
	vectorCantidadRespuestas:t_vectorInt;
	vectorTriggers:t_vector;	
	vectorRespuestas:t_vector;
	auxByte:byte;
	found:ansistring;
	size:integer;
	
	begin

		int:=30;

		clrscr;

		gotoxy(0, 0);
		writeln('Presiona "ESC" antes de escribir tu mensaje o despedite para cerrar el chat!');

		gotoxy(1, 8); 
		writeln('----------');

		gotoxy(15, 8);
		auxByte:=0;

		boxDO(1, 115, 6, 25, '*', false);

		aux:= username+': ';
		gotoxy(15, 8);
    	animation(aux, int, completition_type);

    	assign (datos, 'datos.txt');
    	reset(datos);
		desacoplarData(datos, vectorTriggers, vectorRespuestas, vectorTotal, vectorCantidadRespuestas);
		close(datos);
		reset(datos);
    	buscarRegistro(word, size, vectorRespuestas, false, auxByte, datos, found, vectorTotal, vectorCantidadRespuestas, true, false);

    	reg.humano := '[' + DateTimeToStr(Now) + '] ' + username + ': ';
    	reg.textoHumano := word;

    	word := AnsiLowerCase(word);

    	if found<>'' then
    	begin

    	aux:= 'Escribiendo...';
    	textcolor(colorTextoBYTE);
    	gotoxy(18, 10);
    	animation(aux, int, completition_type);
    	textcolor(white);

    	delay(1300);
    	
    	textcolor(colorTextoBYTE);
    	gotoxy(15, whereY);
    	aux:= 'Bot: ';
    	gotoxy(whereX+3, whereY);
   		animation(aux, int, completition_type);
   
    	reg.Bot := '[' + DateTimeToStr(Now) + '] ' + 'Bot: ';
    	randomValue(size, rand);
    	aux:= vectorRespuestas[rand];

    	if found='hora' then aux:='Ahora mismo en tu zona horaria son las '+TimeToStr(Time)+ '.';
    	if found='dia' then aux:= 'Hoy es el '+ diaActual + '.';
    	if (found='historial de chat') or (found='guarda') or (found='guardes') or (found='guardame') then save:=true;
    	if (found='chau') or (found='adios') or (found='nos vemos') then doneProgram:=true;
    	if found='notfound404' then aux:='No tengo programada ninguna respuesta para tu pregunta (y el archivo genérico no existe).';

    	animation(aux, int, completition_type);

    	reg.textoBot := aux;
    	v[m+1] := reg;
    	m := m + 1;
    	textcolor(white);
    	end;

	end;

begin
end.