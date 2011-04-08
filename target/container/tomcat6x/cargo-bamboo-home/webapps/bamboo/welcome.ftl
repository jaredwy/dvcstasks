[#-- @ftlvariable name="action" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.webwork.StarterAction" --]

<html>
<head>
    <title>[@ww.text name='dashboard.title' /]</title>
</head>
<body>
<div id="welcome-content">
    <h1>${instanceName?html}</h1>
    [#include "/fragments/startupWelcome.ftl"]
</div>
</body>
</html>
