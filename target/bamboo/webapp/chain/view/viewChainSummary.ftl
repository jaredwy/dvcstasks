[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainSummary" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainSummary" --]
[#if user??]
    [#assign rssSuffix="&amp;os_authType=basic" /]
[#else]
    [#assign rssSuffix="" /]
[/#if]
<html>
<head>
    <title>[@ui.header pageKey='chain.summary.title.long' object=plan.name title=true /]</title>
    <link rel="alternate" type="application/rss+xml" title="&ldquo;${plan.name}&rdquo; all builds RSS feed" href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssAll&amp;buildKey=${plan.key}${rssSuffix}" />
    <link rel="alternate" type="application/rss+xml" title="&ldquo;${plan.name}&rdquo; failed builds RSS feed" href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssFailed&amp;buildKey=${plan.key}${rssSuffix}" />    
    <meta name="tab" content="summary"/>
</head>
<body>
[#include "/fragments/plan/displayPlanSummary.ftl" /]
</body>
</html>
