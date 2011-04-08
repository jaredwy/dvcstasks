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
    [@menu.displayTabbedContent selectedTab='recent' location="agent.subMenu"]
        [@ui.header pageKey='agent.recent' /]
        [@menu.displayExternalOperations]
            <li>
                [@ui.standardMenu triggerText="Showing ${filterController.agentFilterName}"  id="filterMenuParent"]
                    [#list filterController.filterMap.keySet() as key]
                        [@ww.url id="filterUrl" action="setResultsFilter" namespace="/agent" returnUrl=currentUrl]
                            [@ww.param name="filterController.agentFilterKey"]${key}[/@ww.param]
                        [/@ww.url]

                        [@ui.displayLink id="filter:${key}" title=filterController.filterMap[key] href=filterUrl inList=true /]
                    [/#list]
                [/@ui.standardMenu]
            </li>
        [/@menu.displayExternalOperations]
        [@ui.bambooPanel]
             [@ww.action name="viewBuildResultsTable" namespace="/build" executeResult="true"][/@ww.action]
        [/@ui.bambooPanel]
    [/@menu.displayTabbedContent]
</div>
</body>
</html>