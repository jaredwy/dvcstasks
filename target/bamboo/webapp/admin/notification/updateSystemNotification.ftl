[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.notification.ConfigureSystemNotifications" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.notification.ConfigureSystemNotifications" --]

[#import "/lib/build.ftl" as bd]

<title>[@ww.text name="system.notifications"/]</title>
[#assign updateUrl='/admin/updateSystemNotification.action?notificationId=${notificationId}' /]
[#assign cancelUrl='/admin/viewSystemNotifications.action' /]
[#assign titleKey="notification.edit.title" /]

<h1>[@ww.text name="system.notifications.edit"/]</h1>
[@ui.clear/]
[@ww.form action=updateUrl
          cancelUri=cancelUrl
          submitLabelKey='global.buttons.update'
          id='updateSystemNotificationForm'
          titleKey='notification.title'
          showActionErrors='false'

]
    [@ui.bambooSection]
           [#if notificationErrorMessageKey?has_content]
               [@cp.displayNotificationWarnings messageKey=notificationErrorMessageKey addServerKey=notificationAddServerKey cssClass='warning' allowInlineEdit=true/]
           [/#if]
    [/@ui.bambooSection]
    [#if systemNotificationRules?has_content]
        [@bd.displayNotificationRulesTable
            notificationRules=systemNotificationRules
            showColumnSpecificHeading=true
         /]
    [#else]
        <div>[@ww.text name="system.notifications.none"/]</div>
    [/#if]
    [@ui.clear/]
    [@bd.configureSystemNotificationsForm edit=true showFormButtons=false/]
[/@ww.form]
</body>
