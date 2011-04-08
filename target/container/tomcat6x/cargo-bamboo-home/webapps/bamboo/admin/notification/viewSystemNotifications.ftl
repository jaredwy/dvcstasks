[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.notification.ConfigureSystemNotifications" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.notification.ConfigureSystemNotifications" --]

[#import "/lib/build.ftl" as bd]

<html>
<head>
    <title>[@ww.text name="system.notifications"/]</title>
</head>
<body>
<h1>[@ww.text name="system.notifications"/]</h1>
<p>[@ww.text name="system.notifications.description"/]</p>
[@ui.bambooSection]
      [#if notificationErrorMessageKey?has_content]
            [@cp.displayNotificationWarnings messageKey=notificationErrorMessageKey addServerKey=notificationAddServerKey cssClass='warning' allowInlineEdit=true/]
      [/#if]
[/@ui.bambooSection]
[#if systemNotificationRules?has_content]
    [@bd.displayNotificationRulesTable
        notificationRules=systemNotificationRules
        showColumnSpecificHeading=false
        editUrl='${req.contextPath}/admin/editSystemNotification.action?'
        deleteUrl='${req.contextPath}/admin/removeSystemNotification.action?'
        /]
[#else]
    <div>[@ww.text name="system.notifications.none"/]</div>
[/#if]

[@ww.form action='addSystemNotification'
          namespace='/admin'
          showActionErrors='false'
          id='systemNotificationForm']
    [@bd.configureSystemNotificationsForm  /]
[/@ww.form]
</body>
</html>
