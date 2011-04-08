[#-- @ftlvariable name="numFailures" type="java.lang.Integer"--]
[#-- @ftlvariable name="baseUrl" type="java.lang.String" --]
[#-- @ftlvariable name="build" type="com.atlassian.bamboo.chains.Chain" --]
[#-- @ftlvariable name="buildSummary" type="com.atlassian.bamboo.chains.ChainResultsSummary" --]
[#-- @ftlvariable name="triggerReasonDescription" type="java.lang.String" --]
[#-- @ftlvariable name="firstFailedBuildSummary" type="com.atlassian.bamboo.chains.ChainResultsSummary" --]
[#-- @ftlvariable name="firstFailedTriggerReasonDescription" type="java.lang.String" --]
[#include "notificationCommonsHtml.ftl"]
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
[#assign totalJobCount = buildSummary.totalJobCount/]
[#assign failingJobCount = buildSummary.failedJobResults.size()/]
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
                    <span class="successful" style="font-family: Arial, sans-serif; font-size: 14px;">[#if numFailures?has_content]was successful after <strong>${numFailures}</strong> [#if numFailures==1]failure.[#else]failures.[/#if][#else] was successful.[/#if]</span>
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
                    [#if firstFailedBuildSummary?has_content]
                        <br/><br/>This plan has been failing since <a href="${baseUrl}/browse/${firstFailedBuildSummary.buildResultKey}" style="color:#393">${firstFailedBuildSummary.buildResultKey}</a> (${firstFailedBuildSummary.reasonSummary}, ${firstFailedBuildSummary.getRelativeBuildDate(buildSummary.buildCompletedDate)}).
                    [/#if]
                    </span>
                </td>
			</tr>
        </table>
		<br>
        [#else]
        <table class="failed" width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:#ffe6e7;border-top:1px solid #eec0c0;border-bottom:1px solid #eec0c0;color:#d62829;">
        <tr>
        <td class="failed" width="20" style="vertical-align:top;padding:5px 0 5px 10px">
            <img src="${baseUrl}/images/iconsv3/plan_failed_16.png" width="15" height="15">
        </td>
        <td class="failed" width="100%" style="font-family: Arial, sans-serif; font-size: 13px; color:#d62829;padding:5px 10px">
            [@displayEmailTitle baseUrl build buildSummary "#d62829"/]
            <span class="failed" style="font-family: Arial, sans-serif; font-size: 14px;">[#if numFailures?has_content]has failed <strong>${numFailures}</strong> [#if numFailures==1]time.[#else]times.[/#if][#else]has failed.[/#if]</span>
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
                [#if firstFailedBuildSummary?has_content]
                    <br/><br/>This plan has been failing since <a href="${baseUrl}/browse/${firstFailedBuildSummary.buildResultKey}" style="color:#d62829">${firstFailedBuildSummary.buildResultKey}</a> (${firstFailedBuildSummary.reasonSummary}, ${firstFailedBuildSummary.getRelativeBuildDate(buildSummary.buildCompletedDate)}).
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
