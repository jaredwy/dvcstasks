[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.ListChainResults" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.ListChainResults" --]
<html>
<head>
    <title> [@ui.header pageKey='chain.completedResults.title.long' object='${chain.name}' title=true /]</title>
    <meta name="tab" content="results"/>
</head>
<body>

[#include "/fragments/buildResults/showBuildResultsTable.ftl" /]
[@ui.header pageKey='chain.completedResults.title.long' /]
[@showBuildResultsTable
    pager=pager
    sort=false
    showAgent=false
    showOperations=true
    showArtifacts=false
    showFullBuildName=false/]

<ul>
 <li>[@ww.text name="plan.footer.colorCodes"/]</li>
 <li>[@ww.text name="plan.footer.buildCount"][@ww.param value=chain.lastBuildNumber /][/@ww.text]</li>

 [#assign buildStrategy='${chain.buildDefinition.buildStrategy.key}' /]
 [#if  buildStrategy='manualOnly' ]
    <li>[@ww.text name="plan.footer.trigger.manual"/]</li>
 [#elseif buildStrategy='schedule' || buildStrategy='daily']
     <li>[@ww.text name="plan.footer.trigger.scheduled"/]</li>
 [#else]
     <li>
         [#if chain.buildDefinition.repository??]
            [@ww.text name="plan.footer.trigger.repository.withName"]
                [@ww.param]${chain.buildDefinition.repository.name}[/@ww.param]
            [/@ww.text]
         [#else]
             [@ww.text name="plan.footer.trigger.repository.noName"/]
         [/#if]
     </li>
 [/#if]
 [#--  @TODO: RSS feed links go here but RSS for chain not yet done (?). --]
</ul>
</body>
</html>