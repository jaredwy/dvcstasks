[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ViewAgents" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ViewAgents" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]
<html>
<head>
    <title>[@ww.text name='agent.title' /]</title>
</head>

<body>
<div id="agent-content">
    <h1>[@ww.text name='agent.heading' /]</h1>

    [#if action.hasActionErrors()]
        [@ww.actionerror /]
    [#else]
        <p>
            [@ww.text name='agents.description' /][#t]
            [#if planKey??]
                [#t] [@ww.text name='agents.forPlan.description']
                    [@ww.param]${planKey?html}[/@ww.param]
                [/@ww.text]
                [#t] [@ww.text name="agents.forPlan.returnLink"]
                    [@ww.param]${req.contextPath}[/@ww.param]
                    [@ww.param]${fn.sanitizeUri(returnUrl)}[/@ww.param]
                [/@ww.text]
            [/#if]
            .[#t]
        </p>

        [@ui.bambooPanel titleKey='agent.local.heading' descriptionKey='agent.local.description']
            [#if localAgents?has_content]
                <table id="local-agents" class="aui">
                    <colgroup>
                        <col />
                        <col width="185" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th>[@ww.text name='agent.table.heading.name' /]</th>
                            <th>[@ww.text name='agent.table.heading.status' /]</th>
                        </tr>
                    </thead>
                    <tbody>
                        [#foreach agent in localAgents]
                            <tr>
                                <td>[@ui.renderAgentNameLink agent/]</td>
                                <td>[@agt.displayStatusCell agent=agent /]</td>
                            </tr>
                        [/#foreach]
                    </tbody>
                </table>
            [#else]
                [#if planKey??]
                    [@ww.text name='agent.local.noneMatching' /]
                [#else]
                    [@ww.text name='agent.local.none' /]
                [/#if]
            [/#if]
        [/@ui.bambooPanel]

        [#if onlineRemoteAgents?has_content || offlineRemoteAgents?has_content]
            [@ui.bambooPanel titleKey='agent.remote.heading' descriptionKey='agent.remote.description' ]
                [#assign tabs=[action.getText('agent.remote.online.tab'),action.getText('agent.remote.offline.tab')] /]
                [@dj.tabContainer headings=tabs selectedTab='${selectedTab!}']
                    [@dj.contentPane labelKey='agent.remote.online.tab']
                        [@agt.onlineAgents showLogs=false showOperations=false/]
                    [/@dj.contentPane]
                    [@dj.contentPane labelKey='agent.remote.offline.tab']
                        [@agt.offlineAgents/]
                    [/@dj.contentPane]
                [/@dj.tabContainer]
            [/@ui.bambooPanel]
        [/#if]
    [/#if]

    [#if elasticBambooEnabled]
        <h2 id="elasticImages">[@ww.text name='agent.image.heading' /]</h2>

        <p>
            [@ww.text name='agent.image.description' /][#t]
            [#if planKey??]
                [#t] [@ww.text name='agents.forPlan.description']
                    [@ww.param]${planKey?html}[/@ww.param]
                [/@ww.text]
                [#t] [@ww.text name="agents.forPlan.returnLink"]
                    [@ww.param]${req.contextPath}[/@ww.param]
                    [@ww.param]${returnUrl}[/@ww.param]
                [/@ww.text]
            [/#if]
            .[#t]
            [#if fn.hasGlobalAdminPermission()]
                [#t] [@ww.text name='agent.image.startup']
                    [@ww.param][@ww.url action='prepareElasticInstances' namespace='/admin/elastic'/][/@ww.param]
                [/@ww.text]
            [/#if]
        </p>

        [#if elasticImageConfigurations?size > 0]
            <table class="aui">
                <colgroup>
                    <col />
                    <col />
                    <col width="185" />
                </colgroup>
                <thead>
                    <tr>
                        <th>[@ww.text name='elastic.image.configuration.configurationName.heading'/]</th>
                        <th>[@ww.text name='elastic.image.configuration.amiId'/]</th>
                        <th>[@ww.text name='elastic.image.configuration.numberOfActiveInstances.heading'/]</th>
                    </tr>
                </thead>
                <tbody>
                    [#list elasticImageConfigurations as configuration]
                        [#assign activeInstanceCount = elasticUIBean.getActiveInstancesCountForConfiguration(configuration)/]
                        <tr>
                            <td>
                                [#if fn.hasGlobalAdminPermission()]<a href="[@ww.url action='viewElasticImageConfiguration' namespace='/admin/elastic/image/configuration' configurationId=configuration.id /]" title="${configuration.configurationDescription!?html}">[/#if]
                                ${configuration.configurationName!?html}
                                [#if fn.hasGlobalAdminPermission()]</a>[/#if]
                                [#if configuration.shippedWithBamboo]
                                <span class="grey">[@ww.text name="elastic.image.configuration.default" /]</span>
                                [/#if]
                            </td>
                            <td>${configuration.amiId!?html}</td>
                            <td>
                                [#if fn.hasGlobalAdminPermission()]<a href="[@ww.url action='viewElasticInstancesForConfiguration' namespace='/admin/elastic/image/configuration' configurationId=configuration.id /]">[/#if]
                                ${activeInstanceCount}
                                [#if fn.hasGlobalAdminPermission()]</a>[/#if]
                            </td>
                        </tr>
                    [/#list]
                </tbody>
            </table>
        [#else]
            <p>[@ww.text name='agent.image.noneMatching'/]</p>
        [/#if]
    [/#if]
</div>
</body>
</html>