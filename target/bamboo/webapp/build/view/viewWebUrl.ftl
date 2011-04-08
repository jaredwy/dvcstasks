[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.admin.ViewPlanConfiguration" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.admin.ViewPlanConfiguration" --]
[#if plan.buildDefinition.webRepositoryViewer?has_content]
    [@ww.label labelKey='bulkAction.webRepo.repoType' name='plan.buildDefinition.webRepositoryViewer.name'/]
    ${plan.buildDefinition.webRepositoryViewer.getViewHtml(plan)!}
[#else]
    [@ww.text name='bulkAction.webRepo.noWebRepo' /]
[/#if]
