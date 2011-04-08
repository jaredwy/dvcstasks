[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.ConfigureDatabaseAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.ConfigureDatabaseAction" --]
<html>
<head>
	<title>[@ww.text name='config.database.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
	<h1>[@ww.text name='config.database.title' /]</h1>

    [@ui.bambooPanel titleKey='config.database.subTitle']
    [@ui.bambooSection ]
        [@ww.label labelKey='config.database.driverName' name='databaseDriver' /]
        [@ww.label labelKey='config.database.databaseUrl' name='databaseUrl' /]
        [@ww.label labelKey='config.database.username' name='userName' /]
        [@ww.label labelKey='config.database.dialect' name='dialect' /]
    [/@ui.bambooSection ]
    [/@ui.bambooPanel]
</body>
</html>