({
    init: function (cmp, event, helper) {
        var OrderId = cmp.get("v.recordId");
        var actionGetOrder = cmp.get("c.getOrderInfo");
        var actionGetBillingAddress = cmp.get("c.getBillingAddressInfo");
        var billingAddress = '';
        actionGetOrder.setParams({
            'OrderId': cmp.get("v.recordId")
        })

        actionGetOrder.setCallback(this, function (response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var res = response.getReturnValue();
                cmp.set('v.Order', res[0]);
                cmp.set('v.AccountId', res[0].Customer__c);
            } else if (state == "ERROR") {
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                if (errors) {
                    toastEvent.setParams({
                        "type": 'error',
                        "title": "Error",
                        "message": 'Error'
                    });
                    toastEvent.fire();
                }
            }
        });

        actionGetBillingAddress.setParams({
            'OrderId': cmp.get("v.recordId")
        })

        actionGetBillingAddress.setCallback(this, function (response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var res = response.getReturnValue();
                cmp.set('v.BillingAddress', res[0]);
                if (res[0].Address_1__c) {
                    billingAddress += res[0].Address_1__c;
                }
                if (res[0].District_text__c) {
                    billingAddress += ', ' + res[0].District_text__c;
                }
                if (res[0].Ward_text__c) {
                    billingAddress += ', ' + res[0].Ward_text__c;
                }
                if (res[0].Province_text__c) {
                    billingAddress += ', ' + res[0].Province_text__c;
                }
                cmp.set('v.billingAddress', billingAddress);
            } else if (state == "ERROR") {
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                if (errors) {
                    toastEvent.setParams({
                        "type": 'error',
                        "title": "Error",
                        "message": errors[0].message
                    });
                    toastEvent.fire();
                }
            }
        })
        $A.enqueueAction(actionGetOrder);
        $A.enqueueAction(actionGetBillingAddress);
    },
    onClickAccount: function (cmp, event) {
        var getAccountId = cmp.get("v.AccountId");
        var url = "/lightning/r/Account/" + getAccountId + "/view";
        window.open(url, "_self");
    }
})