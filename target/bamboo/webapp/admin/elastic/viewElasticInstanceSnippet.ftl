[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ViewElasticInstanceAction" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ViewElasticInstanceAction" --]


[#import "/admin/elastic/commonElasticFunctions.ftl" as ela]

[@ui.bambooPanel titleKey='elastic.instance.details' descriptionKey='elastic.instance.details.description']

    [@ww.label labelKey='elastic.instance.agent.status' escape=false]
        [@ww.param name="value"]
            <img src="${req.contextPath?html}${action.getStateImagePath()?html}" alt="${action.getStateDescription()?html}" />
            ${action.getStateDescription()?html}
        [/@ww.param]
    [/@ww.label]

    [#if instance.dnsName??]
        [#assign elasticDnsDescription]
            [@ui.commaList list=action.getIpAddress(instance.dnsName) /]
        [/#assign]
        [@ww.label labelKey='elastic.instance.dns' escape=false value=instance.dnsName description="${action.getText('elastic.instance.ip')}: ${elasticDnsDescription}" /]
    [/#if]

    [#if instance.launchTime??]
        [@ww.label labelKey='elastic.instance.agent.start' value="${instance.launchTime?datetime?string.short} (${durationUtils.getRelativeDate(instance.launchTime.time)} ${action.getText('global.dateFormat.ago')})" /]
    [/#if]

    [#if buildAgent?? && agentDefinition??]
        [@ww.url id='agentUrl' namespace='/admin/agent' action='viewAgent' agentId=agentDefinition.id /]
        [@ww.label labelKey='elastic.instance.agent' showDescription=true escape=false]
            [@ww.param name="value"]
                <a href="${agentUrl}">${buildAgent.name?html}</a> (${buildAgent.agentStatus.label})
            [/@ww.param]
        [/@ww.label]
    [#elseif agent.agentLoading]
        [@ww.label labelKey='elastic.instance.agent' escape=false]
            [@ww.param name="value"]
                 <img src="${req.contextPath}/images/jt/icn_building.gif"" alt="Pending" />
                 Pending
            [/@ww.param]
        [/@ww.label]
    [/#if]


	[#assign availabilityZoneText]
		${instance.availabilityZone!}
		[#if image?has_content && !image.availabilityZone?has_content]
			[@ww.text name='elastic.image.configuration.availabilityZone.default.suffix'/]
		[/#if]
	[/#assign]

    [@ww.label labelKey='elastic.image.configuration.availabilityZone.current' value='${availabilityZoneText}' /]

    [@ui.displayText]

    [#if agent.attachedVolumes?has_content]
        <table id="attachedVolumes" class="aui">
            <thead>
                <tr>
                    <th>
                        [@ww.text name='elastic.instance.volumes' /]
                    </th>
                </tr>
            </thead>
            <tbody>
            [#list agent.attachedVolumes as volume]
                <tr>
                    <td>
                        ${volume.ID}
                    </td>
                </tr>
            [/#list]
            </tbody>
        </table>
    [/#if]

    [/@ui.displayText]


    [@ui.bambooSection titleKey='elastic.configuration']
        [@ela.elasticImageConfigurationViewProperties configuration=image displayConfigurationUrl=true short=true /]
    [/@ui.bambooSection]

    [#if action.allowShutdown()]
        [@ui.displayFooter]
            [@ww.url id="returnUrl" action='viewElasticInstance' namespace='/admin/elastic' instanceId=instanceId /]
            [@ww.url id="shutdownInstanceUrl" action='shutdownElasticInstance' namespace='/admin/elastic'
                instanceId=instanceId returnUrl=returnUrl /]
            <a href="${shutdownInstanceUrl}">[@ww.text name='elastic.manage.shutdown' /]</a>
        [/@ui.displayFooter]
    [/#if]
[/@ui.bambooPanel]

[@ui.clear /]

[#if instance.dnsName??]
[#if action.checkIfPkFileExists()]
    [#assign pkFileExists=1 /]
    [@ww.url id='pkFileUrl' namespace='/admin/elastic' action='getPkFile' /]
    [#assign downloadSite='<a href="${pkFileUrl}">here</a>' /]
    [#assign pkFile='<a href="${pkFileUrl}">${pkFileLocation}</a>' /]
[#else]
    [#assign pkFileExists=0 /]
    [#assign downloadSite='' /]
    [#assign pkFile='elasticbamboo.pk' /]
[/#if]

[@ui.bambooPanel cssClass='hideHeadingSection' ]
[@ui.bambooSection titleKey='elastic.instance.ssh']
        [@ww.text name='elastic.instance.ssh.description']
            [@ww.param value=pkFileExists /]
            [@ww.param]${downloadSite}[/@ww.param]
            [@ww.param]${pkFile}[/@ww.param]
            [@ww.param]${instance.dnsName?html}[/@ww.param]
            [@ww.param]<a href="http://confluence.atlassian.com/x/yhO-Cg">online documentation</a>[/@ww.param]
        [/@ww.text]
[/@ui.bambooSection]
[@ui.bambooSection titleKey='elastic.instance.logs']
        [@ww.text name='elastic.instance.logs.description']
            [@ww.param]${pkFile}[/@ww.param]
            [@ww.param]${instance.dnsName?html}[/@ww.param]
        [/@ww.text]
[/@ui.bambooSection]
[@ui.bambooSection titleKey='elastic.instance.amazon.console']
    [@ww.text name='elastic.instance.amazon.console.description' ]
        [@ww.param]${instanceId}[/@ww.param]
    [/@ww.text]
    <iframe id="amazonLogs" src="https://console.aws.amazon.com/ec2/_consoleOutputDecoded.jsp?action.InstanceId=${instanceId}">
    </iframe>
[/@ui.bambooSection]
[/@ui.bambooPanel]
[/#if]

