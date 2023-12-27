@RestResource(urlMapping='/HaravanWebhook/APIDeleteProduct/*')
global without sharing class WebhookAPIDeleteProduct {
    @HttpPost
    global static void DeleteProduct() {
        RestRequest req =  RestContext.request;
        String jsonRespone = req.requestBody.toString();
        System.debug(jsonRespone);
        Map<String,Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonRespone);
        String idProd  = String.valueOf((Integer) responseMap.get('id'));
        List<Haravan_Product__c> lstProd = [SELECT Id, Name, External_Id__c FROM Haravan_Product__c WHERE External_Id__c =: idProd];
        if (lstProd.size() >0 ) {
            try {
                delete lstProd.get(0);
            } catch (Exception e) {
                System.debug('Error: '+e.getMessage());
            }
        } else {
            
        }
    }
}