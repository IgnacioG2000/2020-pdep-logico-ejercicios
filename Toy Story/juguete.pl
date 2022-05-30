% Relaciona al dueño con el nombre del juguete
%y la cantidad de años que lo ha tenido
duenio(andy, woody, 8).
duenio(sam, jessie, 3).
duenio(andy,buzz,9).
duenio(sam,seniorCaraDePapa,7).
% Relaciona al juguete con su nombre
% los juguetes son de la forma:
% deTrapo(tematica)
% deAccion(tematica, partes)
% miniFiguras(tematica, cantidadDeFiguras)
% caraDePapa(partes)
juguete(woody, deTrapo(vaquero)).
juguete(jessie, deTrapo(vaquero)).
juguete(buzz, deAccion(espacial,[original(casco)])).
juguete(soldados, miniFiguras(soldado, 60)).
juguete(monitosEnBarril, miniFiguras(mono, 50)).
juguete(seniorCaraDePapa, caraDePapa([original(pieIzquierdo), original(pieDerecho), repuesto(nariz)])).
% Dice si un juguete es raro
esRaro(deAccion(stacyMalibu, 1, [sombrero])).
% Dice si una persona es coleccionista
esColeccionista(sam).


% Punto 1 A
tematica(Juguete,Tematica):-
    juguete(Juguete,Tema),
    temaDeCadaUno(Tema,Tematica).

temaDeCadaUno(deTrapo(Tematica),Tematica).
temaDeCadaUno(deAccion(Tematica,_),Tematica).
temaDeCadaUno(miniFiguras(Tematica,_),Tematica).
temaDeCadaUno(caraDePapa(_),caraDePapa).


% Punto 1 B

esDePlastico(Juguete):-
    juguete(Juguete, miniFiguras(_,_)).

esDePlastico(Juguete):-
    juguete(Juguete,caraDePapa(_)).


% Punto 1 C

esDeColeccion(Juguete):-
    juguete(Juguete,Tema),
    puedeSerColeccionable(Tema).

puedeSerColeccionable(deAccion(_,_)):-
    esRaro(deAccion(_,_)).

puedeSerColeccionable(caraDePapa(_)):-
    esRaro(caraDePapa(_)).

puedeSerColeccionable(deTrapo(_)).



% Punto 2

amigoFiel(Duenio,Juguete):-
    juguete(Juguete,_),
    duenio(Duenio,Juguete,Tiempo),
    not(esDePlastico(Juguete)),
    forall(otrosJuguetes(Duenio,Juguete,Tiempo2), Tiempo > Tiempo2).

otrosJuguetes(Duenio,Juguete,Tiempo):-
    duenio(Duenio,Juguete2,Tiempo),
    Juguete \= Juguete2.


% Punto 3

/*
superValioso(Juguete):-
    juguete(Juguete,Tematica),
    duenio(Duenio,Juguete,_),
    esDeColeccion(Juguete),
    not(esColeccionista(Duenio)),
    tienePartesOriginales(Tematica)
    */

esOriginal(original(_)).
esRepuesto(repuesto(_)).

% Punto 4

duoDinamico(Duenio,Juguete1,Juguete2):-
    duenio(Duenio,Juguete1,_),
    duenio(Duenio,Juguete2,_),
    hacenBuenaPareja(Juguete1,Juguete2).

hacenBuenaPareja(Juguete1,Juguete2):-
    juguete(Juguete1,Tema1),
    juguete(Juguete2,Tema2),
    temaDeCadaUno(Tema1,Tematica),
    temaDeCadaUno(Tema2,Tematica),
    Juguete1 \= Juguete2.

hacenBuenaPareja(woody,buzz).


% Punto 5

felicidad(Duenio,CantFelicidad):-
    duenio(Duenio,_,_),
    findall(Felicidad,(duenio(Duenio,Juguete,_),felicidadDe(Juguete,Felicidad)),Felicidades),
    sumlist(Felicidades,CantFelicidad).


felicidadDe(Juguete,Felicidad):-
    juguete(Juguete,miniFiguras(_,CantFiguras)),
    Felicidad is 20 * CantFiguras.

felicidadDe(Juguete,100):-
    juguete(Juguete,deTrapo(_)).

felicidadDe(Juguete,Felicidad):-
    condicionDe(Juguete,Felicidad).



felicidadDe(Juguete,Felicidad):-
    juguete(Juguete,caraDePapa(Partes)),
    cantPartesOriginales(Partes,CantOriginal),
    cantPartesRepuesto(Partes,CantRepuesto),
    Felicidad is CantOriginal * 5 + CantRepuesto * 5.

cantPartesOriginales(Partes,CantOriginal):-
    findall(PartesOriginales,(member(PartesOriginales,Partes),esOriginal(Partes)),ListaPartesOriginales),
    length(ListaPartesOriginales,CantOriginal).

cantPartesRepuesto(Partes,CantRepuesto):-
    findall(PartesRepuesto,(member(PartesRepuesto,Partes),esRepuesto(Partes)),ListaPartesRepuesto),
    length(ListaPartesRepuesto,CantRepuesto).


condicionDe(Juguete,120):-
    duenio(Duenio,Juguete,_),
    juguete(Juguete,deAccion(_,_)),
    esDeColeccion(Juguete),
    not(esColeccionista(Duenio)).

condicionDe(Juguete,100):-
    juguete(Juguete,deAccion(_,_)).


% Punto 6

puedeJugarCon(Alguien,Juguete):-
    duenio(Alguien,Juguete,_),
    tienePermisoCon(Alguien,Juguete).


tienePermisoCon(Alguien,Juguete):-
    puedePrestar(Alguien,Otro),
    puedeJugarCon(Otro,Juguete).

puedePrestar(Alguien,Otro):-
    cantidadDeJuguetes(Alguien,CantAlguien),
    cantidadDeJuguetes(Otro,CantOtro),
    CantAlguien > CantOtro,
    Alguien \= Otro.

cantidadDeJuguetes(Duenio,CantJuguetes):-
    findall(Juguete,duenio(Duenio,Juguete,_),Juguetes),
    length(Juguetes,CantJuguetes).
