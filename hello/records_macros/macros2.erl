-module(macros2).
-export([tstFun/2, test1/0, test2/1]).
-include("macros2.hrl").

tstFun(Z,W) when ?Multiple(Z,W) -> true;
tstFun(Z,W)                     -> false.

test1() ->
  ?VALUE(length([1,2,4])).

test2(ListA) ->
  ?DBG("~p:call(~p) called~n", [?MODULE, ListA]),
  ?VALUE(length(ListA)).

  
