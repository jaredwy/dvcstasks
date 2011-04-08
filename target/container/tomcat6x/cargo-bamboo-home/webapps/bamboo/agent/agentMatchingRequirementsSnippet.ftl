[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ViewAgents" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ViewAgents" --]
[#if executableAgentsMatrix?has_content]
<ul class="standard executableAgents">
    [@ww.text name='requirement.executableAgents.tooltip'/]:
   [#assign matchingAgents = executableAgentsMatrix.buildAgents /]
    [#list action.sortMatchingAgents(matchingAgents) as agent]
        [#if agent_index == 5]
            [#break]
        [/#if]
        <li><a href="[@ww.url action='viewAgent' namespace='/agent' agentId=agent.id /]">
            ${agent.name?html}</a>
        [#if !agent.active]
            <span class="subGrey">([@ww.text name='agent.status.offline' /])</span>
        [#elseif !agent.enabled]
            <span class="subGrey">([@ww.text name='agent.status.disabled' /])</span>
        [/#if]
        </li>
    [/#list]
</ul>
    [#if executableAgentsMatrix.buildAgents.size() > 5]
    <div class='moreExecutableAgents'>
        <a href="${req.contextPath}/agent/viewAgents.action?planKey=${planKey}&amp;returnUrl=/browse/${planKey}/config">More...</a>
    </div>
    [/#if]
[/#if]