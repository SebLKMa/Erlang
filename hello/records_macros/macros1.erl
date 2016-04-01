-module(macros1).
-export([tstFun/2, test1/0, test2/1]).

% compile with debug or undebug mode
% c("records_macros/macros1", [{outdir, "records_macros/"}, {d,debug}]).
% c("records_macros/macros1", [{outdir, "records_macros/"}, {u,debug}]).
-ifdef(debug).
   -define(DBG(Str, Args), io:format(Str, Args)).
-else.
   -define(DBG(Str, Args), ok).
-endif.

-define(VALUE(CALL), io:format("~p = ~p~n", [??CALL, CALL])).
-define(Multiple(X,Y), X rem Y == 0).

tstFun(Z,W) when ?Multiple(Z,W) -> true;
tstFun(Z,W)                     -> false.

test1() ->
  ?VALUE(length([1,2,4])).

test2(ListA) ->
  ?DBG("~p:call(~p) called~n", [?MODULE, ListA]),
  ?VALUE(length(ListA)).

  
