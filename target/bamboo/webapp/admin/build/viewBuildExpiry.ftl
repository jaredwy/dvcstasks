[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.expiry.BuildExpiryAction" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.expiry.BuildExpiryAction" --]
[#assign nextFireTimeText ]
        [#if action.trigger?has_content]
            [#assign nextFireTime = (action.trigger.nextFireTime)! /]
            [#if nextFireTime?has_content]
                ${(nextFireTime?datetime)}
                <span class="small grey">(in ${durationUtils.getRelativeToDate(nextFireTime.time)})</span>
            [#else]
                [@ww.text name='elastic.schedule.noFireTime' /]
            [/#if]

        [#else]
            [@ww.text name='elastic.schedule.noFireTime' /]

        [/#if]
[/#assign]
<html>
<head>
	<title>[@ww.text name='buildExpiry.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
	<h1>[@ww.text name='buildExpiry.heading' /]</h1>

    <div class="paddedClearer" ></div>
    [@ww.text name='buildExpiry.description' /]
    <div class="paddedClearer" ></div>

    [#if buildExpiryConfig?exists]
        [@ww.form
                action='buildExpiry!edit.action'
                titleKey='buildExpiry.form.title'
                submitLabelKey='global.buttons.edit'
        ]
            [@ww.param name='buttons']
                 <input id="runButton" type="button"
                                   value="[@ww.text name='global.buttons.run' /]"
                                   onclick="location.href='${req.contextPath}/admin/runBuildExpiry.action'"
                                />
            [/@ww.param]


            [#if buildExpiryConfig.cronExpression?has_content]
                [@ww.label labelKey='buildExpiry.cronExpression' value='${action.getPrettyCronExpression(buildExpiryConfig.cronExpression)!}' /]
                [@ww.label labelKey='buildExpiry.nextFireTime' value='${nextFireTimeText!}' escape="false"/]
            [/#if]


            [@ui.bambooSection titleKey="buildExpiry.defaultConfigSection.title"]
            [#if buildExpiryConfig.disabled]
                [@ui.displayText]
                    [@ww.text name='buildExpiry.disabled' /]
                [/@ui.displayText]
            [#else]
                [#include "/admin/build/viewBuildExpiryFragment.ftl" /]
            [/#if]
            [/@ui.bambooSection]

        [/@ww.form]
    [#else]
        [@ww.form
                action='buildExpiry!add.action'
                titleKey='buildExpiry.form.title'
                submitLabelKey='global.buttons.enable'
        ]
                [@ww.param name='buttons']
                <input id="runButton2" type="button"
                                   value="[@ww.text name='global.buttons.run' /]"
                                   onclick="location.href='${req.contextPath}/admin/runBuildExpiry.action'"
                                />
            [/@ww.param]

                [@ww.label labelKey='buildExpiry.cronExpression' value='${action.getPrettyCronExpression(defaultCronExpression)!}' /]
                [@ww.label labelKey='buildExpiry.nextFireTime' value='${nextFireTimeText!}' escape="false"/]
                [@ui.bambooSection titleKey="buildExpiry.defaultConfigSection.title"]
                [@ui.displayText]
                    [@ww.text name='buildExpiry.notEnabled' /]
                [/@ui.displayText]
                [/@ui.bambooSection]
        [/@ww.form]
    [/#if]
</body>
</html>
