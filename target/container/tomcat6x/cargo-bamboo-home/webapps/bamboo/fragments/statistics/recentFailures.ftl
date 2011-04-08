[#-- @ftlvariable name="statistics" type="com.atlassian.bamboo.build.statistics.StatisticsCollector" --]

[#macro showSummary maxResults=5]

    [@ww.url id='viewFailurePeriodsUrl'
        action='viewFailurePeriods'
        namespace='/build'
        buildKey='${plan.key}'/]

    <div id="recentFailures">
        [@ui.header pageKey='chain.failures.title.long' /]
        [#if statistics.totalFailures > 0]
            [#if maxResults > 0]
                [#if statistics.failurePeriods?size > maxResults ]
                    <p class="headingInfo">
                        <a class="viewAllLink" href="${viewFailurePeriodsUrl}">[#rt]
                            [@ww.text name='build.failures.viewAll']
                                [@ww.param name="value" value=statistics.failurePeriods?size /]
                            [/@ww.text][#t]
                        </a>[#lt]
                    </p>
                [/#if]
                <h3>
                    <a id="recentFailures_toggler_on" class="toggleOn">[@ww.text name='build.failures.title'/]</a>
                    <a id="recentFailures_toggler_off" class="toggleOff">[@ww.text name='build.failures.title'/]</a>
                    [@cp.toggleDisplayByGroup toggleGroup_id='recentFailures' jsRestore=true /]
                </h3>
                <div id="recentFailures_target">
                    [@listRecentFailures maxResults=maxResults failurePeriods=statistics.failurePeriods/]
                </div>
            [#else]
                [@listRecentFailures maxResults=maxResults failurePeriods=statistics.failurePeriods /]
            [/#if]
            <ul>
                <li>Average time to fix a failure: <strong>
                    ${dateUtils.formatDurationPretty(statistics.averageElapsedTime / 1000)}</strong></li>
                <li>Average number of builds between fixes: <strong>${statistics.averageElapsedBuilds} builds</strong></li>
                <li>The longest time taken to fix a failure is
                    <strong>${dateUtils.formatDurationPretty(statistics.longestElapsedTimePeriod.elapsedTime/1000)}</strong>, from failure starting in
                    build <a href="#Period-${statistics.longestElapsedTimePeriod.breakingBuild.buildNumber}" class="Failed">
                    #${statistics.longestElapsedTimePeriod.breakingBuild.buildNumber}</a>.</li>
                <li>The greatest number of builds taken to fix a failure is
                    <strong>${statistics.longestElapsedBuildPeriod.elapsedBuilds}</strong>,
                    from failure starting in build
                    <a href="#Period-${statistics.longestElapsedBuildPeriod.breakingBuild.buildNumber}" class="Failed">
                    #${statistics.longestElapsedBuildPeriod.breakingBuild.buildNumber}</a>.</li>
            </ul>
        [#else]
            <p>[@ww.text name="build.failures.notFound" /]</p>
        [/#if]
    </div>
[/#macro]

[#macro recentFailuresIcon buildResult failure]
    <td class="${buildResult.buildState} recentFailuresIcon">
        [@ui.icon '${buildResult.buildState}'/]
        [#assign spanId="successBuild_${buildResult.buildResultKey}"/]
        [#if failure]
            [#assign spanId="failingBuild_${buildResult.buildResultKey}"/]
        [/#if]
        <span id="${spanId}" class="[#if failure]title[#else]successBuild[/#if]">
            <a href="[@ww.url value='/browse/${buildResult.buildResultKey}'/]" class="commits"
               id="Period-${buildResult.buildNumber}">#${buildResult.buildNumber}</a></span>
    </td>
[/#macro]

[#macro recentFailuresReason buildResult]
    <td class="recentFailuresReason">
        ${buildResult.reasonSummary}[#t]
        [@cp.commentIndicator buildResultsSummary=buildResult /]
        [#if buildResult.hasChanges()]
            <script type="text/javascript">
                AJS.$(function() {
                    initCommitsTooltip("${spanId}", "${buildResult.buildKey}", "${buildResult.buildNumber}");
                });
            </script>
        [/#if]
        <p>
            [@ui.time datetime=buildResult.buildCompletedDate]${buildResult.relativeBuildDate}[/@ui.time]
        </p>
    </td>
[/#macro]

[#macro listRecentFailures failurePeriods maxResults = -1]
    <table class="aui">
        <thead>
            <tr>
                <th scope="col" class="c1" colspan="2">Failed In</th>
                <th class="c2" colspan="2">Fixed In</th>
                <th class="c3">Time Taken To Fix</th>
            </tr>
        </thead>
        <tbody>
            [#list failurePeriods?reverse as failurePeriod]
                [#if maxResults > 0 && failurePeriod_index gte maxResults ][#break ][/#if]
                <tr [#if failurePeriod_index % 2 == 1] class="alt"[/#if]>
                    [@recentFailuresIcon buildResult=failurePeriod.breakingBuild failure=true/]
                    [@recentFailuresReason buildResult=failurePeriod.breakingBuild/]
                        [#if failurePeriod.fixingBuild??]
                            [@recentFailuresIcon buildResult=failurePeriod.fixingBuild failure=false/]
                            [@recentFailuresReason buildResult=failurePeriod.fixingBuild/]
                        [#elseif failurePeriod.removedInBuild??]
                        <td colspan="2">
                            <div class="removedInBuild">
                                    Removed in
                                    <a href="[@ww.url value='/browse/${failurePeriod.removedInBuild.buildResultKey}'/]" class="buildNumber">${failurePeriod.removedInBuild.buildNumber}</a>
                                    (${failurePeriod.removedInBuild.reasonSummary})
                                    [@cp.commentIndicator buildResultsSummary=failurePeriod.removedInBuild /]
                                    <p>[@ui.time datetime=buildResult.removedInBuild.buildDate]${buildResult.removedInBuild.buildDate?datetime}[/@ui.time] &ndash;
                                        [@ui.time datetime=failurePeriod.removedInBuild.buildCompletedDate]${failurePeriod.removedInBuild.relativeBuildDate}[/@ui.time]</p>
                            </div>
                        </td>
                        [#else]
                        <td colspan="2">
                            <span class="failedBuild">
                                Currently failing
                            </span>
                        </td>
                        [/#if]
                    <td class="c3">
                        [#if failurePeriod.fixingBuild?? || failurePeriod.removedInBuild??]
                            [@ww.text name='build.common.build.count'][@ww.param name="value" value=failurePeriod.elapsedBuilds /][/@ww.text]
                            <p class="details">${dateUtils.formatDurationPretty(failurePeriod.elapsedTime / 1000)}</p>
                        [/#if]
                    </td>
                </tr>
            [/#list]
        </tbody>
    </table>
[/#macro]