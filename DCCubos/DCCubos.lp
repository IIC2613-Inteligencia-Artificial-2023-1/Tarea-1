tiempo(0..bound).

bloque(a).
bloque(b).
bloque(c).
bloque(d).
bloque(e).
bloque(f).
bloque(g).
bloque(h).

lugar(X) :- bloque(X).
lugar(mesa).

0{ejecutar(X,Y,T) : movimientoposible(X,Y,T)}1 :- tiempo(T), T!=bound.

origen_movimiento(X,T) :- ejecutar(X,Y,T).
destino_movimiento(Y,T) :- ejecutar(X,Y,T).

sobre(X,Y,T+1) :-
	tiempo(T),
	sobre(X,Y,T),
	not origen_movimiento(X,T).

sobre(X,Y,T+1) :- 
	bloque(X),lugar(Y),tiempo(T),
	ejecutar(X,Y,T).


bloquetapado(Y,T) :- sobre(X,Y,T), tiempo(T).
bloquelibre(X,T) :- bloque(X), tiempo(T), not bloquetapado(X,T).

movimientoposible(X,Y,T) :- bloquelibre(X,T), bloquelibre(Y,T), X!=Y, not sobre(X,Y,T).
movimientoposible(X,mesa,T) :- bloquelibre(X,T), not sobre(X,mesa,T).

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