unit lista;

{$IFDEF Windows} 
{$codepage UTF-8}
{$ENDIF}

{$mode objfpc}{$H+}

INTERFACE

Uses
    CRT, sysutils;

TYPE
    tDatoLista= ANSISTRING;

    tPuntero = ^tNodo;

    tNodo = RECORD
           INFO:tDatoLista;
           SIG:tPuntero;
    END;

    tLista = RECORD
                CAB,ACT: tPuntero;
                TAM: WORD;
    END;

PROCEDURE CREARLISTA (VAR L:tLista);
procedure agregarNoOrdenado(VAR L:tLista; X:tDatoLista);
//PROCEDURE AGREGAR (VAR L:tLista; X:tDatoLista);
//FUNCTION LISTA_LLENA (VAR L:tLista): BOOLEAN;
FUNCTION LISTA_VACIA (VAR L:tLista): BOOLEAN;
PROCEDURE ELIMINAR (VAR L:tLista;BUSCADO: tDatoLista; VAR X:tDatoLista);
procedure borrarPuntosLista(lista:tLista; var sublista:tLista);
FUNCTION TAMANIO(VAR L:tLista): WORD;
PROCEDURE SIGUIENTE(VAR L:tLista);
PROCEDURE PRIMERO (VAR L:tLista);
function FIN (VAR L:tLista): BOOLEAN;
PROCEDURE RECUPERAR (VAR L:tLista; VAR X:tDatoLista);
procedure devolverSublista(lista:tLista; paginaBuscada:byte; var sublista:tLista; velocidadTexto:boolean);
//PROCEDURE RECORRERLISTA ( L:tLista);
procedure mostrar(lista:tLista; pos:word; cantidadRespuestas:word);
procedure mostrarTodaLista(lista:tLista);   
PROCEDURE exportarListaArchivo (L:tLista; var arch:textfile);
Procedure eliminarLista (L:tLista);    
//PROCEDURE BUSCAR (var L:tLista; BUSCADO:tDatoLista ;VAR ENC:BOOLEAN);
//PROCEDURE CONSULTA (VAR L:tLista);
procedure logicaMostrarCinco(var i:word; cantidadRespuestas:word; var salteado:boolean);


IMPLEMENTATION

PROCEDURE CREARLISTA (VAR L:tLista);
          BEGIN
               L.TAM:=0;
               L.CAB:=NIL;
          END;


procedure agregarNoOrdenado(VAR L:tLista; X:tDatoLista);
VAR
    DIR,ANT: tPuntero;
begin

    NEW (DIR);
    DIR^.INFO:= X;

    IF (L.CAB= NIL) THEN
    begin

        DIR^.SIG:= L.CAB;
        L. CAB:=DIR;

    end
    else
    begin

        ANT:= L.CAB;
        L.ACT:= L.CAB^.SIG;

        WHILE (L.ACT <> NIL) do
        begin

            ANT:= L.ACT;
            L.ACT:= L.ACT^.SIG;

        end;

        DIR^.SIG:= L.ACT;
        ANT^.SIG:= DIR;

    end;


    INC(L.TAM);

end;

PROCEDURE AGREGAR (VAR L:tLista; X:tDatoLista);
          VAR
            DIR,ANT: tPuntero;
          BEGIN
               NEW (DIR);
               DIR^.INFO:= X;
               IF (L.CAB= NIL) OR (L.CAB^.INFO > X) THEN
                  BEGIN
                       DIR^.SIG:= L.CAB;
                       L. CAB:=DIR;
                  END
                     ELSE
                         BEGIN
                              ANT:= L.CAB;
                              L.ACT:= L.CAB^.SIG;
                              WHILE (L.ACT <> NIL) AND (L.ACT^.INFO < X) DO
                                    BEGIN
                                         ANT:= L.ACT;
                                         L.ACT:= L.ACT^.SIG;
                                    END;
                              DIR^.SIG:= L.ACT;
                              ANT^.SIG:= DIR;
                         END;
               INC(L.TAM);
          END;

PROCEDURE ELIMINAR (VAR L:tLista;BUSCADO: tDatoLista; VAR X:tDatoLista);
          VAR
            ANT: tPuntero;
          BEGIN
               
             //  primero(l);

               IF (L.CAB^.INFO= BUSCADO) THEN
                  BEGIN
                       X:= L.CAB^.INFO;
                       L.ACT:=L.CAB;
                       L.CAB:=L.CAB^.SIG;
                  END
                     ELSE
                         BEGIN
                              ANT:=L.CAB;
                              L.ACT:= L.CAB^.SIG;

                              WHILE (L.ACT <> NIL) AND (L.ACT^.INFO <> X) DO
                                    BEGIN
                                         ANT:=L.ACT;
                                         L.ACT:= L.ACT^.SIG;
                                    END;

                              X:= L.ACT^.INFO;
                              ANT^.SIG:=L.ACT^.SIG;
                         END;
                  
                  DISPOSE (L.ACT);
                  DEC(L.TAM)
          END;

FUNCTION TAMANIO(VAR L:tLista): word;
         BEGIN
              TAMANIO:=L.TAM;
         END;

FUNCTION LISTA_LLENA (VAR L:tLista): BOOLEAN;
         BEGIN
              LISTA_LLENA:= getheapstatus.totalfree< sizeof(tNodo) ;
         END;

