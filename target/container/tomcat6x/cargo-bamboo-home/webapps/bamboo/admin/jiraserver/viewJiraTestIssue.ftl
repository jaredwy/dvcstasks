
[#macro displayTestJiraIssue testIssue]
<table summary="Jira Test Issue" class="jiraTestIssueTable">
    <colgroup>
        <col width="18">
        <col width="90">
        <col>
        <col width="9%">
    </colgroup>
    <thead>
        <th class="jiraIssueHeadingBar" id="jiraIssuesHeader"  colspan="4">
                <div class="jiraIssueSectionHeading">Server Response</div>
            </th>
         <tr class="assistive">
            <th id="JiraTestIssue-key">Key</th>
            <th id="JiraTestIssue-summary">Summary</th>
        </tr>
    </thead>

    <tbody>
        <tr class="jiraIssueItem">
            <td class="jiraIssueIcon" headers="JiraTestIssue-type">
                [#if testIssue.type?has_content]
                <img src="${testIssue.type.typeIconUrl}" alt="${testIssue.type.typeDescription?html}"/>
                [#else]
                <img src="${req.contextPath}/images/icons/jira_type_unknown.gif" alt="Unknown Issue Type">
                [/#if]
            </td>
            <td class="jiraIssueKey" headers="JiraTestIssue-key">
                ${jiraIssueUtils.getRenderedString(testIssue.issueKey)}
            </td>
            <td headers="JiraTestIssue-summary"[#if testIssue.summary?has_content]class="jiraIssueDetails" [#else] class="jiraIssueDetailsError" [/#if]>
                [#if testIssue.summary?has_content]
                    ${testIssue.summary?html}
                [#else]
                    Could not obtain issue details from the JIRA Server
                [/#if]
            </td>
            <td  class="jiraIssueStatus" headers="JiraTestIssue-status">
                [#if testIssue.status?has_content]
                    ${testIssue.status.statusDescription?html}
                     <img src="${testIssue.status.statusIconUrl}"/>
                [/#if]
            </td>
        </tr>
    </tbody>
 </table>
[/#macro]