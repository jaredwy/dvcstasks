[#-- ============================================================================================== @nc.commonStyle --]
[#macro commonStyle]
<style type="text/css">
[#--NB: These css styles will not actually be picked up by some email clients do don't put anything vital to presentation in here. --]        
td a, td a:link, td a:visited, td a:hover, td a:active {background:transparent;font-family: Arial, sans-serif;text-decoration:underline;}
td a:link {color:#369;}
td a:visited {color:#444;}
td a:hover, td a:active {color:#036;}
td a:hover {text-decoration:none;}
</style>
[/#macro]


[#-- ================================================================================================= @nc.fontHtml --]
[#macro fontHtml]
<font size="2" color="black" face="Arial, Helvetica, sans-serif" style="font-family: Arial, sans-serif;font-size: 13px;color:#000">
    [#nested]
</font>
[/#macro]


[#-- ================================================================================ @nc.notificationTitleGreyHtml --]
[#macro notificationTitleGrey]
            <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:#f2f2f2;border-top:1px solid #d9d9d9;border-bottom:1px solid #d9d9d9;color:#000;">
            <tr>
                <td width="100%" style="font-family: Arial, sans-serif; font-size: 13px; color:#000;padding:5px 10px">
                    [#nested]
                </td>
            </tr>
            </table>
            <br>
[/#macro]


[#-- ============================================================================================== @nc.showActions --]
[#macro showActions]
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
                [#nested]
            </td>
        </tr>
    </table>
[/#macro]


[#-- ================================================================================================ @nc.addAction --]
[#macro addAction name url]
    <a href="${url}" style="font-family: Arial, sans-serif; font-size: 13px; color:#036">${name}</a>
    <br>
[/#macro]

[#-- ================================================================================================ @nc.displayEmailTitle --]
[#-- This is just the name of the plan/result not the entire red/green section.--]
[#macro displayEmailTitle baseUrl build buildSummary colour]
  [#if build.parent?has_content]
      <a href="${baseUrl}/browse/${build.project.key}/" style="font-family: Arial, sans-serif; font-size: 15px; font-weight:bold; color:${colour}">${build.project.name}</a> &gt;
      <a href="${baseUrl}/browse/${build.parent.key}/" style="font-family: Arial, sans-serif; font-size: 15px; font-weight:bold; color:${colour}">${build.parent.buildName}</a> &gt;
      <a href="${baseUrl}/browse/${build.parent.key}-${buildSummary.buildNumber}/" style="font-family: Arial, sans-serif; font-size: 15px; font-weight:bold; color:${colour}">#${buildSummary.buildNumber}</a> &gt;
      <a href="${baseUrl}/browse/${buildSummary.buildResultKey}/" style="font-family: Arial, sans-serif; font-size: 15px; font-weight:bold; color:${colour}">${build.buildName}</a>
  [#else]
      <a href="${baseUrl}/browse/${build.project.key}/" style="font-family: Arial, sans-serif; font-size: 15px; font-weight:bold; color:${colour}">${build.project.name}</a> &gt;
      <a href="${baseUrl}/browse/${build.key}/" style="font-family: Arial, sans-serif; font-size: 15px; font-weight:bold; color:${colour}">${build.buildName}</a> &gt;
      <a href="${baseUrl}/browse/${buildSummary.buildResultKey}/" style="font-family: Arial, sans-serif; font-size: 15px; font-weight:bold; color:${colour}">#${buildSummary.buildNumber}</a>
  [/#if]
[/#macro]

[#-- ================================================================================================ @nc.sectionHeader --]

[#macro sectionHeader  baseUrl url title utilText='']
  <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:#ecf1f7;border-top:1px solid #bbd0e5;border-bottom:1px solid #bbd0e5;color:#036;">
        <tr>
            <td width="60%" style="font-family: Arial, sans-serif;text-align:left;font-size:16px;font-weight:bold;color:#036;padding:5px 10px">
                <a href="${url}" style="text-decoration: none; font-family: Arial, sans-serif;text-align:left;font-size:16px;font-weight:bold;color:#036" >${title}</a>
            </td>
            <td width="40%" style="font-family: Arial, sans-serif;text-align:right;font-size:13px;color:#036;padding:5px 10px">
                [#if utilText?has_content]
                <a href="${url}" style="font-family: Arial, sans-serif; font-size: 13px; color:#036">${utilText}</a><img src="${baseUrl}/images/icons/more.gif" width="15" height="15" style="vertical-align:middle;padding:2px">
                [/#if]
            </td>
        </tr>
   </table>
[/#macro]

[#-- ================================================================================================ @nc.displayJobRow --]

[#macro displayJobRow jobResult stageResult]
    <tr>
        <td width="20" style="vertical-align:top;padding:11px 0 5px 10px; border-bottom:1px solid #EEEEEE; ">
            [#if jobResult.successful]
                <img src="${baseUrl}/images/iconsv3/plan_successful_16.png" width="15" height="15">
            [#elseif jobResult.failed]
                <img src="${baseUrl}/images/iconsv3/plan_failed_16.png" width="15" height="15">
            [#else]
                <img src="${baseUrl}/images/iconsv3/plan_canceled_16.png" width="15" height="15">
            [/#if]
        </td>
        <td style="font-family: Arial, sans-serif; font-size: 13px; vertical-align:top;padding:10px 5px 10px 5px; border-bottom:1px solid #EEEEEE;">
            [#if jobResult.successful]
                <a href="${baseUrl}/browse/${jobResult.planResultKey}/" style="color:green;">${jobResult.plan.buildName}</a>
            [#elseif jobResult.failed]
                 <a href="${baseUrl}/browse/${jobResult.planResultKey}/"  style="color:red;">${jobResult.plan.buildName}</a>
            [#else]
                <a href="${baseUrl}/browse/${jobResult.planResultKey}/"  style="color:#999999;">${jobResult.plan.buildName}</a>
            [/#if]
             <span style="color:#444444; font-size:11px; font-style:italic;">(${stageResult.name})</span>
        </td>
        <td width="120" style="font-family: Arial, sans-serif; font-size: 13px; vertical-align:top;padding:10px 5px 10px 5px; border-bottom:1px solid #EEEEEE;color:#444444; font-size:11px">
            [#if jobResult.finished]
                <b>Duration:</b> ${jobResult.durationDescription}
            [#else]
                &nbsp;
            [/#if]
        </td>
        <td width="130" style="font-family: Arial, sans-serif; font-size: 13px; vertical-align:top;padding:10px 5px 10px 5px; border-bottom:1px solid #EEEEEE;color:#444444; font-size:11px">
            [#if jobResult.finished]
                <b>Tests:</b> ${jobResult.testSummary}
            [#else]
                &nbsp;
            [/#if]
        </td>
        <td width="80" style="font-family: Arial, sans-serif; font-size: 13px; vertical-align:top;padding:10px 5px 10px 5px; border-bottom:1px solid #EEEEEE;font-size:11px">
            [#if jobResult.finished]
                <a href="${baseUrl}/browse/${jobResult.buildResultKey}/log">Logs</a> | <a href="${baseUrl}/browse/${jobResult.buildResultKey}/artifact">Artifacts</a>
            [#else]
                &nbsp;
            [/#if]
        </td>
    </tr>
[/#macro]

[#-- ========================================================================================== @nc.showCommitsHtml --]
[#macro showCommits buildSummary baseUrl='']
    [#if buildSummary.commits.size() > 0]
        [#assign utilText]
            [#if buildSummary.commits.size() gt 3]View all ${buildSummary.commits.size()} code changes[#else]See full change details[/#if][#t]
        [/#assign]
    [/#if]
    [#assign titleUrl = "${baseUrl}/browse/${buildSummary.buildResultKey}/commit/" /]
    [@sectionHeader baseUrl titleUrl "Code Changes" utilText/]
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
        [#if buildSummary.commits.size() > 0]
             [#list buildSummary.commits as commit]
             [#if commit_index gte 3][#break][/#if]
                <tr><td width="20" style="vertical-align:top;padding:10px 0 0px 10px">
                        <img src="${baseUrl}/images/icons/businessman.gif" width="15" height="15">
                    </td>
                    <td width="100%" style="font-family: Arial, sans-serif; font-size: 13px; color:#000;vertical-align:top;padding:10px 10px 0px 10px">
                        <a href="[@ui.displayAuthorOrProfileLink commit.author/]" style="font-family: Arial, sans-serif; font-size: 13px; font-weight:bold; color:#000">
                           ${commit.author.fullName?html}</a><br>
                        ${jiraIssueUtils.getRenderedString(htmlUtils.getTextAsHtml(commit.comment), buildSummary.buildKey, buildSummary.buildNumber)}
                    </td>
                    <td width="60" style="font-family: Arial, sans-serif; font-size: 13px; ;color:#036;vertical-align:top;padding:10px 10px 0px 10px">
                    [#assign guessedRevision = commit.guessChangeSetId()!("")]
                    [#if    "Unknown" != commit.author.name &&
                            guessedRevision?has_content &&
                            build.buildDefinition.webRepositoryViewer.getWebRepositoryUrlForCommit?? &&
                            build.buildDefinition.webRepositoryViewer.getWebRepositoryUrlForCommit(commit, build.buildDefinition.repository)?has_content]
                        [#assign commitUrl = (build.buildDefinition.webRepositoryViewer.getWebRepositoryUrlForCommit(commit, build.buildDefinition.repository))!('') /]
                        [#if commitUrl?has_content]
                            (<a href="${commitUrl}" style="font-family: Arial, sans-serif; font-size: 13px; ;color:#036" title="View change set in FishEye">${guessedRevision?html}</a>)
                        [/#if]
                    [#elseif guessedRevision?has_content]
                         (${guessedRevision?html})
                    [/#if]</td></tr>
            [/#list]
            [#if buildSummary.commits.size() gt 3]
            <tr><td colspan="3">
                <br/><a href="${baseUrl}/browse/${buildSummary.buildResultKey}/commit" style="font-family: Arial, sans-serif; font-size: 13px; color:#036">${buildSummary.commits.size()-3} more changes...</a>
            </td></tr>
            [/#if]
        [#else]
             <tr><td width="100%" style="font-family: Arial, sans-serif; font-size: 13px; color:#000;vertical-align:top;padding:10px 10px 0px 10px">
                     This build does not have any commits.
             </td></tr>
        [/#if]
    </table><br>
[/#macro]


[#-- ========================================================================================== @nc.showCommitsHtmlNoBuildResult --]
[#macro showCommitsNoBuildResult commits='' baseUrl='' buildKey='']
[#if commits?has_content]
[@sectionHeader baseUrl "${baseUrl}/browse/${buildKey}/log" "Code Changes"/]
<table width="100%" border="0" cellpadding="0" cellspacing="0">
   [#if commits.size() > 0]
      [#list commits as commit]
         [#if commit_index gte 3][#break][/#if]
            <tr><td width="20" style="vertical-align:top;padding:10px 0 0px 10px">
                    <img src="${baseUrl}/images/icons/businessman.gif" width="15" height="15">
                </td>
                <td width="100%" style="font-family: Arial, sans-serif; font-size: 13px; color:#000;vertical-align:top;padding:10px 10px 0px 10px">
                    <a href="[@ui.displayAuthorOrProfileLink commit.author/]" style="font-family: Arial, sans-serif; font-size: 13px; font-weight:bold; color:#000">
                       ${commit.author.fullName?html}</a><br>
                    ${jiraIssueUtils.getRenderedString(htmlUtils.getTextAsHtml(commit.comment), buildKey, buildNumber)}
                </td>
                <td width="60" style="font-family: Arial, sans-serif; font-size: 13px; ;color:#036;vertical-align:top;padding:10px 10px 0px 10px">
                [#assign guessedRevision = commit.guessChangeSetId()!("")]
                [#if (build.buildDefinition.repository.hasWebBasedRepositoryAccess())!false && "Unknown" != commit.author.name && guessedRevision?has_content]
                    [#assign commitUrl = (build.buildDefinition.repository.getWebRepositoryUrlForCommit(commit))!('') /]
                    [#if commitUrl?has_content]
                        (<a href="${commitUrl}" style="font-family: Arial, sans-serif; font-size: 13px; ;color:#036" title="View change set in FishEye">${guessedRevision?html}</a>)
                    [/#if]
                [#elseif guessedRevision?has_content]
                     (${guessedRevision?html})
                [/#if]</td></tr>
    [/#list]
    [#if commits.size() gt 3]
    <tr><td colspan="3">
        <br/><a href="${baseUrl}/browse/${buildKey}/log" style="font-family: Arial, sans-serif; font-size: 13px; color:#036">${commits.size() - 3} more changes...</a>
    </td></tr>
    [/#if]
[/#if]
</table><br>
[/#if]
[/#macro]

[#-- ========================================================================================== @nc.showJiraIssues --]

[#macro showJiraIssues buildResultKey jiraIssues baseUrl ]
    [#if jiraIssues?has_content && jiraIssueUtils.isJiraServerSetup()]
        [#assign utilText]
            [#if jiraIssues.size() gt 3]See all ${jiraIssues.size()} issues[#else]See full issue details[/#if][#t]
        [/#assign]
        [@sectionHeader baseUrl "${baseUrl}/browse/${buildResultKey}/issues" "JIRA Issues" utilText/]

       <table width="100%" border="0" cellpadding="0" cellspacing="0">
       [#list jiraIssues as issue]
           [#if issue_index gte 3][#break][/#if]
           <tr>

              <td width="20" style="vertical-align:top;padding:10px 0 5px 10px">
                  [#if (issue.jiraIssueDetails.type)?has_content]
                       <img src="${issue.jiraIssueDetails.type.typeIconUrl}" width="15" height="15"/>
                  [#else]
                       <img src="${baseUrl}/images/icons/jira_type_unknown.gif" width="15" height="15">
                  [/#if]
              </td>
              <td width="100%" style="font-family: Arial, sans-serif; font-size: 13px; color:#000;vertical-align:top;padding:10px 10px 5px 10px">
                   <a href="${jiraIssueUtils.getJiraUrl(issue.issueKey)}" style="font-family: Arial, sans-serif; font-size: 13px; font-weight:bold; color:#000">${issue.issueKey?html}</a>
                   <span style="font-family: Arial, sans-serif; font-size: 13px;color:#999">(${issue.issueType.linkDescription?html})</span>
                   <br>
                   [#if issue.jiraIssueDetails?has_content && issue.jiraIssueDetails.summary?has_content]
                       ${issue.jiraIssueDetails.summary?html}
                   [#else]
                       <span style="font-family: Arial, sans-serif; font-size: 13px;color:#999"><em>Could not obtain issue details from JIRA</em></span>
                   [/#if]
               </td>
           </tr>
       [/#list]
       [#if jiraIssues.size() gt 3]
           <tr><td colspan="2">
           <a href="${baseUrl}/browse/${buildResultKey}/issues" style="font-family: Arial, sans-serif; font-size: 13px; color:#036">${jiraIssues.size() - 3} more issues...</a>
           </td></tr>
       [/#if]
       </table><br/>
    [/#if]
[/#macro]

[#-- ============================================================================================== @nc.showChainsTests --]

[#macro showChainsTests buildSummary baseUrl]
        [#assign testSummary = buildSummary.testResultsSummary/]
        [#assign hasExistingFailedTests=testSummary.existingFailedTestCount gt 0 /]
        [#assign hasNewlyFailingTests=testSummary.newFailedTestCaseCount gt 0 /]
        [#assign hasFixedTests=testSummary.fixedTestCaseCount gt 0 /]
        [#assign numTests=0 /]
        [#assign maxTests=25 /]
        [#if buildSummary.testResults?? && (hasExistingFailedTests || hasNewlyFailingTests || hasFixedTests)]
            [#assign testResults = buildSummary.testResults/]
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
            [#if hasNewlyFailingTests]
                [@displayChainTestList "New Test Failures" testSummary.newFailedTestCaseCount testResults.newFailedTests "${baseUrl}/images/iconsv3/plan_failed_16.png" baseUrl numTests maxTests/]
            [/#if]
            [#if hasExistingFailedTests]
                [@displayChainTestList "Existing Test Failures" testSummary.existingFailedTestCount testResults.existingFailedTests "${baseUrl}/images/iconsv3/plan_failed_16.png" baseUrl  numTests maxTests/]
            [/#if]
            [#if hasFixedTests]
                [@displayChainTestList "Fixed Tests" testSummary.fixedTestCaseCount testResults.fixedTests "${baseUrl}/images/iconsv3/plan_successful_16.png" baseUrl numTests maxTests/]
            [/#if]
            [#if numTests gte maxTests]
                <tr><td colspan="2" style="font-family: Arial, sans-serif; vertical-align:top;padding:10px 0 0 10px">
                    <a href="${baseUrl}/browse/${buildSummary.buildResultKey}/test" style="font-family: Arial, sans-serif; font-size: 13px; color:#036">More tests...</a>
                </td></tr>
            [/#if]
            </table><br>
        [/#if]
[/#macro]

[#macro displayChainTestList title totalCount testList imageUrl baseUrl numTests maxTests]
    [#if numTests lt maxTests]
        <tr>
            <td colspan="2" width="100%" style="font-family: Arial, sans-serif; font-size: 13px; font-weight:bold; color:#000;vertical-align:top;padding:10px 0 0 10px">
                ${title} (${totalCount})
            </td>
        </tr>
        [#list testList.values() as testResult]
            [#if numTests gte maxTests][#break][/#if]
            [@displayChainTest testResult imageUrl baseUrl numTests maxTests/]
        [/#list]
    [/#if]
[/#macro]

[#macro displayChainTest testResult img baseUrl numTests maxTests]
        [#assign numTests = numTests + 1 /]
        [#assign jobResult = testResult.testClassResult.buildResultsSummary /]
        [@compress singleLine=true]
            <tr>
                <td width="20" style="vertical-align:top;padding:5px 0 5px 10px">
                    <img src="${img}" width="15" height="15">
                </td>
                <td width="100%" style="font-family: Arial, sans-serif; font-size: 13px; color:#000;vertical-align:top;padding:5px 10px">
                    ${testResult.testClassResult.shortName?html} :
                    <a href="${baseUrl}${fn.getTestCaseResultUrl(jobResult.buildKey, jobResult.buildNumber, testResult.testCase.id)}" style="font-family: Arial, sans-serif; font-size: 13px;color:#000">${testResult.methodName!testResult.name?html}</a>
                    <a href="${baseUrl}/browse/${jobResult.buildResultKey}/test" style="font-family: Arial, sans-serif; font-size: 13px;color:#999">(${jobResult.plan.buildName})</a>
                </td>
            </tr>
        [/@compress]
[/#macro]

[#-- ============================================================================================== @nc.showLogHtml --]
[#macro showLogs lastLogs='' baseUrl='' buildKey='']
[#if lastLogs?has_content]
<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:#ecf1f7;border-top:1px solid #bbd0e5;border-bottom:1px solid #bbd0e5;color:#036;">
    <tr>
        <td width="60%" style="font-family: Arial, sans-serif;text-align:left;font-size:16px;font-weight:bold;color:#036;padding:5px 10px">
            <a href="${baseUrl}/browse/${buildKey}/log" style="text-decoration: none; font-family: Arial, sans-serif;text-align:left;font-size:16px;font-weight:bold;color:#036" >Last Logs</a>
        </td>
    </tr>
 </table>
<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:#f2f2f2;border-top:1px solid #d9d9d9;border-bottom:1px solid #d9d9d9;color:#000;margin-top:5px;padding:10px">
   [#list lastLogs as log]
    <tr>
        <td width="20%" style="font-family:'Courier New', Courier, monospace; font-size: 12px; color: gray; vertical-align:top">
            ${log.formattedDate}
        </td>
        <td width="80%" style="font-family:'Courier New', Courier, monospace; font-size: 12px; color:#000;vertical-align:top;">
            ${log.log}
        </td>
    </tr>
    [/#list]
</table><br/>
[/#if]
[/#macro]

[#-- ====================================================================================== @nc.showEmailFooterHtml --]
[#macro showEmailFooter baseUrl]
<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr><td colspan="2" align="center" style="font-family: Arial, sans-serif;text-align:center;font-size:11px;font-weight:bold;color:#999;vertical-align:top;padding:20px">
        Email generated by <a href="${baseUrl}" style="font-family: Arial, sans-serif; font-size: 11px; color:#999">Atlassian Bamboo</a> - if you wish to stop receiving these emails edit your  <a href="${baseUrl}/profile/userNotifications.action" style="font-family: Arial, sans-serif; font-size: 11px; color:#999">user profile</a> or <a href="${baseUrl}/viewAdministrators.action" style="font-family: Arial, sans-serif; font-size: 11px; color:#999">notify your administrator</a>
    </td>
    </tr>
</table>
[/#macro]

