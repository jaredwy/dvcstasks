[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.ConfigurationAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.ConfigurationAction" --]
<html>
<head>
	<title>[@ww.text name='config.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
	<h1>[@ww.text name='config.heading' /]</h1>
	<p>[@ww.text name='config.description' /]</p>

    [@ww.actionmessage /]

    [@ui.clear/]
    [@ww.form action="configure.action"
              id="configurationForm"
              submitLabelKey='global.buttons.update'
              cancelUri='/admin/administer.action'
              showActionMessages='false'
    ]
        [#include "../fragments/systemProperties.ftl"]
    [/@ww.form]
</body>
</html>