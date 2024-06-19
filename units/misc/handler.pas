unit handler;
{$IFDEF Windows} 
{$codepage UTF-8}
{$ENDIF}

interface

uses crt, Keyboard, SysUtils, lista, visuales, configuraciones;

procedure adminMenu();
procedure guardarDatosEnLista(var archivo:textfile; var lista:tLista);
procedure buscarClaveEnLista(lista:tLista; clave:tDatoLista; var posEncontrado:word; var cantidadRespuestas:word);	
procedure incluirHorarioLog(var lista:tLista; texto:string);
procedure guardarChatHandler(var lista:tLista; tiempo:tVector; autoGuardadoActivado:boolean);
procedure agregarLineas(const fileName: ansistring; lineChange:ansistring; lineCoinc:ansistring);

implementation


procedure guardarDatosEnLista(var archivo:textfile; var lista:tLista);
var datoLeido:ansistring;
begin

	crearlista(lista);
	reset(archivo);

	while not EOF(archivo) do
	begin

		readln(archivo, datoLeido);
		agregarNoOrdenado(lista, datoLeido);

	end;

	close(archivo);

end;

procedure agregarLineas(const fileName: ansistring; lineChange:ansistring; lineCoinc:ansistring);
var
  inputFile, outputFile: TextFile;
  data:ansistring;
begin
  Assign(inputFile, fileName);
  Assign(outputFile, 'temp.txt');
  
    Reset(inputFile);
    Rewrite(outputFile);
    
    while not EOF(inputFile) do
    begin

      ReadLn(inputFile, data);
      data := TrimLeft(data);
      if data <> lineCoinc then WriteLn(outputFile, data);
      if (data = lineCoinc) and (lineChange<>'') then Writeln(outputFile, lineChange);

    end;
    
    Close(inputFile);
    Close(outputFile);

    DeleteFile(fileName);
  RenameFile('temp.txt', fileName);
  end;


procedure analizarClave(X:tDatoLista; claveIngresada:tDatoLista; var cantidadRespuestas:word);
var posicionSeparador, comaSeparador:word;
subclaveX, aux:tDatoLista;
begin

	posicionSeparador := pos('$', X); 
	comaSeparador := pos(', ', X);

	cantidadRespuestas := 0;
	subclaveX := copy(X, 1, posicionSeparador-1); //subclave que no contiene el divisor $

	while (pos(' ', subclaveX) <> 0) do //si la subclave tiene espacios...
	begin

		comaSeparador := pos(', ', subclaveX)+2;
		
		aux := copy(subclaveX, 1, comaSeparador-3); //auxiliar que solamente contiene la palabra concreta a comparar

		if (pos(aux, claveIngresada) <> 0) or (pos(claveIngresada, aux) <> 0) then 
		begin 

			posicionSeparador := pos('$', X);
			val(copy(X, posicionSeparador+1, length(X)), cantidadRespuestas);

		end;
	
		subclaveX := copy(subclaveX, comaSeparador, length(subclaveX)); //la subclave que, además de tener contenido el auxiliar, tiene las demas variables a comparar

	end;

	if (pos(subclaveX, claveIngresada) <> 0) or (pos(claveIngresada, subclaveX) <> 0) then //si la 
	begin
 
		posicionSeparador := pos('$', X);
		val(copy(X, posicionSeparador+1, length(X)), cantidadRespuestas);

	end;


end;

procedure buscarClaveEnLista(lista:tLista; clave:tDatoLista; var posEncontrado:word; var cantidadRespuestas:word);
var X:tDatoLista;
posGlobal:word;
encontrado:boolean;
begin

	encontrado := false;
	posGlobal := 0; posEncontrado := 0;
	cantidadRespuestas := 0;

	primero(lista);

	//clrscr;

	while (not fin(lista)) and (not encontrado) do
	begin

		 recuperar(lista,X);
		 posGlobal += 1;

		 if pos('$', X) <> 0 then
		 begin

		 	analizarClave(X, clave, cantidadRespuestas);

		 	if cantidadRespuestas <> 0 then
		 	begin

		 		encontrado:=true;
		 		posEncontrado := posGlobal;

		 	end;

		 end; 
		 siguiente(lista);

	end;

end;

