unit respuestas;

interface

uses lista, handler, sysutils, dia;

function randomValue(size:integer):integer;
procedure devolverRespuesta(lista:tLista; var X:tDatoLista; pos:word; numeroRandom:word);
procedure getResponse(input:tDatoLista; var output:tDatoLista);
procedure recorrerPalabra(entrada:string; var respuesta:ansistring; var forzarCierre:boolean; var guardarChat:boolean);
procedure respuestasEspeciales(entrada:string; var respuesta:ansistring; var forzarCierre:boolean; var guardarChat:boolean);

implementation

function randomValue(size:integer):integer;
begin

    randomValue:= (1+random(10000)) mod 34234 + 1;

    while (randomValue>size) do
    begin 
    	randomValue:= random(size)+1;
    end;

end;

procedure devolverRespuesta(lista:tLista; var X:tDatoLista; pos:word; numeroRandom:word);
var i:word;
begin

	primero(lista);

	for i:=1 to pos do siguiente(lista);

	for i:=1 to numeroRandom-1 do
	begin

		recuperar(lista, X);
		siguiente(lista);

	end;

	recuperar(lista, X);

end;

procedure devolverRespuestaGenerica(var X:tDatoLista);
var generico:textfile;
contador, i:word;
lista:tLista;
Xaux:tDatoLista;
begin

	contador := 0;

	assign(generico, '.\data\generic.txt');
	{$I-}
	reset(generico);
	{$I+}

	if IOResult = 0 then 
		begin

			reset(generico);

			while not EOF(generico) do
			begin
				readln(generico, X);			//LEE SI TIENE O NO ELEMENTOS GUARDADOS									
				contador += 1;
			end;
	

	close(generico);

	reset(generico);
	guardarDatosEnLista(generico, lista);

	if not lista_vacia(lista) then
	begin

		primero(lista);
		recuperar(lista, Xaux);

		for i:=1 to (randomValue(contador))-1 do
		begin

			siguiente(lista);
			recuperar(lista, Xaux);

		end;

		if Xaux <> '' then X := Xaux;

		eliminarLista(lista);

	end;

	end
	else X:='No pude entender. Esa palabra clave no se encuentra en mi base de datos.';


end;

procedure getResponse(input:tDatoLista; var output:tDatoLista);
var arch:textfile;
lista:tLista;
posicion, cantidadRespuestas:word;
cantResp:integer;
begin

	assign(arch, './data/datos.txt');
	reset(arch);
	guardarDatosEnLista(arch, lista);
	buscarClaveEnLista(lista, input, posicion, cantidadRespuestas);
	cantResp := cantidadRespuestas;
	if cantResp <> 0 then devolverRespuesta(lista, output, posicion, randomValue(cantResp))
	else devolverRespuestaGenerica(output);

end;

procedure recorrerPalabra(entrada:string; var respuesta:ansistring; var forzarCierre:boolean; var guardarChat:boolean); //procedimiento eficientizado
var i, j:byte;
entradaAux:string;
begin

entradaAux := entrada;

for j:=1 to length(entrada) do
begin

	for i:=1 to length(entrada)+1-j do
		begin

			entrada := copy(entrada, i, j);

			case entrada of
			'hora': respuesta := 'Ahora mismo en tu zona horaria son las '+TimeToStr(Time)+'.';
			'historial', 'guarda', 'chat', 'record': begin respuesta := 'Como tu desees.. el chat lo guardare dentro de la carpeta "chat".'; guardarChat := true; end;
			'dia', 'hoy': respuesta := 'Hoy es ' + diaActual;
			'chau', 'vemos', 'adio', 'bye', 'cya', 'nv', 'voy': forzarCierre := true;
			end;

			entrada := entradaAux;

		end;
end;

end;

procedure respuestasEspeciales(entrada:string; var respuesta:ansistring; var forzarCierre:boolean; var guardarChat:boolean);
var entradaAux:string;

begin

	delete(entrada, length(entrada), length(entrada));

	while (pos(' ', entrada)<>0) do
	begin

		entradaAux := entrada;
		entrada := copy(entradaAux, 1, pos(' ', entrada)-1);

		recorrerPalabra(entrada, respuesta, forzarCierre, guardarChat);

		entrada := entradaAux;
		entrada := copy(entradaAux, pos(' ', entrada)+1, length(entrada));

	end; 

	recorrerPalabra(entrada, respuesta, forzarCierre, guardarChat);

end;

begin
end.