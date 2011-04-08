[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.group.BrowseGroupsAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.group.BrowseGroupsAction" --]
<table id="existingGroups" class="aui">
    <thead>
    <tr>
        <th>Group</th>
        <th>Number of Users</th>
        <th>Operations</th>
    </tr>
    </thead>
    [#foreach group in paginationSupport.page]
    [#if group.name != 'bamboo-admin' || (group.name == 'bamboo-admin' && fn.hasGlobalAdminPermission())]
    <tr [#if affectedGroupName?exists && affectedGroupName==group.name] class="selectedRow"[/#if]>
        <td>
            ${group.name}
        </td>
        <td>
            ${action.getUsersCountForGroup(group)}
        </td>
        <td class="operations">
            [#if !bambooUserManager.isReadOnly(group) && !action.isExternallyManaged()]
                <a id="editGroup-${group.name}" href="[@ww.url action='editGroup' groupName=group.name /]">
                    Edit
                </a>
                [#if group.name != 'bamboo-admin' && group.name != 'bamboo-restricted-admin' ]
                |
                 <a id="deleteGroup-${group.name}" href="[@ww.url action='deleteGroup' groupName=group.name /]">
                    Delete
                </a>
                [/#if]
            [/#if]
        </td>
    </tr>
    [/#if]
    [/#foreach]
</table>

[@cp.entityPagination actionUrl='${req.contextPath}/admin/group/viewGroups.action?' paginationSupport=paginationSupport /]