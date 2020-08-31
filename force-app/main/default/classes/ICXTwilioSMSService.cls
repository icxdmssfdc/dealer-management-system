public class ICXTwilioSMSService {
    @future(callout = true)
	public static void send(String phNumber, String smsBody)
    {
        String accountSid = 'ACf21c3f326ff5c47439fe9bd505fcc83d';
        string token = '33be4a27359b6fd9d034bcd7077b1dd7';
        String fromPhNumber = '+12056773649';
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