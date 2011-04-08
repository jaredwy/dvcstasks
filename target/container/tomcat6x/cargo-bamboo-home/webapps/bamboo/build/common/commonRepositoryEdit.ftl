[#macro commonRepositoryEdit plan=plan changeDetection=false]
[@ui.bambooSection titleKey='repository.common.title']
    [@ww.checkbox labelKey='repository.common.cleanCheckout' name='repository.common.cleanCheckout' /]
    [@ww.checkbox labelKey='repository.common.cleanWorkingDirectory' name='repository.common.cleanWorkingDirectory' /]

    [#if plan.type != 'JOB']
        [@ui.bambooSection dependsOn='selectedRepository' showOn='__com.atlassian.bamboo.plugin.system.repository:cvs __com.atlassian.bamboo.plugin.system.repository:nullRepository']
            [@ww.checkbox labelKey='repository.common.quietPeriod.enabled' toggle='true' name='repository.common.quietPeriod.enabled' /]
            [@ui.bambooSection dependsOn='repository.common.quietPeriod.enabled' showOn='true' ]
                [@ww.textfield labelKey='repository.common.quietPeriod.period' name='repository.common.quietPeriod.period' required='true' /]
                [@ww.textfield labelKey='repository.common.quietPeriod.maxRetries' name='repository.common.quietPeriod.maxRetries' required='true' /]
            [/@ui.bambooSection]
        [/@ui.bambooSection]

        [@ui.bambooSection dependsOn='selectedRepository' showOn='__com.atlassian.bamboo.plugin.system.repository:nullRepository']
            [@ww.select labelKey='filter.pattern.option' name='filter.pattern.option' toggle='true'
                list=uiConfigBean.filterOptions listKey='name' listValue='label' uiSwitch='value']
            [/@ww.select]

            [@ui.bambooSection dependsOn='filter.pattern.option' showOn='regex']
                [@ww.textfield labelKey='filter.pattern.regex' name='filter.pattern.regex' /]
            [/@ui.bambooSection]
        [/@ui.bambooSection]
    [/#if]

    [@ui.bambooSection dependsOn='selectedRepository' showOn='__com.atlassian.bamboo.plugin.system.repository:nullRepository']
        [@ww.select id="selectedWebRepositoryViewer" labelKey='webRepositoryViewer.type' name='selectedWebRepositoryViewer' toggle='true'
 	 	     	 	 	list='uiConfigBean.webRepositoryViewers' listKey='key' listValue='name']
        [/@ww.select]
        [#list uiConfigBean.webRepositoryViewers as viewer]
            [#if viewer.getEditHtml(buildConfiguration, build)!?has_content]
                [@ui.bambooSection dependsOn='selectedWebRepositoryViewer' showOn='${viewer.key}']
                    ${viewer.getEditHtml(buildConfiguration, build)!}
                [/@ui.bambooSection]
            [/#if]
        [/#list]
    [/@ui.bambooSection]

    <script type="text/javascript">
            AJS.$(function(){
                AJS.$('#selectedRepository').change(function updateWebRepositoryFilter() {
                    mutateSelectListContent(AJS.$(this), AJS.$('#selectedWebRepositoryViewer'), AJS.$.parseJSON('${uiConfigBean.webRepositoryJson}'));
                }).change();
            });
    </script>
[/@ui.bambooSection]
[/#macro]