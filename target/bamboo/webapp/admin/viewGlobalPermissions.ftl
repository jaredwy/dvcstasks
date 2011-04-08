[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.ConfigureGlobalPermissions" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.ConfigureGlobalPermissions" --]
<html>
<head>
	<title>[@ww.text name='config.global.permissions.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
	<h1>[@ww.text name='config.global.permissions.heading' /]</h1>
	<p>[@ww.text name='config.global.permissions.description' /]</p>
    <div class="paddedClearer" ></div>


          [#if grantedUsers?has_content]
                    <table class="aui permissions">
                    <thead>
                    <tr>
                        <th>Users</th>
                        <th class="checkboxCell">Access</th>
                        <th class="checkboxCell">Create Plan</th>
                        [#if action.isRestrictedAdminEnabled()]
                        <th class="checkboxCell">Restricted Admin</th>
                        [/#if]
                        [#if action.hasGlobalAdminPermission()]
                        <th class="checkboxCell">Admin</th>
                        [/#if]
                    </tr>
                    </thead>

                    [#list grantedUsers as user]
                        [#if action.hasEditPermissionForUserName(user) ]
                            <tr>
                                <td>${user}</td>
                                [@permissionIndicator principal='${user}' permission='READ' /]
                                [@permissionIndicator principal='${user}' permission='CREATE' /]
                                [#if action.isRestrictedAdminEnabled()]
                                [@permissionIndicator principal='${user}' permission='RESTRICTEDADMINISTRATION' /]
                                [/#if]
                                [#if action.hasGlobalAdminPermission()]
                                [@permissionIndicator principal='${user}' permission='ADMINISTRATION' /]
                                [/#if]
                            </tr>
                        [/#if]
                    [/#list]
                </table>
            [/#if]

                [#if grantedGroups?has_content]
                    <table class="aui permissions" id="configureGlobalGroupPermissions">
                    <thead>
                    <tr>
                        <th>Groups</th>
                        <th class="checkboxCell">Access</th>
                        <th class="checkboxCell">Create Plan</th>
                        [#if action.isRestrictedAdminEnabled()]
                        <th class="checkboxCell">Restricted Admin</th>
                        [/#if]
                        [#if action.hasGlobalAdminPermission()]
                        <th class="checkboxCell">Admin</th>
                        [/#if]
                    </tr>
                    </thead>
                    [#list grantedGroups as group]
                        [#if action.hasEditPermissionForGroup(group) ]                         
                            <tr>
                                <td>${group}</td>
                                [@permissionIndicator principal='${group}' type='group' permission='READ' /]
                                [@permissionIndicator principal='${group}' type='group' permission='CREATE' /]
                                [#if action.isRestrictedAdminEnabled()]
                                [@permissionIndicator principal='${group}' type='group' permission='RESTRICTEDADMINISTRATION' /]
                                [/#if]
                                [#if action.hasGlobalAdminPermission()]
                                [@permissionIndicator principal='${group}' type='group' permission='ADMINISTRATION' /]
                                [/#if]

                            </tr>
                        [/#if]
                    [/#list]
                    </table>
                [/#if]

            <table class="aui permissions" id="configureGlobalOtherPermissions">
                <thead>
                <tr>
                    <th>Other</th>
                    <th class="checkboxCell">Access</th>
                    <th class="checkboxCell">Create Plan</th>
                    [#if action.isRestrictedAdminEnabled()]
                    <th class="checkboxCell">Restricted Admin</th>
                    [/#if]
                    [#if action.hasGlobalAdminPermission()]
                    <th class="checkboxCell"></th>
                    [/#if]
                </tr>
                </thead>
                <tr>
                    <td>All logged in users</td>
                    [@permissionIndicator principal='ROLE_USER' type='role' permission='READ' /]
                    [@permissionIndicator principal='ROLE_USER' type='role' permission='CREATE' /]
                    [#if action.isRestrictedAdminEnabled()]
                    <td></td>
                    [/#if]
                    [#if action.hasGlobalAdminPermission()]
                    <td></td>
                    [/#if]
                </tr>
                <tr>
                    <td>Anonymous users</td>
                    [@permissionIndicator principal='ROLE_ANONYMOUS' type='role' permission='READ' /]
                    <td></td>
                    [#if action.isRestrictedAdminEnabled()]
                    <td></td>
                    [/#if]
                    [#if action.hasGlobalAdminPermission()]
                    <td></td>
                    [/#if]
                </tr>
            </table>

        <form id="editPermissions" action='${req.contextPath}/build/admin/configureGlobalPermissions!default.action'>
            <div class="formFooter">
                <div class="buttons" id=viewGlobalPermissions>
                    <input type="submit" name="editPermissionConfigurations" value="Edit Global Permissions"/>
                </div>
            </div>
        </form>


[#macro permissionIndicator principal permission type='user' ]
    [#assign fieldname='bambooPermission_${type}_${principal}_${permission}' /]
    [#assign granted=grantedPermissions.contains(fieldname) /]
    <td class="checkboxCell">
        [#if granted]
            <img id="${fieldname}" src="${req.contextPath}/images/jt/icn_permission_check.gif">
        [#else]
            <img id="${fieldname}" src="${req.contextPath}/images/jt/icn_permission_unchecked.gif">
        [/#if]
    </td>
[/#macro]

</body>
</html>
