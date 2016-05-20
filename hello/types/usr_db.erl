%%% File: usr_db.erl
%%% Description: Database APIs for subscriber DB

-module(usr_db).
-include("usr.hrl").
-export([create_tables/1, close_tables/0, restore_backup/0]).
-export([add_usr/1, update_usr/1, delete_usr/1,  lookup_id/1, lookup_msisdn/1, delete_disabled_recs/0]).

-spec(create_tables(string()) -> {ok, reference()} | {error, atom()}).
create_tables(FileName) ->
  ets:new(usrRam, [named_table, {keypos, #usr.msisdn}]),
  ets:new(usrIndex, [named_table]),
  dets:open_file(usrDisk, [{file, FileName}, {keypos, #usr.msisdn}]).

close_tables() ->
  ets:delete(usrRam),
  ets:delete(usrIndex),
  dets:close(usrDisk).

add_usr(#usr{msisdn=PhoneNo, id=CustId} = Usr) ->
  ets:insert(usrIndex, {CustId, PhoneNo}),
  update_usr(Usr).

update_usr(Usr) ->
  ets:insert(usrRam, Usr),
  dets:insert(usrDisk, Usr),
  ok.

delete_usr(CustId) ->
  case get_index(CustId) of
    {ok,PhoneNo} ->
      delete_usr(PhoneNo, CustId);
    {error, instance} ->
      {error, instance}
  end.

delete_usr(PhoneNo, CustId) ->
  ets:delete(usrRam, PhoneNo),
  ets:delete(usrIndex, CustId),
  dets:delete(usrDisk, PhoneNo),
  ok.


lookup_id(CustId) ->
  case get_index(CustId) of
    {ok, PhoneNo}	-> lookup_msisdn(PhoneNo);
    {error, instance}	-> {error, instance}
  end.

lookup_msisdn(PhoneNo) ->
  case ets:lookup(usrRam, PhoneNo) of
    [Usr] -> {ok, Usr};
    []    -> {error, instance}
  end.

get_index(CustId) ->
  case ets:lookup(usrIndex, CustId) of
    [{CustId, PhoneNo}] -> {ok, PhoneNo};
    []			-> {error, instance}
  end.

restore_backup() ->
  InsertFun = fun(#usr{msisdn=PhoneNo, id=Id} = Usr) ->
                ets:insert(usrRam, Usr),
                ets:insert(usrIndex, {Id, PhoneNo}),
                continue
              end,
  dets:traverse(usrDisk, InsertFun).

delete_disabled_recs() ->
  ets:safe_fixtable(usrRam, true),
  catch loop_delete_disabled_rec(ets:first(usrRam)),
  ets:safe_fixtable(usrRam, false),
  ok.

loop_delete_disabled_rec('$end_of_table') ->
  ok;
loop_delete_disabled_rec(PhoneNo) ->
  case ets:lookup(usrRam, PhoneNo) of
    [#usr{status=disabled, id = CustId}] ->
      delete_usr(PhoneNo, CustId);
    _ ->
      ok
  end,
  loop_delete_disabled_rec(ets:next(usrRam, PhoneNo)).



