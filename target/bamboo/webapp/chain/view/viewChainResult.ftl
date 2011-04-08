[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainResult" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainResult" --]
[#-- @ftlvariable name="resultsSummary" type="com.atlassian.bamboo.chains.ChainResultsSummary" --]

<html>
<head>
	<title>[@ui.header pageKey='chainResult.summary.title' object='${plan.name} ${chainResultNumber}' title=true /]</title>
    <meta name="tab" content="result"/>
</head>

<body>
[#import "/lib/resultSummary.ftl" as ps]
[#import "/lib/chains.ftl" as chains]
[#import "/lib/tests.ftl" as tests]

[@ww.url id='stopBuildUrl' action='stopPlan' namespace='/build/admin/ajax' planResultKey='${chainResult.buildResultKey}' /]
[#assign testSummary = chainResult.testResultsSummary /]
[#assign testResults = filteredTestResults /]
[#assign hasNewFailingTests = testSummary.newFailedTestCaseCount gt 0 /]
[#assign hasExistingFailedTests = testSummary.existingFailedTestCount gt 0 /]
[#assign hasFixedTests = testSummary.fixedTestCaseCount gt 0 /]

[@ui.header pageKey='chainResult.summary.title' /]
<div class="result-summary">
    <div class="details">
        [@ps.brsStatusBox buildSummary=resultsSummary stopBuildUrl=stopBuildUrl prefix="chainResult" /]
        [@displaySharedChainArtifacts buildSummary=resultsSummary /]
        [#if plan.hasTests() && chainResult.finished]
            <div class="test-summary">
                [#if testSummary.totalTestCaseCount > 0]
                    <div class="toolbar">
                        [@ww.text name="buildResult.tests.summary.testsTotal"][@ww.param name="value" value=testSummary.totalTestCaseCount /][/@ww.text]
                    </div>
                [/#if]
                <h2>[@ww.text name='buildResult.tests.summary.title'/]</h2>
                <ul>
                    <li class="new-failures">[#if hasNewFailingTests]<a href="#new-failed-tests">${testSummary.newFailedTestCaseCount} <span>[@ww.text name='chain.summary.test.newFailures'/]</span></a>[#else]${testSummary.newFailedTestCaseCount} <span>[@ww.text name='chain.summary.test.newFailures'/]</span>[/#if]</li>
                    <li class="existing-failures">[#if hasExistingFailedTests]<a href="#existing-failed-tests">${testSummary.existingFailedTestCount} <span>[@ww.text name='chain.summary.test.existingFailures'/]</span></a>[#else]${testSummary.existingFailedTestCount} <span>[@ww.text name='chain.summary.test.existingFailures'/]</span>[/#if]</li>
                    <li class="fixed">[#if hasFixedTests]<a href="#fixed-tests">${testSummary.fixedTestCaseCount} <span>[@ww.text name='chain.summary.test.fixed'/]</span></a>[#else]${testSummary.fixedTestCaseCount} <span>[@ww.text name='chain.summary.test.fixed'/]</span>[/#if]</li>
                </ul>
            </div>
        [/#if]
    </div>
    [@ps.showChanges plan resultsSummary /]
    [@cp.displayJiraIssuesSummary resultsSummary /]
    [@cp.displayComments chainResult currentUrl commentMode!false/]
    [@cp.displayManualVariables chainResult /]
</div>
[#if chainResult.finished && testResults?? && (hasNewFailingTests || hasExistingFailedTests || hasFixedTests)]
    <div class="tests">
        <h2>[@ww.text name='buildResult.testClass.tests'/]</h2>
        [@tests.displayTestSummary testResults=testResults testSummary=testSummary showJob=true /]
    </div>
[/#if]

[#-- Show errors section if failed, no failed tests and only one failed job --]
[#if chainResult.finished && chainResult.failed && testSummary.failedTestCaseCount == 0]
    [#assign failedJobResults = chainResult.failedJobResults /]
    [#if failedJobResults.size() == 1 ]
        [#assign brs = failedJobResults[0] /]
        [@ww.text id="errorSummaryHeader" name='buildResult.error.summary.chain.title' ]
            [@ww.param][@ww.url value='/browse/${brs.buildResultKey}/' /][/@ww.param]
            [@ww.param]${brs.plan.buildName}[/@ww.param]
        [/@ww.text]
        [@ps.showBuildErrors buildResultSummary=brs extraBuildResultsData=brs.extraBuildResultsData type="chain" header=errorSummaryHeader /]
    [/#if]
[/#if]

[#if chainResult.finished || chainResult.notBuilt]
    [@cp.displayErrorsForResult planResult=chainResult errorAccessor=errorAccessor manualReturnUrl='/browse/${chainResult.buildResultKey}'/]
[/#if]

[#-- ============================================================================================== Logs Section --]

[#if chainResult.inProgress]
    <h2 id="jobLogDisplay">
        [#assign resultSummaries=jobResultSummaries /]
        [#if resultSummaries?size > 1]
            <label for="jobResultKeyForLogDisplay">[@ww.text name="build.logs.displayForJob" /]</label>
            [@ww.select id="jobResultKeyForLogDisplay" name="jobResultKeyForLogDisplay" list=jobResultSummaries listKey="buildResultKey" listValue="plan.buildName" groupBy="plan.stage.name" theme="simple"/]
        [#elseif resultSummaries?size == 1]
            [@ww.text name="build.logs.displayForOneJob"][@ww.param]${resultSummaries.get(0).plan.buildName}[/@ww.param][/@ww.text]
            [@ww.hidden id="jobResultKeyForLogDisplay" value="${resultSummaries.get(0).buildResultKey}" /]
        [/#if]
    </h2>
    <div id="buildResultSummaryLogs">
        <table id="buildLog" class="hidden">
            <tbody></tbody>
        </table>
        <p class="loading">[@ui.icon type="loading" /]&nbsp;[@ww.text name="build.logs.fetching" /]</p>
        <p>[@ww.text name="build.logs.linesToDisplay" ]
            [@ww.param][@ww.select id="linesToDisplay" name="linesToDisplay" list=[10, 25, 50, 100] theme="simple"/][/@ww.param]
        [/@ww.text]</p>
    </div>
    <div id="buildResultSummaryLogMessage"></div>

    <script type="text/x-template" title="logTableRow-template">
        <tr><td class="time">{time}</td><td class="buildOutputLog">{log}</td></tr>
    </script>

    <script type="text/x-template" title="logMessagePending-template">
        <p>[@ww.text name="chainResult.summary.job.pending" ][@ww.param]{job}[/@ww.param][/@ww.text]</p>
    </script>

    <script type="text/x-template" title="logMessageQueued-template">
        <p>[@ww.text name="chainResult.summary.job.queued" ][@ww.param]{job}[/@ww.param][/@ww.text]</p>
    </script>

    <script type="text/x-template" title="logMessageFinished-template">
        <p>[@ww.text name="chainResult.summary.job.finished" ][@ww.param]{job}[/@ww.param][/@ww.text]</p>
    </script>

    <script type="text/javascript">
        AJS.$(function () {
            BuildResultSummaryLiveActivity.init({
                getBuildUrl: "[@ww.url value='/rest/api/latest/result/@KEY@' /]",
                templates: {
                    logMessagePending: "logMessagePending-template",
                    logMessageQueued: "logMessageQueued-template",
                    logMessageFinished: "logMessageFinished-template",
                    logTableRow: "logTableRow-template"
                }
            });
        });
    </script>
[/#if]
</body>
</html>

[#macro displaySharedChainArtifacts buildSummary limit=3]
    [@ww.url id="artifactsTabUrl" value='/browse/${chainResult.buildResultKey}/artifact' /]
    [#assign sharedArtifactsFound = action.hasSharedArtifacts(buildSummary)/]
    [#if sharedArtifactsFound]
        <div id="shared-artifacts">
            <div class="toolbar">
                <a href="${artifactsTabUrl}">[@ww.text name="artifact.shared.viewall"/]</a>
            </div>
            <h2>[@ww.text name='artifact.shared.title'/]</h2>
            <ul>
                [#assign count = 0]
                [#list buildSummary.stageResults as stageResult]
                    [#list stageResult.getSortedBuildResults() as buildResult]
                        [#assign artifactLinks = action.getSharedArtifactLinks(buildResult)!/]
                        [#list artifactLinks as artifact]
                            [#if count lt limit]
                                <li>
                                    [@ui.icon type="artifact-shared" /]
                                    [#if artifact.exists]
                                        <a id="artifact-${artifact.label?html}" href="${req.contextPath}${artifact.url}">${artifact.label?html}</a>
                                        [#if artifact.sizeDescription??]
                                            <span class="filesize">(${artifact.sizeDescription})</span>
                                        [/#if]
                                    [#else]
                                        <span id="artifact-${artifact.label?html}">${artifact.label?html}</span>
                                        <span class="filesize">([@ww.text name='buildResult.artifacts.not.exists' /])</span>
                                    [/#if]
                                </li>
                            [/#if]
                            [#assign count = count + 1]
                        [/#list]
                    [/#list]
                [/#list]
            </ul>
            [#if count gt limit]
                <p><a href="${artifactsTabUrl}">[@ww.text name='artifact.shared.showinglimit'][@ww.param value=count-limit/][/@ww.text]</a></p>
            [/#if]
        </div>
    [/#if]
[/#macro]