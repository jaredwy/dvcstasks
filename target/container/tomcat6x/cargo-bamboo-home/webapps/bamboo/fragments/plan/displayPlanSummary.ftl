[#-- @ftlvariable name="plan" type="com.atlassian.bamboo.plan.Plan" --]

[#import "/fragments/plan/displayWideBuildPlansList.ftl" as planList]
[#import "/lib/chains.ftl" as chains]
[#import "/lib/build.ftl" as builds]
[#include "/fragments/buildResults/showBuildResultsTable.ftl" /]

<div id="buildSummary">
    [#if plan.type.equals('CHAIN')]
        [@ui.header pageKey='chain.summary.title.long' /]
    [#else]
        [@ui.header pageKey='build.summary.title.long' /]
    [/#if]
    <div id="planDetailsSummary">
        <div id="activitySummary">
            <h2>[@ww.text name='build.currentactivity.title'/]</h2>
            [#if plan.type.equals('CHAIN')]
                [@chains.liveActivity expandable=true section=false/]
            [#else]
                [@builds.liveActivity expandable=true section=false/]
            [/#if]
        </div>

        <div class="recentHistorySummary">
            <h2>[@ww.text name='chain.summary.history'/]</h2>
            [@showBuildResultsTable
                pager=pager
                sort=false
                showAgent=false
                showOperations=false
                showArtifacts=false
                showDuration=false
                showHeader=false
                showPager=false
                useRelativeDate=true
                showFullBuildName=false/]

            [#if latestSummary?? || lastSuccessfulSummary??]
                <ul class="history-permalinks">
                    [#if latestSummary??]
                        <li>
                            <a id="buildResult_${latestSummary.planResultKey}" href="${req.contextPath}/browse/${planKey}/latest">
                                [@ui.icon type="permalink" /]
                                [@ww.text name="chain.summary.latest"/][#t]
                            </a>
                        </li>
                    [/#if]
                    [#if lastSuccessfulSummary??]
                        <li>
                            <a id="buildResult_${lastSuccessfulSummary.planResultKey}" href="${req.contextPath}/browse/${planKey}/latestSuccessful">
                                [@ui.icon type="permalink" /]
                                [@ww.text name="chain.summary.lastSuccessful"/][#t]
                            </a>
                        </li>
                    [/#if]
                </ul>
            [/#if]
        </div>

        [@cp.displayErrorsForPlan plan errorAccessor/]
    </div>
    [#assign isJob=plan.type.equals('JOB')/]
    <div id="planStatsSummary">
        [#if isJob]
            <h2>[@ww.text name='job.statistics.title.long'/]</h2>
        [#else]
            <h2>[@ww.text name='plan.statistics.title.long'/]</h2>
        [/#if]
        [@cp.successStatistics statistics plan.averageBuildDuration isJob /]
        <div id="planSummaryGraphs">
            [#if resultsList?has_content]
                [#if isJob]
                    <h2>[@ww.text name='job.summary.graph.duration'/]</h2>
                [#else]
                    <h2>[@ww.text name='chain.summary.graph.duration'/]</h2>
                [/#if]
                [@ww.action name="viewCombinedByBuildNumberChart" namespace="/charts" executeResult="true"]
                    [@ww.param name="height" value=276][/@ww.param]
                    [@ww.param name="width" value=345][/@ww.param]
                [/@ww.action]

                [#if isJob]
                    <h2>[@ww.text name='job.summary.graph.successfulBuilds'/]</h2>
                [#else]
                    <h2>[@ww.text name='chain.summary.graph.successfulBuilds'/]</h2>
                [/#if]
            [@ww.action name="viewCombinedByTimePeriodChart" namespace="/charts" executeResult="true"]
                [@ww.param name="height" value=276][/@ww.param]
                [@ww.param name="width" value=345][/@ww.param]
            [/@ww.action]
            [/#if]
        </div>
    </div>
</div> <!-- END #buildSummary -->

<div class="section">
    <a href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssAll&amp;buildKey=${plan.key}${rssSuffix}"><img
            src="${req.contextPath}/images/rss.gif" border="0" hspace="2" align="absmiddle"
            alt="&ldquo;${plan.name}&rdquo; all builds RSS feed"/></a>
    Feed for <a id="allBuildsPlanRSS"
                href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssAll&amp;buildKey=${plan.key}${rssSuffix}"
                title="&ldquo;${plan.name}&rdquo; all builds RSS feed">all builds</a>
    or just the <a id="failedBuildsPlanRSS"
                   href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssFailed&amp;buildKey=${plan.key}${rssSuffix}"
                   title="&ldquo;${plan.name}&rdquo; failed builds RSS feed">failed builds</a>.
</div>