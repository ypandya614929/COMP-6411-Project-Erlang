%% Yash Pandya - 40119272
-module(calling).
%% ====================================================================
%% API functions
%% ====================================================================
-export([interaction/3, initiateSlaveCommunication/3]).
-define(PROCESS_WAIT_TIME, 5000).

interaction(Sender, ReceiverList, MasterID) ->
   
    receive
            {Receiver, Timestamp, intro} -> 
            	timer:sleep(rand:uniform(100)),
            	MasterID!{Sender, Receiver, Timestamp, intro},
            	Receiver!{Sender, Timestamp, reply},
                interaction(Sender, ReceiverList, MasterID);

            {Receiver, Timestamp, reply} ->  
            	timer:sleep(rand:uniform(100)),
				MasterID!{Sender, Receiver, Timestamp, reply},
                interaction(Sender, ReceiverList, MasterID)
        
    after ?PROCESS_WAIT_TIME ->
            goodByeSlave(Sender)

    end.

createTimestamp() ->
    {_,_,Timestamp} = erlang:timestamp(),
    Timestamp.

initiateSlaveCommunication(Sender, ReceiverList, MasterID) ->
	
    timer:sleep(rand:uniform(100)),
    lists:foreach(fun(Receiver) ->
    	Receiver ! {Sender, createTimestamp(), intro}
	end, ReceiverList),
	interaction(Sender, ReceiverList, MasterID).

goodByeSlave(Sender) ->
    io:format("~nProcess ~w has received no calls for ~w second, ending...~n",[Sender, ?PROCESS_WAIT_TIME div 1000]).
