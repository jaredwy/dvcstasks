[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildRepository" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildRepository" --]

[#import "/lib/build.ftl" as bd]

[#import "editBuildConfigurationCommon.ftl" as ebcc/]
[@ebcc.editConfigurationPage plan=plan  selectedTab='repository']
        [@ww.form titleKey='repository.title' action="updateBuildRepository" namespace="/build/admin/edit"
            method="post" enctype="multipart/form-data"
            cancelUri='/build/buildConfiguration.action?buildKey=${plan.key}'
            submitLabelKey='global.buttons.update']
        [@ww.hidden name="buildKey" /]

        [#include "/build/common/configureRepository.ftl"]

        [/@ww.form]
[/@ebcc.editConfigurationPage]