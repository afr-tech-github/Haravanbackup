public with sharing class CustomerOrderInfoController{
    @AuraEnabled
    public static List<Haravan_Order__c> getOrderInfo(String OrderId){
        try{
            return [SELECT Id, Name, Customer__c, Customer__r.Name, Ordered__c, Customer__r.Total_Spent_Rollup__c, Customer__r.Total_Orders_Rollup__c, Customer__r.PersonBirthdate, CLV__c, Customer__r.PersonMobilePhone, Customer__r.PersonEmail, Customer__r.Notes__c, Customer__r.PersonGenderIdentity
                    FROM Haravan_Order__c
                    WHERE ID = :OrderId
                    LIMIT 1];
        } catch (DmlException e){
            throw e;
        }
    }

    @AuraEnabled
    public static List<Billing_Address__c> getBillingAddressInfo(String OrderId){
        try{
            return [SELECT ID, Address_1__c, District_text__c, Ward_text__c, Province_text__c
                    FROM Billing_Address__c
                    WHERE Haravan_Order__c = :OrderId];
        } catch (DmlException e){
            throw e;
        }
    }

    @AuraEnabled
    public static List<Account> getAccountInfo(String AccountId){
        try{
            return [SELECT Id, Name, Customer_Level__c, Ordered__c, Total_Spent_Rollup__c, PersonBirthdate, PersonMobilePhone, PersonEmail, Default_Address__pr.Address_1__c, Districttext__c, Wardtext__c, Provincetext__c, Notes__c, PersonGenderIdentity
                    from Account
                    Where Id = :AccountId];
        } catch (DmlException e){
            throw e;
        }
    }

    @AuraEnabled
    public static List<AggregateResult> getChartofProductFamily(String AccountId){
        System.debug('12345:' + AccountId);
        try{
            List<Haravan_Order__c> listIdOrder = [SELECT Id
                                                  From Haravan_Order__c
                                                  where Customer__c = :AccountId];
            System.debug('12345:' + listIdOrder);
            String strSelect = 'SELECT SUM(Total_Payment__c), product__r.product__r.Name ';
            String strFrom = 'FROM Haravan_Order_item__c ';
            String strWhere = '';
            if (listIdOrder.size() > 0){
                strWhere += ' WHERE Haravan_Order__c IN : listIdOrder ';
            }
            String strGroupby = 'GROUP BY product__r.product__r.Name';
            String query = strSelect + strFrom + strWhere + strGroupby;
            List<AggregateResult> lstResult = new List<AggregateResult>();
            lstResult = Database.query(query);
            System.debug('12345:' + query);
            System.debug('12345:' + lstResult);
            return lstResult;
        } catch (DmlException e){
            throw e;
        }
    }

    @AuraEnabled
    public static List<AggregateResult> getChartofRevenue6Month(String AccountId){
        try{
            List<Integer> lstMonth = new List<Integer>{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 };
            Integer intMonth = Date.today().month() + 1;
            Integer intYear = Date.today().year();
            Set<Integer> lst6Month = new Set<Integer>();
            Set<Integer> lstYear = new Set<Integer>();
            if (intMonth < 6){
                lstYear.add(intYear);
                lstYear.add(intYear - 1);
            } else{
                lstYear.add(intYear);
            }
            for (Integer i = 6; i > 0; i--){
                System.debug('12345:' + (intMonth - i));
                lst6Month.add(intMonth - i);
            }
            List<AggregateResult> lstRevenue6Month = [SELECT SUM(TOTAL_PAYMENT_INCLUDE_SHIP__c), CALENDAR_MONTH(Order_date__c), CALENDAR_YEAR(Order_date__c)
                                                      from Haravan_Order__c
                                                      WHERE CALENDAR_MONTH(Order_date__c) IN:lst6Month AND CALENDAR_YEAR(Order_date__c) IN:lstYear AND Customer__c = :AccountId
                                                      group by CALENDAR_MONTH(Order_date__c), CALENDAR_YEAR(Order_date__c)
                                                      ORDER BY CALENDAR_YEAR(Order_date__c)];
            return lstRevenue6Month;
        } catch (Exception e){
            throw e;
        }
    }

    @AuraEnabled
    public static Map<String,AggregateResult> getCharofSalesChannels(String AccountId){
        try{
            List<AggregateResult> lstSalesChannels = [SELECT SUM(TOTAL_PAYMENT_INCLUDE_SHIP__c), Sales_Channel__c
                                                      FROM Haravan_Order__c
                                                      WHERE Customer__c = :AccountId
                                                      GROUP BY Sales_Channel__c
                                                      ORDER BY SUM(TOTAL_PAYMENT_INCLUDE_SHIP__c) DESC];
            List<String> pickListValuesList = new List<String>();
            Schema.DescribeFieldResult fieldResult = Haravan_Order__c.Sales_Channel__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry pickListVal : ple){
                pickListValuesList.add(pickListVal.getLabel());
            }
            // Map<String, List<AggregateResult>> map = new Map<String, List<AggregateResult>>();
            Map<string, Aggregateresult> m = new Map<String, Aggregateresult>();
            System.debug('1234:' + lstSalesChannels);
            System.debug('12345:' + lstSalesChannels[0].get('Sales_Channel__c'));
            for (Integer i = 0; i < lstSalesChannels.size(); i++){
                for (Integer j = 0; j < ple.size(); j++){
                    if (lstSalesChannels[i].get('Sales_Channel__c') == ple[j].getValue()){
                        m.put(ple[j].getLabel(), lstSalesChannels[i]);
                    }
                }
            }
            System.debug('12345:' + m);

            return m;
        } catch (Exception e){
            throw e;
        }
    }

}