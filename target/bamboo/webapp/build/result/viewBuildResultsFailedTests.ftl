[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ViewBuildResults" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ViewBuildResults" --]
[#import "/lib/tests.ftl" as tests]

<html>
<head>
    <title>[@ui.header pageKey='buildResult.tests.title' object='${build.name} ${buildResultsSummary.buildNumber}' title=true /]</title>
    <meta name="tab" content="tests"/>
</head>

<body>
    [@ui.header pageKey='buildResult.tests.title' /]

    [#assign  testSummary = buildResultsSummary.testResultsSummary/]
    [@tests.displayTestInfo testSummary=testSummary /]

    [@ww.url id='successfulLink'
        action='viewBuildResultsSuccessfulTests'
        namespace='/build/result'
        buildNumber='${buildNumber}'
        buildKey='${build.key}'/]
    [@ww.url id='failedLink'
        action='viewBuildResultsFailedTests'
        namespace='/build/result'
        buildNumber='${buildNumber}'
        buildKey='${build.key}'/]

    <ul id="submenu">
        <li class="on">
            <a href="${failedLink}">[@ww.text name='buildResult.tests.summary.failed' /][#if buildResultsSummary.testResultsSummary.failedTestCaseCount > 0] (${buildResultsSummary.testResultsSummary.failedTestCaseCount})[/#if]</a>
        </li>
        <li>
            <a href="${successfulLink}">[@ww.text name='buildResult.tests.summary.successful' /][#if buildResultsSummary.testResultsSummary.successfulTestCaseCount > 0] (${buildResultsSummary.testResultsSummary.successfulTestCaseCount})[/#if]</a>
        </li>
        [#if user??]
        <li>
            [@ui.displayIdeIcon/]
        </li>
        [/#if]
    </ul>
    [#if buildResultsSummary?? && buildResultsSummary.filteredTestResults??]
        [#assign  testResults = buildResultsSummary.filteredTestResults/]
        <p class="failedTestsText">
            [#if testSummary.hasFailedTestResults()]
                [@ww.text name='buildResult.tests.failed.description']
                    [@ww.param name="value" value='${buildResultsSummary.buildNumber}'/]
                    [@ww.param name="value" value='${testSummary.failedTestCaseCount}'/]
                [/@ww.text]
                [#if testSummary.newFailedTestCaseCount gt 0]
                    [@ww.text name='buildResult.tests.failed.failed']
                        [@ww.param name="value" value='${testSummary.newFailedTestCaseCount}'/]
                    [/@ww.text]
                [#else]
                    [@ww.text name='buildResult.tests.failed.noNewFailures' /]
                [/#if]
            [#else]
                [@ww.text name='buildResult.tests.failed.none' /]
            [/#if]
        </p>

        [#if testSummary.newFailedTestCaseCount gt 0]
            [#assign newFailuresText]
                [@ww.text name='buildResult.tests.summary.newFailures'][@ww.param name="value" value=testSummary.newFailedTestCaseCount /][/@ww.text]
            [/#assign]
            [@tests.testsTable id="new-failed-tests" testsMap=testResults.newFailedTests showReason=false showJob=false showDuration=true showStackTrace=true isStackTraceExpanded=true caption=newFailuresText /]
        [/#if]
        [#if testSummary.existingFailedTestCount gt 0]
            [#assign existingFailuresText]
                [@ww.text name='buildResult.tests.summary.existingFailures'][@ww.param name="value" value=testSummary.existingFailedTestCount /][/@ww.text]
            [/#assign]
            [@tests.testsTable id="existing-failed-tests" testsMap=testResults.existingFailedTests showReason=true showJob=false showDuration=true showFailingSince=true showStackTrace=true isStackTraceExpanded=false caption=existingFailuresText /]
        [/#if]
    [/#if]
</body>
</html>
