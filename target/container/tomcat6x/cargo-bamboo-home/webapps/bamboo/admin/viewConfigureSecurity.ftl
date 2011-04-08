[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.ConfigureSecurity" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.ConfigureSecurity" --]
<html>
<head>
	<title>[@ww.text name='config.security.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
	<h1>[@ww.text name='config.security.heading' /]</h1>
	<p>[@ww.text name='config.security.description' /]</p>
    <div class="paddedClearer" ></div>
    [@ww.form action="configureSecurity.action"
              id="viewConfigurationSecurityForm"
              submitLabelKey='global.buttons.edit'
              titleKey='config.security.form.view.heading'
    ]
        [@ww.checkbox id='enableExternalUserManagement_id' labelKey='config.security.enableExternalUserManagement' descriptionKey='config.security.enableExternalUserManagement.description' name='enableExternalUserManagement' disabled='true'/]
        [@ww.checkbox id='enableSignup_id' labelKey='config.security.enableSignup' descriptionKey='config.security.enableSignup.description' toggle='true' name='enableSignup' disabled='true'/]
        [@ui.bambooSection dependsOn='enableSignup' showOn='true']
            [@ww.checkbox id='enableCaptchaOnSignup_id' labelKey='config.security.enableCaptchaOnSignup' name='enableCaptchaOnSignup' disabled="true"  /]
        [/@ui.bambooSection]
        [@ww.checkbox id='enableViewContactDetails_id' labelKey='config.security.enableViewContactDetails' descriptionKey='config.security.enableViewContactDetails.description' name='enableViewContactDetails' disabled='true'/]
        [@ww.checkbox id='enableRestrictedAdmin_id' labelKey='config.security.enableRestrictedAdmin' descriptionKey='config.security.enableRestrictedAdmin.description' name='enableRestrictedAdmin' disabled='true'/]
        [@ww.checkbox id='enableCaptcha_id' labelKey='config.security.enableCaptcha' toggle='true' name='enableCaptcha' disabled="true"  /]
        [@ui.bambooSection dependsOn='enableCaptcha' showOn='true']
            [@ww.textfield id='loginAttempts_id' cssClass="labelForCheckbox" labelKey='config.security.loginAttempts' name="loginAttempts" disabled="true"/]
        [/@ui.bambooSection]
    [/@ww.form]
</body>
</html>