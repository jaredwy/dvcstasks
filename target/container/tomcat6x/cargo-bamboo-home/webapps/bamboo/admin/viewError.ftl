[#-- @ftlvariable name="action" type="com.atlassian.bamboo.logger.ViewBuildError" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.logger.ViewBuildError" --]
<html>
<head>
    <title>Bamboo Error Viewer</title>
    <meta name="decorator" content="helppage">
</head>

<body>
<h1>System Error Details</h1>

[#if errorDetails??]
<div id="applicationError">
    <em>
       [#if errorDetails.buildSpecific]
           [#assign buildUrl = "/browse/" + errorDetails.buildKey /]
            [#if errorDetails.buildNumber??]
                [#assign buildUrl = buildUrl + "-" + errorDetails.buildNumber /]
            [/#if]
            <a href='[@ww.url value=buildUrl /]' >Build ${errorDetails.buildName} [#if errorDetails.buildNumber?exists ] ${errorDetails.buildNumber}[/#if]</a>
        [#elseif errorDetails.elastic]
            Elastic Bamboo Error
        [#else]
            General Error
        [/#if]
    :</em> ${errorDetails.context} <br />
    [#if errorDetails.throwableDetails??]
    <div class="grey">(${errorDetails.throwableDetails.name} : ${errorDetails.throwableDetails.message?if_exists})</div>
    [#if errorDetails.numberOfOccurrences == 1]
        <br>Occurred: ${errorDetails.lastOccurred?datetime}
    [#else]
        <br>Occurrences: ${errorDetails.numberOfOccurrences}
        <br>First Occurred: ${errorDetails.firstOccurred?datetime}
        <br>Last Occurred: ${errorDetails.lastOccurred?datetime}
    [/#if]
    [#if errorDetails.agentIds?has_content]
        <br>Agent[#if errorDetails.agentIdentifiers.size() != 1]s[/#if]: [#lt]
        [#list errorDetails.agentIdentifiers as agent]
            [#if agent.name?has_content]
                <a href="[@ww.url action='viewAgent' namespace='/agent' agentId=agent.id /]">${agent.name?html}</a>[#t]
            [#else]
                (${agent.id})
            [/#if]                
            [#if agent_has_next]
                ,[#lt]
            [/#if]
        [/#list]
    [/#if]
    [#if errorDetails.elastic]
        [#if errorDetails.instanceIds?has_content]
            <br>Elastic Instance[#if errorDetails.instanceIds.size() != 1]s[/#if]: [#lt]
            [#list errorDetails.instanceIds as instanceId]
                ${instanceId?html}[#t]
                [#if instanceId_has_next]
                    ,[#lt]
                [/#if]
            [/#list]
        [/#if]
    [/#if]
    <hr>

    <pre class="code">${errorDetails.throwableDetails.stackTrace}</pre>

    <hr>

    <a href="javascript:window.close();">Close This Window</a> |
    
    [#if fn.hasAdminPermission() ]
    <img src="${req.contextPath}/images/delete.gif" border="0" alt="Remove error from the list" width="16"
         height="16" align="absmiddle">
    <a href="${req.contextPath}/admin/removeErrorFromLog.action?buildKey=${errorDetails.buildKey}&error=${errorDetails.errorNumber}"
       onClick='removeError("${errorDetails.errorNumber}"); return false;'>
        Clear error from log</a> |
    [/#if]

    <img src="${req.contextPath}/images/contract.gif" border="0" alt="Report bug" width="16" height="16"
         align="absmiddle">
    <a target="_blank" href="http://support.atlassian.com">Report Bug</a>.

    [/#if]
</div>
[/#if]
</body>
</html>