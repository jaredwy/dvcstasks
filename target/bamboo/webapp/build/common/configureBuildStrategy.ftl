[#macro configureBuildStrategy selectedRepository long=false]

    [#assign vcsUsed = true/]
    [#if selectedRepository='com.atlassian.bamboo.plugin.system.repository:nullRepository']
        [#assign vcsUsed = false/]
    [/#if]

    [@ww.select labelKey='repository.change' name='selectedBuildStrategy' id='selectedBuildStrategy'
                listKey='key' listValue='description' toggle='true'
                list=uiConfigBean.getBuildStrategies(vcsUsed) required='true' helpKey='build.strategy' /]

    [@ui.bambooSection dependsOn='selectedBuildStrategy' showOn='poll']
        [@ww.radio labelKey='config.repository.polling.strategy' name='repository.change.poll.type' listKey='first' listValue='second' toggle='true' list=uiConfigBean.pollingTypes /]
        [@ui.bambooSection dependsOn="repository.change.poll.type" showOn="PERIOD"]
            [@ww.textfield labelKey='repository.change.poll.frequency' name='repository.change.poll.pollingPeriod' /]
        [/@ui.bambooSection]
        [@ui.bambooSection dependsOn="repository.change.poll.type" showOn="CRON"]
            [@dj.cronBuilder idPrefix="pt" name='repository.change.poll.cronExpression'/]
        [/@ui.bambooSection]
    [/@ui.bambooSection]

    [@ui.bambooSection dependsOn='selectedBuildStrategy' showOn='trigger']
        [@ww.textfield labelKey='repository.change.trigger.ip' name='repository.change.trigger.triggerIpAddress' /]
    [/@ui.bambooSection]

    [@ui.bambooSection dependsOn='selectedBuildStrategy' showOn='daily']
        [@ww.textfield labelKey='repository.change.daily.buildTime' name='repository.change.daily.buildTime' /]
    [/@ui.bambooSection]

    [@ui.bambooSection dependsOn='selectedBuildStrategy' showOn='schedule']
        [@dj.cronBuilder idPrefix="ct" name='repository.change.schedule.cronExpression' helpKey='build.strategy.cron'/]
    [/@ui.bambooSection]

    [#if long]
        [#assign condtionHtml = triggerConditionEditHtml /]
        [#if condtionHtml?has_content]
            [@ui.bambooSection titleKey='repository.change.conditions']
                ${condtionHtml}
            [/@ui.bambooSection]
        [/#if]
    [/#if]

[#assign optionListNoVcs]
    [@strategyOptionList false/]
[/#assign]

[#assign optionListVcs]
    [@strategyOptionList true/]
[/#assign]

<script type="text/javascript">
    AJS.$(function() {
              var strategyList = AJS.$('#selectedBuildStrategy'),
              optionListNoVcs = '${optionListNoVcs?js_string}';
              optionListVcs = '${optionListVcs?js_string}';
              AJS.$('#selectedRepository').change(
                function() {
                    var value = strategyList.val();
                    strategyList.attr('disabled', 'disabled');
                    if (AJS.$(this).val() == 'com.atlassian.bamboo.plugin.system.repository:nullRepository') {
                        strategyList.html(optionListNoVcs);
                    } else {
                        strategyList.html(optionListVcs);
                    }
                    strategyList.removeAttr('disabled').val(value).change();
                }).change();
          });
</script>
[/#macro]

[#macro strategyOptionList withVcs]
[#list uiConfigBean.getBuildStrategies(withVcs) as option]
    <option value="${option.key}">${option.description}</option>[#t]
[/#list]
[/#macro]
