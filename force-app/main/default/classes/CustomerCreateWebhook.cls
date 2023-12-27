// @RestResource(urlMapping='/HaravanWebhook/APICreateCustomer/*')
global without sharing class CustomerCreateWebhook {
    // @HttpPost
    global static void CustomerCreateWebhook() {
        RestRequest req =  RestContext.request;
        // RestResponse restRes = RestContext.response;
        String jsonRespone = req.requestBody.toString();
        Map<String,Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonRespone);
        Account acc = new Account();
        Decimal ExternalId = (Decimal) responseMap.get('id');
        String LastName = (String) responseMap.get('last_name');
        String FirstName = (String) responseMap.get('first_name');
        Object default_address = responseMap.get('default_address');
        Map<String,Object> MapDefaultAddress = (Map<String, Object>) default_address;
        Decimal Phone = (Decimal) MapDefaultAddress.get('Phone');
        Decimal Mobile = (Decimal) responseMap.get('Phone');
        String Email = (String) responseMap.get('email');
        Date Birthdate = (Date) responseMap.get('birthday');
        String Note = (String) responseMap.get('note');
        System.debug('12345:' + default_address);



        System.debug('12345:' + ExternalId);
        //  listData = (List<Object>) responseMap.get('data');
        // String aa =(String) 
        // Map<String,Object> mapKeyData = new Map<String, Object>();
        // List<Package__c> lstPackUpdate = new List<Package__c>();
        // // mapKeyData = (Map<String,Object>) listData[0];
        // for (Integer i = 0; i< listData.size(); i++) {
        //     Map<String,Object> mapKeyData = (Map<String,Object>) listData[i];
        //     String status  = (String) mapKeyData.get('status');
        //     if (status == '7') {
        //         String itemCode = (String) mapKeyData.get('itemCode');
        //         String shippingFeeStr = (String) mapKeyData.get('mainFee');
        //         String totalFeeStr = (String) mapKeyData.get('totalFee');
        //         String priceWeightStr = (String) mapKeyData.get('priceWeight'); 
        //         Package__c pack = [SELECT Id, Name, GrossWeightgVendor__c, ShippingChargeVNPost__c, TotalOtherChargesVNPost__c  FROM Package__c WHERE ItemCodeVNPost__c =: itemCode LIMIT 1];
        //         Decimal shippingFee = Decimal.valueOf(shippingFeeStr);
        //         Decimal totalFee = Decimal.valueOf(totalFeeStr);
        //         Decimal priceWeight = Decimal.valueOf(priceWeightStr);
        //         pack.GrossWeightgVendor__c = priceWeight;
        //         pack.ShippingChargeVNPost__c = shippingFee;
        //         pack.TotalOtherChargesVNPost__c = totalFee;
        //         pack.PackageStatus__c = 'Đã xuất kho';
        //         lstPackUpdate.add(pack);
        //     } else if (status  == '14') {
        //         String itemCode = (String) mapKeyData.get('itemCode');
        //         Package__c pack = [SELECT Id, Name, GrossWeightgVendor__c, ShippingChargeVNPost__c, TotalOtherChargesVNPost__c  FROM Package__c WHERE ItemCodeVNPost__c =: itemCode LIMIT 1];
        //         pack.PackageStatus__c = 'Giao hàng thành công';
        //         lstPackUpdate.add(pack);
        //     } else if (status == '15') {
        //         String itemCode = (String) mapKeyData.get('itemCode');
        //         Package__c pack = [SELECT Id, Name, GrossWeightgVendor__c, ShippingChargeVNPost__c, TotalOtherChargesVNPost__c  FROM Package__c WHERE ItemCodeVNPost__c =: itemCode LIMIT 1];
        //         pack.PackageStatus__c = 'Giao hàng không thành công lần 1';
        //         lstPackUpdate.add(pack);
        //     } else if (status == '17') {
        //         String itemCode = (String) mapKeyData.get('itemCode');
        //         Package__c pack = [SELECT Id, Name, GrossWeightgVendor__c, ShippingChargeVNPost__c, TotalOtherChargesVNPost__c  FROM Package__c WHERE ItemCodeVNPost__c =: itemCode LIMIT 1];
        //         pack.PackageStatus__c = 'Hoàn hàng';
        //         lstPackUpdate.add(pack);
        //     } else if (status == '19') {
        //         String itemCode = (String) mapKeyData.get('itemCode');
        //         Package__c pack = [SELECT Id, Name, GrossWeightgVendor__c, ShippingChargeVNPost__c, TotalOtherChargesVNPost__c  FROM Package__c WHERE ItemCodeVNPost__c =: itemCode LIMIT 1];
        //         pack.PackageStatus__c = 'Hoàn hàng';
        //         lstPackUpdate.add(pack);
        //     } else if (status == '21') {
        //         String itemCode = (String) mapKeyData.get('itemCode');
        //         Package__c pack = [SELECT Id, Name, GrossWeightgVendor__c, ShippingChargeVNPost__c, TotalOtherChargesVNPost__c  FROM Package__c WHERE ItemCodeVNPost__c =: itemCode LIMIT 1];
        //         pack.PackageStatus__c = 'Hoàn tiền';
        //         lstPackUpdate.add(pack);
        //     }  else if (status == '9') {
        //         String itemCode = (String) mapKeyData.get('itemCode');
        //         Package__c pack = [SELECT Id, Name, GrossWeightgVendor__c, ShippingChargeVNPost__c, TotalOtherChargesVNPost__c  FROM Package__c WHERE ItemCodeVNPost__c =: itemCode LIMIT 1];
        //         pack.PackageStatus__c = 'Đã nhập kho';
        //         lstPackUpdate.add(pack);
        //     } else if (status == '22') {
        //         String itemCode = (String) mapKeyData.get('itemCode');
        //         Package__c pack = [SELECT Id, Name, GrossWeightgVendor__c, ShippingChargeVNPost__c, TotalOtherChargesVNPost__c  FROM Package__c WHERE ItemCodeVNPost__c =: itemCode LIMIT 1];
        //         pack.PackageStatus__c = 'Đã nhập kho';
        //         lstPackUpdate.add(pack);
        //     }
        // }
        // update lstPackUpdate;
        // String status  = (String) mapKeyData.get('status');
        // if (status == '7') {
        //     String itemCode = (String) mapKeyData.get('itemCode');
        //     String shippingFeeStr = (String) mapKeyData.get('mainFee');
        //     String totalFeeStr = (String) mapKeyData.get('totalFee');
        //     String priceWeightStr = (String) mapKeyData.get('priceWeight'); 
        //     Package__c pack = [SELECT Id, Name, GrossWeightgVendor__c, ShippingChargeVNPost__c, TotalOtherChargesVNPost__c  FROM Package__c WHERE ItemCodeVNPost__c =: itemCode LIMIT 1];
        //     Decimal shippingFee = Decimal.valueOf(shippingFeeStr);
        //     Decimal totalFee = Decimal.valueOf(totalFeeStr);
        //     Decimal priceWeight = Decimal.valueOf(priceWeightStr);
        //     pack.GrossWeightgVendor__c = priceWeight;
        //     pack.ShippingChargeVNPost__c = shippingFee;
        //     pack.TotalOtherChargesVNPost__c = totalFee;
        //     update pack;
        // }
    }
}