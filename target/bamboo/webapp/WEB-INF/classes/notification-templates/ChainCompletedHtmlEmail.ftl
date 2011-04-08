[#-- @ftlvariable name="triggerReasonDescription" type="java.lang.String" --]
[#-- @ftlvariable name="baseUrl" type="java.lang.String" --]
[#-- @ftlvariable name="build" type="com.atlassian.bamboo.chains.Chain" --]
[#-- @ftlvariable name="buildSummary" type="com.atlassian.bamboo.chains.ChainResultsSummary" --]
[#include "notificationCommonsHtml.ftl" ]
[#assign planResultKey = buildSummary.planResultKey/]

<div>
<style type="text/css">
[#--NB: These css styles will not actually be picked up by some email clients do don't put anything vital to presentation in here. --]
.successful a, .successful a:visited, .successful a:link, .successful a:hover,.successful  a:active {color:#393}
.failed a, .failed a:visited, .failed a:link, .failed a:hover,.failed  a:active {color:#d62829}
.notexecuted a, .notexecuted a:visited, .notexecuted a:link, .notexecuted a:hover,.notexecuted  a:active {color:#ffcc66}
td a, td a:link, td a:visited, td a:hover, td a:active {background:transparent;font-family: Arial, sans-serif;text-decoration:underline;}
td a:link {color:#369;}
td a:visited {color:#444;}
td a:hover, td a:active {color:#036;}
td a:hover {text-decoration:none;}
</style>
<font size="2" color="black" face="Arial, Helvetica, sans-serif" style="font-family: Arial, sans-serif;font-size: 13px;color:#000">
<table align="center" border="0" cellpadding="5" cellspacing="0" width="98%">

[#assign totalJobCount = buildSummary.totalJobCount/]
[#assign failingJobCount = buildSummary.failedJobResults.size()/]
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
                    [#if totalJobCount > 1]
                        [#if buildSummary.testResultsSummary.totalTestCaseCount == 0]
                          <br/>All <strong>${totalJobCount}<strong> jobs passed
                        [#else]
                           <br/>All <strong>${totalJobCount}</strong> jobs passed with <strong>${buildSummary.testResultsSummary.successfulTestCaseCount}</strong> tests in total.[#t]
                        [/#if]
                    [#else]
                        [#if buildSummary.testResultsSummary.totalTestCaseCount == 0]
                          <br/>No tests executed.
                        [#else]
                          <br/><strong>${buildSummary.testResultsSummary.successfulTestCaseCount}</strong> tests in total.
                        [/#if]
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
                    [#if totalJobCount > 1]
                        [#if buildSummary.testResultsSummary.totalTestCaseCount == 0]
                          <br/><strong>${failingJobCount}/${totalJobCount}</strong> jobs failed, no tests found.
                        [#else]
                           <br/><strong>${failingJobCount}/${totalJobCount}</strong> jobs failed with <strong>${buildSummary.testResultsSummary.failedTestCaseCount}</strong> failing test[#if buildSummary.testResultsSummary.failedTestCaseCount != 1]s[/#if].[#t]
                        [/#if]
                    [#else]
                        [#if buildSummary.testResultsSummary.failedTestCaseCount == 0]
                            <br/>No failed tests found, a possible compilation error.
                        [#else]
                            <br/><strong>${buildSummary.testResultsSummary.failedTestCaseCount}/${buildSummary.testResultsSummary.totalTestCaseCount}</strong> tests failed.
                        [/#if]
                    [/#if]
                    </span>
                </td>
            </tr>
        </table>
        <br>
        [/#if]
        [#if buildSummary.failed]
        [#assign failingJob = false/]
        [@sectionHeader baseUrl "${baseUrl}/browse/${buildSummary.buildResultKey}/" "Failing Jobs"/]
         <table  width="100%" border="0" cellpadding="0" cellspacing="0">
            [#list buildSummary.stageResults as stageResult]
                [#list stageResult.sortedBuildResults as jobResult]
                    [#if jobResult.failed]
                        [@displayJobRow jobResult stageResult/]
                        [#assign failingJob = true /]
                    [/#if]
                [/#list]
            [/#list]
            [#if !failingJob]
                 <tr>
                    <td style="font-family: Arial, sans-serif; font-size: 13px; vertical-align:top;padding:10px 5px 10px 5px; border-bottom:1px solid #EEEEEE;">
                        No failed jobs found.
                    </td>
                 </tr>
            [/#if]
        </table>
        <br/>
        [/#if]
        [@showCommits buildSummary baseUrl /]
        [@showJiraIssues buildSummary.buildResultKey jiraIssues baseUrl/]
        [@showChainsTests buildSummary baseUrl /]

    </td>
    <td width="150" style="vertical-align:top">
        [@showActions]
            [@addAction "View Online" "${baseUrl}/browse/${buildSummary.buildResultKey}"/]
            [@addAction "Add Comments" "${baseUrl}/browse/${buildSummary.buildResultKey}?commentMode=true"/]
            [#if jiraIssueUtils.isJiraServerSetup()]
                [@addAction "Link to JIRA issue" "${baseUrl}/build/addJiraIssue!default.action?buildKey=${buildSummary.buildKey}&buildNumber=${buildSummary.buildNumber}"/]
            [/#if]
        [/@showActions]
    </td>
</tr>
<tr>
    <td>
    [@showEmailFooter baseUrl/]
    </td>
</tr>
</table>
</font>
</div>