procedure incluirHorarioLog(var lista:tLista; texto:string);
var sublista:tLista;
X:tDatoLista;
begin

	crearLista(sublista);
	primero(sublista);
	agregarNoOrdenado(sublista, texto);
	agregarNoOrdenado(sublista, '');

	while not fin(lista) do
	begin

		recuperar(lista,X);
		agregarNoOrdenado(sublista, X);
		siguiente(lista);

	end;

	lista := sublista;

end;

procedure guardarChatHandler(var lista:tLista; tiempo:tVector; autoGuardadoActivado:boolean);
var arch:textfile;
sublista:tLista;
texto:string;
begin

	If Not DirectoryExists('chat') then CreateDir('chat');

	case autoGuardadoActivado of 
	true: texto :=  'HISTORIAL DE CHAT (AUTOGUARDADO)  ---  ' + tiempo[3] + '/' + tiempo[2] + '/' + tiempo[1] + ' ' + tiempo[4] + ':' + tiempo[5] + ':' + tiempo[6] + ' hs.';
	false: texto :=  'HISTORIAL DE CHAT  ---  '  + tiempo[3] + '/' + tiempo[2] + '/' + tiempo[1] + ' ' + tiempo[4] + ':' + tiempo[5] + ':' + tiempo[6] + ' hs.'; 
	end;

	borrarPuntosLista(lista, sublista);
	incluirHorarioLog(sublista, texto);

	assign (arch, './chat/log_' + tiempo[1] + '-' + tiempo[2] + '-' + tiempo[3] + '-' + tiempo[4] + tiempo[5] + tiempo[6] + '.txt');
	rewrite(arch);
	exportarListaArchivo(sublista, arch);
	
	eliminarLista(sublista);

end;

procedure introducirPalabraClave(lista:tLista; var clave:tDatoLista; var pos:word; var cantidadRespuestas:word);
begin

	clave := '';
	crearDibujo;
	box(25, 97, 8, 20, '.');
	gotoxy(25, 7);
	writeln('ADMINISTRADOR');
	gotoxy(54, 12);
	writeln('Introduzca palabra clave: ');
	gotoxy(56, 14);
	readln(clave);
	buscarClaveEnLista(lista, clave, pos, cantidadRespuestas);

end;

procedure consulta();
var lista:tLista;
pos, cantidadRespuestas:word;
clave:tDatoLista;
var archivoInformacion:textfile;
begin

	clrscr;

	assign (archivoInformacion, './data/datos.txt');
	{$I-}
	reset(archivoInformacion);
	{$I+}
	if IOResult = 0 then reset(archivoInformacion)
	else rewrite(archivoInformacion);

	guardarDatosEnLista(archivoInformacion, lista);

	gotoxy(39, 7);
	writeln('- ¿Que desea consultar?');

	introducirPalabraClave(lista, clave, pos, cantidadRespuestas);

	if cantidadRespuestas > 0 then
	begin
	clrscr;
	writeln('Info ----> Posicion en Archivo: ', pos, '. Cantidad de Respuestas Posibles: ', cantidadRespuestas); readkey; writeln;
	mostrar(lista, pos, cantidadRespuestas)
	end
	else if clave<>'' then begin gotoxy(30, 22); writeln('No ha sido encontrado! Revisa que este bien escrito o exista.'); readkey; end;

	eliminarLista(lista);

end;

procedure mostrarEncontrado(tipo:char; accion:char; posicion:word; cantidadRespuestas:word; var datoLeido:tDatoLista);
var i:word;
archivoInformacion:textfile;
salteado:boolean;
begin

	salteado:=false;
	assign(archivoInformacion, './data/datos.txt');
	reset(archivoInformacion);

	for i:=1 to posicion do readln(archivoInformacion, datoLeido);

	case tipo of	// respuesta de palabra clave. muestra de a 5 respuestas de la palabra clave encontrada.
	'1': begin 

			clrscr;
			i:=1;

			while i <= cantidadRespuestas do
			begin
				readln(archivoInformacion, datoLeido);
				writeln(i,') ', datoLeido); 
				logicaMostrarCinco(i, cantidadRespuestas, salteado);
			end;

			if (not salteado) and (cantidadRespuestas<>0) then readkey; clrscr;

		 end;

	'2': begin 
			
			gotoxy(49, 14);
			clreol;
			gotoxy(97, 14); writeln('.');
			gotoxy(49, 14);

			gotoxy(49, 14); 
			writeln(datoLeido); 
		 end;		//palabra clave. muestra la línea que contiene todas las palabras claves relacionadas, el $, y la cant. respuestas
	end;

	close(archivoInformacion);

