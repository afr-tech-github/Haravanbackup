@RestResource(urlMapping = '/HaravanWebhook/APIUpdateOrder/*')
global without sharing class WebhookAPIUpdateOrder{
    @HttpPost
    global static void WebhookAPIUpdateOrder(){
        RestRequest req = RestContext.request;
        String jsonResponse = req.requestBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
        String getCancelStatus = (String) responseMap.get('cancelled_status');
        Object customer = (Object) responseMap.get('customer');
        Map<String, Object> mapCustomer = (Map<String, Object>)customer;
        String ExIdCustomer = String.valueOf((Decimal) mapCustomer.get('id'));
        String ExIdOrder = String.valueOf((Decimal) responseMap.get('id'));
        Object shipping_address = (Object) responseMap.get('shipping_address');
        Object billing_address = (Object) responseMap.get('billing_address');
        Map<String, Object> mapShippingAddress = (Map<String, Object>)shipping_address;
        Map<String, Object> mapBillingAddress = (Map<String, Object>)billing_address;
        Haravan_shipment__c shipment = new Haravan_shipment__c();
        Account acc = [SELECT Id, PersonContactId
                       From Account
                       Where External__c = :ExIdCustomer];
        List<Haravan_Order__c> order = [SELECT Id, Order_Processing_Status__c
                                        From Haravan_Order__c
                                        WHERE External_Id__c = :ExIdOrder];
        Shipping_Address__c shippingAddress = [SELECT Id
                                               FROM Shipping_Address__c
                                               WHERE Haravan_Order__c = :order[0].Id];
        if (order.size() > 0){
            order[0].Notes__c = (String) responseMap.get('note');
            order[0].Payment_Status__c = (String) responseMap.get('financial_status');
            order[0].Order_Processing_Status__c = (String) responseMap.get('order_processing_status');
            if(getCancelStatus == 'cancelled'){
                order[0].Fulfillment_Status__c = getCancelStatus;
            }else {
                order[0].Fulfillment_Status__c = (String) responseMap.get('fulfillment_status');
            }
            update order;

            System.debug('12345:' + String.valueOf((Decimal) mapShippingAddress.get('id')));
            System.debug('12345:' + String.valueOf((Decimal) mapBillingAddress.get('id')));
            // Shipping_Address__c shippingAddress = new Shipping_Address__c();
            shippingAddress.External_Id__c = String.valueOf((Decimal) mapShippingAddress.get('id'));
            shippingAddress.Street__c = (String) mapShippingAddress.get('address1');
            shippingAddress.District__c = (String) mapShippingAddress.get('district');
            shippingAddress.Ward__c = (String) mapShippingAddress.get('ward');
            shippingAddress.Haravan_Order__c = order[0].Id;
            shippingAddress.Province__c = (String) mapShippingAddress.get('province');
            shippingAddress.Country__c = (String) mapShippingAddress.get('country');
            update shippingAddress;
        }
        try {
            List<Object> fulfillments = (List<Object>) responseMap.get('fulfillments');
            Map<String, Object> mapFulfillments = (Map<String, Object>) fulfillments[0];
            System.debug('12345 : ' + mapFulfillments);
            System.debug('12345 : ' + mapFulfillments.size());
            if(mapFulfillments.size() > 0){
                shipment.External_Id__c = String.valueOf((Decimal)mapFulfillments.get('id'));
                shipment.Buyer__c = acc.Id;
                shipment.Haravan_Order__c = order[0].Id;
                shipment.Tracking_number__c = String.valueOf((Decimal)mapFulfillments.get('tracking_number'));
                shipment.COD_amount__c = (Decimal)mapFulfillments.get('cod_amount');
                shipment.Size__c = String.valueOf((Decimal)mapFulfillments.get('package_length')) + ' x ' + String.valueOf((Decimal)mapFulfillments.get('package_width')) + ' x ' + String.valueOf((Decimal)mapFulfillments.get('package_height'));
                shipment.Total_weight__c = (Decimal)mapFulfillments.get('total_weight');
                shipment.Note_for_shipment__c = (String)mapFulfillments.get('shipping_notes');
                shipment.Status1__c = (String)mapFulfillments.get('status');
                shipment.Carrier_Status__c = (String)mapFulfillments.get('carrier_status_name');
                shipment.Carrier_COD_Status__c = (String)mapFulfillments.get('carrier_cod_status_name');
                upsert shipment External_Id__c;
            }
        } catch (Exception e) {
            
        }

    }

}