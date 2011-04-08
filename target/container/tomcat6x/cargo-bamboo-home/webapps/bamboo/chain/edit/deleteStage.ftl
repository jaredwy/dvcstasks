
[#assign title]
    [@ww.text name='stage.delete.pagetitle']
        [@ww.param]${stageName}[/@ww.param]
    [/@ww.text]
[/#assign]

<title>${title}</title>
<div class="section">
    [#if plan.isActive()]
        [@ww.form title='${title}'
                      action='stopPlan' namespace='/build/admin'
                      submitLabelKey='global.buttons.confirm'
                      cancelUri='/browse/${plan.key}/config#Structure' ]
            [@ww.hidden name="planKey" value="${plan.key}"/]
            [@ui.messageBox type="warning"]
                [@ww.text name='stage.delete.running']
                    [@ww.param]${stageName}[/@ww.param]
                    [@ww.param]${plan.getName()}[/@ww.param]
                [/@ww.text]
            [/@ui.messageBox]
        [/@ww.form]
    [#else]
        [@ww.form title='${title}'
                      action='deleteStage' namespace='/chain/admin'
                      submitLabelKey='global.buttons.confirm'
                      cancelUri='/browse/${plan.key}/stages' ]
            [@ww.hidden name="buildKey"/]
            [@ww.hidden name='stageId'/]
            [@ui.messageBox type="warning"]
                [@ww.text name='stage.delete.description']
                    [@ww.param]${stageName}[/@ww.param]
                    [@ww.param value='${chainStage.getJobs().size()}'/]
                [/@ww.text]
            [/@ui.messageBox]
            [#if jobsContainingInvalidSubscriptions?has_content ]
                [#import "/fragments/artifact/artifacts.ftl" as artifacts/]
                [@ww.text name='job.remove.confirm.subscriptions' id='confirmationMsg'/]
                [@artifacts.displaySubscribersAndProducersByStage subscribedJobs=jobsContainingInvalidSubscriptions dependenciesDeletionMessage=confirmationMsg headerWeight='h3'/]
            [/#if]
        [/@ww.form]
    [/#if]
</div>