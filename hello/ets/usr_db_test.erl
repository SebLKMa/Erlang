c(usr_db).
rr("usr.hrl").
usr_db:create_tables("UsrTabFile").
Seq = lists:seq(1,100000).
Add = fun(Id) -> usr_db:add_usr(#usr{msisdn = 700000000 + Id, id = Id, plan = prepay, services = [data, sms, lbs]}) end.
lists:foreach(Add, Seq).
ets:info(usrRam).

% get the record into UsrRec
{ok, UsrRec} = usr_db:lookup_msisdn(700000001).
% update UsrRec record
usr_db:update_usr(UsrRec#usr{services = [data, sms], status = disabled}).

usr_db:lookup_msisdn(700000001).



