[#-- @ftlvariable name="builds" type="java.util.Collection<com.atlassian.bamboo.plan.TopLevelPlan>" --]

[#-- ============================================================================================== @planList.displayJiraIssues --]
[#--used for jira bamboo plugin--]
[#macro displayJiraIssues jiraIssues summary]
[#if jiraIssues.size() > 3]
    <a href="${baseUrl}/browse/${summary.buildResultKey}/issues">[#rt]
        ${jiraIssues.size()} issues[#t]
    </a>[#lt]
[#else]
    [#list jiraIssues as jiraIssue]
           ${jiraIssueUtils.getRenderedString(jiraIssue.issueKey, summary)}[#if jiraIssue_has_next], [/#if]
    [/#list]
[/#if]
[/#macro]

[#-- ============================================================================================== @planList.displayIssues --]
[#--used for jira bamboo plugin--]
[#macro displayIssues summary]
[#assign fixingJiraIssues =  summary.fixingJiraIssues!('')/]
[#assign relatedJiraIssues =  summary.relatedJiraIssues!('')/]

[#if fixingJiraIssues?has_content || relatedJiraIssues?has_content]
    <p class="summary">
    [#if fixingJiraIssues?has_content]
        <span class="fixes_issues">
            [@ww.text name='jira.fixes' /]:
            [@displayJiraIssues jiraIssues=fixingJiraIssues summary=summary /]
        </span>
        [#if relatedJiraIssues?has_content]
            <br>
        [/#if]
    [/#if]

    [#if relatedJiraIssues?has_content]
        <span class="related_issues">
            [@ww.text name='jira.related' /]:
            [@displayJiraIssues jiraIssues=relatedJiraIssues summary=summary /]
        </span>
    [/#if]
    </p>
[/#if]
[/#macro]

[#-- ============================================================================================== @planList.showFullSummaryDetails --]
[#--used for jira bamboo plugin--]
[#macro showFullSummaryDetails summary showComment=true]
   <p class="details">
        <!-- Reason -->
        <span class="reason" id="reasonSummary${summary.buildKey}">
            ${summary.reasonSummary}
        </span> |

        [#assign willShowComment = showComment && summary.comments?has_content /]
        [#if willShowComment]
            [@cp.commentIndicatorAsText buildResultsSummary=summary /] |
        [/#if]

	    <!-- Last Build Time-->
		[@ww.text name='build.common.ran.title' /]:
        [#if summary.successful || summary.failed]
            <span class="relativeDate" title="${summary.buildCompletedDate?datetime?string('hh:mm a, EEE, d MMM')}">
                ${summary.relativeBuildDate}
            </span>
        [#else]
            <span class="relativeDate">
                [@ww.text name='buildResult.completedBuilds.defaultDurationDescription'/]
            </span>
        [/#if]

        <br>
        <!-- Duration -->
        [@ww.text name='build.common.duration' /]:
        <span class="duration">
            ${summary.durationDescription}[#t]
        </span> |

        <!-- test count summary -->
        [@ww.text name='build.tests.title' /]:
        <span class="test_results">
            ${summary.testSummary}[#t]
        </span>

        <!-- Artifacts and Labels -->
		[#assign artifactLinks = (summary.artifactLinksThatExist)! /]
		[#assign labelNames = (summary.labelNames)! /]
		[#if artifactLinks?has_content || labelNames?has_content]
			<br>

			[#if artifactLinks?has_content]
                [@ww.text name='artifact.title' /]:
		        <span class="artifacts">
		            [#list artifactLinks?chunk(7) as artifactLinkRow]
                        [#list artifactLinkRow as artifactLink]
                            [#if artifactLink.url?has_content]
                                <a href="[@ww.url value='${artifactLink.url}'/]">${artifactLink.label}</a>[#if artifactLink_has_next], [/#if]
                            [/#if]
                        [/#list]
                        <br>
		            [/#list]
		        </span>
			    [#if labelNames?has_content] | [/#if][#t]
            [/#if]

            [#if labelNames?has_content]
		        [@ww.text name='labels.title' /]:[#lt]
		        <span class="labels">
		           [#list labelNames?chunk(7) as labelNameRow]
                       [#list labelNameRow as labelName]
		                    <a href="[@ww.url value='/browse/label/${labelName?url}'/]">${labelName?html}</a>[#if labelName_has_next], [/#if]
                       [/#list]
                       <br>
		           [/#list]
		        </span>
            [/#if]
		[/#if]
	</p>
[/#macro]

[#-- ============================================================================================== @planList.planOperations --]
[#macro planOperations build]
<div class="planOperations">
    [#assign operationsReturnUrl='${currentUrl}' /]
    <!-- operations -->
    [#if fn.hasPlanPermission('BUILD',build) ]
        [@dj.simpleDialogForm
            triggerSelector=".build-stop_${build.key}"
            actionUrl="/ajax/viewRunningPlans.action?planKey=${build.key}&returnUrl=${currentUrl}"
            width=800 height=400
            submitLabelKey="build.stop.confirmation.button"/]
        [@ww.text id="stopAllTitle" name="build.stop.all" ][@ww.param]'${build.name}'[/@ww.param][/@ww.text]
        [@ww.text id="stopOneTitle" name="build.stop.name" ][@ww.param]'${build.name}'[/@ww.param][/@ww.text]

        [#assign hideResume = true/]
        [#assign hideStopMultiple = true/]
        [#assign hideStopSingle = true/]
        [#assign hideStart = true/]

        [#if build.suspendedFromBuilding ]
            [#assign hideResume = false/]
        [#else]
            [#assign numberOfRunningPlans = action.getNumberOfCurrentlyBuildingPlans(build.key) /]
            [#if numberOfRunningPlans > 1 ]
                [#assign hideStopMultiple = false/]
            [#elseif build.active]
                [#assign hideStopSingle = false/]
            [#else]
                [#assign hideStart = false/]
            [/#if]
        [/#if]
        <a class="asynchronous" id="resumeBuild_${build.key}" [#if hideResume]style="display:none;"[/#if] href="[@ww.url action='resumeBuild' namespace='/build/admin' buildKey=build.key returnUrl='${req.contextPath}/start.action' /]">[@ui.icon type="build-enable" text="Enable '${build.name}'"/]</a>
        <a class="asynchronous" id="manualBuild_${build.key}" [#if hideStart]style="display:none;"[/#if] href="${fn.getPlanRunLink(build)}">[@ui.icon type="build-run" text="Run"/]</a>
        <a class="asynchronous" id="stopSingleBuild_${build.key}" [#if hideStopSingle]style="display:none;"[/#if] href="${req.contextPath}/build/admin/ajax/stopPlan.action?planKey=${build.key}">[@ui.icon type="build-stop" text="${stopOneTitle}" /]</a>
        <a class="build-stop_${build.key} asynchronous" id="stopMultipleBuilds_${build.key}" [#if hideStopMultiple]style="display:none;"[/#if]>[@ui.icon type="build-stop" text="${stopAllTitle}" /]</a>
    [/#if]
    [#if fn.hasPlanPermission('WRITE', build)]
        <a id="editBuild:${build.key}" href="${fn.getPlanEditLink(build)}" >[@ui.icon type="build-configure" text="Edit '${build.name}'"/]</a>
    [/#if]
[@cp.dashboardFavouriteIcon plan=build operationsReturnUrl=operationsReturnUrl user=user/]
</div>
[/#macro]

[#-- ============================================================================================== @planList.showBuildResultSummary --]
[#--used for jira bamboo plugin--]
[#macro showBuildResultSummary summary]

<li id="buildResult_${summary.buildResultKey}" class="build_${summary.buildState}">
    <h4>
         <span class="build_result">Build ${summary.buildState}:</span>
            <a href="${baseUrl}/browse/${summary.buildKey}" class="build-project">${(action.getPlan(summary.buildKey).name)!}</a>
            <a href="${baseUrl}/browse/${summary.buildResultKey}" class="build-issue-key">#${summary.buildNumber}</a>
    </h4>

    [@showFullSummaryDetails summary=summary/]

 	[@displayIssues summary=summary /]
</li>
[/#macro]

[#-- ============================================================================================== @planList.displayWideBuildPlansList --]

[#macro displayWideBuildPlansList builds showProject=true]
    <table class="aui" id="dashboard">
        [#if showProject]
            <col width="16px"/>
            <col width="17%"/>
        [/#if]
        <col width="20%" style="min-width: 200px;"/>
        <col width="10%"/>
        <col width=""/>
        <col width=""/>
        <col width=""/>
        <col width="70px"/>
        <thead>
            <tr>
                [#if showProject]
                    <th colspan="2" class="projectColumn">[@ww.text name="dashboard.project"/]</th>
                [/#if]
                <th>[@ww.text name="dashboard.plan"/]</th>
                <th>[@ww.text name="dashboard.build"/]</th>
                <th>[@ww.text name="dashboard.completed"/]</th>
                <th>[@ww.text name="dashboard.tests"/]</th>
                <th>[@ww.text name="dashboard.reason"/]</th>
                <th>&nbsp;</th>
            </tr>
        </thead>

        [#assign currentGroupLabel = ""/]
        [#assign planCount=0/]

        [#list builds as build]
                [#assign latestResultsSummary=build.latestResultsSummary! /]
                [#assign hasBuildResults=(build.latestResultsSummary??&&latestResultsSummary.id??) /]
                [#assign currentProject = build.project /]
                [#assign groupLabel = currentProject.name /]
                [#assign expandedValue = action.getConglomerateCookieValue('bamboo.dash.display.toggles','${currentProject.id}') /]

                [#assign isNewProject = !currentGroupLabel?has_content || (currentGroupLabel?? && groupLabel?? && currentGroupLabel != groupLabel)]
                [#if isNewProject]
                    [#assign planCount=1/]
                    [#if currentGroupLabel?has_content]
                        </tbody>
                    [/#if]

                    <tbody class="projectHeader[#if expandedValue != '0' || !showProject] hidden[/#if]" id="projectHeader${currentProject.id}">
                        [#assign currentGroupLabel = groupLabel/]
                        <tr>
                            [#if showProject]
                                <td class="twixie expand" id="twixie${currentProject.id}">
                                    <a tabindex="0">[@ui.icon type="expand" text="Expand"/]</a>
                                </td>
                                <td>
                                    <a id="viewProject:${currentProject.key}" href="${req.contextPath}/browse/${currentProject.key}" class="projectLink" title="Project Summary">
                                    ${currentGroupLabel}
                                    </a>
                                </td>
                            [/#if]
                            <td>&nbsp;</td>
                            <td colspan="5">
                                <div class="statusMessage">
                                    [@ui.icon type="project-${projectStatusHelper.getCurrentStatus(currentProject.key)}" /]
                                    ${projectStatusHelper.getProjectSummary(currentProject.key)}
                                </div>
                            </td>
                        </tr>
                    </tbody>
                    <tbody class="project${currentProject.id}[#if expandedValue == '0' && showProject] hidden[/#if]">
                [#else]
                    [#assign planCount = planCount + 1/]
                [/#if]

                <tr [#if planCount%2 == 0]class="zebraOverride"[/#if]>

                [#if showProject]
                    [#if isNewProject]
                            <td class="projectSection twixie collapse" id="twixie${currentProject.id}">
                                <a tabindex="0">[@ui.icon type="collapse" text="Collapse"/]</a>
                            </td>
                            <td class="projectSection">
                                <a id="viewProject:${currentProject.key}" href="${req.contextPath}/browse/${currentProject.key}"
                                    class="projectLink alwaysFollow" title="Project Summary">${currentProject.name}</a>
                            </td>
                    [#else]
                            <td class="projectSection" colspan="2">&nbsp;</td>
                    [/#if]
                [/#if]
                <td>
                    <a id="viewBuild:${build.key}" href="${req.contextPath}/browse/${build.key}" [#if build.description?has_content]title="${build.description!?html}"[/#if]>${build.buildName}</a>
                </td>

                [#if hasBuildResults]
                    <td class="planKeySection [#if build.suspendedFromBuilding]Suspended[#else]${latestResultsSummary.buildState}[/#if]">
                        [@cp.currentBuildStatusIcon classes="statusIcon" id="statusSection${build.key}" build=build /]
                        <a  id="latestBuild${build.key}" href="${req.contextPath}/browse/${build.key}/latest" title="[@ww.text name='build.common.latestBuild'/]">#${latestResultsSummary.buildNumber}</a>
                    </td>
                    <td>
                        [#if latestResultsSummary.successful || latestResultsSummary.failed]
                            <span id="lastBuiltSummary${latestResultsSummary.buildKey}" title="${latestResultsSummary.buildCompletedDate?datetime?string('hh:mm a, EEE, d MMM')}">${latestResultsSummary.relativeBuildDate}</span>
                        [#else]
                            <span id="lastBuiltSummary${latestResultsSummary.buildKey}">[@ww.text name='buildResult.completedBuilds.defaultDurationDescription'/]</span>
                        [/#if]
                    </td>
                    <td id="testSummary${latestResultsSummary.buildKey}">
                        ${latestResultsSummary.testSummary}
                    </td>
                    <td>
                        <span id="reasonSummary${latestResultsSummary.buildKey}">${latestResultsSummary.reasonSummary}</span>
                        [#if latestResultsSummary.hasChanges()]
                            <script type="text/javascript">
                                AJS.$(initCommitsTooltip("reasonSummary${latestResultsSummary.buildKey}", "${latestResultsSummary.buildKey}", "${latestResultsSummary.buildNumber}"));
                            </script>
                        [/#if]
                    </td>
                [#else]
                    <td class="planKeySection [#if build.suspendedFromBuilding]Suspended[#else]NeverExecuted[/#if]">
                        [@cp.currentBuildStatusIcon classes="statusIcon" id="statusSection${build.key}" build=build /]
                        <a id="latestBuild${build.key}" href="${req.contextPath}/browse/${build.key}/latest" title="[@ww.text name='build.common.latestBuild'/]">[@ww.text name='build.neverExecuted' /]</a>
                    </td>
                    <td>
                        <span id="lastBuiltSummary${build.key}"></span>
                    </td>
                    <td id="testSummary${build.key}">&nbsp;</td>
                    <td>
                        <span id="reasonSummary${build.key}">&nbsp;</span>
                    </td>
                [/#if]
                <td>
                    [@planOperations build/]
                </td>
            </tr>
            [/#list]
        </tbody>
    </table>

    <script type="text/javascript">
        [#if showProject]
        [#-- attach event handlers to the expand collapse twixies --]
        AJS.$(document).delegate("#dashboard > tbody > tr > .twixie > a", "click", function (e) {
            var $twixie = AJS.$(this).closest("td");
            if ($twixie.hasClass("collapse")) {
               collapseProject($twixie);
            } else {
               expandProject($twixie)
            }
        });

        [#-- Bind collapse/expand all events --]
        AJS.$("#allPlansToggler a.collapseAll").click(collapseAllProjects);
        AJS.$("#allPlansToggler a.expandAll").click(expandAllProjects);

        [#--Collapsing/Expanding functions--]
        function collapseAllProjects() {
            AJS.$("#dashboard > tbody > tr > .twixie").each(function() {
                  collapseProject(AJS.$(this));
            });
        }
        function expandAllProjects() {
            AJS.$("#dashboard > tbody > tr > .twixie").each(function() {
                 expandProject(AJS.$(this));
            });
        }
        function collapseProject ($twixie) {
            var projectId = $twixie.attr("id").replace("twixie", "");
            if (projectId.length) {
                AJS.$("tbody.project" + projectId).hide();
                AJS.$("tbody#projectHeader" + projectId).show();
                saveToConglomerateCookie(BAMBOO_DASH_DISPLAY_TOGGLES, projectId, '0');
            }
        }
        function expandProject ($twixie) {
            var projectId = $twixie.attr("id").replace("twixie", "");
            if (projectId.length) {
                AJS.$("tbody.project" + projectId).show();
                AJS.$("tbody#projectHeader" + projectId).hide();
                saveToConglomerateCookie(BAMBOO_DASH_DISPLAY_TOGGLES, projectId, null);
            }
        }
        [/#if]
        [#-- initiate async manager for operations (handles e.g. inline stopping/starting of builds) --]
        AJS.$(function() {
            AsynchronousRequestManager.init(".asynchronous", null, function () {
                updatePlans();
            });
        });

        setTimeout(function () { updatePlans(0); }, BAMBOO.reloadDashboardTimeout * 1000);
        BAMBOO.reloadDashboard = true;
    </script>
[/#macro]