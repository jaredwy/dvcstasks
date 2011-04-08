[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.user.ConfigureUser" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.user.ConfigureUser" --]
<html>
<head>
    <title>Manage Users</title>
    <meta name="decorator" content="adminpage">
</head>

<body>

<h1>[@ww.text name='user.admin.manage.title' /]</h1>
<p>[@ww.text name='user.admin.manage.description' /]</p>

[@ww.actionerror /]

[@ww.action name="browseUsers" executeResult="true" /]


[#if !action.isExternallyManaged()]
    <br/>

    [@ww.action name="addUser" executeResult="true" /]
[/#if]

</body>
</html>