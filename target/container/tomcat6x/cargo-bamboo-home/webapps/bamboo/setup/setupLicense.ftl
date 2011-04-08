[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.setup.SetupLicenseAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.setup.SetupLicenseAction" --]
<html>
<head>
    <title>[@ww.text name='setup.install.standard.title' /]</title>
</head>

<body>

<h1>[@ww.text name='setup.install.standard.heading' /]</h1>

<p>[@ww.text name='setup.welcome' /]</p>

[#assign licenseDescription]
    [@ww.text name='license.description' ]
        [@ww.param][@ww.text name='license.contact.company' /][/@ww.param]
    [/@ww.text]
[/#assign]
[@ww.form action="validateLicense"]
    [@ww.hidden name='sid' /]

    [@ui.bambooSection  titleKey='setup.install.license.section']
        [@ww.label labelKey='setup.install.sid' name='sid' /]
        [@ww.textarea labelKey='license' name="licenseString" required="true" rows="8" cssClass="license-field"]
            [@ww.param name='description']
                [@ww.text name='license.description']
                    [@ww.param]${version}[/@ww.param]
                    [@ww.param]${sid}[/@ww.param]
                [/@ww.text]
            [/@ww.param]
        [/@ww.textarea]
    [/@ui.bambooSection]
    [@ui.bambooSection titleKey="setup.install.setupType.section"]
            [@ww.submit value=action.getText('setup.install.express') name="expressInstall" theme='simple' id="expressInstall"/]
            <div class="installationDescription">
                <strong>[@ww.text name='setup.install.setupType.express' /]</strong><br />
                [@ww.text name='setup.install.setupType.express.description' /]
            </div>
            [@ww.submit value=action.getText('setup.install.custom') name="customInstall" theme='simple' id="customInstall"/]
            <div class="installationDescription">
                <strong>[@ww.text name='setup.install.setupType.custom' /]</strong><br />
                [@ww.text name='setup.install.setupType.custom.description' /]
            </div>
    [/@ui.bambooSection]
[/@ww.form]

</body>
</html>
