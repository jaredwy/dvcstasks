[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ViewAgents" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ViewAgents" --]
[#if executableAgentsMatrix?has_content]
<ul class="executableAgents">
    [@ww.text name='requirement.executableImages.tooltip'/]:
    [#list executableAgentsMatrix.imageMatches as image]
        <li>
            [#if fn.hasGlobalAdminPermission()]<a href="[@ww.url action='viewElasticImageConfiguration' namespace='/admin/elastic/image/configuration' configurationId='${image.id}' /]">[/#if]
            ${image.amiId?html} (${image.configurationName?html})
            [#if fn.hasGlobalAdminPermission()]</a>[/#if]
        </li>
    [/#list]
</ul>
[/#if]