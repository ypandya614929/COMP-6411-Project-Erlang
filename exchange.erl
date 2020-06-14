%% Yash Pandya - 40119272

-module(exchange).
%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0, initiateCommunication/0]).
-define(MASTER_WAIT_TIME, 10000).

start() ->
	{_, Filedata} = file:consult("calls.txt"),
	io:format("~s.~n",["** Calls to be made **"]),
	startupDisplay(Filedata),
	slaveProcessRegistration(Filedata),
	initiateCommunication().

startupDisplay([]) -> io:format("~s",["\n"]);

startupDisplay([Head|Tail]) ->
	{Sender, ReceiverList} = Head,
	io:format("~w: ~w~n",[Sender, ReceiverList]),
	startupDisplay(Tail).

slaveProcessRegistration([]) -> ok;

slaveProcessRegistration([Head|Tail]) ->
	{Sender, ReceiverList} = Head,
	SlaveId = spawn(calling, initiateSlaveCommunication, [Sender, ReceiverList, self()]),
	register(Sender, SlaveId),
	slaveProcessRegistration(Tail).

initiateCommunication()->
    receive
    	{Sender, Receiver, Timestamp, intro} ->
            io:fwrite("~w received intro message from ~w [~w]",[Sender, Receiver, Timestamp]),
            io:format("~s",["\n"]),
            initiateCommunication();

	    {Sender, Receiver, Timestamp, reply} ->
            io:fwrite("~w received reply message from ~w [~w]",[Sender, Receiver, Timestamp]),
            io:format("~s",["\n"]),
            initiateCommunication()

    after ?MASTER_WAIT_TIME ->
			goodByeMaster()
			
    end.

goodByeMaster() ->
	io:format("~nMaster has received no replies for ~w seconds, ending....~n",[?MASTER_WAIT_TIME div 1000]).