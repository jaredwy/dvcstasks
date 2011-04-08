[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.monitoring.ConfigureGlobalBuildHangingDetection" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.monitoring.ConfigureGlobalBuildHangingDetection" --]
<html>
<head>
	<title>[@ww.text name='buildMonitoring.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
	<h1>[@ww.text name='buildMonitoring.title' /]</h1>

    [@ww.form
        id='buildHangingDetectionForm'
        action='buildHangingDetection.action'
        cancelUri='${req.contextPath}/buildHangingDetection!read.action'
        submitLabelKey='global.buttons.update'
        titleKey='buildMonitoring.hanging.form.title'
    ]

    <p class="description">
        [@ww.text name='buildMonitoring.hanging.description' /]
    </p>
    [@ww.textfield name='buildHangingConfig.multiplier' labelKey='buildMonitoring.hanging.multiplier'/]
    [@ww.textfield name='buildHangingConfig.minutesBetweenLogs' labelKey='buildMonitoring.hanging.logtime' /]

    <p class="description">
        [@ww.text name='buildMonitoring.queuetimeout.description' /]
    </p>
    [@ww.textfield name='buildHangingConfig.minutesBeforeQueueTimeout' labelKey='buildMonitoring.hanging.queuetimeout' /]    

    [/@ww.form]
</body>
</html>
