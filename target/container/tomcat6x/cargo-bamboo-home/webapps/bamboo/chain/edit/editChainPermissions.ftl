[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildPermissions" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildPermissions" --]
[#import "/lib/build.ftl" as bd]
[#import "editChainConfigurationCommon.ftl" as eccc/]

[@eccc.editChainConfigurationPage plan=plan selectedTab='permissions' ]
        [@bd.configurePermissions action='updateChainPermissions' cancelUri='/browse/${plan.key}/config' /]
[/@eccc.editChainConfigurationPage]
