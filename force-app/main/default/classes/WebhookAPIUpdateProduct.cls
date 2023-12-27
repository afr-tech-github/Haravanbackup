@RestResource(urlMapping='/HaravanWebhook/APIUpdateProduct/*')
global without sharing class WebhookAPIUpdateProduct {
    @HttpPost
    global static void UpdateProduct() {
        RestRequest req =  RestContext.request;
        String jsonRespone = req.requestBody.toString();
        System.debug(jsonRespone);
        Map<String,Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonRespone);
        String idProd  = String.valueOf((Integer) responseMap.get('id'));
        List<Haravan_Product__c> lstProd = [SELECT Id, Name, External_Id__c FROM Haravan_Product__c WHERE External_Id__c =: idProd];
        if (lstProd.size() >0 ) {
            try {
                Haravan_Product__c prod = lstProd.get(0);
                prod.External_Id__c = idProd;
                prod.Name = (String) responseMap.get('title');
                prod.Vendor__c = (String) responseMap.get('vendor');
                prod.Quote__c = (String) responseMap.get('body_plain');
                prod.Description1__c = (String) responseMap.get('body_html');
                prod.Type1__c = (String) responseMap.get('product_type');
                prod.Tags__c = (String) responseMap.get('tags');
                prod.promotionproducttext__c = String.valueOf((Boolean) responseMap.get('not_allow_promotion'));
                //prod.Images_Text__c = (String) responseMap.get('vendor');
                update prod;
                List<HaravanProductVariant__c> lstProdVar = new List<HaravanProductVariant__c>();
                List<Object> listVar = (List<Object>) responseMap.get('variants');
                for (Integer i=0; i<listVar.size(); i++) {
                    HaravanProductVariant__c prodVar = new HaravanProductVariant__c();
                    Map<String,Object> mapProdVar = (Map<String,Object>) listVar[i];
                    prodVar.Product__c = prod.Id;
                    prodVar.External_Id__c = String.valueOf((Integer) mapProdVar.get('id'));
                    prodVar.Name = (String) mapProdVar.get('title');
                    prodVar.UnitPrice__c = (Decimal) mapProdVar.get('price');
                    prodVar.SKU__c = (String) mapProdVar.get('sku');
                    prodVar.Barcode__c = (String) mapProdVar.get('barcode');
                    prodVar.Color__c = (String) mapProdVar.get('option2');
                    prodVar.Size__c = (String) mapProdVar.get('option3');
                    prodVar.Weight__c = (Decimal) mapProdVar.get('grams');
                    prodVar.CompareatPrice__c = (Decimal) mapProdVar.get('compare_at_price');
                    prodVar.Material__c = (String) mapProdVar.get('option3');
                    prodVar.Thisisaphysicalproduct__c = String.valueOf((Boolean) mapProdVar.get('requires_shipping'));
                    prodVar.ContinueSellingWhenOutofStock__c = (String) mapProdVar.get('inventory_policy');
                    lstProdVar.add(prodVar);
                }
                if (lstProdVar.size() >0) {
                    upsert lstProdVar External_Id__c;
                }
            } catch (Exception e) {
                System.debug('Error: '+e.getMessage());
            }
        } else {
            
        }
    }
}