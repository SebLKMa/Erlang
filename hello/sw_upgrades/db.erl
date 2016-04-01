% compile from root folder
% c("sw_upgrades/db", [{outdir, "sw_upgrades/"}]).
-module(db).
-export([new/0, write/3, read/2, delete/2, destroy/1]).
%-vsn(1.0).
-vsn(1.1).

new() -> dict:new().

write(Key, Data, Db) -> dict:store(Key, Data, Db).

read(Key, Db) ->
  %vsn 1.1 fix, use find instead of fetch
  %case dict:fetch(Key, Db) of
  case dict:find(Key, Db) of
    error      -> {error, instance};
	{ok, Data} -> {ok, Data}
  end.

delete(Key, Db) -> dict:erase(Key, Db).

destroy(_Db) -> ok.

