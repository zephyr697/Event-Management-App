public with sharing class EventDetailService {

  @AuraEnabled
  public static List<Event__c> getUpcomingEvents(){ 
    
    List<Event__c> eventList = [SELECT ID,Name,Name__c,Event_Detail__c, Location__c, Location__r.Name,Event_Organizer__r.Name, Event_Organizer__c 
    FROM Event__c
    WHERE Start_DateTime__c >=TODAY AND Live__c = true
    ];
    return eventList;
  }

}
