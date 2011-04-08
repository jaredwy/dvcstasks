[#-- @ftlvariable name="testResults" type="com.atlassian.bamboo.resultsummary.tests.FilteredTestResults" --]
[#-- @ftlvariable name="testSummary" type="com.atlassian.bamboo.resultsummary.tests.TestResultsSummary" --]
[#-- @ftlvariable name="testsMap" type="com.google.common.collect.Multimap<com.atlassian.bamboo.resultsummary.tests.TestClassResultDescriptor, com.atlassian.bamboo.resultsummary.tests.TestCaseResult>" --]

[#macro displayTestSummary testResults testSummary showJob=false]
    [#if !testResults.newFailedTests.isEmpty()]
        [#assign newFailuresText]
            [#if testSummary.newFailedTestCaseCount == testResults.newFailedTests.size()]
                [@ww.text name='buildResult.tests.summary.newFailures'][@ww.param name="value" value=testSummary.newFailedTestCaseCount /][/@ww.text]
            [#else ]
                [@ww.text name='buildResult.tests.summary.newFailures.preview']
                    [@ww.param name="value" value=testResults.newFailedTests.size() /]
                    [@ww.param name="value" value=testSummary.newFailedTestCaseCount /]
                [/@ww.text]
            [/#if]
        [/#assign]
        [@testsTable id="new-failed-tests" testsMap=testResults.newFailedTests showReason=false showJob=showJob showDuration=true showStackTrace=true isStackTraceExpanded=true caption=newFailuresText /]
    [/#if]

    [#if !testResults.existingFailedTests.isEmpty()]
        [#assign existingFailuresText]
            [#if testSummary.existingFailedTestCount == testResults.existingFailedTests.size()]
                [@ww.text name='buildResult.tests.summary.existingFailures'][@ww.param name="value" value=testSummary.existingFailedTestCount /][/@ww.text]
            [#else ]
                [@ww.text name='buildResult.tests.summary.existingFailures.preview']
                    [@ww.param name="value" value=testResults.existingFailedTests.size() /]
                    [@ww.param name="value" value=testSummary.existingFailedTestCount /]
                [/@ww.text]
            [/#if]
        [/#assign]
        [@testsTable id="existing-failed-tests" testsMap=testResults.existingFailedTests showReason=true showJob=showJob showDuration=true showFailingSince=true showStackTrace=true isStackTraceExpanded=false caption=existingFailuresText /]
    [/#if]

    [#if !testResults.fixedTests.isEmpty()]
        [#assign fixedTestsText]
            [#if testSummary.fixedTestCaseCount == testResults.fixedTests.size()]
                [@ww.text name='buildResult.tests.summary.fixed'][@ww.param name="value" value=testSummary.fixedTestCaseCount /][/@ww.text]
            [#else ]
                [@ww.text name='buildResult.tests.summary.fixed.preview']
                    [@ww.param name="value" value=testResults.fixedTests.size() /]
                    [@ww.param name="value" value=testSummary.fixedTestCaseCount /]
                [/@ww.text]
            [/#if]
        [/#assign]
        [@testsTable id="fixed-tests" testsMap=testResults.fixedTests showReason=true showJob=showJob showDuration=true showFailingSince=true caption=fixedTestsText /]
    [/#if]
[/#macro]

[#macro testsTable testsMap showReason showJob showDuration showFailingSince=false showStackTrace=false isStackTraceExpanded=false id="" cssClass="" caption=""]
    [#assign testIndex = 0]
    [#assign colspan = 2]
    [#if showStackTrace]
        [#assign colspan = colspan + 1]
    [/#if]
    [#if showJob]
        [#assign colspan = colspan + 1]
    [/#if]
    [#if showDuration]
        [#assign colspan = colspan + 1]
    [/#if]
    [#if showFailingSince]
        [#assign colspan = colspan + 1]
    [/#if]
    <div class="tests-table-container">
        <table class="aui tests-table[#if cssClass?has_content] ${cssClass}[/#if]"[#if id?has_content] id="${id}"[/#if]>
            [#if caption?has_content]<caption><span>${caption}</span></caption>[/#if]
            <thead>
                <tr>
                    [#if showStackTrace]<td class="twixie">
                        <ul>
                            <li class="expand-all"><span role="link">[@ui.icon type="expand" /][@ww.text name="global.buttons.expand.all" /]</span></li>
                            <li class="collapse-all"><span role="link">[@ui.icon type="collapse" /][@ww.text name="global.buttons.collapse.all" /]</span></li>
                        </ul>
                    </td>[/#if]
                    <th class="status"><span class="assistive">[@ww.text name="buildResult.completedBuilds.status" /]</span></th>
                    <th class="test">[@ww.text name="build.testSummary.test" /]</th>
                    [#if showFailingSince]<th class="failing-since">[@ww.text name="buildResult.tests.failingSince" /]</th>[/#if]
                    [#if showJob]<th class="job">[@ww.text name="job.configuration.view" /]</th>[/#if]
                    [#if showDuration]<th class="duration">[@ww.text name="buildResult.completedBuilds.duration" /]</th>[/#if]
                </tr>
            </thead>
            <tbody>
                [#list testsMap.keySet() as testResultClass]
                    [#list testsMap.get(testResultClass) as testResult]
                        [#assign testIndex = testIndex + 1]
                        [#assign failingSinceBuild = (action.getFailingSinceForTest(testResult))!('')]
                        <tr class="${testResult.state.displayName?lower_case?html}[#if (testIndex) % 2 == 0] zebra[/#if][#if showStackTrace] [#if isStackTraceExpanded]expanded[#else]collapsed[/#if][/#if]">
                            [#if showStackTrace]<td class="twixie">[#if isStackTraceExpanded][@ui.icon type="collapse" textKey="global.buttons.collapse" /][#else][@ui.icon type="expand" textKey="global.buttons.expand" /][/#if]</td>[/#if]
                            <td class="status">[@ui.icon type=testResult.state.displayName?lower_case?html text=testResult.state.displayName?html /]</td>
                            <td class="test">
                                <span class="test-class">${testResult.testClassResult.shortName?html}</span>
                                <a href="[@ww.url value=fn.getTestCaseResultUrl(testResult.testCase.testClass.plan.key, testResult.testClassResult.buildResultsSummary.buildNumber, testResult.testCase.id) /]" class="test-name">${testResult.name?html}</a>
                                <a href="[@ww.url value=fn.getViewTestCaseHistoryUrl(testResult.testCase.testClass.plan.key, testResult.testCase.id) /]">[@ui.icon type="history" textKey="buildResult.tests.history" /]</a>
                            </td>
                            [#if showFailingSince]<td class="failing-since">
                                [#if failingSinceBuild?has_content && failingSinceBuild.buildNumber != testResult.testClassResult.buildResultsSummary.buildNumber]
                                    <a href="${req.contextPath}/browse/${testResult.testCase.testClass.plan.key}-${failingSinceBuild.buildNumber}/" class="failing-since" title="[@ww.text name="buildResult.tests.failingSinceBuild" /] #${testResult.failingSince}"><span class="assistive">[@ww.text name="buildResult.tests.failingSinceBuild" /] </span>#${testResult.failingSince}</a>
                                [/#if]
                                [#if showReason]<span class="reason">(${failingSinceBuild.reasonSummary})</span>[/#if]
                            </td>[/#if]
                            [#if showJob]<td class="job"><a href="${req.contextPath}/browse/${testResult.testClassResult.buildResultsSummary.buildResultKey}/"[#if testResult.testCase.testClass.plan.description?has_content] title="${testResult.testCase.testClass.plan.description}"[/#if]>${testResult.testCase.testClass.plan.buildName}</a></td>[/#if]
                            [#if showDuration]<td class="duration">${testResult.prettyDuration?html}</td>[/#if]
                        </tr>
                        [#if showStackTrace && testResult.errors.size() gt 0]
                            <tr class="stack-trace">
                                <td class="code" colspan="${colspan}">
                                    <pre>[#list testResult.errors as error]${htmlUtils.getFirstNLinesWithTrailer(error.content,8)?html}[/#list]</pre>
                                </td>
                            </tr>
                        [/#if]
                    [/#list]
                [/#list]
            </tbody>
        </table>
    </div>
[/#macro]

[#macro displayTestInfo testSummary ]
    [#assign hasFixedTests=testSummary.fixedTestCaseCount gt 0 /]
    [#assign hasExistingFailedTests=testSummary.existingFailedTestCount gt 0 /]
    [#assign hasNewlyFailingTests=testSummary.newFailedTestCaseCount gt 0 /]
    [#assign hasFixedTests=testSummary.fixedTestCaseCount gt 0 /]
    <ul id="testsSummary">
        <li id="testsSummaryTotal">
            [@ww.text name='buildResult.tests.summary.testsTotal']
                [@ww.param name="value" value=testSummary.totalTestCaseCount /]
            [/@ww.text]
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
                [@ww.text name='buildResult.tests.summary.newFailedCount']
                    [@ww.param name="value" value=testSummary.newFailedTestCaseCount /]
                [/@ww.text]
            </li>
        [/#if]
            <li id="testsSummaryDuration">
                [@ww.text name='buildResult.tests.summary.testDuration']
                    [@ww.param]${durationUtils.getPrettyPrint(testSummary.totalTestDuration)}[/@ww.param]
                [/@ww.text]
            </li>
        [#if hasFixedTests]
            <li id="testsSummaryFixed">
                [@ww.text name='buildResult.tests.summary.fixedSummary']
                    [@ww.param name="value" value=testSummary.fixedTestCaseCount /]
                [/@ww.text]
            </li>
        [/#if]
    </ul>
[/#macro]
