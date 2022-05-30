%jugador(Nombre,Rating,Civilizacion).

jugador(juli,2200,jemeres).
jugador(aleP,1600,mongoles).
jugador(feli,500000,persas).
jugador(aleC,1723,otomanos).
jugador(ger,1729,ramanujanos).
jugador(juan,1515,britones).
jugador(marti,1342,argentinos).


%tiene(Nombre,QueTiene).
/* QueTiene->recurso(Madera,Alimento,Oro)
        ->unidad(Tipo,Cantidad)
        ->edificio(Tipo,Cantidad) */
tiene(aleP,unidad(samurai,199)).
tiene(aleP,unidad(espadachin,10)).
tiene(aleP,unidad(granjero,10)).
tiene(aleP,recurso(800,300,100)).
tiene(aleP,edificio(casa,40)).
tiene(aleP,edificio(castillo,1)).
tiene(juan,unidad(carreta,10)).
tiene(ger,unidad(espadachin,10)).
tiene(ger,recurso(800,300,100)).
% militar​(​Tipo, costo(Madera, Alimento, Oro), Categoria​)​.
militar(espadachin,costo(0,60,20),infanteria).
militar(arquero,costo(25,0,45),arqueria).
militar(mangudai,costo(55,0,65),caballeria).
militar(samurai,costo(0,60,30),unica).
militar(keshik,costo(0,80,50),unica).
militar(tercanos,costo(0,60,60),unica).
militar(alabardero,costo(25,35,0),piquero).
%aldeano(Tipo, produce(Madera, Alimento, Oro)).
aldeano(lenador,produce(23,0,0)).
aldeano(granjero,produce(0,32,0)).
aldeano(minero,produce(0,0,23)).
aldeano(cazador,produce(0,25,0)).
aldeano(pescador,produce(0,23,0)).
aldeano(alquimista,produce(0,0,25)).
%edificio(Edificio,costo(Madera,Alimento,Oro)).
edificio(casa,costo(30,0,0)).
edificio(granja,costo(0,60,0)).
edificio(herreria,costo(175,0,0)).
edificio(castillo,costo(650,0,300)).
edificio(maravillaMartinez,costo(10000,10000,10000)).


/* Punto 1)
Definir el predicado esUnAfano/2 , que nos dice si al jugar el primero contra el segundo, la diferencia de
rating entre el primero y el segundo es mayor a 500.
*/

esUnAfano(Jugador1,Jugador2):-
    jugador(Jugador1,Rating1,_),
    jugador(Jugador2,Rating2,_),
    diferenciaDeRatingMayorA(Rating1,Rating2,500).

diferenciaDeRatingMayorA(Rating1,Rating2,Umbral):-
    Diferencia is abs(Rating1 - Rating2),
    Diferencia > Umbral.


/* Punto 2)
Definir el predicado esEfectivo/2 , que relaciona dos unidades si la primera puede ganarle a la otra según
su categoría, dado por el siguiente piedra, papel o tijeras:
a) La caballería le gana a la arquería.
b) La arquería le gana a la infantería.
c) La infantería le gana a los piqueros.
d) Los piqueros le ganan a la caballería.
Por otro lado, los Samuráis son efectivos contra otras unidades únicas (incluidos los samurái).


Los aldeanos nunca son efectivos contra otras unidades: Por Principio de Universo Cerrado, no modelo la condición
*/

esEfectivo(Unidad1,Unidad2):-
    militar(Unidad1,_,caballeria),
    militar(Unidad2,_,arqueria).

esEfectivo(Unidad1,Unidad2):-
    militar(Unidad1,_,arqueria),
    militar(Unidad2,_,infanteria).

esEfectivo(Unidad1,Unidad2):-
    militar(Unidad1,_,infanteria),
    militar(Unidad2,_,piqueros).

esEfectivo(Unidad1,Unidad2):-
    militar(Unidad1,_,piqueros),
    militar(Unidad2,_,caballeria).

