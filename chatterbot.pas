program chatterbot;
{$IFDEF Windows} 
{$codepage UTF-8}
{$ENDIF}

uses handler in 'units/misc/handler.pas', 
lista in 'units/misc/lista.pas', 
sysutils, 
crt, 
keyboard, 
visuales in 'units/screen/visuales.pas', 
configuraciones in 'units/config/configuraciones.pas', 
dia in 'units/misc/dia.pas', 
music in 'units/misc/music.pas', 
menuPrincipal in 'units/screen/menuPrincipal.pas', 
paginas in 'units/screen/paginas.pas', 
respuestas in 'units/screen/respuestas.pas';

procedure escribirPrompt(var entrada:string); //limita la longitud de escritura para evitar bugs
var caracter: char;
guardarX:byte;
begin


	restaurarBoxPrompt;
	DoneKeyboard;

	caracter := #0;
	entrada := '';

	 repeat

	 	caracter := readkey;

		if (caracter <> #13) and (caracter <> #8) and (caracter <> #27) then write(caracter);	//----- Distinto de Enter y Backspace --------//

		if (caracter <> #8) then 
		begin 
		entrada := entrada + caracter;	//----- Distinto de Backspace -------//
		if whereX > 94 then 
			begin 
			gotoxy(whereX-1, 27);
			delete(entrada, length(entrada), 1);
			end;
		end
		else if (caracter <> #27) then
		begin

			if whereX > 9 then gotoxy(whereX-1, 27);
			delete(entrada, length(entrada), 1);
			ClrEol;
			guardarX := whereX;
			gotoxy(118, 27); writeln(')');
			gotoxy(guardarX, 27);

		end;

		if (caracter = #27) then
		begin

			if whereX > 9 then gotoxy(whereX, 27);
			delete(entrada, length(entrada), 1);
			caracter := #13;
			entrada := '';

		end;
	 	
	 until caracter=#13;

	 if length(entrada) = 1 then entrada := '';

	InitKeyboard;
	restaurarBoxPrompt;
	base;
	
end;

procedure chat;
var K: TKeyEvent;
entrada, entradaAux:string;
respuesta:tDatoLista;
cantidadLineas, posicionYbot, posicionYuser, paginaActual, ultimaPagina, colorTexto:byte;
lista, sublista:tLista;
infoConfig, tiempo:tVector;
forzarCierre, guardarChat, autoGuardadoActivado, velocidadTexto, musicaActiva:boolean;

begin

	crearLista(lista);
	leerConfiguracionesGuardadas(infoConfig, colorTexto, guardarChat, autoGuardadoActivado, velocidadTexto, musicaActiva); forzarCierre:=false;
	decodificarTiempo(tiempo);

	InitKeyboard;
	boxPrompt;

	posicionYuser := 5; posicionYbot := posicionYuser+4;
	paginaActual := 1;
	ultimaPagina := 1;
	K:= 0;

	gotoxy(90,1);
	writeln('PAGINA: ', paginaActual, '/', ultimaPagina);

    while (TKeyRecord(K).KeyCode<>283) and (not forzarCierre) do
	begin

		base;

		K:= GetKeyEvent;
		K:= TranslateKeyEvent(K);

		gotoxy(90,1);
		writeln('PAGINA: ', paginaActual, '/', ultimaPagina);

		case TKeyRecord(K).KeyCode of
		65313: subirPagina(paginaActual, ultimaPagina, lista, infoConfig, velocidadTexto);
		65319: bajarPagina(paginaActual, ultimaPagina, lista, infoConfig, velocidadTexto);
		7181: begin

				if paginaActual <> ultimaPagina then //por si decis revisar chat viejo. si no es el caso, esto no se ejecuta.
				begin 
					clrscr;
					devolverSublista(lista, ultimaPagina, sublista, velocidadTexto);
					restaurarPagina(sublista, infoConfig, velocidadTexto);
					paginaActual := ultimaPagina; 
				end;

				escribirPrompt(entrada);
				entradaAux := entrada;
				entrada := lowercase(entrada);

				if (entrada <> '') then
				begin

						checkPantallaLlena(paginaActual, ultimaPagina, posicionYuser, posicionYbot, lista);
						textoUsuario(lista, posicionYuser, entradaAux, infoConfig[1]);
						
						getResponse(entrada, respuesta);
						respuestasEspeciales(entrada, respuesta, forzarCierre, guardarChat);

						textoBot(lista, cantidadLineas, posicionYbot, respuesta, velocidadTexto);

						posicionYuser := posicionYbot+cantidadLineas+2;
						posicionYbot := posicionYuser+4;

				end;

				InitKeyboard;

		    end;

	    end;

	end;

	DoneKeyboard;
	if forzarCierre then readkey;

	if guardarChat then guardarChatHandler(lista, tiempo, autoGuardadoActivado);
	eliminarLista(lista);

end;

procedure chequearArchivoData(var hayData:boolean);
var archivo:textfile;
begin

	assign (archivo, './data/datos.txt');
	{$I-}
	reset(archivo);
	{$I+}
	if IOResult = 0 then hayData := true
	else hayData:=false;

end;

procedure ifChat(hayData:boolean);
begin

	if hayData then chat
	else begin

		gotoxy(25,22);
		writeln('¡No existe un archivo de datos! Si no lo borraste, ');
		gotoxy(25,23);
		write('entra a "Administrador" y agrega tus propias palabras claves.. o reinstalame :(');
		readkey;

	end;

end;

procedure menu(infoConfig:tVector; songName:string; Cmd:pchar; StopSong:pchar);
var op:string;
colorTexto:byte;
guardarChat, autoGuardadoActivado, velocidadTexto, musicaActiva:boolean;
hayData:boolean;

	begin

		repeat

			leerConfiguracionesGuardadas(infoConfig, colorTexto, guardarChat, autoGuardadoActivado, velocidadTexto, musicaActiva);
			hayData:=false;
			clrscr;
			
			chequearArchivoData(hayData);

			crearDibujo;
			box(25, 97, 8, 20, '.');

			{$IFDEF Windows} 
			gotoxy(3, 29);
			if (songName <> '') and (musicaActiva) then writeln('Sonando: ' + songName);
			{$ENDIF}

			gotoxy(25,7);
			write('Bienvenid@, ');
			textcolor(colorTexto);
			write(infoConfig[1], '!');
			textcolor(white);
			gotoxy(47, 10);
			textcolor(colorTexto);
			writeln('---- FOOTBALL CHATTERBOT ----');
			textcolor(white);
			gotoxy(79, 10);
			writeln('Opcion: ');
			gotoxy(56, 12);
			writeln('1) Iniciar');
			gotoxy(52, 14);
			writeln('2) Configuraciones');
			gotoxy(53, 16);
			writeln('3) Administrador');
			gotoxy(57,18);
			writeln('4) Salir');
			gotoxy(87, 10);
			readln(op);

			case op of
			'1': begin mostrarSeleccion(52, 12, colorTexto); ifChat(hayData); end; 
			'2': begin mostrarSeleccion(48, 14, colorTexto); configMenu(StopSong, Cmd, songName); end; 
			'3': begin mostrarSeleccion(49, 16, colorTexto); adminMenu;  end;
			'4': begin gotoxy(50, 22); animation('Adios, nos vemos pronto!', 30, velocidadTexto); mostrarSeleccion(53, 18, colorTexto); end;
			end;

		until op='4';

end;

procedure main;
var infoConfig:tVector;
listaCanciones:tVectorCanciones;
index:byte;
Cmd, StopSong:pchar;
songName:string;

begin

	configOpeningHandling(infoConfig);

	If Not DirectoryExists('music') then CreateDir('music');
	If Not DirectoryExists('data') then CreateDir('data');

	{$IFDEF Windows} 
	musicFinding(listaCanciones, index, Cmd, songName, StopSong); 
	if infoConfig[6]='Activada' then SendMCICommand(Cmd);; 
	{$ENDIF}

	if infoConfig[3]='Desactivado' then pantallaPrincipal(songName); //si esta desactivado, saltear pantalla principal

	menu(infoConfig, songName, Cmd, StopSong);

end;

begin

	randomize;
	main;

end.