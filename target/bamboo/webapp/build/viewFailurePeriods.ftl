[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ViewBuild" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ViewBuild" --]

[#import "/fragments/statistics/recentFailures.ftl" as recentFailures]

[#if user??]
    [#assign rssSuffix="&amp;os_authType=basic" /]
[#else]
    [#assign rssSuffix="" /]
[/#if]
<html>
<head>
    <title>[@ui.header pageKey='build.failures.title.long' object='${build.name}' title=true /]</title>
    <link rel="alternate" type="application/rss+xml" title="&ldquo;${plan.name}&rdquo; all builds RSS feed" href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssAll&amp;buildKey=${build.key}${rssSuffix}" />
    <link rel="alternate" type="application/rss+xml" title="&ldquo;${plan.name}&rdquo; failed builds RSS feed" href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssFailed&amp;buildKey=${build.key}${rssSuffix}" />
    <meta name="tab" content="failures"/>
</head>
<body>
    [@recentFailures.showSummary maxResults=-1/]
</body>
</html>