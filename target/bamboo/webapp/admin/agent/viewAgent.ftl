[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ViewAgentAdmin" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ViewAgentAdmin" --]

[#import "/agent/commonAgentFunctions.ftl" as agt]
<html>
<head>
    <title>
    [@ww.text name='agent.view.heading.' + agent.type.freemarkerIdentifier /]
    [#switch agent.type.freemarkerIdentifier]
    [#case "local"]
        [@ww.url id='sharedCapabilityUrl' action='configureSharedLocalCapabilities' namespace='/admin/agent' /]
    [#break]
    [#case "remote"]
        [@ww.url id='sharedCapabilityUrl' action='configureSharedRemoteCapabilities' namespace='/admin/agent' /]
    [#break]
    [#case "elastic"]
    [#break]
    [/#switch]
    - ${agent.name?html}
    </title>
    [@ww.url value='/admin/agent/viewAgents.action' id='agentsListUrl' /]    
    <meta name="decorator" content="adminpage">
</head>

<body>
    [@agt.header /]

    [@agt.agentDetails headerKey='agent.details' agentId=agent.id showOptions="all" /]

    [@ui.clear /]

[#switch agent.type.freemarkerIdentifier]
[#case "local"]
[#case "remote"]
    [#assign tabs=[action.getText('agent.capabilities'),action.getText('agent.builds.execute'),action.getText('system.info.title')] /]
[#break]
[#case "elastic"]
    [#assign tabs=[action.getText('elastic.image.capabilities'),action.getText('agent.builds.execute'),action.getText('system.info.title')] /]
[#break]
[/#switch]
[@dj.tabContainer headings=tabs selectedTab='${selectedTab!}']
    [#switch agent.type.freemarkerIdentifier]
    [#case "local"]
    [#case "remote"]
        [@dj.contentPane labelKey='agent.capabilities']
            [#-- Specific Capabilities --]
            [@ww.url action='configureAgentCapability' namespace='/admin/agent' agentId='${agentId}' id='addCapabilityUrl' /]
            [@ui.bambooPanel titleKey='agent.capability.specific.title' descriptionKey='agent.capability.specific.description'
                             tools='<a id="addCapability" href="${addCapabilityUrl}">${action.getText("agent.capability.add")}</a>']
                [#if capabilitySet?exists && capabilitySet.capabilities?has_content]
                    [@ui.displayText key='agent.capability.specific.prefix' /]
                    [@agt.displayCapabilities capabilitySetDecorator=capabilitySetDecorator
                                             addCapabilityUrlPrefix=addCapabilityUrl
                                             showDelete=true /]
                    [#assign showDesc = false /]
                [#else]
                    [#assign showDesc = true /]
                    [@ui.displayText key='agent.capability.specific.empty' /]
                [/#if]
            [/@ui.bambooPanel]


            [#-- Shared Capabilities --]
            [#if (fn.hasGlobalAdminPermission())]
                [#assign editLink]
                    <a  id="addSharedCapability" href="${sharedCapabilityUrl}">${action.getText("global.buttons.edit")}</a>
                [/#assign]
            [#else]
                [#assign editLink='']
            [/#if]

            [@ui.bambooPanel titleKey='agent.capability.inherited.shared.title' descriptionKey='agent.capability.inherited.shared.description' tools=editLink]
                [#if sharedCapabilitySet?exists && sharedCapabilitySet.capabilities?has_content]
                    [@agt.displayCapabilities capabilitySetDecorator=sharedCapabilitySetDecorator addCapabilityUrlPrefix='' showDescription=showDesc/]
                [#else]
                    [@ui.displayText key='agent.capability.inherited.shared.empty' /]
                [/#if]
            [/@ui.bambooPanel]
        [/@dj.contentPane]

        [@dj.contentPane labelKey='agent.builds.execute']
            [@agt.executablePlans showLastBuild=true /]
        [/@dj.contentPane]

    [#break]
    [#case "elastic"]
        [#assign image=agent.elasticImageConfiguration]
        [@dj.contentPane labelKey='elastic.image.capabilities']
            [@ui.bambooPanel titleKey='elastic.image.capabilities' descriptionKey='elastic.image.capabilities.description']
                [#if capabilitySet?exists && capabilitySet.capabilities?has_content]
                    [@ui.displayText key='elastic.image.capabilities.prefix' /]
                    [@agt.displayCapabilities capabilitySetDecorator=capabilitySetDecorator showEdit=false showDelete=false /]
                    [#assign showDesc = false /]
                [#else]
                    [#assign showDesc = true /]
                    [@ui.displayText key='elastic.image.capabilities.empty' /]
                [/#if]
            [/@ui.bambooPanel]
        [/@dj.contentPane]

        [@dj.contentPane labelKey='agent.builds.execute']
            [@agt.executablePlans /]
        [/@dj.contentPane]
    [#break]
    [/#switch]

    [@dj.contentPane labelKey='system.info.title']
        [#if systemInfo?exists]
            [@ui.bambooPanel]
                [@ui.bambooSection]
                    [@ww.label label='System Date' name='systemInfo.systemDate' /]
                    [@ww.label label='System Time' name='systemInfo.systemTime' /]
                    [@ww.label label='Up Time' name='systemInfo.uptime' /]
                    [@ww.label label='Username' name='systemInfo.userName' /]
                    [@ww.label label='User Timezone' name='systemInfo.userTimezone' /]
                    [@ww.label label='User Locale' name='systemInfo.userLocale' /]
                    [@ww.label label='System Encoding' name='systemInfo.systemEncoding' /]
                    [@ww.label label='Operating System' name='systemInfo.operatingSystem' /]
                    [@ww.label label='Operating System Architecture' name='systemInfo.operatingSystemArchitecture' /]
                    [@ww.label label='Available Processors' name='systemInfo.availableProcessors' /]
                [/@ui.bambooSection]
                [@ui.bambooSection title="Network" ]
                    [@ww.label label='Host Name' name='systemInfo.hostName' /]
                    [@ww.label label='IP Address' name='systemInfo.ipAddress' /]
                [/@ui.bambooSection]
                [@ui.bambooSection title="Memory Statistics" ]
                    [@ww.label label='Total Memory' value='${systemInfo.totalMemory} MB' /]
                    [@ww.label label='Free Memory' value='${systemInfo.freeMemory} MB' /]
                    [@ww.label label='Used Memory' value='${systemInfo.usedMemory} MB' /]
                [/@ui.bambooSection]

                [@ui.bambooSection title='Bamboo Paths' ]
                    [@ww.label label='Current running directory' name='systemInfo.currentDirectory' /]
                    [@ww.label labelKey='config.server.buildDirectory' name='systemInfo.buildWorkingDirectory' /]
                    [@ww.label label='Bamboo Home' name='systemInfo.applicationHome' /]
                    [@ww.label label='Temporary directory' name='systemInfo.tempDir' /]
                    [@ww.label labelKey='system.bambooPaths.userHome' name='systemInfo.userHome' /]
                [/@ui.bambooSection]

                [@ui.bambooSection titleKey='system.file.stats' ]
                    [@ww.label labelKey='system.file.disk.free' name='systemInfo.freeDiskSpace' /]
                [/@ui.bambooSection]
            [/@ui.bambooPanel]
        [#else]
        <p>
            [@ui.displayText key='No system information found' /]
        </p>
        [/#if]
    [/@dj.contentPane]
[/@dj.tabContainer]






</body>
</html>
