event(E):-act(E).
event(E):-auto(E).
negative(neg(F)) :- effect(E,neg(F)).

%MOTEUR CAUSAL

% Causes
r(S,causes,E,T,F)    :- occurs(S,E,T), effect(E,F), holds(S,F,T+1).
r(S,causes,F,T,U)    :- holds(S,F,T), prec(F,U), occurs(S,U,T), auto(U).
r(S,causes,E1,T1,E2) :- r(S,causes,E1,T1,C), r(S,causes,C,T2,E2), event(E1), event(E2), T2>T1.

% Prevents
   %prédicats intermédiaires
hypCons(F1,F2) :- prec(F1,U), effect(U,F2), auto(U).
%arises(S,E) :- occurs(S,E,T).
transTerm(S,E,F,T)  :- occurs(S,E,T), effect(E,neg(F)).
transTerm(S,E,F2,T) :- transTerm(S,E,F1,T), hypCons(F1,F2), not negative(F2).
r(S,prevents,E1,T,E2) :- transTerm(S,E1,F1,T), prec(F1,E2), {prec(F2,E2):not holds(S,F2,T2), not transTerm(S,E1,F2,T)}0,
				{occurs(S,E2,T3):time(T3),T3>=T}0, T2>T, time(T2), event(E2).
r(S,prevents,E1,T1,E2) :- r(S,causes,E1,T1,E3), r(S,prevents,E3,T2,E2), event(E1), event(E2),event(E3), T2>T1.

#show r/5.
#show transTerm/4.
#show irrelevant/4.
