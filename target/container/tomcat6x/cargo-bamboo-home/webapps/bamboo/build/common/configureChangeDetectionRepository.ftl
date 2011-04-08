[#include "/build/common/commonRepositoryEdit.ftl"]
[@ww.select labelKey='repository.type' name='selectedRepository' id="selectedRepository" toggle='true'
            list=uiConfigBean.repositories listKey='key' listValue='name' optionDescription='optionDescription']
[/@ww.select]

[#list uiConfigBean.repositories as repo]
    [@ui.bambooSection dependsOn='selectedRepository' showOn='${repo.key}']
        ${repo.getEditHtml(buildConfiguration, plan)!}
    [/@ui.bambooSection]
[/#list]

[@commonRepositoryEdit plan=plan changeDetection=true/]

[#include "/build/common/configureBuildStrategy.ftl"]
[@configureBuildStrategy selectedRepository=selectedRepository long=true/]
