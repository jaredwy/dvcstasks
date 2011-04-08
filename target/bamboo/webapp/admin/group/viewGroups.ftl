[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.group.ConfigureGroup" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.group.ConfigureGroup" --]
<html>
<head>
    <title>[@ww.text name='group.admin.manage.title' /]</title>
</head>

<body>

<h1>[@ww.text name='group.admin.manage.heading' /]</h1>
<p>[@ww.text name='group.admin.manage.description' /]</p>

[@ww.action name="browseGroups" namespace="/admin/group" executeResult="true" /]

[#if !action.isExternallyManaged()]

    <br/>

    [@ww.action name="addGroup" executeResult="true" /]

[/#if]




</body>
</html>