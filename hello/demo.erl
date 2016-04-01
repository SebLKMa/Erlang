-module(demo).
-export([double/1]).
-export([factorial/1]).
-export([guardedFactorial/1]).
-export([even/1]).
-export([number/1]).

% This is a comment.
% This is anoher comment.

double(Value) ->
  times(Value, 2).

times(X,Y) ->
  X*Y.

% factorial(-1) will cause infinite recursive calls, crashing the system
factorial(0) -> 1;
factorial(N) ->
  N * factorial(N-1).

% guardedFactorial(-1) will at least throw error immediately
guardedFactorial(N) when N>0 ->
  N * guardedFactorial(N-1);
guardedFactorial(0) -> 1.

even(Int) when Int rem 2 == 0 -> true;
even(Int) when Int rem 2 == 1 -> false.

number(Num) when is_integer(Num) -> integer;
number(Num) when is_float(Num)   -> float;
number(_Other)                   -> false.

