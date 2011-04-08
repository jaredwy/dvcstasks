[#-- @ftlvariable name="action" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.webwork.StarterAction" --]

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

[@cp.dashboardSubMenu selectedTab="currentTab"]
        [@ww.action namespace='/ajax' name='displayCurrentActivity' executeResult='true' /]
[/@cp.dashboardSubMenu]
</body>
</html>
