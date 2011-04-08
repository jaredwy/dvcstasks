[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildNotification" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildNotification" --]
[#import "/lib/build.ftl" as bd]

[#if mode?has_content && mode='planCreate']
    <title>6. Notifications</title>
    [#assign updateUrl='/build/admin/create/updateBuildNotification.action?notificationId=${notificationId}' /]
    [#assign cancelUrl='/build/admin/create/defaultBuildNotification.action' /]
    [#assign myMode='planCreate' /]
[#else]
    <title>Configure Notifications</title>
    [#assign updateUrl='/build/admin/edit/updateBuildNotification.action?buildKey=${plan.key}&notificationId=${notificationId}' /]
    [#assign cancelUrl='/build/admin/edit/editBuildNotification.action?buildKey=${plan.key}' /]
    [#assign myMode='planConfigure' /]
[/#if]

[#if edit?has_content && edit=="true"]
    [#assign titleKey="notification.edit.title" /]
[#else]
    [#assign titleKey="notification.add.title" /]
[/#if]

[@ww.form action=updateUrl
          cancelUri=cancelUrl
          submitLabelKey='global.buttons.update'
          id='notificationsForm'
          titleKey='notification.title'
          showActionErrors='false'
]
    [@bd.notificationWarnings /]
    [@bd.existingNotificationsTable /]
    [@bd.configureBuildNotificationsForm showFormButtons=false/]
[/@ww.form]