esEfectivo(samurai,Unidad2):-
    militar(Unidad2,_,unica).


% Punto 3
% Definir el predicado alarico/1 que se cumple para un jugador si solo tiene unidades de infantería.

alarico(Jugador):-
    jugador(Jugador,_,_),
    soloTiene(Jugador,infanteria).

soloTiene(Jugador,TipoUnidad):-
    tiene(Jugador,_),
    forall(tiene(Jugador,unidad(Unidad,_)),militar(Unidad,_,TipoUnidad)).

% Punto 4
% Definir el predicado leonidas/1 , que se cumple para un jugador si solo tiene unidades de piqueros.

leonidas(Jugador):-
    jugador(Jugador,_,_),
    soloTiene(Jugador,piquero).

% Punto 5
% Definir el predicado nomada/1 , que se cumple para un jugador si no tiene casas.

nomada(Jugador):-
    jugador(Jugador,_,_),
    noTieneCasa(Jugador).

noTieneCasa(Jugador):-
    not(tiene(Jugador,edificio(casa,_))).

% Punto 6
/*
 Definir el predicado cuantoCuesta/2 , que relaciona una unidad o edificio con su costo. De las unidades
militares y de los edificios conocemos sus costos. Los aldeanos cuestan 50 unidades de alimento. Las
carretas y urnas mercantes cuestan 100 unidades de madera y 50 de oro cada una.
*/

cuantoCuesta(Militar,Costo):-
    militar(Militar,Costo,_).

cuantoCuesta(Edificio,Costo):-
    edificio(Edificio,Costo).

cuantoCuesta(Aldeano,(0,50,0)):-
    aldeano(Aldeano,_).

cuantoCuesta(carreta,(100,0,50)).

cuantoCuesta(urnaMercante,(100,0,50)).


/* Punto 7
Definir el predicado produccion/2 , que relaciona una unidad con su producción de recursos por minuto.
De los aldeanos, según su profesión, se conoce su producción. Las carretas y urnas mercantes producen
32 unidades de oro por minuto. Las unidades militares no producen ningún recurso, salvo los Keshiks, que
producen 10 de oro por minuto.
*/

produccion(Unidad,Produccion):-
   aldeano(Unidad,Produccion).

produccion(carreta,produce(0,0,32)).

produccion(urnaMercante,produce(0,0,32)).

produccion(keshiks,produce(0,0,10)).

/* Punto 8
Definir el predicado produccionTotal/3 que relaciona a un jugador con su producción total por minuto de
cierto recurso, que se calcula como la suma de la producción total de todas sus unidades de ese recurso.
*/

produccionTotal(Jugador,Recurso,ProduccionTotal):-
    jugador(Jugador,_,_),
    recurso(Recurso),
    findall(Produccion,(tiene(Jugador,Unidad),produccionGrupalDe(Unidad,Recurso,Produccion)),Producciones),
    sumlist(Producciones, ProduccionTotal).

produccionGrupalDe(unidad(Unidad,Cantidad),Recurso,ProduccionTotal):-
    produccionIndividualDe(Unidad,Recurso,ProduccionRecurso),
    ProduccionTotal is ProduccionRecurso*Cantidad.

produccionIndividualDe(Unidad,Recurso,ProduccionRecurso):-
    produccion(Unidad,Produccion),
    cantidadRecurso(Produccion,Recurso,ProduccionRecurso).


cantidadRecurso(produce(Madera,_,_),madera,Madera).
cantidadRecurso(produce(_,Alimento,_),alimento,Alimento).
cantidadRecurso(produce(_,_,Oro),oro,Oro).
recurso(madera).
recurso(oro).
recurso(alimento).

/* Punto 9
Definir el predicado estaPeleado/2 que se cumple para dos jugadores cuando no es un afano para
ninguno, tienen la misma cantidad de unidades y la diferencia de valor entre su producción total de
recursos por minuto es menor a 100. ¡Pero cuidado! No todos los recursos valen lo mismo: el oro vale
cinco veces su cantidad; la madera, tres veces; y los alimentos, dos veces.
*/

