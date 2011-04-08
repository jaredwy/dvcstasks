[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.project.ViewProject" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.project.ViewProject" --]

[#import "/fragments/plan/displayWideBuildPlansList.ftl" as planList]

<html>
<head>
    <title>[@ui.header pageKey='project.summary.title' object='${project.name}' title=true /]</title>
</head>

<body>
[#import "/lib/menus.ftl" as menu/]
[@menu.displayExternalOperations]
    <li>
        <a href="${req.contextPath}/telemetry.action?filter=project&amp;projectKey=${projectKey}">[@ui.icon type="wallboard" /][@ww.text name="dashboard.wallboard.project"/]</a>
    </li>
[/@menu.displayExternalOperations]
[@planList.displayWideBuildPlansList builds=plans showProject=false/]
</body>
</html>