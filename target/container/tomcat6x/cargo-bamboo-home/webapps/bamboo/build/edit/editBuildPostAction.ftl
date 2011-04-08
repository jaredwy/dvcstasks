[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildPostAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildPostAction" --]

[#import "/lib/build.ftl" as bd]

[#import "editBuildConfigurationCommon.ftl" as ebcc/]
[@ebcc.editConfigurationPage plan=plan  selectedTab='postActions']
        [@ww.form action="updateBuildPostAction" namespace='/build/admin/edit' descriptionKey='build.build.post'
                  cancelUri='/build/buildConfiguration.action?buildKey=${plan.key}'
                  submitLabelKey='global.buttons.update'
                titleKey='build.post.action.title'
        ]
            [@ww.hidden name="buildKey" /]

            [@bd.configurePostAction /]
            [#if buildCompleteActionsPluginHtmlList?has_content]
                [#list buildCompleteActionsPluginHtmlList as pluginHtml]
                    ${pluginHtml}
                [/#list]
            [#else]
                [@ww.text name='build.post.action.empty' /]
            [/#if]
        [/@ww.form]
[/@ebcc.editConfigurationPage]