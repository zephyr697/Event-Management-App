public class TransactionLogHandler {
	
    public static void doHandleException(System.Exception ex, String processName){
        Error_Log__c log = new Error_Log__c(
        		Log_Details__c = ex.getStackTraceString() + '<br/> <strong> Message : </strong>' + ex.getMessage() +
            					 '<br/> <strong> Possible cause: </strong>' + ex.getCause()+
            					  '<br/>' + ex.getTypeName() + '<br/>' + ex.getLineNumber(),
            	Log_DateTime__c = System.now(),
            	Process_Name__c = processName
        );
        insert log;
    }
    
    public static void doHandleExceptionWithError(String errors, String processName){
        Error_Log__c log = new Error_Log__c(
        		Log_Details__c = errors,
            	Log_DateTime__c = System.now(),
            	Process_Name__c = processName
        );
        insert log;
    }
}