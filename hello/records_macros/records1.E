%% this file is created by option 'E' in c("records_macros/records1", [{outdir, "records_macros/"}, 'E']).

-file("records_macros/records1.erl", 1).

incre_birthday({person,_,Age,_} = P) ->
    begin
        rec0 = Age + 1,
        rec1 = P,
        case rec1 of
            {person,_,_,_} ->
                setelement(3, rec1, rec0);
            _ ->
                error({badrecord,person})
        end
    end.

joe() ->
    {person,"Joe",21,"999-999"}.

mike() ->
    {person,{namedef,"Mike","Corleone"},30,"333-2222"}.

showPerson1({person,Name,Age,Phone}) ->
    io:format("name: ~p age: ~p phone: ~p~n", [Name,Age,Phone]).

showPerson2({person,{namedef,FirstName,LastName},Age,Phone}) ->
    io:format("name: ~p ~p age: ~p phone: ~p~n",
              [FirstName,LastName,Age,Phone]).

test1() ->
    showPerson1(joe()).

test2() ->
    showPerson1(incre_birthday(joe())).

test3() ->
    showPerson2(mike()).

module_info() ->
    erlang:get_module_info(records1).

module_info(X) ->
    erlang:get_module_info(records1, X).

