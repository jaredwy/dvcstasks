[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ViewBuild" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ViewBuild" --]
[#import "/fragments/plan/displayWideBuildPlansList.ftl" as planList]
[#import "/fragments/statistics/recentFailures.ftl" as recentFailures]
[#if user??]
    [#assign rssSuffix="&amp;os_authType=basic" /]
[#else]
    [#assign rssSuffix="" /]
[/#if]
<html>
<head>
    <title>[@ui.header pageKey='build.summary.title.long' object=build.name title=true /]</title>
    <link rel="alternate" type="application/rss+xml" title="&ldquo;${build.name}&rdquo; all builds RSS feed" href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssAll&amp;buildKey=${build.key}${rssSuffix}" />
    <link rel="alternate" type="application/rss+xml" title="&ldquo;${build.name}&rdquo; failed builds RSS feed" href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssFailed&amp;buildKey=${build.key}${rssSuffix}" />
    <meta name="tab" content="summary"/>
</head>
<body>
[#include "/fragments/plan/displayPlanSummary.ftl" /]
</body>
</html>