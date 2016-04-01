-module(exception).
-export([return_error/1,try_return/1]).
-export([try_wildcard/1]).
-export([try_return2/1]).

return_error(X) when X < 0 ->
  throw({'EXIT', {badarith,
    [{exception,return_error,1},
     {erl_eval,do_apply,5},
     {shell,exprs,6},
     {shell,eval_exprs,6},
     {shell,eval_loop,3}]}});
return_error(X) when X == 0 ->
  1/X;
return_error(X) when X > 0 ->
  {'EXIT', {badarith, 
    [{exception,return_error,1},
     {erl_eval,do_apply,5},
     {shell,exprs,6},
     {shell,eval_exprs,6},
     {shell,eval_loop,3}]}}.

% this function returns 3 kinds of behavior depending
% on  argument is positive, negative or zero.
try_return(X) when is_integer(X) ->
  try return_error(X) of
    Val -> {normal, Val}
  catch
    exit:Reason -> {exit, Reason};
    throw:Throw -> {throw, Throw};
    error:Error -> {error, Error}
  end.

try_wildcard(X) when is_integer(X) ->
  try return_error(X)
  catch
    throw:Throw -> {throw, Throw};
    error:_     -> error;         %% could match error:Error, here just return error
    Type:Error  -> {Type, Error};
    _           -> other;         %% will never be returned, ignore Warning
    _:_         -> other          %% will never be returned, ignore Warning
  end.

% catch but return different values
try_return2(X) when is_integer(X) ->
  try return_error(X) of
    Val -> {normal, Val}
  catch
    exit:_  -> 34;
    throw:_ -> 39;
    error:_ -> 678
  end.

