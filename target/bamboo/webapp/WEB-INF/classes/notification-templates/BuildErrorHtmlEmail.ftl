[#include "notificationCommonsHtml.ftl"]
<div>
[@commonStyle /]
[@fontHtml]

<table align="center" border="0" cellpadding="5" cellspacing="0" width="98%">
<tr>
	<td style="vertical-align:top">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:#ffe6e7;border-top:1px solid #eec0c0;border-bottom:1px solid #eec0c0;color:#d62829;">
        <tr>
        <td width="20" style="vertical-align:top;padding:5px 0 5px 10px">
            <img src="${baseUrl}/images/delete.gif" width="18" height="18">
        </td>
        <td width="100%" style="font-family: Arial, sans-serif; font-size: 13px; color:#d62829;padding:5px 10px">
            <span style="font-family: Arial, sans-serif; font-size: 15px;">Error detected for </span>
            <a href="${baseUrl}/browse/${error.buildKey}/" style="font-family: Arial, sans-serif; font-size: 15px; font-weight:bold; color:#d62829">${error.buildName}</a>
            [#if error.buildNumber?has_content && error.buildExists]
               &gt; <a href="${baseUrl}/browse/${error.buildResultKey}/" style="font-family: Arial, sans-serif; font-size: 15px; font-weight:bold; color:#d62829">${error.buildResultKey}</a>
            [/#if]
            <span style="font-family: Arial, sans-serif; font-size: 13px;">
              [#if error.context?has_content]
                  <br/>${error.context}
              [/#if]
            </span>
         </td>
        </tr>
        </table>
        <br>

        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:#ecf1f7;border-top:1px solid #bbd0e5;border-bottom:1px solid #bbd0e5;color:#036;">
            <tr>
                <td width="100%" style="font-family: Arial, sans-serif;text-align:left;font-size:16px;font-weight:bold;color:#036;padding:5px 10px">
                    <a href="${baseUrl}/browse/${error.buildKey}#buildPlanSummaryErrorLog" style="text-decoration: none; font-family: Arial, sans-serif;text-align:left;font-size:16px;font-weight:bold;color:#036" >Error Details</a>
                </td>
            </tr>
        </table>
        <br>
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr><td>
            <span style="font-family: Arial, sans-serif; font-size: 13px; color:#000">
                [#if error.throwableDetails?has_content]
                   [#if error.throwableDetails.name?has_content]
                        <strong>${error.throwableDetails.name?html}[#if error.throwableDetails.message?has_content]:[/#if]</strong>
                   [/#if]
                   [#if error.throwableDetails.message?has_content]
                        <br/>${error.throwableDetails.message?html}
                   [/#if]
                   <br/><br/>
               [/#if]

                [#if error.numberOfOccurrences == 1]
                    Occurred: ${error.lastOccurred?datetime}
                [#else]
                    Occurrences: ${error.numberOfOccurrences}
                    <br>First Occurred: ${error.firstOccurred?datetime}
                    <br>Last Occurred: ${error.lastOccurred?datetime}
                [/#if]
                [#if error.agentIds?has_content]
                    <br>Agent[#if error.agents.size() != 1]s[/#if]: [#lt]
                    [#list error.agents as agent]
                        <a href="${baseUrl}/agent/viewAgent.action?agentId=${agent.id}">${agent.name?html}</a>[#t]
                        [#if agent_has_next]
                            ,[#lt]
                        [/#if]
                    [/#list]
                [/#if]
            </span>
            </td>
            </tr>
        </table>
        <br>

        [#if error.throwableDetails?has_content && error.throwableDetails.stackTrace?has_content]
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:#f2f2f2;border-top:1px solid #d9d9d9;border-bottom:1px solid #d9d9d9;color:#000;margin-top:5px;padding:10px">
           <tr>
            <td width="100%" style="font-family:'Courier New', Courier, monospace; font-size: 12px; color:#000;vertical-align:top">
            <pre style="font-family:'Courier New', Courier, monospace; font-size: 12px; color:#000;vertical-align:top">${error.throwableDetails.stackTrace?html}</pre>
            </td>
            </tr>
        </table>
        <br />
        [/#if]

        [@showEmailFooter baseUrl /]
    </td>
    <td width="150" style="vertical-align:top">
        [@showActions]
            [#if error.buildNumber?has_content && error.buildExists]
                [@addAction name="View Build Online" url="${baseUrl}/browse/${error.buildResultKey}/" /]
            [/#if]
            [#assign buildSummaryUrl= baseUrl + '/browse/' + error.buildKey + '#buildPlanSummaryErrorLog' /]
            [@addAction name="View Error Online" url="${buildSummaryUrl}" /]
            [@addAction name="Clear Error From Log" url="${baseUrl}/admin/removeErrorFromLog.action?buildKey=${error.buildKey}&error=${error.errorNumber}&returnUrl=${buildSummaryUrl?url}" /]
            [@addAction name="View Plan Summary" url="${baseUrl}/browse/${error.buildKey}" /]
        [/@showActions]
    </td>
<tr>
</table>
[/@fontHtml]
</div>
