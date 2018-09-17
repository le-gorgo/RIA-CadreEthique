
imp(deon,A):- act(A),r(S,causes,A,T,transplant(X1,X2)).

t_weight(X,N):-numberInGroup(X,N).

%value
value(helpfulness).
displays(E,X,neg(helpfulness)):-effect(E,neg(alive(X))).
displays(E,X,helpfulness):-effect(E,neg(sick(X))).
m_weight(helpfulness,1,1).

value(respectForDead).
displays(transplant(X1,X2),X1,neg(respectForDead)):-event(transplant(X1,X2)).
m_weight(respectForDead,0,0).
%m_weight(respectForDead,1,1).

%instances
rule(minRisks20;moreGain).
instance(give(Z),minRisks20):-#sum{N,X:numberInGroup(X,N),initially(type(X,G)),negImpact(Z,G)}<=20, treatment(Z).
instance(give(Z),moreGain):-Npos=#sum{N,X:numberInGroup(X,N),initially(type(X,G)),posImpact(Z,G)}, #sum{N,X:numberInGroup(X,N),initially(type(X,G)),negImpact(Z,G)} < Npos, treatment(Z), Npos<=100.
instance(give(gamma),moreGain):-0<#sum{N,X:numberInGroup(X,N),initially(type(X,G)),posImpact(gamma,G)}, #sum{N,X:numberInGroup(X,N),initially(type(X,G)),negImpact(gamma,G)}<50.

aim(give(Z),E):-effect(E,neg(sick(X))),event(give(Z)).

number(-300..300).

%#show aim/2.
%#show instance/2.
%#show missing/1.
%#show negImpact/2.
%#show holds/3.
%#show initially/1.
%#show precCure/2.
%#show finally/1.
