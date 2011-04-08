[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildPermissions" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildPermissions" --]
[#import "/lib/build.ftl" as bd]

[#import "editBuildConfigurationCommon.ftl" as ebcc/]
[@ebcc.editConfigurationPage plan=plan  selectedTab='permissions']
        [@bd.configurePermissions action='updateBuildPermissions' cancelUri='/build/buildConfiguration.action?buildKey=${build.key}' /]
[/@ebcc.editConfigurationPage]