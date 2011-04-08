[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.create.CreateChain" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.create.CreateChain" --]
<title>[@ww.text name='plan.create' /]</title>

[@ui.header pageKey='plan.create.clone.title' descriptionKey='plan.create.clone.description' /]

<div class="onePageCreate">
[@ww.form action="performClonePlan" namespace="/build/admin/create"
          cancelUri='addPlan.action'
          submitLabelKey='Create']

        [@ui.bambooSection titleKey="chain.clone.list"]
            [#if plansToClone?has_content]
                [@ww.select labelKey='chain.clone.list' name='planKeyToClone'
                            list='plansToClone' listKey='key' listValue='name' groupBy='project.name']
                [/@ww.select]
            [#else]
                [@ui.messageBox type="error" titleKey="build.clone.list.empty" /]
            [/#if]
        [/@ui.bambooSection]

        [@ui.bambooSection titleKey="build.details"]
            [#include "/fragments/project/selectCreateProject.ftl"]
            [#include "/fragments/chains/editChainKeyName.ftl"]

            [@ww.hidden name="clonePlan" value="true"/]
        [/@ui.bambooSection]

        [@ui.bambooSection titleKey="plan.create.enable.title"]
            [@ww.checkbox labelKey="plan.create.enable.option" name='tmp.createAsEnabled' descriptionKey='plan.create.enable.description' value='true'/]
        [/@ui.bambooSection]
        
[/@ww.form]
</div>