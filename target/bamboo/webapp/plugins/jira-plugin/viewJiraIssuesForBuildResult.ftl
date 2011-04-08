[#-- @ftlvariable name="action" type="com.atlassian.bamboo.plugins.jiraPlugin.actions.ViewJiraIssues"  --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.plugins.jiraPlugin.actions.ViewJiraIssues" --]

<html>
<head>
	<title> [@ui.header pageKey='JIRA Issues' object='${plan.name} ${resultsSummary.buildNumber}' title=true /]</title>
    <meta name="tab" content="jira"/>
    <meta name="decorator" content="result"/>
</head>

<body>
        [#if plan?? && resultsSummary?? && user??]
            <div class="addIssue aui-toolbar inline">
                <ul class="toolbar-group">
                    <li class="toolbar-item">
                        [@ww.url id='addLinkedIssueUrl' value='/build/addJiraIssue!default.action?buildKey=${plan.key!}&buildNumber=${resultsSummary.buildNumber}' /]
                        <a id="addNewLinkedJiraIssue" class="toolbar-trigger" href="${addLinkedIssueUrl}">Add linked issue</a>
                    </li>
                </ul>
            </div>
        [/#if]
        <h1 id="jiraIssuesHeader">JIRA Issues</h1>
        <p>
            <ul>
            This page shows the JIRA issues that have been linked to this build. This includes issues specified in commit messages, labels or comments, as well as issues manually linked to this build. Issues are linked as either;
            <li> 'Fixed Issues' - fixed in this build, or </li>
            <li> 'Related Issues' - linked to the build but not fixed in it </li>
            </ul>
            <br />
        </p>
        [#if plan.type == "CHAIN"]
            [#assign showRelated=true/]
        [#else]
            [#assign showRelated=false/]
        [/#if]
        [@displayJiraIssueList fixedIssues   resultsSummary "Fixed Issues"   lastModified showRelated/]
        [@displayJiraIssueList relatedIssues resultsSummary "Related Issues" lastModified showRelated/]
</body>
</html>

[#macro displayJiraIssueList issues resultsSummary heading='Jira Issues' lastModified='' showRelated=true]
[#import "viewJiraIssueComponents.ftl" as jiraComponents /]
<table summary="${heading}" class="jiraIssueTable aui">
    <colgroup>
        <col width="18">
        <col width="90">
        <col>
        <col width="9%">
        <col width="9%">
        <col width="40" >
    </colgroup>
    <thead>
         <tr>
            <th class="jiraIssueHeadingBar"  colspan="6">
                <div class="jiraIssueSectionHeading">${heading}</div>
                <div class="jiraIssueCount">[#if issues.size()==1](1 issue)[#else](${issues.size()} issues)[/#if]</div>
            </th>
         </tr>
         <tr class="assistive">
            <th id="${heading}-type">Type</th>
            <th id="${heading}-key">Key</th>
            <th id="${heading}-summary">Summary</th>
            <th id="${heading}-status">Status</th>
            <th id="${heading}-relatedBuilds">Related Builds</th>
            <th id="${heading}-operations">Operations</th>
        </tr>
    </thead>

    <tbody>
        [#if issues?has_content]
            [#list issues as issue]
            <tr class="jiraIssueItem" [#if lastModified?has_content && lastModified=issue.issueKey]id="jiraIssueSelected"[/#if]>
                <td class="jiraIssueIcon" headers="${heading}-type">
                  [@jiraComponents.jiraIcon issue /]
                </td>
                <td class="jiraIssueKey" headers="${heading}-key">
                  [@jiraComponents.jiraIssueKey issue /]
                </td>
                <td headers="${heading}-summary"[#if issue.jiraIssueDetails.summary?has_content]class="jiraIssueDetails" [#else] class="jiraIssueDetailsError" [/#if]>
                   [@jiraComponents.jiraSummary issue /]
                </td>
                <td  class="jiraIssueStatus" headers="${heading}-status">
                     [@jiraComponents.jiraStatus issue /]
                </td>
                <td class="jiraIssueRelatedBuilds" headers="${heading}-relatedBuilds">
                    [#if showRelated]
                     [@jiraComponents.jiraRelatedBuilds issue action.getNumberOfRelatedBuilds(issue.issueKey) /]
                    [/#if]
                </td>
                <td class="jiraIssueOperations" headers="${heading}-operations">
                   [#if resultsSummary?? && user??]
                        [@jiraComponents.jiraSwitchOperation issue resultsSummary /]
                        [@jiraComponents.jiraDeleteOperation issue resultsSummary /]
                   [/#if]
                </td>
            </tr>
            [/#list]
        [#else]
            <tr class="jiraIssueItem"><td class="jiraIssueDetailsError" colspan="6" >No Linked ${heading}</td></tr>
        [/#if]
    </tbody>
</table>
[/#macro]
