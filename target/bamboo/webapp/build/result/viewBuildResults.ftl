[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ViewBuildResults" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ViewBuildResults" --]

[#import "/lib/resultSummary.ftl" as ps]
[#import "/lib/build.ftl" as bd]
[#import "/lib/tests.ftl" as tests]

[@ww.text id='cancelBuildText' name='agent.build.cancel' /]

[#assign buildResult=buildResults! /]
[#assign buildSummary=buildResultsSummary /]
[#assign testResults=filteredTestResults! /]
[#assign testSummary= buildSummary.testResultsSummary /]
[#assign buildResultKey=buildSummary.buildResultKey /]
[#assign buildLifeCycleState=buildSummary.lifeCycleState /]


[@ww.url id='viewFailedTestsUrl'
    action='viewBuildResultsFailedTests'
    namespace='/build/result'
    buildNumber='${buildSummary.buildNumber}'
    buildKey='${build.key}'/]
[@ww.url id='viewSuccessfulTestsUrl'
    action='viewBuildResultsSuccessfulTests'
    namespace='/build/result'
    buildNumber='${buildSummary.buildNumber}'
    buildKey='${build.key}'/]
[@ww.url id='manageElasticInstancesUrl'
    action='manageElasticInstances'
    namespace='/admin/elastic'/]
[@ww.url id='viewAgentsUrl'
    action='viewAgents'
    namespace='/agent'
    planKey=build.key
    returnUrl=currentUrl/]
[@ww.url id='stopBuildUrl'
    action='stopPlan'
    namespace='/build/admin/ajax'
    planResultKey=buildResultKey/]

<html>
<head>
	<title> [@ui.header pageKey='buildResult.summary.title' object='${build.name} ${buildSummary.buildNumber}' title=true /]</title>
    <meta name="tab" content="summary"/>
</head>

<body>
[@ui.header pageKey='buildResult.summary.title' /]
[#if buildSummary.inProgress]
    [#if currentlyBuilding??]
            [#assign agent = action.getAgent(currentlyBuilding)!/]
    [/#if]
[#elseif buildSummary.finished || buildSummary.notBuilt]
    [#assign agent = action.getAgent(buildSummary)!/]
[/#if]
    [#-- ============================================================================================= Header Section --]
    [@ww.url id='currentBuildUrl' value='/browse/${buildResultKey}' /]
    <div class="result-summary">
        <div class="details">
            [@ps.brsStatusBox resultsSummary stopBuildUrl agent! /]
        </div>
        [@ps.showChanges plan resultsSummary /]
        [@cp.displayJiraIssuesSummary resultsSummary /]
        [@cp.displayComments resultsSummary currentUrl commentMode!false/]
        [@cp.displayManualVariables resultsSummary /]
    </div>


    [#-- ============================================================================================= Tests Section --]

    [#if buildSummary?has_content && buildSummary.finished && testResults?? && testSummary.totalTestCaseCount > 0]
        <div class="tests">
            [@ww.url value='/browse/${buildSummary.buildResultKey}/test' id='testUrl' /]

            [#assign hasExistingFailedTests=testSummary.existingFailedTestCount gt 0 /]
            [#assign hasNewlyFailingTests=testSummary.newFailedTestCaseCount gt 0 /]
            [#assign hasFixedTests=testSummary.fixedTestCaseCount gt 0 /]


            <p id="resultSummaryTests_toggler_off" class="headingInfo">
                <a class="toggleOff">Expand</a>
            </p>
            <p id="resultSummaryTests_toggler_on" class="headingInfo">
                <a class="toggleOn">Collapse</a>
            </p>
            [@cp.toggleDisplayByGroup toggleGroup_id='resultSummaryTests' jsRestore=true/]
            <h2>
                <a href="${testUrl}">Tests</a>
                [#if user??]
                    [@ui.displayIdeIcon/]
                [/#if]
            </h2>
            <div id="resultSummaryTests_target">
                <ul id="testsSummary">
                    <li id="testsSummaryTotal">
                        <strong>${testSummary.totalTestCaseCount}</strong> tests in total
                    </li>
                [#if testSummary.hasFailedTestResults() ]
                    <li id="testsSummaryFailed">
                        [@ui.icon type="failed"/]
                        [@ww.text name='buildResult.tests.summary.failedTotal']
                            [@ww.param name="value" value=testSummary.failedTestCaseCount /]
                        [/@ww.text]
                    </li>
                [/#if]
                [#if hasNewlyFailingTests?? && hasNewlyFailingTests]
                    <li id="testsSummaryFixed">
                        <strong class="failedLabel">${testSummary.newFailedTestCaseCount}</strong> are new failure(s)
                    </li>
                [/#if]
                    <li  id="testsSummaryDuration">
                        <strong>${durationUtils.getPrettyPrint(testSummary.totalTestDuration)}</strong> taken in total.
                    </li>
                [#if hasFixedTests]
                    <li id="testsSummaryFixed">
                        <strong class="successfulLabel">${testSummary.fixedTestCaseCount}</strong> tests were fixed
                    </li>
                [/#if]
                </ul>

                [@tests.displayTestSummary testResults=testResults testSummary=testSummary /]
            </div>
        </div>
    [/#if]

    [#-- ============================================================================================== Logs Section --]

    [#if buildSummary.inProgress]
        <div id="logs" class="section">
            <p id="resultSummaryLogs_toggler_off" class="headingInfo">
                <a class="toggleOff">Expand</a>
            </p>
            <p id="resultSummaryLogs_toggler_on" class="headingInfo">
                <a class="toggleOn">Collapse</a>
            </p>
            [@cp.toggleDisplayByGroup toggleGroup_id='resultSummaryLogs' jsRestore=true/]
            <h2>[@ww.text name="build.logs.title" /]</h2>
            <div id="resultSummaryLogs_target">
                <table id="buildLog" class="hidden">
                    <tbody></tbody>
                </table>
                <p class="loading">[@ui.icon type="loading" /]&nbsp;[@ww.text name="build.logs.fetching" /]</p>
                <p>[@ww.text name="build.logs.linesToDisplay" ]
                    [@ww.param][@ww.select id="linesToDisplay" name="linesToDisplay" list=[10, 25, 50, 100] theme="simple"/][/@ww.param]
                [/@ww.text]</p>
            </div>
        </div> <!-- END #logs -->
    [/#if]

    [#-- ============================================================================================= Errors Section --]

    [@ps.showBuildErrors buildResultSummary=buildSummary extraBuildResultsData=buildResults /]



    [#if buildSummary.active]

        [@ww.url id='getBuildUrl' value='/rest/api/latest/result/${buildResultKey}' /]
        [@ww.url id="reloadUrl" value="/browse/${buildResultKey}"/]
        [@ww.text id='cancellingBuildText' name='agent.build.cancelling' /]

        <script type="text/x-template" title="disabledStopButton-template">
            <span class="build-stop-disabled" title="${cancellingBuildText}">${cancellingBuildText}</span>
        </script>

        <script type="text/x-template" title="logTableRow-template">
            <tr><td class="time">{time}</td><td class="buildOutputLog">{log}</td></tr>
        </script>

        <script type="text/x-template" title="progressOverAverage-template">
            [@ww.text name="build.currentactivity.build.overaverage"]
                [@ww.param]{elapsed}[/@ww.param]
            [/@ww.text]
        </script>

        <script type="text/x-template" title="progressUnderAverage-template">
            [@ww.text name="build.currentactivity.build.underaverage"]
                [@ww.param]{elapsed}[/@ww.param]
                [@ww.param]{remaining}[/@ww.param]
            [/@ww.text]
        </script>

        <script type="text/x-template" title="queueDurationDescription-template">
            [@ww.text name="queue.status.waiting.queueDurationDescription"]
                [@ww.param]{durationDescription}[/@ww.param]
            [/@ww.text]
        </script>

        <script type="text/x-template" title="queuePositionDescription-template">
            [@ww.text name="queue.status.waiting.queuePositionDescription"]
                [@ww.param]{position}[/@ww.param]
                [@ww.param]{length}[/@ww.param]
            [/@ww.text]
        </script>

        <script type="text/x-template" title="updatingSourceFor-template">
            [@ww.text name="build.currentactivity.build.updatingSourceFor"]
                [@ww.param]{prettyVcsUpdateDuration}[/@ww.param]
            [/@ww.text]
        </script>

        <script type="text/javascript">
            AJS.$(function () {
                JobResultSummaryLiveActivity.init({
                    buildResultKey: "${buildResultKey?js_string}",
                    buildLifeCycleState: "${buildLifeCycleState.getValue()?js_string}",
                    container: AJS.$("#buildResultsSummary"),
                    getBuildUrl: "${getBuildUrl}",
                    reloadUrl: "${reloadUrl}",
                    templates: {
                        disabledStopButton: AJS.template.load("disabledStopButton-template"),
                        logTableRow: "logTableRow-template",
                        progressOverAverage: "progressOverAverage-template",
                        progressUnderAverage: "progressUnderAverage-template",
                        queueDurationDescription: "queueDurationDescription-template",
                        queuePositionDescription: "queuePositionDescription-template",
                        updatingSourceFor: "updatingSourceFor-template"
                    }
                });
            });
        </script>
    [/#if]

    [#if buildSummary.finished || buildSummary.notBuilt]
        [@cp.displayErrorsForResult planResult=buildSummary errorAccessor=errorAccessor manualReturnUrl='/browse/${buildResultKey}' /]
    [/#if]

  </body>
</html>