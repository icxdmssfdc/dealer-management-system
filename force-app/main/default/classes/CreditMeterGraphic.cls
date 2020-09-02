public with sharing class CreditMeterGraphic {
    public String currentRecordId {get;set;}
    public Account acc{get;set;}
    public CreditMeterGraphic(ApexPages.StandardController controller){
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        if (Schema.sObjectType.Account.fields.Credit_Limit__c.isAccessible()) {
        acc = [Select Credit_Limit__c From Account Where Id =: currentRecordId];
        }
    }
    public List<gaugeData> getData(){
        double npsscore = 0;
        Account creditusage = [Select Id, Name, Credit_Usage__c, Credit_Limit__c From Account Where Id =: currentRecordId];
        Account creditlimit = [Select Id, Name, Credit_Limit__c From Account LIMIT 1];
       
        List<gaugeData> data = new List<gaugeData>();
        data.add(new gaugeData('Credit', creditusage.Credit_Usage__c));
        data.add(new gaugeData('Credit', creditusage.Credit_Limit__c));
       return data;   
    }
    public class GaugeData{
        public String name{get; set;}
        public decimal credit{get; set;}
        public gaugeData(String name, decimal npsScore){
            this.name = name;
            this.credit = npsScore;
        }
    }
}


