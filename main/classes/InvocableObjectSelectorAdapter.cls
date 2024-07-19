global class InvocableObjectSelectorAdapter
{
    public class RequestModel
    {
        @InvocableVariable(label='Nome do objeto' description='Nome de api do objeto' required=true)
        public String objApi;
        
        @InvocableVariable(label='Campos para retornar' description='Separados por vírgula ex: Id,Name,...' required=true)
        public String fieldsByComma;

        @InvocableVariable(label='Filtros' description='Lista de "InvocableObjectSelectorWhereClause"')
        public List<InvocableObjectSelectorWhereClause> whereClauses;

        @InvocableVariable(label='Ordenar por' description='Nome do campo ex: Name')
        public String orderBy;

        @InvocableVariable(label='Limite de resultados' description='Número ex: 1')
        public Integer quantity;
    }

    public class ResponseModel
    {
        @InvocableVariable(label='Coleção de retorno' description='Coleção para armazenar os registros retornados')
        @AuraEnabled
        public List<SObject> listSObjects;
    }

    @InvocableMethod(label='Obter registros via Apex' description='Retorna uma lista de registros buscados via código apex')
    public static List<ResponseModel> getRecords(List<RequestModel> bulkfiedRequest)
    {
        List<ResponseModel> bulkfiedResponse = new List<ResponseModel>();
        RequestModel request = bulkfiedRequest[0];

        objectSelectorInstance
        .init('')
        .object(request.objApi)
        .fields(request.fieldsByComma)
        .whereClause(request.whereClauses)
        .orderBy(request.orderBy)
        .limitOf(request.quantity);

        ResponseModel response = new ResponseModel();

        System.debug('SOQL Query: ');
        System.debug(objectSelectorInstance.getQuery());

        response.listSObjects = Database.query(objectSelectorInstance.getQuery());

        bulkfiedResponse.add(response);
        return bulkfiedResponse;
    }

    //
    // Instâncias
    //

    @TestVisible
    private static InvocableObjectSelector objectSelectorInstance
    {
        get
        {
            if(objectSelectorInstance == null)
            {
                objectSelectorInstance = new InvocableObjectSelectorImpl();
            }
            return objectSelectorInstance;
        }
        set;
    }
}