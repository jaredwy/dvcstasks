[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.CreateJob" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.CreateJob" --]
<title>[@ww.text name='job.create.new.title' /]</title>
<meta name="decorator" content="createWizard"/>
<meta name="tab" content="1"/>
<meta name="prefix" content="job"/>

[@ui.header pageKey='job.create.new.title' descriptionKey='job.create.new.description' /]

<div class="onePageCreate">
[@ww.form action="createJob.action" namespace="/chain/admin/config"
          method="post" enctype="multipart/form-data"
          cancelUri='/browse/${buildKey}/stages'
          submitLabelKey='plan.create.tasks.button']

        [@ww.hidden name='buildKey' value='${chain.key}' /]

        [@ui.bambooSection titleKey="job.details"]
            [#include "/fragments/chains/selectCreateStage.ftl"]
            [#include "/fragments/plan/editJobKeyName.ftl"]
        [/@ui.bambooSection]

        [@ui.bambooSection titleKey="repository.title"]
            [@ww.checkbox labelKey='repository.inherit' toggle='true' name='inheritRepository' /]
            [@ui.bambooSection dependsOn='inheritRepository' showOn='false']
                [@ww.select labelKey='repository.type' name='selectedRepository' id='selectedRepository' toggle='true'
                            list='uiConfigBean.repositories' listKey='key' listValue='name']
                [/@ww.select]
                [#list uiConfigBean.repositories as repo]
                    [@ui.bambooSection dependsOn='selectedRepository' showOn='${repo.key}']
                        ${repo.getMinimalEditHtml(buildConfiguration)!}
                    [/@ui.bambooSection]
                [/#list]
            [/@ui.bambooSection ]
            [@ui.bambooSection dependsOn='inheritRepository' showOn='true']
                [#include "/build/view/viewRepository.ftl"]
                <div class="parentRepository">
                    [@displayRepository repository=plan.buildDefinition.repository plan=plan condensed=true/]
                </div>
            [/@ui.bambooSection]
        [/@ui.bambooSection]

        [@ww.hidden name="selectedWebRepositoryViewer" value="bamboo.webrepositoryviewer.provided:noRepositoryViewer" /]

        [@ui.bambooSection titleKey="builder.title.long"]
            [#include "/build/common/configureBuilder.ftl"]
        [/@ui.bambooSection]
[/@ww.form]
</div>
