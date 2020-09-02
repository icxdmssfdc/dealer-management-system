({
	onInit : function(component, event, helper) {
		helper.getInvDetails(component,event, helper)
	},
    handleKeyUp: function (component, event, helper) {
      var isEnterKey = event.keyCode === 13;
      var queryTerm = component.find('enter-search').get('v.value');
      if (isEnterKey) {
          component.set('v.issearching', true);
          setTimeout(function() {
              helper.queryAccProducts(component, event, helper, queryTerm);
              component.set('v.issearching', false);
          }, 2000);
      }
    },
    createOrder: function (component, event, helper){
    	var lInvItems = [];
  		var data = component.get("v.sInvList");
        for(var i=0;i<data.length;i++){
            if(data[i].isSelected){
                lInvItems.push(data[i]);
            }
        }
        helper.genOrder(component, event, helper, lInvItems);
    }
})