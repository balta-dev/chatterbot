unit administrador;

interface

uses crt, SysUtils,
borrarEspacios, box, keyboard, music;
const N=3000;
type 

	t_vector = array [1..N] of AnsiString;
	t_vectorInt = array [1..N] of integer;

	procedure desacoplarData(var datos:textfile; var vectorTriggers:t_vector; var vectorRespuestas:t_vector; var vectorTotal:t_vector; var vectorCantidadRespuestas:t_vectorInt);
	procedure recorrerVectores(vector:t_vectorInt; vectorTotal:t_vector; buscado:string; var size:integer; var pos:integer);
	procedure guardarDatos(var datos:textfile; var vectorTotal:t_vector);
	procedure BorrarModificar(ansNum:byte; var datos:textfile; var vectorTotal:t_vector; modificar:boolean; auxiliar:ansiString; pos:integer; size:integer);
	procedure randomValue(var size:integer; var rand:integer);
	procedure genericFile(var vectorGenerico:t_vector; var exists:boolean; var found:ansiString; var size:integer);
	procedure buscarRegistro(var word:ansistring; var size:integer; var vectorRespuestas:t_vector; notChatterBot:boolean; var ansNum:byte; var datos:textfile; var found:AnsiString; var vectorTotal:t_vector; vectorCantidadRespuestas:t_vectorInt; mostrar:boolean; modificar:boolean);
	procedure listarVectorSTR(vector:t_vector);
	procedure quitarPalabraClave(ansNum:byte; var datos:textfile; var found:AnsiString; var vectorTotal:t_vector; vectorCantidadRespuestas:t_vectorInt);
	procedure modificarPalabraClave(ansNum:byte; var datos:textfile; var found:AnsiString; var vectorTotal:t_vector; vectorCantidadRespuestas:t_vectorInt);
	procedure agregarPalabraClave(var datos:textfile);
	procedure menuData(var op:string; var datos:textfile; found:ansiString; vectorTotal:t_vector; vectorCantidadRespuestas:t_vectorInt; vectorTriggers:t_vector);
	procedure crearDatos;
	
	implementation

    	procedure desacoplarData(var datos:textfile; var vectorTriggers:t_vector; var vectorRespuestas:t_vector; var vectorTotal:t_vector; var vectorCantidadRespuestas:t_vectorInt);
    	var gatherData:string;
    	cantidadRespuestas:integer; 
    	i, j, k:integer;
    	codigo:integer; //siempre va a ser 1
    	begin
    	j:=1;
    	
    		for i:=1 to N do
    		begin

    		readln(datos, gatherData);

    			if pos('$', gatherData) <> 0 then //encuentra triggers
    			begin

    				Val(copy(gatherData, pos('$', gatherData)+1, 3), cantidadRespuestas, codigo);
    				delete (gatherData, pos('$', gatherData) , 4);
    				vectorTriggers[i]:=gatherData;
    				vectorCantidadRespuestas[j]:=cantidadRespuestas;
    				vectorTotal[j] := vectorTriggers[i];

    					for k:=1 to cantidadRespuestas do
    					begin
    						readln(datos, gatherData);
    						vectorRespuestas[j]:=gatherData;
    						vectorTotal[j+1] := vectorRespuestas[j];
    						j:=j+1;
    					end;
    				j:=j+1;
    			end;

    		end;

    	end;

    	procedure recorrerVectores(vector:t_vectorInt; vectorTotal:t_vector; buscado:string; var size:integer; var pos:integer); //sirve para devolverme size
    	var i:integer;
    	begin

    		for i:=1 to N do
    		begin

    			if buscado=vectorTotal[i] then pos:=i;
    			size := vector[pos];
    			
    		end;

    	end;

    	procedure guardarDatos(var datos:textfile; var vectorTotal:t_vector);
    	var i:integer;
    	begin

    		rewrite(datos);
    		for i:=1 to N do
    		begin
    			writeln(datos, vectorTotal[i]);
    		end;

    	end;

    	procedure BorrarModificar(ansNum:byte; var datos:textfile; var vectorTotal:t_vector; modificar:boolean; auxiliar:ansiString; pos:integer; size:integer);
    	var k:integer; 
    	i:integer;
    	gatherData:ansiString;

    	begin

    		gotoxy(25,12);
    		if ansNum = 1 then begin

    		k:=1;

    		reset(datos);
    		

    		while not eof(datos) do
    		begin
    	
    			readln(datos, gatherData);
    			if gatherData <> '' then vectorTotal[k] := gatherData; 
    			k:=k+1;
    		end;


    		if modificar=false then 
    		begin
    			vectorTotal[pos] := '';
    			writeln(vectorTotal[pos])
    			end
    			else begin 

    				clrscr;
    				write('Ingresa la nueva palabra: ');
    				readln(auxiliar);
    				auxiliar := AnsiLowerCase(auxiliar+'$'+IntToStr(size));
    				vectorTotal[pos] := auxiliar;

    			end;
    		
    			i:=1;

    			for k:=1 to size do
    			begin

    				if modificar=false then begin
    		 
    				vectorTotal[pos+k] := ''
    			end
    			else begin
				auxiliar:='';
				write('Respuesta ', i, ': ');
				readln(auxiliar);

				while auxiliar='' do begin
				clrscr;
				gotoxy(25, whereY+2); 
				writeln('Error: No puede insertar una respuesta vacia.');
				gotoxy(25, whereY+2); 
				write('Respuesta ', i, ': ');
				readln(auxiliar);
				end;

			i:=i+1;
			vectorTotal[pos+k] := auxiliar;

			end;    		 

				close(datos);
				reset(datos);

    		end;

    		//close(datos);
    	clrscr;
		gotoxy(25,12);		
		writeln('Exito: La operacion fue procesada satisfactoriamente!');
		ansNum := 1;
		readkey;

		end
		else begin clrscr; gotoxy(25,12); writeln('Accion Cancelada/Invalida: La palabra clave NO ha sido alterada.'); readkey; end;
    	end; 

    	procedure randomValue(var size:integer; var rand:integer);
    	begin

    		while (rand>size) or (rand<1) do
    		begin 
    			rand:= random(254)+1;
    		end;

    	end;

    	procedure genericFile(var vectorGenerico:t_vector; var exists:boolean; var found:ansiString; var size:integer);
    	var generic:textfile;
    	gatherData:ansiString;
    	begin

    	assign(generic, 'generic.txt');
 		{$I-}
		reset (generic); 
		{$I+}

			if IOResult = 0 then
			begin

			reset(generic);

			size:=1;
			while not eof(generic) do
			begin

				readln(generic, gatherData);
				vectorGenerico[size] := gatherData;
				size:=size+1;

			end;

			size:=size-1;

			end;

    		end;

    	procedure transformKey(var datos:textfile; var found:ansistring; var exists:boolean; vectorTotal:t_vector; vectorTriggers:t_vector; vectorRespuestas:t_vector; vectorCantidadRespuestas:t_vectorInt);
    	var bus:ansistring;
    	i, j, k:integer;
    	//exists:boolean;
    	generic:textfile;

    	begin

 			exists:=false;
    		desacoplarData(datos, vectorTriggers, vectorRespuestas, vectorTotal, vectorCantidadRespuestas);
    		bus:='';

    		for i:=1 to length(found) do
				begin 

   	    			for j:=1 to length(found) do
        			begin
               	
        				bus := AnsiLowerCase(copy(found, i, j));
        				
        				for k:=1 to N do
        				begin

        					if (vectorTriggers[k]<>'') and (bus = vectorTriggers[k]) then begin found:=bus; exists:=true; end;

        				end;
        			
 					end;

 				end;

 		assign(generic, 'generic.txt');
 		{$I-}
		reset (generic); 
		{$I+}

			if IOResult <> 0 then
			begin

				if not exists then found:='3b5452e551bc025a4122233988dab33f9144eb5c9b03e9051159a2eb5144111d';

			end;

		//close(generic);

    	end;

    	procedure buscarRegistro(var word:ansistring; var size:integer; var vectorRespuestas:t_vector; notChatterBot:boolean; var ansNum:byte; var datos:textfile; var found:AnsiString; var vectorTotal:t_vector; vectorCantidadRespuestas:t_vectorInt; mostrar:boolean; modificar:boolean);
    	var i:integer;
    	gatherData:AnsiString;
    	pos:integer;
    	j:byte;
    	auxiliar:AnsiString;
    	vectorTriggers:t_vector;
    	generic:boolean;
    	exists:boolean;
    	ansNumSTR:string;
    	code:integer;
    	
    	begin

    		exists:=false;
    		//ansNum := 3;
    		size:=0; generic:=false;

    		if notChatterbot=true then clrscr;
    		pos:=0;
    		j:=1;

    		if notChatterbot=true then
    		begin 
    			gotoxy (25, 10);
    			write('Buscar por palabra clave: ');
    		end;

    		readln(word);

    		found:=word;

    		transformKey(datos, found, exists, vectorTotal, vectorTriggers, vectorRespuestas, vectorCantidadRespuestas);

    		//found := AnsiLowerCase(found);
    		recorrerVectores(vectorCantidadRespuestas, vectorTotal, found, size, pos); //este es sin codigo

    		if (found='3b5452e551bc025a4122233988dab33f9144eb5c9b03e9051159a2eb5144111d') and (pos=0) then found:='notfound404';

    		reset(datos);

    		for i:=1 to N do
    		begin

    			readln(datos, gatherData);

    				
    				if gatherData = found+'$'+IntToStr(vectorCantidadRespuestas[pos]) then //este es sin codigo
    				begin
    				auxiliar := found;
    				found := 'enc';
    				pos:=i;
    				end;

    				
    				if mostrar = true then   //una posibilidad es mostrar
    				begin
    					if (found = 'enc') and (i<=pos+size) then 
    					begin
    					gotoxy(25, 12);
    					if notChatterbot=true then writeln('Info ----> Posicion en Archivo: ', pos, '. Size del Array: ', size);
    					writeln;

    						if (j-1 <> 0) and (notChatterbot=true) then 
    						begin 
    							writeln; 
    							writeln(j-1, ') ', gatherData); 
    							readkey; 
    						end;

    						if notChatterbot=false then vectorRespuestas[j-1]:=gatherData; 

    						j:=j+1;
    					end
    					else if (found <> 'enc') and ((i>=pos+size) and (i<pos+size+2)) and (notChatterbot=true) then 
    					begin 
    					
    						 gotoxy(25, 12); 
    							writeln('No ha sido encontrado! Revisa que este bien escrito o exista.');
    							readkey; 
    						 

    					end
    					else if (found <> 'enc') and ((i>=pos+size) and (i<pos+size+2)) and (notChatterbot=false) then
    					begin
    						auxiliar:=found;
    						generic:=true;

    					end;

    				end;

    				if mostrar = false then   //la otra posibilidad al buscar es que quieras borrar o modificarlo
    				begin
 
    					gotoxy(25, 12);

    					if (found = 'enc') and (i<=pos) then
    					begin

    						if (modificar = false) and (notChatterbot = true) then 
    						begin
    							writeln('Estas seguro/a que deseas eliminar la palabra clave "', auxiliar, '"? Si:1, No:2');
    							gotoxy(25,13);
    							textcolor(red);
    							writeln('ESTA ACCION NO ES REVERSIBLE!');
    							textcolor(white);
    							gotoxy(25,15);
    							writeln('Posicion: ', pos, '. Cant. Respuestas: ', size);
    							//gotoxy(25, 17);
    							write('Opcion: ');
    							readln(ansNumSTR);
    							clrscr;
    						end
    						else if (modificar = true) and (notChatterbot = true) then 
    						begin
    							textcolor(yellow);
    							writeln('Estas seguro/a que deseas modificar la palabra clave "', auxiliar, '"? Si:1, No:2');
    							textcolor(white);
    							gotoxy(25,14);
    							writeln('Posicion: ', pos, '. Cant. Respuestas: ', size);
    							write('Opcion: ');
    							readln(ansNumSTR);
    						end;

    						while (ansNumSTR<>'1') and (ansNumSTR<>'2') do
    						begin

    							clrscr;
    							gotoxy(25,12);
    						 	writeln('No es una respuesta valida. Si:1, No:2');
    						 	write('Opcion: ');
    						 	readln(ansNumSTR);

    						end;

    						Val(ansNumSTR, ansNum, Code);

    					end;

    	
    				end;
    
    		end;

    		

    		found:=auxiliar; //para tener una salida

    		//writeln(found)


    		if (mostrar=false) and (notChatterbot=true) then BorrarModificar(ansNum, datos, vectorTotal, modificar, auxiliar, pos, size);

    		pos:=0; //auxiliar
    		if (mostrar=true) and (notChatterbot=false) and (generic=false) then randomValue(size, pos);

    		if (generic=true) then genericFile(vectorRespuestas, exists, found, size);
    		//writeln('final de buscar registro');

    		//ansNum := 3;

    	end;

 	
	procedure listarVectorSTR(vector:t_vector);
	var i, velocidad:integer;
	op:string;
	begin

		op:='';
		clrscr;
		gotoxy(25,12);		
		writeln('A que velocidad del 1 al 5?   Opcion:');
		gotoxy(25,14);
		writeln('1=Lento, 5=Rapido');
		gotoxy(63,12);

		while (op<>'1') and (op<>'2') and (op<>'3') and (op<>'4') and (op<>'5') do                //ARREGLAR
		begin
		readln(op);
		case op of
		'1': velocidad:=300;
		'2': velocidad:=100;
		'3': velocidad:=50;
		'4': velocidad:=10;
		'5': velocidad:=1;
		else begin clrscr; gotoxy(25,12); write('No es valido. Ingrese nuevamente: '); end;
		end;

		end;

		writeln; writeln; writeln;

		InitKeyboard;
		for i:=1 to N do
		begin
			if (vector[i] <> '') and (vector [i] <> '3b5452e551bc025a4122233988dab33f9144eb5c9b03e9051159a2eb5144111d') then
			begin
				gotoxy(25, whereY);
				writeln(vector[i]);
				sleep(velocidad);
				
				if keyPressed then
     			begin
     				sleep(1000);
     				DoneKeyboard;
     				InitKeyboard;			
     			end;

			end;
			
		end;
		DoneKeyboard;

	end;

	procedure quitarPalabraClave(ansNum:byte; var datos:textfile; var found:AnsiString; var vectorTotal:t_vector; vectorCantidadRespuestas:t_vectorInt);
	var auxiliarVec:t_vector; size:integer; word:ansiString; //no hace nadas
	begin			

		buscarRegistro (word, size, auxiliarVec, true, ansNum, datos, found, vectorTotal, vectorCantidadRespuestas, false, false);
		if (found <> '') and (ansNum = 1) then

		begin
			//writeln('no es vacio y ansnum =1 ');
			//readln;

			guardarDatos(datos, vectorTotal);
			close(datos);
		//	RemoveEmptyLinesFromFile('datos.txt');
		end;

		RemoveEmptyLinesFromFile('datos.txt');
		reset(datos);

	end;

	procedure modificarPalabraClave(ansNum:byte; var datos:textfile; var found:AnsiString; var vectorTotal:t_vector; vectorCantidadRespuestas:t_vectorInt);
	var auxiliarVec:t_vector; size:integer; word:ansiString; //no hace nada
	begin

		buscarRegistro (word, size, auxiliarVec, true, ansNum, datos, found, vectorTotal, vectorCantidadRespuestas, false, true);
		if (found <> '') and (ansNum = 1) then
		begin
			guardarDatos(datos, vectorTotal);
			close(datos);
			//RemoveEmptyLinesFromFile('datos.txt');
		end;

		RemoveEmptyLinesFromFile('datos.txt');
		reset(datos);

	end;

	procedure agregarPalabraClave(var datos:textfile); 
	var key:string;
	ansNum:byte;
	ansNumSTR:string;
	i:byte;
	aux:string;
	code:integer;

	begin

		i:=1;

		reset(datos);
		//sleep(500);
		//append(datos);

		clrscr;
		gotoxy (25, 10);
		write('Ingrese palabra clave a crear: ');
		readln(key);

		while key='' do
		begin

			clrscr;
			gotoxy (25, 10);
			write('No se puede ingresar una palabra vacia. Ingrese nuevamente: ');
			readln(key);

		end;

		gotoxy (25, whereY+2);
		write('Ingrese cantidad de posibles respuestas (de ser 0, se cancela): ');
		readln(ansNumSTR);
		Val(ansNumSTR, ansNum, Code);

		while (code <> 0) or (ansNum<0) do
		begin

			clrscr;
			gotoxy(25, 10);
			writeln('Error: Solamente se pueden ingresar numeros que sean mayores que 1. Si ingresa 0 se cancela la operacion.');
			gotoxy(25, whereY+2);
			write('Ingrese cantidad de posibles respuestas: ');
			readln(ansNumSTR);
			Val(ansNumSTR, ansNum, Code);

		end;
		

		//writeln(ansNum);
		//readln;
