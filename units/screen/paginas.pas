unit paginas;
{$IFDEF Windows} 
{$codepage UTF-8}
{$ENDIF}

interface

uses lista, visuales, keyboard, crt, sysutils, configuraciones;

procedure restaurarPagina(var lista:tLista; infoConfig:tVector; velocidadTexto:boolean);
procedure subirPagina(var paginaActual:byte; ultimaPagina:byte; lista:tLista; infoConfig:tVector; velocidadTexto:boolean);
procedure bajarPagina(var paginaActual:byte; ultimaPagina:byte; lista:tLista; infoConfig:tVector; velocidadTexto:boolean);
procedure checkPantallaLlena(var paginaActual:byte; var ultimaPagina:byte; var posicionYuser:byte; var posicionYbot:byte; var lista:tLista);
procedure contarLineas(entrada:ansiString; var cantidadLineas:byte);
procedure textoUsuario(var lista:tLista; posicionYuser:byte; entradaAux:string; username:string);
procedure textoBot(var lista:tLista; var cantidadLineas:byte; posicionYbot:byte; respuesta:ansiString; velocidadTexto:boolean);		

implementation

procedure textoUsuario(var lista:tLista; posicionYuser:byte; entradaAux:string; username:string);
begin

	delete(entradaAux, length(entradaAux), length(entradaAux));
	entradaAux := '[' + DateTimeToStr(Now) + '] '+entradaAux;
	agregarNoOrdenado(lista, entradaAux);
	gotoxy(118-length(entradaAux), posicionYuser+2);
	writeln(entradaAux);
	dibujarBoxUser(entradaAux, posicionYuser, username);	

end;

procedure textoBot(var lista:tLista; var cantidadLineas:byte; posicionYbot:byte; respuesta:ansiString; velocidadTexto:boolean);
begin

	gotoxy(10, posicionYbot);
	writeln('  BOT: ');

	respuesta := '[' + DateTimeToStr(Now) + '] ' + respuesta;

	contarLineas(respuesta, cantidadLineas);
	dibujarBoxBot(respuesta, cantidadLineas, posicionYbot);		
	delete(respuesta, 1, pos('] ', respuesta));
						
	gotoxy(5, posicionYbot+2);
	animation('Escribiendo...', 30, velocidadTexto); //finge escribir

	sleep(1100); //espera a responder
	gotoxy(5, posicionYbot+2);
	write('                   ');

	respuesta := '[' + DateTimeToStr(Now) + ']' + respuesta;
	agregarNoOrdenado(lista, respuesta);
						
	gotoxy(5, posicionYbot+2);
	animation(respuesta, 30, velocidadTexto);

end;

procedure contarLineas(entrada:ansiString; var cantidadLineas:byte);
var x, y, i, auxX:integer;

begin

	cantidadLineas := 1;

	x:=whereX;
	auxX:=x;
	y:=whereY;

	for i:=1 to length(entrada) do
	begin

		if x>105 then 
		begin
			y+=1;
			x:=auxX;
			cantidadLineas +=1;
		end;

		gotoxy(x,y);
		x:=x+1;

	end;

end;

procedure restaurarPagina(var lista:tLista; infoConfig:tVector; velocidadTexto:boolean);
var X:tDatoLista;
cantidadLineas, posicionYbot, posicionYuser:byte;
begin

	boxPrompt;
	posicionYuser := 5;
	posicionYbot := posicionYuser+4;
	cantidadLineas := 1;

	primero(lista);

	while not fin(lista) do
	begin

			recuperar(lista, X);
			//delete(X, 1, pos('] ', X));

			gotoxy(118-length(X), posicionYuser+2);
			writeln(X);

			dibujarBoxUser(X, posicionYuser, infoConfig[1]); 

			gotoxy(10, posicionYbot);
			writeln('  BOT: ');

			siguiente(lista);

			recuperar(lista, X);
			//delete(X, 1, pos('] ', X));
			contarLineas(X, cantidadLineas);

			dibujarBoxBot(X, cantidadLineas, posicionYbot);		//agregarle posicion en X
						
			gotoxy(5, posicionYbot+2);
			animation(X, 0, velocidadTexto);

			writeln;

			posicionYuser := posicionYbot+cantidadLineas+2;
			posicionYbot := posicionYuser+4;

			siguiente(lista);

	end;

	eliminarLista(lista);


end;

procedure subirPagina(var paginaActual:byte; ultimaPagina:byte; lista:tLista; infoConfig:tVector; velocidadTexto:boolean);
var sublista:tLista;
colorTexto:byte;
begin

	if (paginaActual>1) then
	begin

		clrscr;
		paginaActual -= 1;
		devolverSublista(lista, paginaActual, sublista, velocidadTexto);
		restaurarPagina(sublista, infoConfig, velocidadTexto);
		gotoxy(90,1);
		writeln('PAGINA: ', paginaActual, '/', ultimaPagina);
		InitKeyboard;

		asignacionColor(infoConfig[2], colorTexto);
		gotoxy(109, 1);
		textcolor(colorTexto);
		writeln('AUTOGUARDADO');
		textcolor(white);

				
	end
	else begin

		gotoxy(90,1);
		writeln('PAGINA: ', paginaActual, '/', ultimaPagina);
		gotoxy(90,2);
		writeln('NO SE PUEDE SUBIR MAS');
										

	end;

end;

procedure bajarPagina(var paginaActual:byte; ultimaPagina:byte; lista:tLista; infoConfig:tVector; velocidadTexto:boolean);
var sublista:tLista;
colorTexto:byte;
begin

	if (paginaActual<ultimaPagina) then
	begin
	
		clrscr;
		paginaActual += 1;
		devolverSublista(lista, paginaActual, sublista, velocidadTexto);
		restaurarPagina(sublista, infoConfig, velocidadTexto);
		gotoxy(90,1);
		writeln('PAGINA: ', paginaActual, '/', ultimaPagina);
		InitKeyboard;

		asignacionColor(infoConfig[2], colorTexto);
		gotoxy(109, 1);
		textcolor(colorTexto);
		writeln('AUTOGUARDADO');
		textcolor(white);
					

	end
	else begin

		gotoxy(90,1);
		writeln('PAGINA: ', paginaActual, '/', ultimaPagina);
		gotoxy(90,2);
		writeln('NO SE PUEDE BAJAR MÁS');
					
	end;

end;

procedure checkPantallaLlena(var paginaActual:byte; var ultimaPagina:byte; var posicionYuser:byte; var posicionYbot:byte; var lista:tLista);
begin

	if posicionYbot > 18 then 
	begin 

		borrarPantalla;
		boxPrompt;
		restaurarBoxPrompt;
		base;
		posicionYuser := 5;
		posicionYbot := posicionYuser+4;
		paginaActual += 1;
		ultimaPagina += 1;
		gotoxy(90,1);
		writeln('PAGINA: ', paginaActual, '/', ultimaPagina);
		agregarNoOrdenado(lista, '.');

	end;

end;

begin
end.