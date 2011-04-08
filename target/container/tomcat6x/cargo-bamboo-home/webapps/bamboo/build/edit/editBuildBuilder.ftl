[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildBuilder" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildBuilder" --]

[#import "/lib/build.ftl" as bd]

[#import "editBuildConfigurationCommon.ftl" as ebcc/]
[@ebcc.editConfigurationPage plan=plan  selectedTab='builder']
        [@ww.form action="updateBuildBuilder" namespace="/build/admin/edit" titleKey='builder.title.long'
            cancelUri='/build/buildConfiguration.action?buildKey=${plan.key}'
            submitLabelKey='global.buttons.update']

            [@ww.hidden name="buildKey" /]

            [#include "/build/common/configureBuilder.ftl"]

            [#list preBuildQueuedActionPluginHtmlList as pluginHtml]
                ${pluginHtml}
            [/#list]

            [#list preBuildActionPluginHtmlList as pluginHtml]
                ${pluginHtml}
            [/#list]

            [#list buildProcessorPluginHtmlList as pluginHtml]
                ${pluginHtml}
            [/#list]
        [/@ww.form]
        [@ww.form action="convertBuilderToTask.action" namespace="/build/admin/edit" submitLabelKey='Convert Build To Task']
            [@ww.hidden name="buildKey" /]
        [/@ww.form]
[/@ebcc.editConfigurationPage]