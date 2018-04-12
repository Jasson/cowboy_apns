%% Feel free to use, reuse and abuse the code in this file.

%% @private
-module(cowboy_apns_app).
-behaviour(application).

%% API.
-export([start/2]).
-export([stop/1]).

%% API.

start(_Type, _Args) ->

	Dispatch = cowboy_router:compile([
		{'_', [
			%%{"/", toppage_handler, []}
			{"/send/apns", apns_handler, []},
			{"/background/send/apns", background_apns_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_clear(http, [{port, 8080}], #{
		env => #{dispatch => Dispatch}
	}),
	cowboy_apns_sup:start_link().

stop(_State) ->
	ok.
