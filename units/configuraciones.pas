unit configuraciones;

interface
uses crt, SysUtils, music, box;
type vectorConf = array [1..6] of string;
	vectorColores = array [1..16] of string;
	vectorEspecial = array[1..10] of string;

procedure configMenu(var colorTextoBYTE:byte; var colorTextoSTR:string; var username:string; var saltearMenu:boolean; var autoSave:boolean; var completition_type:boolean; var infoConfig:vectorConf; var save:boolean; var musicON:boolean; var cmd:pchar; var stopsong:pchar; var songName:string; listaCanciones:vectorEspecial2);
procedure configClosingHandling(var autoSave:boolean; var configuration:textfile; var infoConfig:vectorConf; var save:boolean; var musicON:boolean);
procedure configGathering(var infoConfig:vectorConf; var username:string; var colorTextoSTR:string; var colorTextoBYTE:byte; var saltearMenu:boolean; var autoSave:boolean; var completition_type:boolean; var musicON:boolean);
procedure configDefault(var missing:boolean; var configuration:textfile; var username:string; var colorTextoSTR:string; var colorTextoBYTE:byte; var saltearMenu:boolean; var autoSave:boolean; var completition_type:boolean; var musicON:boolean);
procedure configOpeningHandling(var username:string; var configuration:textfile; var infoConfig:vectorConf; var colorTextoSTR:string; var colorTextoBYTE:byte; var saltearMenu:boolean; var autoSave:boolean; var completition_type:boolean; var musicON:boolean);


implementation

procedure configMenu(var colorTextoBYTE:byte; var colorTextoSTR:string; var username:string; var saltearMenu:boolean; var autoSave:boolean; var completition_type:boolean; var infoConfig:vectorConf; var save:boolean; var musicON:boolean; var cmd:pchar; var stopsong:pchar; var songName:string; listaCanciones:vectorEspecial2);	
var op:string;
iterator:byte;
colores:vectorColores;
symbol:char;
configuration:textfile;
index:byte;
//musicON:boolean;							

	begin

		repeat

			clrscr;
			//if musicON then SendMCICommand('play ".\music\5.mp3" wait');
			configOpeningHandling(username, configuration, infoConfig, colorTextoSTR, colorTextoBYTE, saltearMenu, autoSave, completition_type, musicON);

			symbol:='*'; 
			boxDO(20, 70, 7, 25, symbol, true);
			gotoxy(25, 10);
			write('1) Nombre de Usuario: '); textcolor(colorTextoBYTE); writeln(username); textcolor(white);		
			gotoxy(25, 12);
			write('2) Color de texto del BOT: '); textcolor(colorTextoBYTE); writeln(colorTextoSTR); textcolor(white);     
			gotoxy(25, 14);
			write('3) Ignorar menu: '); textcolor(colorTextoBYTE); writeln(saltearMenu); textcolor(white);		
			gotoxy(25, 16);
			write('4) Guardar chat automaticamente: '); textcolor(colorTextoBYTE); writeln(autoSave); textcolor(white);
			gotoxy(25, 18);
			write('5) Completado de texto progresivo: '); textcolor(colorTextoBYTE); writeln(completition_type); textcolor(white);
			gotoxy(25, 20);
			write('6) Musica: '); textcolor(colorTextoBYTE); writeln(musicON); textcolor(white);
			gotoxy(25, 22);
			write('7) Volver Atras');
			gotoxy(50, 22);
			write('Opcion: ');

			readln(op);

			case op of
			'1':
				begin
					clrscr; 
					gotoxy(25, 10);
					write('Nombre de Usuario: '); textcolor(colorTextoBYTE); readln(username); textcolor(white);
					infoConfig[1] := username;
				end;
			'2':
				begin
	
					clrscr; 
					gotoxy(25, 10);
					writeln('Seleccione un color: ');
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


					for iterator:=1 to 15 do
					begin
					gotoxy(25, whereY);
					writeln(iterator, ') ', colores[iterator]);
					end;

					gotoxy(46, 10);
					readln(colorTextoBYTE);
	
					while (colorTextoBYTE<1) or (colorTextoBYTE>15) do
					begin
						clrscr;
						gotoxy(45, 10);
						write('Ingrese un valor valido: ');
						readln(colorTextoBYTE);
					end;
	
					colorTextoSTR := colores[colorTextoBYTE];
					infoConfig[2] := colorTextoSTR;
	
				end;
			'3':
				begin
	
					if not saltearMenu then 
					saltearMenu := true
					else saltearMenu := false;
	
					infoConfig[3] := BoolToStr(saltearMenu);
					
				end;
			'4':
				begin
	
					if not autoSave then
					begin
					autoSave := true;
					save := true;
					end
					else 
					autoSave := false;
	
					infoConfig[4] := BoolToStr(autoSave);

				end;
			'5':
				begin
	
					if completition_type then
					completition_type := false
					else completition_type := true;
					
					infoConfig[5] := BoolToStr(completition_type);
	
				end;

			'6':
				begin

					if musicOn = true then 
					begin
						musicON := false;
						SendMCICommand(StopSong);
					end
					else 
					begin
						musicFinding(listaCanciones, index, Cmd, songName, StopSong);
						SendMCICommand(Cmd);
						musicON:=true;
					end;

					infoConfig[6] := BoolToStr(musicON);

				end;	
	
			end;

		configClosingHandling(autoSave, configuration, infoConfig, save, musicON);

		until op='7';

		//configOpeningHandling(username, configuration, infoConfig, colorTextoSTR, colorTextoBYTE, saltearMenu, autoSave, completition_type, musicON);
		//configOpeningHandling(username, configuration, infoConfig, colorTextoSTR, colorTextoBYTE, saltearMenu, autoSave, completition_type, musicON);

	end;
