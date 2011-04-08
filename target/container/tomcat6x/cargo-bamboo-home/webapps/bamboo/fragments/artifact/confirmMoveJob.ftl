[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.MoveJobAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.MoveJobAction" --]
[#import "/fragments/artifact/artifacts.ftl" as artifacts/]

[@ww.form action="moveJob" namespace="/chain/admin/ajax" cssClass="bambooAuiDialogForm"]
<div class="artifact-delete-definition">
    <p>
        [@ww.text name='job.move.confirm.warning' /]
    </p>
</div>

[@ww.text name='job.move.confirm.subscriptions' id='confirmationMsg'/]
[@artifacts.displaySubscribersAndProducersByStage subscribedJobs=jobsContainingInvalidSubscriptions dependenciesDeletionMessage=confirmationMsg/]

[@ww.hidden name='planKey' /]
[@ww.hidden name='stageId' /]
[@ww.hidden name='jobKey' /]
[@ww.hidden name='removeBrokenSubscriptions' value='true' /]
[/@ww.form]
