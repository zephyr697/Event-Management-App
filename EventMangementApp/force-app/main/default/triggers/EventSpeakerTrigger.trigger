trigger EventSpeakerTrigger on EventSpeakers__c (before insert, before update ) {
    
    // Step 1 - Get the speaker id & event id 
    // Step 2 - SOQL on Event to get the Start Date and Put them into a Map
    // Step 3 - SOQL on Event - Spekaer to get the Related Speaker along with the Event Start Date
    // Step 4 - Check the Conditions and throw the Error
    
    //Step-1
    Set<Id> speakerIdSet = new Set<Id>();
    Set<Id> eventIdSet = new Set<Id>();
    
    for(EventSpeakers__c es : Trigger.new){
        speakerIdSet.add(es.Speaker__c);
        eventIdSet.add(es.Event__c);
    }
    
    //Step-2
    List<Event__c> eventsInQueue = [Select Id,Start_DateTime__c From Event__c Where Id in :eventIdSet];
    Map<Id, DateTime> eventsInQueueMap = new Map<Id,DateTime>();
    
    for(Event__c e : eventsInQueue){
        eventsInQueueMap.put(e.ID, e.Start_DateTime__c);
    }
    
    //Step-3
   	List<EventSpeakers__c> esWithSameSpeakers = [Select Id,Event__r.Start_DateTime__c,Speaker__c,Event__c From EventSpeakers__c Where
                                                Speaker__c In :speakerIdSet];
    
    
    //Step-4
    //Check whether the Speakers have an event at same time as the events in Map
    
    for(EventSpeakers__c es : Trigger.new){
        //Time for the new event
        DateTime bookingTime = eventsInQueueMap.get(es.Event__c);
        
        //Check if any event at this time is already scheduled for the same speaker
        
        for(EventSpeakers__c es1 : esWithSameSpeakers){
            if(es.Speaker__c == es1.Speaker__c && bookingTime == es1.Event__r.Start_DateTime__c){
                es.Speaker__c.addError('Speaker is not available at the chosen time. Please modify the Start Date or choose another speaker.');
                es.addError('Speaker is not available at the chosen time. Please modify the Start Date or choose another speaker.');
            }
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}