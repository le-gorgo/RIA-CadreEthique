event(E):-act(E).
event(E):-auto(E).


%%%% THEORIES DU BIEN %%%%
   % qualitatif
%droits
bad(E,X,M)  :- effect(E,neg(F)), right(M,X,F).
bad(E,X,M)  :- effect(E,F), right(M,X,neg(F)).
good(E,X,M) :- effect(E,F), right(M,X,F).

   % quantitatif
weightedGood(E,N1*N2,X,M) :- good(E,X,M), t_weight(X,N1), m_weight(M,N2,_).
weightedBad(E,N1*N2,X,M) :- bad(E,X,M), t_weight(X,N1), m_weight(M,_,N2).


%%%% THEORIES DU JUSTES %%%%


weightBadAct(A,N1+N2)  :- act(A), number(N1), number(N2), 
        N1=#sum{K,X,M,E:weightedBad(E,K,X,M),r(S,causes,A,T,E)},
        N2=#sum{K,X,M,E:weightedGood(E,K,X,M),r(S,prevents,A,T,E)}.
weightGoodAct(A,N1+N2) :- act(A), number(N), number(N1), number(N2),   
        N1=#sum{K,X,M,E:weightedGood(E,K,X,M),r(S,causes,A,T,E)},
        N2=#sum{K,X,M,E:weightedBad(E,K,X,M),r(S,prevents,A,T,E)}.
weightAct(A,Ng-Nb) :-act(A), number(Ng), number(Nb), 
        weightBadAct(A,Nb), weightGoodAct(A,Ng).

% Permissibilité définié via non-impermissibilité
th(pureBad;leastBad2;benCosts;actUti;doNotKill;dde).
per(J,A) :- act(A), not imp(J,A),th(J).

% pureBad
badCons(S,A,T) :- act(A), r(S,causes,A,T,E), bad(E,X,M).
goodCons(S,A,T) :- act(A), r(S,causes,A,T,E), good(E,X,M).
  % ajout prevents
badCons(S,A,T) :- act(A), r(S,prevents,A,T,E), good(E,X,M).
goodCons(S,A,T) :- act(A), r(S,prevents,A,T,E), bad(E,X,M).
  
imp(pureBad,A) :- badCons(S,A,T), not goodCons(S,A,T).

imp(leastBad2,A1) :- weightBadAct(A1,N1), weightBadAct(A2,N2), N1>N2.

% benCosts et actUti
imp(benCosts,A):- weightAct(A,N2), number(N2), N2<0.
imp(actUti,A1) :- weightAct(A1,N1), weightAct(A2,N2), N1<N2.

% conduct : doNotKill
imp(doNotKill,A):- act(A),r(S,causes,A,T,E),effect(E,neg(alive(G))).

%dde
imp(dde1,A) :- act(A), bad(A,X,M).  % ???
imp(dde2,A) :- act(A), r(S,causes,A,T,E1), r(S,causes,E1,T2,E2), bad(E1,X1,M1), good(E2,X2,M2).
imp(dde2,A) :- act(A), r(S,causes,A,T,E1), r(S,prevents,E1,T2,E2), bad(E1,X1,M1), bad(E2,X2,M2).
imp(dde3,A) :- imp(benCosts,A).
imp(dde,A) :- imp(dde1,A).
imp(dde,A) :- imp(dde2,A).
imp(dde,A) :- imp(dde3,A).

%#show weightedEffects/2.
%#show weightRule/2.
%#show worstCons/4.
%#show badCons/3.
%#show weightAct/2.
%#show weightBadAct/2.
%#show imp/2.
%#show per/2.
