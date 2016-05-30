-module(tcpclient).
-export([start_client/2, start_client2/3, send/2]).

% tcpclient:start_client({127,0,0,1}, <<"Hello Concurrent World">>).
start_client(Host, Data) ->
  {ok, Socket} = gen_tcp:connect(Host, 1234, [binary, {packet, 0}]),
  send(Socket, Data),
  ok = gen_tcp:close(Socket).
  
% tcpclient:start_client2({127,0,0,1}, 1234, <<"Hello Concurrent World">>).
start_client2(Host, Port, Data) ->
  {ok, Socket} = gen_tcp:connect(Host, Port, [binary, {packet, 0}]),
  send(Socket, Data),
  ok = gen_tcp:close(Socket).
  
send(Socket, <<Chunk:100/binary, Rest/binary>>) ->
  gen_tcp:send(Socket, Chunk),
  send(Socket, Rest);
send(Socket, Rest) ->
  gen_tcp:send(Socket, Rest).
  

