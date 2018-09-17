%MOTEUR CAUSAL

% Causes
r(S,causes,E,T,F)    :- occurs(S,E,T), effect(E,F), holds(S,F,T+1).
r(S,causes,F,T,U)    :- holds(S,F,T), prec(F,U), occurs(S,U,T), auto(U).
r(S,causes,E1,T1,E2) :- r(S,causes,E1,T1,C), r(S,causes,C,T2,E2), event(E1), event(E2), T2>T1.

% Prevents
   %prédicats intermédiaires
hyp(F1,F2) :- prec(F1,U), effect(U,F2), auto(U).
hyp(F1,F3) :- hyp(F1,F2), hyp(F2,F3).
arises(S,E) :- occurs(S,E,T).
transTerm(S,E,F,T)  :- occurs(S,E,T), effect(E,neg(F)).
transTerm(S,E,F2,T) :- transTerm(S,E,F1,T), hyp(F1,F2), not negative(F2).
irrelevant(S,E1,T,E2) :- transTerm(S,E1,F1,T), prec(F1,E1), prec(F2,E2), not holds(S,F2,T), not transTerm(S,E1,F2,T).
   % prevents
r(S,prevents,E1,T,E2) :- transTerm(S,E1,T,E2), prec(F,E2), not irrelevant(S,E1,T,E2), not arises(S,E2), event(E2).


%#show occurs/3.
%#show performs/3.
%#show initiates/4.
%#show terminates/4.
%#show clipped/3.
%#show holds/3.
#show r/4.
