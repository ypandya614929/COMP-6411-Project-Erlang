% To run the program follow below commands.
% 1) compile both the files.
%    c(calling).
%    c(exchange).
% 2) run the main method of exchange file.
%    exchange:start().

-module(exchange).
-export([start/0]).
-define(MASTER_WAIT_TIME, 10000).

% main method to start the program
start() ->
	{_, Filedata} = file:consult("calls.txt"),
	io:format("~s.~n",["** Calls to be made **"]),
	startupDisplay(Filedata),
	slaveProcessRegistration(Filedata),
	initiateCommunication().

startupDisplay([]) -> io:format("~s",["\n"]);

% used to display the calling list
startupDisplay([Head|Tail]) ->
	{Sender, ReceiverList} = Head,
	io:format("~w: ~w~n",[Sender, ReceiverList]),
	startupDisplay(Tail).

slaveProcessRegistration([]) -> ok;

% register process for communicating between sender and list of receives
slaveProcessRegistration([Head|Tail]) ->
	{Sender, ReceiverList} = Head,
	SlaveId = spawn(calling, initiateSlaveCommunication, [Sender, ReceiverList, self()]),
	register(Sender, SlaveId),
	slaveProcessRegistration(Tail).

% receive message and print at master side
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

% print goodbye message on master side
goodByeMaster() ->
	io:format("~nMaster has received no replies for ~w seconds, ending....~n",[?MASTER_WAIT_TIME div 1000]).