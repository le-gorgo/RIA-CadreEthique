treatment(alpha;beta;gamma).
%treatment(alpha;beta;gamma;delta).

divGroup(1..20).
numberInGroup(X,5):-divGroup(X).
variant(g1;g2;g3;g4;g5;g6).

posImpact(alpha,g1).
negImpact(alpha,g2).
posImpact(beta,(g3;g6)).
negImpact(beta,g4).
posImpact(gamma,g2).
negImpact(gamma,(g1;g5;g6)).
posImpact(delta,g5).


act(give(Z)):-treatment(Z).
prec(sick(X),give(Z)):-divGroup(X), act(give(Z)).
effect(give(Z),received(X,Z)):-divGroup(X), act(give(Z)).

auto(cures(X,G,Z)) :- treatment(Z),divGroup(X),variant(G),posImpact(Z,G).
prec(received(X,Z),cures(X,G,Z)) :- auto(cures(X,G,Z)).
prec(alive(X),cures(X,G,Z)) :- auto(cures(X,G,Z)).
prec(sick(X),cures(X,G,Z)) :- auto(cures(X,G,Z)).
prec(type(X,G),cures(X,G,Z)):- auto(cures(X,G,Z)).
effect(cures(X,G,Z),neg(sick(X))) :- auto(cures(X,G,Z)).

auto(kills(X,G,Z)) :- treatment(Z),divGroup(X), variant(G),negImpact(Z,G).
prec(received(X,Z),kills(X,G,Z)) :- auto(kills(X,G,Z)).
prec(alive(X),kills(X,G,Z)) :- auto(kills(X,G,Z)).
prec(type(X,G),kills(X,G,Z)):- auto(kills(X,G,Z)).
effect(kills(X,G,Z),dead(X)) :- auto(kills(X,G,Z)).
effect(kills(X,G,Z),neg(alive(X))) :- auto(kills(X,G,Z)).

auto(transplant(X1,X2)):-divGroup(X1;X2).
prec(dead(X1),transplant(X1,X2)):-auto(transplant(X1,X2)).
prec(received(X1,gamma),transplant(X1,X2)):-auto(transplant(X1,X2)).
prec(sick(X2),transplant(X1,X2)):-auto(transplant(X1,X2)).
prec(received(X2,gamma),transplant(X1,X2)):-auto(transplant(X1,X2)).
prec(alive(X2),transplant(X1,X2)):-auto(transplant(X1,X2)).
effect(transplant(X1,X2),neg(sick(X2))):-auto(transplant(X1,X2)).
effect(transplant(X1,X2),neg(received(X1,gamma))):-auto(transplant(X1,X2)).

%auto(suffers(X))):-divGroup(X).
%prec(alive(X),suffers(X)):-auto(suffers(X)).
%prec(sick(X),suffers(X)):-auto(suffers(X)).
%prec(stage1(X),suffers(X)):-auto(suffers(X)).
%effect(suffers(X),suffering(X)):-auto(suffers(X)).
%effect(suffers(X),neg(stage1(X))):-auto(suffers(X)).
event(E):-act(E).
event(E):-auto(E).

priority(A,U):-act(A),auto(U).
%priority(E,suffers(X)):-event(E).
priority(cures(X,G,Z),transplant(Y,X)):-auto(cures(X,G,Z);transplant(X,Y)).
priority(kills(X,G,Z),transplant(Y,X)):-auto(cures(X,G,Z);transplant(X,Y)).
priority(transplant(Y,X1),transplant(Y,X2)):- X1 < X2, auto(transplant(X1,Y);transplant(X2,Y)).
priority(transplant(Y1,X),transplant(Y2,X)):- Y1 < Y2, auto(transplant(X,Y1);transplant(X,Y2)).

initially(type(1..3,g1)).
initially(type(4..7,g2)).
initially(type(8..12,g3)).
initially(type(13,g6)).
initially(type(14..18,g4)).
initially(type(19..20,g5)).
initially(sick(X)) :- divGroup(X).
initially(alive(X)) :- divGroup(X).

%finally(unchanged(X)) :- holds(s0,sick(X),5), not holds(s0,dead(X),5).
%finally(dead(X)) :- holds(s0,dead(X),5).
%finally(cured(X)) :- holds(s0,alive(X),5), not holds(s0,sick(X),5).

time(0..3).
sim(s0;s1;s2;s3).
%sim(s0;s1;s2;s3).
%1{performs(s0,give(Z),0):treatment(Z)}1.
performs(s0,give(alpha),0).
performs(s1,give(beta),0).
performs(s2,give(gamma),0).
%performs(s3,give(delta),0).


