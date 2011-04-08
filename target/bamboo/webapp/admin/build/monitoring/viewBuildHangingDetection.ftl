[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.monitoring.ConfigureGlobalBuildHangingDetection" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.monitoring.ConfigureGlobalBuildHangingDetection" --]
<html>
<head>
	<title>[@ww.text name='buildMonitoring.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
	<h1>[@ww.text name='buildMonitoring.title' /]</h1>

	<h3>[@ww.text name='buildMonitoring.hanging.title' /]</h3>
    <div class="paddedClearer" ></div>
    [@ww.text name='buildMonitoring.hanging.description' /]
    <div class="paddedClearer" ></div>

    <h3>[@ww.text name='buildMonitoring.queuetimeout.title' /]</h3>
    <div class="paddedClearer" ></div>
    [@ww.text name='buildMonitoring.queuetimeout.description' /]
    <div class="paddedClearer" ></div>

    [#if buildHangingConfig?exists && !buildHangingConfig.disabled]
        [@ww.form
                action='buildHangingDetection!edit.action'
                titleKey='buildMonitoring.hanging.form.title'
                submitLabelKey='global.buttons.edit'
    ]

            [@ww.param name='buttons']
                <input id="disableButton" type="button"
                                       value="[@ww.text name='global.buttons.disable' /]"
                                       onclick="location.href='${req.contextPath}/admin/buildHangingDetection!delete.action'"
                                    />
            [/@ww.param]

            [@ww.label labelKey='buildMonitoring.hanging.multiplier' value='${buildHangingConfig.multiplier}' /]
            [@ww.label labelKey='buildMonitoring.hanging.logtime' value='${buildHangingConfig.minutesBetweenLogs}'/]
            [@ww.label labelKey='buildMonitoring.hanging.queuetimeout' value='${buildHangingConfig.minutesBeforeQueueTimeout}'/]    
        [/@ww.form]
    [#else]
        [@ww.form
                action='buildHangingDetection!add.action'
                titleKey='buildMonitoring.hanging.form.title'
                submitLabelKey='global.buttons.enable'
        ]
            [@ui.displayText]
                [@ww.text name='buildMonitoring.disabled' /]
            [/@ui.displayText]
        [/@ww.form]
    [/#if]
</body>
</html>
