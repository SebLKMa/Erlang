-module(my_timer).
-export([send_after/2, send_after/3,  sleep/1, send/3]).

% spawns a process to send msg to self after Delay
send_after(Delay, Msg) ->
  spawn(my_timer, send, [self(), Delay, Msg]).

% spawns a process to send msg to a Pid after Delay
send_after(Pid, Delay, Msg) ->
  spawn(my_timer, send, [Pid, Delay, Msg]).

send(Pid, Delay, Msg) ->
  receive
  after Delay ->
    Pid ! Msg
  end.

% this is similar to sleep/1 from timer module
sleep(T) ->
  receive
  after T ->
    true
  end.

