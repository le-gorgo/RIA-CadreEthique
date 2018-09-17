event(E):-act(E).
event(E):-auto(E).
negative(neg(F)) :- effect(E,neg(F)).

%MOTEUR CAUSAL

% Causes
r(S,causes,E,T,F)    :- occurs(S,E,T), effect(E,F), holds(S,F,T+1).
r(S,causes,F,T,U)    :- holds(S,F,T), prec(F,U), occurs(S,U,T), auto(U).
r(S,causes,E1,T1,E2) :- r(S,causes,E1,T1,C), r(S,causes,C,T2,E2), event(E1), event(E2), T2>T1.

#show r/5.
