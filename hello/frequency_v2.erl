% Chapter 6, page 150
-module(frequency_v2).
% Client functions
-export([start/0, stop/0, allocate/0, deallocate/1]).
% Server function used by spawn/3
-export([init/0]).

%% Client functions
stop()           -> call(stop).
allocate()       -> call(allocate).
deallocate(Freq) -> call({deallocate, Freq}).

%% Hide all message passing and the message protocol
%% in a function interface
call(Message) ->
  frequency ! {request, self(), Message},
  receive
    {reply, Reply} -> Reply
  end.


%% Server functions
%% These are the start functions used to create
%% and initialize the server

% register the process, convention is to use same name as module for alias
start() ->
  register(frequency, spawn(frequency, init, [])).

init() ->
process_flag(trap_exit, true),
  Frequencies = {get_frequencies(), []},
  loop(Frequencies).

%% Internal server functions

% Hard coding frequencies
get_frequencies () -> [10,11,12,13,14,15].

%% The Main Loop
loop(Frequencies) ->
  receive
    {request, Pid, allocate} ->
      {NewFrequencies, Reply} = allocate(Frequencies, Pid),
      reply(Pid, Reply),
      loop(NewFrequencies);
    {request, Pid, {deallocate, Freq}} ->
      NewFrequencies = deallocate(Frequencies, Freq),
      reply(Pid, ok),
      loop(NewFrequencies);
{'EXIT', Pid, _Reason} ->
      NewFrequencies = exited(Frequencies, Pid),
      loop(NewFrequencies);
    {request, Pid, stop} ->
      reply(Pid, ok)
  end.

reply(Pid, Reply) ->
  Pid ! {reply, Reply}.

% allocate and deallocate pattern matched functions
allocate({[], Allocated}, _Pid) ->
  {{[], Allocated}, {error, no_frequency}};
allocate({[Freq|Free], Allocated}, Pid) ->
  link(Pid),
  {{Free, [{Freq, Pid}|Allocated]}, {ok, Freq}}.

deallocate({Free, Allocated}, Freq) ->
  {value, {Freq,Pid}} = lists:keysearch(Freq,1,Allocated),
  unlink(Pid),
  NewAllocated = lists:keydelete(Freq, 1, Allocated),
  {[Freq|Free], NewAllocated}.

exited({Free, Allocated}, Pid) ->
  case lists:keysearch(Pid,2,Allocated) of
    {value, {Freq,Pid}} ->
      NewAllocated = lists:keydelete(Freq,1,Allocated),
      {[Freq|Free], NewAllocated};
    false ->
      {Free, Allocated}
  end.
