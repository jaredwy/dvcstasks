[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ViewBuildResultsSuccessfulTests" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ViewBuildResultsSuccessfulTests" --]
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
    <li>
        <a href="${failedLink}">[@ww.text name='buildResult.tests.summary.failed' /][#if buildResultsSummary.testResultsSummary.failedTestCaseCount > 0] (${buildResultsSummary.testResultsSummary.failedTestCaseCount})[/#if]</a>
    </li>
    <li class="on">
        <a href="${successfulLink}">[@ww.text name='buildResult.tests.summary.successful' /][#if buildResultsSummary.testResultsSummary.successfulTestCaseCount > 0] (${buildResultsSummary.testResultsSummary.successfulTestCaseCount})[/#if]</a>
    </li>
    [#if user??]
    <li>
        [@ui.displayIdeIcon/]
    </li>
    [/#if]
</ul>

    [#if buildResults?? && buildResults.successfulTestResults?has_content && (pager.page.list)?has_content]
        [#assign successfulTests = pager.page.list]

        <p class="successfulTestsText">
            [@ww.text name='buildResult.tests.successful.description']
                [@ww.param value='${buildResults.successfulTestResults.size()}'/]
            [/@ww.text]
            [#if testSummary.fixedTestCaseCount gt 0]
                [@ww.text name='buildResult.tests.successful.fixed']
                    [@ww.param value='${testSummary.fixedTestCaseCount}'/]
                [/@ww.text]
            [/#if]
        </p>

        [#if pager.hasNextPage || pager.hasPreviousPage]
            [@ww.url id='allSuccessfulLink'
                action='viewBuildResultsSuccessfulTests'
                namespace='/build/result'
                buildNumber='${buildNumber}'
                buildKey='${build.key}'
                pageSize='${(buildResults.successfulTestResults.size())!"999999"}'
            /]
            <a href="${allSuccessfulLink}">[@ww.text name='buildResult.tests.successful.showAll' /]</a>
        [/#if]
        [@successTable id="successful-tests" successfulTests=successfulTests/]
    [#else]
        [@ww.text name='buildResult.tests.successful.none' /]
    [/#if]
</body>
</html>

[#macro successTable successfulTests id="" cssClass=""]
    [#assign testIndex = 0]
    [#assign colspan = 4]

    <div class="tests-table-container">
        <table class="aui tests-table[#if cssClass?has_content] ${cssClass}[/#if]"[#if id?has_content] id="${id}"[/#if]>
            <thead>
                <tr>
                    <th class="status"><span class="assistive">[@ww.text name="buildResult.completedBuilds.status" /]</span></th>
                    <th class="test">[@ww.text name="build.testSummary.test" /]</th>
                    <th class="duration">[@ww.text name="buildResult.completedBuilds.duration" /]</th>
                </tr>
            </thead>
            <tbody>
                [#list successfulTests as testResult]
                    [#assign testIndex = testIndex + 1]
                    <tr class="${testResult.state.displayName?lower_case?html}[#if (testIndex) % 2 == 0] zebra[/#if]">
                        <td class="status">[@ui.icon type=testResult.state.displayName?lower_case?html text=testResult.state.displayName?html /]</td>
                        <td class="test">
                            <span class="test-class">${testResult.shortClassName?html}</span>
                            <a href="[@ww.url value=fn.getTestCaseResultUrl(plan.key,buildResultsSummary.buildNumber, testResult.testCaseId) /]" class="test-name">${testResult.actualMethodName?html}</a>
                            <a href="[@ww.url value=fn.getViewTestCaseHistoryUrl(plan.key, testResult.testCaseId) /]">[@ui.icon type="history" textKey="buildResult.tests.history" /]</a>
                        </td>
                        <td class="duration">${testResult.prettyDuration?html}</td>
                    </tr>
                [/#list]
            </tbody>
        </table>
        [@cp.pagination /]
    </div>
[/#macro]
