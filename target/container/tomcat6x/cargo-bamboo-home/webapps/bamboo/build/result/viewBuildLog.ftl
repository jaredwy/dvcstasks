[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ViewPreviousBuildResults" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ViewPreviousBuildResults" --]

<html>
<head>
	<title> [@ui.header pageKey='buildResult.logs.title' object='${build.name} ${buildResultsSummary.buildNumber}' title=true /]</title>
    <meta name="tab" content="logs"/>
</head>

<body>
    [@ui.header pageKey='buildResult.logs.title' /]
    [#if buildLogs?has_content]
        <p>
            [@ww.text name='buildResult.logs.totalLines' ][@ww.param value=totalLines /][/@ww.text]
            [#if buildLogsTooLong]
                [@ww.text name='buildResult.logs.outputTruncated' ][@ww.param value=maxLinesToShow /][/@ww.text]
            [/#if]
            [#if !action.buildResultsSummary.inProgress]
                <a id="logs-viewJobSummary" href="${req.contextPath}/browse/${buildResultsSummary.buildResultKey}">[@ww.text name='buildResult.logs.view.livelogs'/]</a>
                &nbsp;|&nbsp;
            [/#if]
            <a id="logs-downloadLog" href="${req.contextPath}/download/${build.key}/build_logs/${buildResultsSummary.buildResultKey}.log">[@ww.text name='buildResult.logs.downloadFullLog'/]</a>.
        </p>

        [@ui.displayLogLines buildLogs /]
    [#else]
        <p>[@ww.text name='buildResult.logs.noLogsFound'/]</p>
    [/#if]
</body>
</html>