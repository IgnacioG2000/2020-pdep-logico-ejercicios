cantante(megurineLuka,cancion(nightFever,4)).
cantante(megurineLuka,cancion(foreverYoung,5)).
cantante(hatsuneMiku,cancion(tellYourWorld,4)).
cantante(gumi,cancion(foreverYoung,4)).
cantante(gumi,cancion(tellYourWorld,5)).
cantante(seeU,cancion(novemberRain,6)).
cantante(seeU,cancion(nightFever,5)).

% Kaito no sabe cantar ninguna canción: Por Principio de Universo Cerrado, no modelo esta condición.

% Punto 1

novedoso(Vocaloid):-
    cantante(Vocaloid,_),
    sabeCantCanciones(Vocaloid,2),
    tiempoCanciones(Vocaloid,Tiempo),
    Tiempo < 15.

sabeCantCanciones(Vocaloid,CantCanciones):-
    findall(Cancion,cantante(Vocaloid,cancion(Cancion,_)),ListaCanciones),
    length(ListaCanciones,CantCanciones).

tiempoCanciones(Vocaloid,TiempoTotal):-
    findall(Tiempo,cantante(Vocaloid,cancion(_,Tiempo)),ListaTiempos),
    sumlist(ListaTiempos,TiempoTotal).


% Punto 2

acelerado(Vocaloid):-
    cantante(Vocaloid,_),
    not(cancionDuraMasDe(Vocaloid,4)).

cancionDuraMasDe(Vocaloid,TiempoTotal):-
    cantante(Vocaloid,cancion(_,Tiempo)),
    Tiempo > TiempoTotal.


%Segunda Parte


% Punto 1

concierto(mikuExpo,estadosUnidos,2000,gigante(2,6)).
concierto(magicalMirai,japon,3000,gigante(3,10)).
concierto(vocalektVisions,estadosUnidos,1000,mediano(9)).
concierto(mikuFest,argentina,100,pequenio(4)).

% Punto2

puedeParticipar(Vocaloid,Concierto):-
    cantante(Vocaloid,_),
    concierto(Concierto,_,_,Requisito),
    cumpleRequisito(Vocaloid,Requisito).

puedeParticipar(hatsuneMiku,Concierto):-
    concierto(Concierto,_,_,_).

cumpleRequisito(Vocaloid,gigante(CantMinCanciones,TiempoMinCanciones)):-
    sabeAlMenos(Vocaloid,CantMinCanciones),
    superaElTiempoMinimo(Vocaloid,TiempoMinCanciones).

cumpleRequisito(Vocaloid,mediano(TiempoMaximo)):-
    tiempoCanciones(Vocaloid,TiempoTotal),
    TiempoTotal < TiempoMaximo.

cumpleRequisito(Vocaloid,pequenio(Tiempo)):-
    cancionDuraMasDe(Vocaloid,Tiempo).


sabeAlMenos(Vocaloid,CantCanciones):-
    sabeCantCanciones(Vocaloid,CancionesQueSabe),
    CancionesQueSabe > CantCanciones.

superaElTiempoMinimo(Vocaloid,TiempoMinimo):-
    tiempoCanciones(Vocaloid,TiempoTotal),
    TiempoTotal > TiempoMinimo.


% Punto 3

masFamoso(Vocaloid):-
    nivelDeFama(Vocaloid,FamaVocaloid),
    forall(nivelDeFama(_,FamaOtrosVocaloid),FamaVocaloid >= FamaOtrosVocaloid).


nivelDeFama(Vocaloid,NivelFama):-
    cantante(Vocaloid,_),
    famaTotal(Vocaloid,Fama),
    sabeCantCanciones(Vocaloid,CantCanciones),
    NivelFama is Fama * CantCanciones.

famaTotal(Vocaloid,Fama):-
    findall(FamaConcierto,famaConcierto(Vocaloid,FamaConcierto),ListaFamas),
    sumlist(ListaFamas,Fama).

famaConcierto(Vocaloid,FamaConcierto):-
    puedeParticipar(Vocaloid,Concierto),
    concierto(Concierto,_,FamaConcierto,_).



% Punto 4

conoceA(megurineLuka,hatsuneMiku).
conoceA(megurineLuka,gumi).
conoceA(gumi,seeU).
conoceA(seeU,kaito).


unicoDe(Vocaloid,Concierto):-
    puedeParticipar(Vocaloid,Concierto),
    not((conocido(Vocaloid,Conocido),puedeParticipar(Conocido,Concierto))).


conocido(X,Y):- 
    conoceA(X,Y),
    X \= Y.

conocido(X,Y):- 
    conoceA(Y,X),
    Y \= X.

conocido(Conocido1,Conocido2):-
    conoceA(Conocido1,ConocidoIntermedio),
    conocido(ConocidoIntermedio,Conocido2).





