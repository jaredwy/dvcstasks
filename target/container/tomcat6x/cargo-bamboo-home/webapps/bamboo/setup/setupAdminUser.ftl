[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.setup.SetupAdminUserAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.setup.SetupAdminUserAction" --]
<html>
	<head>
		<title>[@ww.text name='setup.user.admin.title' /]</title>
	</head>

	<body>
        <h1>[@ww.text name='setup.user.admin.heading' /]</h1>

        <p>[@ww.text name='setup.user.admin.description' /]</p>
        [@ww.actionerror /]

        [@ww.form action="performSetupAdminUser" method="post" submitLabelKey='global.buttons.finish' titleKey='setup.user.admin.form.title']
            [@ww.textfield labelKey='user.username' descriptionKey='user.username.description' name="username" required="true" value="${((systemInfo.userName)?lower_case)!'${username!}'}" /]
            [@ww.password labelKey='user.password' name="password" showPassword="true" required="true" /]
            [@ww.password labelKey='user.password.confirm' name="confirmPassword" showPassword="true" required="true" /]
            [@ww.textfield labelKey='user.fullName' name="fullName" required="true" /]
            [@ww.textfield labelKey='user.email' name="email" required="true" /]
        [/@ww.form]

	</body>
</html>