-module(recursion).
-export([factorial/1]).
-export([guardedFactorial/1]).
-export([bump/1]).
-export([average/1]).
-export([even/1]).
-export([is_member/2]).

% This is a comment.
% This is anoher comment.

% factorial(-1) will cause infinite recursive calls, crashing the system
factorial(0) -> 1;
factorial(N) ->
  N * factorial(N-1).

% guardedFactorial(-1) will at least throw error immediately
guardedFactorial(N) when N>0 ->
  N * guardedFactorial(N-1);
guardedFactorial(0) -> 1.

% add 1 to all elements in a list
bump([]) -> [];
bump([Head | Tail]) -> [Head + 1 | bump(Tail)].

% returns sum the elements in a list
sum([]) -> 0;
sum([Head|Tail]) -> Head + sum(Tail).

% returns the length of a list
len([]) -> 0;
len([_|Tail]) -> 1 + len(Tail).

% returns the average of a list
average([]) -> 0;
average(List) -> sum(List) / len(List).

% given a list, filter and return a new list with even numbers only
% [10,11,12] is taken as list if ascii chars in erlang unless at least 1 element is a real number
% e.g. [10,11,12,0] or [10,11,12,2]
even([]) -> [];
even([Head | Tail]) when Head rem 2 == 0 -> [Head | even(Tail)];
even([_ | Tail]) -> even(Tail).

% checks if argument is a member of a list.
% e.g. is_member(pomerol, [hautmedoc, pessacleognan, pomerol, margaux, stjulien]).
% e.g. is_member(cahors, [hautmedoc, pessacleognan, pomerol, margaux, stjulien]).
is_member(_,[]) -> false;
is_member(H, [H | _]) -> true;
is_member(H, [_ | T]) -> is_member(H, T).






