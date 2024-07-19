@IsTest
private class InvocableObjectSelectorConverterTest 
{
    @IsTest
    static void convertValueToStringTest()
    {
        // GIVE
        String strParam = 'Test String';
        Decimal decimalParam = 0.0;
        Datetime datetimeParam = Datetime.now().addDays(1);
        Boolean boolParam = false;
        List<String> listNames = new List<String>{'Test String'};
        Set<String> setNames = new Set<String>{'Test String'};
        Set<Id> setIds = new Set<Id>{Id.valueOf('001IY000003O8SyYAK')};
        List<Id> listIds = new List<Id>{Id.valueOf('001IY000003O8SyYAK')};
        List<Decimal> listDecimal = new List<Decimal>{0.0};
        Set<Integer> setInteger = new Set<Integer>{0};
        List<Date> listDate = new List<Date>{Date.today().addDays(1)};

        // WHEN
        String result_strParam = InvocableObjectSelectorConverter.convertValueToString(strParam);
        String result_decimalParam = InvocableObjectSelectorConverter.convertValueToString(decimalParam);
        String result_datetimeParam = InvocableObjectSelectorConverter.convertValueToString(datetimeParam);
        String result_boolParam = InvocableObjectSelectorConverter.convertValueToString(boolParam);
        String result_listNames = InvocableObjectSelectorConverter.convertValueToString(listNames);
        String result_setNames = InvocableObjectSelectorConverter.convertValueToString(setNames);
        String result_setIds = InvocableObjectSelectorConverter.convertValueToString(setIds);
        String result_listIds = InvocableObjectSelectorConverter.convertValueToString(listIds);
        String result_listDecimal = InvocableObjectSelectorConverter.convertValueToString(listDecimal);
        String result_setInteger = InvocableObjectSelectorConverter.convertValueToString(setInteger);
        String result_listDate = InvocableObjectSelectorConverter.convertValueToString(listDate);

        // THEN
        System.debug(strParam);
        System.debug(decimalParam);
        System.debug(datetimeParam);
        System.debug(boolParam);
        System.debug(listNames);
        System.debug(setNames);
        System.debug(setIds);
        System.debug(listIds);
        System.debug(listDecimal);
        System.debug(setInteger);
        System.debug(listDate);

        System.assertEquals('\'Test String\'', result_strParam, 'Should be a soql string');
        System.assertEquals('0.0', result_decimalParam, 'Should be a soql decimal');
        System.assertEquals('false', result_boolParam, 'Should be a soql boolean');
        System.assertEquals('(\'Test String\')', result_listNames, 'Should be a soql list of string');
        System.assertEquals('(\'Test String\')', result_setNames, 'Should be a soql set of string');
        System.assertEquals('(\'001IY000003O8SyYAK\')', result_setIds, 'Should be a soql set of ids');
        System.assertEquals('(\'001IY000003O8SyYAK\')', result_listIds, 'Should be a soql list of ids');
        System.assertEquals('(0.0)', result_listDecimal, 'Should be a soql list of decimal');
        System.assertEquals('(0)', result_setInteger, 'Should be a soql set of integer');
        
        // System.assertEquals('2023-12-13T14:39:23Z', result_datetimeParam, 'Should be a soql datetime');
        // System.assertEquals('(2023-12-13)', result_listDate, 'Should be a soql list of date');

    }
}