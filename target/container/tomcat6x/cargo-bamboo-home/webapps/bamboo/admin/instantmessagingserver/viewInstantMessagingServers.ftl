<html>
<head>
    <title>[@ww.text name='instantMessagingServer.admin.manage.title' /]</title>
</head>

<body>

<h1>[@ww.text name='instantMessagingServer.admin.manage.heading' /]</h1>
<p>[@ww.text name='instantMessagingServer.admin.manage.description' /]</p>
[#if instantMessagingServers?has_content]
<table id="existingInstantMessagingServers" class="aui">
    <thead>
        <tr>
            <th>IM Server</th>
            <th>Host</th>
            <th>Operations</th>
        </tr>
    </thead>
    [#foreach instantMessagingServer in instantMessagingServers]
    <tr [#if affectedInstantMessagingServerId?exists && affectedInstantMessagingServerId==instantMessagingServer.id] class="selectedRow"[/#if]>
        <td>
            ${instantMessagingServer.name?html}
        </td>
        <td>
            ${instantMessagingServer.host}[#if instantMessagingServer.resource?has_content]/${instantMessagingServer.resource}[/#if]
        </td>
    <td class="operations">
            <a id="editInstantMessagingServer-${instantMessagingServer.id}" href="[@ww.url action='editInstantMessagingServer' instantMessagingServerId=instantMessagingServer.id /]">
                [@ww.text name='global.buttons.edit'/]
            </a>
             <a id="deleteGroup-${instantMessagingServer.id}" href="[@ww.url action='deleteInstantMessagingServer' instantMessagingServerId=instantMessagingServer.id /]">
                [@ww.text name='global.buttons.delete'/]
            </a>
        </td>
    </tr>
    [/#foreach]

</table>

[#else]
[@ww.text name='instantMessagingServer.admin.manage.none' /]
[/#if]

[@ww.action name="addInstantMessagingServer" executeResult="true" /]

</body>
</html>