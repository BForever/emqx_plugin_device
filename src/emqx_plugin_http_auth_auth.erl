%% Copyright (c) 2013-2019 EMQ Technologies Co., Ltd. All Rights Reserved.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

-module(emqx_plugin_http_auth_auth).

-behaviour(emqx_auth_mod).

-include_lib("emqx/include/emqx.hrl").

-export([init/1, check/3, description/0]).

init(Opts) ->
  inets:start(),
  io:format("inets started.~n"),
  {ok, Opts}.

check(#{client_id := ClientId, username := Username}, Password, _Opts) ->
  io:format("New connection: clientId=~p, username=~p, password=~p~n",
    [ClientId, Username, Password]),
  {ok, {{Version, States, ReasonPhrase}, Headers, Body}} = httpc:request(string:concat
  ("http://edge_authentication?device=",ClientId)),
  Allowed = string:equal(Body, "{\"success\":true}\n"),
  io:format("Auth server response: ~w:~s~n",[States,Body]),
  if
    Allowed == true ->
      io:format("Access allowed.~n"),
      ok;
    %% Here ignore to enable further verifying of other auth plugins
    Allowed == false ->
      io:format("Access denied.~n"),
      error
  end.

description() -> "Auth Demo Module".
