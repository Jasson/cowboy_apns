%% Feel free to use, reuse and abuse the code in this file.

%% @doc Hello world handler.
-module(apns_handler).

-export([init/2]).
-export([content_types_provided/2,
         content_types_accepted/2,
         allowed_methods/2]).
-export([hello_to_html/2]).
-export([hello_to_json/2]).
-export([hello_to_json1/2]).
-export([hello_to_text/2]).

init(Req, Opts) ->
	{cowboy_rest, Req, Opts}.

content_types_accepted(Req, Ctx) ->
    io:format("content_types_accepted:Req = ~p~n ", [Req]),
        {[{'*', hello_to_json1}], Req, Ctx}.
content_types_provided(Req, State) ->
    io:format("Req = ~p~n", [Req]),
    
	{[
	%	{<<"text/html">>, hello_to_html},
		{<<"application/json">>, hello_to_json},
		{<<"text/plain">>, hello_to_text}
	], Req, State}.

allowed_methods(Req, State) ->
        {[<<"GET">>, <<"POST">>], Req, State}.

hello_to_html(Req, State) ->
	Body = <<"<html>
<head>
	<meta charset=\"utf-8\">
	<title>REST Hello World!</title>
</head>
<body>
	<p>REST Hello World as HTML!</p>
</body>
</html>">>,
	{Body, Req, State}.

hello_to_json(Req, State) ->
	Body = <<"{\"rest\": \"Hello World!\"}">>,
	{Body, Req, State}.

hello_to_text(Req, State) ->
	{<<"REST Hello World as text!">>, Req, State}.

hello_to_json1(Req, State) ->
    {ok, Data, _Req0} = cowboy_req:read_body(Req),
    lager:debug("Data = ~p~n", [Data]),
    Echo = <<"{\"code\": \"0\"}">>,
    List = jsx:decode(Data),
    Token = proplists:get_value(<<"token">>, List),
    Alert = proplists:get_value(<<"alert">>, List),
    case proplists:get_value(<<"ext">>, List, <<>>) of
        <<>> ->
            Result = cowboy_apns:send(Token, Alert);
        Ext ->
            Result = cowboy_apns:send(Token, Alert, Ext)
    end,
    lager:debug("ResultApns= ~p", [Result]),
    Req1 = cowboy_req:set_resp_header(<<"Content-Type">>, <<"application/json">>, Req),
    Req2 = cowboy_req:set_resp_body(Data, Req1),
    {true, Req2, State}.
    %cowboy_req:reply(200, #{ <<"content-type">> => <<"application/json; charset=utf-8">> }, Echo, Req). 

