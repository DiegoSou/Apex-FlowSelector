public inherited sharing class InvocableObjectSelectorImpl implements InvocableObjectSelector
{
    private String queryString;
    
    public String getQuery()
    {
        return this.queryString;
    }

    /** 
     * @param initialString For example 'SELECT FROM WHERE ORDER BY LIMIT'
    */
    public InvocableObjectSelector init(String initialString)
    {
        queryString = initialString;
        return this;
    }
    
    public InvocableObjectSelector object(String objApi)
    {
        String substringBef = queryString.substringBefore('FROM').trim();
        List<String> substringAft = queryString.substringAfter('FROM').split(' ');
        substringAft[0] = objApi.deleteWhitespace();

        queryString = substringBef + ' FROM ' + String.join(substringAft, ' ');
        return this;
    }
    
    public InvocableObjectSelector fields(String fieldsApiByComma)
    {
        String substringBef = 'SELECT';
        List<String> substringAft = queryString.substringAfter('SELECT').split(' ');
        substringAft[0] = fieldsApiByComma.deleteWhitespace();

        queryString = substringBef + ' ' +String.join(substringAft, ' ');
        return this;
    }
    
    /** 
     * @param whereClauses Lista de cláusulas WHERE construídas pela classe WhereClauseFactory
    */
    public InvocableObjectSelector whereClause(String stringFormula, Boolean skipNullable)
    {
        // Criar as cláusulas
        List<WhereClause> whereClauses = new WhereClauseFactory().createWhereClauseListFromString(stringFormula, skipNullable);

        // Execução normal
        String substringBef = queryString.substringBefore('WHERE').trim();
        List<String> substringAft = queryString.substringAfter('WHERE').split(' ');
        
        if(whereClauses == null || whereClauses?.size() <= 0)
        {
            substringAft[0] = '';

            queryString = substringBef + String.join(substringAft, ' ');
            return this;
        }

        List<String> whereClauseBuild = new List<String>();
        Integer clauseSize = whereClauses.size();
        
        for(Integer i = 0; i < clauseSize; i++)
        {
            whereClauseBuild.add('');

            whereClauseBuild[i] += whereClauses[i].logicalOperator + ' ';
            whereClauseBuild[i] += whereClauses[i].fieldApi;
            whereClauseBuild[i] += ' ' + whereClauses[i].comparisonOperator + ' ';
            whereClauseBuild[i] += whereClauses[i].value;
        }

        substringAft[0] = String.join(whereClauseBuild, ' ');
        queryString = substringBef + ' WHERE ' + String.join(substringAft, ' ');
        return this;
    }
    
    public InvocableObjectSelector orderBy(String orderBy)
    {
        String substringBef = queryString.substringBefore('ORDER BY').trim();
        List<String> substringAft = queryString.substringAfter('ORDER BY').split(' ');

        if(orderBy == null)
        {
            substringAft[0] = '';

            queryString = substringBef + String.join(substringAft, ' ');
            return this;
        }
        substringAft[0] = orderBy.trim();

        queryString = substringBef + ' ORDER BY ' + String.join(substringAft, ' ');
        return this;
    }
    
    public InvocableObjectSelector limitOf(Integer quantity)
    {
        String substringBef = queryString.substringBefore('LIMIT').trim();
        List<String> substringAft = queryString.substringAfter('LIMIT').split(' ');

        if(quantity == null)
        {
            substringAft[0] = '';

            queryString = substringBef + String.join(substringAft, ' ');
            return this;
        }
        substringAft[0] = String.valueOf(quantity);

        queryString = substringBef + ' LIMIT ' + String.join(substringAft, ' ');
        return this;
    }

    //
    // Classes
    //

    /** 
     * @description Create "where clauses" for Invocable Object Selector Impl
    */
    public class WhereClauseFactory
    {
        /** 
         * @param stringFormula Ex: fieldApi > {!value}: Decimal AND (fieldApi LIKE {!value}: String OR fieldApi LIKE {!value}: String)
         * @param skipNullable Use para "pular" valores nulos e evitar filtros buscando especificamente pelo valor NULL ou vazio
        */
        public List<WhereClause> createWhereClauseListFromString(String stringFormula, Boolean skipNullable)
        {
            List<WhereClause> whereClauseList = new List<WhereClause>();

            // Verifica se há filtros
            Boolean stringFormulaIsNull = (
                String.isEmpty(stringFormula) ||
                String.isBlank(stringFormula) ||
                String.valueOf(stringFormula) == 'null' ||
                stringFormula == null
            );

            if(stringFormulaIsNull)
            {
                return whereClauseList;
            }

            // Retirar espaços iniciais/finais
            String startString = stringFormula.trim();
            
            // Obter cada condição
            List<String> conditions = startString.split('\\sAND\\s|\\sOR\\s');
            Integer conditionSize = conditions.size();

            // Obter contexto de parenteses
            Boolean openendParenthesis = false;
            Boolean closedParenthesis = false;

            // Percorrer cada condição
            for(Integer i = 0; i < conditionSize; i++)
            {
                String conditionString = conditions[i];

                WhereClause whereClause = new WhereClause(
                    getLogicalOperator(startString, conditionString),
                    getFieldApi(conditionString),
                    getComparisonOperator(conditionString),
                    getValue(conditionString)
                );

                Boolean valueIsNull = (
                    String.valueOf(whereClause.value).contains('null') ||
                    String.valueOf(whereClause.value.deleteWhitespace()).equals('\'\'') ||
                    String.isBlank(whereClause.value)
                );

                if (skipNullable && valueIsNull) 
                {
                    // Adiciona fechamento no índice anterior caso a condição termine com parênteses e tenha sido pulada
                    if (conditionString.endsWith(')') && openendParenthesis)
                    {
                        whereClauseList[i-1].value = whereClauseList[i-1].value + ')';
                    }

                    continue;
                }

                // Só fecha aqueles parenteses que foram abertos, caso tenham sido pulados por terem valor nulo
                if(conditionString.startsWith('('))
                {
                    whereClause.fieldApi = '(' + whereClause.fieldApi;

                    openendParenthesis = true;
                    closedParenthesis = false;
                }
                if(conditionString.endsWith(')') && openendParenthesis)
                {
                    whereClause.value = whereClause.value + ')';
                    
                    openendParenthesis = false;
                    closedParenthesis = true;
                }

                whereClauseList.add(whereClause);
            }

            return whereClauseList;
        }

        /** 
         * @param conditionString fieldApi LIKE {!value}: String
        */
        @TestVisible
        private String getLogicalOperator(String startString, String conditionString)
        {
            String logicalOperator = '';
            Integer indexof = startString.lastIndexOf(conditionString)-1;

            if(indexof > 0)
            {
                if(startString.substring(indexof-3, indexof).trim() == 'AND')
                {
                    logicalOperator = 'AND';
                }
                else
                {
                    logicalOperator = 'OR';
                }
            }

            return logicalOperator;
        }

        /** 
         * @param conditionString fieldApi LIKE {!value}: String
        */
        @TestVisible
        private String getFieldApi(String conditionString)
        {
            String fieldApi = conditionString.split(' ')[0].replaceAll('\\(', '').replaceAll('\\)', '');

            return fieldApi;
        }

        /** 
         * @param conditionString fieldApi LIKE {!value}: String
        */
        @TestVisible
        private String getComparisonOperator(String conditionString)
        {
            String comparisonOperator = conditionString.split(' ')[1];

            return comparisonOperator;
        }
        
        /** 
         * @param conditionString fieldApi LIKE {!value}: String
        */
        @TestVisible
        private String getValue(String conditionString)
        {
            Integer indexAfterComparisonOperator = conditionString.indexOf(conditionString.split(' ')[1]) + conditionString.split(' ')[1].length() + 1;

            String valueAsString = conditionString.substring(
                indexAfterComparisonOperator,
                conditionString.lastIndexOf(':')  
            );

            String typeOfValue = conditionString.substring(conditionString.lastIndexOf(':') + 2).replaceAll('\\(', '').replaceAll('\\)', '');

            String value = InvocableObjectSelectorConverter.convertValueToString(
                JSON.deserialize(JSON.serialize(valueAsString), Type.forName(typeOfValue))
            );

            return value;
        }
    }

    /** 
     * @description Where clauses used by Invocable Object Selector Impl
    */
    public class WhereClause 
    {
        @AuraEnabled
        public String logicalOperator {get;set;}
        @AuraEnabled
        public String fieldApi {get;set;}
        @AuraEnabled
        public String comparisonOperator {get;set;}
        @AuraEnabled
        public String value {get;set;}

        public WhereClause(String logicalOperator, String fieldApi, String comparisonOperator, String value)
        {
            this.logicalOperator = logicalOperator;
            this.fieldApi = fieldApi;
            this.comparisonOperator = comparisonOperator;
            this.value = value;
        }
    }
}