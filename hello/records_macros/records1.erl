-module(records1).
-export([test1/0, test2/0, test3/0]).

% definition of record types
-record(namedef, {firstname, lastname}).
-record(person, {name, age=0, phone}).

% function below works with person record type only
incre_birthday(#person{age=Age} = P) ->
  P#person{age=Age+1}.

joe() ->
  #person{name="Joe", age=21, phone="999-999"}.
mike() ->
  #person{name=#namedef{firstname="Mike", lastname="Corleone"}, age=30, phone="333-2222"}.
  
showPerson1(#person{name=Name, age=Age, phone=Phone}) ->
  io:format("name: ~p age: ~p phone: ~p~n", [Name, Age, Phone]).
showPerson2(#person{name=#namedef{firstname=FirstName, lastname=LastName}, age=Age, phone=Phone}) ->
  io:format("name: ~p ~p age: ~p phone: ~p~n", [FirstName, LastName, Age, Phone]).

% test functions
test1() ->
  showPerson1(joe()).
  
test2() ->
  showPerson1(incre_birthday(joe())).
  
test3() ->
  showPerson2(mike()).
  


