program chatterbot;	

uses crt, SysUtils, Keyboard, MMSystem, StrUtils,

configuraciones in 'units/configuraciones.pas',
procesamiento in 'units/procesamiento.pas',
historial in 'units/historial.pas',
principal in 'units/principal.pas',
administrador in 'units/administrador.pas',
borrarEspacios in 'units/borrarEspacios',
box in 'units/box',
music in 'units/music',
dia in 'units/dia';
type vectorEspecial2 = array [1..maxSongs] of string;

procedure textWrite();
var texto:ansiString;
int30:integer;
completition_type:boolean;
begin

	int30:=30;
	boxDO(1, 115, 6, 25, '*', false);
	texto := 'Lionel Andres Messi es indiscutiblemente uno de los mejores jugadores de la historia, con 42 titulos oficiales a lo largo de su carrera; 35 con el FC Barcelona, 2 con el PSG, 3 con la seleccion Argentina, 1 con la seleccion Argentina sub-20 y otro con la sub-23. En lo que titulos individuales respecta, Messi posee 9 MVP de la Liga, 8 Pichichis de la Liga, 7 Balones de Oro, 6 Botas de Oro, 6 Maximo goleador de la Champions, 4 Onze d"Or, 2 Mejor Jugador de Europa, 1 MVP Mundial 2022, 1 Premio The Best, 1 FIFA World Player, 1 Balon de Oro Mundial 2014, 1 MVP Copa America 2021, 1 FIFA FIFPro, 1 Premio Laureus, 1 Golden Boy y 1 Trofeo Bravo.';
	completition_type := true;
	gotoxy(18, 10);
	animation(texto, int30, completition_type);
	readkey;

end;

procedure mainProgram();
var configuration:textfile;
infoConfig:vectorConf;
colorTextoBYTE:byte;
colorTextoSTR:string;
saltearMenu:boolean;
autoSave:boolean;
completition_type:boolean;
username:string;
save:boolean;
auxDate:string;
auxTime:string;
v:t_vector2;
m:byte;
musicON:boolean;
listaCanciones:vectorEspecial2;
index:byte;
Cmd:pchar;
StopSong:pchar;
songName:string;


	begin

		//musicFinding(listaCanciones, index, Cmd, songName);

		saltearMenu:=false;////
		autoSave:=false;
		save:=false;
		completition_type:=true;
		musicON:=true;
		colorTextoBYTE := 14;						//DEFAULT PRESET
		colorTextoSTR:='Amarillo';
		username:=GetUserDir;
		delete(username, 1, 9);
		delete(username, length(username), length(username));

		If Not DirectoryExists('chatLog') then CreateDir('chatLog');

		If Not DirectoryExists('music') then CreateDir('music');

		configOpeningHandling(username, configuration, infoConfig, colorTextoSTR, colorTextoBYTE, saltearMenu, autoSave, completition_type, musicON);
		logOpeningHandling(auxDate, auxTime);
		configClosingHandling(autoSave, configuration, infoConfig, save, musicON);

		//if musicON then SendMCICommand(Cmd);
		//clrscr;

		musicFinding(listaCanciones, index, Cmd, songName, StopSong);
		if musicON then SendMCICommand(Cmd);

		if not saltearMenu then start(colorTextoBYTE, completition_type, songName, musicON, Cmd, StopSong);

		menu(username, configuration, infoConfig, colorTextoSTR, colorTextoBYTE, saltearMenu, autoSave, completition_type, save, v, m, musicON, songName, Cmd, StopSong, listaCanciones);	

		configClosingHandling(autoSave, configuration, infoConfig, save, musicON);
		logClosingHandling(v, auxDate, auxTime, autoSave, m, save);

		//SendMCICommand('close overlay');
		
	end;


begin  	//PROGRAMA PRINCIPAL

	mainProgram;
	//textWrite;

end.
