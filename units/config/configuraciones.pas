unit configuraciones;

interface

uses crt, SysUtils, music, visuales;
type tVector = array [1..6] of string;
vectorColores = array [1..16] of string;

procedure configOpeningHandling(var infoConfig:tVector);
procedure asignacionColor(colorTextoSTR:string; var colorTextoBYTE:byte);
procedure leerConfiguracionesGuardadas(var infoConfig:tVector; var colorTexto:byte; var guardarChat:boolean; var autoGuardadoActivado:boolean; var velocidadTexto:boolean; var musicaActiva:boolean);
procedure configMenu(var StopSong:pchar; var Cmd:pchar; var songName:string);	

implementation

procedure configClosingHandling(var infoConfig:tVector);
var configuration:textfile;
	begin

		//if autoSave then
		//save:=true;

		assign (configuration, './data/config.txt');

		rewrite(configuration);
		writeln(configuration, 'Nombre: '+ infoConfig[1]);
		writeln(configuration, 'Color_texto_BOT: ' + infoConfig[2]);
		writeln(configuration, 'Skip_menu: ' + infoConfig[3]);
		writeln(configuration, 'Guardar_chat: ' + infoConfig[4]);
		writeln(configuration, 'Type_text_compl: ' + infoConfig[5]);
		writeln(configuration, 'Musica: ' + infoConfig[6]);

		close(configuration);
		clrscr;

	end;

procedure configDefault(var infoConfig:tVector);
var configuration:textfile;
barra:char;
	begin

		//las configuraciones predeterminadas DEBEN EXISTIR

		barra := '/';
		assign (configuration, './data/config.txt');

		infoConfig[1]:=GetUserDir;
		infoConfig[2]:='Amarillo';
		infoConfig[3]:='Desactivado';
		infoConfig[4]:='Desactivado';
		infoConfig[5]:='Activado';
		infoConfig[6]:='Activada';								//DEFAULT PRESET
		
		{$IFDEF Windows}
		barra := '\';
		{$ENDIF}

		delete(infoConfig[1], 1, pos(barra, infoConfig[1]));
		delete(infoConfig[1], 1, pos(barra, infoConfig[1]));
		delete(infoConfig[1], pos(barra, infoConfig[1]), length(infoConfig[1]));
		
		rewrite(configuration);
		writeln(configuration, 'Nombre: '+ infoConfig[1]);
		writeln(configuration, 'Color_texto_BOT: ' + infoConfig[2]);
		writeln(configuration, 'Skip_menu: ' + infoConfig[3]);
		writeln(configuration, 'Guardar_chat: ' + infoConfig[4]);
		writeln(configuration, 'Type_text_compl: ' + infoConfig[5]);
		writeln(configuration, 'Musica: ' + infoConfig[6]);
		close(configuration);

	end;

procedure asignacionColor(colorTextoSTR:string; var colorTextoBYTE:byte);
begin

	case colorTextoSTR of
	'Azul': colorTextoBYTE:=1;
	'Verde': colorTextoBYTE:=2;
	'Cyan': colorTextoBYTE:=3;
	'Rojo': colorTextoBYTE:=4;
	'Magenta': colorTextoBYTE:=5;
	'Marron': colorTextoBYTE:=6;
	'Gris claro': colorTextoBYTE:=7;
	'Gris oscuro': colorTextoBYTE:=8;
	'Celeste': colorTextoBYTE:=9;
	'Verde claro': colorTextoBYTE:=10;
	'Cyan claro': colorTextoBYTE:=11;
	'Rojo claro': colorTextoBYTE:=12;
	'Magenta claro': colorTextoBYTE:=13;
	'Amarillo': colorTextoBYTE:=14;
	'Blanco': colorTextoBYTE:=15;
	end;


end;

procedure configGathering(var infoConfig:tVector);
var configuration:textfile;
iterator:1..6;
data:string;

	begin

		assign (configuration, './data/config.txt');

		reset(configuration);
		for iterator:=1 to 6 do
		begin
			readln(configuration, data);
			infoConfig[iterator] := data;
			//writeln(infoConfig[iterator]);
		end;
		close(configuration);

	/////// RECORTE DE DATOS

		delete (infoConfig[1], 1, 8);	//nombre		
		delete (infoConfig[2], 1, 17);  //colortextostr
		delete (infoConfig[3], 1, 11);  //saltearmenu
		delete (infoConfig[4], 1, 14);  //autosave
		delete (infoConfig[5], 1, 17);  //tipoescritrua
		delete (infoConfig[6], 1, 8);   //musica

	//////////////////////////

		clrscr;
		
	end;

procedure configOpeningHandling(var infoConfig:tVector);
var iterator:1..6;
missing:boolean;
data:string;
var configuration:textfile;

	begin

		missing:=false;

		assign (configuration, './data/config.txt');
		{$I-}
		reset(configuration);
		{$I+}

		if IOResult = 0 then 
		begin

			reset(configuration);

			for iterator:=1 to 6 do
			begin
				readln(configuration, data);			//LEE SI TIENE O NO ELEMENTOS GUARDADOS									
				if data='' then missing := true;
			end;

		    close(configuration);

		end
		else missing:=true;

	if missing then configDefault(infoConfig) 
	else configGathering(infoConfig);

end;

procedure leerConfiguracionesGuardadas(var infoConfig:tVector; var colorTexto:byte; var guardarChat:boolean; var autoGuardadoActivado:boolean; var velocidadTexto:boolean; var musicaActiva:boolean);
begin

	configOpeningHandling(infoConfig);

	asignacionColor(infoConfig[2], colorTexto);

		if infoConfig[4] = 'Activado' then 
		begin

			gotoxy(109, 1);
			textcolor(colorTexto);
			writeln('AUTOGUARDADO');
			textcolor(white);
			guardarChat := true;
			autoGuardadoActivado := true;

		end
		else begin guardarChat := false; autoGuardadoActivado := false; end;

		if infoConfig[5] = 'Activado' then velocidadTexto := true else velocidadTexto := false;

		if infoConfig[6] = 'Activada' then musicaActiva := true else musicaActiva := false;

