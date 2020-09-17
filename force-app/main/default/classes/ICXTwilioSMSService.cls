public class ICXTwilioSMSService {
    @future(callout = true)
	public static void send(String phNumber, String smsBody)
    {
        String accountSid = '';
        string token = '';
        String fromPhNumber = '';  
        
        // Added SID and Token using metadata
        Twillio_Setting__mdt twilliodata =[SELECT accountSid__c,token__c,fromPhNumber__c from Twillio_Setting__mdt where MasterLabel = 'ICXTwilioSMSService'];
        
         accountSid = twilliodata.accountSid__c;
         token = twilliodata.token__c;
         fromPhNumber = twilliodata.fromPhNumber__c;
        
        ErrorResponseWrapper erw;
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.twilio.com/2010-04-01/Accounts/'+accountSid+'/SMS/Messages.json');
        req.setMethod('POST');
        String version  = '3.2.0';
        req.setHeader('X-Twilio-Client', 'salesforce-' + version);
        req.setHeader('User-Agent', 'twilio-salesforce/' + version);
        req.setHeader('Accept', 'application/json');
        req.setHeader('Accept-Charset', 'utf-8');
        req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueOf(accountSid+':' +token)));
        req.setBody('To='+EncodingUtil.urlEncode(phNumber,'UTF-8')+'&From='+EncodingUtil.urlEncode(fromPhNumber,'UTF-8')+'&Body='+smsBody);
        system.debug(req);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        if(res.getStatusCode()==201){
            system.debug('Twilio Success: '+phNumber);
        }
        else{
            system.debug('Twilio failed: '+phNumber);
            erw =(ErrorResponseWrapper)json.deserialize(res.getBody(),ErrorResponseWrapper.class);
            system.debug('Twilio error: '+erw.message);
        }
	}
    public class ErrorResponseWrapper{
        String code;
        String message;
        String moreInfo;
        String status;    
    }
}