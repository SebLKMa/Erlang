C:\erlang\hello\webserver>erl -pa r1.0/ebin -mnesia dir '"r1.0/mnesia"'
Eshell V7.2.1  (abort with ^G)
1> mnesia:start().
ok
2> mnesia:info().
---> Processes holding locks <---
---> Processes waiting for locks <---
---> Participant transactions <---
---> Coordinator transactions <---
---> Uncertain transactions <---
---> Active tables <---
schema         : with 1        records occupying 418      words of mem
===> System info in version "4.13.2", debug level = none <===
opt_disc. Directory "c:/erlang/hello/webserver/r1.0/mnesia" is NOT used
use fallback at restart = false
running db nodes   = [nonode@nohost]
stopped db nodes   = []
master node tables = []
remote             = []
ram_copies         = [schema]
disc_copies        = []
disc_only_copies   = []
[{nonode@nohost,ram_copies}] = [schema]
2 transactions committed, 0 aborted, 0 restarted, 0 logged to disc
0 held locks, 0 in queue; 0 local transactions, 0 remote
0 transactions waits for other nodes: []
ok
3> iserve:create_table([node()]).
{aborted,{bad_type,iserve_callback,disc_copies,
                   nonode@nohost}}
4> mnesia:stop().
stopped
5>
=INFO REPORT==== 13-Jun-2016::14:46:24 ===
    application: mnesia
    exited: stopped
    type: temporary
5> mnesia:create_schema([node()]).
ok
6> mnesia:start().
ok
7> mnesia:info().
---> Processes holding locks <---
---> Processes waiting for locks <---
---> Participant transactions <---
---> Coordinator transactions <---
---> Uncertain transactions <---
---> Active tables <---
schema         : with 1        records occupying 410      words of mem
===> System info in version "4.13.2", debug level = none <===
opt_disc. Directory "c:/erlang/hello/webserver/r1.0/mnesia" is used.
use fallback at restart = false
running db nodes   = [nonode@nohost]
stopped db nodes   = []
master node tables = []
remote             = []
ram_copies         = []
disc_copies        = [schema]
disc_only_copies   = []
[{nonode@nohost,disc_copies}] = [schema]
2 transactions committed, 0 aborted, 0 restarted, 0 logged to disc
0 held locks, 0 in queue; 0 local transactions, 0 remote
0 transactions waits for other nodes: []
ok
8> iserve:create_table([node()]).
{atomic,ok}
9> iserve:add_callback(8081, 'GET', "/", test_iserve_app, do_get).
ok
10>iserve:add_callback(8081, 'GET', "/helloworld.html", test_iserve_app, do_getHello).
ok

11> application:start(iserve).
{error,{not_started,sasl}}
12> application:start(sasl).

=PROGRESS REPORT==== 13-Jun-2016::14:55:36 ===
          supervisor: {local,sasl_safe_sup}
             started: [{pid,<0.125.0>},
                       {id,alarm_handler},
                       {mfargs,{alarm_handler,start_link,[]}},
                       {restart_type,permanent},
                       {shutdown,2000},
                       {child_type,worker}]

=PROGRESS REPORT==== 13-Jun-2016::14:55:36 ===
          supervisor: {local,sasl_safe_sup}
             started: [{pid,<0.126.0>},
                       {id,overload},
                       {mfargs,{overload,start_link,[]}},
                       {restart_type,permanent},
                       {shutdown,2000},
                       {child_type,worker}]

=PROGRESS REPORT==== 13-Jun-2016::14:55:36 ===
          supervisor: {local,sasl_sup}
             started: [{pid,<0.124.0>},
                       {id,sasl_safe_sup},
                       {mfargs,
                           {supervisor,start_link,
                               [{local,sasl_safe_sup},sasl,safe]
                       {restart_type,permanent},
                       {shutdown,infinity},
                       {child_type,supervisor}]

=PROGRESS REPORT==== 13-Jun-2016::14:55:36 ===
          supervisor: {local,sasl_sup}
             started: [{pid,<0.127.0>},
                       {id,release_handler},
                       {mfargs,{release_handler,start_link,[]}},
                       {restart_type,permanent},
                       {shutdown,2000},
                       {child_type,worker}]

=PROGRESS REPORT==== 13-Jun-2016::14:55:36 ===
         application: sasl
          started_at: nonode@nohost
ok

20> code:priv_dir("r1.0").
"r1.0/priv"
21> code:priv_dir(iserve).
{error,bad_name}

26> pwd().
C:/erlang/hello/webserver
ok

>>> change iserve_sup.erl to use code:priv_dir("r1.0")
>>>   case file:consult(filename:join(code:priv_dir("r1.0"), "iserve.conf")) of

27> c(iserve_sup).
{ok,iserve_sup}
28> application:start(iserve).

=PROGRESS REPORT==== 13-Jun-2016::15:11:40 ===
          supervisor: {local,iserve_sup}
             started: [{pid,<0.174.0>},
                       {id,iserve_server},
                       {mfargs,{iserve_server,start_link,[8080]}},
                       {restart_type,permanent},
                       {shutdown,2000},
                       {child_type,worker}]

=INFO REPORT==== 13-Jun-2016::15:11:40 ===
    alarm_handler: {clear,{application_stopped,iserve}}

=PROGRESS REPORT==== 13-Jun-2016::15:11:40 ===
         application: iserve
          started_at: nonode@nohost
ok
29>