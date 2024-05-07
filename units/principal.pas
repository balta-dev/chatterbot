unit principal;

interface

uses crt, procesamiento, strings, sysutils, configuraciones, administrador, box, music;

procedure execution(var doneProgram:boolean; var completition_type:boolean; var colorTextoBYTE:byte; var username:string; var save:boolean; var v:t_vector2; var m:byte);
procedure menu(var username:string; var configuration:textfile; var infoConfig:vectorConf; var colorTextoSTR:string; var colorTextoBYTE:byte; var saltearMenu:boolean; var autoSave:boolean; var completition_type:boolean; var save:boolean; var v:t_vector2; var m:byte; var musicON:boolean; songName:string; Cmd:pchar; StopSong:pchar; listaCanciones:vectorEspecial2);
procedure start(var colorTextoBYTE:byte; var completition_type:boolean; songName:string; musicON:boolean; var Cmd:pchar; var StopSong:pchar);

implementation

procedure execution(var doneProgram:boolean; var completition_type:boolean; var colorTextoBYTE:byte; var username:string; var save:boolean; var v:t_vector2; var m:byte);
var aux:longString;
counter:byte;
int30:integer;
word:ansistring;
result:string;
reg:t_reg;
datos:textfile;
const ESC_Key = #27;

	begin

		int30:=30;
		counter:=0;
		m:=0;

		clrscr;
		writeln('Presiona una tecla para continuar.');

			assign (datos, 'datos.txt');
			{$I-}
			reset (datos); 
			{$I+}

			if IOResult <> 0 then
			begin

				clrscr;
				gotoxy(25, 12); 
				writeln('Archivo "datos.txt" faltante...'); 
				gotoxy(25, 13); 
				writeln('Comprueba de que el archivo exista en el mismo directorio que el ejecutable.'); 
				gotoxy(25, 15); 
				write('Presiona ESC para cerrar este prompt.');

			end;


 	   while not (ReadKey() = ESC_Key)  do
  	  	begin

//  	  		SendMCICommand('play "music.mp3"');

  	  		assign (datos, 'datos.txt');
			{$I-}
			reset (datos); 
			{$I+}

			if IOResult = 0 then
			begin

			if not doneProgram then

				begin
	
					//if counter>=4 then
					//begin
					//	clrscr;		//se necesita borrar pantalla, sino gotoxy se buguea
					//	counter := 0;
					//end;
	
 	       			writeln();
 	       			writeln();
  	      			wLine(word, result, reg, v, completition_type, username, m, colorTextoBYTE, save, doneProgram); //ACÁ SE PRODUCE LA ESCRITURA DE TODO
  	      			writeln();
  	      			result := '';
	
        			//counter := counter + 1;

        	end
        	else begin
        			clrscr;
        			writeln;
        			gotoxy(15, whereY);
        			aux:= 'El programa ha finalizado! Presiona ESC para Cerrar!';
        			animation(aux, int30, completition_type);
        	end;
			

			end
			else
			begin

				clrscr;
				gotoxy(25, 12); 
				writeln('Archivo "datos.txt" faltante...'); 
				gotoxy(25, 13); 
				writeln('Comprueba de que el archivo exista en el mismo directorio que el ejecutable.'); 
				gotoxy(25, 15); 
				write('Presiona ESC para cerrar este prompt.');


			end;


 	   	end;	
	
	end;



procedure menu(var username:string; var configuration:textfile; var infoConfig:vectorConf; var colorTextoSTR:string; var colorTextoBYTE:byte; var saltearMenu:boolean; var autoSave:boolean; var completition_type:boolean; var save:boolean; var v:t_vector2; var m:byte; var musicON:boolean; songName:string; Cmd:pchar; StopSong:pchar; listaCanciones:vectorEspecial2);
var op:string;
doneProgram:boolean;
codigo:integer;
symbol:char;

	begin


	//StrCopy(StopSong, Pchar('stop '));
	//StrCat(StopSong, Pchar(Cmd));

	//writeln(StopSong);
	//readln;

	//StopSong := 'stop ".\music\01.mp3"';
	//SendMCICommand(StopSong);

//	SendMCICommand(StopSong);

		repeat

			//doneProgram := false;
			clrscr;
			symbol:='*';
			boxDO(15, 80, 9, 20, symbol, true);
			doneProgram := false;
			gotoxy(18,7);
			writeln('Bienvenid@, ', username, '!');
			gotoxy(25, 10);
			textcolor(colorTextoBYTE);
			writeln('---- FOOTBALL CHATTERBOT ----');
			textcolor(white);
			gotoxy(57, 10);
			writeln('Opcion: ');
			gotoxy(25, 12);
			writeln('1) Iniciar');
			gotoxy(25, 14);
			writeln('2) Configuraciones');
			gotoxy(25, 16);
			writeln('3) Administrador');
			gotoxy(25,18);
			writeln('4) Salir');
			gotoxy(3, 29);
			if (songName <> '') and (musicOn) then writeln('Cancion: ' + songName);
			gotoxy(65, 10);
			readln(op);

			

			//val(op, valor, codigo);

			case op of
			'1':execution(doneProgram, completition_type, colorTextoBYTE, username, save, v, m);
			'2':configMenu(colorTextoBYTE, colorTextoSTR, username, saltearMenu, autoSave, completition_type, infoConfig, save, musicON, Cmd, StopSong, songName, listaCanciones);
			'3':crearDatos;
			end;

		until op='4';

	end;


