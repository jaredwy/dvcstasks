[#-- @ftlvariable name="action" type="com.atlassian.bamboo.plugins.jiraPlugin.actions.EditJiraIssues"  --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.plugins.jiraPlugin.actions.EditJiraIssues" --]

<html>
<head>
	<title> [@ui.header pageKey='JIRA Issues' object='${plan.name} ${resultsSummary.buildNumber}' title=true /]</title>
    <meta name="tab" content="jira"/>
    <meta name="decorator" content="result"/>
</head>

<body>
    <div class="section">

[#if user??]
[@ww.form action="addJiraIssue" namespace="/build"
          submitLabelKey='global.buttons.update'
          cancelUri='/build/viewJiraIssues.action?buildKey=${plan.key}&buildNumber=${resultsSummary.buildNumber}'
          titleKey='Add Linked JIRA Issue' description="JIRA issues can be manually linked to this build as either:
                    <ul>
                     <li>'Fixed' - fixed by this build</li>
                     <li>'Related' - linked to the build but not fixed by it</li>
                    </ul><br/>
"]
[@ww.select labelKey='Type of Issue Link' name='issueTypeInput'
                    list='availableIssueTypes' listKey='linkType' listValue='linkDescription' /]

[@ww.textfield id='issueKeyInput' labelKey='JIRA Issue' name='issueKeyInput' description="Please enter the JIRA issue key (for example PROJ-1323) " /]

[@ww.hidden name='buildKey' /]
[@ww.hidden name='buildNumber' /]
[/@ww.form]
[#else]
Sorry you do not have permission to add a JIRA Issue.
[/#if]
     </div>
</body>
</html>