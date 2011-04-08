[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.variable.ConfigurePlanVariables" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.variable.ConfigurePlanVariables" --]
[#import "/fragments/variable/variables.ftl" as variables/]

<html>
<head>
    [@ui.header pageKey="plan.variables.title" title=true/]
    <meta name="tab" content="variables"/>
</head>

<body>
[@ui.header pageKey="plan.variables.heading" descriptionKey="plan.variables.description"/]

[@ww.url id="createVariableUrl" namespace="/build/admin/ajax" action="createPlanVariable" planKey=plan.key /]
[@ww.url id="deleteVariableUrl" namespace="/build/admin/ajax" action="deletePlanVariable" planKey=plan.key variableId="VARIABLE_ID"/]

[@variables.configureVariables
    id="planVariables"
    variablesList=action.variables
    createVariableUrl=createVariableUrl
    deleteVariableUrl=deleteVariableUrl/]

<script type="text/javascript">
    BAMBOO.ConfigureVariables.init({
        target: "#planVariables",
        updateVariableUrl: "[@ww.url namespace="/build/admin/ajax" action="updatePlanVariable" planKey=plan.key/]"
    });
</script>

</body>
</html>
