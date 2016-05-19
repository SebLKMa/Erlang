HandlerFun =
  fun({trace, Pid, gc_start, Start}, _) ->
    Start;
    ({trace, Pid, gc_end, End}, Start) ->
    {_, {_,OHS}} = lists:keysearch(old_heap_size, 1, Start),
    {_, {_,OHE}} = lists:keysearch(old_heap_size, 1, End),
    io:format("Old heap size delta after gc:~w~n",[OHS-OHE]),
    {_, {_,HS}} = lists:keysearch(heap_size, 1, Start),
    {_, {_,HE}} = lists:keysearch(heap_size, 1, End),
    io:format("Heap size delta after gc:~w~n",[HS-HE])
  end.