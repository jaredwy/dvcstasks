[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.CreateJob" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.CreateJob" --]
<meta name="decorator" content="atl.general"/>

<div id="create-content">
[#import "/fragments/artifact/artifacts.ftl" as artifacts/]

[@ui.header pageKey='job.create.clone.title' title=true/]
[@ui.header pageKey='job.create.clone.title' descriptionKey='job.create.clone.description' /]

<div class="onePageCreate">
[@ww.form action="createClonedJob.action" namespace="/chain/admin/config"
          cancelUri='/browse/${buildKey}/stages'
          submitLabelKey='Create']

        [@ui.bambooSection titleKey="job.chain.clone.list"]
            [#if jobsToClone?has_content]
                [@ww.select labelKey='job.chain.clone.list' name='chainKeyToClone'
                    list='chainsToClone' listKey='key' listValue='buildName' groupBy='project.name' value='chainKeyToClone'/]
                [@ww.select labelKey='job.clone.list' name='jobKeyToClone'
                    list='jobsToClone' listKey='key' listValue='buildName' groupBy='stage.name' value='jobKeyToClone'/]
            [#else]
                [@ui.messageBox type="error" titleKey="build.clone.list.empty" /]
            [/#if]
        [/@ui.bambooSection]

        [@ui.bambooSection titleKey="job.details"]
            [#include "/fragments/chains/selectCreateStage.ftl"]
            [#include "/fragments/plan/editJobKeyName.ftl"]
        [/@ui.bambooSection]

        [@ui.bambooSection titleKey="job.create.enable.title"]
            [@ww.checkbox labelKey="plan.create.enable.option" name='tmp.createAsEnabled' descriptionKey='job.create.enable.description'/]
        [/@ui.bambooSection]

        [@ww.hidden name='buildKey' value='${chain.key}' /]
        [@ww.hidden name="cloneJob" value="true"/]
        [@ww.hidden id='ignoreUnclonableSubscriptions' name='ignoreUnclonableSubscriptions' value='false'/]
[/@ww.form]
</div>
</div>
<script type="text/javascript">
    AJS.$(function() {
        //Ajax loading of Jobs
        var jobList = AJS.$('#createClonedJob_jobKeyToClone');
        AJS.$('#createClonedJob_chainKeyToClone').change(function() {
            jobList.attr('disabled', 'disabled');
            var key = AJS.$(this).val();
            AJS.$.get('${req.contextPath}/chain/admin/ajax/getJobs.action?planKey=' + key, function(data) {
                var select = "";
                for (var stage in data) {
                    select += '<optgroup label="' + stage + '">';
                    var jobs = data[stage];
                    for (var i = 0; i < jobs.length; i++) {
                        var job = jobs[i];
                        select += '<option value="' + job.key + '">' + job.name + '</option>';
                    }
                    select += "</optgroup>";
                }
                jobList.html(select).removeAttr('disabled');
                [#if jobKeyToClone?? && chainKeyToClone??]
                    if (key == '${chainKeyToClone}') {
                        jobList.attr('value', '${jobKeyToClone}');
                    }
                [/#if]
            });
        }).change();
    });
</script>

[#macro confirmationDialogContent]
    <form class="aui">
        <div class="artifact-delete-definition">
            <p>
            [@ww.text name='job.clone.confirm.warning' /]
            </p>
        </div>

        [@ww.text name='job.clone.confirm.subscriptions' id='confirmationMsg'/]
        [@artifacts.displaySubscribersAndProducersByStage subscribedJobs=jobsContainingInvalidSubscriptions dependenciesDeletionMessage=confirmationMsg/]
    </form>
[/#macro]

[#if unclonableSubscriptions?has_content]
    [#--
        this happens when action returns with validation passed but detects that there are
        subscriptions that cannot be cloned: display confirmation popup
    --]
    <script type="text/x-template" title="cloneJobDialog-template">
        [@confirmationDialogContent/]
    </script>

    <script type="text/javascript">
       var content = AJS.template.load("cloneJobDialog-template").toString(),
               onSubmit = function()
               {
                   AJS.$("#ignoreUnclonableSubscriptions").attr('value', true);
                   AJS.$("#createClonedJob").submit();
               },
               onCancel = function()
               {
                   AJS.$("#ignoreUnclonableSubscriptions").attr('value', false);
               };

       simpleConfirmationDialog(600, 500, content, "[@ww.text name='job.create.clone.title'/]", "[@ww.text name='job.create'/]", "[@ww.text name='global.buttons.cancel'/]", onSubmit, onCancel);
    </script>
[/#if]
