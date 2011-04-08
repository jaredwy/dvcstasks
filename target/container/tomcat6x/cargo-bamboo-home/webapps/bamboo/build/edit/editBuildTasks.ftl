[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.task.ConfigureBuildTasks" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.task.ConfigureBuildTasks" --]

[#import "editBuildConfigurationCommon.ftl" as ebcc/]
[@ebcc.editConfigurationPage plan=plan selectedTab='tasks']
    [@ww.text id="tasksTitleDescription" name="tasks.config.description"]
    [@ww.param][@ww.url action='defaultBuildArtifact' namespace='/build/admin/edit' buildKey=planKey /][/@ww.param]
    [/@ww.text]
    [@ui.header pageKey="tasks.config.title" description=tasksTitleDescription /]
    [#include "./editBuildTasksCommon.ftl"/]
[/@ebcc.editConfigurationPage]

