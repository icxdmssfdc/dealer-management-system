/*
* Author:- Vaishnavi Gajawada
* Created:- 25082020
* Last Updated:- 
* Feature:- 
* Description:- Converting leads to users
*/
Public class AutoConvertLeads
{
  /*  private final Lead lead;
    public AutoConvertLeads(ApexPages.StandardController stdController){
        this.lead=(Lead)stdController.getRecord();
        System.debug('This is lead id');
        System.debug(lead.Id);
        //ID lid=lead.Id;
    }
    public PageReference LeadToAccount()//Id leadid)//I brought lead from lead obj(00Q2v00001ggujZEAQ)muraliraj name//0052v00000fdSY8AAM
    {
        ID leadid1=lead.id;
        Lead LeadInfo =[SELECT Id,Name, Company, RecordTypeId FROM Lead WHERE Id=: leadid1];//retrieves lead id
		
        LeadStatus CLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true];//closed-converted
		
        List<Database.LeadConvert> Leadconvert = new List<Database.LeadConvert>();
		//Retrieve PartnerLead Recordtype Id
		Id accRTIdPartLd = Schema.SObjectType.Lead.getRecordTypeInfosByName().get(ParterLead).getRecordTypeId();

        RecordType leadtype = [SELECT Id,Name FROM RecordType WHERE Id=:accRTIdPartLd];
		//Retrieve Account Dealer Recordtype Id
		Id accRTIdDist = Schema.SObjectType.Lead.getRecordTypeInfosByName().get(Dealer).getRecordTypeId();                                                                                

        RecordType AccountTypeId = [SELECT Id FROM RecordType WHERE Id=:accRTIdDist];
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile DMSPartnerProfileId = [Select Id from Profile where name = 'DMS - Partner Login'];
        Profile SystemAdminId = [Select Id from Profile where name = 'System Administrator'];
        User Managerid=[SELECT Id FROM User WHERE ProfileId=: SystemAdminId.id];
        if(Leadinfo.RecordTypeId == leadtype.Id)
        {
            Database.LeadConvert lc = new Database.LeadConvert();
            Account acct = new account();
            Contact c=new Contact();
            acct.Name = Leadinfo.Company;
            acct.RecordTypeId=AccountTypeId.Id;//'0122v000002AYR0AAO';
            c.AccountId=acct.Id;
            Leadinfo.Status='Closed-Converted';
            lc.setLeadId(leadid1);
            lc.setConvertedStatus(CLeadStatus.MasterLabel);
            lc.setDoNotCreateOpportunity(TRUE); //Remove this line if you want to create an opportunity from Lead Conversion            
            Leadconvert.add(lc);                       
        }
        if (!Leadconvert.isEmpty()) 
        {
            List<Database.LeadConvertResult> lcr = Database.convertLead(Leadconvert);
            //boolean isSuccessful = lcr. isSuccess();
            for(Database.LeadConvertResult lctemp:lcr)
            {   ID acid=lctemp.getAccountId();
                system.debug(lctemp.getAccountId());
                system.debug(lctemp.getContactId());
                 
             }
        }
        Lead convertedid=[SELECT id,IsConverted,Company,Status,Name,convertedAccountId FROM Lead WHERE id=: lead.id];
        if(convertedid.IsConverted==True){
        String AccountName=convertedid.Company;
        Account accountvals=[SELECT id,IsPartner,Primary_Contact__c  FROM Account WHERE Name =: AccountName];//SELECT id, Name, IsPartner FROM Account WHERE Id=: lead.ConvertedAccountId];// ConvertedAcctId];
        String ContactName=convertedid.Name;
        Contact contactvals=[SELECT id,Name,FirstName,LastName,Email FROM Contact WHERE Name=: ContactName];
        accountvals.Primary_Contact__c=contactvals.id;
        accountvals.IsPartner=true;
        update accountvals;
        List<Messaging.SingleEmailMessage> setPWs = new List<Messaging.SingleEmailMessage>();
        User u=new User();
            u.FirstName = contactvals.FirstName;
            u.LastName = contactvals.LastName;
            u.Email=contactvals.Email;
            u.Username=System.now().millisecond() + u.FirstName + '@amruthanjan.com';//'contactvals.Name'+'@'+'amruthanjan'+'.'+'com';
            u.CommunityNickname=contactvals.FirstName+contactvals.LastName+'nick';            
            u.ProfileId = DMSPartnerProfileId.Id;
            u.IsActive=true;
            u.ContactId=contactvals.Id;
            u.Alias = contactvals.LastName;
            u.TimeZoneSidKey='Asia/Kolkata';
            u.LocaleSidKey = 'en_US'; // Required
            u.EmailEncodingKey = 'ISO-8859-1'; // Required
            u.LanguageLocaleKey = 'en_US';
            u.EmailPreferencesStayInTouchReminder=True;
            u.ManagerId=Managerid.Id;
            insert u;
            System.debug('user values are'+u);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            //Set email address

            String[] toAddresses = new String[] {contactvals.Email};

            mail.setToAddresses(toAddresses);

            mail.setSubject('Subject - User Creation');

            mail.setPlainTextBody('User has been cretaed!');


            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {mail};//setPW}; 
            String body = ' Sample Body to test email is sending or not '; 
            //setPWs.setPlainTextBody(body);

            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if (results[0].success) {
            System.debug('The email was sent successfully.');
            } else {
            System.debug('The email failed to send: '+ results[0].errors[0].message);          
             }        
        }        
        String sServerName = ApexPages.currentPage().getHeaders().get('Host');
        sServerName = 'https://'+sServerName+'/';
        PageReference retPage = new PageReference(sServerName+convertedid.convertedAccountId); 
        retPage.setRedirect(true);

        return retPage;
    }
          */     
}