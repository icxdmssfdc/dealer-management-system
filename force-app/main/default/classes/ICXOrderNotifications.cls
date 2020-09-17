public class ICXOrderNotifications {
    @InvocableMethod(label='Send Order SMS Notifications' description='Send Order SMS Notifications')
    public static void orderSMSNotification(List<Order> orders)
    {
        String mobileno = '';
        String distributorno = '';
        String message = '';
        String distributorName ='';
        String OrderAccntName ='';
        List <Id> ordAccIds = new List<Id>();
        List <Account> ordAcc = new List<Account>();
        Map <Id,Account> ordAccMap = new Map <Id,Account>();
        List <Id> parOrdAccIds = new List<Id>();
        List <Account> parOrdAcc = new List<Account>();
        Map <Id,Account> parOrdAccMap = new Map <Id,Account>();

        for (Order order : orders){
            ordAccIds.add(order.AccountId);
        }

            //Validating CRUD permission before SOQL/DML operation
        if (Account.SObjectType.getDescribe().isAccessible()) {
                 ordAcc = [Select Name,Phone,ParentId from Account where Id in :ordAccIds];
                 
                 }

            // Defining a Map object to store a key,value pair of child and Parent Accounts and storing Accnt Id and Account objects for all the matched accounts
                 For (Account acc : ordAcc) {
                     ordAccMap.put(acc.Id,acc);
                     if(acc.ParentId != null){
                        parOrdAccIds.add(acc.ParentId);
                     }
              }

            if (Account.SObjectType.getDescribe().isAccessible() && parOrdAccIds.size()>0) {
                parOrdAcc = [Select Name,Phone,ParentId from Account where Id in :parOrdAccIds];
                 }

             For (Account acc : parOrdAcc) {
                parOrdAccMap.put(acc.Id,acc);
             }


        for (Order order : orders){
            String sOrderAccId = order.AccountId;
            
            //Fetching Mobile Number of retailer and Dealer from account for which order is getting placed
            mobileno = ordAccMap.Get(order.AccountId).Phone;        
            OrderAccntName = ordAccMap.Get(order.AccountId).Name;
          /*  if(order.Order_Type__c == 'Retailer'){
                Account parOrdAcc = [Select Phone,ParentId,Order_Type__c,Name from Account where Id =:ordAcc.ParentId];
                distributorno = parOrdAcc.Phone;               
            }*/
            
            if(order.Status == 'Approval Request'){
                //String OrderOwner = order.OwnerId;
               // User usr = [select Phone,Name from User where Id =: OrderOwner];
                //Sending the message to retailer if Order is booked by salesrep
                if(order.Order_Type__c == 'Retailer' ){
                    message = 'SalesRep '+ UserInfo.getName() +' is placed an order behalf of you. We will be updating you the order status shortly.';
                    if(mobileno != null && message != null){
                        ICXTwilioSMSService.send(mobileno, message);
                       
                    }
                    //message = 'SalesRep '+UserInfo.getName() +' is requesting Approval for an Order'+order.OrderNumber+'With order amount: '+order.TotalAmount;                   if(distributorno != null && message != null){
                        //ICXTwilioSMSService.send(distributorno, message);
                      
                    }
                 //Sending the message to dealer if Order is placed by salesrep
                else if(order.Order_Type__c == 'Dealer' && order.Channel__c == 'SalesRep'){
                    message = 'SalesRep '+UserInfo.getName() +' is requesting Approval for an Order'+order.OrderNumber+'With order amount: '+order.TotalAmount;
                    if(mobileno != null && message != null){
                        ICXTwilioSMSService.send(mobileno, message);
                       
                    }
                }else{
                    message = null;
                }
            } 
            else if(order.Status == 'Confirmed' && order.Channel__c == 'SalesRep'){
                //String orderOwner = order.OwnerId;
               // distributorName =  ordAccMap.Get(order.AccountId).Name; 
                //User usr = [select Phone,Name from User where Id =: OrderOwner]; 
               // mobileno = usr.Phone;
                message = 'Hi '+ OrderAccntName +', Your order '+ order.OrderNumber+' order is Confirmed.';
                if(mobileno != null && message != null){
                    ICXTwilioSMSService.send(mobileno, message);
                   
                }
            }
            else if(order.Status == 'Booked'){
                String orderOwner = order.OwnerId;
                
                message = 'Hi '+ OrderAccntName +', Your order '+order.OrderNumber+ ' is booked with amount ' +order.TotalAmount+ '\nEstimated delivery date will be conveyed shortly.';
                if(mobileno != null && message != null){
                    ICXTwilioSMSService.send(mobileno, message);
                    
                }
                
                
            }
            else if(order.Status == 'Out For Delivery'){               
               // message = 'Your order '+order.OrderNumber+' is out for delivery.\nEstimated delivery date is - '+order.icxdms__Estimated_Delivery_Date__c;
                message ='Hi '+ OrderAccntName+', Your order '+order.OrderNumber+' has been Shipped.\nEstimated delivery date is - '+order.Estimated_Delivery_Date__c;
                if(mobileno != null && message != null){
                    ICXTwilioSMSService.send(mobileno, message);
                   
                }		
            }
            else if(order.Status == 'Delivered'){
                message = 'Hi '+ OrderAccntName +',Your Order '+order.OrderNumber+' has been delivered.';
                if(mobileno != null && message != null){
                    ICXTwilioSMSService.send(mobileno, message);
                   
                }		
            }
            else{
                message = null;
            }
        }
    }
}