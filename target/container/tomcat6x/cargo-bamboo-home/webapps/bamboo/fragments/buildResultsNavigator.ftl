[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.BuildResultsAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.BuildResultsAction" --]

[#assign returnUrl=navigationContext.getCurrentUrl()!currentUrl/]

<div id="history-navigator">
    <h4>[@ww.text name="historynavigator.title" /]</h4>
    [#if resultsSummary.buildNumber gt plan.firstBuildNumber]
        [@ww.url id='previousLink'
                 action='viewPreviousBuildResults'
                 namespace='/build/result'
                 buildNumber='${resultsSummary.buildNumber}'
                 buildKey='${plan.key}'
                 returnUrl='${returnUrl}' /]
        <a id="hn-previous" href="${previousLink}" title="[@ww.text name="historynavigator.previous" /]" accesskey="[@ww.text name="global.key.back" /]"><span>[@ww.text name="global.pager.previous" /]</span></a>
    [#else]
        <span id="hn-previous"><span></span></span>
    [/#if]
    <ol>
        [#list neighbouringSummaries as neighbouringBuild]
            [@ww.url action="gotoBuildResult" id="gotoUrl"
                     namespace="/build/result"
                     buildKey="${plan.key}"
                     returnUrl="${returnUrl}"
                     buildNumber="${neighbouringBuild.buildNumber}"/]

            [#if neighbouringBuild.finished]
                [#assign buildStatus = neighbouringBuild.buildState]
                [#assign buildStatusDescription][@ww.text name="build.buildState.${neighbouringBuild.buildState.name()}"/][/#assign]
            [#else]
                [#assign buildStatus = neighbouringBuild.lifeCycleState]
                [#assign buildStatusDescription][@ww.text name="build.lifeCycleState.${neighbouringBuild.lifeCycleState.name()}"/][/#assign]
            [/#if]

            [#if neighbouringBuild.buildNumber == resultsSummary.buildNumber]
                <li id="hn-${neighbouringBuild.buildNumber}" class="${buildStatus} current">
                    <span>[@ui.icon type=buildStatus text="#${neighbouringBuild.buildNumber} (${buildStatusDescription})" /]</span>
                </li>
            [#else]
                <li id="hn-${neighbouringBuild.buildNumber}" class="${buildStatus}">
                    <a href="${gotoUrl}">[@ui.icon type=buildStatus text="#${neighbouringBuild.buildNumber} (${buildStatusDescription})" /]</a>
                    [@dj.tooltip target='hn-${neighbouringBuild.buildNumber}' showDelay=100]
                        [@ui.icon type=buildStatus/] <strong class="${buildStatus}">#${neighbouringBuild.buildNumber}</strong><br />
                        [#if neighbouringBuild.triggerReason??]
                            ${action.getTriggerReasonLongDescriptionText(neighbouringBuild)}<br />
                        [/#if]
                        [#if neighbouringBuild.failed]
                           ${neighbouringBuild.failedTestCount} tests failed
                        [/#if]
                    [/@dj.tooltip]
                </li>
            [/#if]
        [/#list]
    </ol>
    [@dj.tooltip target='gotoBuildResult_buildNumber' text=action.getText('buildResult.nav.goto.help') showDelay=100 /]
    [#if resultsSummary.buildNumber lt plan.lastBuildNumber]
        [@ww.url id='nextLink'
                 action='viewNextBuildResults'
                 namespace='/build/result'
                 buildNumber='${resultsSummary.buildNumber}'
                 buildKey='${plan.key}'
                 returnUrl='${returnUrl}' /]
        <a id="hn-next" href="${nextLink}" title="[@ww.text name="historynavigator.next" /]" accesskey="[@ww.text name="global.key.next" /]"><span>[@ww.text name="global.pager.next" /]</span></a>
    [#else]
        <span id="hn-next"><span></span></span>
    [/#if]
</div>
