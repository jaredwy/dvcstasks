[#-- @ftlvariable name="builds" type="java.util.Collection<com.atlassian.bamboo.plan.TopLevelPlan>" --]

[#-- ========================================================================-===================== @cp.displayBuildPlansList--]
[#macro displayBuildPlansList id builds showProject=true]

<div id="${id}section" class="narrowPlanList">
[#list builds as build]
[#assign latestBuildSummary=build.latestResultsSummary! /]
[#assign hasBuildResults=(latestBuildSummary.id)?exists /]

[#-- FTL Code for grouping --]
[#assign groupLabel = build.project.name /]

[#if currentGroupLabel?exists && groupLabel?exists && currentGroupLabel != groupLabel]
      </ul>
      </div>
      [@ui.clear /]
[/#if]
[#if groupLabel?exists && (!currentGroupLabel?has_content || (currentGroupLabel?exists && currentGroupLabel != groupLabel))]
    [#assign currentGroupLabel = groupLabel/]
    [#assign currentProject = build.project /]
    [#assign expandedValue = action.getConglomerateCookieValue('bamboo.dash.display.toggles','${id}_${build.project.id}') /]
     <div id="${id}_project_${currentProject.id}_section" class="projectSection">
     <a id="${id}_${currentProject.id}" class="projectLabel" name="${currentProject.name}"></a>

     <div id="${id}_${currentProject.id}_toggler_on" class="buildListProjectHeader headerOpen" style="[#if expandedValue == '0']display:none[/#if]">
        <a class="projectDisplayToggler">Collapse</a>
        <a id="viewProject:${currentProject.key}" href="${req.contextPath}/browse/${currentProject.key}" title="Project Summary" class="projectLink alwaysFollow">
            ${currentGroupLabel}
        </a>
    </div>
    <div id="${id}_${currentProject.id}_toggler_off" class="buildListProjectHeader headerClosed"  style="[#if expandedValue != '0']display:none[/#if]"> <!--to prevent flicking -->
        <a class="projectDisplayToggler">Expand</a>
        <a id="viewProject:${currentProject.key}" href="${req.contextPath}/browse/${currentProject.key}"
           class="projectLink alwaysFollow" title="Project Summary">
            ${currentGroupLabel}
        </a>
        <span class="projectHeaderSummary"> - ${projectStatusHelper.getProjectSummary(currentProject.key)}</span>
    </div>
    <ul class="buildList" id="${id}_${currentProject.id}_target" style="[#if expandedValue == '0']display:none[/#if]">
[/#if]

<li class="buildListItem">
    <div class="buildListItemOperations">
        [#assign operationsReturnUrl='${currentUrl}' /]
        <!-- operations -->
        [#if fn.hasPlanPermission('BUILD', build) ]
            [#if build.suspendedFromBuilding]
                <a id="${id}resumeBuild:${build.key}" href="${req.contextPath}/build/admin/resumeBuild.action?buildKey=${build.key}">[@ui.icon type="build-enable" text="Enable Build"/]</a>
            [#else]
                [#if build.active]
                    <a id="${id}stopBuild_${build.key}" class="asynchronous" href="${fn.getPlanStopLink(build)}">[@ui.icon type="build-stop" text="Stop Build"/]</a>
                [#else]
                    <a id="${id}manualBuild_${build.key}" class="asynchronous" href="${fn.getPlanRunLink(build)}">[@ui.icon type="build-run" text="Checkout &amp; Build"/]</a>
                [/#if]
            [/#if]
        [/#if]
        [#if fn.hasPlanPermission('WRITE', build) ]
            <a id="${id}editBuild:${build.key}" accesskey="E" href="${fn.getPlanEditLink(build)}"><img src="${req.contextPath}/images/jt/icn_edit.gif" border="0" hspace="2" alt="Edit Build" title="Edit Build"></a>
        [/#if]
        [@cp.favouriteIcon plan=build operationsReturnUrl=operationsReturnUrl user=user/]
    </div>

    <!-- summary icon -->
    <div class="buildListStatusIcon">
        [@cp.currentBuildStatusIcon build=build /]
    </div>

    <div class="buildListItemHeader [#if build.suspendedFromBuilding]Suspended[#elseif latestBuildSummary?has_content]${latestBuildSummary.buildState}[#else]NeverExecuted[/#if]">
    <!-- plan -->
        <a id="${id}viewBuild:${build.key}"
           href="${req.contextPath}/browse/${build.key}" [#if build.description?has_content]title="${build.description!?html}"[/#if]>${build.buildName}</a>
    <!-- latest build -->
        &rsaquo;
        [#if hasBuildResults]
        <a id="${id}latestBuild:${build.key}:${latestBuildSummary.buildNumber}"
           href="${req.contextPath}/browse/${build.key}/latest" title="[@ww.text name='build.common.latestBuild'/]">#${latestBuildSummary.buildNumber}</a>
            [#-- reason for switching off: atm not good enough for dashboard [@cp.commentIndicator buildResultsSummary=latestBuildSummary /] --]
        [#else]
            [@ww.text name='build.neverExecuted' /]
        [/#if]
    </div>

    [#if hasBuildResults]
    <div class="buildListItemDetails">
    <ul>
    <!-- Last Build Time-->
            <li>Ran: ${latestBuildSummary.relativeBuildDate}</li>
    <!-- Reason -->
            <li>
                <span id="${id}reasonForBuild${build.key}">
                    ${latestBuildSummary.reasonSummary}
                </span>
                [#if (latestBuildSummary.changesListSummary)?has_content]
                    [@dj.tooltip target="${id}reasonForBuild${build.key}" text=latestBuildSummary.changesListSummary][/@dj.tooltip]
                [/#if]
            </li>
    <!-- Duration -->
            <li>Duration: ${latestBuildSummary.durationDescription}</li>

    <!-- test count summary -->
            <li class="last">
                Tests:
                ${latestBuildSummary.testSummary}
            </li>
    </ul>
    </div>
    [/#if]
</li>
[/#list]
[#if currentGroupLabel?has_content]
    </ul>
     </div>
[/#if]

<div class="clearer"></div>
</div>
[/#macro]
