/*
De cada vocaloid (o cantante) se conoce el nombre y además la canción que sabe cantar. De cada canción se conoce el nombre y la cantidad de minutos de duración.

Queremos reflejar entonces que:
 - megurineLuka sabe cantar la canción nightFever cuya duración es de 4 min y
 también canta la canción foreverYoung que dura 5 minutos.	
 - hatsuneMiku sabe cantar la canción tellYourWorld que dura 4 minutos.
 - gumi sabe cantar foreverYoung que dura 4 min y tellYourWorld que dura 5 min
 - seeU sabe cantar novemberRain con una duración de 6 min y nightFever con una duración de 5 min.


 - kaito no sabe cantar ninguna canción: Por Principio de Universo Cerrado, no modelaremos esta condición.
*/

%cantante(Nombre,cancion(Titulo,Duracion)).
cantante(megurineLuka,cancion(nightFever,4)).
cantante(megurineLuka,cancion(foreverYoung,5)).
cantante(hatsuneMiku,cancion(tellYourWorld,4)).
cantante(gumi,cancion(foreverYoung,4)).
cantante(gumi,cancion(tellYourWorld,5)).
cantante(seeU,cancion(novemberRain,6)).
cantante(seeU,cancion(nightFever,5)).


/* 1)
Para comenzar el concierto, es preferible introducir primero a los cantantes más novedosos, 
por lo que necesitamos un predicado para saber si un vocaloid es novedoso cuando saben al menos 2 canciones 
y el tiempo total que duran todas las canciones debería ser menor a 15.
*/

novedoso(Vocaloid):-
    cantante(Vocaloid,_),
    sabeCantidadCanciones(Vocaloid,2),
    tiempoTotalCanciones(Vocaloid,TiempoTotal),
    TiempoTotal < 15.


sabeCantidadCanciones(Vocaloid,CantCanciones):-
    findall(Cancion,cantante(Vocaloid,Cancion),Canciones),
    length(Canciones,CantCanciones).

tiempoTotalCanciones(Vocaloid,TiempoTotal):-
    findall(Tiempo,cantante(Vocaloid,cancion(_,Tiempo)),Tiempos),
    sumlist(Tiempos,TiempoTotal).


/* 2)
Hay algunos vocaloids que simplemente no quieren cantar canciones largas porque no les gusta, 
es por eso que se pide saber si un cantante es acelerado, condición que se da cuando todas sus canciones 
duran 4 minutos o menos. Resolver sin usar forall/2.
*/

acelerado(Vocaloid):-
    cantante(Vocaloid,_),
    not(tieneCancionMayorA(Vocaloid,4)).


tieneCancionMayorA(Vocaloid,Tiempo):-
    cantante(Vocaloid,cancion(_,Duracion)),
    Duracion > Tiempo.

/*

Además de los vocaloids, conocemos información acerca de varios conciertos que se darán en un futuro
no muy lejano. De cada concierto se sabe su nombre, el país donde se realizará, una cantidad de fama 
y el tipo de concierto.

Hay tres tipos de conciertos:

- gigante del cual se sabe la cantidad mínima de canciones que el cantante tiene que saber y además 
la duración total de todas las canciones tiene que ser mayor a una cantidad dada.
- mediano sólo pide que la duración total de las canciones del cantante sea menor a una cantidad determinada.
- pequeño el único requisito es que alguna de las canciones dure más de una cantidad dada.

Queremos reflejar los siguientes conciertos:

- Miku Expo, es un concierto gigante que se va a realizar en Estados Unidos, 
 le brinda 2000 de fama al vocaloid que pueda participar en él y pide que el vocaloid sepa más de 2 canciones
 y el tiempo mínimo de 6 minutos.	
 - Magical Mirai, se realizará en Japón y también es gigante, pero da una fama de 3000 y pide saber más
 de 3 canciones por cantante con un tiempo total mínimo de 10 minutos. 
 - Vocalekt Visions, se realizará en Estados Unidos y es mediano brinda 1000 de fama y 
 exige un tiempo máximo total de 9 minutos.	
 - Miku Fest, se hará en Argentina y es un concierto pequeño que solo da 100 de fama al vocaloid 
 que participe en él, con la condición de que sepa una o más canciones de más de 4 minutos.

*/

%concierto(Nombre,Pais,Fama,gigante(CantMinCancionesDebeSaber,tiempoMinimo)).
%concierto(Nombre,Pais,Fama,mediano(DuracionTotal)).
%concierto(Nombre,Pais,Fama,pequenio(DuracionCancion)).

concierto(mikuExpo,estadosUnidos,2000,gigante(2,6)).
concierto(magicalMirai,japon,3000,gigante(3,10)).
concierto(vocalektVisions,estadosUnidos,1000,mediano(9)).
concierto(mikuFest,argentina,100,pequenio(4)).


/*
Se requiere saber si un vocaloid puede participar en un concierto, 
esto se da cuando cumple los requisitos del tipo de concierto. 
También sabemos que Hatsune Miku puede participar en cualquier concierto.
*/

puedeParticipar(hatsuneMiku,Concierto):-
    concierto(Concierto,_,_,_).

puedeParticipar(Vocaloid,Concierto):-
    cantante(Vocaloid,_),
    concierto(Concierto,_,_,RequisitoTipoConcierto),
    cumpleRequisito(Vocaloid,RequisitoTipoConcierto).

cumpleRequisito(Vocaloid,gigante(CantMinCancionesASaber,TiempoTotal)):-
    sabeAlMenos(Vocaloid,CantMinCancionesASaber),
    superaElTiempoDado(Vocaloid,TiempoTotal).

cumpleRequisito(Vocaloid,mediano(DuracionTotal)):-
    not(superaElTiempoDado(Vocaloid,DuracionTotal)).

cumpleRequisito(Vocaloid,pequenio(Duracion)):-
    tieneCancionMayorA(Vocaloid,Duracion).

superaElTiempoDado(Vocaloid,Tiempo):-
    tiempoTotalCanciones(Vocaloid,TiempoTotal),
    TiempoTotal > Tiempo.

sabeAlMenos(Vocaloid,CantCanciones):-
    sabeCantidadCanciones(Vocaloid,Canciones),
    CantCanciones >= Canciones.


/*
Conocer el vocaloid más famoso, es decir con mayor nivel de fama. 
El nivel de fama de un vocaloid se calcula como la fama total que le dan los conciertos en los cuales puede participar 
multiplicado por la cantidad de canciones que sabe cantar.
*/

famoso(Vocaloid):-
    nivelFama(Vocaloid,Fama),
    forall(nivelFama(_,NivelFamaOtros),Fama >= NivelFamaOtros).

nivelFama(Vocaloid,FamaTotal):-
    cantante(Vocaloid,_),
    famaTotal(Vocaloid,FamaConcierto),
    sabeCantidadCanciones(Vocaloid,CantCanciones),
    FamaTotal is FamaConcierto * CantCanciones.

famaTotal(Vocaloid,FamaTotal):-
    findall(Fama,famaConcierto(Vocaloid,Fama),SumaDeFama),
    sumlist(SumaDeFama,FamaTotal).

famaConcierto(Vocaloid,FamaConcierto):-
    puedeParticipar(Vocaloid,Concierto),
    concierto(Concierto,_,FamaConcierto,_).