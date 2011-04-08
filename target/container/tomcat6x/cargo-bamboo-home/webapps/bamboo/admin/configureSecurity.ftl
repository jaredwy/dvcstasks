[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.ConfigureSecurity" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.ConfigureSecurity" --]
<html>
<head>
	<title>[@ww.text name='config.security.title' /]</title>
</head>
<body>
	<h1>[@ww.text name='config.security.heading' /]</h1>
	<p>[@ww.text name='config.security.description' /]</p>
    [@ww.form action="configureSecurity!execute.action"
              id="configurationSecurityForm"
              submitLabelKey='global.buttons.update'
              cancelUri='/admin/viewSecurity.action'
              titleKey='config.security.form.edit.heading'
    ]
        [@ww.checkbox id='enableExternalUserManagement_id' labelKey='config.security.enableExternalUserManagement' descriptionKey='config.security.enableExternalUserManagement.description' name='enableExternalUserManagement'/]
        [@ww.checkbox id='enableSignup_id' labelKey='config.security.enableSignup' toggle='true' name='enableSignup'/]
        [@ui.bambooSection dependsOn='enableSignup' showOn='true']
            [@ww.checkbox id='enableCaptchaOnSignup_id' labelKey='config.security.enableCaptchaOnSignup' name='enableCaptchaOnSignup'/]
        [/@ui.bambooSection]
        [@ww.checkbox id='enableViewContactDetails_id' labelKey='config.security.enableViewContactDetails' descriptionKey='config.security.enableViewContactDetails.description' name='enableViewContactDetails'/]
        [@ww.checkbox id='enableRestrictedAdmin_id' labelKey='config.security.enableRestrictedAdmin' descriptionKey='config.security.enableRestrictedAdmin.description' name='enableRestrictedAdmin'/]
        [@ww.checkbox id='enableCaptcha_id' labelKey='config.security.enableCaptcha' toggle='true' name='enableCaptcha'/]
        [@ui.bambooSection dependsOn='enableCaptcha' showOn='true']
            [@ww.textfield id='loginAttempts_id' labelKey='config.security.loginAttempts' name="loginAttempts" required="true"/]
        [/@ui.bambooSection]
    [/@ww.form]
</body>
</html>