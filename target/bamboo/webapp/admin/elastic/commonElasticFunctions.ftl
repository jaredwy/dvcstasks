[#import "/agent/commonAgentFunctions.ftl" as agt]
[#-- @ftlvariable name="currentSpotPrices" type="com.atlassian.aws.ec2.SpotPriceMatrix" --]
[#-- @ftlvariable name="instanceTypes" type="com.amazonaws.services.ec2.model.InstanceType[]" --]
[#-- @ftlvariable name="confElasticCloudAction" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticCloudAction" --]
[#-- @ftlvariable name="instances" type="java.util.List<com.atlassian.bamboo.agent.elastic.server.RemoteElasticInstance>" --]

[#-- =================================================================================================== @ela.headerInstance --]
[#--
    Displays the title of the page
    @requires instanceId
    @requires instanceListUrl - URL for the instance page
    @requires elasticMainUrl - URL for the main elastic page
--]
[#macro headerInstance instanceId, instanceListUrl, elasticMainUrl]
<h1>
    <a href="${elasticMainUrl}" id="elasticMain" title="[@ww.text name='elastic.main.view.title' /]">[#t]
        [@ww.text name='elastic.main.title' /]</a>
        &rsaquo; <a href="${instanceListUrl}" id="instanceList" title="[@ww.text name='elastic.instances.view.title' /]">[#t]
            [@ww.text name='elastic.instances.title' /]</a>
        &rsaquo; ${instanceId}
</h1>
[/#macro]
[#-- =================================================================================================== @ela.displayElasticInstanceId --]
[#-- Simple macro for displaying the intanceId, in case we want to add prtty status etc. --]
[#macro displayElasticInstanceId instanceId, instance='' ]
    [#if instance?has_content]
        <a href="[@ww.url action='viewElasticInstance' namespace='/admin/elastic' instanceId=instanceId /]">[@ww.text name='elastic.instance'/] ${instanceId}</a>
    [#else]
        [@ww.text name='elastic.instance'/] ${instanceId}
    [/#if]
[/#macro]
[#-- =================================================================================================== @ela.displayElasticCOnfigurationName --]
[#-- Simple macro for displaying the elastic configuration, in case we want to add prtty status etc. --]
[#macro displayElasticConfigurationName configuration ]
    [#if configuration?has_content]
        [#if fn.hasAdminPermission()]
            <a href="[@ww.url action='viewElasticImageConfiguration' namespace='/admin/elastic/image/configuration' configurationId=configuration.id /]">${configuration.configurationName?html}</a>[#t]
        [#else]
            ${configuration.configurationName!?html}[#t]
        [/#if]
    [/#if]
[/#macro]
[#-- =================================================================================================== @ela.agentHistoryHeader --]
[#--
    Displays the title of the page
    @requires agent
    @requires historyUrl - URL for elastic history
--]
[#macro agentHistoryHeader agent, historyUrl='' ]
<h1>
    [#if historyUrl?has_content]
        <a href="${historyUrl}" id="historyList" title="[@ww.text name='elastic.agent.history.title' /]">[#t]
        [@ww.text name='elastic.agent.history.heading' /]</a> &rsaquo;
    [/#if]
    ${agent.name?html}
    <span class="grey">([#rt]
    [@ww.text name='agent.type.' + agent.type.freemarkerIdentifier /]
    )</span>[#lt]
</h1>
[#if (agent.description)?has_content]
    <div class="grey">${agent.description?html}</div>
[/#if]
[/#macro]
[#-- ============================================================================== @ela.elasticImageConfigurationViewProperties --]
[#--
    Displays properties of ElasticImageConfiguration  
    @requires configuration ElasticImageConfiguration object
--]
[#macro elasticImageConfigurationViewProperties configuration displayConfigurationUrl=false short=false ]
    [#if displayConfigurationUrl]
        [@ww.url id='elasticConfigurationUrl' namespace='/admin/elastic/image/configuration' action='viewElasticImageConfiguration' configurationId=configuration.id /]
        [@ww.label labelKey='elastic.configuration' escape=false description=configuration.configurationDescription?html]
            [@ww.param name="value"]
            <a href="${elasticConfigurationUrl?html}">
                ${image.configurationName?html}
            </a>
            [/@ww.param]
        [/@ww.label]
    [#else]
        [@ww.label labelKey='elastic.image.configuration.configurationName' value=configuration.configurationName description=configuration.configurationDescription?html /]
    [/#if]
    [@ww.label labelKey='elastic.image.configuration.amiId' value=configuration.amiId /]

    [#if configuration.isEbsEnabled() ]
        [@ww.label labelKey='elastic.image.configuration.ebsSnapshotId' value=configuration.ebsSnapshotId /]
    [#else]
        [@ww.label labelKey='elastic.image.configuration.ebsSnapshotId' value=action.getText('elastic.image.configuration.ebsDisabled') /]
    [/#if]

    [@ww.label labelKey='elastic.instance.type' value=configuration.instanceType /]

    [#if !short]
    [@ww.label labelKey='elastic.image.configuration.availabilityZone.preferred' ]
        [@ww.param name="value"]
            [#if configuration.availabilityZone?has_content]
                ${configuration.availabilityZone}
            [#else]
                [@ww.text name='elastic.image.configuration.availabilityZone.default'/]
            [/#if]
        [/@ww.param]
    [/@ww.label]

    [@ww.label labelKey='elastic.image.configuration.numberOfActiveInstances.heading'  escape=false]
        [@ww.param name="value"]<a href="[@ww.url action='viewElasticInstancesForConfiguration' namespace='/admin/elastic/image/configuration' configurationId=configuration.id /]">${elasticUIBean.getActiveInstancesCountForConfiguration(configuration)}</a>[/@ww.param]
    [/@ww.label]
    [/#if]
[/#macro]

[#macro listElasticInstances instances]
 <table id="elastic-agents" class="aui">
            <thead><tr>
                <th>[@ww.text name='elastic.manage.table.instance.name' ][@ww.param]${req.contextPath}[/@ww.param][/@ww.text]</th>
                <th>[@ww.text name='elastic.instance.volumes' /]</th>
                <th>[@ww.text name='elastic.manage.table.configuration.name' ][@ww.param]${req.contextPath}[/@ww.param][/@ww.text]</th>
                <th>[@ww.text name='elastic.manage.table.state' /]</th>
                <th>[@ww.text name='elastic.manage.table.upTime' /]</th>
                <th>[@ww.text name='elastic.instance.price' /]</th>
                <th class="operations">[@ww.text name='elastic.manage.table.operations' /]</th>
            </tr></thead>
            <tbody>
                [#foreach instance in instances]
                    [#if instance.remoteAgent > 0]
                           [#assign agent=elasticUIBean.getAgentById(instance.remoteAgent)]
                           [#if agent?has_content]
                                [#assign hasAgents=true/]
                           [#else]
                                [#assign hasAgents=false/]
                            [/#if]
                    [#else]
                        [#assign hasAgents=false/]
                    [/#if]
                    [#if hasAgents && instance.state.name() == 'RUNNING' && instance.configuration.ebsEnabled && !instance.attachedVolumes?has_content]
                        [#assign ebsError = true /]
                    [#else]
                        [#assign ebsError = false /]
                    [/#if]
                
                
                    <tr class="elasticRow [#if hasAgents || instance.agentLoading]elasticRowBottomless[/#if] [#if ebsError]ebsError[/#if]">
                        <td>
                             <a id="view:${instance.instance.ID?html}" [#rt]
                                href="${req.contextPath}/admin/elastic/viewElasticInstance.action?instanceId=${instance.instance.ID?url}" [#t]
                                title="[@ww.text name='elastic.instance.view.title' /]">[#t]
                                 [@ww.text name='elastic.instance'/] ${instance.instance.ID?html}[#t]
                             </a>[#lt]
                        </td>
                        <td>
                             [#if instance.attachedVolumes?has_content]
                                [#list instance.attachedVolumes as item]
                                    ${item.ID}[#if item_has_next], [/#if][#t]
                                [/#list]
                            [#elseif ebsError]
                                <strong>[@ww.text name='elastic.instance.volumes.none' /]</strong>
                            [#elseif instance.configuration.ebsEnabled]
                                <em class="grey">[@ww.text name='elastic.instance.volumes.starting' /]</em>
                            [/#if]
                        </td>
                        <td>
                             <a id="view:${instance.configuration.id?html}" href="${req.contextPath}/admin/elastic/image/configuration/viewElasticImageConfiguration.action?configurationId=${instance.configuration.id?url}" title="[@ww.text name='elastic.instance.view.configuration' /]">${instance.configuration.configurationName?html}</a>
                        </td>
                        <td>
                            [#if elasticUIBean.getStateImagePath(instance.state)?has_content]
                                <img src="${req.contextPath?html}${elasticUIBean.getStateImagePath(instance.state)?html}" alt="${elasticUIBean.getStateDescription(instance.state)?html}" />
                            [/#if]
                            ${elasticUIBean.getStateDescription(instance.state)?html}
                        </td>
                        <td>
                            [#if instance.instance.launchTime?has_content]
                                <div id="${instance.instance.ID?html}upTime">
                                    ${durationUtils.getRelativeDate(instance.instance.launchTime)}
                                </div>
                                [@dj.tooltip target='${instance.instance.ID}upTime']
                                    Launch Time: ${instance.instance.launchTime?datetime}
                                [/@dj.tooltip]
                            [/#if]

                        </td>
                        [#assign spotPrice=action.getInstancePrice(instance)!"-"/]
                        <td>[#if spotPrice?string!="-"]$[/#if]${spotPrice}</td>
                        <td class="operations">
                            <a id="view:${instance.instance.ID?html}" href="${req.contextPath}/admin/elastic/viewElasticInstance.action?instanceId=${instance.instance.ID?url}" title="[@ww.text name='elastic.instance.view.title' /]">[@ww.text name='global.buttons.view' /]</a>
                            [#if instance.shutdownable]
                                   | <a id="shutdown:${instance.instance.ID?html}" href="${req.contextPath}/admin/elastic/shutdownElasticInstance.action?instanceId=${instance.instance.ID?url}&amp;returnUrl=${currentUrl}">[@ww.text name='elastic.manage.shutdown' /]</a>
                            [/#if]
                        </td>
                        </tr>
                        [#if hasAgents]
                            <tr class="elasticRowTopless [#if ebsError]ebsErrorDark[/#if]">
                               <td class="elasticAgentSubTableCell">
                                   <a href="${req.contextPath}/admin/agent/viewAgent.action?agentId=${agent.id}">${agent.name?html}</a>
                               </td>
                               <td></td>
                               <td></td>
                               <td class="agentStatus">
                                   [@agt.displayStatusCell agent=agent /]
                               </td>
                               <td></td>
                               <td>&nbsp;</td>
                               <td class="operations">
                                    [#if agent.active]
                                        [#if agent.enabled]
                                            <a id="disableQueue:${agent.id}" href="${req.contextPath}/admin/agent/disableAgent.action?agentId=${agent.id}&amp;returnUrl=/admin/elastic/manageElasticInstances.action">[@ww.text name='agent.disable' /]</a>
                                        [#else]
                                            <a id="enableQueue:${agent.id}" href="${req.contextPath}/admin/agent/enableAgent.action?agentId=${agent.id}&amp;returnUrl=/admin/elastic/manageElasticInstances.action">[@ww.text name='agent.enable' /]</a>
                                        [/#if]
                                    [/#if]
                               </td>
                            </tr>
                        [#elseif instance.agentLoading]
                            <tr class="elasticRowTopless [#if ebsError]ebsErrorDark[/#if]">
                               <td class="elasticAgentSubTableCell">
                                   Elastic Agent on ${instance.instance.ID?html}
                               </td>
                               <td></td>
                               <td></td>
                               <td>
                                   <img src="${req.contextPath}/images/jt/icn_building.gif"" alt="Pending" />
                                   Pending
                               </td>
                               <td></td>
                               <td></td>
                            </tr>
                        [/#if]
                [/#foreach]
            </tbody>
        </table>
[/#macro]


[#-- ====================================================================================== @ela.editElasticInstance --]
[#--
    Displays Elastic Image Configuration edit form
--]
[#macro editElasticInstance mode]

    [#if mode == "edit"]
        [#assign action="/admin/elastic/image/configuration/saveElasticImageConfiguration.action" /]
        [#assign cancelUri=returnUrl /]
    [#else]
        [#assign action="/admin/elastic/image/configuration/createElasticImageConfiguration.action" /]
        [#assign cancelUri="/admin/elastic/image/configuration/viewElasticImageConfigurations.action" /]
    [/#if]


    [@ww.form action="${action}"
              submitLabelKey='global.buttons.update'
              titleKey='elastic.image.configuration.${mode}.title'
              cancelUri="${cancelUri}"
              showActionErrors='false'
    ]
        [@ww.textfield name="configurationName" required="true" labelKey='elastic.image.configuration.configurationName' /]
        [@ww.textfield name="configurationDescription" labelKey='elastic.image.configuration.configurationDescription' cssClass="long-field" /]
        [#if mode == "edit"]
            [#if configuration?has_content && configuration.isShippedWithBamboo() ]
                [@ww.label labelKey='elastic.image.configuration.amiId' value=configuration.amiId  descriptionKey="elastic.image.configuration.amiId.default.description"/]
            [#else]
                [@ww.textfield name="amiId" required="true" labelKey='elastic.image.amiId' /]
            [/#if]
        [#else]
            [@ww.textfield name="amiId" required="true" labelKey='elastic.image.amiId' /]
        [/#if]

        [@ww.checkbox name='ebsEnabled' toggle='true' labelKey='elastic.image.configuration.ebsEnabled' /]
        [@ui.bambooSection dependsOn='ebsEnabled' showOn=true]
            [#if ebsCapable]
                [@ww.textfield name="ebsSnapshotId" labelKey='elastic.image.configuration.ebsSnapshotId' descriptionKey='elastic.image.configuration.ebsSnapshotId.description'/]
            [#else]
                [@ui.messageBox type="warning"]
                    [@ww.text name='elastic.image.configuration.ebsSnapshotId.warning']
                        [@ww.param]${req.contextPath}[/@ww.param]
                    [/@ww.text]
                [/@ui.messageBox]
            [/#if]
        [/@ui.bambooSection]

        [@ww.select name='instanceType' list=instanceTypes listKey='name()' listValue='name' labelKey='elastic.instance.type'/]
        [@ww.select name='availabilityZone' list=availabilityZones listKey='key' listValue='key'
            labelKey='elastic.image.configuration.availabilityZone']
                [@ww.param name="headerKey"]${defaultAvailabilityZone}[/@ww.param]
                [@ww.param name="headerValue"][@ww.text name='elastic.image.configuration.availabilityZone.default'/][/@ww.param]
        [/@ww.select]

        [#if mode == "edit"]
            [@ww.hidden name="configurationId" /]
            [@ww.hidden name="returnUrl" /]
            [@ww.hidden name="mode" value="edit" /]
        [/#if]
    [/@ww.form]
[/#macro]


[#macro displaySpotPrices confElasticCloudAction editMode]
<table id="bidTable" class="aui">
    <thead>
    <th>&nbsp;</th>
        [#list currentSpotPrices.getProducts() as product]
        <th style="text-align: center;">${product}</th>
        [/#list]
    </thead>
    <tbody>
        [#list instanceTypes as instanceType]
            [#assign atLeastOneBidGiven = false || editMode/]

            [#if !editMode]
                [#list currentSpotPrices.getProducts() as product]
                    [#if confElasticCloudAction.getBid(product, instanceType)?? && confElasticCloudAction.getBid(product, instanceType)>0]
                        [#assign atLeastOneBidGiven = true/]
                    [/#if]
                [/#list]
            [/#if]

            [#if atLeastOneBidGiven]
            <tr>
                <th> Instance type: ${instanceType}</th>
                [#list currentSpotPrices.getProducts() as product]
                    [#assign price = currentSpotPrices.getPrice(product, instanceType)!"n/a"/]

                    <td style="text-align: center;">

                        [#assign bid = confElasticCloudAction.getBid(product, instanceType)!0 /]
                        [#if bid == 0 ]
                            [#assign bid = ""/]
                        [#else]
                            [#assign bid = bid?string/]
                        [/#if]
                        
                        [#if editMode]
                            [@ww.textfield name='${getBidFieldName(product, instanceType)}' value="${bid}" labelKey="Bid $" cssClass="short-field" /]
                        [#else]
                            [#if bid?has_content]
                                <div>Bid $${bid}</div>
                            [#else]
                                <div class="subGrey">No bid</div>
                            [/#if]
                        [/#if]
                        [#if !bid?has_content]<span class="subGrey">[/#if]
                        Spot price:
                        [#if price!="n/a"]
                            $${price} <span class="subGrey">(${price.timestamp?datetime?string})</span>
                        [#else]
                            <span class="subGrey">${price}</span>
                        [/#if]
                        [#if !bid?has_content]</span>[/#if]
                    </td>
                [/#list]
            </tr>
            [/#if]
        [/#list]
    </tbody>
</table>
[/#macro]

[#function getBidFieldName product instanceType]
    [#return "fieldBid_${product}_XYZ_${instanceType}"?replace("[^-A-Za-z0-9_:.]", "_", "r")]
[/#function]