public class LocationTriggerHandler {

    @future(callout=true)
    public static void verifyAddress(String recordId){
        Location__c loc = [Select Id,Name,Verified__c,Street__c,City__c,Postal_Code__c, State__c
                          From Location__c Where Id=: recordId];
//       "https://us-street.api.smartystreets.com/street-address?auth-id=6e715038-70db-64c9-ae06-a4ad27a620ae&auth-token=2maqQaEDw3AT0V0XBADU&candidates=10
//       &street=&city=&state=&zipcode=&match=enhanced&license=us-rooftop-geocoding-cloud" 
        String baseUrl = 'https://us-street.api.smartystreets.com/street-address?auth-id=6e715038-70db-64c9-ae06-a4ad27a620ae&auth-token=2maqQaEDw3AT0V0XBADU&candidates=10';
        String url = baseUrl
            		 +'&street='+EncodingUtil.urlEncode(loc.Street__c, 'UTF-8')
            		 + '&city='+EncodingUtil.urlEncode(loc.City__c, 'UTF-8')
             		 + '&state='+EncodingUtil.urlEncode(loc.State__c, 'UTF-8')
                     + '&zipcode='+EncodingUtil.urlEncode(loc.Postal_Code__c, 'UTF-8')
                     + '&match=enhanced&license=us-rooftop-geocoding-cloud%2Cus-core-cloud';
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(url);
        //req.setHeader('Content-Type', 'application/json');
        Http http = new Http();
        
        HttpResponse res = new HttpResponse();
        
        try{
            res = http.send(req);
            System.debug('ResponseBody '+ res.getBody());
            System.debug('Url: '+url);
            if(res.getStatusCode() == 200 && res.getStatus()=='OK'){
                String resBody = res.getBody();
                if(!String.isBlank(resBody) && resBody.length()>2){
                    loc.Verified__c = true;
                }else{
                    loc.Verified__c = false;
                }
                update loc;
            }else{
                TransactionLogHandler.doHandleExceptionWithError(res.getBody(), 'LocationTriggerHandler');
            }
        	    
        }catch(System.CalloutException ex){
            System.debug('An exception occured '+ ex.getStackTraceString());
            TransactionLogHandler.doHandleException(ex, 'LocationTriggerHandler');
        }    
    }
}