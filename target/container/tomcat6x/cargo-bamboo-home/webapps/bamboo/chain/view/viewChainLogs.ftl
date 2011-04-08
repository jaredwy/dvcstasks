[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainLogs" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainLogs" --]
[#-- @ftlvariable name="resultsSummary" type="com.atlassian.bamboo.chains.ChainResultsSummary" --]

<html>
<head>
	<title> [@ui.header pageKey='Logs' object='${plan.key} ${(resultsSummary.buildNumber)!}' title=true /]</title>
    <meta name="tab" content="logs"/>
</head>

<body>
    [@ui.header pageKey='Logs' /]
    [#if resultsSummary??]
        [@ww.text name='chainResult.logs.description'/]
        [@displayAllLogs /]
    [#else]
        <p>[@ww.text name='chainResult.logs.noLogsFound'/]</p>
    [/#if]

</body>
</html>

[#macro displayAllLogs]
    <table id="job-logs" class="aui">
        <colgroup>
            <col />
            <col width="250px"/>
        </colgroup>
        <thead>
            <th>[@ww.text name="Job"/]</th>
            <th>[@ww.text name="Logs"/]</th>
        </thead>
        <tbody>
            [#list resultsSummary.stageResults as stageResult]
                [#list stageResult.sortedBuildResults as buildResult]
                    <tr>
                        <td>
                            [#if buildResult.finished]
                                [#assign iconClass=buildResult.buildState /]
                            [#else]
                                [#assign iconClass=buildResult.lifeCycleState /]
                            [/#if]
                            [@ui.icon type=iconClass/]
                            <a href="${req.contextPath}/browse/${buildResult.buildKey}-${buildResult.buildNumber}">${buildResult.plan.buildName?html}</a>
                            <span class="subGrey">${stageResult.name}</span>
                        </td>
                        [#if buildResult.finished || buildResult.inProgress]
                            <td>
                                <a href="${req.contextPath}/browse/${buildResult.buildKey}-${buildResult.buildNumber}/log">[@ww.text name='chainResult.logs.view'/]</a>
                                &nbsp;|&nbsp;
                                <a href="${req.contextPath}/download/${buildResult.buildKey}/build_logs/${buildResult.buildKey}-${buildResult.buildNumber}.log">[@ww.text name='chainResult.logs.download'/]</a>
                                [#if buildResult.inProgress]
                                    <span class="grey">[@ww.text name='chainResult.logs.partial'/]</span>
                                [/#if]
                            </td>
                        [#else]
                            <td><span class="grey">[@ww.text name='chainResult.logs.noLogsAvailable'/]</span></td>
                        [/#if]
                    </tr>
                [/#list]
            [/#list]
        </tbody>
    </table>
[/#macro]