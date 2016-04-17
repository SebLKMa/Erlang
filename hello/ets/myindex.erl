%% to compile from root folder, c("ets/myindex", [{outdir, "ets/"}]).
-module(myindex).
-export([processFile/2,test1/0,test2/0,accumulate/1]).
-define(Punctuation,"(\\ |\\,|\\.|\\;|\\:|\\t|\\n|\\(|\\))+").

processFile(File,Table) ->
    {ok,IoDevice} = file:open(File,[read]),
    processLines(IoDevice,Table,1).

processLines(IoDevice,Table,N) ->
    case io:get_line(IoDevice,"") of
	eof ->
	    ok;
	Line -> 
	    processLine(Line,Table,N),
	    processLines(IoDevice,Table,N+1)
    end.

processLine(Line,Table,N) ->
    case re:split(Line,?Punctuation) of
	{ok,Words} ->
	    processWords(Words,Table,N) ;
	_ -> []
    end.

processWords(Words,Table,N) ->
    case Words of
	[] -> ok;
	[Word|Rest] ->
	    if length(Word) > 3 ->
		    Normalise = Word, %string:to_lower(Word),
		    ets:insert(Table,{{ Normalise , N}});
	       true -> ok
	    end,
	    processWords(Rest,Table,N)
    end.



index(File) ->
  ets:new(indexTable, [order_set, named_table]),
  processFile(File),
  prettyIndex().

processFile(File) ->
  {ok,IoDevice} = file:open(File,[read]),
  processLines(IoDevice,1).

processLines(IoDevice,N) ->
  case io:get_line(IoDevice,"") of
    eof ->
      ok;
    Line ->
      processLine(Line,N),
      processLines(IoDevice,N+1)
  end.

processLine(Line,N) ->
  case re:split(Line,?Punctuation) of
    {ok,Words} ->
      processWords(Words,N);
    _ -> []
  end.

processWords(Words,N) ->
  case Words of
    [] -> ok;
    [Word|Rest] ->
      if 
        length(Word) > 3 ->
          Normalise = string:to_lower(Word),
          ets:insert(indexTable,{{Normalise,N}});
        true -> ok
      end,
      processWords(Rest,N)
  end.

prettyIndex() ->
  case ets:first(indexTable) of 
    '$end_of_table' ->
      ok;
    First ->
      case First of
        {Word,N} ->
          IndexEntry = {Word,[N]}
        end,
        prettyIndexNext(First,IndexEntry)
    end.

prettyIndexNext(Entry,{Word, Lines}=IndexEntry) ->
  Next = ets:next(indexTable,Entry),
  case Next of
    '$end_of_table' ->
      prettyEntry(IndexEntry);
    {NextWord, M} ->
      if
        NextWord == Word ->
          prettyIndexNext(Next, {Word, [M|Lines]});
        true ->
          prettyEntry(IndexEntry),
          prettyIndexNext(Next,{NextWord, [M]})
      end
  end.

prettyEntry({Word, Lines}) ->    
  io:put_chars(pad(15,Word)),
  prettyList(accumulate(Lines)).       
 
pad(N,Word) ->
    Len = length(Word),
    if 
	Len>=N ->
	    Word;
	true ->
	    Word ++ replicate(N-Len, " ")
    end.

replicate(0,_) ->
     [];
replicate(N,X) ->
    X ++ replicate(N-1,X).

prettyList([]) ->
    ok;
prettyList([{N}]) ->
    io:format("~p.~n",[N]);
prettyList([{N,M}]) ->
    io:format("~p-~p.~n",[N,M]);
prettyList([{N}|Ns]) ->
    io:format("~p,",[N]),
    prettyList(Ns);
prettyList([{N,M}|Ns]) ->
    io:format("~p-~p,",[N,M]),
    prettyList(Ns).

accumulate(Ns) ->
    accumulate(Ns,[]).

accumulate([],L) -> L;
accumulate([N|Ns],[]) ->
    accumulate(Ns,[{N}]);
accumulate([N|Ns],[{P}|Rest]=Ms) ->
    if
	N==P ->
	    accumulate(Ns,[{P}|Rest]);
	N+1==P ->
	    accumulate(Ns,[{N,P}|Rest]);
	true ->
	    accumulate(Ns,[{N}|Ms])
    end;
accumulate([N|Ns],[{P,Q}|Rest]=Ms) ->
    if
	N==P ->
	    accumulate(Ns,[{P,Q}|Rest]);
	N+1==P ->
	    accumulate(Ns,[{N,Q}|Rest]);
	true ->
	    accumulate(Ns,[{N}|Ms])
    end.    

% test code

test1() ->
    TabId = ets:new(myTable, [set,{keypos,2}]),
    processFile("Text.txt",TabId),
    First = ets:first(TabId),
    io:format("First element is: ~p~n",[First]),
    Next = ets:next(TabId,First),
    io:format("The next element is: ~p~n",[Next]),
    NextBut1 = ets:next(TabId,Next),
    io:format("And the next but one is: ~p~n",[NextBut1]),
    ets:tab2list(TabId),
    ets:info(TabId).
    
test2() ->
    index("Short.txt").


