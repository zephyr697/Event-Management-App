@isTest
public class EventSpeakerTriggerTest {
    
    @testSetup static void setup(){
        Event_Organizer__c org = new Event_Organizer__c(Name='Test Organizer',Email__c='a@v.com',Phone__c = '1233445');
        insert org;
        DateTime dt = System.now();
        Event__c evt = new Event__c(Name__c='Test Event',Start_DateTime__c=dt,Max_Seats__c=12,Event_Organizer__c=org.Id,Live__c=true,Event_Type__c='Virtual');
        insert evt;
        Speaker__c speaker = new Speaker__c(Name='Test Speaker',Email__c='a@b.com',Phone__c='123454');
        insert speaker;
        EventSpeakers__c es = new EventSpeakers__c(Event__c=evt.Id,Speaker__c=speaker.Id);
        insert es;
    } 
    
    @isTest
    public static void TestCollision(){
        Event__c evt = [Select Id From Event__c Where Name__c='Test Event'];
        Speaker__c sp = [Select Id From Speaker__c Where Name='Test Speaker'];
        EventSpeakers__c es = new EventSpeakers__c(Event__c=evt.Id,Speaker__c=sp.Id);
        Test.startTest();
        Database.SaveResult res = Database.insert(es,false);
        Test.stopTest();
        System.assertEquals(false, res.isSuccess());
    }
}