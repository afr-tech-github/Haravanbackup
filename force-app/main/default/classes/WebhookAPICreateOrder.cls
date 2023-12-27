@RestResource(urlMapping = '/HaravanWebhook/APICreateOrder/*')
global without sharing class WebhookAPICreateOrder{
    @HttpPost
    global static void WebhookAPICreateOrder(){
        RestRequest req = RestContext.request;
        String jsonResponse = req.requestBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
        Object customer = (Object) responseMap.get('customer');
        Map<String, Object> mapCustomer = (Map<String, Object>)customer;
        List<Object> lstShippingLines = (List<Object>)responseMap.get('shipping_lines');
        Map<String, Object> mapShippingLines = (Map<String, Object>)lstShippingLines[0];
        Object shipping_address = (Object) responseMap.get('shipping_address');
        Object billing_address = (Object) responseMap.get('billing_address');
        Map<String, Object> mapShippingAddress = (Map<String, Object>)shipping_address;
        Map<String, Object> mapBillingAddress = (Map<String, Object>)billing_address;
        List<String> ExternalIdVariant = new List<String>();
        Map<String, Id> mapIdVariant = new Map<String, Id>();
        List<Haravan_Order_item__c> lstOrderItem = new List<Haravan_Order_item__c>();
        List<Object> lstLineItems = (List<Object>)responseMap.get('line_items');
        // Map<String, Object> mapLineItems = (Map<String, Objetc>) lstLineItems

        Haravan_Order__c order = new Haravan_Order__c();

        String ExIdCustomer = String.valueOf((Decimal) mapCustomer.get('id'));
        List<Account> acc = [SELECT Id, PersonContactId
                       From Account
                       Where External__c = :ExIdCustomer];
        if (acc.size() > 0){
            try{
                order.External_Id__c = String.valueOf((Decimal) responseMap.get('id'));
                order.Customer__c = acc[0].Id;
                order.Email__c = (String) mapCustomer.get('email');
                order.Discount__c = (Decimal) responseMap.get('total_discounts');
                order.Shipping__c = (Decimal) mapShippingLines.get('price');
                order.Total_Payment__c = (Decimal) responseMap.get('total_price');
                order.Customer_Note__c = (String) mapCustomer.get('note');
                order.Notes__c = (String) responseMap.get('note');
                order.Payment_method__c = (String) responseMap.get('gateway');
                order.Fulfillment_Status__c = (String) responseMap.get('fulfillment_status');
                order.Payment_Status__c = (String) responseMap.get('financial_status');
                order.Sales_Channel__c = (String) responseMap.get('source');
                order.Order_Processing_Status__c = (String) responseMap.get('order_processing_status');
                insert order;

                Shipping_Address__c shippingAddress = new Shipping_Address__c();
                // shippingAddress.External_Id__c = String.valueOf((Decimal) mapShippingAddress.get('id'));
                shippingAddress.Street__c = (String) mapShippingAddress.get('address1');
                shippingAddress.District__c = (String) mapShippingAddress.get('district');
                shippingAddress.Ward__c = (String) mapShippingAddress.get('ward');
                shippingAddress.Haravan_Order__c = order.Id;
                shippingAddress.Province__c = (String) mapShippingAddress.get('province');
                shippingAddress.Country__c = (String) mapShippingAddress.get('country');
                insert shippingAddress;

                Billing_Address__c billingAddress = new Billing_Address__c();
                billingAddress.External_Id__c = String.valueOf((Decimal) mapBillingAddress.get('id'));
                billingAddress.Name = order.Id;
                billingAddress.Address_1__c = (String) mapBillingAddress.get('address1');
                billingAddress.Contact__c = acc[0].PersonContactId;
                billingAddress.Phone__c = (String) mapBillingAddress.get('phone');
                billingAddress.Haravan_Order__c = order.Id;
                billingAddress.Province_text__c = (String) mapBillingAddress.get('province');
                billingAddress.District_text__c = (String) mapBillingAddress.get('district');
                billingAddress.Ward_text__c = (String) mapBillingAddress.get('ward');
                billingAddress.Countrytext__c = (String) mapBillingAddress.get('country');
                billingAddress.Company__c = (String) mapBillingAddress.get('company');
                upsert billingAddress External_Id__c;

                for (Integer i = 0; i < lstLineItems.size(); i++){
                    Map<String, Object> mapLineItems = (Map<String, Object>)lstLineItems[i];
                    ExternalIdVariant.add(String.valueOf((Decimal) mapLineItems.get('variant_id')));
                }
                System.debug('12345:' + ExternalIdVariant);

                List<HaravanProductVariant__c> lstVariant = [SELECT Id, External_Id__c
                                                             FROM HaravanProductVariant__c
                                                             Where External_Id__c IN:ExternalIdVariant];
                System.debug('12345:' + lstVariant);
                for (Integer i = 0; i < lstVariant.size(); i++){
                    for (Integer j = 0; j < ExternalIdVariant.size(); j++){
                        if (ExternalIdVariant[j] == lstVariant[i].External_Id__c){
                            mapIdVariant.put(ExternalIdVariant[j], lstVariant[i].Id);
                        }
                    }
                }
                for (Integer i = 0; i < lstLineItems.size(); i++){
                    Haravan_Order_item__c orderItem = new Haravan_Order_item__c();
                    Map<String, Object> mapLineItems = (Map<String, Object>)lstLineItems[i];
                    orderItem.Haravan_Order__c = order.Id;
                    orderItem.Quantity__c = (Decimal) mapLineItems.get('quantity');
                    orderItem.Price__c = (Decimal) mapLineItems.get('price_original');
                    orderItem.Total__c = (Decimal) mapLineItems.get('price');
                    orderItem.Discount__c = (Decimal) mapLineItems.get('total_discount');
                    for (Integer j = 0; j < mapIdVariant.size(); j++){
                        if (mapIdVariant.containsKey(String.valueOf((Decimal) mapLineItems.get('variant_id')))){
                            System.debug('12345:' + mapIdVariant.get(String.valueOf((Decimal) mapLineItems.get('variant_id'))));
                            orderItem.product__c = mapIdVariant.get(String.valueOf((Decimal) mapLineItems.get('variant_id')));
                        }
                    }
                    lstOrderItem.add(orderItem);
                }
                insert lstOrderItem;
            } catch (Exception e){
                System.debug('Error: ' + e.getMessage());
            }
        }
    }
}