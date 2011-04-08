[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.admin.ConfigureChainNotification" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.admin.ConfigureChainNotification" --]
[#import "/lib/build.ftl" as bd]
[#import "editChainConfigurationCommon.ftl" as eccc/]

[@eccc.editChainConfigurationPage plan=plan selectedTab='notifications']
        [@ww.form action='configureChainNotification'
                  namespace='/chain/admin/config'
                  showActionErrors='false'
                  titleKey='notification.title'
                  id='notification' ]
            [@ww.hidden name='buildKey' value=chain.key /]
            [@bd.notificationWarnings /]
            [@bd.existingNotificationsTable
               editUrl='${req.contextPath}/chain/admin/config/editChainNotification.action?buildKey=${buildKey}'
               deleteUrl='${req.contextPath}/chain/admin/config/deleteChainNotification.action?buildKey=${buildKey}'
                    /]
            [@bd.configureBuildNotificationsForm groupEvents=true/]
        [/@ww.form]
[/@eccc.editChainConfigurationPage]

