[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildNotification" --]
[#import "/lib/build.ftl" as bd]

[#import "editBuildConfigurationCommon.ftl" as ebcc/]
[@ebcc.editConfigurationPage plan=plan selectedTab='notifications']
        [@ww.form action='configureBuildNotification'
              namespace='/build/admin/edit'
              showActionErrors='false'
              titleKey='notification.title'
              id='notification' ]
            [@ww.hidden name='buildKey' value=plan.key /]
            [@bd.notificationWarnings /]
            [@bd.existingNotificationsTable
            editUrl='${req.contextPath}/build/admin/edit/editBuildNotification.action?buildKey=${plan.key}'
            deleteUrl='${req.contextPath}/build/admin/edit/deleteBuildNotification.action?buildKey=${plan.key}'
                /]
            [@bd.configureBuildNotificationsForm /]
        [/@ww.form]
[/@ebcc.editConfigurationPage]