end;

procedure configMenu(var StopSong:pchar; var Cmd:pchar; var songName:string);	
var op, colorTextoSTR:string;
colores:vectorColores;
index, i, colorTextoBYTE:byte;
infoConfig, valueConfig:tVector; 
listaCanciones:tVectorCanciones;							

	begin

		repeat

			clrscr;
			configOpeningHandling(infoConfig);
			asignacionColor(infoConfig[2], colorTextoBYTE);

			crearDibujo;

			gotoxy(25, 7);
			writeln('CONFIGURACIONES');

			box(25, 97, 8, 24, '.');
			gotoxy(45, 10);
			write('1) Nombre de Usuario: '); textcolor(colorTextoBYTE); writeln(infoConfig[1]); textcolor(white);		
			gotoxy(43, 12);
			write('2) Color de texto del BOT: '); textcolor(colorTextoBYTE); writeln(infoConfig[2]); textcolor(white);     
			gotoxy(48, 14);
			write('3) Ignorar menu: '); textcolor(colorTextoBYTE); writeln(infoConfig[3]); textcolor(white);		
			gotoxy(39, 16);
			write('4) Guardar chat automaticamente: '); textcolor(colorTextoBYTE); writeln(infoConfig[4]); textcolor(white);
			gotoxy(39, 18);
			write('5) Completado de texto progresivo: '); textcolor(colorTextoBYTE); writeln(infoConfig[5]); textcolor(white);
			gotoxy(50, 20);
			write('6) Musica: '); textcolor(colorTextoBYTE); writeln(infoConfig[6]); textcolor(white);
			gotoxy(51, 22);
			write('7) Volver Atras');
			gotoxy(85, 22);
			write('Opcion: ');

			{$IfNDef Windows}
			gotoxy(1, 29);
			writeln('Advertencia: Si no se está ejecutando en Windows, "Música" no tiene ningún efecto.');
			writeln('MMSystem es una biblioteca parte del API Microsoft Multimedia.');
			gotoxy(93, 22);
			{$ENDIF}


			readln(op);

			case op of
			'1': //nombre de usuario
				begin
					//clrscr; 
					
					gotoxy(45, 10);
					ClrEol;
					gotoxy(97, 10); writeln('.');
					gotoxy(45, 10);
					write('1) Nombre de Usuario: '); textcolor(colorTextoBYTE); readln(infoConfig[1]); textcolor(white);
				end;
			'2': //color letras
				begin
	
					clrscr; 
					box(25, 97, 8, 24, '.');
					gotoxy(25, 7);
					writeln('CONFIGURACIONES - Seleccione un color: ');
					writeln;
	
					colores[1] := 'Azul';
					colores[2] := 'Verde';
					colores[3] := 'Cyan';
					colores[4] := 'Rojo';
					colores[5] := 'Magenta';
					colores[6] := 'Marron';
					colores[7] := 'Gris claro';
					colores[8] := 'Gris oscuro';
					colores[9] := 'Celeste';
					colores[10] := 'Verde claro';
					colores[11] := 'Cyan claro';
					colores[12] := 'Rojo claro';
					colores[13] := 'Magenta claro';
					colores[14] := 'Amarillo';
					colores[15] := 'Blanco';


					for i:=1 to 15 do
					begin
					gotoxy(25, whereY);
					writeln(i, ') ', colores[i]);
					end;

					gotoxy(64, 7);

					readln(valueConfig[2]);
						
					if (valueConfig[2] <> '') then
					begin

						val(valueConfig[2], colorTextoBYTE);
		
						while (colorTextoBYTE<=0) or (colorTextoBYTE>15) do
						begin
							gotoxy(25, 7);
							write('CONFIGURACIONES - Ingrese un valor valido: ');
							readln(valueConfig[2]);
							val(valueConfig[2], colorTextoBYTE);
						end;
			
						if colorTextoBYTE>0 then
						begin
						colorTextoSTR := colores[colorTextoBYTE];
						infoConfig[2] := colorTextoSTR;
						end;

					end;

				end;
			'3':	//saltear menu
				begin
	
					if infoConfig[3] = 'Activado' then 
					infoConfig[3] := 'Desactivado'
					else infoConfig[3] := 'Activado';
	
					//infoConfig[3] := BoolToStr(saltearMenu);
					
				end;
			'4':	//autoguardado
				begin
	
					if infoConfig[4] = 'Activado' then
					infoConfig[4] := 'Desactivado'
					else infoConfig[4] := 'Activado';
	
					//infoConfig[4] := BoolToStr(autoSave);

				end;
			'5':	//tipo escritura
				begin
	
					if infoConfig[5] = 'Activado' then
					infoConfig[5] := 'Desactivado'
					else infoConfig[5] := 'Activado';
					
					//infoConfig[5] := BoolToStr(completition_type);
	
				end;

			'6':	//musica
				begin

					if infoConfig[6] = 'Activada' then 
					begin
						infoConfig[6] := 'Desactivada';
						SendMCICommand(StopSong);
					end
					else 
					begin
						musicFinding(listaCanciones, index, Cmd, songName, StopSong);
						SendMCICommand(Cmd);
						infoConfig[6] := 'Activada';
					end;

					//infoConfig[6] := BoolToStr(musicON);

				end;	
	
			end;

		configClosingHandling(infoConfig);

		until op='7';

	end;


	begin

	//	configMenu();	

	end.