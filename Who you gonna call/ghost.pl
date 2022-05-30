
%herramientasRequeridas(Tarea,QueNecesito).
herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).


/* Punto 1
Agregar a la base de conocimientos la siguiente información:
Egon tiene una aspiradora de 200 de potencia.
Egon y Peter tienen un trapeador, Ray y Winston no.
Sólo Winston tiene una varita de neutrones.

Nadie tiene una bordeadora: Por Principio de Universo Cerrado, no modelaremos esta condición.
*/

tiene(egon,aspiradora(200)).
tiene(egon,trapeador).
tiene(peter,trapeador).
tiene(winston,varitaDeNeutrones).

/* Punto 2
Definir un predicado que determine si un integrante satisface la necesidad de una herramienta requerida. 
Esto será cierto si tiene dicha herramienta, teniendo en cuenta que si la herramienta requerida 
es una aspiradora, el integrante debe tener una con potencia igual o superior a la requerida.

Nota: No se pretende que sea inversible respecto a la herramienta requerida.
*/

satisfaceNecesidad(Integrante,Herramienta):-
    cumpleConHerramientaRequerida(Integrante,Herramienta).
    
cumpleConHerramientaRequerida(Integrante,aspiradora(PotenciaRequerida)):-
    tiene(Integrante,aspiradora(Potencia)),
    between(0,Potencia,PotenciaRequerida).
    % Potencia >= PotenciaRequerida.

cumpleConHerramientaRequerida(Integrante,Herramienta):-    
    tiene(Integrante,Herramienta).

/*
Queremos saber si una persona puede realizar una tarea, que dependerá de las herramientas que tenga. 
Sabemos que:
- Quien tenga una varita de neutrones puede hacer cualquier tarea, 
independientemente de qué herramientas requiera dicha tarea.
- Alternativamente alguien puede hacer una tarea si puede satisfacer la necesidad de todas las herramientas 
requeridas para dicha tarea.
*/

puedeRealizar(Integrante,Tarea):-
    herramientasRequeridas(Tarea,_),
    tiene(Integrante,varitaDeNeutrones).

puedeRealizar(Integrante,Tarea):-
    tiene(Integrante,_),
    herramientasRequeridas(Tarea,_),
    forall(requerida(Herramienta,Tarea),satisfaceNecesidad(Integrante,Herramienta)).

requerida(Herramienta,Tarea):-
    herramientasRequeridas(Tarea,ListaHerramientas),
    member(Herramienta,ListaHerramientas).


/* Punto 4
Nos interesa saber de antemano cuanto se le debería cobrar a un cliente por un pedido 
(que son las tareas que pide). Para ellos disponemos de la siguiente información en la base de conocimientos:

- tareaPedida/3: relaciona al cliente, con la tarea pedida y la cantidad de metros cuadrados sobre los cuales 
hay que realizar esa tarea.
- precio/2: relaciona una tarea con el precio por metro cuadrado que se cobraría al cliente.
Entonces lo que se le cobraría al cliente sería la suma del valor a cobrar por cada tarea, 
multiplicando el precio por los metros cuadrados de la tarea.
*/

%tareaPedida(tarea, cliente, metrosCuadrados).
tareaPedida(ordenarCuarto, dana, 20).
tareaPedida(cortarPasto, walter, 50).
tareaPedida(limpiarTecho, walter, 70).
tareaPedida(limpiarBanio, louis, 15).

%precio(tarea, precioPorMetroCuadrado).
precio(ordenarCuarto, 13).
precio(limpiarTecho, 20).
precio(limpiarBanio, 55).
precio(cortarPasto, 10).
precio(encerarPisos, 7).

precioTotal(Cliente,PrecioTotal):-
    tareaPedida(_,Cliente,_),
    findall(PrecioTarea,cuantoCuestaTarea(_,Cliente,PrecioTarea),Precios),
    sumlist(Precios,PrecioTotal).

cuantoCuestaTarea(Tarea,Cliente,PrecioTotalTarea):-
    tareaPedida(Tarea,Cliente,MetrosCuadrados),
    precio(Tarea,PrecioPorMetroCuadrado),
    PrecioTotalTarea is PrecioPorMetroCuadrado * MetrosCuadrados.

/* Punto 5
Finalmente necesitamos saber quiénes aceptarían el pedido de un cliente.
Un integrante acepta el pedido cuando puede realizar todas las tareas del pedido y además está dispuesto a
aceptarlo.
Sabemos que Ray sólo acepta pedidos que no incluyan limpiar techos, 
Winston sólo acepta pedidos que paguen más de $500, Egon está dispuesto a aceptar pedidos que no tengan tareas 
complejas y Peter está dispuesto a aceptar cualquier pedido.
Decimos que una tarea es compleja si requiere más de dos herramientas. 
Además la limpieza de techos siempre es compleja.
*/

aceptaPedido(Integrante,Cliente):-
    estaDispuestoAHacer(Integrante,Cliente),
    forall(tareaPedida(Tarea,Cliente,_),puedeRealizar(Integrante,Tarea)).

estaDispuestoAHacer(ray,Cliente):-
    tareaPedida(_,Cliente,_),
    not(tareaPedida(limpiarTecho,Cliente,_)).

estaDispuestoAHacer(winston,Cliente):-
    precioTotal(Cliente,Precio),
    Precio > 500.

estaDispuestoAHacer(peter,Cliente):-
    tareaPedida(_,Cliente,_).

estaDispuestoAHacer(egon,Cliente):-
    tareaPedida(_,Cliente,_),
    forall(tareaPedida(Tarea,Cliente,_),not(tareaCompleja(Tarea))).

tareaCompleja(Tarea):-
    herramientasRequeridas(Tarea,ListaDeHerramientas),
    length(ListaDeHerramientas,CantHerramientas),
    CantHerramientas > 2.

tareaCompleja(limpiarTecho).


