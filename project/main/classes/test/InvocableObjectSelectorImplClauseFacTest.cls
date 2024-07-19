@IsTest
private class InvocableObjectSelectorImplClauseFacTest
{
    private static InvocableObjectSelectorImpl.WhereClauseFactory whereClauseFactory = new InvocableObjectSelectorImpl.WhereClauseFactory(); 

    @IsTest
    static void createWhereClauseListFromStringFirstTest()
    {
        String stringFormula = 'Id = 001: String AND (Name = Test Name: String OR Age__c >= 18: Decimal)';

        List<InvocableObjectSelectorImpl.WhereClause> result = whereClauseFactory.createWhereClauseListFromString(stringFormula, true);

        System.debug(result);
        System.assertEquals(3, result.size(), 'The string should generate 3 conditions');
    }

    @IsTest
    static void createWhereClauseListFromStringSecondTest()
    {
        String stringFormula = 'Id = 001: String AND (Name = : String OR Age__c >= 18 : Decimal)';

        List<InvocableObjectSelectorImpl.WhereClause> result = whereClauseFactory.createWhereClauseListFromString(stringFormula, true);

        System.debug(result);
        System.assertEquals(2, result.size(), 'The string should generate 2 conditions and 1 nullable skip');
    }

    @IsTest
    static void createWhereClauseListFromStringThirdTest()
    {
        String stringFormula = 'Id = 001: String AND (Name = Test Name: String OR Age__c >= : Decimal)';

        List<InvocableObjectSelectorImpl.WhereClause> result = whereClauseFactory.createWhereClauseListFromString(stringFormula, true);

        System.debug(result);
        System.assertEquals(2, result.size(), 'The string should generate 2 conditions and 1 nullable skip');
    }

    @IsTest
    static void createWhereClauseListFromStringFortyTest()
    {
        String stringFormula = 'Id = 001: String AND (Name = : String OR Age__c >= : Decimal)';

        List<InvocableObjectSelectorImpl.WhereClause> result = whereClauseFactory.createWhereClauseListFromString(stringFormula, true);

        System.debug(result);
        System.assertEquals(2, result.size(), 'The string should generate 1 condition and 2 nullable skip');
    }

    @IsTest
    static void getLogicalOperatorTest()
    {
        String startString = 'Id = 001: String AND Name = Test Name: String';
        String conditionString = 'Name = Test Name: String';

        String result = whereClauseFactory.getLogicalOperator(startString, conditionString);

        System.debug(result);
        System.assertEquals('AND', result, 'Should get the logical operator that preceeds the condition');
    }

    @IsTest
    static void getFieldApiTest()
    {
        String conditionString = 'Origin != Web: String';

        String result = whereClauseFactory.getFieldApi(conditionString);

        System.debug(result);
        System.assertEquals('Origin', result, 'Should get the api field from the condition');
    }

    @IsTest
    static void getComparisonOperatorTest()
    {
        String conditionString = 'Age__c >= 18: Decimal';

        String result = whereClauseFactory.getComparisonOperator(conditionString);

        System.debug(result);
        System.assertEquals('>=', result, 'Should get the operator used to compare from the condition');
    }

    @IsTest
    static void getValueTest()
    {
        String conditionString = 'Subject LIKE %help with%: String';

        String result = whereClauseFactory.getValue(conditionString);

        System.debug(result);
        System.assertEquals('\'%help with%\'', result, 'Should get the serialized value by soql injection from the condition');
    }
}