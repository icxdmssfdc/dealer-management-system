({
    init: function (cmp, event, helper) {
        var tableColumns = [
            {
                "label": " ",
                "fieldName": "Orderable",
                "initialWidth": 50,
                "cellAttributes": {
                    "class": {
                        "fieldName": "showClass"
                    },
                    "iconName": {
                        "fieldName": "displayIconName"
                    }
                }
            },
            {
                "label": "Product Name",
                "fieldName": "productName",
                "type": "text",
                "cellAttributes": {
                    "class": {
                        "fieldName": "showClass"
                    }
                }
            },
            {
                "label": "Order Product Quantity",
                "fieldName": "orderQty",
                "type": "numeric",
                "cellAttributes": {
                    "class": {
                        "fieldName": "showClass"
                    }
                }
            },
            {
                "label": "OnHand Quantity",
                "fieldName": "onHandQty",
                "type": "numeric",
                "cellAttributes": {
                    "class": {
                        "fieldName": "showClass"
                    }
                }
            }
        ];
        
        cmp.set('v.columns', tableColumns);
        helper.gethCheckInventory(cmp, event, helper);
    }
})