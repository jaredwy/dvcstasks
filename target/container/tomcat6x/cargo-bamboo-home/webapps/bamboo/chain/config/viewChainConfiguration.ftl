[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.admin.ViewChainConfiguration" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.admin.ViewChainConfiguration" --]
<html>
<head>
    <title> [@ui.header pageKey='chain.configuration.title.long' object='${chain.name}' title=true /]</title>
    <meta name="tab" content="config"/>
</head>
<body>

    [#import "/lib/chains.ftl" as chains]

    [#assign dropDownText][@ww.text name='chain.edit' /][/#assign]
    [#if chain.suspendedFromBuilding]
        [@ww.text name='build.enable.description' id='buildEnableDescription']
            [@ww.param][@ww.url action='resumeBuild' namespace='/build/admin' buildKey=chain.key returnUrl="/browse/${chain.key}/config"/][/@ww.param]
        [/@ww.text]
        [@ui.messageBox title=buildEnableDescription /]
    [/#if]

    [@cp.configDropDown dropDownText 'chainConfiguration.subMenu'/]

    [@ui.header pageKey='chain.configuration.title.long' /]

    <h2>[@ww.text name="chain.config.details"/]</h2>
    [@ui.bambooInfoDisplay]
        [@ww.label labelKey='project.key' name='chain.project.key' /]
        [@ww.label labelKey='project.name' name='chain.project.name' /]
        [@ww.label labelKey='chain.key' name='chain.buildKey' /]
        [@ww.label labelKey='chain.name' name='chain.buildName' /]
        [@ww.label labelKey='chainDescription' name='chain.description'  hideOnNull='true' /]
        [@ww.label labelKey='chain.lastVcsRevisionKey' name='chain.lastVcsRevisionKey' hideOnNull='true' /]
    [/@ui.bambooInfoDisplay]

    <h2>[@ww.text name="repository.title"/]</h2>
    [@ui.bambooInfoDisplay]
        [#include "/build/view/viewRepository.ftl"]
        [@displayRepository repository plan/]
    [/@ui.bambooInfoDisplay]

    [#assign pluginHtml = dependenciesBuildConfigurationViewHtml /]
    [#if parentPlanDependencies?has_content || childPlanDependencies?has_content || pluginHtml?has_content]
        <h2>[@ww.text name="chain.dependency.title"/]</h2>
        [@ui.bambooInfoDisplay]
            [#include "/build/view/viewDependencies.ftl"]
            [@showDependencies parentPlanDependencies childPlanDependencies dependencyBlockingStrategy /]
            [#if pluginHtml?has_content]
                <p>${pluginHtml}</p>
            [/#if]
        [/@ui.bambooInfoDisplay]
    [/#if]

    [#if (chain.notificationSet.notificationRules)?has_content]
        <h2>[@ww.text name="notification.title"/]</h2>
        [@ui.bambooInfoDisplay]
            [#include "/chain/view/viewNotifications.ftl"]
        [/@ui.bambooInfoDisplay]
    [/#if]

    [#if artifactDefinitions.keySet().size() > 0]
        <h2>[@ww.text name="artifact.shared.title"/]</h2>
        [@ui.bambooInfoDisplay]
            [@chains.displaySharedArtifactDefinitions artifactDefinitions /]
        [/@ui.bambooInfoDisplay]
    [/#if]

    [#assign pluginsPage = miscellaneousBuildConfigurationViewHtml/]
    [#if pluginsPage?has_content]
        <h2>[@ww.text name="build.miscellaneous"/]</h2>
        [@ui.bambooInfoDisplay]
            ${pluginsPage}
        [/@ui.bambooInfoDisplay]
    [/#if]

    [#if fn.hasPlanPermission('ADMINISTRATION', chain) ]
        <h2>[@ww.text name="chain.permissions.title"/]</h2>
        [@ui.bambooInfoDisplay]
            [@ww.action name="viewChainPermissions" executeResult="true"  ]
                 [@ww.param name="planKey" value="'${plan.key}'"/]
            [/@ww.action]
        [/@ui.bambooInfoDisplay]
    [/#if]

    [#-- Variables --]
    [#if variableDefinitions?has_content]
        [#import "/fragments/variable/variables.ftl" as variables/]
        <h2>[@ww.text name='plan.variables.title'/]</h2>
        [@ui.bambooInfoDisplay]
            [@variables.displayDefinedVariables id="variableDefinitions" variablesList=variableDefinitions /]
        [/@ui.bambooInfoDisplay]
    [/#if]

    <h2>[@ww.text name='chain.logs.title'/]</h2>
    <p><a class="view"  href="[@ww.url value="/chain/viewChainActivityLog.action?planKey=${chain.key}"/]">[@ww.text name="plan.configuration.view.log"/]</a></p>
</body>
</html>
