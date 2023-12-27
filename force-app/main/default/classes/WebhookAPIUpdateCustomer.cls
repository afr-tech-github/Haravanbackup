@RestResource(urlMapping = '/HaravanWebhook/APIUpdateCustomer/*')
global without sharing class WebhookAPIUpdateCustomer{
    @HttpPost
    global static void WebhookAPIUpdateCustomer(){
        RestRequest req = RestContext.request;
        String jsonResponse = req.requestBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
        String ExternalId = String.valueOf((Decimal) responseMap.get('id'));
        Object default_address = (Object) responseMap.get('default_address');
        Map<String, Object> MapDefaultAddress = (Map<String, Object>)default_address;
        List<Object> lstAddresses = (List<Object>)responseMap.get('addresses');
        Map<String, Object> mapAddress = (Map<String, Object>)lstAddresses[0];
        String recordTypeId = [SELECT Id, Name
                               From RecordType
                               Where Name = 'Person Account'].Id;
        List<Account> lstAcc = [SELECT Id
                                FROM Account
                                Where External__c = :ExternalId];
        if (lstAcc.size() > 0){
            Account acc = lstAcc.get(0);
            acc.External__c = ExternalId;
            acc.LastName = (String) responseMap.get('last_name');
            acc.FirstName = (String) responseMap.get('first_name');
            acc.RecordTypeId = recordTypeId;
            acc.Phone = (String) MapDefaultAddress.get('phone');
            acc.PersonMobilePhone = String.valueOf((String) responseMap.get('phone'));
            acc.PersonEmail = (String) responseMap.get('email');
            acc.PersonBirthdate = Date.valueOf((String) responseMap.get('birthday'));
            acc.Total_Spent__c = (Decimal) responseMap.get('total_spent');
            acc.Total_Orders__c = (Decimal) responseMap.get('orders_count');
            acc.Addres__c = (String) MapDefaultAddress.get('address1');
            acc.Notes__c = (String) responseMap.get('note');
            acc.Gender__c = String.valueOf((Decimal) responseMap.get('gender'));
            acc.Wardtext__c = (String) MapDefaultAddress.get('ward');
            acc.Districttext__c = (String) MapDefaultAddress.get('district');
            acc.Provincetext__c = (String) MapDefaultAddress.get('province');
            acc.Countrytext__c = (String) MapDefaultAddress.get('country');
            acc.Accept_Email_Marketing__c = String.valueOf((Boolean) responseMap.get('accepts_marketing'));
            update acc;
            List<Customer_Addresses__c> lstCusAddress = new List<Customer_Addresses__c>();
            for (Integer i = 0; i < lstAddresses.size(); i++){
                Customer_Addresses__c cusAddress = new Customer_Addresses__c();
                Map<String, Object> mapAdd = (Map<String, Object>)lstAddresses[i];
                cusAddress.Address_1__c = (String) mapAdd.get('address1');
                cusAddress.External_Id__c = String.valueOf((Decimal) mapAdd.get('id'));
                cusAddress.Account__c = acc.Id;
                cusAddress.Province_text__c = (String) mapAdd.get('province');
                cusAddress.District_text__c = (String) mapAdd.get('district');
                cusAddress.Ward_text__c = (String) mapAdd.get('ward');
                cusAddress.Country1__c = (String) mapAdd.get('country');
                lstCusAddress.add(cusAddress);
            }
            if (lstCusAddress.size() > 0){
                upsert lstCusAddress External_Id__c;
            }
        }
    }

}