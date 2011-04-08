[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildMiscellaneousOptions" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildMiscellaneousOptions" --]
[#import "editChainConfigurationCommon.ftl" as eccc/]

[@eccc.editChainConfigurationPage plan=plan  selectedTab='miscellaneous' ]
        [@ww.form titleKey='miscellaneous.title' action='updateChainMiscellaneous' namespace='/chain/admin/config'
                  cancelUri='/browse/${plan.key}/config'
                  submitLabelKey='global.buttons.update']

            [@ww.hidden name='buildKey' value=plan.key /]

            [#assign pluginsPage = miscellaneousBuildConfigurationEditHtml /]
            [#if pluginsPage?has_content]
                ${pluginsPage}
            [#else]
                [@ui.displayText key='miscellaneous.noContent'/]
            [/#if]
        [/@ww.form]
[/@eccc.editChainConfigurationPage]