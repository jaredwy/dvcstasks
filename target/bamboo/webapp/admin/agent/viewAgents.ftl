[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ConfigureAgents" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ConfigureAgents" --]

[#import "/agent/commonAgentFunctions.ftl" as agt]

<html>
<head>
    <title>[@ww.text name='agent.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>

<body>
    <h1>[@ww.text name='agent.heading' /]</h1>

    <p>[@ww.text name='agent.description']
        [@ww.param]${req.contextPath}/admin/agent/viewAgentPlanMatrix!default.action[/@ww.param]
    [/@ww.text]</p>

    [@ww.actionerror /]

    [#if (fn.hasGlobalAdminPermission())]
        [#assign sharedCapabilitiesLink]
            <a href="${req.contextPath}/admin/agent/configureSharedLocalCapabilities.action">${action.getText("agent.capability.shared.local.title")}</a>
        [/#assign]
    [#else]
        [#assign sharedCapabilitiesLink='']
    [/#if]

    [@ui.bambooPanel titleKey='agent.local.heading' descriptionKey='agent.local.description' tools=sharedCapabilitiesLink]
        [#if localAgents?has_content]
            [@ww.form action="configureAgents!reconfigure.action" id="localAgentConfiguration" theme="simple"]
            [@agt.displayOperationsHeader agentType='Local'/]
                [#if !allowNewLocalAgent]
                    [@ww.text name='agent.local.limited.description']
                        [@ww.param value=allowedNumberOfLocalAgents /]
                    [/@ww.text]
                [/#if]
                <table id="local-agents" class="aui">
                    <colgroup>
                        <col width="5" />
                        <col />
                        <col width="185" />
                        <col width="95" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th>&nbsp;</th>
                            <th>[@ww.text name='agent.table.heading.name' /]</th>
                            <th>[@ww.text name='agent.table.heading.status' /]</th>
                            <th>[@ww.text name='agent.table.heading.operations' /]</th>
                        </tr>
                    </thead>
                    <tbody>
                        [#foreach agent in localAgents]
                            <tr>
                                <td><input name="selectedAgents" type="checkbox" value="${agent.id}" class="selectorAgentType_Local selectorAgentEnabled_${agent.enabled?string} selectorAgentStatus_${agent.agentStatus}" /></td>
                                <td>[@ui.renderAgentNameAdminLink agent /]</td>
                                <td>[@agt.displayStatusCell agent=agent /]</td>
                                <td>[@agt.displayOperationsCell agent=agent /]</td>
                            </tr>
                        [/#foreach]
                    </tbody>
                </table>
            [/@ww.form]
        [#else]
            [@ww.text name='agent.local.none' /]
        [/#if]
        [#if fn.hasGlobalAdminPermission()]
            [#if allowNewLocalAgent]
                [@ui.buttons]
                    <a href="[@ww.url action='addLocalAgent' namespace='/admin/agent' /]">[@ww.text name='agent.local.add' /]</a>
                [/@ui.buttons]
            [/#if]
        [/#if]
    [/@ui.bambooPanel]

    [#if allowedNumberOfRemoteAgents != 0]
        [#if remoteAgentFunctionEnabled]
            [@ui.bambooPanel
                titleKey='agent.remote.heading'
                descriptionKey='agent.remote.description'
                tools='<a href="${req.contextPath}/admin/agent/configureSharedRemoteCapabilities.action">${action.getText("agent.capability.shared.remote.title")}</a>'
            ]

                [#assign tabs=[action.getText('agent.remote.online.tab'),action.getText('agent.remote.offline.tab')] /]

                [@dj.tabContainer headings=tabs selectedTab=selectedTab!]
                    [@dj.contentPane labelKey='agent.remote.online.tab']
                        [@agt.onlineAgents /]
                    [/@dj.contentPane]
                    [@dj.contentPane labelKey='agent.remote.offline.tab']
                        [@agt.offlineAgents/]
                    [/@dj.contentPane]
                [/@dj.tabContainer]

                [@ui.buttons]
                    [#if fn.hasGlobalAdminPermission()]
                        <a href="[@ww.url action='addRemoteAgent' namespace='/admin/agent' /]">[@ww.text name='agent.remote.add' /]</a> |
                    [/#if]
                    <a id="disableRemoteAgentFunction" href="[@ww.url action='disableRemoteAgentFunction' namespace='/admin/agent' /]">[@ww.text name='agent.remote.disableFunction' /]</a>
                [/@ui.buttons]
            [/@ui.bambooPanel]
        [#else]
            [@ui.bambooPanel titleKey='agent.remote.heading' descriptionKey='agent.remote.description']
                [@ui.messageBox type="warning" titleKey="agent.remote.functionDisabled" /]
                [@ui.buttons]
                    <a id="enableRemoteAgentFunction" href="[@ww.url action='enableRemoteAgentFunction' namespace='/admin/agent' /]">[@ww.text name='agent.remote.enableFunction' /]</a>
                [/@ui.buttons]
            [/@ui.bambooPanel]
        [/#if]
    [/#if]
</body>
</html>