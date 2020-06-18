-module(calling).
%% ====================================================================
%% API functions
%% ====================================================================
-export([initiateSlaveCommunication/3]).
-define(PROCESS_WAIT_TIME, 5000).

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


slaveCommunication(Sender, Receiver) -> 
    {_,_,Timestamp} = erlang:timestamp(),
    Receiver ! {Sender, Timestamp, intro}.


initiateSlaveCommunication(Sender, ReceiverList, MasterID) ->
	
    timer:sleep(rand:uniform(100)),
    [slaveCommunication(Sender, Receiver) || Receiver <- ReceiverList],
	interaction(Sender, MasterID).


goodByeSlave(Sender) ->
    io:format("~nProcess ~w has received no calls for ~w second, ending...~n",[Sender, ?PROCESS_WAIT_TIME div 1000]).
