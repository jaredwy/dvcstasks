[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildDetails" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildDetails" --]

[#import "editBuildConfigurationCommon.ftl" as ebcc/]
[@ebcc.editConfigurationPage plan=plan  selectedTab='build.details']
        [@ww.form action="updateBuildDetails" namespace="/build/admin/edit"
              cancelUri='/build/buildConfiguration.action?buildKey=${build.key}' 
              submitLabelKey='global.buttons.update' titleKey='job.details.edit']
            [@ww.hidden name="buildKey" /]
            [@ww.textfield labelKey='job.name' name='buildName' required='true' /]
            [@ww.textfield labelKey='job.description' name='buildDescription' required='false' /]
            [@ww.checkbox labelKey='job.enabled' name="enabled" /]
        [/@ww.form]
[/@ebcc.editConfigurationPage]