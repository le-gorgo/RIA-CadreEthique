event(E):-act(E).
event(E):-auto(E).

%%%% MOTEUR EVENEMENTIEL %%%%
% Axiomes d'effet
negative(neg(F)) :- effect(E,neg(F)).
initiates(S,E,F,T) :- effect(E,F), occurs(S,E,T), not negative(F).
terminates(S,E,F,T) :- effect(E,neg(F)), occurs(S,E,T), sim(S),time(T).
clipped(S,F,T):-terminates(S,E,F,T).

holds(S,F,0) :- initially(F),sim(S).
holds(S,F,T) :- initiates(S,E,F,T-1),time(T).
holds(S,F,T) :- holds(S,F,T-1), not clipped(S,F,T-1), time(T).
%holds(S,F,T) :- holds(S,F,T-1), not clipped(S,F,T), not nonInertial(F), time(T).

%Axiomes préconditions
incomplete(S,E,T) :- prec(F,E), not holds(S,F,T), sim(S), time(T).
possible(S,E,T) :- not incomplete(S,E,T), sim(S), event(E), time(T).

triggered(S,U,T) :- possible(S,U,T), auto(U).
triggered(S,A,T) :- possible(S,A,T), performs(S,A,T),act(A).

overtaken(S,E1,T) :- triggered(S,E1,T), occurs(S,E2,T), priority(E2,E1).

occurs(S,E,T) :- triggered(S,E,T), not overtaken(S,E,T).

%occurs(S,U,T) :- possible(S,U,T), auto(U).
%occurs(S,A,T) :- possible(S,A,T), performs(S,A,T), act(A).


#show occurs/3.
%#show performs/3.
%#show initiates/4.
%#show terminates/4.
%#show clipped/3.
#show holds/3.
