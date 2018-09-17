

%%%% THEORIES DU BIEN %%%%
   % qualitatif
%values
good(E,X,M) :- displays(E,X,M), value(M).
bad(E,X,M) :- displays(E,X,neg(M)), value(M).

   % quantitatif
weightedGood(E,N1*N2,X,M) :- good(E,X,M), t_weight(X,N1), m_weight(M,N2,_).
weightedBad(E,N1*N2,X,M) :- bad(E,X,M), t_weight(X,N1), m_weight(M,_,N2).
%weightedEffects(E,Ng-Nb) :- Ng=#sum{I,X,M:weightedGood(E,I,X,M)},Nb=#sum{K,X,M:weightedBad(E,K,X,M)}, number(Ng;Nb),event(E).

%%%% THEORIES DU JUSTES %%%%

% Permissibilité définié via non-impermissibilité
th(pureBad;leastBad;leastBad2;benCosts;actUti;ruleUti;doNotKill;deon;kant;dde).
per(J,A) :- act(A), not imp(J,A),th(J).

%%% Weight definitions %%%%
weightBadAct(A,N)  :- act(A), number(N),   
        N=#sum{K,X,M,E:weightedBad(E,K,X,M),r(S,causes,A,T,E)}.
weightGoodAct(A,N) :- act(A), number(N),   
        N=#sum{K,X,M,E:weightedGood(E,K,X,M),r(S,causes,A,T,E)}.
weightAct(A,Ng-Nb) :-act(A), number(Ng), number(Nb), 
        weightBadAct(A,Nb), weightGoodAct(A,Ng).

% pureBad
badCons(S,A,T) :- act(A), r(S,causes,A,T,E), bad(E,X,M).
goodCons(S,A,T) :- act(A), r(S,causes,A,T,E), good(E,X,M).
  
imp(pureBad,A) :- badCons(S,A,T), not goodCons(S,A,T).


%leastBad
%worse(E1,E2) :- r(S1,causes,A1,T1,E1),r(S2,causes,A2,T2,E2), weightedBad(E1,N1,_,_), weightedBad(E2,N2,_,_), N1<N2.
worse(E1,E2) :- r(S,causes,A,T,E1),r(S,causes,A,T,E2), weightedBad(E1,N1,_,_), weightedBad(E2,N2,_,_), N1>N2.
worstCons(S,A,T,E) :- act(A), event(E), r(S,causes,A,T,E), {event(E2):r(S,causes,A,T,E2),worse(E2,E),not worse(E,E2)}0.
imp(leastBad,A1) :- worstCons(S1,A1,T1,E1), worstCons(S2,A2,T2,E2), worse(E1,E2), A1!=A2.

%leastBad2
imp(leastBad2,A1) :- weightBadAct(A1,N1), weightBadAct(A2,N2), N1>N2.

% benCosts et actUti
imp(benCosts,A):- weightAct(A,N2), number(N2), N2<0.
imp(actUti,A1) :- weightAct(A1,N1), weightAct(A2,N2), N1<N2.

% ruleUti
weightRule(R,N) :- rule(R), number(N), N=#sum{N1,A:weightAct(A,N1),instance(A,R)}.
imp(ruleUti,A):- act(A), instance(A,R), weightRule(R,N), N<0.

% conduct : doNotKill
th(doNotKill).
imp(doNotKill,A):- act(A),r(S,causes,A,T,kills(_,_,_)).

% formule de la fin en elle-même
involves(E,X):-bad(E,X,M).
imp(kant,A) :- act(A), r(S,causes,A,T,E), involves(E,X), not aim(A,E).

%dde
imp(dde1,A) :- act(A), bad(A,X,M).  % ???
imp(dde2,A) :- act(A), r(S,causes,A,T,E1), r(S,causes,E1,T2,E2), bad(E1,X1,M1), good(E2,X2,M2).
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

%#show occurs/3.
%#show imp/2.
%#show per/2.
%#show performs/3.
%#show initiates/4.
%#show terminates/4.
%#show clipped/3.
%#show holds/3.
