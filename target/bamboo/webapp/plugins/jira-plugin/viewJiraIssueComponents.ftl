[#-- @ftlvariable name="issue" type="com.atlassian.bamboo.jira.jiraissues.LinkedJiraIssue" --]

[#macro jiraIssueKey issue]
        ${jiraIssueUtils.getRenderedString(issue.issueKey)}
[/#macro]

[#macro jiraSummary issue]
        [#if issue.jiraIssueDetails.summary?has_content]
            ${issue.jiraIssueDetails.summary?html}
        [#else]
            Could not obtain issue details from JIRA
        [/#if]
[/#macro]

[#macro jiraIcon issue]
    [@ww.url id="jiraIconUrl" value="${(jiraIssueUtils.getJiraUrl(issue.issueKey))!}" /]

    [#if jiraIconUrl?has_content ]
        <a href="${jiraIconUrl}" title="[@ww.text name='issue.link.jira.title' /]" >
            [#if issue.jiraIssueDetails.type?has_content]
                <img class="issueTypeImg" src="${issue.jiraIssueDetails.type.typeIconUrl}" alt="${issue.jiraIssueDetails.type.typeDescription?html}"/>
            [#else]
                <img class="issueTypeImg" src="${req.contextPath}/images/icons/jira_type_unknown.gif" alt="Unknown Issue Type">
            [/#if]
        </a>
    [#else]
        <img class="issueTypeImg" src="${req.contextPath}/images/icons/jira_type_unknown.gif" alt="Unknown Issue Type">
    [/#if]
[/#macro]

[#macro jiraStatus issue]
    [#if issue.jiraIssueDetails.status?has_content]
        ${issue.jiraIssueDetails.status.statusDescription?html}<img src="${issue.jiraIssueDetails.status.statusIconUrl}"/>
    [/#if]
[/#macro]

[#macro jiraRelatedBuilds issue numberOfBuilds]
    <a href="${jiraIssueUtils.getJiraUrl(issue.issueKey)}" id="showBuildsRelatedToJira:${issue.issueKey}" title="View related builds in JIRA">[#if numberOfBuilds==1]1 related build[#else]${numberOfBuilds} related builds[/#if]</a>
[/#macro]

[#macro jiraSwitchOperation issue buildResultsSummary]
    [@ww.url id='switchTypeUrl' value='/build/switchJiraIssueType.action?buildKey=${buildResultsSummary.buildKey!}&buildNumber=${buildResultsSummary.buildNumber}&currentIssueKey=${issue.issueKey}' /]
    [#if (issue.issueType.linkType)! == "fixes"]
        <a href="${switchTypeUrl}" id="switchIssueType:${issue.issueKey}" title="Change to Related"><img src="${req.contextPath}/images/icons/arrow_down_blue.gif" alt="Change to Related" /></a>
    [#else]
        <a href="${switchTypeUrl}" id="switchIssueType:${issue.issueKey}" title="Change to Fixed"><img src="${req.contextPath}/images/icons/arrow_up_blue.gif" alt="Change to Fixed" /></a>
    [/#if]
[/#macro]

[#macro jiraDeleteOperation issue buildResultsSummary]
    [@ww.url id='removeUrl' value='/build/removeJiraIssue.action?buildKey=${buildResultsSummary.buildKey!}&buildNumber=${buildResultsSummary.buildNumber}&currentIssueKey=${issue.issueKey}' /]
    <a href="${removeUrl}" id="removeJiraIssue:${issue.issueKey}" title="Remove linked Jira Issue"><img src="${req.contextPath}/images/icons/trash_16.gif" /></a>
[/#macro]