-module(my_ring).
-export([start/1, start_proc/2]).

start(Max) ->
  start_proc(Max, self()).

% the last spawned process will match this function
start_proc(0, Pid) ->
  Pid ! ok;  %% no more spawn, just send an ok message

start_proc(Num, Pid) ->
  NewPid = spawn(my_ring, start_proc, [Num-1, Pid]),
  NewPid ! ok,
  receive ok -> ok end.


