@IsTest
private class InvocableObjectSelectorImplClauseTest 
{
    @IsTest
    static void constructorTest()
    {
        // GIVE
        String logicalOperator = '';
        String fieldApi = 'Id';
        String comparisonOperator = '='; 
        String value = '001';

        // WHEN
        InvocableObjectSelectorImpl.WhereClause whereClauseModel = new InvocableObjectSelectorImpl.WhereClause(
            logicalOperator, fieldApi, comparisonOperator, value
        );

        // THEN
        System.assert(
            whereClauseModel.logicalOperator == logicalOperator &&
            whereClauseModel.fieldApi == fieldApi &&
            whereClauseModel.comparisonOperator == comparisonOperator &&
            whereClauseModel.value == value
        , 'The constructor should set attributes correctly');
    }
}