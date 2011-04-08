[#include "notificationCommonsHtml.ftl" ]
<div>
<style type="text/css">
[#--NB: These css styles will not actually be picked up by some email clients do don't put anything vital to presentation in here. --]    
td a, td a:link, td a:visited, td a:hover, td a:active {background:transparent;font-family: Arial, sans-serif;text-decoration:underline;}
td a:link {color:#369;}
td a:visited {color:#444;}
td a:hover, td a:active {color:#036;}
td a:hover {text-decoration:none;}
</style>
<font size="2" color="black" face="Arial, Helvetica, sans-serif" style="font-family: Arial, sans-serif;font-size: 13px;color:#000">
<table align="center" border="0" cellpadding="5" cellspacing="0" width="98%">
<tr>
	<td style="vertical-align:top">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:#f2f2f2;border-top:1px solid #d9d9d9;border-bottom:1px solid #d9d9d9;color:#000;">
            <tr>
                <td width="100%" style="font-family: Arial, sans-serif; font-size: 14px; color:#000;padding:5px 10px">
                    <a href="${baseUrl}/browse/${buildSummary.buildResultKey}/" style="font-family: Arial, sans-serif; font-size: 15px; font-weight:bold; color:#000">${buildSummary.buildResultKey}</a>
                    <span style="font-family: Arial, sans-serif; font-size: 14px; color:#000">
                    commented by
                    [#if addedComment.user?has_content]
                    [@ui.displayUserFullName user=addedComment.user /]
                    [#elseif addedComment.userName?has_content]
                    ${addedComment.userName?html}
                    [#else]
                    Anonymous User
                    [/#if]
                    </span>
                </td>
            </tr>
        </table>
        <br>
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:#ecf1f7;border-top:1px solid #bbd0e5;border-bottom:1px solid #bbd0e5;color:#036;">
            <tr>
                <td width="100%" style="font-family: Arial, sans-serif;text-align:left;font-size:16px;font-weight:bold;color:#036;padding:5px 10px">
                    <a href="${baseUrl}/browse/${buildSummary.buildResultKey}" style="text-decoration: none; font-family: Arial, sans-serif;text-align:left;font-size:16px;font-weight:bold;color:#036" >Comments</a>
                </td>
            </tr>
        </table>
        <br>
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
            [#list comments as comment]
            <tr [#if comment.id == addedComment.id]style="background-color:#ffffd1"[/#if]>
                <td width="20" style="vertical-align:top;padding:10px 0 10px 10px">
                    <img src="${baseUrl}/images/icons/businessman.gif" width="15" height="15">
                </td>
                <td width="100%" style="font-family: Arial, sans-serif; font-size: 13px; color:#000;vertical-align:top;padding:10px">
                    [#if comment.user?has_content]
                     <a href="${baseUrl}/browse/user/${comment.user.name}" style="font-family: Arial, sans-serif; font-size: 13px; font-weight:bold; color:#000">[@ui.displayUserFullName user=comment.user/]</a>
                    [#elseif comment.userName?has_content]
                     <span style="font-family: Arial, sans-serif; font-size: 13px; font-weight:bold; color:#000">
                         ${comment.userName?html}
                     </span>
                    [#else]
                    <span style="font-family: Arial, sans-serif; font-size: 13px; font-weight:bold; color:#000">
                         Anonymous User
                     </span>
                    [/#if]
                    <span style="font-family: Arial, sans-serif; font-size: 13px;color:#999">(${comment.lastModificationDate?datetime})</span>
                    <br>
                    ${jiraIssueUtils.getRenderedString(htmlUtils.getTextAsHtml(comment.content), buildSummary.buildKey, buildSummary.buildNumber)}
                </td>
            </tr>
            [/#list]
        </table>
        <br>

        [@showEmailFooter baseUrl/]

    </td>
    <td width="150" style="vertical-align:top">
        <table width="150" border="0" cellpadding="0" cellspacing="0" style="background-color:#ecf1f7;border-top:1px solid #bbd0e5;border-bottom:1px solid #bbd0e5;color:#036;">
            <tr>
                <td style="font-family: Arial, sans-serif;text-align:left;font-size:16px;font-weight:bold;color:#036;vertical-align:top;padding:5px 10px">
                    Actions
                </td>
            </tr>
        </table>
        <table width="150" border="0" cellpadding="0" cellspacing="0" style="background-color:#f5f9fc;border-bottom:1px solid #bbd0e5;">
            <tr>
                <td style="font-family: Ariel, sans-serif; font-size: 13px; color:#036;vertical-align:top;padding:5px 10px;line-height:1.7">
                    <a href="${baseUrl}/browse/${buildSummary.buildResultKey}/" style="font-family: Arial, sans-serif; font-size: 13px; color:#036">View Online</a>
                    <br>
                    <a href="${baseUrl}/browse/${buildSummary.buildResultKey}?commentMode=true" style="font-family: Arial, sans-serif; font-size: 13px; color:#036">Add Comment</a>
                    <br>
                </td>
            </tr>
        </table>
    </td>
<tr>
</table>
</font>
</div>