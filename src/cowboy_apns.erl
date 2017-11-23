%% Feel free to use, reuse and abuse the code in this file.

-module(cowboy_apns).
-behaviour(gen_server).

%% API.
-export([start/0,
         send/3,
         send/2]).

-export([start_link/1, stop/0]).
%% gen_server callbacks
-export([init/1, terminate/2, handle_call/3,
	 handle_cast/2, handle_info/2, code_change/3]).

-record(state, {opt}).
%% API.

start() ->
    io:format("begin...."),
    application:ensure_all_started(cowboy_apns),
    io:format("begin1....").

send(Device, Alert) ->
    lager:debug("~p Device", [Device]),
    Notification = #{aps => #{alert => Alert, sound => <<"bingbong.aiff">>}},      
    gen_server:cast(?MODULE, {send_message, {Device, Notification}}).

send(Device, Alert, Ext) ->
    lager:debug("~p Device", [Device]),
    Notification = #{aps => #{alert => Alert, sound => <<"bingbong.aiff">>}, extra => #{extra => Ext}},
    gen_server:cast(?MODULE, {send_message, {Device, Notification}}).

start_link(Opts) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, Opts, []).

stop() ->
    gen_server:call(?MODULE, {stop}).
%%====================================================================
%% gen_server callbacks
%%====================================================================
init(_Opts) ->
    apns:connect(cert, cowboy_apns_connection),
    {ok, #state{}}.

handle_call(_Req, _From, State) ->
    {reply, ok, State}.

handle_cast({send_message, {Device, Notification}}, State) -> 
    case apns:push_notification(cowboy_apns_connection, Device, Notification) of
        {timeout, Value} ->
            Result = apns:connect(cert, cowboy_apns_connection),
            lager:error("timeout Value= ~p, Result = ~p", [Value, Result]);
        Result ->
            lager:debug("ResultApns= ~p", [Result])
    end,
    {noreply, State}.

handle_info(_Info, State) -> 
    lager:debug("~p:handle_info ~p _Info=~p", [?MODULE, ?LINE, _Info]),
    {noreply, State}.

code_change(_OldVsn, State, _Extra) -> 
    {ok, State}.

terminate(_Reason, _State) ->
    lager:error("~p:terminate ~p _Reason=~p", [?MODULE, ?LINE, _Reason]),
    ok.
 




