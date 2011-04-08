[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ViewBuild" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ViewBuild" --]
[#if user??]
    [#assign rssSuffix="&amp;os_authType=basic" /]
[#else]
    [#assign rssSuffix="" /]
[/#if]
        
<html>
<head>
    <title>${build.name}: Builds</title>
    <link rel="alternate" type="application/rss+xml" title="Bamboo RSS feed" href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssAll&buildKey=${build.key}${rssSuffix}" />
    <meta name="tab" content="results"/>
</head>

<body>
    [@ui.header pageKey='build.results.title' /]
    [@ww.action name="viewBuildResultsTable" namespace="/build" executeResult="true" ]
        [@ww.param name="showAgent" value="true"/]
        [@ww.param name="sort" value="true"/]
        [@ww.param name="singlePlan" value="true"/]
    [/@ww.action]
    <ul>
        <li>Successful builds are <font color="green">green</font>, failed builds are <font color="red">red</font>.</li>
        <li>This plan has been built ${build.lastBuildNumber} times.</li>
        [#if build.averageBuildDuration??]
            <li>The average build time for recent builds is approximately ${durationUtils.getPrettyPrint(build.averageBuildDuration)}</li>
        [/#if]

        [#assign buildStrategy='${build.buildDefinition.buildStrategy.key}' /]
        [#if  buildStrategy='manualOnly' ]
            <li>Bamboo builds everything whenever a user manually triggers a build.</li>
        [#elseif buildStrategy='schedule' || buildStrategy='daily']
            <li>Bamboo builds everything according to the schedule specified.</li>
        [#else]
            <li>Bamboo builds everything whenever [#if build.buildDefinition.repository??]the ${build.buildDefinition.repository.name}[/#if] source code repository changes.</li>
        [/#if]

        <li>
            <a href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssAll&buildKey=${build.key}${rssSuffix}"><img src="${req.contextPath}/images/rss.gif" border="0" hspace="2" align="absmiddle" title="Point your rss reader at this link to get the full ${build.name} build feed"></a>
            Feed for all <a href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssAll&buildKey=${build.key}${rssSuffix}" alt="Point your rss reader at this link to get the full ${build.name} build feed">builds</a>
            or just the <a href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssFailed&buildKey=${build.key}${rssSuffix}" alt="Point your rss reader at this link to get just the failed ${build.name} build feed">failed builds</a>.
        </li>
    </ul>
</body>
</html>