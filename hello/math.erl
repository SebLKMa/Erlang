-module(math).
-export([add/2]).

add(X,Y) ->
  validate_int(X),
  validate_int(Y),
  X + Y.

validate_int(Int) when is_integer(Int) -> true;
validate_int(Int) -> throw({error, {non_integer, Int}}).

