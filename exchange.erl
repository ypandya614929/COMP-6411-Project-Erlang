-module(exchange).

-export([start/0, startupDisplay/1]).

start() ->
	{_, Communication} = file:consult("calls.txt"),
	io:format("~s.~n",["*** Calls to be made ***"]),
	startupDisplay(Communication).
   
startupDisplay(Communication) ->
	lists:map(fun({Sender, ReceiverList}) -> 
		io:format("~w: ~w.~n",[Sender,ReceiverList]) end, Communication),
	io:format("~s",["\n"]).