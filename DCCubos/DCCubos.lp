% Esta línea define el dominio de tiempo en el que se llevarán a cabo los movimientos. 
% 'bound' es un número arbitrario que representa el límite superior del intervalo de tiempo.
tiempo(0..bound).

% Definición de los bloques que formaran parte del problema.
bloque(a).
bloque(b).
bloque(c).
bloque(d).
bloque(e).
bloque(f).
bloque(g).
bloque(h).

% Definición de los lugares donde se pueden colocar los bloques.
lugar(X) :- bloque(X).
lugar(mesa).

% Esta línea define la acción de ejecutar un movimiento. En cada instante de tiempo T, 
% se puede ejecutar un movimiento posible de un bloque X a un lugar Y, siempre que T 
% sea diferente de 'bound'. Con la restricción de cardinalidad se asegura que no se
% ejecuten más de un movimiento en cada instante de tiempo.
0{ejecutar(X,Y,T) : movimientoposible(X,Y,T)}1 :- tiempo(T), T!=bound.

% Estas líneas definen los bloques que están siendo movidos en un instante de tiempo T y sus destinos.
origen_movimiento(X,T) :- ejecutar(X,Y,T).
destino_movimiento(Y,T) :- ejecutar(X,Y,T).

% Esta línea indica que un bloque X sigue estando sobre el bloque Y en el tiempo T+1 
% si no está siendo movido en el tiempo T. En otras palabras, si no se origina un 
% movimiento de X en T, X seguirá sobre Y en T+1.
sobre(X,Y,T+1) :-
	tiempo(T),
	sobre(X,Y,T),
	not origen_movimiento(X,T).

% Esta línea indica que un bloque X estará sobre el bloque Y en el tiempo T+1 
% si se ejecuta un movimiento desde X a Y en el tiempo T.
sobre(X,Y,T+1) :- 
	bloque(X),lugar(Y),tiempo(T),
	ejecutar(X,Y,T).

% Estas líneas definen si un bloque está tapado (tiene otro bloque encima) o 
% libre en un instante de tiempo T. Si X está sobre Y en el tiempo T, Y está tapado por X.
% Si X no está tapado por ningún bloque en el tiempo T, entonces X está libre.
bloquetapado(Y,T) :- sobre(X,Y,T), tiempo(T).
bloquelibre(X,T) :- bloque(X), tiempo(T), not bloquetapado(X,T).

% Estas líneas definen las condiciones para que un movimiento sea posible. Un bloque X puede 
% moverse a un bloque Y si ambos bloques están libres y X no está ya sobre Y en el instante 
% de tiempo T. Además, X no puede moverse y quedar sobre sí mismo (X!=Y).
movimientoposible(X,Y,T) :- bloquelibre(X,T), bloquelibre(Y,T), X!=Y, not sobre(X,Y,T).
% Un bloque X también puede moverse a la mesa si está libre y no está ya sobre 
% la mesa en el tiempo T, es decir, si es que no está sobre la mesa actualmente.
movimientoposible(X,mesa,T) :- bloquelibre(X,T), not sobre(X,mesa,T).

% Esta línea indica que no puede haber un modelo en el cual en el tiempo límite 
% los bloques no se encuentran en la configuración objetivo.
:- not objetivo(bound).

% Condiciones iniciales
sobre(f,mesa,0).
sobre(g,mesa,0).
sobre(h,mesa,0).
sobre(e,mesa,0).
sobre(d,mesa,0).
sobre(a,mesa,0).
sobre(b,a,0).
sobre(c,b,0).

% Objetivo
objetivo(T) :- sobre(c,b,T), sobre(b,a,T), sobre(a,e,T), sobre(e,mesa,T).

#show ejecutar/3.