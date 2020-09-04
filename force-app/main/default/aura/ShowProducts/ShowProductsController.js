({
    init: function (cmp, event, helper) {
        cmp.set('v.columns', [
            {label: 'Product', fieldName: 'ProductName', type: 'text', initialWidth: 250, wrapText: true},
            {label: 'Qty', fieldName: 'Quantity', type: 'numeric', editable: true, initialWidth: 80, wrapText: true}
        ]);
        helper.gethProducts(cmp, event, helper);
    },

    updateSelectedText: function (cmp, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        helper.clearCartItems(cmp, event, helper);
        helper.insertCartItem(cmp, event, selectedRows);
    },

    saveEdition : function (cmp, event, helper) {
        var draftValues = event.getParam('draftValues');
        var selectedRows = event.getParam('selectedRows');
        console.log(draftValues);
        var products = cmp.get('v.data');
        for(var i=0; i<draftValues.length; i++){
            var id = draftValues[i].id.split('-')[1];
            if(draftValues[i].Price !== undefined){
                products[id].Price = draftValues[i].Price;
            }
            if(draftValues[i].Quantity !== undefined){
                products[id].Quantity = draftValues[i].Quantity;
            }
        }
        cmp.set('v.draftValues', []);
        cmp.set('v.data', products);
        //helper.clearCartItems(cmp, event, helper);
        //helper.insertCartItem(cmp, event, selectedRows);
    }
})