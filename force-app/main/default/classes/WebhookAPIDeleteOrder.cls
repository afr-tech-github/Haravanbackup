@RestResource(urlMapping = '/HaravanWebhook/APIDeleteOrder/*')
global without sharing class WebhookAPIDeleteOrder {
    @HttpPost
    global static void WebhookAPIDeleteOrder() {
        RestRequest req = RestContext.request;
        String jsonResponse = req.requestBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
        String ExIdOrder = String.valueOf((Decimal) responseMap.get('id'));
        try {
            delete [SELECT Id From  Haravan_Order__c WHERE External_Id__c =: ExIdOrder];
        } catch (Exception e) {
            System.debug('Error: '+e.getMessage());
            
        }
    }
}