[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildArtifact" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildArtifact" --]
[#import "/lib/build.ftl" as bd]
[#import "editBuildConfigurationCommon.ftl" as ebcc/]

<script type="text/javascript">
    function createArtifactDefinitionCallback(result) {
        window.location.reload(true);
    }

    function createArtifactSubscriptionCallback(result) {
        window.location.reload(true);
    }
</script>


[@ebcc.editConfigurationPage plan=plan  selectedTab='artifacts']
    [#assign artifactDefinitionTools]
        <ul class="toolbar-group">
            <li class="toolbar-item">
                <a id="createArtifactDefinition" class="toolbar-trigger" title="[@ww.text name='artifact.definition.create'/]">[@ww.text name='artifact.definition.create'/]</a>
            </li>
        </ul>
    [/#assign]

    [@dj.simpleDialogForm
        triggerSelector="#createArtifactDefinition"
        actionUrl="/ajax/addArtifactDefinition.action?planKey=${planKey}"
        width=800 height=450
        submitLabelKey="global.buttons.create"
        submitMode="ajax"
        submitCallback="createArtifactDefinitionCallback"
    /]

    [@ui.bambooPanel titleKey='artifact.definition.title' descriptionKey='artifact.definition.description' auiToolbar=artifactDefinitionTools content=true ]
        [@bd.displayArtifactDefinitions artifactDefinitions=artifactDefinitions showOperations=true/]
    [/@ui.bambooPanel]

    [@ui.renderWebPanels 'job.configuration.artifact.definitions'/]

    [#if artifactSubscriptionPossible]
        [#assign artifactSubscriptionTools]
        <ul class="toolbar-group">
            <li class="toolbar-item">
                <a id="createArtifactSubscription" class="toolbar-trigger" title="[@ww.text name='artifact.subscription.create'/]">[@ww.text name='artifact.subscription.create'/]</a>
            </li>
        </ul>
        [/#assign]

        [@dj.simpleDialogForm
            triggerSelector="#createArtifactSubscription"
            actionUrl="/ajax/addArtifactSubscription.action?planKey=${planKey}"
            width=800 height=400
            submitLabelKey="global.buttons.create"
            submitMode="ajax"
            submitCallback="createArtifactSubscriptionCallback"
        /]

        [@ui.bambooPanel titleKey='artifact.consumed.title' descriptionKey='artifact.consumed.description' auiToolbar=artifactSubscriptionTools content=true ]
            [@bd.displayArtifactSubscriptions artifactSubscriptions=artifactSubscriptions showOperations=true/]
        [/@ui.bambooPanel]
    [#else]
        [@ui.bambooPanel titleKey='artifact.consumed.title']
            [@ui.messageBox type="info"]
                [@ww.text name='artifact.subscription.first.stage.info' /]
            [/@ui.messageBox]
        [/@ui.bambooPanel]
    [/#if]

    [@ui.renderWebPanels 'job.configuration.artifact.subscriptions'/]
[/@ebcc.editConfigurationPage]