end;

procedure cambiarCantidadRespuestas(lista:tLista; auxPos:word; var cantidadRespuestas:word; accion:char);
var DatoLeido, datoLeidoAux:tDatoLista;
i:word;
begin

	case accion of 
	'b': cantidadRespuestas-=1;
	'a': cantidadRespuestas+=1;
	end;

	primero(lista);

	for i:=1 to auxPos-1 do siguiente(lista);

	recuperar(lista, datoLeido);
	datoLeidoAux := datoLeido;

	datoLeido := copy(datoLeido, 1, pos('$', datoLeido)-1);
	datoLeido += '$'+IntToStr(cantidadRespuestas);

	if cantidadRespuestas = 0 then datoLeido := '';

	agregarLineas('./data/datos.txt', datoLeido, datoLeidoAux); 

end;

procedure eliminarTodasRespuestas(var lista:tLista; auxPos:word; cantidadRespuestas:word);
var datoLeido:tDatoLista;
i, j:word;
begin

	primero(lista);
	for i:=1 to auxPos-1 do siguiente(lista);
	recuperar(lista, datoLeido);

	eliminar(lista, datoLeido, datoLeido);

	for i:=1 to cantidadRespuestas do
	begin

		primero(lista);
		for j:=1 to auxPos-1 do siguiente(lista);
		recuperar(lista, datoLeido);
		eliminar(lista, datoLeido, datoLeido);

	end;

end;

procedure ingresarNuevoTIPO2(var lista:tLista; var clave:tDatoLista; accion:char; auxPos:word; var posicion:word; var cantidadRespuestas:word; var datoLeido:tDatoLista; var datoLeidoAux:tDatoLista; var nuevo:tDatoLista);
begin

buscarClaveEnLista(lista, clave, posicion, cantidadRespuestas);

	if (cantidadRespuestas <> 0) and (posicion=auxPos) then
	begin

		posicion := pos(clave, datoLeido);
		datoLeidoAux := datoLeido;

			case accion of
			'm': begin

					gotoxy(49, 14);
					clreol;
					gotoxy(97, 14); writeln('.');
					gotoxy(49, 14);

					gotoxy(49, 14);
					writeln('Ingrese nueva palabra para reemplazar "',clave,'": ');
					gotoxy(1, 1);
		    		write('Ingresar: ');
					readln(nuevo);

					delete(datoLeidoAux, posicion, length(clave));
					insert(nuevo, datoLeidoAux, posicion);
					nuevo := datoLeidoAux;

				 end;
			'b': begin

					if posicion = 1 then delete(datoLeidoAux, 1, length(clave)+2)
					else delete(datoLeidoAux, posicion-2, length(clave)+2);
					nuevo := '';

				 end;

			'a': begin 

					gotoxy(49, 14);
					clreol;
					gotoxy(97, 14); writeln('.');
					gotoxy(49, 14);	

					gotoxy(49, 14);
					writeln('Ingresa una palabra nueva para agregar: ');
					gotoxy(1, 1);
				   	write('Ingresar: ');
					readln(nuevo);
							
					if nuevo<>'' then nuevo := nuevo + ', ';
					insert(nuevo, datoLeidoAux, 1);
					nuevo := datoLeidoAux;

				 end;
			end;

	end
	else begin nuevo:='NOVALIDO'; end;
			
	
end;

procedure ingresarNuevoTIPO1(clave:tDatoLista; accion:char; var nuevo:tDatoLista);
var auxOp:word;
begin

	nuevo := '';
	
	if accion <> 'a' then val(clave, auxOp);

	case accion of
	'm': begin 
			
			gotoxy(49, 14);
			clreol;
			gotoxy(97, 14); writeln('.');
			gotoxy(49, 14);

			gotoxy(49, 14);
		   	writeln('¿Con que quiere reemplazar la opción "', auxOp ,'"?: ');
		 end;
	'a':  begin

			gotoxy(48, 12);
			clreol;
			gotoxy(97, 12); writeln('.');
			gotoxy(48, 12);

			gotoxy(48, 12);
			writeln('Ingrese nueva respuesta a "', clave ,'": ');
		  end;
	end;

	if accion<>'b' then
	begin 

		gotoxy(1, 1);
		write('Ingresar: ');
		readln(nuevo);	
		if nuevo='' then nuevo := 'NOVALIDO';

	end;

