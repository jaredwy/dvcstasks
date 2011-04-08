<title>[@ww.text name='plan.create' /]</title>
<meta name="decorator" content="createWizard"/>
<meta name="tab" content="2"/>

[@ui.header pageKey="plan.create.tasks.title" descriptionKey="plan.create.tasks.description" /]

<div id="onePageCreate">
    [#include "/build/edit/editBuildTasksCommon.ftl"/]

    [@ww.form   action="finalisePlanCreation"
                namespace="/build/admin/create"
                submitLabelKey="global.buttons.create"]
        [@ww.hidden name="planKey"/]
        <div class="createAsEnabledSection">
            [@ui.bambooSection titleKey="plan.create.enable.title"]
                [@ww.checkbox labelKey="plan.create.enable.option" name='enabled' descriptionKey='plan.create.enable.description'/]
            [/@ui.bambooSection]
        </div>
        [@ww.param name="buttons"]
            <a class="cancel requireConfirmation" href="[@ww.url namespace='/build/admin/create' action='cancelPlanCreation' planKey=planKey/]" accesskey="`" title="[@ww.text name='plan.create.cancel.confirm'/]">
                [@ww.text name="global.buttons.cancel"/]
            </a>
        [/@ww.param]
    [/@ww.form]
</div>
