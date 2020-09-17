({
    gethProducts: function (cmp, event, helper) {
        var action = cmp.get('c.getProduts'); 
        // method name i.e. getEntity should be same as defined in apex class
        // params name i.e. entityType should be same as defined in getEntity method
       /* action.setParams({
            "PriceBookId" : cmp.get('v.PriceBookId')
        });*/
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                var rows = a.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    row.ProductName = row.Product2.Name;
                    row.Price = row.UnitPrice;
                    row.Quantity = 0;
                }
                cmp.set('v.data', rows);
            }
        });
        $A.enqueueAction(action);
    },

    insertCartItem: function (cmp, event, selectedRows) {
        for(var i=0; i< selectedRows.length; i++){
            var action = cmp.get('c.insertLineItem'); 
            action.setParams({
                "AccountId" : cmp.get('v.accountId'),
                "Product2Id" : selectedRows[i].Product2Id,
                "PriceBookEntryId" : selectedRows[i].Id,
                "ListPrice" : selectedRows[i].UnitPrice,
                "UnitPrice" : selectedRows[i].Price,
                "Quantity" : selectedRows[i].Quantity
            });
            action.setCallback(this, function(a){
                var state = a.getState(); // get the response state
                if(state == 'SUCCESS') {
                    cmp.set('v.SelectedProducts', a.getReturnValue());
                }
            });
            $A.enqueueAction(action);
        }
    },

    clearCartItems: function (cmp, event, helper) {
        var action = cmp.get('c.clearCart'); 
        action.setParams({
            "AccountId" : cmp.get('v.accountId')
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                cmp.set('v.SelectedProducts', a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})