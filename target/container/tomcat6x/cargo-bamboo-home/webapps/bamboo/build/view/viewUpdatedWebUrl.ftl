[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.bulk.BulkPlanAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.bulk.BulkPlanAction" --]
[#assign webRepo = bulkAction.getMockBuildForView(params).buildDefinition.webRepositoryViewer! /]
[#if webRepo?has_content]
    [@ww.label labelKey='bulkAction.webRepo.repoType' value='${webRepo.name}'/]
    ${webRepo.getViewHtml(bulkAction.getMockBuildForView(params))!}
[#else]
    [@ww.text name='bulkAction.webRepo.noWebRepo' /]
[/#if]