procedure configClosingHandling(var autoSave:boolean; var configuration:textfile; var infoConfig:vectorConf; var save:boolean; var musicON:boolean);

	begin

		if autoSave then
		save:=true;

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
procedure configGathering(var infoConfig:vectorConf; var username:string; var colorTextoSTR:string; var colorTextoBYTE:byte; var saltearMenu:boolean; var autoSave:boolean; var completition_type:boolean; var musicON:boolean);

	begin

	/////// RECORTE DE DATOS

		delete (infoConfig[1], 1, 8);		//TRAIDO DEL ARCHIVO
		delete (infoConfig[2], 1, 17);
		delete (infoConfig[3], 1, 11);
		delete (infoConfig[4], 1, 14);
		delete (infoConfig[5], 1, 17);
		delete (infoConfig[6], 1, 8);

	///////

		clrscr;

	////// ASIGNACION DE DATOS AL PROGRAMA

		if (infoConfig[1]<>'') and (infoConfig[2]<>'') then
		begin
		username := infoConfig[1];
		colorTextoSTR := infoConfig[2];
		end;

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

		case infoConfig[3] of
		'0': saltearMenu := false;
		'-1': saltearMenu := true;
		end;

		case infoConfig[4] of
		'0': autoSave := false;
		'-1': autoSave := true;
		end;

		case infoConfig[5] of
		'0': completition_type := false;
		'-1': completition_type := true;
		end;

		case infoConfig[6] of
		'0': musicON := false;
		'-1': musicON := true; 
		end;

	///////
		
	end;


procedure configDefault(var missing:boolean; var configuration:textfile; var username:string; var colorTextoSTR:string; var colorTextoBYTE:byte; var saltearMenu:boolean; var autoSave:boolean; var completition_type:boolean; var musicON:boolean);

	begin

		//las configuraciones predeterminadas DEBEN EXISTIR
		
		rewrite(configuration);
		writeln(configuration, 'Nombre: '+ username);
		writeln(configuration, 'Color_texto_BOT: ' + colorTextoSTR);
		writeln(configuration, 'Skip_menu: ' + BoolToStr(saltearMenu));
		writeln(configuration, 'Guardar_chat: ' + BoolToStr(autoSave));
		writeln(configuration, 'Type_text_compl: ' + BoolToStr(completition_type));
		writeln(configuration, 'Musica: ' + BoolToStr(musicON));
		close(configuration);

	end;


procedure configOpeningHandling(var username:string; var configuration:textfile; var infoConfig:vectorConf; var colorTextoSTR:string; var colorTextoBYTE:byte; var saltearMenu:boolean; var autoSave:boolean; var completition_type:boolean; var musicON:boolean);
var iterator:1..6;
missing:boolean;
data:string;

	begin

		missing:=false;

		assign (configuration, 'config.txt');
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

		end


	else missing:=true;


	if missing then configDefault(missing, configuration, username, colorTextoSTR, colorTextoBYTE, saltearMenu, autoSave, completition_type, musicON);

	reset(configuration);
	for iterator:=1 to 6 do
		begin
			readln(configuration, data);
			infoConfig[iterator] := data;
			//writeln(infoConfig[iterator]);
		end;
	close(configuration);

	configGathering(infoConfig, username, colorTextoSTR, colorTextoBYTE, saltearMenu, autoSave, completition_type, musicON);	

	end;

	begin
	end.