end;

//submenuConfirmarCambios(lista, cantidadRespuestas, auxPos, nuevo, datoLeido, datoLeidoAux, tipo, accion);

procedure buscarClaveEnArchivo(lista:tLista; clave:tDatoLista; cantidadRespuestas:word; auxPos:word; var nuevo:tDatoLista; var datoLeido:tDatoLista; var datoLeidoAux:tDatoLista; tipo:char; accion:char);
var auxOp, i:word;											
archivoInformacion:textfile;
begin

	
	val(clave, auxOp);

	if auxOp <> 0 then
	begin

		assign (archivoInformacion, './data/datos.txt');
		reset(archivoInformacion);

		for i:=1 to auxPos do readln(archivoInformacion, datoLeido);
		for i:=1 to auxOp do readln(archivoInformacion, datoLeido);

		close(archivoInformacion);

	end;

end;

procedure confirmarBorrado(lista:tLista; cantidadRespuestas:word; auxPos:word; datoLeido:tDatoLista; datoLeidoAux:tDatoLista; tipo:char);
var archivoInformacion:textfile;
begin

	case tipo of
	'1': begin

			cambiarCantidadRespuestas(lista, auxPos, cantidadRespuestas, 'b');
			agregarLineas('./data/datos.txt', datoLeidoAux, datoLeido);

		 end;
	
	'2': if (datoLeidoAux<>'') then agregarLineas('./data/datos.txt', datoLeidoAux, datoLeido) 
	     else
		 begin

				eliminarTodasRespuestas(lista, auxPos, cantidadRespuestas);
				exportarListaArchivo(lista, archivoInformacion);

				writeln('¡BORRADO CON ÉXITO!');
				readkey;

		 end;
	end;

end;

procedure desplazarLista(var lista:tLista; nuevo:tDatoLista; posicion:word);
var i:word;
X:tDatoLista;
listaAux:tLista;
begin

	primero(lista);
	crearlista(listaAux);

	for i:=1 to posicion do
	begin
		
		recuperar(lista, X);
		agregarNoOrdenado(listaAux, X);
		siguiente(lista);

	end;

	agregarNoOrdenado(listaAux, nuevo);

	while not fin(lista) do
	begin

		recuperar(lista, X);
		agregarNoOrdenado(listaAux, X);
		siguiente(lista);

	end;

	lista := listaAux;
	
end;

procedure confirmarAgregado(lista:tLista; nuevo:tDatoLista; cantidadRespuestas:word; auxPos:word; datoLeido:tDatoLista; datoLeidoAux:tDatoLista; tipo:char);
var archivoInformacion:textfile;
begin

	case tipo of
	'1': begin
			
			desplazarLista(lista, nuevo, auxPos);
			assign(archivoInformacion, './data/datos.txt');
			exportarListaArchivo(lista, archivoInformacion);
			cambiarCantidadRespuestas(lista, auxPos, cantidadRespuestas, 'a');

			writeln('¡AGREGADO CON ÉXITO!');
			readkey;

		 end;
	'2': if (datoLeidoAux<>'') then agregarLineas('./data/datos.txt', datoLeidoAux, datoLeido) 
	end;

end;

