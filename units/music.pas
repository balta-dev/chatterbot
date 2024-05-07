unit music;

interface


uses MMSystem, SysUtils, crt, StrUtils;

const MaxSongs=22;
type vectorEspecial2 = array [1..MaxSongs] of string;

procedure SendMCICommand(Cmd: PChar);
procedure musicFinding(var FN:vectorEspecial2; var maxSongsFound:byte; var Cmd:pchar; var songName:string; var selected:pchar);

implementation

procedure SendMCICommand(Cmd: PChar);
begin  
	mciSendString(Cmd, nil, 0, 0); 
end;

function musicRandomizer(var maxSongsFound:byte):byte;
begin

	randomize;
	musicRandomizer:= random(maxSongsFound-1)+1;

end;

procedure songSet(var FN:vectorEspecial2; var maxSongsFound:byte; var Cmd:Pchar; var songName:string; var selected:Pchar);
var aux:pchar;
begin

	//writeln('SONG SELECTED: '+FN[maxSongsFound]);


	delete(FN[maxSongsFound], 3, 5);
	//writeln(FN[maxSongsFound]);
	//readln;

	case FN[maxSongsFound] of
	//'0': Cmd := '';
	'01': begin Cmd := '".\music\01.mp3"';  songName := 'On Melancholy Hill - Gorillaz'; end;							
	'02': begin Cmd := '".\music\02.mp3"';	songName := 'Take on Me - a-ha'; end;	
	'03': begin Cmd := '".\music\03.mp3"';	songName := 'Hotline Bling - Drake'; end;	
	'04': begin Cmd := '".\music\04.mp3"';  songName := 'Lean On - Major Lazer & DJ Snake'; end;    		
	'05': begin Cmd := '".\music\05.mp3"';	songName := 'Never Gonna Give You Up - Rick Astley'; end;		
	'06': begin Cmd := '".\music\06.mp3"';	songName := 'Eye of a Tiger - Survivor'; end;				
	'07': begin Cmd := '".\music\07.mp3"';	songName := 'All Star - Smash Mouth (Shrek)'; end;				
	'08': begin Cmd := '".\music\08.mp3"';	songName := 'Uptown Funk - Mark Ronson ft. Bruno Mars'; end;	 
	'09': begin Cmd := '".\music\09.mp3"';	songName := 'Ghostbusters - Ray Parker, Jr'; end;			
	'10': begin Cmd := '".\music\10.mp3"';  songName := 'Cake by the Ocean - DNCE'; end;
	'11': begin Cmd := '".\music\11.mp3"';  songName := 'Radioactive - Imagine Dragons'; end;			
	'12': begin Cmd := '".\music\12.mp3"';  songName := 'Centuries - Fall Out Boy'; end;			
	'13': begin Cmd := '".\music\13.mp3"';  songName := 'Immortals - Fall Out Boy'; end; 			
	'14': begin Cmd := '".\music\14.mp3"';  songName := 'Get Lucky - Daft Punk'; end;				
	'15': begin Cmd := '".\music\15.mp3"';  songName := 'Thriller - Michael Jackson'; end;			
	'16': begin Cmd := '".\music\16.mp3"';  songName := 'Welcome to the Jungle - Guns N Roses'; end;
	'17': begin Cmd := '".\music\17.mp3"';  songName := 'Bohemian Rhapsody - Queen'; end;					
	'18': begin Cmd := '".\music\18.mp3"';  songName := 'Watch Me Whip Nae Nae - Silento'; end;				
	'19': begin Cmd := '".\music\19.mp3"';  songName := 'Turn Down For What - DJ Snake & Lil Jon'; end;		
	'20': begin Cmd := '".\music\20.mp3"';  songName := 'Talk Dirty To Me - Jason Derulo & 2 Chainz'; end;	
	'21': begin Cmd := '".\music\21.mp3"';  songName := 'Blue Da Ba Dee - Eiffel 65'; end;					
	'22': begin Cmd := '".\music\22.mp3"';  songName := 'Animals - Maroon 5'; end;							
	end;

	aux := StrAlloc (StrLen('play ')*2+1);
	StrMove(aux, 'play ', StrLen(Cmd)+1);
	StrCat(aux, Cmd);

	selected := StrAlloc (StrLen('stop ')*2+1);
	StrMove(selected, 'stop ', StrLen(Cmd)+1);
	StrCat(selected, Cmd);

	Cmd := aux;

end;

procedure musicFinding(var FN:vectorEspecial2; var maxSongsFound:byte; var Cmd:pchar; var songName:string; var selected:pchar);
var P:string;
i:byte;
//songName:string;
begin
	
	P := '.\music';
	maxSongsFound:=0;
	i:=1;

	while i<=MaxSongs do
	begin
		
		if (FileSearch(IntToStr(i)+'.mp3',P) <> '') then 
		begin 
			INC(maxSongsFound);
			FN[maxSongsFound] := IntToStr(i)+'.mp3';

		end;

		if (FileSearch('0'+IntToStr(i)+'.mp3',P) <> '') then 
		begin 
			INC(maxSongsFound);
			FN[maxSongsFound] := '0'+IntToStr(i)+'.mp3';
		end;

		INC(i);

	end;

	clrscr;

	if maxSongsFound <> 0 then 
	begin
		
		maxSongsFound := musicRandomizer(maxSongsFound);
		while (maxSongsFound = 0) or (maxSongsFound>MaxSongs) do maxSongsFound := musicRandomizer(maxSongsFound); writeln(maxSongsFound);

		songSet(FN, maxSongsFound, Cmd, songName, selected); 

	end else Cmd := '';//bug handling por si no tenés canciones para evitar que crashee

	clrscr;

end;

begin
end.