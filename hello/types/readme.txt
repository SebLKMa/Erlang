C:\erlang\hello\types>typer --show usr.erl usr_db.erl
typer: Dialyzer's PLT is missing or is not up-to-date; please (re)create it

C:\erlang\hello\types>dialyzer --build_plt --apps erts kernel stdlib crypto mnesia sasl common_test eunit

dialyzer: {dialyzer_error,"The HOME environment variable needs to be set so that Dialyzer knows where to find the default PLT"}
[{dialyzer_plt,plt_error,1,[{file,"dialyzer_plt.erl"},{line,588}]},
 {dialyzer_options,build,1,[{file,"dialyzer_options.erl"},{line,56}]},
 {dialyzer_cl_parse,cl,1,[{file,"dialyzer_cl_parse.erl"},{line,229}]},
 {dialyzer_cl_parse,start,0,[{file,"dialyzer_cl_parse.erl"},{line,47}]},
 {dialyzer,plain_cl,0,[{file,"dialyzer.erl"},{line,61}]},
 {init,start_it,1,[{file,"init.erl"},{line,1055}]},
 {init,start_em,1,[{file,"init.erl"},{line,1035}]}]


C:\erlang\hello\types>set HOME=C:\erlang\HOME
C:\erlang\hello\types>dialyzer --build_plt --apps erts kernel stdlib crypto mnesia sasl common_test eunit
  Creating PLT c:/erlang/HOME/.dialyzer_plt ...
eunit_test.erl:305: Call to missing or unexported function eunit_test:nonexisting_function/0
Unknown functions:
  compile:file/2
  compile:forms/2
  compile:noenv_forms/2
  compile:output_generated/1
  cover:export/1
  cover:get_main_node/0
  cover:import/1
  cover:start/1
  cover:stop/1
  cover:which_nodes/0
  dbg:p/2
  ...
  

set HOME=C:\erlang\HOME
this is where dialyzer plt is

C:\erlang\hello\types>typer --show usr.erl usr_db.erl

%% File: "usr.erl"
%% ---------------
-spec start() -> 'ok' | {'error','starting'}.
-spec start(_) -> 'ok' | {'error','starting'}.
-spec stop() -> any().
-spec add_usr(_,_,'postpay' | 'prepay') -> any().
-spec delete_usr(_) -> any().
-spec set_service(_,_,boolean()) -> any().
-spec set_status(_,'disabled' | 'enabled') -> any().
-spec delete_disabled_recs() -> any().
-spec lookup_id(_) -> {'error','instance'} | {'ok',tuple()}.
-spec lookup_msisdn(_) -> {'error','instance'} | {'ok',tuple()}.
-spec service_flag(_,_) -> boolean() | {'error','disabled' | 'instance'}.
-spec call('delete_disabled_recs' | 'stop' | {'delete_usr',_} | {'set_status',_,'disabled' | 'enabled'} | {'add_usr',_,_,'postpay' |
-spec reply({atom() | pid() | port() | {atom(),atom()},_},'ok' | {'error',_}) -> {'reply',_,'ok' | {'error',_}}.
-spec init(atom() | [atom() | [any()] | char()] | non_neg_integer(),atom() | pid() | port() | {atom(),atom()}) -> {'reply',_,'ok' |
-spec loop() -> {'reply',_,'ok' | {'error',_}}.
-spec request('delete_disabled_recs' | {'delete_usr',_} | {'set_status',_,_} | {'add_usr',_,_,_} | {'set_service',_,_,_}) -> 'ok' |

%% File: "usr_db.erl"
%% ------------------
-spec create_tables(atom() | [atom() | [any()] | char()] | non_neg_integer()) -> {'error',_} | {'ok',_}.
-spec close_tables() -> 'ok' | {'error',_}.
-spec add_usr(#usr{}) -> 'ok'.
-spec update_usr([tuple()] | tuple()) -> 'ok'.
-spec delete_usr(_) -> 'ok' | {'error','instance'}.
-spec delete_usr(_,_) -> 'ok'.
-spec lookup_id(_) -> {'error','instance'} | {'ok',tuple()}.
-spec lookup_msisdn(_) -> {'error','instance'} | {'ok',tuple()}.
-spec get_index(_) -> {'error','instance'} | {'ok',_}.
-spec restore_backup() -> any().
-spec delete_disabled_recs() -> 'ok'.
-spec loop_delete_disabled_rec(_) -> 'ok'.

C:\erlang\hello\types>
