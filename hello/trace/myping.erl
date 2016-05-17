-module(myping).
-export([start/0, ping/1, loop/0]).

start() ->
  spawn_link(myping, loop, []).
  
ping(Pid) ->
  Pid ! {self(), ping},
  receive
    pong -> pong
  end.
  
loop() ->
  receive
    {Pid, ping} ->
	  spawn(crash, does_not_exist_fun, []),
	  Pid ! pong,
	  loop()
  end.

  