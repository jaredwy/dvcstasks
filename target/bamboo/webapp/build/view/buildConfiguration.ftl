[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.ViewBuildConfiguration" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.ViewBuildConfiguration" --]

[#import "/lib/build.ftl" as bd]

<html>
<head>
    [@ui.header pageKey='build.configuration.title.long' object='${build.name}' title=true /]
    <meta name="tab" content="config"/>
</head>
<body>
    [#assign dropDownText][@ww.text name='job.edit' /][/#assign]

    [#if build.suspendedFromBuilding]
        [@ww.text name='build.enable.description' id='buildEnableDescription']
                [@ww.param][@ww.url action='resumeBuild' namespace='/build/admin' buildKey=build.key returnUrl="/browse/${build.key}/config"/][/@ww.param]
            [/@ww.text]
        [@ui.messageBox title=buildEnableDescription /]
    [/#if]

    [@cp.configDropDown dropDownText 'planConfiguration.subMenu' /]

    [@ui.header pageKey='build.configuration.title.long' /]

    [#-- 1. Plan & project details--]
    <h2>[@ww.text name="job.details"/]</h2>
    [@ui.bambooInfoDisplay]
        [@ww.label labelKey='job.key' name='build.buildKey' /]
        [@ww.label labelKey='job.name' name='build.buildName' /]
        [@ww.label labelKey='job.description' name='build.description' /]
        [@ww.label labelKey='job.lastVcsRevisionKey' name='build.lastVcsRevisionKey' hideOnNull='true' /]
    [/@ui.bambooInfoDisplay]

    [#-- 2. Repository --]
    <h2>[@ww.text name="repository.title"/]</h2>
    [@ui.bambooInfoDisplay]
        [#include "./viewRepository.ftl"]
        [@displayRepository repository plan/]
    [/@ui.bambooInfoDisplay]

    [#-- 3. Builder --]
    <h2>[@ww.text name="builder.title"/]</h2>
    [@ui.bambooInfoDisplay]
        [#include "./viewBuilder.ftl"]
    [/@ui.bambooInfoDisplay]

    [#-- 3a. Tasks --]
    [#include "./viewTasks.ftl"]

    [#-- 4. Requirements--]
    <h2>[@ww.text name="requirement.title"/]</h2>
    [@ui.bambooInfoDisplay]
        [@bd.configureBuildRequirement showForm=false showOperations=false /]
    [/@ui.bambooInfoDisplay]

    [#--5. Artifacts--]
    [#if artifactDefinitions?has_content]
        <h2>[@ww.text name='artifact.produced.title'/]</h2>
        [@ui.bambooInfoDisplay]
            <p>[@ww.text name='artifact.definition.description'/]</p>
            [@bd.displayArtifactDefinitions artifactDefinitions=artifactDefinitions showOperations=false/]
        [/@ui.bambooInfoDisplay]
    [/#if]

    [#if artifactSubscriptions?has_content]
        <h2>[@ww.text name='artifact.consumed.title'/]</h2>
        [@ui.bambooInfoDisplay]
            <p>[@ww.text name='artifact.consumed.description'/]</p>
            [@bd.displayArtifactSubscriptions artifactSubscriptions=artifactSubscriptions showOperations=false showSubstitutionVariables=true /]
        [/@ui.bambooInfoDisplay]
    [/#if]

    [#-- 5. Notifications --]
    [#if plan.type != "JOB" && (chain.notificationSet.notificationRules)?has_content]
        <h2>[@ww.text name="notification.title"/]</h2>
        [@ui.bambooInfoDisplay]
            [@bd.existingNotificationsTable /]
        [/@ui.bambooInfoDisplay]
    [/#if]

    [#-- 6. Post actions --]
    [#if buildCompleteActionsPluginHtmlList?has_content]
        <h2>[@ww.text name="build.post.action.title"/]</h2>
        [@ui.bambooInfoDisplay]
            [#list buildCompleteActionsPluginHtmlList as pluginHtml]
                ${pluginHtml}
            [/#list]
        [/@ui.bambooInfoDisplay]
    [/#if]

    [#-- 8. Miscellaneous --]
    [#assign pluginsPage = miscellaneousBuildConfigurationViewHtml /]
    [#if pluginsPage?has_content]
        <h2>[@ww.text name="build.miscellaneous"/]</h2>
        [@ui.bambooInfoDisplay]
            ${pluginsPage}
        [/@ui.bambooInfoDisplay]
    [/#if]

    [#-- 8. Permissions --]
    [#if plan.type != "JOB" && fn.hasPlanPermission('ADMINISTRATION', plan) ]
        <h2>[@ww.text name="chain.permissions.title"/]</h2>
        [@ui.bambooInfoDisplay]
            [@ww.action name="viewChainPermissions" executeResult="true"  ]
                [@ww.param name="planKey" value="'${plan.key}'"/]
            [/@ww.action]
        [/@ui.bambooInfoDisplay]
    [/#if]

</body>
</html>
