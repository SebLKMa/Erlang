%%% File: usr.erl
%%% Description: APIs and codes using Mnesia for cellphone user db
%%%              All process related calls are removed - start, spawn, init, stop, gen_server
-module(usr).
%-export([start_link/0, start_link/1, stop/0]).
%-export([init/1, terminate/2, handle_call/3, handle_cast/2]).
-export([add_usr/3, delete_usr/1, set_service/3, set_status/2, 
        delete_disabled_recs/0, lookup_id/1]).
-export([lookup_msisdn/1, service_flag/2]).
%-behavior(gen_server).
-export([create_tables/0, ensure_loaded/0]).

-include("usr.hrl").

%% Mnesia API

create_tables() ->
  mnesia:create_table(usr, [{disc_copies, [node()]}, {ram_copies, nodes()}, {type, set}, {attributes, record_info(fields, usr)}, {index, [id]}]).

ensure_loaded() ->
  mnesia:wait_for_tables([usr], 60000).

%% Exported Client Functions
%% Operation & Maintenance APIs

%% Customer Service APIs

add_usr(PhoneNum, CustId, Plan) when Plan==prepay; Plan==postpay ->
%  gen_server:call(?MODULE, {add_usr, PhoneNum, CustId, Plan}).
  Rec = #usr{msisdn=PhoneNum, id=CustId, status=enabled, plan=Plan},
  Fun = fun() -> mnesia:write(Rec) end,
  {atomic, Res} = mnesia:transaction(Fun),
  Res.

delete_usr(CustId) ->
%  gen_server:call(?MODULE, {delete_usr, CustId}).
  F = fun() -> case mnesia:index_read(usr, CustId, id) of
                 [] -> {error, instance};
                 [Usr] -> mnesia:delete({usr, Usr#usr.msisdn})
               end
      end,
  {atomic, Result} = mnesia:transaction(F),
  Result.

set_service(CustId, Service, Flag) when Flag==true; Flag==false ->
%  gen_server:call(?MODULE, {set_service, CustId, Service, Flag}).
  F = fun() -> 
        case mnesia:index_read(usr, CustId, id) of
          [] -> {error, instance};
          [Usr] ->
            Services = lists:delete(Service, Usr#usr.services),
            NewServices = case Flag of
                            true -> [Service|Services];
                            false -> Services
                          end,
            mnesia:write(Usr#usr{services=NewServices})
        end
      end,
  {atomic, Result} = mnesia:transaction(F),
  Result.
     
set_status(CustId, Status) when Status==enabled; Status==disabled ->
%  gen_server:call(?MODULE, {set_status, CustId, Status}).
  F = fun() -> 
        case mnesia:index_read(usr, CustId, id) of
          [] -> {error, instance};
          [Usr] -> mnesia:write(Usr#usr{status=Status})
        end
      end,
  {atomic, Result} = mnesia:transaction(F),
  Result.


delete_disabled_recs() ->
%  gen_server:call(?MODULE, delete_disabled_recs).
  F = fun() -> 
    FoldFun = fun(#usr{status=disabled, msisdn=PhoneNo},_) ->
                    mnesia:delete({usr,PhoneNo});
                 (_,_) ->
                    ok
              end,
    mnesia:foldl(FoldFun, ok, usr)
  end,
  {atomic, ok} = mnesia:transaction(F),
  ok.

lookup_id(CustId) ->
%  usr_db:lookup_id(CustId).
  case mnesia:dirty_index_read(usr, CustId, id) of
    [Usr] -> {ok, Usr};
    []    -> {error, instance}
  end.

%% Service APIs

lookup_msisdn(PhoneNo) ->
%  usr_db:lookup_msisdn(PhoneNo).
  case mnesia:dirty_read({usr, PhoneNo}) of
    [Usr] -> {ok, Usr};
    []    -> {error, instance}
  end.

service_flag(PhoneNo, Service) ->
%  case usr_db:lookup_msisdn(PhoneNo) of
  case lookup_msisdn(PhoneNo) of
    {ok, #usr{services=Services, status=enabled}} ->
      lists:member(Service, Services);
    {ok, #usr{status=disabled}} ->
      {error, disabled};
      {error, Reason} -> {error, Reason}
    end.

%% Callback Functions

init(FileName) ->
  usr_db:create_tables(FileName),
  usr_db:restore_backup(),
  {ok, null}.

terminate(_Reason, _LoopData) ->
  usr_db:close_tables().

handle_cast(stop, LoopData) ->
  {stop, normal, LoopData}.

% Previous Handling Client Requests, pattern match functions based on incoming arguments
%request({add_usr, PhoneNo, CustId, Plan}) -> 
%  usr_db:add_usr(#usr{msisdn=PhoneNo, id=CustId, plan=Plan});
handle_call({add_usr, PhoneNo, CustId, Plan}, _From, LoopData) ->
  Reply = usr_db:add_usr(#usr{msisdn=PhoneNo, id=CustId, plan=Plan}),
  {reply, Reply, LoopData};

%request({delete_usr, CustId}) ->
%  usr_db:delete_usr(CustId);
handle_call({delete_usr, CustId}, _From, LoopData) ->
  Reply = usr_db:delete_usr(CustId),
  {reply, Reply, LoopData};

%request({set_service, CustId, Service, Flag}) ->
%  case usr_db:lookup_id(CustId) of
handle_call({set_service, CustId, Service, Flag}, _From, LoopData) ->
  Reply = case usr_db:lookup_id(CustId) of
    {ok, Usr} ->
      Services = lists:delete(Service, Usr#usr.services),
      NewServices = case Flag of
        true -> [Service|Services];
        false -> Services
        end,
      usr_db:update_usr(Usr#usr{services=NewServices});
    {error, instance} ->
      {error, instance}
  end,
  {reply, Reply, LoopData};

%request({set_status, CustId, Status}) ->
%  case usr_db:lookup_id(CustId) of
handle_call({set_status, CustId, Status}, _From, LoopData) ->
  Reply = case usr_db:lookup_id(CustId) of
    {ok, Usr} ->
      usr_db:update_usr(Usr#usr{status=Status});
    {error, instance} ->
      {error, instance}
  end,
  {reply, Reply, LoopData};

%request(delete_disabled_recs) ->
%  usr_db:delete_disabled_recs().
handle_call(delete_disabled_recs, _From, LoopData) ->
  {reply, usr_db:delete_disabled_recs(), LoopData}.
	
%% Messaging Functions
%call(Request) ->
% Ref = make_ref(),
%  ?MODULE! {request, {self(), Ref}, Request},
%  receive
%    {reply, Ref, Reply} -> Reply
%  after
%    ?TIMEOUT -> {error, timeout}
%  end.

%reply({From, Ref}, Reply) ->
%  From ! {reply, Ref, Reply}.

%% Internal Server Fucntions
%init(FileName, Pid) ->
%  usr_db:create_tables(FileName),
%  usr_db:restore_backup(),
%  Pid ! started,
%  loop().

%loop() ->
%  receive
%    {request, From, stop} ->
%      reply(From, usr_db:close_tables());
%    {request, From, Request} ->
%      Reply = request(Request),
%      reply(From, Reply),
%      loop()
%  end.
