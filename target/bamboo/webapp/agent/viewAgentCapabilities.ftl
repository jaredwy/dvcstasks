[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ViewAgent" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ViewAgent" --]
[#import "/lib/menus.ftl" as menu/]
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
    [@ww.url value='/agent/viewAgents.action' id='agentsListUrl' /]
</head>

<body>
<div id="agent-content">
    [@agt.header /]

    [@agt.agentDetails headerKey='agent.details' agentId=agent.id showOptions="short" /]

    [@menu.displayTabbedContent selectedTab='capabilities' location="agent.subMenu"]
        [@ui.header pageKey='agent.capability.title' /]
        [@ui.bambooPanel]
            [@agt.displayCapabilities capabilitySetDecorator=combinedCapabilitySetDecorator showEdit=false showDelete=false /]
        [/@ui.bambooPanel]
    [/@menu.displayTabbedContent]
</div>
</body>
</html>