procedure start(var colorTextoBYTE:byte; var completition_type:boolean; songName:string; musicON:boolean; var Cmd:pchar; var StopSong:pchar);
var aux:longString;
int30:integer;
symbol:char;
auxPOS:integer;


	begin

		symbol:='*';
		int30:=30;
		aux := 'PRESIONA UNA TECLA PARA CONTINUAR...';
		delay(1000);
		writeln;
		writeln;
		textcolor(colorTextoBYTE);
		write(' .@@@@@@@@@       .*%@@@%*              */@@@@/,      (@@@@@@@@@/ %@@@@@#*           .@@@*        ,@@@       ,@@@       ');
		delay(10);
		write(' .@@@((((((    /&@@%#(((#&@@&*      ,#@@@#((((#@@@#.  ,((#@@@(((, %@@%((%@@&.       .@@@@@,       ,@@@       ,@@@       ');
		delay(10);
		write(' .@@@        ,@@@*         (@@@.   %@@%         .@@@(    ,@@@.    %@@/   @@@,       @@@(@@@,      ,@@@       ,@@@       ');
		delay(10);
		write(' .@@@@@@@@@  @@@,           *@@&  /@@%            @@@,   ,@@@.    %@@@@@@@@,      .@@@* .@@@,     ,@@@       ,@@@       ');
		delay(10);
		write(' .@@@       .@@@.           *@@@  (@@(            &@@*   ,@@@.    %@@/  ,%@@@     @@@*   .@@@,    ,@@@       ,@@@       ');
		delay(10);
		write(' .@@@        /@@%.         ,@@@*   &@@/          (@@%    ,@@@.    %@@/    (@@(   &@@@@@@@@@@@@.   ,@@@       ,@@@       ');
		delay(10);
		write(' .@@@          &@@@(,   ,#@@@%      *@@@@*    *@@@@*     ,@@@.    %@@/  .(@@@,  &@@/       ,@@@.  ,@@@       ,@@@       ');
		delay(10);
		write(' .@@@            ,(#@@@@&#(,          .(#%@@@@%#/.       ,@@@.    %@@@@@@&#*   %@@(         *@@@. ,@@@@@@@@, ,@@@@@@@@, ');
		writeln;
		writeln;
		textcolor(white);
		delay(1000);
		writeln('     ,ad8888ba,   88                                                                88                                ');
		delay(10);
		writeln('     d8"    `"8b  88                         ,d       ,d                            88                         ,d     ');
		delay(10);
		writeln('   d8"            88                         88       88                            88                         88     ');
		delay(10);
		writeln('   88             88,dPPYba,   ,adPPYYba,  MM88MMM  MM88MMM  ,adPPYba,  8b,dPPYba,  88,dPPYba,    ,adPPYba,  MM88MMM  ');
		delay(10);
		writeln('   88             88P"    "8a  ""     `Y8    88       88    a8P_____88  88P"   "Y8  88P"    "8a  a8"     "8a   88     ');
		delay(10);
		writeln('   Y8,            88       88  ,adPPPPP88    88       88    8PP"""""""  88          88       d8  8b       d8   88     ');
		delay(10);
		writeln('    Y8a.    .a8P  88       88  88,    ,88    88,      88,   "8b,   ,aa  88          88b,   ,a8"  "8a,   ,a8"   88,    ');
		delay(10);
		writeln('     `"Y8888Y""   88       88  `"8bbdP"Y8    "Y888    "Y888  `"Ybbd8""  88          8Y"Ybbd8""    `"YbbdP"`    "Y888  ');
		writeln;
		writeln;
		delay(1000);
		//writeln('                                          PRESIONA UNA TECLA PARA CONTINUAR...');
		writeln;
		textcolor(colorTextoBYTE);
		gotoxy(whereX+40, whereY);
		animation(aux, int30, completition_type);
		textcolor(white);

		writeln;
		writeln;
		auxPOS:=whereX+90;

		boxDO(35, 80, 23, 26, symbol, false);

		//textcolor(colorTextoBYTE);
		aux:='Chatterbot v1.4';
		gotoxy(auxPOS, whereY);
		animation(aux, int30, completition_type);
		delay(500);

		writeln; writeln;
		gotoxy(whereX+2, whereY);
		
		if (songName <> '') and (musicOn) then
		begin 
		aux := 'Cancion: ' + songName;
		animation(aux, int30, completition_type); 
		end;

		readkey;

	end;

begin
end.