procedure submenuConfirmarCambios(var lista:tLista; cantidadRespuestas:word; auxPos:word; nuevo:tDatoLista; datoLeido:tDatoLista; datoLeidoAux:tDatoLista; tipo:char; accion:char);
var op:char;
begin

	gotoxy(1,23);

	case accion of
	'b', 'm':   begin
	////////////////////////////////////////////////////
					case nuevo of
				      	'': begin
								writeln('Se está por borrar "', datoLeido, '"');		
								
								gotoxy(48, 14);
								clreol;
								gotoxy(97, 14); writeln('.');
								gotoxy(48, 14);

								gotoxy(49, 14);
								write('¿Desea continuar? S/N: ');
								readln(op);
								if (op = 's') or (op = 'S') then confirmarBorrado(lista, cantidadRespuestas, auxPos, datoLeido, datoLeidoAux, tipo);	//se acepto borrar
							end;
                ////..............////
			  			'NOVALIDO': begin gotoxy(30, 22); writeln('No se ha efectuado ningún cambio.'); readkey; end;
				////............./////
						else begin
									if nuevo <> ' ' then
									begin

										writeln('Se está por modificar "', datoLeido, '"');
										writeln('y se va a cambiar por "',nuevo,'".'); writeln;
										
										gotoxy(48, 16);
										clreol;
										gotoxy(97, 16); writeln('.');
										gotoxy(48, 16);

										gotoxy(48, 16);
										write('¿Desea continuar? S/N: ');
										readln(op);
										if (op = 's') or (op = 'S') then agregarLineas('./data/datos.txt', nuevo, datoLeido);	//se modifica
								
									end;
						 	 end;
				////............../////
					end;
	//////////////////////////////////////////////////////
		 	 	end;
	'a': begin

			if nuevo <> 'NOVALIDO' then
			begin

				writeln('Se está por agregar "', nuevo, '"');
				
				gotoxy(48, 16);
				clreol;
				gotoxy(97, 16); writeln('.');
				gotoxy(48, 16);

				gotoxy(48, 16);
				write('¿Desea continuar? S/N: ');
				readln(op);
			
				if (op = 's') or (op = 'S') then confirmarAgregado(lista, nuevo, cantidadRespuestas, auxPos, datoLeido, datoLeidoAux, tipo);		//se agrega

			end;

		end;
	end;


end;

procedure noEncontrado();
begin

	crearDibujo;
	box(25, 97, 8, 20, '.');
	gotoxy(25, 7);
	writeln('ADMINISTRADOR');

	gotoxy(30, 22);
	writeln('No encontrado! Revise que exista o esté bien escrito.');
	readkey;

end;

procedure preguntarCambios(tipo:char; accion:char; var clave:tDatoLista; var numeroRespuesta:byte);
begin

	if accion <> 'a' then	//no aplica a agregar
	begin

		case tipo of
		'1': begin 			//se decide cambiar respuesta

				crearDibujo;
				box(25, 97, 8, 20, '.');
				gotoxy(25, 7);
				writeln('ADMINISTRADOR');
			
				gotoxy(48, 12);
				write('¿Que respuesta desea ');

				case accion of
				'b': write('ELIMINAR (NÚMERO): ');
				'm': write('MODIFICAR (NÚMERO): ');
				end;

				readln(clave);
				val(clave, numeroRespuesta);		//la respuesta es evaluada como numero (elegir opcion)

			 end;

		'2': begin 		//se decide cambiar palabra clave

				gotoxy(52, 12);
				clreol;
				gotoxy(97, 12); writeln('.');
				gotoxy(48, 12);

				case accion of
				'b': write('¿Cuál desea ELIMINAR?: ');
				'm': write('¿Cuál desea MODIFICAR?: ');
				end;

				readln(clave);	//escribir la palabra clave. agregar no necesita ser leida devuelta.

			 end;
		end;

	end;

end;

procedure agregarNuevaPalabra(var lista:tLista; clave:tDatoLista; accion:char; tipo:char);
var op:char;
archivoInformacion:textfile;
nuevo:string;
begin

	if (clave<>'') and (accion = 'a') then
		begin
			case tipo of
			'1': begin

					crearDibujo;
					box(25, 97, 8, 20, '.');
					gotoxy(25, 7);
					writeln('ADMINISTRADOR');


					gotoxy(49, 12);
					write('Clave nueva agregada!');
					gotoxy(1,1);
					write('Escriba una respuesta: ');
					readln(nuevo);

					
					gotoxy(1, 23);
					writeln('Se agregará la clave "',clave,'"" y la respuesta "', nuevo, '".');
					gotoxy(48, 16);
					write('¿Desea continuar? S/N: ');
					readln(op);

					clave := clave + '$1';

					if (op = 's') or (op = 'S') then
					begin

						agregarNoOrdenado(lista, clave);
						agregarNoOrdenado(lista, nuevo);
						assign(archivoInformacion, './data/datos.txt');
						exportarListaArchivo(lista, archivoInformacion);

					end;
				 end;
			end;
		end;

end;

