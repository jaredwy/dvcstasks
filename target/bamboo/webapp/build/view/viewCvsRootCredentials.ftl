[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.admin.ViewPlanConfiguration" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.admin.ViewPlanConfiguration" --]
[#if plan.buildDefinition.repository?exists]
    [#assign repo = plan.buildDefinition.repository /]
    [#if repo.key == 'com.atlassian.bamboo.plugin.system.repository:cvs']
        [#if plan.buildDefinition.inheritRepository]<span class="note">[@ww.text name="repository.inherit.note"/]</span>[/#if]
        [@ww.label labelKey='repository.cvs.root' name='plan.buildDefinition.repository.cvsRoot' /]
        [@ww.label labelKey='repository.cvs.authentication' name='plan.buildDefinition.repository.authType' /]
        [@ww.label labelKey='repository.cvs.keyFile' name='plan.buildDefinition.repository.keyFile' hideOnNull='true' /]
    [#else]
        [@ww.text name='bulkAction.cvs.notCvs' /]
    [/#if]
[#else]
    [@ww.text name='bulkAction.repo.notPlugin' /]
[/#if]