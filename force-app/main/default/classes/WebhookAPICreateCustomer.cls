@RestResource(urlMapping = '/HaravanWebhook/APICreateCustomer/*')
global without sharing class WebhookAPICreateCustomer{
    @HttpPost
    global static void WebhookAPICreateCustomer(){
        String recordTypeId = [SELECT Id, Name
                               From RecordType
                               Where Name = 'Person Account'].Id;
        RestRequest req = RestContext.request;
        // RestResponse restRes = RestContext.response;
        String jsonResponse = req.requestBody.toString();
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
        Object default_address = (Object) responseMap.get('default_address');
        Map<String, Object> MapDefaultAddress = (Map<String, Object>)default_address;
        List<Object> lstAddresses = (List<Object>)responseMap.get('addresses');
        Map<String, Object> mapAddress = (Map<String, Object>)lstAddresses[0];
        Account acc = new Account();
        Customer_Addresses__c cusAddress = new Customer_Addresses__c();
        try{
            acc.External__c = String.valueOf((Decimal) responseMap.get('id'));
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
            insert acc;

            cusAddress.Address_1__c = (String) mapAddress.get('address1');
            cusAddress.External_Id__c = String.valueOf((Decimal) mapAddress.get('id'));
            cusAddress.Account__c = acc.Id;
            cusAddress.Province_text__c = (String) mapAddress.get('province');
            cusAddress.District_text__c = (String) mapAddress.get('district');
            cusAddress.Ward_text__c = (String) mapAddress.get('ward');
            cusAddress.Country1__c = (String) mapAddress.get('country');

            insert cusAddress;
        } catch (Exception e){
            System.debug('Error: ' + e.getMessage());
        }
    }

}