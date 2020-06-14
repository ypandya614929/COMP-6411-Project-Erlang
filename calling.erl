-module(calling).
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
		io:format("~nProcess ~w has received no calls for ~w second, ending...~n",[Sender, ?PROCESS_WAIT_TIME div 1000])

    end.

initiateSlaveCommunication(Sender, ReceiverList, MasterID) ->
	
    timer:sleep(rand:uniform(100)),
    lists:foreach(fun(Receiver) ->
    	{_,_, Timestamp} = erlang:timestamp(),
    	Receiver ! {Sender, Timestamp, intro}
	end, ReceiverList),
	interaction(Sender, ReceiverList, MasterID).
