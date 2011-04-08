[#-- @ftlvariable name="stageResults" type="java.util.Collection<com.atlassian.bamboo.chains.ChainStageResult>" --]
[#-- @ftlvariable name="stages" type="java.util.List<com.atlassian.bamboo.chains.ChainStage>" --]
[#-- @ftlvariable name="navObject" type="com.atlassian.bamboo.ww2.beans.DecoratedNavObject" --]
[#-- @ftlvariable name="navigationContext" type="com.atlassian.bamboo.ww2.NavigationContext" --]

[#-- ================================================================================== @chains.liveActivity --]

[#macro liveActivity expandable=true section=true]

[@ww.url id='getBuildsUrl' namespace='/chain/admin/ajax' action='getChains' /]
[@ww.url id='getChangesUrl' value='/rest/api/latest/result/' /]

[@ww.url id='unknownJiraType' value='/images/icons/jira_type_unknown.gif' /]
[@ww.text id='queueEmptyText' name='plan.liveactivity.noactivity' /]
[@ww.text id='cancelBuildText' name='agent.build.cancel' /]
[@ww.text id='cancellingBuildText' name='agent.build.cancelling' /]
[@ww.text id='noAdditionalInfoText' name='plan.liveactivity.build.noadditionalinfo' /]

<div id="liveActivity" [#if section]class="section"[/#if]>
    [#if chainExecution?has_content]
        <ul>
            [#assign buildStatus = "building" /]
            [#list chainExecution as execution]
                [#if execution.stopping]
                    [#assign buildMessage]
                        [@message]
                            [@ww.text name="build.currentactivity.build.beingstopped" /][#t]
                        [/@message]
                    [/#assign]
                    [@chainListItem chainResultKey=execution.planResultKey cssClass=buildStatus triggerReason=execution.getTriggerReason().getNameForSentence() planKey=chain.key buildMessage=buildMessage currentStage=currentStageText/]
                [#else]
                    [#assign progressBarText]
                        [#if false]
                            [@ww.text name="build.currentactivity.build.underaverage"]
                            [@ww.param]${durationUtils.getPrettyPrint(execution.elapsedTime,false)}[/@ww.param]
                            [@ww.param]${progressBar.getPrettyTimeRemaining(false)}[/@ww.param]
                            [/@ww.text]
                        [#else]
                            [@ww.text name="build.currentactivity.build.overaverage"]
                            [@ww.param]${durationUtils.getPrettyPrint(execution.elapsedTime,false)}[/@ww.param]
                            [/@ww.text]
                        [/#if]
                    [/#assign]
                    [#if chainExecution.startTime??]
                        [#assign buildMessage]
                            [@dj.progressBar id="pb${execution.planResultKey}" value=0 text=progressBarText cssClass="message" /]
                        [/#assign]
                        [#assign currentStageText]
                            [@currentStage stageName=execution.currentStage.name stageNumber=(execution.currentStage.stageIndex + 1) totalStages=execution.stages.size() /]
                        [/#assign]
                    [#else]
                        [@ww.text id="buildMessage" name="build.currentactivity.waiting"/]
                    [/#if]
                    [@chainListItem chainResultKey=execution.planResultKey cssClass=buildStatus triggerReason=execution.getTriggerReason().getNameForSentence() planKey=chain.key buildMessage=buildMessage currentStage=currentStageText/]
               [/#if]
            [/#list]
        </ul>
    [#else]
        <p>${queueEmptyText}</p>
    [/#if]
</div>

<script type="text/x-template" title="buildListItem-template">
    [@chainListItem chainResultKey="{buildResultKey}" cssClass="{cssClass}" triggerReason="{triggerReason}" planKey="{planKey}" buildMessage="{buildMessage}" currentStage="{currentStage}" /]
</script>
<script type="text/x-template" title="buildMessage-template">
    [@message type="{type}"]{text}[/@message]
</script>
<script type="text/x-template" title="jiraIssue-template">
    <li>
        <a title="View this issue" href="{url}?page=com.atlassian.jira.plugin.ext.bamboo%3Abamboo-build-results-tabpanel"><img alt="{issueType}" src="{issueIconUrl}" class="issueTypeImg"/></a>
        <h3><a href="{url}">{key}</a></h3>
        <p class="jiraIssueDetails">{details}</p>
    </li>
</script>
<script type="text/x-template" title="codeChange-changesetLink-template">
    <a href="{commitUrl}" class="rightFloat">({changesetId})</a>
</script>
<script type="text/x-template" title="codeChange-changesetDisplay-template">
    <span class="rightFloat">({changesetId})</span>
</script>
<script type="text/x-template" title="codeChange-template">
    <li>
        {changesetInfo}
        <img alt="{author}" src="[@ww.url value='/images/icons/businessman.gif' /]" class="profileImage"/>
        <h3><a href="${req.contextPath}/browse/user/{author}">{author}</a></h3>
        <p>{comment}</p>
    </li>
</script>
<script type="text/x-template" title="currentStage-template">
[@currentStage stageName="{stageName}" stageNumber="{stageNumber}" totalStages="{totalStages}" /]
</script>


<script type="text/javascript">
    AJS.$(function () {
        LiveActivity.init({
            planKey: "${chain.key}",
            container: AJS.$("#liveActivity"),
            getBuildsUrl: "${getBuildsUrl}",
            getChangesUrl: "${getChangesUrl}",
            queueEmptyText: "${queueEmptyText?js_string}",
            cancellingBuildText: "${cancellingBuildText?js_string}",
            noAdditionalInfoText: "${noAdditionalInfoText?js_string}",
            defaultIssueIconUrl: "${unknownJiraType?js_string}",
            defaultIssueType: "Unknown Issue Type",
            templates: {
                buildListItemTemplate: "buildListItem-template",
                buildMessageTemplate: "buildMessage-template",
                jiraIssueTemplate: "jiraIssue-template",
                codeChangeTemplate: "codeChange-template",
                currentStageTemplate: "currentStage-template",
                codeChangeChangesetLinkTemplate: "codeChange-changesetLink-template",
                codeChangeChangesetDisplayTemplate: "codeChange-changesetDisplay-template"
                [#if !expandable], toggleDetailsButton: null[/#if]
            }
        });
    });
</script>

[/#macro]

[#-- ================================================================================== @chains.message --]

[#macro message type="informative"]
<div class="message ${type}">[#nested]</div>[/#macro]

[#-- ================================================================================== @chains.currentStage --]

[#macro currentStage stageName stageNumber totalStages][#rt]
    - executing stage <strong>${stageName}</strong> (stage ${stageNumber} of ${totalStages})[#t]
[/#macro][#lt]

[#macro chainListItem chainResultKey planKey cssClass triggerReason buildMessage="" currentStage=""][#rt]
<li id="b${chainResultKey}" class="${cssClass}">
    <span class="build-description">[#rt]
        <strong><a href="${req.contextPath}/browse/${chainResultKey}">${chainResultKey}</a></strong> <span>${triggerReason}</span> <span class="stage-info">${currentStage}</span>[#t]
    </span>[#lt]
    <a id="stopBuild_${chainResultKey}" href="[@ww.url namespace='/build/admin/ajax' action='stopPlan' /]?planResultKey=${chainResultKey}" class="build-stop" title="${cancelBuildText}">${cancelBuildText}</a>
    ${buildMessage}
    <div class="additional-information">
        <div class="issueSummary">
            <h2 class="jiraIssuesHeader">JIRA Issues</h2>
        </div>
        <div class="changesSummary">
            <h2 class="codeChangesHeader">[@ww.text name='buildResult.changes.title' /]</h2>
        </div>
    </div>
</li>
[/#macro]

[#-- ================================================================================== @chains.stageConfiguration --]

[#macro stageConfiguration id chain]
    [#assign stages = chain.stages/]
    [#assign key = chain.key/]
    [#if stages?has_content]
        [@stageList id=id]
            [#list stages as stage]
                [@ww.url id="stageEditLink" value='/chain/admin/ajax/editStage.action' buildKey=key stageId=stage.id returnUrl=currentUrl /]
                [#assign stageStatus]
                    <ul class="actions">
                        <li class="aui-dd-parent">
                            <span class="aui-dd-trigger">[@ww.text name="menu.actions"/]</span>
                            <ul class="aui-dropdown hidden">
                                <li>[@ui.displayLinkForAUIDialog titleKey='stage.configure' id="edit_${stage.id}" href=stageEditLink class="edit-stage"/]</li>
                                [#if fn.hasPlanPermission("ADMINISTRATION", chain)]
                                    [@ww.url id='confirmDeleteStageLink' action='confirmDeleteStage' namespace='/chain/admin' buildKey=key stageId=stage.id returnUrl=currentUrl /]
                                    <li>[@ui.displayLink href=confirmDeleteStageLink titleKey="stage.delete"/]</li>
                                [/#if]
                            </ul>
                        </li>
                    </ul>
                [/#assign]

                [@stageListItem id=stage.id name=stage.name status=stageStatus description=stage.description cssClass="not-collapsible"]
                    [@jobList]
                        [#list stage.jobs.toArray()?sort_by("name") as job]
                            [@jobListItem key=job.key name=job.buildName href="${req.contextPath}/browse/${job.key}/config" disabled=job.suspendedFromBuilding agentUnavailabilityHint=action.getAgentUnavailabilityHint(job)]
                                <span class="handle"></span>
                                [#if fn.hasPlanPermission("BUILD", chain) || fn.hasPlanPermission("ADMINISTRATION", chain)]
                                <ul class="actions">
                                    <li class="detail-drop aui-dd-parent">
                                        [@ww.url id="editBuildConfigurationLink" action="editBuildConfiguration" namespace="/build/admin/edit" buildKey=job.key /]
                                        [@ui.displayLink href=editBuildConfigurationLink titleKey="job.edit"/]
                                        <span class="drop-wrap">
                                            <a class="aui-dropdown-trigger aui-dd-link drop" title="[@ww.text name="menu.accessmore"/]">[@ui.icon type="drop" /]</a>
                                        </span>
                                        <ul class="aui-dropdown hidden">
                                            [#if fn.hasPlanPermission("BUILD", chain)]
                                            <li>
                                                [#if job.suspendedFromBuilding]
                                                    [@ww.url id="resumeBuildLink" namespace="/build/admin" action="resumeBuild" buildKey=job.key returnUrl=currentUrl/]
                                                    [@ui.displayLink href=resumeBuildLink titleKey="job.enable"/]
                                                [#else]
                                                    [@ww.url id="suspendBuildLink" namespace="/build/admin" action="suspendBuild" buildKey=job.key returnUrl=currentUrl/]
                                                    [@ui.displayLink href=suspendBuildLink titleKey="job.disable"/]
                                                [/#if]
                                            </li>
                                            [/#if]
                                            [#if fn.hasPlanPermission("ADMINISTRATION", chain)]
                                                <li>[@ww.url id="deleteJobLink" action="deleteChain" namespace="/chain/admin" buildKey=job.key returnUrl=currentUrl /]
                                                    [@ui.displayLink href=deleteJobLink titleKey="job.delete"/]</a></li>
                                            [/#if]
                                        </ul>
                                    </li>
                                </ul>
                                [/#if]
                            [/@jobListItem]
                        [/#list]
                        [@createJobListItem chain=chain stage=stage /]
                    [/@jobList]
                [/@stageListItem]
            [/#list]
        [/@stageList]
        <script type="text/javascript">
            AJS.$(function () {
                ChainConfiguration.init({
                    $list: AJS.$("#${id}"),
                    moveStageUrl: '[@ww.url action="moveStage" namespace="/chain/admin/ajax" /]',
                    moveJobUrl: '[@ww.url action="moveJob" namespace="/chain/admin/ajax" /]',
                    confirmStageMoveUrl: '[@ww.url action="confirmStageMove" namespace="/chain/admin/ajax" /]',
                    confirmJobMoveJobUrl: '[@ww.url action="confirmJobMove" namespace="/chain/admin/ajax" /]',
                    chainKey: "${key}",
                    canReorder: ${fn.hasPlanPermission("ADMINISTRATION", chain)?string},
                    stageMoveHeader: '[@ww.text name="stage.move.confirm.header"/]',
                    jobMoveHeader: '[@ww.text name="job.move.confirm.header"/]'
                });
            });
            var updateStage = function (data) {
                var $stageTitle = AJS.$("#stage_" + data.stage.id + " > div > dl > dt"),
                    newTitleHTML = data.stage.description ? (data.stage.name + " <span>" + data.stage.description + "</span>") : data.stage.name;
                $stageTitle.html(newTitleHTML);
            };
        </script>
        [@dj.simpleDialogForm triggerSelector=".edit-stage" width=540 height=250 headerKey="stage.configure" submitCallback="updateStage" /]
    [#else]
        <p>[@ww.text name='chain.result.stage.nostages' /]</p>
    [/#if]
[/#macro]

[#-- =================================================================================================== @chains.logMenu --]
[#macro logMenu action plan planType linesToDisplay secondsToRefresh]
    <form id="viewPlanActivityLogForm" action="${action}" method="get">
        This page shows
        <select name="linesToDisplay" class="submitOnChange">
            <option value="10"  [#if linesToDisplay == 10]  selected="selected" [/#if]>10</option>
            <option value="25"  [#if linesToDisplay == 25]  selected="selected" [/#if]>25</option>
            <option value="50"  [#if linesToDisplay == 50]  selected="selected" [/#if]>50</option>
            <option value="100" [#if linesToDisplay == 100] selected="selected" [/#if]>100</option>
        </select>
        activity log entries for the <strong>${plan.name}</strong> ${planType}. Refresh:
        <select name="secondsToRefresh" class="submitOnChange">
            <option value="0"  [#if secondsToRefresh == 0] selected="selected" [/#if]>[@ww.text name="chain.logs.never"/]</option>
            <option value="1"  [#if secondsToRefresh == 1]  selected="selected" [/#if]>[@ww.text name="chain.logs.one"/]</option>
            <option value="5" [#if secondsToRefresh == 5] selected="selected" [/#if]>[@ww.text name="chain.logs.five"/]</option>
            <option value="30" [#if secondsToRefresh == 30] selected="selected" [/#if]>[@ww.text name="chain.logs.thirty"/]</option>
        </select>
        [#nested /]
    </form>
[/#macro]

[#-- ========================================================================================= @chains.planNavigator --]

[#macro planNavigator navigationContext]
    [#assign navObject=navigationContext.navObject/]
    [#assign currentKey=navigationContext.currentKey/]

    [#if navObject?has_content]
        <h2>[@ww.text name='navigator.title' /]</h2>
        [@ww.url value=navigationContext.getChainUrl(navObject) id='chainUrl'/]
        <h3[#if navObject.key == currentKey] class="active [#if navObject.status??]${navObject.status.displayClass}[/#if]"[/#if]>
            <a href="${chainUrl}">[#rt]
                [#if navObject.planResultKey?has_content]
                    [@ww.text name='navigator.result.name'][@ww.param]${navObject.planResultKey.buildNumber}[/@ww.param][/@ww.text][#t]
                [#else]
                    ${navObject.displayName}[#t]
                [/#if]
            </a>[#lt]
        </h3>
        <ul>
            [#list navObject.navGroups as stage]
                <li id="stage-${stage.id}" [#if (stage.status.displayClass)?has_content]class="${stage.status.displayClass}"[/#if]>
                    <h4 [#if stage.description?has_content] title="${stage.description}"[/#if]>${stage.name}</h4>
                    <ul>
                        [#list stage.children as job]
                            <li id="job-${job.key}" [#if job.description?has_content] title="${job.description}"[/#if] class="[#if (job.suspendedFromBuilding)!false]disabled [/#if][#if job.key == currentKey]active [/#if][#if job.status??]${job.status.displayClass}[/#if]">
                                [#if job.status?has_content]
                                    [#if job.status.inProgress]
                                        [#assign execStatus = job.status.executionStatus!/]
                                        [#if execStatus?has_content]
                                            [@dj.progressBar id="navPb${job.key}" value=(100 - (execStatus.progressBar.percentageCompleted * 100))?ceiling /]
                                        [/#if]
                                    [/#if]
                                    [@ui.icon job.status.displayClass /]
                                [#elseif (job.suspendedFromBuilding)!false]
                                    [@ui.icon "disabled" /]
                                [#else]
                                    [@ui.icon "job"/]
                                [/#if]
                                [@ww.url value=navigationContext.getJobUrl(job) id='jobUrl'/]
                                <a id="navJob_${job.key}" href="${jobUrl}">${job.displayName}</a>
                            </li>
                        [/#list]
                    </ul>
                </li>
            [/#list]
        </ul>
    [/#if]
[/#macro]

[#-- ========================================================================================== @chains.statusRibbon --]

[#macro statusRibbon navigationContext]
    [#assign navObject=navigationContext.navObject/]
    [#assign currentObject=navigationContext.currentObject/]
    [#assign hasJob=currentObject.parent??/]
    [#if !hasJob]
        [#assign operationTimeText = navObject.status.opTimeText!/]
    [/#if]

    <div id="status-ribbon"[#if hasJob] class="has-job"[/#if]>
        <div id="sr-build" class="${navObject.status.displayClass}">
            <h2>
                [@ui.icon type=navObject.status.displayClass /]
                <span class="assistive">[@ww.text name="build.common.title" /]:</span>
                <a href="${req.contextPath}/browse/${navObject.key}">#${navObject.buildNumber}</a>
                <span[#if hasJob] class="assistive"[/#if]>${navObject.status.summarySuffix}[#if operationTimeText?has_content] <span class="operationTime">${operationTimeText}</span>[/#if]</span>
            </h2>
        </div>
        [#if hasJob]
            [#assign operationTimeText = currentObject.status.opTimeText!/]
            <div id="sr-job" class="${currentObject.status.displayClass}">
                <h3>
                    <span>[@ww.text name="job.common.title" /]:</span> ${currentObject.displayName}
                    <span>${currentObject.status.summarySuffix}[#if operationTimeText?has_content] <span class="operationTime">${operationTimeText}</span>[/#if]</span>
                </h3>
            </div>
        [/#if]
        <div id="progress-and-history-navigator">
            [#include "/fragments/buildResultsNavigator.ftl"]
            [#if !hasJob && navObject.status.inProgress && navObject.status.executionStatus?has_content]
                [@dj.progressBar id="sr-pb-${navObject.key}" value=(100 - (navObject.status.executionStatus.progressBar.percentageCompleted * 100))?ceiling /]
            [#elseif hasJob && currentObject.status.inProgress && !currentObject.status.updatingSource && currentObject.status.executionStatus?has_content]
                [@dj.progressBar id="sr-pb-${currentObject.key}" value=(100 - (currentObject.status.executionStatus.progressBar.percentageCompleted * 100))?ceiling /]
            [/#if]
        </div>
        <script type="text/javascript">
            if (AJS.$.browser.msie && parseInt(AJS.$.browser.version, 10) <= 8) {
                AJS.$(function ($) {
                    $("#status-ribbon").append('<span class="before"></span><span class="after"></span>');
                });
            }
            [#if (navObject.status.active)!false]
            AJS.$(function () {
                BuildResult.init({
                    currentKey: "${currentObject.key}",
                    getStatusUrl: "[@ww.url value='/rest/api/latest/result/status/' + navObject.key /]",
                    buildStatus: "${navObject.status.displayClass}"[#if hasJob],
                    jobStatus: "${currentObject.status.jobExecutionPhaseString}"[/#if]
                });
            });
            [/#if]
        </script>
    </div>
[/#macro]

[#-- Helper/Structural Macros ====================================================================================== --]

[#-- ================================================================================== @chains.stageList --]

[#macro stageList id]
<ul id="${id}" class="stageList">
    [#nested]
</ul>
[/#macro]

[#-- ================================================================================== @chains.stageListItem --]

[#macro stageListItem id name status description="" cssClass=""]
<li id="stage_${id}"[#if cssClass?has_content] class="${cssClass}"[/#if]>
    <div>
        <dl>
            <dt>${name}[#if description?has_content] <span>${description?html}</span>[/#if]</dt>
            <dd>${status}</dd>
        </dl>
        [#nested]
    </div>
    <div class="arrow"></div>
</li>
[/#macro]

[#-- ================================================================================== @chains.jobList --]

[#macro jobList cssClass=""]
<ul[#if cssClass?has_content] class="${cssClass}"[/#if]>
    [#nested]
</ul>
[/#macro]

[#-- ================================================================================== @chains.jobListItem --]

[#macro jobListItem key name href cssClass="" disabled=false agentUnavailabilityHint=""]
<li id="job_${key}"[#if cssClass?has_content] class="${cssClass}"[/#if]>    
    <a href="${href}" id="viewJob_${key}" class="job">${name}</a>
    [#if disabled]
        <span class="disabled">[@ww.text name="build.summary.title.long.suspended"/]</span>
    [/#if]
    [#if agentUnavailabilityHint?has_content]
        <span class="noMatchingAgent">
            ${agentUnavailabilityHint}
        </span>
    [/#if]
    [#nested]
</li>
[/#macro]

[#-- ================================================================================== @chains.createJobListItem --]

[#macro createJobListItem chain stage]
    [#if fn.hasPlanPermission("ADMINISTRATION", chain)]
        <li class="create-job">
            <a id="createJob_${stage.id}" href="[@ww.url action='addJob' namespace='/chain/admin' buildKey=chain.key existingStage=stage.name /]" title="Create a new Job">Create Job</a>
        </li>
    [/#if]
[/#macro]

[#-- ================================================================================== @chains.displayBuildResultDetails --]

[#macro displayBuildResultDetails durationDescription testSummary]
<dl>
    <dt class="duration">[@ww.text name="buildResult.summary.duration" /]</dt>
    <dd class="duration">${durationDescription}</dd>
    <dt class="tests">[@ww.text name="buildResult.testClass.tests" /]</dt>
    <dd class="tests">${testSummary}</dd>
</dl>
[/#macro]

[#-- ================================================================================== @chains.displayBuildInProgress --]

[#macro displayBuildInProgress id chainResultKey buildResultKey ]
<a id="stopBuildLink_{id}" class="build-stop" href="${req.contextPath}/build/admin/stopPlan.action?planResultKey={buildResultKey}&amp;returnUrl=/browse/{chainResultKey}" title="[@ww.text name='job.stop' /]">[@ww.text name='job.stop' /]</a>
[/#macro]

[#-- ================================================================================== @chains.displayJobNoAgentError --]

[#macro displayJobNoAgentError]
<span class="jobError">[@ww.text name='queue.status.cantBuild'/]</span>
[/#macro]

[#macro displaySharedArtifactDefinitions artifactDefinitions]
<table id="artifactDefinitions" class="aui">
    <thead>
        <tr>
            <th>[@ww.text name='job.common.title'/]</th>
            <th>[@ww.text name='artifact.name'/]</th>
            <th>[@ww.text name='artifact.location'/]</th>
            <th>[@ww.text name='artifact.copyPattern'/]</th>
        </tr>
    </thead>
    [#list artifactDefinitions.keySet() as job]
        [#assign jobArtifactDefinitions = artifactDefinitions.get(job)]
        <tbody>
            [#list jobArtifactDefinitions as artifactDefinition]
                <tr id="artifactDefinition-${artifactDefinition.id}">
                    [#if artifactDefinition_index = 0]
                        <td rowspan="${jobArtifactDefinitions.size()}"><a id="producerJob-${job.id}" href="${req.contextPath}/browse/${job.key}/config">${job.buildName}</a></td>
                    [/#if]
                    <td><a id="artifactConfig-${artifactDefinition.id}" href="[@ww.url action='defaultBuildArtifact' namespace='/build/admin/edit' buildKey=job.key /]">[@ui.icon type="artifact-shared"/] ${artifactDefinition.name}</a></td>
                    <td>${artifactDefinition.location!}</td>
                    <td>${artifactDefinition.copyPattern}</td>
                </tr>
            [/#list]
        </tbody>
    [/#list]
</table>
[/#macro]
