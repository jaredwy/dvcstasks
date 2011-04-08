[#-- @ftlvariable name="action" type="com.atlassian.bamboo.plugins.jiraPlugin.actions.ajax.ViewBuildResultsByJiraKey"  --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.plugins.jiraPlugin.actions.ajax.ViewBuildResultsByJiraKey" --]

[#--used for jira bamboo plugin--]
[#import "/fragments/plan/displayWideBuildPlansList.ftl" as planList]
<html>
<head>
   <title>
        Builds related to JIRA Issue
    </title>
    <link rel="stylesheet" href="[@cp.getStaticResourcePrefix /]/styles/buildResultsList.css" type="text/css" />
</head>
<body>

[#if resultsList?has_content]

[#if selectedSubTab?? && selectedSubTab == "buildByPlan"]
    [@ww.action name="viewBuildResultsTableByPlans" namespace="/build" executeResult="true" ]
    [/@ww.action]
[#elseif selectedSubTab?? && selectedSubTab == "planStatus"]
    <ol class="build_result_list">
    [#list resultsList as summary]
        [@planList.showBuildResultSummary summary=summary/]
    [/#list]
    </ol>
[#else]
    [@ww.action name="viewBuildResultsIssueFocussed" namespace="/build" executeResult="true" ]
       [@ww.param name="sort" value="true"/]
    [/@ww.action]
[/#if]
[#else]
    <p>
        [@ww.text name='jira.issues.none' /]
    </p>
[/#if]

</body>
</html>