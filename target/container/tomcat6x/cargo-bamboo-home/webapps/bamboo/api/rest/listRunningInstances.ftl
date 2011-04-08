[#-- @ftlvariable name="action" type="com.atlassian.bamboo.rest.ListRunningInstances" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.rest.ListRunningInstances" --]
<response>
[#if runningElasticInstances?exists]
[#list runningElasticInstances as agent]
    [#if agent.instance??]
    <instance>
        <id>${agent.instance.ID?xml}</id>
        <state>${agent.state?xml}</state>
        <uptime>${durationUtils.getEllapsedTime(agent.instance.launchTime)}</uptime>
        <hostname>${agent.instance.dnsName!?xml}</hostname>
        <elasticImageConfiguration>${agent.configuration.configurationName?xml}</elasticImageConfiguration>
        <attachedEbsVolumes>[#if agent.attachedVolumes?has_content]
                [#list agent.attachedVolumes as volume]
                <ebsVolumeId>${volume.ID?xml}</ebsVolumeId>
                [/#list]
            [/#if]</attachedEbsVolumes>
        <bambooAgentId>[#if agent.remoteAgent > 0]${agent.remoteAgent?xml}[/#if]</bambooAgentId>
    </instance>
    [/#if]
[/#list]
[/#if]
</response>
