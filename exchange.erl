-module(exchange).

-export([start/0]).

start() ->
	{_, Filedata} = file:consult("calls.txt"),
	io:format("~s.~n",["*** Calls to be made ***"]),
	startupDisplay(Filedata).
	% io:format("~w",[Filedata]),
	% Communication = maps:from_list(Filedata),
	

startupDisplay([]) -> 
	io:format("~s",["\n"]);

startupDisplay([Head|Tail]) ->
	{Sender, ReceiverList} = Head,
	io:format("~w: ~w~n",[Sender, ReceiverList]),
	startupDisplay(Tail).