FUNCTION LISTA_VACIA (VAR L:tLista): BOOLEAN;
         BEGIN
              LISTA_VACIA:= L.TAM=0;
         END;

PROCEDURE SIGUIENTE(VAR L:tLista);
          BEGIN
               L.ACT:= L.ACT^.SIG;
          END;

PROCEDURE PRIMERO (VAR L:tLista);
          BEGIN
               L.ACT:= L.CAB;
          END;

function FIN (VAR L:tLista): BOOLEAN;
         BEGIN
              FIN:= L.ACT = NIL;
         END;

PROCEDURE RECUPERAR (VAR L:tLista; VAR X:tDatoLista);
          BEGIN
               X:= L.ACT^.INFO;
          END;

procedure devolverSublista(lista:tLista; paginaBuscada:byte; var sublista:tLista; velocidadTexto:boolean);
var X:tDatoLista;
cantidadPaginas:byte;
begin

    crearLista(sublista);
    primero(sublista);
    clrscr;
    //mostrarTodaLista(lista);

    primero(lista);
    cantidadPaginas:=1;

    while (not fin(lista)) do
    begin

        recuperar(lista, X);
        if X = '.' then cantidadPaginas += 1;
        
        if (paginaBuscada = cantidadPaginas) and (X <> '.') then 
        begin
         paginaBuscada := cantidadPaginas;
         agregarNoOrdenado(sublista, X);
        end;

        siguiente(lista);

    end;

    primero(sublista);

end;

procedure logicaMostrarCinco(var i:word; cantidadRespuestas:word; var salteado:boolean);
var j:3..30;
begin

    if i mod 5 = 0 then 
        begin

            writeln;
            write('Presiona ENTER para mostrar mas. Presione cualquier otra tecla para salir.');
            
            if readkey = #13 then
            begin
            
                for j:=3 to 30 do
                begin
                    gotoxy(1, j);
                    clreol;
                end;

                gotoxy(1, 3);

            end
            else begin i:=cantidadRespuestas; salteado := true end;

        end;

        i+=1;

end;

procedure mostrar(lista:tLista; pos:word; cantidadRespuestas:word);
var X:tDatoLista;
i:word;
salteado:boolean;
begin

    primero(lista);
    salteado:=false;

    for i:=1 to pos do siguiente(lista);

    i:=1;

    while i <= cantidadRespuestas do
    begin

        recuperar(lista, X);
        gotoxy(1,whereY);
        writeln(i,') ', X);
        siguiente(lista);
        logicaMostrarCinco(i, cantidadRespuestas, salteado)

    end;

    if not salteado then readkey;

end;

procedure mostrarTodaLista(lista:tLista);
var X:tDatoLista;
i:word;
begin

    primero(lista);

    i:=1;

    while not fin(lista) do
    begin

        recuperar(lista, X);
        writeln(i-1,') ', X);
        siguiente(lista);
        i+=1;

    end;

end;

PROCEDURE RECORRERLISTA (L:tLista);
          VAR
            E:tDatoLista;
          BEGIN
               PRIMERO (L);
               WHILE (NOT FIN (L)) DO
                     BEGIN
                          RECUPERAR (L,E);
                          WRITELN (E);
                          SIGUIENTE (L);
                     END;
          END;

PROCEDURE exportarListaArchivo (L:tLista; var arch:textfile);
          VAR
            E:tDatoLista;
          BEGIN

               REWRITE(arch);
               PRIMERO (L);
               WHILE (NOT FIN (L)) DO
                     BEGIN

                          RECUPERAR (L,E);
                          WRITELN(arch, E);
                          SIGUIENTE (L);
                     END;

                CLOSE(arch);
          END;

procedure borrarPuntosLista(lista:tLista; var sublista:tLista);
var X:tDatoLista;
begin

    crearLista(sublista);
    primero(sublista);

    primero(lista);

    while not fin(lista) do
    begin

        recuperar(lista,X);
        if (X<>'.') then agregarNoOrdenado(sublista, X);
        siguiente(lista);

    end;

    primero(sublista);

end;

Procedure eliminarLista (L:tLista);
          VAR
            E:tDatoLista;
          BEGIN
               PRIMERO (L);
               WHILE (NOT FIN (L)) DO
                     BEGIN
                          RECUPERAR (L,E);
                          ELIMINAR (L, E, E);
                          SIGUIENTE (L);
                     END;
          END;


PROCEDURE BUSCAR (var L:tLista; BUSCADO:tDatoLista ;VAR ENC:BOOLEAN);
          VAR
             X:tDatoLista;
          BEGIN
               PRIMERO(L);
               ENC:= FALSE;
               WHILE NOT FIN(L) AND (NOT ENC) DO
                     BEGIN
                          RECUPERAR(L,X);
                          IF X = BUSCADO THEN ENC:=TRUE
                                      ELSE SIGUIENTE (L);
                     END;
          END;

PROCEDURE CONSULTA (VAR L:tLista);
          VAR
             BUSCADO:tDatoLista;
             ENC:BOOLEAN;
             X:tDatoLista;
          BEGIN
               WRITE('INGRESE BUSCADO: ');
               READLN (BUSCADO);
               BUSCAR(L,BUSCADO,ENC);
               IF ENC=TRUE THEN
                  BEGIN
                       RECUPERAR(L,X);
                       WRITE(X)
                  end
                      ELSE
                          WRITE ('NO SE ENCONTRÓ EL ELEMENTO');
          end;
END.