[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildArtifact" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildArtifact" --]
[#import "/fragments/artifact/artifacts.ftl" as artifacts/]

[@ww.form action="deleteArtifactDefinition" namespace="/ajax"
        cssClass="bambooAuiDialogForm"]

<div class="artifact-delete-definition">
    <p>
    [@ww.text name='artifact.definition.delete.definition' ]
        [@ww.param]<strong>${artifactDefinition.name}</strong>[/@ww.param]
    [/@ww.text]
    </p>
</div>
    [@ww.text id='deletionMessage' name='artifact.definition.delete.subscriptions'/]
    [@artifacts.displaySubscribersAndProducersByStage subscribedJobs=action.getJobsSubscribedToArtifact(artifactDefinition) dependenciesDeletionMessage=deletionMessage/]
[@ww.hidden name='planKey' /]
[@ww.hidden name='artifactId' /]
[/@ww.form]