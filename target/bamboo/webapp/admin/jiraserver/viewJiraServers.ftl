[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.jiraserver.ConfigureJiraServer" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.jiraserver.ConfigureJiraServer" --]
[#import "viewJiraTestIssue.ftl" as jiraIssueView /]

[#if allJiraServers?has_content]
<html>
<head>
    <title>[@ww.text name='jiraServer.admin.view' /]</title>
</head>

<body>
<h1>[@ww.text name='jiraServer.admin.view' /]</h1>
    [#foreach jiraServer in allJiraServers]
        <div class="paddedClearer" ></div>

        [@ww.form action='editJiraServer'
                  titleKey='jiraServer.admin.view.title'
                  descriptionKey='jiraServer.admin.view.description'
                  submitLabelKey='global.buttons.edit'
                    showActionErrors='false']
            [@ww.param name='buttons']
                <input id="deleteButton" type="button"
                                       value="[@ww.text name='global.buttons.delete' /]"
                                       onclick="location.href='${req.contextPath}/admin/jiraserver/deleteJiraServer.action?jiraServerId=${jiraServer.id}'"
                                    />
                [@ww.submit value=action.getText('global.buttons.test') name="testing" theme='simple' /]
            [/@ww.param]
            [@ww.hidden name="jiraServerId" value=jiraServer.id /]
            [@ww.actionerror /]

            [#-- [@ww.label labelKey='jiraServer.label' value=jiraServer.name /] --]
            [@ww.label labelKey='jiraServer.host' value=jiraServer.host /]
            [#if jiraServer.username?has_content]
                [@ww.label labelKey='jiraServer.username' value=jiraServer.username /]
            [/#if]
            [@ui.bambooSection titleKey='jiraServer.test.title' descriptionKey='jiraServer.test.description']
                [@ww.textfield labelKey='jiraServer.test.issueKey' name="issueKey" required="false" descriptionKey='jiraServer.test.issueKey.description'/]
                [#if testIssue?has_content]
                    [#assign issues=[testIssue] ]
                    [@jiraIssueView.displayTestJiraIssue testIssue /]
                [/#if]
            [/@ui.bambooSection]
        [/@ww.form]
    [/#foreach]
</body>
[#else]
    [@ww.action name="newJiraServer" executeResult="true" /]
[/#if]
</html>