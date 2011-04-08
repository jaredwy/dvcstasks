[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.ConfigureConcurrentBuilds" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.ConfigureConcurrentBuilds" --]

<html>
<head>
	<title>[@ww.text name='admin.concurrentBuilds.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
	<h1>[@ww.text name='admin.concurrentBuilds.title' /]</h1>

    <p>[@ww.text name='admin.concurrentBuilds.description' /]</p>
    <p>[@ww.text name='admin.concurrentBuilds.page.description' /]</p>

    [#if concurrencyConfig.enabled]
        [@ww.form action="editConcurrentBuildConfig.action"
              id="editConcurrentConfigForm"
              submitLabelKey='global.buttons.edit'
              titleKey='admin.concurrentBuilds.view.title'
        ]
            [@ui.bambooSection]
                [@ww.text name='admin.concurrentBuilds.number.view']
                    [@ww.param]${numberConcurrentBuilds}[/@ww.param]
                [/@ww.text]
                [@ww.param name='buttons']
                    <input id="disableButton" type="button" class="button"
                            value="[@ww.text name='global.buttons.disable' /]"
                            onclick="location.href='${req.contextPath}/admin/disableConcurrentBuildConfig.action'" />
                [/@ww.param]
            [/@ui.bambooSection]
        [/@ww.form]
    [#else]
        [@ww.form action="editConcurrentBuildConfig.action"
                      id="enableConcurrentConfigForm"
                      submitLabelKey='global.buttons.enable'
                      titleKey='admin.concurrentBuilds.view.title'
        ]
            [@ui.bambooSection]
                [@ww.text name='admin.concurrentBuilds.disabled'/]
            [/@ui.bambooSection]
        [/@ww.form]
    [/#if]

</body>
