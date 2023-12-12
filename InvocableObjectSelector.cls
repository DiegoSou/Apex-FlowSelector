/** 
 * @description Serviço de montagem de querys
*/
public interface InvocableObjectSelector 
{
    InvocableObjectSelector init(String initialString);
    InvocableObjectSelector object(String objApi);
    InvocableObjectSelector fields(String fieldsApiByComma);
    InvocableObjectSelector whereClause(String stringFormula, Boolean skipNullable);
    InvocableObjectSelector orderBy(String orderBy);
    InvocableObjectSelector limitOf(Integer quantity);

    String getQuery();
}