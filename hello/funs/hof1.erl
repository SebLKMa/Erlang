%% to compile from root folder, c("funs/hof1", [{outdir, "funs/"}]).
-module(hof1).
-export([evens/1, palins/1, doubleAll/1, palins2/1, palin/1, filter/2]).
-export([printElements/1, sendTo/2, multiply/1, doubleAll2/1, sendListTo/2]).

evens([]) ->
  [];
evens([X|Xs]) ->
  case X rem 2 == 0 of
    true ->
	  [X| evens(Xs)];
	_  ->
	  evens(Xs)
  end.
  
palins([]) ->
  [];
palins([X|Xs]) ->
  case palin(X) of
    true ->
	  [X| palins(Xs)];
	_ ->
	  palins(Xs)
  end.
  
palin(X) -> X == lists:reverse(X).

% using funs
palins2(Xs) ->
  filter(fun(X) -> palin(X) end, Xs).

doubleAll(Xs) ->
  map(fun(X) -> X*2 end, Xs).

printElements(Xs) ->
  foreach(fun(X) -> io:format("Element: ~p~n", [X]) end, Xs).
  
sendTo(Pid, Xs) ->
  foreach(fun(X) -> Pid ! X end, Xs).
  
map(F, []) ->
  [];
map(F, [X|Xs]) ->
  [F(X) | map(F, Xs)].

filter(P,[]) ->
  [];
filter(P, [X|Xs]) ->
  case P(X) of
    true ->
	  [X| filter(P, Xs)];
	_ ->
	  filter(P, Xs)
  end.

foreach(F,[]) ->
  ok;
foreach(F,[X|Xs]) ->
  F(X),
  foreach(F,Xs).
  
% funs as results

multiply(X) ->
  fun (Y) -> X*Y end.

doubleAll2(Xs) ->
  map(multiply(2), Xs).

sendElementTo(Pid) ->
  fun (X) -> Pid ! X end.
  
sendListTo(Pid, Xs) ->
  map(sendElementTo(Pid), Xs).

  





  
 
	
  
