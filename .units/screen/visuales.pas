unit visuales;

interface
uses crt, sysutils, keyboard, math, lista;

procedure box(originX:integer; x:integer; originY:integer; y:integer; simbolo:char);
procedure base;
procedure boxPrompt;
procedure crearDibujo;
procedure borrarPantalla;
procedure restaurarBoxPrompt;
procedure mostrarSeleccion(x:integer; y:integer; color:byte);
procedure animation(aux:ansiString; ms:integer; velocidadTexto:boolean);
procedure dibujarBoxUser(entrada:string; posicionY:byte; username:string);
procedure dibujarBoxBot(respuesta:ansistring; cantidadLineas:integer; posicionY:byte);

implementation

procedure dibujarBoxUser(entrada:string; posicionY:byte; username:string);
var posInt:integer;
posR:real;
begin

	posR := 117-(length(entrada)*2/3);
	posInt := floor(posR);

	box(116-length(entrada), posInt-3, posicionY, posicionY, '/');
	box(posInt+3, 119, posicionY, posicionY, '/');

	box(116-length(entrada), 116-length(entrada), posicionY+1, posicionY+3, '|');
	box(116-length(entrada), 119, posicionY+3, posicionY+3, '-');
	box(116-length(entrada), 116-length(entrada), posicionY+1, posicionY+3, '|');
	box(119,119, posicionY+1, posicionY+3, '/');

	gotoxy(posInt-1, posicionY);
	writeln(username + ': ');
end;

procedure dibujarBoxBot(respuesta:ansistring; cantidadLineas:integer; posicionY:byte);
begin

	if cantidadLineas > 1 then
		begin

			box(17, 108, posicionY, posicionY, '/');
			box(108, 108, posicionY+1, posicionY+2+cantidadLineas, '/');
			box(3, 108, posicionY+2+cantidadLineas, posicionY+2+cantidadLineas, '-');

		end
		else
		begin

			if 17<length(respuesta)+6 then box(17, length(respuesta)+6, posicionY, posicionY, '/');
			box(length(respuesta)+6, length(respuesta)+6, posicionY+1, posicionY+1+cantidadLineas, '/');
			box(3, length(respuesta)+6, posicionY+2+cantidadLineas, posicionY+2+cantidadLineas, '-');

		end;

	box(3, 3, posicionY+1, posicionY+2+cantidadLineas, '|');
	box(3, 9, posicionY, posicionY, '/');
	gotoxy(5, 11);

end;

procedure borrarPantalla;
var i:byte;
begin

	for i:=3 to 24 do
	begin

		gotoxy(1, i);
		clrEol;

	end;

	gotoxy(9,27);
	clrEol;

end;

procedure boxPrompt;
begin

	box(4, 118, 25, 25, '-');
	box(4, 118, 29, 29, '-');
	box(4, 4, 26, 28, '(');
	box(118, 118, 26, 28, ')');

end;

procedure base;
begin

	textcolor(15);

	gotoxy(25,25);
	writeln(' Prompt ');

	gotoxy(7, 27);
	textcolor(8);
	write('| Escribe un mensaje...');

	gotoxy(1,1);
	write('Presiona "Enter" para comenzar a chatear. Presiona "ESC" para salir. ');

	textcolor(15);

end;

procedure restaurarBoxPrompt;
begin

	gotoxy(9, 27);
	clrEol;
	gotoxy(118, 27); write(')');
	gotoxy(9, 27);

end;


procedure animation(aux:ansiString; ms:integer; velocidadTexto:boolean);
var i:integer;
x, auxX:integer;
y:integer;
auxiliarMS:integer;

	begin

		x:=whereX;
		auxX:=x;
		y:=whereY;

		InitKeyboard;
		auxiliarMS := ms;


		for i:=1 to length(aux) do
		begin

			if velocidadTexto then delay(ms);
				
			if x>105 then 
			begin
				if copy(aux, i, 1)<>' ' then write('-');
				y+=1;
				x:=auxX;
			end;
				
			gotoxy(x,y);
			write(copy(aux, i, 1));
			x:=x+1;

     		if keyPressed then
     		begin			
     			ms := 0;
     		end;
  
		end;

		ms := auxiliarMS;
		DoneKeyboard;

end;

procedure mostrarSeleccion(x:integer; y:integer; color:byte);
var i:1..2;
begin

	InitKeyboard;

	for i:=1 to 2 do
	begin

	//textbackground(yellow);
	textcolor(color);
	gotoxy(x, y);
	writeln('->');
	sleep(250);

	//textbackground(black);
	gotoxy(x, y);
	writeln('  ');
	sleep(100);

	end;

	//clrscr;
	textcolor(white);
	DoneKeyboard;

end;

procedure crearDibujo;
begin

	textcolor(8);
	gotoxy(1, 10);
	writeln('                               ...%@@@@      ');
	writeln('                            :...../..%%@@.   ');
	writeln('                          ::.... / ... ....: ');
	writeln('                          :#@@%%. \......... ');
	writeln('                         ::@@@%%.. .\. %%...@');
	writeln('                         ::@@@%.. ..-##%%@@.:');
	writeln('                         ::::....... @%%@@.::');
	writeln('                           ::\..../...@@@+:: ');
	writeln('                           ::#@@@:...::\::@  ');
	writeln('                             .#@@@%:::::=#   ');
	textcolor(white);

end;

procedure box(originX:integer; x:integer; originY:integer; y:integer; simbolo:char);
var i, j:integer;
begin

	//if fondo then TextBackground(yellow);
	//TextColor(yellow);

	if ((x<=119) and (x>=originX)) and ((y<=29) and (y>=originY)) then
	begin

	for i:=originX to x do
		for j:=originY to y do
		begin
			if ((i=originX) or (j=originY)) then begin
			gotoxy(i, j);
			writeln(simbolo);
			end;
		end;

	for i:=originX to x do
		for j:=originY to y do
		begin

			if ((i=x)) or ((j=y)) then begin
			gotoxy(i, j);
			writeln(simbolo);
			end;

		end;	
	end
	else writeln('Dimensiones X;Y fuera de limite (X MAX: 119; Y MAX: 29).');

	TextBackground(black);
	TextColor(white);

end;

begin
end.