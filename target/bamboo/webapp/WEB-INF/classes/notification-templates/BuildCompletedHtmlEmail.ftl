[#-- @ftlvariable name="build" type="com.atlassian.bamboo.build.Buildable" --]
[#-- @ftlvariable name="buildSummary" type="com.atlassian.bamboo.resultsummary.BuildResultsSummary" --]
[#-- @ftlvariable name="triggerReasonDescription" type="java.lang.String" --]
[#include "notificationCommonsHtml.ftl" ]
[#assign testSummary = buildSummary.testResultsSummary /]
<div>
<style type="text/css">
[#--NB: These css styles will not actually be picked up by some email clients do don't put anything vital to presentation in here. --]    
.successful a, .successful a:visited, .successful a:link, .successful a:hover,.successful  a:active {color:#393}
.failed a, .failed a:visited, .failed a:link, .failed a:hover,.failed  a:active {color:#d62829}
td a, td a:link, td a:visited, td a:hover, td a:active {background:transparent;font-family: Arial, sans-serif;text-decoration:underline;}
td a:link {color:#369;}
td a:visited {color:#444;}
td a:hover, td a:active {color:#036;}
td a:hover {text-decoration:none;}
</style>
<font size="2" color="black" face="Arial, Helvetica, sans-serif" style="font-family: Arial, sans-serif;font-size: 13px;color:#000">
<table align="center" border="0" cellpadding="5" cellspacing="0" width="98%">
<tr>
	<td style="vertical-align:top">
        [#if buildSummary.successful]
		<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:#e4f5e3;border-top:1px solid #b4e2b4;border-bottom:1px solid #b4e2b4;color:#393;">
			<tr>
				<td width="20" style="vertical-align:top;padding:5px 0 5px 10px">
					<img src="${baseUrl}/images/iconsv3/plan_successful_16.png" width="15" height="15">
				</td>
				<td width="100%" style="font-family: Arial, sans-serif; font-size: 13px; color:#393;padding:5px 10px">
                    [@displayEmailTitle baseUrl build buildSummary "#393"/]
					<span class="successful" style="font-family: Arial, sans-serif; font-size: 14px;"> was successful.</span>
                    <span class="successful" style="font-family: Arial, sans-serif; font-size: 13px;">
                    [#if triggerReasonDescription?has_content]
                    <br/>${triggerReasonDescription}
                    [/#if]
                    [#if testSummary.totalTestCaseCount == 0]
                      <br/>No tests executed.
                    [#else]
                      <br/><strong>${testSummary.successfulTestCaseCount}</strong> tests in total.
                    [/#if]
                    </span>
                </td>
			</tr>
        </table>
		<br>
        [#else]
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:#ffe6e7;border-top:1px solid #eec0c0;border-bottom:1px solid #eec0c0;color:#d62829;">
            <tr>
                <td width="20" style="vertical-align:top;padding:5px 0 5px 10px">
                    <img src="${baseUrl}/images/iconsv3/plan_failed_16.png" width="15" height="15">
                </td>
                <td width="100%" style="font-family: Arial, sans-serif; font-size: 13px; color:#d62829;padding:5px 10px">
                    [@displayEmailTitle baseUrl build buildSummary "#d62829"/]
                    <span class="failed" style="font-family: Arial, sans-serif; font-size: 14px;"> has failed.</span>
                    <span class="failed" style="font-family: Arial, sans-serif; font-size: 13px;">
                    [#if triggerReasonDescription?has_content]
                    <br/>${triggerReasonDescription}
                    [/#if]
                    [#if testSummary.failedTestCaseCount == 0]
                        <br/>No failed tests found, a possible compilation error.
                    [#else]
                        <br/><strong>${testSummary.failedTestCaseCount}/${testSummary.totalTestCaseCount}</strong> tests failed.
                    [/#if]
                    </span>
                </td>
            </tr>
        </table>
        <br>
        [/#if]

        [@showCommits buildSummary baseUrl /]

        [#assign hasExistingFailedTests=testSummary.existingFailedTestCount gt 0 /]
        [#assign hasNewlyFailingTests=testSummary.newFailedTestCaseCount gt 0 /]
        [#assign hasFixedTests=testSummary.fixedTestCaseCount gt 0 /]
        [#assign numTests=0 /]
        [#assign maxTests=25 /]
        [#if buildSummary.filteredTestResults?? && (hasExistingFailedTests || hasNewlyFailingTests || hasFixedTests)]
            [#assign testResults = buildSummary.filteredTestResults /]
            <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:#ecf1f7;border-top:1px solid #bbd0e5;border-bottom:1px solid #bbd0e5;color:#036;">
                <tr>
                    <td width="60%" style="font-family: Arial, sans-serif;text-align:left;font-size:16px;font-weight:bold;color:#036;vertical-align:top;padding:5px 10px">
                        <a href="${baseUrl}/browse/${buildSummary.buildResultKey}/test" style="text-decoration: none; font-family: Arial, sans-serif;text-align:left;font-size:16px;font-weight:bold;color:#036" >Tests</a>
                    </td>
                    <td width="40%" style="font-family: Arial, sans-serif;text-align:right;font-size:13px;color:#036;padding:5px 10px">
                        <a href="${baseUrl}/browse/${buildSummary.buildResultKey}/test" style="font-family: Arial, sans-serif; font-size: 13px;color:#036">See full test details</a><img src="${baseUrl}/images/icons/more.gif" width="15" height="15" style="vertical-align:middle;padding:2px">
                    </td>
                </tr>
            </table>
            <table width="100%" border="0" cellpadding="0" cellspacing="0">


            [#if hasExistingFailedTests ||  hasNewlyFailingTests]
                    [#assign failedTestTotal=testSummary.failedTestCaseCount/]
                    <tr>
                        <td colspan="2" width="100%" style="font-family: Arial, sans-serif; font-size: 13px; font-weight:bold; color:#000;vertical-align:top;padding:10px 0 0 10px">
                            Failed Tests (${failedTestTotal})
                        </td>
                    </tr>
                    [#list testResults.newFailedTests.values() as testResult]
                        [#if numTests gte maxTests][#break][/#if]
                        [@displayTest testResult "${baseUrl}/images/iconsv3/plan_failed_16.png" "(New)" /]
                    [/#list]
                    [#list testResults.existingFailedTests.values() as testResult]
                        [#if numTests gte maxTests][#break][/#if]
                        [@displayTest testResult "${baseUrl}/images/iconsv3/plan_failed_16.png" "(Existing)" /]
                    [/#list]
            [/#if]
            [#if hasFixedTests && numTests lt maxTests]
                    <tr>
                        <td colspan="2" width="100%" style="font-family: Arial, sans-serif; font-size: 13px; font-weight:bold; color:#000;vertical-align:top;padding:10px 0 0 10px">
                            Fixed Tests (${testSummary.fixedTestCaseCount})
                        </td>
                    </tr>
                    [#list testResults.fixedTests.values() as testResult]
                        [#if numTests gte maxTests][#break][/#if]
                        [@displayTest testResult "${baseUrl}/images/iconsv3/plan_successful_16.png" /]
                    [/#list]
            [/#if]
            [#if numTests gte maxTests]
                <tr><td colspan="2" style="font-family: Arial, sans-serif; vertical-align:top;padding:10px 0 0 10px">
                    <a href="${baseUrl}/browse/${buildSummary.buildResultKey}/test" style="font-family: Arial, sans-serif; font-size: 13px; color:#036">More tests...</a>
                </td></tr>
            [/#if]
            </table><br>
        [/#if]

        [@showJiraIssues buildSummary.buildResultKey jiraIssues baseUrl/]

        [#if shortErrorSummary.size() gt 0]
            <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:#ecf1f7;border-top:1px solid #bbd0e5;border-bottom:1px solid #bbd0e5;color:#036;">
                <tr>
                    <td width="60%" style="font-family: Arial, sans-serif;text-align:left;font-size:16px;font-weight:bold;color:#036;padding:5px 10px">
                        <a href="${baseUrl}/browse/${buildSummary.buildResultKey}/log" style="text-decoration: none; font-family: Arial, sans-serif;text-align:left;font-size:16px;font-weight:bold;color:#036" >Error Summary</a>
                    </td>
                    <td width="40%" style="font-family: Arial, sans-serif;text-align:right;font-size:13px;color:#036;padding:5px 10px">
                        <a href="${baseUrl}/browse/${buildSummary.buildResultKey}/log" style="font-family: Arial, sans-serif; font-size: 13px;color:#036">See full build log</a>
                        <img src="${baseUrl}/images/icons/more.gif" width="15" height="15" style="vertical-align:middle;padding:2px">
                    </td>
                </tr>
            </table>

            <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:#f2f2f2;border-top:1px solid #d9d9d9;border-bottom:1px solid #d9d9d9;color:#000;margin-top:5px;padding:10px">
               [#list shortErrorSummary as error]
               <tr>
                <td width="100%" style="font-family:'Courier New', Courier, monospace; font-size: 12px; color:#000;vertical-align:top">
                    ${htmlUtils.getAsPreformattedText(error)}<br/>
                </td>
                </tr>
               [/#list]
            </table>
            <br />
        [/#if]

        [@showEmailFooter baseUrl/]

    </td>
    <td width="150" style="vertical-align:top">
        <table width="150" border="0" cellpadding="0" cellspacing="0" style="background-color:#ecf1f7;border-top:1px solid #bbd0e5;border-bottom:1px solid #bbd0e5;color:#036;">
            <tr>
                <td style="font-family: Arial, sans-serif;text-align:left;font-size:16px;font-weight:bold;color:#036;vertical-align:top;padding:5px 10px">
                    Actions
                </td>
            </tr>
        </table>
        <table width="150" border="0" cellpadding="0" cellspacing="0" style="background-color:#f5f9fc;border-bottom:1px solid #bbd0e5;">
            <tr>
                <td style="font-family: Ariel, sans-serif; font-size: 13px; color:#036;vertical-align:top;padding:5px 10px;line-height:1.7">
                    <a href="${baseUrl}/browse/${buildSummary.buildResultKey}/" style="font-family: Arial, sans-serif; font-size: 13px; color:#036">View Online</a>
                    <br>
                    <a href="${baseUrl}/browse/${buildSummary.buildResultKey}?commentMode=true" style="font-family: Arial, sans-serif; font-size: 13px; color:#036">Add Comments</a>
                    <br>
                    <a href="${baseUrl}/browse/${buildSummary.buildResultKey}/artifact" style="font-family: Arial, sans-serif; font-size: 13px; color:#036">View Artifacts</a>
                    <br>
                    <a href="${baseUrl}/download/${buildSummary.buildKey}/build_logs/${buildSummary.buildResultKey}.log" style="font-family: Arial, sans-serif; font-size: 13px; color:#036">Download Logs</a>
                    <br>
                    [#if jiraIssueUtils.isJiraServerSetup()]
                    <a href="${baseUrl}/build/addJiraIssue!default.action?buildKey=${buildSummary.buildKey}&buildNumber=${buildSummary.buildNumber}" style="font-family: Arial, sans-serif; font-size: 13px; color:#036">Link to JIRA issue</a>
                    <br>
                    [/#if]
                </td>
            </tr>
        </table>
    </td>
<tr>
</table>
</font>
</div>

[#macro displayTest testResult img postfix='']
        [#assign numTests = numTests + 1 /]
        [@compress singleLine=true]
            <tr>
                <td width="20" style="vertical-align:top;padding:5px 0 5px 10px">
                    <img src="${img}" width="15" height="15">
                </td>
                <td width="100%" style="font-family: Arial, sans-serif; font-size: 13px; color:#000;vertical-align:top;padding:5px 10px">
                    ${testResult.testClassResult.shortName?html} :
                    <a href="${baseUrl}${fn.getTestCaseResultUrl(build.key, buildSummary.buildNumber, testResult.testCase.id)}" style="font-family: Arial, sans-serif; font-size: 13px;color:#000">${testResult.methodName?html}</a>
                    <span style="color:#999">${postfix}</span>
                </td>
            </tr>
        [/@compress]
[/#macro]
