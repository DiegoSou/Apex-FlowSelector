/**
 * @description Convert values passed in where conditions to string format
 */
public class InvocableObjectSelectorConverter 
{
    public static String convertValueToString(Object o)
    {
        String retorno = '';

        if(o instanceof List<String>)
        {
            retorno += '(';
            for(String str : (List<String>) o) {retorno += '\'' +(String) str + '\',';}
            if(retorno.length() == 1) {retorno += ')';}
            else {retorno = retorno.subString(0, retorno.length()-1) + ')';}
        }
        else if(o instanceof Set<String>)
        {
            retorno += '(';
            for(String str : (Set<String>) o) {retorno += '\'' +(String) str + '\',';}
            if(retorno.length() == 1) {retorno += ')';}
            else {retorno = retorno.subString(0, retorno.length()-1) + ')';}
        }
        else if(o instanceof Set<Id>)
        {
            retorno += '(';
            for(String str : (Set<Id>) o) {retorno += '\'' + (String) str + '\',';}
            if(retorno.length() == 1) {retorno += ')';}
            else {retorno = retorno.subString(0, retorno.length()-1) + ')';}
        }
        else if(o instanceof List<Id>)
        {
            retorno += '(';
            for(String str : (List<Id>) o) {retorno += '\'' +(String) str + '\',';}
            if(retorno.length() == 1) {retorno += ')';}
            else {retorno = retorno.subString(0, retorno.length()-1) + ')';}
        }
        else if(o instanceof List<Decimal>)
        {
            retorno += '(';
            for(Decimal str : (List<Decimal>) o) {retorno += str + ',';}
            if(retorno.length() == 1) {retorno += ')';}
            else {retorno = retorno.subString(0, retorno.length()-1) + ')';}
        }
        else if(o instanceof Set<Integer>)
        {
            retorno += '(';
            for(Integer str : (Set<Integer>) o) {retorno += str + ',';}
            if(retorno.length() == 1) {retorno += ')';}
            else {retorno = retorno.subString(0, retorno.length()-1) + ')';}
        }
        else if(o instanceof String) {retorno += '\''+o+'\'';}
        else if(o instanceof Decimal) {retorno += ''+o+'';}
        else if(o instanceof Datetime) 
        {
            if(String.valueOf(o).contains('00:00:00')) {retorno = ((Datetime) o).formatGMT('yyyy-MM-dd');}
            else {retorno = ((Datetime) o).formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');}
        }
        else if(o instanceof List<Date>)
        {
            retorno += '(';
            for(Date dateValue : (List<Date>) o) {retorno += '' +string.valueOf(dateValue) + ',';}
            if(retorno.length() == 1) {retorno += ')';}
            else {retorno = retorno.subString(0, retorno.length()-1) + ')';}
        }
        else if(o instanceof Boolean) {retorno = String.valueOf(o);}
        
        if(o == null) { retorno = 'null'; }
        if(retorno == '()') { retorno = '(null)'; }
            
        return retorno;
    }    
}