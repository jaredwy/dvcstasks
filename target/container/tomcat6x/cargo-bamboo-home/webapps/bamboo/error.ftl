[#-- @ftlvariable name="action" type="com.atlassian.bamboo.logger.AdminErrorAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.logger.AdminErrorAction" --]

<html>
<head>
	<title>[@ww.text name='error.title' /]</title>
    <meta name="decorator" content="errorDecorator"/>
</head>

<body>
	<h1>[@ww.text name='error.heading' /]</h1>

    [#if formattedErrorMessages?has_content]
        [@ui.messageBox type='error']
            [#list formattedErrorMessages as error]
                <p>${error}</p>
            [/#list]
        [/@ui.messageBox]
    [/#if]
</body>
</html>