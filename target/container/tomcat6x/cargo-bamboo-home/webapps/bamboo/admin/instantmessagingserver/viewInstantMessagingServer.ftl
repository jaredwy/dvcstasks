[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.instantmessagingserver.ConfigureInstantMessagingServer" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.instantmessagingserver.ConfigureInstantMessagingServer" --]
<html>
<head>
[#if instantMessagingServers?has_content]
    <title>[@ww.text name='instantMessagingServer.admin.view' /]</title>
</head>
<body>
    <h1>[@ww.text name='instantMessagingServer.admin.view' /]</h1>
    [#foreach instantMessagingServer in instantMessagingServers]
        <div class="paddedClearer" ></div>

        [@ww.form action='editInstantMessagingServer'
                  titleKey='instantMessagingServer.admin.view.title'
                  descriptionKey='instantMessagingServer.admin.view.description'
                  submitLabelKey='global.buttons.edit']
            [@ww.param name='buttons']
                <input id="deleteButton" type="button"
                                       value="[@ww.text name='global.buttons.delete' /]"
                                       onclick="location.href='${req.contextPath}/admin/instantmessagingserver/deleteInstantMessagingServer.action?instantMessagingServerId=${instantMessagingServer.id}'"
                                    />
                [@ww.submit value=action.getText('global.buttons.test') name="messageTest" theme='simple' /]
            [/@ww.param]
            [@ww.hidden name="instantMessagingServerId" value=instantMessagingServer.id /]
            [#-- [@ww.label labelKey='instantMessagingServer.label' value=instantMessagingServer.name /] --]
            [@ww.label labelKey='instantMessagingServer.host' value=instantMessagingServer.host /]
            [#if instantMessagingServer.port?exists]
                [@ww.label labelKey='instantMessagingServer.port' value=instantMessagingServer.port /]
            [/#if]
            [#if instantMessagingServer.username?has_content]
                [@ww.label labelKey='instantMessagingServer.username' value=instantMessagingServer.username /]
            [/#if]
            [#if instantMessagingServer.resource?has_content]
                [@ww.label labelKey='instantMessagingServer.resource' value=instantMessagingServer.resource /]
            [/#if]
            [@ww.label labelKey='instantMessagingServer.secureConnectionRequired' value=instantMessagingServer.secureConnectionRequired /]
            [#if instantMessagingServer.secureConnectionRequired]
                [@ww.label labelKey='instantMessagingServer.enforceLegacySsl' value=instantMessagingServer.enforceLegacySsl /]
            [/#if]
            [@ui.bambooSection titleKey='instantMessagingServer.test.title' descriptionKey='instantMessagingServer.test.description']
               [@ww.textfield labelKey='instantMessagingServer.test.recipient' name="testRecipients" required="false" descriptionKey='instantMessagingServer.test.recipient.description'/]
            [/@ui.bambooSection]
        [/@ww.form]

    [/#foreach]
[#else]
    <title>[@ww.text name='instantMessagingServer.admin.add' /]</title>
</head>
<body>
    [@ww.action name="addInstantMessagingServer" executeResult="true" /]
[/#if]

</body>
</html>