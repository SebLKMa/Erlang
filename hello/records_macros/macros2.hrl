-ifdef(debug).
   -define(DBG(Str, Args), io:format(Str, Args)).
-else.
   -define(DBG(Str, Args), ok).
-endif.

-define(VALUE(CALL), io:format("~p = ~p~n", [??CALL, CALL])).
-define(Multiple(X,Y), X rem Y == 0).


  