if ansNum <> 0 then begin
		aux:=AnsiLowerCase(key+'$'+IntToStr(ansNum));

		append(datos);
		writeln(datos, aux);
		clrscr;
		gotoxy (25, whereY+2);

		while i<=ansNum do
		begin
			gotoxy(25, whereY+2); 
		
			write('Respuesta ', i, ': ');
			readln(key);

				while key='' do 
				begin
					clrscr;
					gotoxy(25, whereY+2); 
					writeln('Error: No puede insertar una respuesta vacia.');
					gotoxy(25, whereY+2); 
					write('Respuesta ', i, ': ');
					readln(key);
				end;
			i:=i+1;
			writeln(datos, key);
			readkey;
		end;

		gotoxy(25, whereY+2);
		writeln('Desea guardar la nueva palabra clave? Si:1, No:2');
		write('Opcion: ');
		readln(ansNumSTR);

		if ansNumSTR='1' then begin close(datos); reset(datos); end;
end;

	end;

	procedure menuData(var op:string; var datos:textfile; found:ansiString; vectorTotal:t_vector; vectorCantidadRespuestas:t_vectorInt; vectorTriggers:t_vector);
	var ansNum:byte;
	auxiliarVec:t_vector; size:integer; word:ansiString; //no hace nada
	symbol:char;
	begin

		clrscr;
		//SendMCICommand('play "music.mp3"');
		symbol:='*';
		boxDO(20, 70, 7, 25, symbol, true);
		gotoxy (25, 10);
		writeln('1) Buscar por palabra clave');
		gotoxy (25, 12);
		writeln('2) Listar todas las palabras clave'); //podria usar los vectores de las constantes, pero como luego no va a existir no sirve
		gotoxy (25, 14);
		writeln('3) Agregar palabras clave');
		gotoxy (25, 16);
		writeln('4) Quitar palabras clave');
		gotoxy(25, 18);
		writeln('5) Modificar palabra clave existente');
		gotoxy(25, 20);
		writeln('6) Volver Atras');
		gotoxy(50, 20);
		write('Opcion: ');
		readln(op);
		case op of
		'1': buscarRegistro (word, size, auxiliarVec, true, ansNum, datos, found, vectorTotal, vectorCantidadRespuestas, true, false);
		'2': listarVectorSTR(vectorTriggers);
		'3': agregarPalabraClave(datos);
		'4': quitarPalabraClave(ansNum, datos, found, vectorTotal, vectorCantidadRespuestas);
		'5': modificarPalabraClave(ansNum, datos, found, vectorTotal, vectorCantidadRespuestas);
		'6': clrscr;
		end;
	end;

	procedure crearDatos;
	var datos:textfile;
	found:string;
	vectorTriggers:t_vector;
	vectorRespuestas:t_vector;
	vectorTotal:t_vector;
	vectorCantidadRespuestas:t_vectorInt;
	op:string;
	begin

		found := '';
		op:='0';

		 //está aca en vez de menu por las dudas si necesito desacoplar la data del archivo y volcarlo en vectores
while op <> '6' do begin
		assign (datos, 'datos.txt');
		{$I-}
		reset (datos); 
		{$I+}

		if IOResult = 0  then
		begin

			reset(datos);
			desacoplarData(datos, vectorTriggers, vectorRespuestas, vectorTotal, vectorCantidadRespuestas);
			close(datos);
			reset(datos);
			menuData(op, datos, found, vectorTotal, vectorCantidadRespuestas, vectorTriggers);
			close(datos);
	
		end
		else 
			begin 
			op:='6'; 
			clrscr;
			gotoxy(25, 12); 
			writeln('Archivo "datos.txt" faltante...'); 
			gotoxy(25, 13); 
			writeln('Comprueba de que el archivo exista en el mismo directorio que el ejecutable.'); 
			gotoxy(25, 15); 
			write('Presiona una tecla para terminar el programa.');
			readkey;
			clrscr;
			end;

		end;
end;

	begin //main

		//crearDatos; //datos base
	end.