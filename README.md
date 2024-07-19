# Instalar
<a href="https://githubsfdeploy.herokuapp.com?owner=DiegoSou&repo=InvocableObjectSelector&ref=main">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

---

# Documentação e objetivo

O problema que originou a criação da lib foi a necessidade de desconsiderar os valores nulos e não selecionados dos filtros de um formulário em um Fluxo de Tela.

<br>

A lib conta com uma classe que simula o "GetRecords" do flow, chamada `InvocableObjectSelectorAdapter`, que aceita os filtros no formato de um campo fórmula.
