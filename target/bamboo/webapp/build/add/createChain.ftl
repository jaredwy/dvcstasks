[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.create.CreateChain" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.create.CreateChain" --]
<meta name="decorator" content="createWizard"/>
<meta name="tab" content="1"/>
<title>[@ww.text name='plan.create' /]</title>

[@ui.header pageKey="plan.create.new.title" descriptionKey="plan.create.new.description"/]

<div id="onePageCreate">
[@ww.form action="createPlan" namespace="/build/admin/create"
          method="post" enctype="multipart/form-data"
          cancelUri='addPlan.action'
          submitLabelKey='plan.create.tasks.button']

        <div class="configSection">
            [@ui.bambooSection titleKey="build.details"]
                [#include "/fragments/project/selectCreateProject.ftl"]
                [#include "/fragments/chains/editChainKeyName.ftl"]
            [/@ui.bambooSection]

            [@ui.bambooSection titleKey="repository.title"]
                [@ww.select labelKey='repository.type' name='selectedRepository' id='selectedRepository' toggle='true'
                            list='uiConfigBean.repositories' listKey='key' listValue='name']
                [/@ww.select]
                [#list uiConfigBean.repositories as repo]
                    [@ui.bambooSection dependsOn='selectedRepository' showOn='${repo.key}']
                        ${repo.getMinimalEditHtml(buildConfiguration)!}
                    [/@ui.bambooSection]
                [/#list]
            [/@ui.bambooSection ]

            [@ww.hidden name="selectedWebRepositoryViewer" value="bamboo.webrepositoryviewer.provided:noRepositoryViewer" /]

            [@ui.bambooSection titleKey="repository.change"]
                [#include "/build/common/configureBuildStrategy.ftl"]
                [@configureBuildStrategy selectedRepository=selectedRepository/]
            [/@ui.bambooSection ]
        </div>

        <h2>[@ww.text name="plan.create.new.job"/]</h2>
        <p>[@ww.text name="plan.create.new.job.description"/]</p>
        <div class="configSection">
            [@ui.bambooSection titleKey="builder.title.long"]
                [#include "/build/common/configureBuilder.ftl"]
            [/@ui.bambooSection]
        </div>
[/@ww.form]
</div>