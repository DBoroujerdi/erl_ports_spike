-module(erl_port_spike).
-behaviour(application).

-export([start/0]).

-export([to_lower/1,
         to_upper/1]).

-export([start/2]).
-export([stop/1]).
-export([priv_dir/0]).

zero_byte(Ch) ->
    Ch =/= 0.

to_lower(Word) ->
    lists:filter(fun zero_byte/1, erl_port_spike_server:send_command({to_lower, Word})).

to_upper(Word) ->
    lists:filter(fun zero_byte/1, erl_port_spike_server:send_command({to_upper, Word})).

start(_Type, _Args) ->
    erl_port_spike_sup:start_link().

stop(_State) ->
    ok.

start() ->
    application:ensure_all_started(?MODULE).

priv_dir() ->
    case code:priv_dir(?MODULE) of
        {error, bad_name} ->
            filename:join(
              [filename:dirname(
                 code:which(?MODULE)), "..", "priv"]);
        A ->
            A
    end.
