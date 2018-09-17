%droit de vie
%involves(E,X):-effect(E,on(X,M)),group(X).
%involves(E,X):-effect(E,neg(on(X,M))),group(X).
%involves(E,X):-effect(E,alive(X)),group(X).
%involves(E,X):-effect(E,neg(alive(X))),group(X).

right(life,X,alive(X)):-group(X).


m_weight(life,1,1).
t_weight(X,N):-numberInGroup(X,N).

%%droits
%violates(E,r(X,life)):-effect(E,neg(alive(X))).
%badEffect(E,X,M) :- effect(E,neg(F)), right(M,X,F).

%value
%value(helpfulness).
%displays(E,X,neg(helpfulness)):-effect(E,neg(alive(X))).
%m_weight(helpfulness,1,1).
%goodEffect(E,X,M) :- displays(E,X,M), value(M).
%badEffect(E,X,M) :- displays(E,X,neg(M)), value(M).

number(-300..300).

%#show aim/2.
%#show instance/2.
%#show missing/1.
%#show negImpact/2.
%#show holds/3.
%#show initially/1.
%#show precCure/2.
%#show finally/1.
