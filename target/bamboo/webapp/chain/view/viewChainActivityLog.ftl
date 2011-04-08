[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.ViewActivityLog" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.ViewActivityLog" --]

[#import "/lib/chains.ftl" as cn]

<html>
<head>
    [@ui.header object=plan.name page="Logs" title=true/]
     <meta name="tab" content="config"/>
</head>

<body>
    [@ww.url id='backToChainConfigurationUrl' value='/chain/viewChainConfiguration.action' planKey=buildKey returnUrl=currentUrl /]
    [@cp.displayLinkButton buttonId='backToPlanConfiguration' buttonKey='chain.logs.back.to.configuration' buttonUrl=backToChainConfigurationUrl /]

    [@ui.header pageKey='chain.logs.title'/]

    [#--Plan Level Logs--]
    [@dj.reloadPortlet id='activityLogWidget' url='${req.contextPath}/ajax/viewActivityLogSnippet.action?buildKey=${plan.key}&linesToDisplay=${linesToDisplay}' reloadEvery=secondsToRefresh loadScripts=false]
        [@ww.action name="viewActivityLogSnippet" namespace="/ajax" executeResult="true"]
        [/@ww.action]
    [/@dj.reloadPortlet]

    [@cn.logMenu action="${req.contextPath}/chain/viewChainActivityLog.action" plan=plan  planType="Plan" linesToDisplay=linesToDisplay secondsToRefresh=secondsToRefresh]
        <input name="planKey" value="${plan.key}" type="hidden">
    [/@cn.logMenu]
</body>
</html>
