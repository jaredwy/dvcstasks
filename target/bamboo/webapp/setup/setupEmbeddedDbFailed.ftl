[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.setup.SetupEmbeddedDatabaseAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.setup.SetupEmbeddedDatabaseAction" --]
<html>
	<head>
		<title>[@ww.text name='setup.database.embedded.title' /]</title>
	</head>

	<body>
		<p>[@ww.text name='setup.database.embedded.error.failure' /]</p>

        [#import "setupCommon.ftl" as sc/]
        [@sc.setupActionErrors/]
    </body>
</html>