-module(tcpserver).
-export([start_server/0, wait_connect/2, get_request/3]).
-export([start_server2/1]).

start_server() ->
  {ok, ListenSocket} = gen_tcp:listen(1234, [binary, {active, false}]),
  wait_connect(ListenSocket, 0).
  
start_server2(Port) ->
  {ok, ListenSocket} = gen_tcp:listen(Port, [binary, {active, false}]),
  wait_connect2(ListenSocket, 0).
  
wait_connect(ListenSocket, Count) ->
  {ok, Socket} = gen_tcp:accept(ListenSocket),
  spawn(?MODULE, wait_connect, [ListenSocket, Count+1]),
  get_request(Socket, [], Count).
  
wait_connect2(ListenSocket, Count) ->
  {ok, Socket} = gen_tcp:accept(ListenSocket),
  Pid = spawn(?MODULE, get_request, [Socket, [], Count]),
  gen_tcp:controlling_process(Socket, Pid),
  wait_connect2(ListenSocket, Count+1).
  
get_request(Socket, BinaryList, Count) ->
  case gen_tcp:recv(Socket, 0, 5000) of
    {ok, Binary} ->
	  get_request(Socket, [Binary|BinaryList], Count);
	{error, closed} ->
	  handle(lists:reverse(BinaryList), Count)
  end.
  
handle(Binary, Count) ->
  {ok, Fd} = file:open("log_file_"++integer_to_list(Count)++".txt", write),
  file:write(Fd, Binary),
  file:close(Fd).
  

