@RestResource(urlMapping='/HaravanWebhook/APIDeleteCustomer/*')
global without sharing class WebhookAPIDeleteCustomer {
    @HttpPost
    global static void WebhookAPIDeleteCustomer() {
        RestRequest req = RestContext.request;
        String jsonResponse = req.requestBody.toString();
        Map<String,Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
        String ExternalId = String.valueOf((Decimal) responseMap.get('id'));
        System.debug('12345:'+ ExternalId);
        try {
            delete [SELECT Id FROM Account Where External__c =: ExternalId];
        } catch (Exception e) {
            System.debug('Error: '+e.getMessage());
        }
    }
}