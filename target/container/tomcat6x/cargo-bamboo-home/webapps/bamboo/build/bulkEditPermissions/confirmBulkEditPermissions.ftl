[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.BulkEditBuildPermissions" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.BulkEditBuildPermissions" --]
[@ui.header pageKey='build.bulkEditPermissions.title' title=true /]
[@ui.header pageKey='build.bulkEditPermissions.title' /]

[@ui.clear /]

[@ww.form action='saveBulkEditPermissions'
            submitLabelKey='global.buttons.confirm'
            titleKey='build.bulkEditPermissions.confirm.title'
            id='confirmPermissions'
            cancelUri='/admin/chooseBuildsToBulkEditPermissions.action' ]
    <div class="descriptionSection">
        [@ww.text name="build.bulkEditPermissions.confirm.description" /]
        <ul>
        [#list selectedBuilds as selectedBuild]
             <li>${selectedBuild.name}</li>
        [/#list]
        </ul>
    </div>

    [#include "/fragments/plan/planPermissionTable.ftl" /]

    [#if grantedPermissions?has_content]
        [#list grantedPermissions as grantedPermission]
            [@ww.hidden name='${grantedPermission}' value='true' /]
        [/#list]
    [/#if]

    [#if buildIds?has_content]
        [#list buildIds as buildId]
            [@ww.hidden name='buildIds' value='${buildId}' /]
        [/#list]
    [/#if]
[/@ww.form]