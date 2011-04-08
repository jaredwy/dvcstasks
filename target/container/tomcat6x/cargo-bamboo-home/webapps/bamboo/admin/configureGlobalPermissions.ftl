[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.ConfigureGlobalPermissions" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.ConfigureGlobalPermissions" --]
<html>
<head>
	<title>[@ww.text name='config.global.permissions.title' /]</title>
</head>
<body>
	<h1>[@ww.text name='config.global.permissions.heading' /]</h1>
	<p>[@ww.text name='config.global.permissions.description' /]</p>
        [@ww.form action='configureGlobalPermissions' submitLabelKey='global.buttons.update' titleKey='config.global.permissions.title' id='permissions' cancelUri='/admin/viewGlobalPermissions.action']

                <div class="permissionForm">
                    <div class="formArea">
                [#if grantedUsers?has_content]

                    <table class="aui permissions" id="configureGlobalUserPermissions">
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
                        [#if action.hasEditPermissionForUserName(user)]
                            <tr>
                                <td>${user}</td>
                                [@permissionCheckBox principal='${user}' permission='READ' /]
                                [@permissionCheckBox principal='${user}' permission='CREATE' /]
                                [#if action.isRestrictedAdminEnabled()]
                                [@permissionCheckBox principal='${user}' permission='RESTRICTEDADMINISTRATION' /]
                                [/#if]
                                [#if action.hasGlobalAdminPermission()]
                                [@permissionCheckBox principal='${user}' permission='ADMINISTRATION' /]
                                [/#if]
                            </tr>
                        [/#if]
                    [/#list]
                </table>
                [/#if]

                [#if grantedGroups?has_content]
                    <table class="aui" id="configureGlobalGroupPermissions">
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
                            [@permissionCheckBox principal='${group}' type='group' permission='READ' /]
                            [@permissionCheckBox principal='${group}' type='group' permission='CREATE' /]
                            [#if action.isRestrictedAdminEnabled()]
                            [@permissionCheckBox principal='${group}' type='group' permission='RESTRICTEDADMINISTRATION' /]
                            [/#if]
                            [#if action.hasGlobalAdminPermission()]
                            [@permissionCheckBox principal='${group}' type='group' permission='ADMINISTRATION' /]
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
                    [@permissionCheckBox principal='ROLE_USER' type='role' permission='READ' /]
                    [@permissionCheckBox principal='ROLE_USER' type='role' permission='CREATE' /]
                    [#if action.isRestrictedAdminEnabled()]
                    <td></td>
                    [/#if]
                    [#if action.hasGlobalAdminPermission()]
                    <td></td>
                    [/#if]
                </tr>
                <tr>
                    <td>Anonymous users</td>
                    [@permissionCheckBox principal='ROLE_ANONYMOUS' type='role' permission='READ' /]
                    <td></td>
                    [#if action.isRestrictedAdminEnabled()]
                    <td></td>
                    [/#if]
                    [#if action.hasGlobalAdminPermission()]
                    <td></td>
                    [/#if]
                </tr>
            </table>

            <h3>[@ww.text name='build.permission.form.add.title'/]</h3>
            <div class="permissionFieldLabel">
                 [@ww.select name='principalType' list=['User', 'Group'] toggle='true' ][/@ww.select]
            </div>

            [@ui.bambooSection dependsOn='principalType' showOn='User']
                [@ww.textfield name='newUser' template='userPicker' multiSelect=false/]
                [@ui.buttons]
                    <input type="submit" name="addUserPrincipal" value="Add" />
                [/@ui.buttons]
            [/@ui.bambooSection]

            [@ui.bambooSection dependsOn='principalType' showOn='Group']
                [@ww.textfield name='newGroup' /]
                [@ui.buttons]
                    <input type="submit" name="addGroupPrincipal" value="Add" />
                [/@ui.buttons]
            [/@ui.bambooSection]
            </div>
            <div class="helpTextArea">
                <span class="helpTextHeading">Permission Types</span>
                <ul>
                    <li><strong>Access</strong> - User can access Bamboo.</li>
                    <li><strong>Create Plan</strong> - User can create a new plan in Bamboo.</li>
                    <li><strong>Restricted Admin</strong> - User can perform some administration operations and view all plans in Bamboo.</li>
                    [#if action.hasGlobalAdminPermission()]
                    <li><strong>Admin</strong> - User can perform all operations and view all plans in Bamboo.</li>
                    [/#if]
                </ul>
            </div>
        </div>
        [@ui.clear /]
        [/@ww.form]
    </body>
</html>

[#macro permissionCheckBox principal permission type='user' ]
    [#assign fieldname='bambooPermission_${type}_${principal}_${permission}' /]
    [#assign granted=grantedPermissions.contains(fieldname) /]
    <td class="checkboxCell clickable" id="${fieldname}_cell"><input type="checkbox" name="${fieldname}" [#if granted]checked[/#if] />
    <script type="text/javascript">
        attachHandler('${fieldname}_cell', 'click', toggleContainingCheckbox)
    </script>

    </td>
[/#macro]
