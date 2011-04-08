[#include "notificationCommonsHtml.ftl"]
<div>
    [@commonStyle /]
    [@fontHtml]
    
    <table align="center" border="0" cellpadding="5" cellspacing="0" width="98%">
        <tr>
            <td style="vertical-align:top">

                [@notificationTitleGrey]
                    <a href="${baseUrl}/browse/${buildKey}/log" style="font-family: Arial, sans-serif; font-size: 15px; font-weight:bold; color:#000">${buildKey}-${buildNumber}</a>
                    <span style="font-family: Arial, sans-serif; font-size: 14px;"> may have hung.</span>
                    [@ui.displayBuildHungDurationInfoHtml currentlyBuilding.buildTime, currentlyBuilding.averageDuration, currentlyBuilding.buildHangDetails /]
                    [#if buildAgent?has_content]<br/>Running on agent <strong>${buildAgent.name?html}</strong>[/#if]
                [/@notificationTitleGrey]

                [@showCommitsNoBuildResult commit baseUrl buildKey /]

                [@showLogs lastLogs baseUrl buildKey /]

                [@showEmailFooter baseUrl /]
            </td>

            <td width="150" style="vertical-align:top">
                [@showActions]
                    [@addAction name="View Online" url="${baseUrl}/browse/${buildKey}/log" /]
                    [@addAction name="Stop Build"  url="${baseUrl}/build/admin/stopPlan.action?planKey=${buildKey}" /]
                [/@showActions]
            </td>

        <tr>
    </table>
    [/@fontHtml]
</div>