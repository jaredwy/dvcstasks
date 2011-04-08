[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.jiraserver.ConfigureJiraServer" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.jiraserver.ConfigureJiraServer" --]
[#import "viewJiraTestIssue.ftl" as jiraIssueView]
[#if jiraServerId == -1]
    [#assign mode = 'add' /]
    [#assign cancelUri = '/admin/administer.action' /]
[#else]
    [#assign mode = 'edit' /]
    [#assign cancelUri = '/admin/jiraserver/viewJiraServers.action' /]
[/#if]

<html>
<head>
    <title>[@ww.text name='jiraServer.admin.${mode}' /]</title>
</head>

<body>

<h1>[@ww.text name='jiraServer.admin.${mode}' /]</h1>
[@ww.form action="saveJiraServer"
          titleKey='jiraServer.admin.${mode}'
          descriptionKey='jiraServer.admin.${mode}.description'
          submitLabelKey='global.buttons.update'
          cancelUri=cancelUri
          showActionErrors='false']
    [@ww.param name='buttons']
        [@ww.submit value=action.getText('global.buttons.test') name="testing" theme='simple' /]
    [/@ww.param]

    [#if mode == 'edit']
        [@ww.hidden name="jiraServerId" value=jiraServerId /]
    [/#if]
    [@ww.actionerror /]

    [#-- [@ww.textfield labelKey='jiraServer.label' name="name" required="true" /] --]
    [@ww.textfield labelKey='jiraServer.host' name="host" required="true" cssClass="long-field" /]
    [@ww.textfield labelKey='jiraServer.username' name="username" required="false" /]
    [#if mode == 'edit' && username?has_content]
        [@ww.checkbox labelKey='jiraServer.password.change' toggle='true' name='passwordChange' /]
        [@ui.bambooSection dependsOn='passwordChange' showOn='true']
            [@ww.password labelKey='jiraServer.password' name="password" required="false" showPassword='true'/]
        [/@ui.bambooSection]
    [#else]
        [@ww.password labelKey='jiraServer.password' name="password" required="false" showPassword='true'/]
    [/#if]

    [@ui.bambooSection titleKey='jiraServer.test.title' descriptionKey='jiraServer.test.description']
        [@ww.textfield labelKey='jiraServer.test.issueKey' name="issueKey" required="false" descriptionKey='jiraServer.test.issueKey.description'/]
        [#if testIssue?has_content]
            [#assign issues=[testIssue] ]
            [@jiraIssueView.displayTestJiraIssue testIssue /]
        [/#if]
    [/@ui.bambooSection]

[/@ww.form]

</body>
</html>
