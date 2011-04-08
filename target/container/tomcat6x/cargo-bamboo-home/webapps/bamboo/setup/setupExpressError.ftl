[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.setup.SetupDefaultsAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.setup.SetupDefaultsAction" --]
<html>
<head>
    <title>[@ww.text name='setup.install.standard.title' /]</title>
</head>

<body>

<h1>[@ww.text name='setup.install.standard.heading' /]</h1>

<p>[@ww.text name='setup.welcome' /]</p>

[@ww.form action="${failedAction}" submitLabelKey='setup.install.express.retry' titleKey='setup.install.express.error' descriptionKey="setup.install.express.error.description" cancelUri="/setup/${customAction}.action" cancelSubmitKey="setup.install.express.switch"]
[/@ww.form]

</body>
</html>
