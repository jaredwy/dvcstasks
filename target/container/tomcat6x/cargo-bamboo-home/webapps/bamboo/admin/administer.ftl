[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.AdministerAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.AdministerAction" --]


<html>
<head>
	<title>[@ww.text name='admin.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
	<h1>[@ww.text name='admin.heading' /]</h1>

    <p>[@ww.text name='admin.description' /]</p>

    <ul>
        <li>
            [@ww.url id='configureUrl' action='configure!default' namespace='/admin' /]
            <a href='${configureUrl}'>Change information</a> you supplied when Bamboo was installed.
        </li>
        <li>
            [@ww.url id='agentsUrl' action='configureAgents!default' namespace='/admin/agent' /]
            <a href='${agentsUrl}'>Manage your agents</a> and their capabilities.
        </li>
        <li>
            [@ww.url id='jdkUrl' action='viewJdks!default' namespace='/admin/agent' /]
            [@ww.url id='builderUrl' action='viewBuilders!default' namespace='/admin/agent' /]
            [#if fn.hasGlobalAdminPermission()]
            Select the <a href='${jdkUrl}'>JDKs</a> and different <a href='${builderUrl}'>builders</a> (such as Ant, Maven, Maven 2 or scripts) you would like to use.
            [/#if]
        </li>
        <li>
            [@ww.url id='buildExpiryUrl' action='buildExpiry!read' namespace='/admin' /]
            [@ww.url id='deleteBuildUrl' action='deleteBuilds' namespace='/admin' /]
            [@ww.url id='permissionsUrl' action='chooseBuildsToBulkEditPermissions' namespace='/admin' /]
            <a href='${buildExpiryUrl}'>Set build expiry</a>, <a href='${deleteBuildUrl}'>delete plans</a> or <a href='${permissionsUrl}'>edit plan permissions</a>.
        </li>


        
     </ul>
</body>
</html>