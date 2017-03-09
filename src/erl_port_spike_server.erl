-module(erl_port_spike_server).

-behaviour(gen_server).

%% API
-export([start_link/0,
         send_command/1]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-define(SERVER, ?MODULE).



%%------------------------------------------------------------------------------
%% API
%%------------------------------------------------------------------------------

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

send_command(Command) ->
    gen_server:call(?SERVER, {command, Command}).

%%------------------------------------------------------------------------------
%% gen_server callbacks
%%------------------------------------------------------------------------------

init([]) ->
    process_flag(trap_exit, true),
    Prog = erl_port_spike:priv_dir() ++ "/erl_port_spike",
    Port = open_port({spawn, Prog}, [{packet, 2}]),
    {ok, #{port => Port}}.

handle_call({command, Command}, _From, #{port := Port} = State) ->
    Port ! {self(), {command, encode(Command)}},
    Result = receive
                 {Port, {data, Data}} -> decode(Data)
             end,
    {reply, Result, State}.

handle_cast(_Msg, State) ->
    {noreplay, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%%------------------------------------------------------------------------------
%% Internal functions
%%------------------------------------------------------------------------------

encode({to_upper, Data}) ->
    [1, Data];
encode({to_lower, Data}) ->
    [2, Data].


decode(Tail) ->
    Tail.
