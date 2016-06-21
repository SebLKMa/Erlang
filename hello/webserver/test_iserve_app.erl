-module(test_iserve_app).
-export([do_get/2, do_getHello/2]).
-include("iserve.hrl").
 
do_get(#req{} = Req, Args) ->
    {200, [], <<"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">
<html>
<head>
  <title>Welcome to iserve</title>
</head>
<body>
  Hallo Seb!
</body>
</html>">>}.

do_getHello(#req{} = Req, Args) ->
    {200, [], <<"<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">
<html>
<head>
  <title>Hello world</title>
</head>
<body>
  Guten Tag Seb!
</body>
</html>">>}.


