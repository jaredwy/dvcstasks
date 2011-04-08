[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.expiry.BuildExpiryAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.expiry.BuildExpiryAction" --]
<html>
<head>
	<title>[@ww.text name='buildExpiry.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
	<h1>[@ww.text name='buildExpiry.heading' /]</h1>

    <p class="description">
        [@ww.text name="buildExpiry.description"/]
    </p>
    [@ww.form
        id='buildExpiryForm'
        action='buildExpiry.action'
        cancelUri='${req.contextPath}/buildExpiry!read.action'
        submitLabelKey='global.buttons.update'
        titleKey='buildExpiry.form.title'
        descriptionKey='buildExpiry.cronSection.description'
    ]

        [@ww.textfield name='custom.buildExpiryConfig.cronExpression' labelKey='buildExpiry.cronExpression' required="true" /]


        [@ui.bambooSection titleKey="buildExpiry.defaultConfigSection.title" descriptionKey="buildExpiry.defaultConfigSection.description"]
            [@ww.checkbox name='custom.buildExpiryConfig.disabled' labelKey="buildExpiry.global.enabled" toggle="true" /]
            [@ui.clear/]
            [@ui.bambooSection dependsOn='custom.buildExpiryConfig.disabled' showOn='false']
                [#include "/admin/build/editBuildExpiryForm.ftl" /]
            [/@ui.bambooSection]
        [/@ui.bambooSection]
    [/@ww.form]
</body>
</html>
