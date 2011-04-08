[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ConfigureCapabilityKey" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ConfigureCapabilityKey" --]

[#macro viewCapabilityKey parentUrl mode="tabs" ]

    [#import "/agent/commonAgentFunctions.ftl" as agt]
    [#if  mode != "tabs"]
        [#assign capabilityTabUrl = "${parentUrl}"/]
    [#else]
        [#assign capabilityTabUrl = "${parentUrl}#${capabilityTabId}"/]
    [/#if]

    <h1>
        ${capability.label?html}
    </h1>

    <p>
        [@ww.text name='agent.capability.view.description' /]
    </p>

    [@ui.bambooPanel]
    [@ui.bambooSection titleKey="agent.capability.capabilityAgent"]
    [#if capabilityAgentMappingsSorted?has_content]
        <p>[@ww.text name='agent.capability.capabilityAgent.description' /]</p>
        <table class="aui">
            <thead>
                <tr>
                    <th class="agentCell labelPrefixCell">
                        [@ww.text name='agent.table.heading.name' /]
                    </th>
                    <th class="valueCell">
                        [@ww.text name='agent.capability.type.${capabilityType}.value' /]
                    </th>
                    <th class="operations">
                        [@ww.text name='global.heading.operations' /]
                    </th>
                </tr>
            </thead>
        [#list capabilityAgentMappingsSorted as capabilityAgentMapping]
            [#assign capability =  capabilityAgentMapping.key/]
            [#assign agent = capabilityAgentMapping.value!("") /]
            <tr>
                <td class="agentCell labelPrefixCell">
                    [#assign sharedCapabilitySetType = (capability.capabilitySet.sharedCapabilitySetType)!("") /]
                    [#if sharedCapabilitySetType?has_content]
                        <a href="[@ww.url action='configureShared${sharedCapabilitySetType}Capabilities' namespace='/admin/agent' /]">[@ww.text name='agent.capability.agents.all.${sharedCapabilitySetType}' /]</a>
                    [#else]
                        [#if agent?has_content]
                            <a href="[@ww.url action='viewAgent' namespace='/admin/agent' agentId=agent.id /]">${agent.name?html}</a>
                        [/#if]
                    [/#if]
                </td>
                <td class="valueCell">
                    ${capability.value!?html}
                </td>
                <td class="operations">
                    [@agt.showCapabilityOperations capability=capability agent=agent showEdit=true showDelete=true returnAfterOpUrl="${capabilityTabUrl}" /]
                </td>
            </tr>
        [/#list]
        </table>
    [#else]
        [@ww.text name='agent.capability.capabilityAgent.none' /]
    [/#if]
    [/@ui.bambooSection]


    [#if elasticSupportPossible]
    [@ui.bambooSection titleKey="agent.capability.capabilityElasticImage"]
        [#if capabilityElasticImageMappings?has_content]
            [#if !elasticBambooEnabled]
                [@ww.text name='agent.capability.capabilityElasticImage.description.elasticDisabled' ]
                    [@ww.param][@ww.url action='viewElasticConfig' namespace='/admin/elastic' /][/@ww.param]
                [/@ww.text]
            [#else]
                <p>
                [@ww.text name='agent.capability.capabilityElasticImage.description' ]
                    [@ww.param name="value" value="${capabilityElasticImageMappings.size()}"/]
                [/@ww.text] </p>[#rt]

                <table id="capabilityElasticImageMappings" class="aui">
                    <thead>
                        <tr>
                            <th class="agentCell labelPrefixCell">
                                [@ww.text name='elastic.image.configuration.heading' /]
                            </th>
                            <th class="valueCell">
                                [@ww.text name='agent.capability.type.${capabilityType}.value' /]
                            </th>
                        </tr>
                    </thead>
                [#list capabilityElasticImageMappings as capabilityElasticImageMapping]
                    [#assign capability =  capabilityElasticImageMapping.capability/]
                    [#assign elasticImageConfiguration =  (capabilityElasticImageMapping.elasticImageConfiguration)!("") /]
                    <tr>
                        <td class="agentCell labelPrefixCell">
                            <a href="[@ww.url action='viewElasticImageConfiguration' namespace='/admin/elastic/image/configuration' configurationId=elasticImageConfiguration.id /]">${elasticImageConfiguration.configurationName?html}</a>
                        </td>
                        <td class="valueCell">
                            ${capability.value!""?html}
                        </td>
                    </tr>
                [/#list]
                </table>
            [/#if]
        [#else]
            [@ww.text name='agent.capability.capabilityElasticImage.none' /]
        [/#if]
    [/@ui.bambooSection]
    [/#if]

    [@ui.bambooSection titleKey="agent.capability.planRequirement"]
    [#assign decoratedRequirements = requirementSetDecorator.decoratedObjects /]
    [#if decoratedRequirements?has_content]
        <p>
        [@ww.text name='agent.capability.planRequirement.description' ]
            [@ww.param name="value" value="${decoratedRequirements.size()}"/]
        [/@ww.text]
        </p>
        <table class="aui">
            <thead>
                <tr>
                    <th class="planCell labelPrefixCell">
                        [@ww.text name='plan.title' /]
                    </th>
                    <th class="valueCell">
                        [@ww.text name='agent.capability.type.${capabilityType}.value' /]
                    </th>
                    <th class="operations">
                        [@ww.text name='global.heading.operations' /]
                    </th>
                </tr>
            </thead>
        [#list decoratedRequirements as requirement]
            [#assign build = requirement.build /]
            <tr>
                <td class="planCell labelPrefixCell">
                    [#if build.type=="JOB"]
                        <a title="${build.parent.key}" href="[@ww.url value='/browse/${build.parent.key}'/]">${build.parent.project.name} &rsaquo; ${build.parent.buildName} </a> &rsaquo; <a title="${build.key}" href="[@ww.url action='defaultBuildRequirement' namespace='/build/admin/edit' buildKey=build.key/]">${build.buildName}</a>
                    [#else]
                        <a title="${build.key}" href="[@ww.url action='defaultBuildRequirement' namespace='/build/admin/edit' buildKey=build.key/]">${build.name}</a>
                    [/#if]
                </td>

                [@agt.shoRequirementCell requirement=requirement /]

                <td class="operations">
                    [@agt.showRequirementOperations requirement=requirement build=build returnUrl='${capabilityTabUrl}'/]
                </td>
            </tr>
        [/#list]
        </table>
    [#else]
        [@ww.text name='agent.capability.planRequirement.none' /]
    [/#if]
    [/@ui.bambooSection]

    [#if hasCapabilityConfiguratorPluginForViewPerspective]
    [@ui.bambooSection titleKey="agent.capability.configuration"]
        [#list capabilityConfiguratorPluginViewHtmlList as capabilityConfiguratorHtml]
            ${capabilityConfiguratorHtml}
        [/#list]
    [/@ui.bambooSection ]
    [/#if]


    <div class="buttons formFooter">
        [#if capabilityType.allowRename]
            [#if  mode != "tabs"]
                <a id="rename:${capability.key?html}" href="[@ww.url action='renameCapability' namespace='/admin/agent' capabilityKey=capability.key /]">[@ww.text name='agent.capability.rename' /]</a>
            [#else]
                <a id="rename:${capability.key?html}" href="[@ww.url action='renameCapability' namespace='/admin/agent' capabilityKey=capability.key returnUrl=parentUrl/]">[@ww.text name='agent.capability.rename' /]</a>
            [/#if]
        [/#if]
        [#if hasCapabilityConfiguratorPluginForEditPerspective]
            | <a id="configure_${capability.key?html}" href="[@ww.url action='editCapabilityKey' namespace='/admin/agent' capabilityKey=capability.key returnUrl='${capabilityTabUrl}'/]">[@ww.text name='agent.capability.configuration.edit' /]</a>
        [/#if]
    </div>
    [/@ui.bambooPanel]

[/#macro]
