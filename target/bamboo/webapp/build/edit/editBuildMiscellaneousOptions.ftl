[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildMiscellaneousOptions" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildMiscellaneousOptions" --]
[#import "/lib/build.ftl" as bd]

[#import "editBuildConfigurationCommon.ftl" as ebcc/]
[@ebcc.editConfigurationPage plan=plan  selectedTab='miscellaneous']
        [@ww.form titleKey='miscellaneous.title' action='updateMiscellaneous' namespace='/build/admin/edit'
                cancelUri='/build/buildConfiguration.action?buildKey=${plan.key}'
                submitLabelKey='global.buttons.update']

            [@ww.hidden name='buildKey' value=plan.key /]

            [#assign pluginsPage = miscellaneousBuildConfigurationEditHtml/]
            [#if pluginsPage?has_content]
                ${pluginsPage}
            [#else]
                [@ui.displayText key='miscellaneous.noContent'/]
            [/#if]
        [/@ww.form]
[/@ebcc.editConfigurationPage]