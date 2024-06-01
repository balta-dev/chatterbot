unit menuPrincipal;

interface

uses configuraciones, crt, visuales, music;

procedure pantallaPrincipal(songName:string);

implementation

procedure pantallaPrincipal(songName:string);
var infoConfig:tVector;
colorTexto, pos:byte;
guardarChat, autoGuardadoActivado, velocidadTexto, musicaActiva:boolean;
texto:string;
begin

		leerConfiguracionesGuardadas(infoConfig, colorTexto, guardarChat, autoGuardadoActivado, velocidadTexto, musicaActiva);
		gotoxy(1,1);
		clrEol;

		texto := 'PRESIONA UNA TECLA PARA CONTINUAR...';
		delay(500);
		writeln;
		writeln;
		textcolor(colorTexto);
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
		textcolor(colorTexto);
		box(35, 80, 24, 26, '*');
		
		gotoxy(whereX+40, whereY-2);
		animation(texto, 0, velocidadTexto);
		textcolor(white);

		writeln;
		writeln;
		pos:=whereX+90;

		//textcolor(colorTextoBYTE);
		texto:='Chatterbot v1.5';
		gotoxy(pos, whereY);
		animation(texto, 30, velocidadTexto);
		delay(500);

		writeln; writeln;
		gotoxy(whereX+2, whereY);
		
		if (songName <> '') and (musicaActiva) then
		begin 
		texto := 'Sonando: ' + songName;
		animation(texto, 30, velocidadTexto); 
		end;

		readkey;
		mostrarSeleccion(37, 25, colorTexto);

end;

begin

end.