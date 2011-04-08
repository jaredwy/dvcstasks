[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.admin.ViewPlanConfiguration" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.admin.ViewPlanConfiguration" --]
[#if plan.buildDefinition.repository?exists]
    [#assign repo = plan.buildDefinition.repository /]
    [#if repo.key == 'com.atlassian.bamboo.plugin.system.repository:svn']
        ${repo.repositoryUrl?html} [#if plan.buildDefinition.inheritRepository]<span class="note">([@ww.text name="repository.inherit.note"/])</span>[/#if]
    [#else]
        [@ww.text name='bulkAction.svn.notSvn' /]
    [/#if]
[#else]
    [@ww.text name='bulkAction.repo.notPlugin' /]
[/#if]