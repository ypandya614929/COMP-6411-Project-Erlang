% To run the program follow below commands.
% 1) compile both the files.
%    c(calling).
%    c(exchange).
% 2) run the main method of exchange file.
%    exchange:start().

-module(calling).
-export([initiateSlaveCommunication/3]).
-define(PROCESS_WAIT_TIME, 5000).

% communication between master and slave using message passing
interaction(Sender, MasterID) ->
   
    receive
        {Receiver, Timestamp, intro} -> 
        	timer:sleep(rand:uniform(100)),
        	MasterID!{Sender, Receiver, Timestamp, intro},
        	Receiver!{Sender, Timestamp, reply},
            interaction(Sender, MasterID);

        {Receiver, Timestamp, reply} ->  
        	timer:sleep(rand:uniform(100)),
			MasterID!{Sender, Receiver, Timestamp, reply},
            interaction(Sender, MasterID)
        
    after ?PROCESS_WAIT_TIME ->
            goodByeSlave(Sender)

    end.

% generate timestamp and send the intro message
slaveCommunication(Sender, Receiver) -> 
    {_,_,Timestamp} = erlang:timestamp(),
    Receiver ! {Sender, Timestamp, intro}.

% send message to each slave (receivers) from the receiverlist
initiateSlaveCommunication(Sender, ReceiverList, MasterID) ->
	
    timer:sleep(rand:uniform(100)),
    [slaveCommunication(Sender, Receiver) || Receiver <- ReceiverList],
	interaction(Sender, MasterID).

% print goodbye message on slave side
goodByeSlave(Sender) ->
    io:format("~nProcess ~w has received no calls for ~w second, ending...~n",[Sender, ?PROCESS_WAIT_TIME div 1000]).
