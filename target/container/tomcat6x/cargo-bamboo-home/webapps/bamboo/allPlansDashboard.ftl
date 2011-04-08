[#-- @ftlvariable name="action" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#import "/fragments/plan/displayWideBuildPlansList.ftl" as planList]

[#if user??]
    [#assign rssSuffix="&amp;os_authType=basic" /]
[#else]
     [#assign rssSuffix="" /]
[/#if]
<html>
<head>
    <title>[@ww.text name='dashboard.title' /]</title>
    <link rel="alternate" type="application/rss+xml" title="Bamboo RSS feed" href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssAll${rssSuffix}"/>
</head>
<body>

<h1>${instanceName?html}</h1>

[@cp.dashboardSubMenu selectedTab="allPlansTab"]
    <div id="allPlansToggler">
        <a class="collapseAll">[@ww.text name="global.buttons.collapse.all"/]</a> | <a class="expandAll">[@ww.text name="global.buttons.expand.all"/]</a>
    </div>
    <div id="allPlansSection">
        [#include "/fragments/errorAjaxRefresh.ftl"]
        [@planList.displayWideBuildPlansList builds=plans /]
    </div>
    [#include "/fragments/showSystemErrors.ftl"]
[/@cp.dashboardSubMenu]

</body>
</html>