estaPeleado(Jugador1,Jugador2):-
    jugadoresDiferentes(Jugador1,Jugador2),
    not(esUnAfano(Jugador1,Jugador2)),
    mismaCantidadDeUnidades(Jugador1,Jugador2),
    diferenciaProduccionTotal(Jugador1,Jugador2,100).

jugadoresDiferentes(Jugador1,Jugador2):-
    jugador(Jugador1,_,_),
    jugador(Jugador2,_,_),
    Jugador1 \= Jugador2.

diferenciaProduccionTotal(Jugador1,Jugador2,Umbral):-
    valorProduccionTotal(Jugador1,ValorTotalJ1),
    valorProduccionTotal(Jugador2,ValorTotalJ2),
    Diferencia is abs(ValorTotalJ1 - ValorTotalJ2),
    Diferencia > Umbral.
    

valorProduccionTotal(Jugador,ValorTotal):-
    produccionTotal(Jugador,madera,ProduccionMadera),
    produccionTotal(Jugador,alimento,ProduccionAlimento),
    produccionTotal(Jugador,oro,ProduccionOro),
    ValorTotal is (ProduccionMadera * 3) + (ProduccionAlimento * 2) + (ProduccionOro * 5).    

mismaCantidadDeUnidades(Jugador1,Jugador2):-
    cantidadUnidades(Jugador1,Cant),
    cantidadUnidades(Jugador2,Cant).

cantidadUnidades(Jugador,CantUnidadesTotales):-
    findall(CantUnidades,tiene(Jugador,unidad(_,CantUnidades)),Cantidades),
    sumlist(Cantidades,CantUnidadesTotales).

/* Punto 10
 Definir el predicado avanzaA/2 que relaciona un jugador y una edad si este puede avanzar a ella:
a) Siempre se puede avanzar a la edad media.
b) Puede avanzar a edad feudal si tiene al menos 500 unidades de alimento y una casa.
c) Puede avanzar a edad de los castillos si tiene al menos 800 unidades de alimento y 200 de oro.
También es necesaria una herrería, un establo o una galería de tiro.
d) Puede avanzar a edad imperial con 1000 unidades de alimento, 800 de oro, un castillo y una
universidad.
*/

avanzaA(Jugador,Edad):-
    jugador(Jugador,_,_),
    puedeAvanzar(Jugador,Edad).

puedeAvanzar(_,edadMedia).

puedeAvanzar(Jugador,edadFeudal):-
    tieneAlMenos(Jugador,alimento,500),
    tieneAlMenos(Jugador,casa,1).

puedeAvanzar(Jugador,edadDeLosCastillos):-
    tieneAlMenos(Jugador,alimento,800),
    tieneAlMenos(Jugador,oro,200),
    tieneAlgunoDe(Jugador,herreria,establo,galeriaDeTiro).

puedeAvanzar(Jugador,edadImperial):-
    tieneAlMenos(Jugador,alimento,1000),
    tieneAlMenos(Jugador,alimento,800),
    tieneAlMenos(Jugador,castillo,1),
    tieneAlMenos(Jugador,universidad,1).

tieneAlMenos(Jugador,Buscado,Umbral):-
    tiene(Jugador,edificio(Buscado,Cantidad)),
    Cantidad>=Umbral.


tieneAlMenos(Jugador,Buscado,Umbral):-
    tiene(Jugador,Recursos),
    cantidadRecurso(Recursos,Buscado,Cantidad),
    Cantidad>=Umbral.

tieneAlgunoDe(Jugador,Edificio1,_,_):-
    tieneAlMenos(Jugador,Edificio1,1).

tieneAlgunoDe(Jugador,_,Edificio2,_):-
    tieneAlMenos(Jugador,Edificio2,1).

tieneAlgunoDe(Jugador,_,_,Edificio3):-
    tieneAlMenos(Jugador,Edificio3,1).


