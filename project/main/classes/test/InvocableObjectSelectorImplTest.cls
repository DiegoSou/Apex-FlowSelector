@IsTest
private class InvocableObjectSelectorImplTest 
{
    private static InvocableObjectSelector serviceInstance = new InvocableObjectSelectorImpl();

    @IsTest
    static void initBuildTest()
    {
        // GIVE
        String initialString = 'SELECT FROM WHERE ORDER BY LIMIT';
        
        // WHEN
        serviceInstance.initBuild(initialString);

        // THEN
        System.debug(serviceInstance.getQuery());
        System.assertEquals(initialString, serviceInstance.getQuery(), 'The SOQL query string should initialize equals to initial string');
    }

    @IsTest
    static void setObjectTest()
    {
        // GIVE
        String initialString = 'SELECT FROM LIMIT';
        String objApi = 'Account';
        
        // WHEN
        serviceInstance.initBuild(initialString);
        serviceInstance.object(objApi);

        // THEN
        System.debug(serviceInstance.getQuery());
        System.assertEquals('SELECT FROM Account LIMIT', serviceInstance.getQuery(), 'The SOQL query string should have object api added to the string');
    }

    @IsTest
    static void setFieldsTest()
    {
        // GIVE
        String initialString = 'SELECT FROM ORDER BY Name';
        String fieldsApiByComma = 'Id, Name, Age__c';

        // WHEN
        serviceInstance.initBuild(initialString);
        serviceInstance.fields(fieldsApiByComma);

        // THEN
        System.debug(serviceInstance.getQuery());
        System.assertEquals('SELECT Id,Name,Age__c FROM ORDER BY Name', serviceInstance.getQuery(), 'The SOQL query string should have fields api name added to the string');
    }

    @IsTest
    static void setWhereClausesTest()
    {
        // GIVE
        String initialString = 'SELECT FROM WHERE';
        List<InvocableObjectSelectorWhereClause> whereClauses = new List<InvocableObjectSelectorWhereClause>();
        whereClauses.add(new InvocableObjectSelectorWhereClause('', 'Id', '=', '\'001\''));
        whereClauses.add(new InvocableObjectSelectorWhereClause('AND', 'Name', 'LIKE', '\'%Test Name%\''));
        whereClauses.add(new InvocableObjectSelectorWhereClause('OR', 'Age__c', '>=', '18'));

        // WHEN
        serviceInstance.initBuild(initialString);
        serviceInstance.whereClause(whereClauses);

        // THEN
        System.debug(serviceInstance.getQuery());
        SYstem.assertEquals('SELECT FROM WHERE  Id = \'001\' AND Name LIKE \'%Test Name%\' OR Age__c >= 18', serviceInstance.getQuery(), 'The SOQL query string should have where clauses corretly added to the string');
    }

    @IsTest
    static void setOrderByTest()
    {
        // GIVE
        String initialString = 'SELECT FROM WHERE';
        String orderBy = 'Name';

        // WHEN
        serviceInstance.initBuild(initialString);
        serviceInstance.orderBy(orderBy);

        // THEN
        System.debug(serviceInstance.getQuery());
        System.assertEquals('SELECT FROM WHERE ORDER BY Name', serviceInstance.getQuery(), 'The SOQL query should add the ORDER BY to the string');
    }

    @IsTest
    static void setLimitTest()
    {
        // GIVE
        String initialString = 'SELECT FROM';
        Integer quantity = 3;

        // WHEN
        serviceInstance.initBuild(initialString);
        serviceInstance.limitOf(quantity);

        // THEN
        System.debug(serviceInstance.getQuery());
        System.assertEquals('SELECT FROM LIMIT 3', serviceInstance.getQuery(), 'The SOQL query should add the LIMIT to the string');
    }
}