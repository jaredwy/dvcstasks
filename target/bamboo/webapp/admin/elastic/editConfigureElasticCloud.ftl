[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticCloudAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticCloudAction" --]
[#import "/admin/elastic/commonElasticFunctions.ftl" as ela]

[#if elasticConfig??]
    [#assign editMode = true /]
[#else]
    [#assign editMode = false /]
[/#if]
<html>
<head>
	<title>[@ww.text name='elastic.configure.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
	<h1>[@ww.text name='elastic.configure.title' /]</h1>
    <p>[@ww.text name='elastic.configure.edit.description' /]</p>
    [@ww.form
        method="post" enctype="multipart/form-data"
        id='saveElasticConfigForm'
        action='saveElasticConfig.action'
        cancelUri='/admin/elastic/viewElasticConfig.action'
        submitLabelKey='global.buttons.update'
        titleKey='elastic.configure.form.title'
    ]

    [@ww.textfield labelKey='elastic.configure.field.awsAccessKeyId' name='fieldAwsAccessKeyId' required="true"  /]
    [#if editMode && elasticConfig.awsAccessKeyId?has_content]
        [@ww.checkbox labelKey='elastic.configure.field.awsSecretAccessKey.change' toggle='true' id='awsSecretAccessKeyChange' name='awsSecretAccessKeyChange' /]
        [@ui.bambooSection dependsOn='awsSecretAccessKeyChange' showOn='true']
            [@ww.password labelKey='elastic.configure.field.awsSecretAccessKey' name="fieldAwsSecretAccessKey" showPassword="true" required="true" cssClass="long-field"/]
        [/@ui.bambooSection]
    [#else]
        [@ww.hidden name='awsSecretAccessKeyChange' value='true' /]
        [@ww.password labelKey='elastic.configure.field.awsSecretAccessKey' name="fieldAwsSecretAccessKey" showPassword="true" required="true" cssClass="long-field"/]
    [/#if]

    [@ui.bambooSection titleKey="elastic.configure.server.title"]
        [@ww.textfield labelKey='elastic.configure.field.maxConcurrentInstances' name='fieldMaxConcurrentInstances' required="true" cssClass="short-field" /]
        [@ww.checkbox name='fieldAutoShutdownEnabled' labelKey='elastic.configure.field.autoShutdownEnabled' toggle='true' /]
        [@ui.bambooSection dependsOn='fieldAutoShutdownEnabled' showOn=true]
            [@ww.textfield name='fieldAutoShutdownDelay' labelKey='elastic.configure.field.autoShutdownDelay' required=true cssClass="short-field" /]
        [/@ui.bambooSection]
    [/@ui.bambooSection]

    [@ui.bambooSection title="Spot instances configuration" ]
        [@ww.checkbox name='fieldSpotInstancesEnabled' labelKey='Spot instances enabled' toggle='true' /]
        [@ui.bambooSection dependsOn='fieldSpotInstancesEnabled' showOn=true ]
            [@ww.textfield name="fieldSpotInstancesTimeoutMinutes" labelKey='Fallback to a regular instance after' description='Time (in minutes) after which a spot instance request will be replaced with a regular instance' /]
            <h4>[@ww.text name='Your current bid levels' /]</h4>
            [@ela.displaySpotPrices editMode=true confElasticCloudAction=action/]
        [/@ui.bambooSection]
    [/@ui.bambooSection]

    [@ui.bambooSection titleKey="elastic.configure.instance.title" ]
        [@ww.checkbox name='fieldUploadingOfAwsAccountDetailsEnabled' labelKey='elastic.configure.field.uploadingOfAwsAccountDetailsEnabled' toggle='true' /]
        [@ui.bambooSection dependsOn='fieldUploadingOfAwsAccountDetailsEnabled' showOn=true ]

            [@ww.select labelKey='elastic.configure.key.provide.method' name='elasticConfigureKeysMethod' list=keyProvideMethods listKey='key' listValue='displayName' toggle='true' /]

            [@ui.bambooSection dependsOn='elasticConfigureKeysMethod' showOn='BAMBOO_SERVER_LOCATION']
                [@ww.textfield name='fieldAwsPrivateKeyFile' labelKey='elastic.configure.field.awsPrivateKeyFile' required=true cssClass="long-field" /]
                [@ww.textfield name='fieldAwsCertFile' labelKey='elastic.configure.field.awsCertFile'  required=true cssClass="long-field" /]
            [/@ui.bambooSection]

            [@ui.bambooSection dependsOn='elasticConfigureKeysMethod' showOn='UPLOAD']
                [@ww.file labelKey='elastic.configure.field.awsPrivateKeyFile.upload' required=true name='fieldAwsPrivateKeyFileUpload' /]
                [@ww.file labelKey='elastic.configure.field.awsCertFile.upload' required=true name='fieldAwsCertFileUpload' /]
            [/@ui.bambooSection]

        [/@ui.bambooSection]
    [/@ui.bambooSection]
    
    [@ui.bambooSection titleKey="elastic.configure.automatic.instance.management.title"]
        [@ww.select labelKey='elastic.configure.field.automaticInstanceManagement.config'
            name='automaticInstanceManagementPreset'
            id='automaticInstanceManagementPreset'
            list=automaticInstanceManagementPresets
            listKey='key'
            groupBy='value.group'
            listValue='value.name'
            value="automaticInstanceManagementPreset"]
        [/@ww.select]
        [@ui.bambooSection id='autoConfigManagementValues']
            [@ww.textfield name='fieldInstanceIdleTimeThreshold' id='fieldInstanceIdleTimeThreshold'
                labelKey='elastic.configure.field.automaticInstanceManagement.instance.idle.time.threshold' required=true cssClass="short-field" /]
            [@ww.textfield name='fieldMaxElasticInstancesToStartAtOnce' id='fieldMaxElasticInstancesToStartAtOnce'
                labelKey='elastic.configure.field.automaticInstanceManagement.max.instances.to.start.at.once' required=true cssClass="short-field" /]
            [@ww.textfield name='fieldTotalBuildInQueueThreshold' id='fieldTotalBuildInQueueThreshold'
                labelKey='elastic.configure.field.automaticInstanceManagement.total.builds.in.queue.threshold' required=true cssClass="short-field" /]
            [@ww.textfield name='fieldElasticBuildsInQueueThreshold' id='fieldElasticBuildsInQueueThreshold'
                labelKey='elastic.configure.field.automaticInstanceManagement.elastic.builds.in.queue.threshold' required=true cssClass="short-field" /]
            [@ww.textfield name='fieldAverageTimeInQueueThreshold' id='fieldAverageTimeInQueueThreshold'
                labelKey='elastic.configure.field.automaticInstanceManagement.average.time.in.queue.threshold' required=true cssClass="short-field" /]
        [/@ui.bambooSection]
    [/@ui.bambooSection]
    
    [/@ww.form]
   
    <script type="text/javascript">
        AJS.$(function(){
            var $select = AJS.$("#automaticInstanceManagementPreset"),
                $values = AJS.$("#autoConfigManagementValues"),
                $fieldInstanceIdleTimeThreshold = AJS.$("#fieldInstanceIdleTimeThreshold"),
                $fieldMaxElasticInstancesToStartAtOnce = AJS.$("#fieldMaxElasticInstancesToStartAtOnce"),
                $fieldTotalBuildInQueueThreshold = AJS.$("#fieldTotalBuildInQueueThreshold"),
                $fieldElasticBuildsInQueueThreshold = AJS.$("#fieldElasticBuildsInQueueThreshold"),
                $fieldAverageTimeInQueueThreshold = AJS.$("#fieldAverageTimeInQueueThreshold"),
                $description = AJS.$("#automaticInstanceManagementPresetDesc"),
                $inputs = $values.find("input:text");
            [#list automaticInstanceManagementPresetList as preset]
                 $select.find("option[value='${preset.name}']").data("description", "${preset.explanation}").data("values", ${preset.jsArrayValues});
            [/#list]
            $select.change(function(){
                var $selectedOption = $select.find("option:selected");
                $description.text($selectedOption.data("description"));
                if ($select.val() != "Disabled") {
                    if ($select.val() == "Custom") {
                        $inputs.removeAttr("disabled");
                    } else {
                        var params = $selectedOption.data("values");
                        $fieldInstanceIdleTimeThreshold.val(params[0]);
                        $fieldMaxElasticInstancesToStartAtOnce.val(params[1]);
                        $fieldTotalBuildInQueueThreshold.val(params[2]);
                        $fieldElasticBuildsInQueueThreshold.val(params[3]);
                        $fieldAverageTimeInQueueThreshold.val(params[4]);
                        $inputs.attr("disabled", "disabled");
                    }
                    $values.show();
                } else {
                    $values.hide();
                }
            });
            $select.change();
        });
    </script>
</body>
</html>