
[#macro displayRepository repository plan condensed=false]
    [#if repository??]
        [#if plan.buildDefinition.inheritRepository && plan.parent??]
            <div class="infoMessage">
                [@ww.text name='repository.inherit.warning']
                    [@ww.param]<a href="[@ww.url value='/browse/${plan.parent.key}/config' /]">[/@ww.param]
                    [@ww.param]</a>[/@ww.param]
                [/@ww.text]
            </div>
        [/#if]

        [#if !condensed]
            [@ww.label labelKey='repository.type' value='${repository.name}' /]
        [/#if]

        ${repository.getViewHtml(plan)!}

        [@ww.label labelKey='repository.common.cleanCheckout' value='${repository.cleanCheckout?string}' hideOnNull='true' /]
        [@ww.label labelKey='repository.common.cleanWorkingDirectory' value='${repository.cleanWorkingDirectory?string}' hideOnNull='true' /]

        [#if !condensed]
            [#if plan.type != 'JOB']

                [#if "${repository.name}" != "CVS"]
                    [#if repository.quietPeriodEnabled]
                        [@ww.label labelKey='repository.common.quietPeriod.period' value='${plan.buildDefinition.repository.quietPeriod!}' hideOnNull='true' /]
                        [@ww.label labelKey='repository.common.quietPeriod.maxRetries' value='${plan.buildDefinition.repository.maxRetries!}' hideOnNull='true' /]
                    [/#if]
                [/#if]

                [#if repository.filterFilePatternOption?? && repository.filterFilePatternOption == 'includeOnly']
                    [#assign filterOptionDescription][@ww.text name='filter.pattern.option.includeOnly' /][/#assign]
                [#elseif repository.filterFilePatternOption?? && repository.filterFilePatternOption == 'excludeAll']
                    [#assign filterOptionDescription][@ww.text name='filter.pattern.option.excludeAll' /][/#assign]
                [#else]
                    [#assign filterOptionDescription='None' /]
                [/#if]

                [#if filterOptionDescription != 'None']
                    [@ww.label labelKey='filter.pattern.option' value='${filterOptionDescription}' /]
                    [@ww.label labelKey='filter.pattern.regex' value='${repository.filterFilePatternRegex}' hideOnNull='true' /]
                [/#if]
            [/#if]

            [#if plan.buildDefinition.webRepositoryViewer?has_content]
                ${plan.buildDefinition.webRepositoryViewer.getViewHtml(plan)!}
            [/#if]

            [#if plan.type != "JOB"]
                [@ww.label labelKey='repository.change' name='plan.buildDefinition.buildStrategy.name' /]

                [#if plan.buildDefinition.buildStrategy.key == 'poll']
                    [#if plan.buildDefinition.buildStrategy.pollingStrategy == "CRON"]
                        [@dj.cronDisplay idPrefix="pt" name="plan.buildDefinition.buildStrategy.pollingCronExpression" /]
                    [#else]
                        [@ww.label labelKey='repository.change.poll.frequency' value='${plan.buildDefinition.buildStrategy.pollingPeriod}' /]
                    [/#if]
                [#elseif plan.buildDefinition.buildStrategy.key == 'trigger']
                    [@ww.label labelKey='repository.change.trigger.ip' value='${repository.triggerIpAddress}' /]
                [#elseif plan.buildDefinition.buildStrategy.key == 'daily']
                    [@ww.label labelKey='repository.change.daily.buildTime' value='${plan.buildDefinition.buildStrategy.formattedTime}' /]
                [#elseif plan.buildDefinition.buildStrategy.key == 'schedule']
                    [@dj.cronDisplay idPrefix="ct" name="plan.buildDefinition.buildStrategy.cronExpression" /]
                [/#if]

                ${triggerConditionViewHtml!}
            [/#if]
        [/#if]

    [#else]
          [@ui.displayText text='No repository configured. Edit the configuration to specify a repository.' /]
    [/#if]
[/#macro]