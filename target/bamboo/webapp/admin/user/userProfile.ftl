[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.user.ConfigureProfile" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.user.ConfigureProfile" --]
<head>
	<title>[@ui.header pageKey='User Profile' object='${fn.getUserFullName(currentUser)}' title=true/]</title>
    <meta name="decorator" content="atl.userprofile">
    <meta name="tab" content="personalDetails">
</head>
<body>

       [@ww.url id='changePasswordUrl'
                 action='changePassword'
                 namespace='/profile' /]
       [@ww.url id='changeProfileUrl'
                action='editProfile'
                namespace='/profile' /]
       [#if !action.isUserReadOnly(user) && !action.isExternallyManaged()]
            [#assign editProfileLink='<a href="${changePasswordUrl}">Change Password</a> | <a href="${changeProfileUrl}" accesskey="${action.getText(\'global.key.edit\')}">Edit Profile</a>' /]
       [#else]
            [#assign editProfileLink='<a href="${changeProfileUrl}">Edit Profile</a>' /]
       [/#if]

       [@ui.bambooPanel titleKey='Personal Details' tools='${editProfileLink?if_exists}']
            [@ui.bambooSection]
                   [@ww.label labelKey='user.username' name='currentUser.name' /]
                   [@ww.label labelKey='user.fullName' name='currentUser.fullName' /]
                   [@ww.label labelKey='user.email' name='currentUser.email' /]
                   [@ww.label labelKey='user.jabber' name='currentUser.jabberAddress' /]

                   [#if groups?has_content]
                       [#assign groupList='' /]
                       [#list groups as group]
                           [#assign groupList='${groupList} ${group}' /]
                           [#if group_has_next]
                               [#assign groupList='${groupList},' /]
                           [/#if]
                       [/#list]
                       [@ww.label labelKey='user.groups' value='${groupList}'/]
                   [/#if]

                   [#if author?exists]
                       [@ww.label labelKey='Source Repository Alias' name='author.name' /]
                   [/#if]

                    [@ww.label labelKey='ideConnector.port.label' name='idePort' /]

            [/@ui.bambooSection]
       [/@ui.bambooPanel]
</body>