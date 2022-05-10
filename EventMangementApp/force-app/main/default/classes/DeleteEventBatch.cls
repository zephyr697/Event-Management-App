public class DeleteEventBatch implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'Select Id,Name From Event__c Where Live__c = true AND End_Date_Time__c < LAST_N_MONTHS:2';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<Event__c> eventList){
        if(!eventList.isEmpty()){
            List<Database.DeleteResult> ls = Database.delete(eventList);
      
            for(Database.DeleteResult dr: ls){
                if(!dr.isSuccess()){
                    List<Database.Error> errors = dr.getErrors();
                    String errorString = String.join(errors, ',');
                    TransactionLogHandler.doHandleExceptionWithError(errorString, 'DeleteEventBatch');
                }
            }
        }
    }
    
    public void finish(Database.BatchableContext bc){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            mail.setSubject('Batch Processing Completed');
            List<String> toAddress = new List<String>();
            toAddress.add('maurya.sachin2.sfdc1@gmail.com');
            mail.setToAddresses( toAddress );
        	mail.setSenderDisplayName('DeleteEventBatch');
            mail.setHtmlBody('The DeleteEventBatch has been processed successfully');
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {mail});
    }
    
}