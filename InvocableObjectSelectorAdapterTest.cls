@IsTest
private class InvocableObjectSelectorAdapterTest 
{
    public static InvocableObjectSelector serviceStub = (InvocableObjectSelector) Test.createStub(InvocableObjectSelector.class, new InvocableObjectSelectorStub());

    @IsTest
    static void getRecordsTest()
    {
        // GIVE
        InvocableObjectSelectorAdapter.objectSelectorInstance = serviceStub;
        InvocableObjectSelectorAdapter.RequestModel request = new InvocableObjectSelectorAdapter.RequestModel();
        request.objApi = 'Account';
        request.fieldsByComma = 'Id,Name';
        request.whereClauses = null;
        request.orderBy = 'Name';
        request.quantity = 1;

        // WHEN
        InvocableObjectSelectorAdapter.ResponseModel result = InvocableObjectSelectorAdapter.getRecords(
            new List<InvocableObjectSelectorAdapter.RequestModel>{request}
        )[0];

        // THEN
        System.assertEquals('Test Name', result.listSObjects[0].get('Name'), 'The result should encapsulate the stub result');
    }

    public class InvocableObjectSelectorStub implements System.StubProvider
    {
        public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames, List<Object> listOfArgs)
        {
            Object returnValue;

            if(stubbedMethodName == 'query')
            {
                Account sobjectReturn = new Account(Name='Test Name');
                returnValue = new List<SObject>{sobjectReturn};
            }
            else
            {
                returnValue = serviceStub;
            }

            return returnValue;
        }
    }
}