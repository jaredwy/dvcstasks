[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticCloudAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticCloudAction" --]

[#import "/admin/elastic/commonElasticFunctions.ftl" as ela]

<html>
<head>
	<title>[@ww.text name='elastic.configure.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
	<h1>[@ww.text name='elastic.configure.title' /]</h1>

    <p>
        <img src="${req.contextPath}/images/jt/icn32_elastic_cloud.gif" style="float: left; margin-right: 5px" width="32" height="32" />[@ww.text name='elastic.configure.blurb' /]
    </p>
    
    <p>[@ww.text name='elastic.configure.view.description' /]</p>

    [#if actionErrors?has_content]
        [@ww.actionerror /]
    [#else]
        [#if elasticConfig?? && elasticConfig.enabled]
            [#if showHint]
                 [@ui.messageBox type="success" titleKey='elastic.configure.hint.first']
                     <p>[@ww.text name='elastic.configure.hint']
                        [@ww.param]${req.contextPath}/admin/elastic/manageElasticInstances.action[/@ww.param]
                        [@ww.param]${req.contextPath}/admin/elastic/prepareElasticInstances.action[/@ww.param]
                     [/@ww.text]</p>
                 [/@ui.messageBox]
            [/#if]
            [@ww.form
                action='editElasticConfig.action'
                titleKey='elastic.configure.form.title'
                submitLabelKey='global.buttons.edit'
                showActionErrors='false'
            ]
                [@ww.param name='buttons']
                    <input id="disableButton" type="button"
                                           value="[@ww.text name='global.buttons.disable' /]"
                                           onclick="location.href='${req.contextPath}/admin/elastic/confirmDisableElasticConfig.action'"
                                        />
                [/@ww.param]
                [@ww.label labelKey='elastic.configure.field.awsAccessKeyId' value='${elasticConfig.awsAccessKeyId}' /]

                [@ui.bambooSection titleKey="elastic.configure.server.title"]
                    [@ww.label labelKey='elastic.configure.field.maxConcurrentInstances' value='${elasticConfig.maxConcurrentInstances}' /]
                    
                    [#if elasticConfig.autoShutdownEnabled]
                        [@ww.text name='elastic.configure.view.autoShutdown' id='autoShutdownMessage']
                            [@ww.param]${elasticConfig.autoShutdownDelay}[/@ww.param]
                        [/@ww.text]
                        [@ww.label labelKey='elastic.configure.field.autoShutdown' value='${autoShutdownMessage}' /]
                    [#else]
                        [@ww.label labelKey='elastic.configure.field.autoShutdown' escape='false']
                            [@ww.param name="value"][@ww.text name='elastic.configure.view.autoShutdown.disabled'/][/@ww.param]
                        [/@ww.label]
                    [/#if]
                [/@ui.bambooSection]

                [#assign elasticConfigureInstanceDescription]
                    [#if elasticConfig.uploadingOfAwsAccountDetailsEnabled]
                        [@ww.text name='elastic.configure.view.upload']
                            [@ww.param]${elasticConfig.awsPrivateKeyFile}[/@ww.param]
                            [@ww.param]${elasticConfig.awsCertFile}[/@ww.param]
                        [/@ww.text]
                    [#else]
                        [@ww.text name='elastic.configure.view.upload.disabled' /]
                    [/#if]
                [/#assign]
            
                [@ui.bambooSection title="Spot instances configuration" ]
                    [#if elasticConfig.spotInstanceConfig.enabled]
                        [@ww.text name='core.dateutils.minute.any' id="fieldSpotInstancesTimeoutMinutesDurationName"]
                            [@ww.param value=fieldSpotInstancesTimeoutMinutes/]
                        [/@ww.text]
                        [@ww.label labelKey='Fallback to a regular instance after' value='${fieldSpotInstancesTimeoutMinutes} ${fieldSpotInstancesTimeoutMinutesDurationName}' /]
                        <h4>[@ww.text name='Your current bid levels' /]</h4>
                        [@ela.displaySpotPrices editMode=false confElasticCloudAction=action/]
                    [#else]
                        [@ww.text name='Spot instances configuration disabled'/]
                    [/#if]
                [/@ui.bambooSection]
            
                [@ui.bambooSection titleKey="elastic.configure.instance.title" description=elasticConfigureInstanceDescription /]

                [#assign elasticConfigureAutomaticInstanceManagementDescription]
                    [#if elasticConfig.automaticInstanceManagementConfig.automaticInstanceManagementEnabled]
                        [@ww.text name='elastic.configure.field.automaticInstanceManagement.params']
                            [@ww.param value=fieldInstanceIdleTimeThreshold /]
                            [@ww.param value=fieldMaxElasticInstancesToStartAtOnce /]
                            [@ww.param value=fieldTotalBuildInQueueThreshold /]
                            [@ww.param value=fieldElasticBuildsInQueueThreshold /]
                            [@ww.param value=fieldAverageTimeInQueueThreshold /]
                        [/@ww.text]
                    [#else]
                        [@ww.text name='elastic.configure.view.automaticInstanceManagement.disabled'/]
                    [/#if]
                [/#assign]
                [@ui.bambooSection titleKey="elastic.configure.automatic.instance.management.title" description=elasticConfigureAutomaticInstanceManagementDescription /]
            [/@ww.form]
        [#else]
            [@ww.form
                 action='enableElasticConfig.action'
                 titleKey='elastic.configure.form.title'
                 submitLabelKey='global.buttons.enable'
                 showActionErrors='false'

            ]
                [@ui.displayText]
                    [#if elasticConfig??]
                        [@ww.text name='elastic.configure.disabled' /]
                    [#else]
                        [@ww.text name='elastic.configure.nonexistent' /]
                    [/#if]
                [/@ui.displayText]
            [/@ww.form]
         [/#if]
    [/#if]
</body>
</html>
