<title>[@ww.text name='plan.create' /]</title>
<meta name="decorator" content="createWizard"/>
<meta name="tab" content="2"/>
<meta name="prefix" content="job"/>

[@ui.header pageKey="plan.create.tasks.title" descriptionKey="plan.create.tasks.description" /]

<div id="onePageCreate">
[#include "/build/edit/editBuildTasksCommon.ftl"/]

[@ww.form   action="finaliseJobCreation"
            namespace="/chain/admin"
            submitLabelKey="global.buttons.create"]
    [@ww.hidden name="planKey"/]
    <div class="createAsEnabledSection">
        [@ui.bambooSection titleKey="job.create.enable.title"]
            [@ww.checkbox labelKey="job.create.enable.option" name='enabled' descriptionKey='job.create.enable.description'/]
        [/@ui.bambooSection]
    </div>
    [@ww.param name="buttons"]
        <a class="cancel requireConfirmation" href="[@ww.url namespace='/chain/admin' action='cancelJobCreation' planKey=planKey/]" accesskey="`" title="[@ww.text name='job.create.cancel.confirm'/]">
            [@ww.text name="global.buttons.cancel"/]
        </a>
    [/@ww.param]
[/@ww.form]
</div>
