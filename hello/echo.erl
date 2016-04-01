-module(echo).
-export([go/0,go_reg/0, loop/0]).

go() ->
  Pid = spawn(echo, loop, []),
  Pid ! {self(), bonjour},
  receive
    {Pid, Msg} ->
      io:format("~w says ~w~n",[Pid,Msg])
    end,
  Pid ! stop. %% send stop to Pid

% using register/2 to register pid 
go_reg() ->
  register(echo, spawn(echo, loop, [])),
  echo ! {self(), bonjour},
  receive
    {Pid, Msg} ->
      io:format("~w says ~w~n",[Pid,Msg])
    end.
  % echo ! stop. commenting out sending echo to stop, echo runs indefinitely until you send stop from shell

loop() ->
  receive
    {From, Msg} ->
      io:format("~w says ~w~n",[From,Msg]),
      From ! {self(), Msg},
      loop();
    stop ->
      io:format("~w stopped~n",[self()]),
      true
  end.

