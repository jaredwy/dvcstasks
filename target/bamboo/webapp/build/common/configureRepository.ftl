[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildRepository" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.ConfigureBuildRepository" --]

[#include "/build/common/commonRepositoryEdit.ftl"]

[@ww.checkbox labelKey='repository.inherit' toggle='true' name='inheritRepository' /]
[@ui.bambooSection dependsOn='inheritRepository' showOn='false']
    [@ww.select labelKey='repository.type' name='selectedRepository' id="selectedRepository" toggle='true'
                list='uiConfigBean.repositories' listKey='key' listValue='name' optionDescription='optionDescription']
    [/@ww.select]

    [#list uiConfigBean.repositories as repo]
        [@ui.bambooSection dependsOn='selectedRepository' showOn='${repo.key}']
            ${repo.getEditHtml(buildConfiguration, plan)!}
        [/@ui.bambooSection]
    [/#list]

    [@commonRepositoryEdit plan=plan/]

    [#if plan.type != "JOB"]
        [#include "/build/common/configureBuildStrategy.ftl"]
        [@configureBuildStrategy selectedRepository=selectedRepository long=true/]
    [/#if]
[/@ui.bambooSection]
[#if plan.parent??]
    [@ui.bambooSection dependsOn='inheritRepository' showOn='true']
        [#include "/build/view/viewRepository.ftl"]
        <div class="parentRepository">
            [@displayRepository repository=plan.parent.buildDefinition.repository plan=plan.parent condensed=true/]
        </div>
    [/@ui.bambooSection]
[/#if]
