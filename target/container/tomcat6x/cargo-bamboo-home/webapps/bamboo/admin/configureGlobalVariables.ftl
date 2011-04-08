[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.variable.ConfigureGlobalVariables" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.variable.ConfigureGlobalVariables" --]
[#import "/fragments/variable/variables.ftl" as variables/]

<html>
<head>
    [@ui.header pageKey="globalVariables.title" title=true/]
</head>

<body>
[@ui.header pageKey="globalVariables.heading" descriptionKey="globalVariables.description"/]

[@ww.url id="createVariableUrl" namespace="/admin" action="createGlobalVariable" /]
[@ww.url id="deleteVariableUrl" namespace="/admin" action="deleteGlobalVariable" variableId="VARIABLE_ID"/]

[@variables.configureVariables
    id="globalVariables"
    variablesList=action.variables
    createVariableUrl=createVariableUrl
    deleteVariableUrl=deleteVariableUrl/]

<script type="text/javascript">
    BAMBOO.ConfigureVariables.init({
        target: "#globalVariables",
        updateVariableUrl: "[@ww.url namespace="/admin" action="updateGlobalVariable" /]"
    });
</script>

</body>
</html>
