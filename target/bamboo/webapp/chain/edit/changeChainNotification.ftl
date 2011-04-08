[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.admin.ConfigureChainNotification" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.admin.ConfigureChainNotification" --]
[#import "/lib/build.ftl" as bd]

    <title>Configure Notifications</title>
    [#assign updateUrl='/chain/admin/config/updateChainNotification.action?buildKey=${buildKey}&notificationId=${notificationId}' /]
    [#assign cancelUrl='/chain/admin/config/defaultChainNotification.action?buildKey=${buildKey}' /]


    [#assign titleKey="notification.edit.title" /]

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
