({
    gethCheckInventory: function (cmp, event, helper) {
        var action = cmp.get('c.getOrderInventory'); 
        action.setParams({
            "sOrderId" : cmp.get('v.recordId')
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                //cmp.set('v.data', a.getReturnValue());
                
                var records = a.getReturnValue();
                // iterate each records with forEach loop
                records.forEach(function(record){ 
                    if(typeof record.lineItemId != 'undefined'){ 
                        if(record.onHandQty >= record.orderQty){
                            record.showClass = 'blackcolor';
                            //record.Orderable = true;
                            record.displayIconName = 'utility:check';  
                        }
                        else{
                            //record.Orderable = false;
                            record.showClass = 'redcolor';
                            record.displayIconName = 'utility:close';     
                        }
                    }
                });
                // after the loop set the updated account records on "accountList" aura attribute
                cmp.set("v.data", records);

            }else{
                console.log('Error Message', a.getError());
            }
        });
        $A.enqueueAction(action);
    }
})