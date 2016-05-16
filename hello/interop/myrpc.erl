-module(myrpc).
-export([f/1,setup/0,server/0,facLoop/0,fac/1]).

%-define(NODENAME, 'bar@users-MacBook-Pro').
-define(NODENAME, 'bar@LMA02').

setup() ->
    spawn(?NODENAME,myrpc,server,[]).

server() ->
    register(facserver,self()),
    facLoop().

facLoop() ->
    receive
	{Pid, N} ->
		io:format("Received ~w ~p.~n",[Pid,N]),
	    Pid ! {ok, fac(N)}
    end,
    facLoop().

f(N) ->
    {facserver, ?NODENAME} ! {self(), N},
    receive
	{ok, Res} ->
	    Val = Res
    end,
    io:format("Factorial of ~p is ~p.~n", [N,Val]).

fac(N) when N==0 ->
    1;
fac(N) ->
    N * fac(N-1).

