[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.PlanResultsAction" --]
[#-- @ftlvariable name="buildStatusHelper" type="com.atlassian.bamboo.build.BuildStatusHelper" --]
[#-- @ftlvariable name="buildSummary" type="com.atlassian.bamboo.resultsummary.ResultsSummary" --]

[#macro buildResultLink buildKey buildNumber][#rt]
    <a href="[@ww.url value='/browse/${buildKey}-${buildNumber}'/]" class="buildLink">#${buildNumber}</a>[#t]
[/#macro][#lt]

[#macro brsStatusBox buildSummary stopBuildUrl agent='' prefix="buildResult"]
    [#assign isJob = (buildSummary.plan.type == "JOB") /]
    [#if buildSummary.finished]
        [#assign iconClass=buildSummary.buildState /]
    [#else]
        [#assign iconClass=buildSummary.lifeCycleState /]
    [/#if]
    [#if isJob]
        [@ww.text id="buildType" name="job.common.title" /]
    [#else]
        [@ww.text id="buildType" name="build.common.title" /]
    [/#if]
    [#assign buildResult=buildResults! /]
    [#assign testSummary= buildSummary.testResultsSummary /]
    [#assign buildResultKey=buildSummary.buildResultKey /]
    
    <h2>Details</h2>
    <dl>
        <dt class="trigger">[@ww.text name="buildResult.trigger"/]</dt>
        <dd id="triggerReasonDescription">${action.getTriggerReasonLongDescriptionHtml(buildSummary)}</dd>
        [#if buildSummary.vcsRevisionKey??]
            <dt class="revision">[@ww.text name="buildResult.revision"/]</dt>
            <dd>${buildSummary.vcsRevisionKey}</dd>
        [/#if]
        [#if agent?has_content]
            <dt class="agent">[@ww.text name="buildResult.agent"/]</dt>
            <dd>[@ui.renderAgentNameLink agent/]</dd>
        [/#if]
        [#if buildSummary.waiting]
            [#if currentlyBuilding??]
                <dt class="agent">[@ww.text name="buildResult.agent"/]</dt>
                [#if currentlyBuilding.hasExecutableAgents()]
                    <dd>
                        [@ww.text name='queue.status.waiting.canBuildOnAgents']
                            [@ww.param]
                                [#list currentlyBuilding.executableBuildAgents as agent]
                                    [#if agent_index == 5]
                                        <a href="${viewAgentsUrl}">[@ww.text name="buildResult.agent.more"/]</a>
                                        [#break]
                                    [/#if]
                                    [@ui.renderAgentNameLink agent/]
                                    [#if agent_has_next], [/#if][#lt/]
                                [/#list]
                            [/@ww.param]
                        [/@ww.text]
                    </dd>
                    [#if currentlyBuilding.executableElasticImages?has_content]
                        <dd>
                            [#if fn.hasAdminPermission() ]
                                [@ww.text name='queue.status.waiting.elastic.admin.full']
                                    [@ww.param name="value"]${manageElasticInstancesUrl}[/@ww.param]
                                [/@ww.text]
                            [#else]
                                [@ww.text name='queue.status.waiting.elastic' /]
                            [/#if]
                        </dd>
                    [/#if]
                [#elseif currentlyBuilding.executableElasticImages?has_content]
                    <dd>
                        [@ww.text name='queue.status.cantBuild.elastic.full']
                            [@ww.param name="value"]${manageElasticInstancesUrl}[/@ww.param]
                        [/@ww.text]
                    </dd>
                [#elseif currentlyBuilding.executableAgentInfoInitialized]
                    <dd>[@ww.text name='queue.status.cantBuild' /]</dd>
                [/#if]
                <dt class="queued">[@ww.text name="buildResult.queued"/]</dt>
                <dd>[@ui.time datetime=buildSummary.queueTime]${buildSummary.queueTime?datetime?string} &ndash; <span>${buildSummary.relativeQueueDate}</span>[/@ui.time]</dd>
            [#elseif isJob]
                <dt class="status">Status</dt>
                <dd>[@ww.text name='queue.status.waiting.notCurrentStage' /]</dd>
            [/#if]
        [#elseif buildSummary.inProgress]
        [#elseif buildSummary.finished]
            [#if buildSummary.buildCompletedDate?has_content]
                <dt class="completed">[@ww.text name="buildResult.completed"/]</dt>
                <dd>
                    [@ui.time datetime=buildSummary.buildCompletedDate]${buildSummary.buildCompletedDate?datetime?string} &ndash; <span>${buildSummary.relativeBuildDate}</span>[/@ui.time]
                </dd>
            [/#if]
            [#if buildSummary.duration > 0]
                <dt class="duration">[@ww.text name="buildResult.duration"/]</dt>
                <dd>[#rt]
                    [#if buildSummary.queueTime?? && buildSummary.vcsUpdateTime?? && buildSummary.buildDate??]
                        <span id="build-duration-description">${buildSummary.durationDescription}</span>
                        [@dj.tooltip target='build-duration-description']
                            <span id="queueTime">[@ww.text name="buildResult.queued.sentence"][@ww.param]${durationUtils.getRelativeDate(buildSummary.queueTime,buildSummary.vcsUpdateTime)}[/@ww.param][/@ww.text]</span><br />
                            <span id="vcsUpdateTime">[@ww.text name="buildResult.vcsupdate.sentence"][@ww.param]${durationUtils.getRelativeDate(buildSummary.vcsUpdateTime,buildSummary.buildDate)}[/@ww.param][/@ww.text]</span>
                        [/@dj.tooltip]
                    [#else]
                        ${buildSummary.durationDescription}[#t]
                    [/#if]
                </dd>[#lt]
            [/#if]
            [#if buildSummary.successful]
                [#if buildStatusHelper.countSucceedingSince gt 1]
                    <dt class="successful-since">[@ww.text name="buildResult.successfulsince"/]</dt>
                    <dd>[@ps.buildResultLink plan.key buildStatusHelper.succeedingSinceBuild.buildNumber/] <span>([@ui.time datetime=buildStatusHelper.succeedingSinceBuild.buildCompletedDate]${buildStatusHelper.succeedingSinceBuild.getRelativeBuildDate(buildSummary.buildCompletedDate)}[/@ui.time])</span></dd>
                [#elseif buildStatusHelper.fixesBuild??]
                    <dt class="first-to-pass-since">[@ww.text name="buildResult.firsttopasssince"/]</dt>
                    <dd>[@ps.buildResultLink plan.key buildStatusHelper.fixesBuild.buildNumber/] <span>(${buildStatusHelper.fixesBuild.reasonSummary} &ndash; [@ui.time datetime=buildStatusHelper.fixesBuild.buildCompletedDate]${buildStatusHelper.fixesBuild.getRelativeBuildDate(buildSummary.buildCompletedDate)}[/@ui.time])</span></dd>
                [/#if]
            [#else]
                [#if testSummary??]
                    [#if buildStatusHelper.precedingConsecutiveFailuresCount gte 1]
                        <dt class="failing-since">[@ww.text name="buildResult.failingsince"/]</dt>
                        <dd>[@ps.buildResultLink plan.key buildStatusHelper.failingSinceBuild.buildNumber/] <span>(${buildStatusHelper.failingSinceBuild.reasonSummary} &ndash; [@ui.time datetime=buildStatusHelper.failingSinceBuild.buildCompletedDate]${buildStatusHelper.failingSinceBuild.getRelativeBuildDate(buildSummary.buildCompletedDate)}[/@ui.time])</span></dd>
                    [/#if]
                [/#if]
            [/#if]
            [#if buildStatusHelper.fixedInBuild??]
                <dt class="fixed-in">[@ww.text name="buildResult.fixedin"/]</dt>
                <dd>[@ps.buildResultLink plan.key buildStatusHelper.fixedInBuild.buildNumber/] <span>(${buildStatusHelper.fixedInBuild.reasonSummary})</span></dd>
            [/#if]
        [#elseif buildSummary.notBuilt || !buildResult?has_content]
            [#if !buildSummary.queueTime??]
                <dt class="status">[@ww.text name="buildResult.status"/]</dt>
                <dd>[@ww.text name="buildResult.summary.status.notBuilt.triggeredButNotQueued"/]</dd>
            [#else]
                <dt class="queued">[@ww.text name="buildResult.queued"/]</dt>
                <dd>[@ui.time datetime=buildSummary.queueTime]${buildSummary.queueTime?datetime?string}[/@ui.time]</dd>
                [#if isJob && !buildSummary.buildAgentId??]
                    <dt class="status">[@ww.text name="buildResult.status"/]</dt>
                    <dd>[@ww.text name="buildResult.summary.status.notBuilt.notPickedUpByAgent"/]</dd>
                [#elseif isJob && !buildSummary.vcsUpdateTime??]
                    <dt class="status">[@ww.text name="buildResult.status"/]</dt>
                    <dd>[@ww.text name="buildResult.summary.status.notBuilt.workspaceNotUpdated"/]</dd>
                [#elseif isJob && !buildSummary.buildDate??]
                    <dt class="status">[@ww.text name="buildResult.status"/]</dt>
                    <dd>
                        [@ww.text name="buildResult.summary.status.notBuilt.workspaceUpdatedNotExecuted"]
                            [@ww.param][@ui.time datetime=buildSummary.vcsUpdateTime]${buildSummary.vcsUpdateTime?datetime?string}[/@ui.time][/@ww.param]
                        [/@ww.text]
                    </dd>
                [#else]
                    [#if isJob]
                        <dt class="source-updated">[@ww.text name="buildResult.vcsupdate"/]</dt>
                        <dd>[@ui.time datetime=buildSummary.vcsUpdateTime]${buildSummary.vcsUpdateTime?datetime?string}[/@ui.time]</dd>
                    [/#if]
                    [#if buildSummary.buildDate??]
                        <dt class="started">[@ww.text name="buildResult.started"/]</dt>
                        <dd>[@ui.time datetime=buildSummary.buildDate]${buildSummary.buildDate?datetime?string}[/@ui.time]</dd>
                    [/#if]
                    [#if buildSummary.buildCompletedDate??]
                        <dt class="completed">[@ww.text name="buildResult.completed"/]</dt>
                        <dd>
                            [@ui.time datetime=buildSummary.buildCompletedDate]${buildSummary.buildCompletedDate?datetime?string} &ndash; <span>${buildSummary.relativeBuildDate}</span>[/@ui.time]
                        </dd>
                    [/#if]
                [/#if]
            [/#if]
            [#if buildSummary.buildCancelledDate??]
                <dt class="cancelled">[@ww.text name="buildResult.cancelled"/]</dt>
                <dd>[@ui.time datetime=buildSummary.buildCancelledDate]${buildSummary.buildCancelledDate?datetime?string}[/@ui.time]</dd>
            [#else]
                <dt class="status">[@ww.text name="buildResult.status"/]</dt>
                [#if buildSummary.queueTime?? && !(isJob && !buildSummary.vcsUpdateTime??) && buildSummary.buildDate?? && !buildSummary.buildCompletedDate??]
                    <dd>[@ww.text name="buildResult.summary.status.notBuilt.startedbutunknown"/]</dd>
                [#elseif isJob && action.getPreviousFailedStageResult(buildSummary)??]
                    <dd>[@ww.text name="buildResult.summary.status.notBuilt.previousStageFailed"]
                            [@ww.param]${action.getPreviousFailedStageResult(buildSummary).getName()}[/@ww.param]
                        [/@ww.text]</dd>
                [#else]
                    <dd>[@ww.text name="buildResult.summary.status.notBuilt.unknown"/]</dd>
                [/#if]
            [/#if]
        [/#if]
    </dl>

    [#include "/fragments/labels/labels.ftl"]

    [#-- Build Hung Information --]
    [#if buildSummary.inProgress && (currentlyBuilding.buildAgentId)?? && (currentlyBuilding.buildHangDetails)??]
        [#assign excessRunningMinutes = (currentlyBuilding.getBuildTime() - currentlyBuilding.buildHangDetails.getExpectedBuildTime()) /]
        [@ww.text id="hungWarningTitle" name="buildResult.hung.title"][@ww.param]${currentlyBuilding.buildIdentifier.buildResultKey}[/@ww.param][/@ww.text]
        [@ui.messageBox type="warning" title=hungWarningTitle]
            [@ui.displayBuildHungDurationInfoHtml currentlyBuilding.buildTime currentlyBuilding.averageDuration currentlyBuilding.buildHangDetails /]
        [/@ui.messageBox]
    [/#if]

    [#if chainExecution?? && chainExecution.stopping]
        [@ui.messageBox type="warning" titleKey="build.currentactivity.build.beingstopped"/]
    [/#if]

    [#-- No failed tests found --]
    [#if buildSummary.finished && !buildSummary.successful && testSummary?? && !testSummary.hasFailedTestResults()]
        [@ui.messageBox type="warning" titleKey="buildResult.noFailedTestsWarning" /]
    [/#if]
[/#macro]


[#macro showChanges build buildSummary]
    <div id="changesSummary" class="changesSummary">
        [@ww.url value='/browse/${buildSummary.buildResultKey}/commit' id='changeUrl' /]
        [#if changeUrl?? && buildSummary.commits?has_content]
            <div class="toolbar">
                <a id="displayFullCommits" href='${changeUrl}'>[#rt]
                [#if buildSummary.skippedCommitsCount gt 0]
                    [@ww.text name='buildResult.changes.files.all.skipped' ]
                        [@ww.param name="value" value="${buildSummary.commits.size()}"/]
                        [@ww.param name="value" value="${buildSummary.commits.size() + buildSummary.skippedCommitsCount}"/]
                    [/@ww.text][#t]
                [#elseif buildSummary.commits.size() gt 2]
                    [@ww.text name='buildResult.changes.files.all' ]
                        [@ww.param name="value" value="${buildSummary.commits.size()}"/]
                    [/@ww.text][#t]
                [#else]
                    [@ww.text name='buildResult.changes.files.details' /][#t]
                [/#if]
                </a>[#lt]
            </div>
        [/#if]
        <h2>[@ww.text name='buildResult.changes.title' /]</h2>

        [#if buildSummary.commits?has_content]
            [#if build.buildDefinition.webRepositoryViewer?has_content]
                ${build.buildDefinition.webRepositoryViewer.getHtmlForCommitsSummary(buildSummary, build.buildDefinition.repository)}
            [#else]
                [#include "templates/plugins/webRepository/noWebRepositorySummaryView.ftl" /]
            [/#if]
        [#else]
            <p>
                [@ww.text name='buildResult.changes.nochanges'/]
            </p>
        [/#if]

    </div>
    [#if buildSummary.failed && auditLoggingEnabled && configChanged]
        <div class="changesSummary">
              <h2>[@ww.text name='buildResult.configuration.changes.title' /]</h2>
              <p id="configChanges">
                  [@ww.text name='buildResult.config.changes' ]
                      [@ww.param]${req.contextPath}/chain/admin/config/viewChainAuditLog.action?buildKey=${buildSummary.buildKey}[#if failStartDate??]&filterStart=${failStartDate.getTime()}[/#if]&filterEnd=${buildSummary.getBuildCompletedDate().getTime()}[/@ww.param]
                  [/@ww.text][#t]
              </p>
        </div>
    [/#if]
[/#macro]

[#-- =========================================================================================== @ps.showBuildErrors
    type can have "chain" or "job" as values
--]
[#-- @ftlvariable name="extraBuildResultsData" type="com.atlassian.bamboo.results.ExtraBuildResultsData" --]
[#-- @ftlvariable name="buildResultSummary" type="com.atlassian.bamboo.resultsummary.BuildResultsSummary" --]
[#macro showBuildErrors buildResultSummary extraBuildResultsData='' type="job" header="" ]
    [#if buildResultSummary?? && extraBuildResultsData?has_content && extraBuildResultsData.buildErrors?has_content]
        [@ww.url id='errorUrl' value="/browse/${buildResultSummary.buildResultKey}/log" /]
        <div class="section">
            <h2>
                [#if header?has_content]
                    ${header}                    
                [#else]
                    <a href="${errorUrl}">[@ww.text name='buildResult.error.summary.job.title' /]</a>
                [/#if]
            </h2>
            <div>
                <p class="buildErrorsStatus">
                    [@ui.icon type="failed"/]
                    [@ww.text name='buildResult.error.summary.${type}.description' ]
                        [@ww.param]${errorUrl}[/@ww.param]
                    [/@ww.text]
                </p>
                <div class="code">
                    [#list extraBuildResultsData.buildErrors as error]
                        ${htmlUtils.getAsPreformattedText(error)}<br/>
                    [/#list]
                </div> <!-- END .code -->
            </div>
        </div> <!-- END #buildErrors -->
    [/#if]
[/#macro]


