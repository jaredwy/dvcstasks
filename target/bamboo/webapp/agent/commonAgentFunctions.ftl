[#-- ========================================================================================== @agt.executablePlans --]
[#--
    List of executable buildables (builds and jobs)
    @requires executableBuildables
--]
[#macro executablePlans showLastBuild=false]
    [#-- Executable Builds --]
    [@ui.bambooPanel]
        [#if executableBuildables?has_content]
            [@ui.displayText key='agent.builds.execute.description' /]
            <table class="aui">
                <thead>
                    <th class="noRightBorder">&nbsp;</th>
                    <th class="noLeftBorder">[@ww.text name='plan.title' /]</th>
                    [#if showLastBuild]
                        <th>[@ww.text name='agent.builds.execute.built.last.title' /]</th>
                    [/#if]
                </thead>
                <tbody>
                [#list executableBuildables as build]
                    <tr>
                        <td class="minColumn noRightBorder" >
                            ${build_index + 1}.
                        </td>
                        <td class="noLeftBorder">
                            [@ui.renderPlanNameLink plan=build /]
                        </td>
                        [#if showLastBuild]
                            <td>
                                [#assign lastBuild = (action.findLastBuild(build))!("") /]
                                [#if lastBuild?has_content]
                                    [@ww.text name='agent.builds.execute.built.last' ]
                                        [@ww.param][@ui.icon type=lastBuild.buildState /][@ui.renderBuildResultSummary buildResultSummary=lastBuild /][/@ww.param]
                                        [@ww.param]${lastBuild.relativeBuildDate}[/@ww.param]
                                    [/@ww.text]

                                    [#if lastBuild.failed]
                                        [#assign successBuild = (action.findLastSuccessfulBuild(build))!("") /]
                                        <span class="subGrey">

                                        [#if successBuild?has_content]
                                            [@ww.text name='agent.builds.execute.built.last.success' ]
                                                [@ww.param][@ui.renderBuildResultSummary buildResultSummary=successBuild /][/@ww.param]
                                                [@ww.param]${successBuild.relativeBuildDate}[/@ww.param]
                                            [/@ww.text]
                                        [#else]
                                            [@ww.text name='agent.builds.execute.built.last.success.none' /]
                                        [/#if]
                                        </span>
                                    [/#if]
                                [#else]
                                    <span class="subGrey">
                                        [@ww.text name='agent.builds.execute.built.last.none' /]
                                    </span>
                                [/#if]
                            </td>
                        [/#if]
                    </tr>
                [/#list]
                </tbody>
            </table>
        [#else]
            [@ui.displayText key='agent.builds.execute.none' /]
        [/#if]
    [/@ui.bambooPanel]
[/#macro]

[#-- ============================================================================================= @agt.agentDetails --]                
[#--
    Displays the top section of the agents page
    @requires headerKey
    @requires agentId
    @requires showOptions (none, short, all)
--]
[#macro agentDetails headerKey, agentId, showOptions, refresh=false, showStatus='yes', descriptionKey='' ]
    [@ui.bambooPanel titleKey=headerKey ]

    [@ww.text name='agent.builds.successRatio.long' id="successRatePercentageTitle"]
        [@ww.param]${statistics.totalSuccesses}[/@ww.param]
        [@ww.param]${statistics.totalNumberOfResults}[/@ww.param]
    [/@ww.text]
    <div id="agentSuccessRate" class="successRatePercentage" title="${successRatePercentageTitle}">
        <p>
            <span>${statistics.successPercentage}%</span>
            [@ww.text name='agent.builds.successRatio']
                [@ww.param]${statistics.totalSuccesses}[/@ww.param]
                [@ww.param]${statistics.totalNumberOfResults}[/@ww.param]
            [/@ww.text]
        </p>
    </div> <!-- END #successRatePercentage -->
            

    <div style="float: left;">
        [#if descriptionKey?has_content ]
            <div class="descriptionSection">
                [@ww.text name=descriptionKey /]
            </div>
        [/#if]
        [#if refresh]
            [@ww.url id='agentDetailsSnippetUrl' namespace='/ajax' action='viewAgentDetailsSnippet' escapeAmp=false
            agentId=agentId showOptions=showOptions showStatus=showStatus /]
            [@dj.reloadPortlet id='agentDetailsWidget' url="${agentDetailsSnippetUrl}" reloadEvery=10 ]
                [@ww.action name="viewAgentDetailsSnippet" namespace="/ajax" executeResult="true" ]
                    [@ww.param name='showOptions']${showOptions}[/@ww.param]
                    [@ww.param name='agentId']${agentId}[/@ww.param]
                    [@ww.param name='showStatus']${showStatus}[/@ww.param]
                [/@ww.action]
            [/@dj.reloadPortlet]
        [#else]
            [@ww.action name="viewAgentDetailsSnippet" namespace="/ajax" executeResult="true" ]
                [@ww.param name='showOptions']${showOptions}[/@ww.param]
                [@ww.param name='agentId']${agentId}[/@ww.param]
                [@ww.param name='showStatus']${showStatus}[/@ww.param]
            [/@ww.action]
        [/#if]
    </div>
    [#-- buttons --]
    [#if showOptions?? && fn.hasAdminPermission()]
        [#if showOptions == 'all' ]
            <div class="formFooter buttons" style="clear: both;">
                <a href="[@ww.url action='viewAgent' namespace='/agent' agentId='${agentId}' /]">[@ww.text name='agent.view.activity' /]</a>
                | <a href="[@ww.url action='editAgentDetails' namespace='/admin/agent' agentId='${agentId}' returnUrl='${currentUrl}' /]">[@ww.text name='agent.edit' /]</a>
                [#if buildAgent.active]
                    [#if buildAgent.enabled]
                       | <a id="disableQueue:${buildAgent.id}" href="[@ww.url action='disableAgent' namespace='/admin/agent' agentId='${buildAgent.id}' returnUrl='${currentUrl}'/]">[@ww.text name='agent.disable' /]</a>
                    [#else]
                       | <a id="enableQueue:${buildAgent.id}" href="[@ww.url action='enableAgent' namespace='/admin/agent' agentId='${buildAgent.id}' returnUrl='${currentUrl}'/]">[@ww.text name='agent.enable' /]</a>
                    [/#if]
                [/#if]

                [#if buildAgent.active && !buildAgent.requestedToBeStopped]
                    | <a id="stopNicely${buildAgent.id}" href="[@ww.url action='stopAgentNicely' namespace='/admin/agent' agentId='${buildAgent.id}' returnUrl='${currentUrl}'/]"
                         title="[@ww.text name='agent.stop.request.description' /]">[@ww.text name='agent.stop.request' /]</a>
                [/#if]

                [#switch agent.type.freemarkerIdentifier]
                [#case "local"]
                    [#if buildAgent.active && buildAgent.agentStatus.allowDelete]
                        | <a href="[@ww.url action='stopAgent' namespace='/admin/agent' agentId='${agentId}' /]" title="[@ww.text name='agent.stop.description' /]">[@ww.text name='agent.stop' /]</a>
                    [#elseif !buildAgent.active]
                        | <a href="[@ww.url action='startAgent' namespace='/admin/agent' agentId='${agentId}' /]">[@ww.text name='agent.start' /]</a>
                    [/#if]
                    [#-- no break here --]
                [#case "remote"]
                    [#if buildAgent.agentStatus.allowDelete]
                        | <a href="[@ww.url action='removeAgent' namespace='/admin/agent' agentId='${buildAgent.id}'/]" class="requireConfirmation" title="[@ww.text name='agent.delete.description' /]">[@ww.text name='agent.delete' /]</a>
                    [#else]
                        | <span class="disabled" title="[@ww.text name='agent.delete.disable.description' /]">[@ww.text name='agent.delete' /]</span>
                    [/#if]
                [#break]
                [#case "elastic"]
                [#break]
                [/#switch]

            </div>
        [#elseif showOptions == 'short' ]
            <div class="formFooter buttons " style="clear: both;">
                <a href="[@ww.url action='viewAgent' namespace='/admin/agent' agentId='${agentId}' /]">[@ww.text name='agent.admin' /]</a>
            </div>
        [/#if]
    [/#if]

    [/@ui.bambooPanel]
[/#macro]

[#-- =================================================================================================== @agt.header --]
[#--
    Displays the title of the page
    @requires agent
    @requires agentsListUrl - URL for the agents page
--]
[#macro header]
<h1>
    <a href="${agentsListUrl}" id="agentsList" title="[@ww.text name='agents.view.title' /]">[#t]
        [@ww.text name='agent.title' /]</a> &rsaquo; ${agent.name?html}
    <span class="grey">([#rt]
    [@ww.text name='agent.type.' + agent.type.freemarkerIdentifier /]
    )</span>[#lt]
</h1>
[#if (agent.description)?has_content]
    <div class="grey">${agent.description?html}</div>
[/#if]
[/#macro]

[#-- ======================================================================================== @agt.displayStatusCell --]
[#--
    Shows an agent status
--]
[#macro displayStatusCell agent]
    [#assign currentAgentStatus = agent.agentStatus /]
    <img src="${req.contextPath}${currentAgentStatus.imagePath}" alt="${currentAgentStatus.label}" />
    [#if currentAgentStatus.url??]
        <a href="${req.contextPath}${currentAgentStatus.url}">[#rt]
    [/#if]
    [#if !agent.active]
        [@ww.text name='agent.status.offline.title' /][#t]
    [#else]
        ${currentAgentStatus.label}[#t]
    [/#if]
    [#if currentAgentStatus.url??]
        </a> [#lt]
    [/#if]
    [#if !agent.enabled]
        [#if currentAgentStatus.idle || !agent.active]
            <span class="errorText">([@ww.text name='agent.status.disabled.title' /])</span>
        [#else]
            <span class="errorText">[@ww.text name='agent.status.disabledButBusy.title' /]</span>
        [/#if]
    [/#if]
    [#if agent.active && agent.requestedToBeStopped]
        <span class="errorText" title="[@ww.text name='agent.stop.request.description' /]">[@ww.text name='agent.status.stopRequested' /]</span>
    [/#if]
[/#macro]
[#-- ==================================================================================== @agt.displayOperationsCell --]
[#--
    Shows available operations
--]
[#macro displayOperationsCell agent]
    <a id="view:${agent.id}" href="[@ww.url action='viewAgent' namespace='/admin/agent' agentId='${agent.id}'/]">[@ww.text name='global.buttons.view' /]</a> |
    <a id="edit:${agent.id}" href="[@ww.url action='editAgentDetails' namespace='/admin/agent' agentId='${agent.id}' returnUrl='${currentUrl}'/]">[@ww.text name='global.buttons.edit' /]</a>
[/#macro]

[#macro displayOperationsHeader agentType deleteOnly=false basicSelectorsOnly=false isPaginated=false isCompleteContentSelected=false ]
    <p>
        <span>
        [@ww.text name='global.selection.select' /]:
        <span tabindex="0" role="link" selector="${agentType}_all">[@ww.text name='global.selection.all' /]</span>,
        <span tabindex="0" role="link" selector="${agentType}_none">[@ww.text name='global.selection.none' /]</span>[#rt]
        [#if !basicSelectorsOnly]
            ,[#t]
            <span tabindex="0" role="link" selector="${agentType}_idle">[@ww.text name='agent.status.idle.title' /]</span>,
            <span tabindex="0" role="link" selector="${agentType}_disabled">[@ww.text name='agent.status.disabled.title' /]</span>
        [/#if]
        </span>

        <span class="formActionsBar">
            [@ww.text name='global.selection.action' /]:
            [@ww.submit value=action.getText("agent.delete") theme="simple" name="deleteButton" id="delete${agentType}AgentButton" cssClass="requireConfirmation" cssStyle="display: inline-block;" titleKey="agent.delete.description"/]

            [#if !deleteOnly]
                [@ww.submit value=action.getText("agent.disable") theme="simple" name="disableButton" id="disable${agentType}AgentButton" /]
                [@ww.submit value=action.getText("agent.enable") theme="simple" name="enableButton" id="enable${agentType}AgentButton" /]
            [/#if]
        </span>
    </p>

    [#if isPaginated]
    <p>
        [@ww.hidden name="completeContentSelected" cssClass="${agentType}_completeContentSelected" nameValue="${isCompleteContentSelected?string}" /]

        [#assign shownElementsCount = pager.page.endIndex - pager.page.startIndex /]
        [#if shownElementsCount != pager.totalSize ]
            <div class="${agentType}_paginatedSelectAllWarning ${agentType}_paginatedWarning hidden formCompleteContentSelectionStatus">
                    [@ww.text name="agent.mark.pagination.count"][@ww.param value="${shownElementsCount}"/][/@ww.text]
                    <span tabindex="0" role="link" selector="${agentType}_allPages">
                        [@ww.text name="agent.mark.pagination.select.all"][@ww.param value="${pager.totalSize}"/][/@ww.text]
                    </span>
            </div>
            <div class="${agentType}_paginatedAllPagesSelected ${agentType}_paginatedWarning [#if !isCompleteContentSelected] hidden [/#if] formCompleteContentSelectionStatus">
                    [@ww.text name="agent.mark.pagination.selected.all"][@ww.param value="${pager.totalSize}"/][/@ww.text]
            </div>
        [/#if]
    </p>
    [/#if]

    <script type="text/javascript">
        AJS.$(function() {
            SelectionActions.init("${agentType}");
        });
    </script>
[/#macro]

[#-- ====================================================================================== @agt.displayCapabilities --]
[#--
    Shows a an li showing a set of capabilities. Agent may not actually exist

    @requires capabilitySet - set of capabilities to display
--]
[#macro displayCapabilities capabilitySetDecorator addCapabilityUrlPrefix='' elasticImageConfiguration='' showEdit=true showDelete=false showDescription=true returnAfterOpUrl='']

[#list capabilitySetDecorator.groups as group]
[#if addCapabilityUrlPrefix?has_content]
    [#assign addCapLink]
        <a id="addCapability:${group.typeKey}" href="${addCapabilityUrlPrefix}&capabilityType=${group.typeKey}">[@ww.text name='global.buttons.add' /] [@ww.text name='agent.capability.type.${group.typeKey}.title' /]</a>
    [/#assign]
[#else]
    [#assign addCapLink = '' /]
[/#if]

    [@ui.bambooSection titleKey='agent.capability.type.${group.typeKey}.title'
                       tools='${addCapLink!}']
        [#if showDescription]
            [@ui.displayText key='agent.capability.type.${group.typeKey}.description' /]
        [/#if]

    <table id="capabilities-${group.typeKey}" class="capabilities aui">
        <thead>
            <tr>
                <th class="labelPrefixCell">
                    [@ww.text name='agent.capability.type.${group.typeKey}.key' /]
                    [@ww.text name='agent.capability.type.${group.typeKey}.key.description' id='keyDescription' /]
                    [#if keyDescription?has_content]
                        <br />
                        <span class="subGrey">${keyDescription}</span>
                    [/#if]
                </th>
                <th class="valueCell">
                    [@ww.text name='agent.capability.type.${group.typeKey}.value' /]
                    [@ww.text name='agent.capability.type.${group.typeKey}.value.description' id='valueDescription' /]
                    [#if valueDescription?has_content]
                        <br />
                        <span class="subGrey">${valueDescription}</span>
                    [/#if]
                </th>
                <th class="operations">
                    Operations
                </th>
            </tr>
        </thead>
    [#list group.decoratedObjects as capability]

        <tr [#if capabilityKey?exists && capabilityKey == capability.key]
                class="selectedRow" [#lt]
            [/#if]>
            <td class="labelPrefixCell">
                [@showName capability=capability /]
            </td>
            <td class="valueCell">
                ${capability.value!?html}
                [#if capability.overriddenValue?has_content]
                    <br />
                    <span class="subGrey">(Overrides: ${capability.overriddenValue?html})</span>
                [/#if]
            </td>
            <td class="operations">
                [@showCapabilityOperations capability=capability agent=agent elasticImageConfiguration=elasticImageConfiguration showView=true showEdit=showEdit showDelete=showDelete returnAfterOpUrl=returnAfterOpUrl/]
            </td>
        </tr>
    [/#list]
    </table>
    [/@ui.bambooSection]
[/#list]
[/#macro]

[#-- ================================================================================================= @agt.showName --]
[#-- Function to return the name of the decorated capability object --]
[#macro showName capability]
    [#if fn.hasGlobalAdminPermission()]
        <a id="title:${capability.key?html}" href="[@ww.url action='viewCapabilityKey' namespace='/admin/agent' capabilityKey=capability.key /]">${capability.label?html}</a>
    [#else]
        ${capability.label?html}
    [/#if]
    [#if capability.extraInfo?has_content]
        <span class="subGrey">(${capability.extraInfo})</span>
    [/#if]
[/#macro]

[#-- ================================================================================ @agt.showRequirementOperations --]
[#-- Show requirement operations --]
[#macro showRequirementOperations requirement build returnUrl='']
    [#if !requirement.readonly]
        [#assign deleteUrl='${req.contextPath}/build/admin/edit/deleteBuildRequirement.action?buildKey=${build.key}&requirementId=${requirement.id?url}' /]
        [#if returnUrl != '']
            [#assign deleteUrl='${deleteUrl}&amp;returnUrl=${returnUrl}' /]
        [/#if]
        <a href="${deleteUrl}" class="requireConfirmation" title="[@ww.text name='agent.requirement.delete.description' /]">[@ww.text name='global.buttons.delete' /]</a>
    [/#if]
[/#macro]

[#-- ================================================================================= @agt.showCapabilityOperations --]
[#--
    Show capability operations. show* flags determines if links will be attempted to be shown (may not actually appear
    depending on permissions or agent existance
--]
[#macro showCapabilityOperations capability agent='' elasticImageConfiguration='' showView=false showEdit=false showDelete=false returnAfterOpUrl='']

[#assign finalReturnUrl = returnAfterOpUrl/]
[#if !finalReturnUrl?has_content]
    [#assign finalReturnUrl = currentUrl /]
[/#if]

[#if showView]
    <a id="view:${capability.key?html}" href="[@ww.url action='viewCapabilityKey' namespace='/admin/agent' capabilityKey=capability.key /]">[@ww.text name='global.buttons.view' /]</a>
[/#if]
[#if fn.hasAdminPermission()]
    [#assign sharedCapabilityType = (capability.capabilitySet.sharedCapabilitySetType)!("") /]

    [#if sharedCapabilityType?has_content]
        [#-- Shared capability --]
        [#if showEdit && fn.hasGlobalAdminPermission()]
            [#if showView] | [/#if]
            <a id="edit:${capability.key?html}Shared${sharedCapabilityType}" href="[@ww.url action='editSharedCapability' namespace='/admin/agent' sharedCapabilitySetType=sharedCapabilityType capabilityKey=capability.key returnUrl=finalReturnUrl /]">[@ww.text name='global.buttons.edit' /]</a>
        [/#if]
        [#if showDelete && fn.hasGlobalAdminPermission()]
            [#if showEdit] | [/#if]
            <a id="delete:${capability.key?html}Shared${sharedCapabilityType}" href="[@ww.url action='deleteShared${sharedCapabilityType}Capability' namespace='/admin/agent' capabilityKey=capability.key returnUrl=finalReturnUrl /]" class="requireConfirmation" title="[@ww.text name='agent.capability.delete.description' /]">[@ww.text name='global.buttons.delete' /]</a>
        [/#if]

    [#else]
        [#-- Image or agent capability --]
        [#if agent?has_content]
            [#if showEdit]
                [#if showView] | [/#if]
                <a id="edit:${capability.key?html}From${agent.name?html}" href="[@ww.url action='editCapability' namespace='/admin/agent' agentId=agent.id capabilityKey=capability.key returnUrl=finalReturnUrl /]">[@ww.text name='global.buttons.edit' /]</a>
            [/#if]
            [#if showDelete]
                [#if showEdit] | [/#if]
                <a id="delete:${capability.key?html}From${agent.name?html}" href="[@ww.url action='deleteAgentCapability' namespace='/admin/agent' agentId=agent.id capabilityKey=capability.key returnUrl=finalReturnUrl /]" class="requireConfirmation" title="[@ww.text name='agent.capability.delete.description' /]">[@ww.text name='global.buttons.delete' /]</a>
            [/#if]
        [#elseif elasticImageConfiguration?has_content]
            [#-- Agent has not been found... may belong to an elastic image instead --]
             [#if showEdit]
                [#if showView] | [/#if]
                <a id="edit:${capability.key?html}From${elasticImageConfiguration.id}" href="[@ww.url action='editElasticCapability' namespace='/admin/elastic' configurationId=elasticImageConfiguration.id capabilityKey=capability.key returnUrl=finalReturnUrl /]">[@ww.text name='global.buttons.edit' /]</a>
            [/#if]
            [#if showDelete]
                [#if showEdit] | [/#if]
                <a id="delete:${capability.key?html}From${elasticImageConfiguration.id}" href="[@ww.url action='deleteElasticCapability' namespace='/admin/elastic' configurationId=elasticImageConfiguration.id capabilityKey=capability.key returnUrl=finalReturnUrl /]" class="requireConfirmation" title="[@ww.text name='agent.capability.delete.description' /]">[@ww.text name='global.buttons.delete' /]</a>
            [/#if]
        [/#if]
    [/#if]
[/#if]
[/#macro]
[#-- ======================================================================================= @agt.shoRequirementCell --]
[#-- Show requirement cell --]
[#macro shoRequirementCell  requirement]
<td class="valueCell" title="[@ww.text name='requirement.matchType.${requirement.matchType}.description' /]">
    [@ww.text name='requirement.matchType.${requirement.matchType}' /][#rt]
    [#if requirement.matchValue?has_content]
        <span>${requirement.matchValue!?html}</span>
    [/#if]
</td>
[/#macro]

[#-- ============================================================================== @agt.displayEditCapabilityFields --]
[#macro displayEditCapabilityFields]
    [#assign typeText = action.getText('agent.capability.type.${capabilityType}.title') /]
    [@ww.label labelKey='agent.capability.type' value="${typeText}" /]
    [@ww.label labelKey='agent.capability.type.${capabilityType}.key' name='capability.label' /]
    [@ww.textfield labelKey='agent.capability.type.${capabilityType}.value' name='capabilityValue' /]
[/#macro]

[#-- ============================================================================== @agt.onlineAgents --]
[#macro onlineAgents showLogs=true showOperations=true]

[#-- Description at the top--]
[#if onlineRemoteAgents?has_content]
    [#if numberOfOnlineRemoteAgents == 0]
        [@ww.text name='agent.remote.numberOnline.none'/]
    [#else]
        [#if elasticBambooEnabled]
            [#if numberOfOnlineElasticAgents != 0]
                [#if numberOfOnlineRemoteAgents != numberOfOnlineElasticAgents]
                    [@ww.text name='${elasticEnabledTextKey}']
                        [@ww.param value=numberOfOnlineRemoteAgents /]
                        [@ww.param value=numberOfOnlineRemoteAgents - numberOfOnlineElasticAgents /]
                        [@ww.param value=numberOfOnlineElasticAgents /]
                        [@ww.param value=numberOfRequestedElasticAgents /]
                        [@ww.param value=allowedNumberOfRemoteAgents /]
                        [@ww.param]<a href="[@ww.url namespace='/admin/elastic' action='manageElasticInstances' /]">[/@ww.param]
                        [@ww.param]</a>[/@ww.param]
                    [/@ww.text]
                [#else]
                    [@ww.text name='${onlyElasticOnlineTextKey}']
                        [@ww.param value=numberOfOnlineRemoteAgents /]
                        [@ww.param value=numberOfRequestedElasticAgents /]
                        [@ww.param value=allowedNumberOfRemoteAgents /]
                        [@ww.param]<a href="[@ww.url namespace='/admin/elastic' action='manageElasticInstances' /]">[/@ww.param]
                        [@ww.param]</a>[/@ww.param]
                    [/@ww.text]
                [/#if]
            [#else]
                [@ww.text name='${noElasticOnlineTextKey}']
                    [@ww.param value=numberOfOnlineRemoteAgents /]
                    [@ww.param value=numberOfRequestedElasticAgents /]
                    [@ww.param value=allowedNumberOfRemoteAgents /]
                    [@ww.param]<a href="[@ww.url namespace='/admin/elastic' action='manageElasticInstances' /]">[/@ww.param]
                    [@ww.param]</a>[/@ww.param]
                [/@ww.text]
            [/#if]
        [#else]
            [@ww.text name='${onlyRemoteOnlineElasticDisabledTextKey}']
                [@ww.param value=numberOfOnlineRemoteAgents /]
            [/@ww.text]
        [/#if]
    [/#if]
[/#if]


[#--The Data Table--]
[#if onlineRemoteAgents?has_content]
    [@ww.form action="configureAgents!reconfigure.action" id="remoteAgentConfiguration" theme="simple"]
        [#if showOperations]
            <hr>
            [@agt.displayOperationsHeader agentType='RemoteOnline'/]
        [/#if]
        <table id="remote-agents" class="aui">
            <colgroup>
                [#if showOperations]
                <col width="5"/>
                [/#if]
                <col />
                <col width="185" />
                [#if showOperations]
                    <col width="95" />
                [/#if]
            </colgroup>
            <thead>
                <tr>
                    [#if showOperations]
                        <th>&nbsp;</th>
                    [/#if]
                    <th>[@ww.text name='agent.table.heading.name' /]</th>
                    <th>[@ww.text name='agent.table.heading.status' /]</th>
                    [#if showOperations]
                        <th>[@ww.text name='agent.table.heading.operations' /]</th>
                    [/#if]
                </tr>
            </thead>
            <tbody>
                [#foreach agent in onlineRemoteAgents]
                    <tr class="agent${agent.agentStatus}">
                        [#if showOperations]
                            <td><input name="selectedAgents" type="checkbox" value="${agent.id}" class="selectorAgentType_RemoteOnline selectorAgentEnabled_${agent.enabled?string} selectorAgentStatus_${agent.agentStatus}"> </td>
                        [/#if]
                        <td>[@ui.renderAgentNameAdminLink agent/]</td>
                        <td class="agentStatus">[@agt.displayStatusCell agent=agent /]</td>
                        [#if showOperations]
                            <td valign="center">
                            [@agt.displayOperationsCell agent=agent /]
                            </td>
                        [/#if]
                    </tr>
                [/#foreach]
            </tbody>
        </table>
    [/@ww.form]
[#else]
    [#if planKey??]
        [@ww.text name='agent.remote.noneMatching'/]
    [#else]
        [@ww.text name='agent.remote.none' /]
    [/#if]
[/#if]

[#if showLogs]
    [#--Live Remote Agent Logs--]
    [@dj.reloadPortlet id='remoteAgentsWidget' url='${req.contextPath}/ajax/viewRemoteAgentsLogSnippet.action' reloadEvery=10]
            [@ww.action name="viewRemoteAgentsLogSnippet" namespace="/ajax" executeResult="true"]
            [/@ww.action]
    [/@dj.reloadPortlet]
[/#if]

[/#macro]

[#-- ============================================================================== @agt.offlineAgents --]
[#macro offlineAgents]
    <div id="offlineAgentSection">
     [@ww.action name="viewOfflineRemoteAgents" namespace="/ajax" executeResult="true" /]
    </div>
[/#macro]