procedure manipularClave(var lista:tLista; tipo:char; accion:char);
var 
datoLeido, datoLeidoAux, clave, nuevo:tDatoLista;
auxPos, posicion, cantidadRespuestas:word;
numeroRespuesta:byte;
begin

	numeroRespuesta := 1; //sirve como default en la opcion que no se usa. en la que se usa, es cambiado
	DatoLeido := '';
	clrscr;

	introducirPalabraClave(lista, clave, posicion, cantidadRespuestas);
	mostrarEncontrado(tipo, accion, posicion, cantidadRespuestas, datoLeido);
	
	auxPos := posicion;

	if (cantidadRespuestas = 0) and (clave<>'') then
	begin

		case accion of
		'b', 'm': noEncontrado;
		'a': if tipo='2' then noEncontrado; //el tipo 1 no va porque podría llegar a agregar palabras claves nuevas (implica que tenga al menos 1 pregunta)
		end;

	end;

	if datoLeido <> '' then		//por ejemplo: messi$3
	begin
	
		preguntarCambios(tipo, accion, clave, numeroRespuesta); //cual desea modificar/eliminar. NO APLICA A AGREGAR.

		if ((numeroRespuesta > 0) and (numeroRespuesta <= cantidadRespuestas)) then //si la respuesta es valida...
		begin

			buscarClaveEnArchivo(lista, clave, cantidadRespuestas, auxPos, nuevo, datoLeido, datoLeidoAux, tipo, accion);

			crearDibujo;
			box(25, 97, 8, 20, '.');
			gotoxy(25, 7);
			writeln('ADMINISTRADOR');

			case tipo of
			'1': ingresarNuevoTIPO1(clave, accion, nuevo);
			'2': ingresarNuevoTIPO2(lista, clave, accion, auxPos, posicion, cantidadRespuestas, datoLeido, datoLeidoAux, nuevo);
			end;

			submenuConfirmarCambios(lista, cantidadRespuestas, auxPos, nuevo, datoLeido, datoLeidoAux, tipo, accion);

		end
		else begin writeln('No es un número válido.'); readkey; end;

	end
	else agregarNuevaPalabra(lista, clave, accion, tipo); //si el dato de archivo está vacio. solo aplica para agregar nuevas palabras.

end;

procedure submenuSeleccion(accion:char);
var lista:tLista;
p, r:string;
op:char;
archivoInformacion:textfile;
begin

	clrscr;
	crearDibujo;
	box(25, 97, 8, 20, '.');
	gotoxy(25, 7);
	writeln('ADMINISTRADOR');

	assign (archivoInformacion, './data/datos.txt');
	{$I-}
	reset(archivoInformacion);
	{$I+}
	if IOResult = 0 then reset(archivoInformacion)
	else rewrite(archivoInformacion);

	guardarDatosEnLista(archivoInformacion, lista);

	p := 'Respuesta de Palabra Clave';
	r := 'Palabra Clave';

	gotoxy(39, 7);
	case accion of
	'b': write('- ¿Qué deseas eliminar?');
	'm': write('- ¿Qué deseas modificar?');
	'a': begin 
			writeln('- ¿Qué deseas agregar?');
			p := 'Respuesta de Palabra Clave Nueva o Existente';
			r := 'Palabra Clave a Respuesta/s Existente/s';
		 end;
	end;

	gotoxy(50, 12);
	writeln('1) ', p); 
	gotoxy(51, 14);
	writeln('2) ', r);
	gotoxy(50, 16);
	write('Opcion: ');
	readln(op);

	case op of
	'1': manipularClave(lista, '1', accion);
	'2': manipularClave(lista, '2', accion);
	end;

	eliminarLista(lista);

end;

procedure adminMenu();
var op:char;
begin

	repeat /////////////////////////////////////////
	
	clrscr;
	crearDibujo;
	box(25, 97, 8, 20, '.');
	gotoxy(25, 7);
	writeln('ADMINISTRADOR');
	gotoxy(48, 10);
	writeln('1) Agregar');
	gotoxy(50, 12);
	writeln('2) Borrar');
	gotoxy(51, 14);
	writeln('3) Modificar');
	gotoxy(50, 16);
	writeln('4) Consultar');
	gotoxy(48, 18);
	writeln('5) Salir');
	gotoxy(85, 18);
	write('Opcion: ');
	readln(op);

	case op of
	'1': submenuSeleccion('a');
	'2': submenuSeleccion('b');
	'3': submenuSeleccion('m');
	'4': consulta;
	end;

	until op='5'; ///////////////////////////////////

end;

begin
end.