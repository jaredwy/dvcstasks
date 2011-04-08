[#-- ========================================================================================= @cp.displayBuildSummaries
     Simple no JS view of the all plan summaries. Used by JS views and functional tests
--]
[#-- @ftlvariable name="builds" type="java.util.Collection<com.atlassian.bamboo.plan.TopLevelPlan>" --]


[#macro displayBuildSummaries builds showProject=true]
<table id="summary" class="grid" width="100%">
<tr>
    <th>Status</th>
    <th>[#if showProject]Project - [/#if]Plan</th>
    <th>Latest Completed Build</th>
    <th>Last Ran</th>
    <th>Reason</th>
    <th>Duration</th>
    <th>Test Count</th>
    <th>Operations</th>
</tr>
[#list builds as build]

[#assign latestBuildSummary=build.latestResultsSummary! /]
[#assign hasBuildResults=(latestBuildSummary.id)?? /]
[#-- FTL Code for grouping
    [#assign groupLabel = build.project.name /]
    [#if (!currentGroupLabel?has_content || currentGroupLabel?exists && currentGroupLabel != groupLabel) && build.project.builds.size() > 1]
        [#assign currentGroupLabel = groupLabel/]
        <tr>
            <td>${currentGroupLabel}</td>
        </tr>
    [/#if]
--]
<tr class="[#if build.suspendedFromBuilding]Suspended[#elseif latestBuildSummary?has_content]${latestBuildSummary.buildState}[#else]NeverExecuted[/#if]">
    <!-- summary icon -->
    <td>
        [@cp.currentBuildStatusIcon build=build /]
    </td>
    <!-- plan -->
    <td>
        [#if showProject]
        <a id="viewProject:${build.project.key}"
           href="${req.contextPath}/browse/${build.project.key}" title="Project Summary">${build.project.name}</a>
        -
        [/#if]
        <a id="viewBuild:${build.key}"
           href="${req.contextPath}/browse/${build.key}" [#if build.description?has_content]title="${build.description!?html}[/#if]">${build.buildName}</a>
    </td>
    <!-- latest build -->
    <td>
        [#if hasBuildResults]
        <a id="latestBuild:${build.key}:${latestBuildSummary.buildNumber}"
           href="${req.contextPath}/browse/${build.key}/latest"  title="[@ww.text name='build.common.latestBuild'/]">${latestBuildSummary.buildResultKey}</a>
        [#-- reason for switching off: atm not good enough for dashboard [@cp.commentIndicator buildResultsSummary=latestBuildSummary /] --]
        [#else]
            [@ww.text name='build.neverExecuted' /]
        [/#if]
    </td>
    <!-- Last Build Time-->
    <td>
        [#if hasBuildResults]
            ${latestBuildSummary.relativeBuildDate}
        [#else]
            &nbsp;
        [/#if]
    </td>

    <!-- Reason -->
    <td>
        [#if hasBuildResults]
            [#if latestBuildSummary.triggerReason.name == "Code has changed" ]
                <span id="reasonForBuild${build.key}">
                    ${latestBuildSummary.reasonSummary}
                </span>
                [@dj.tooltip target="reasonForBuild:${build.key}" text=latestBuildSummary.changesListSummary]
                [/@dj.tooltip]
            [#else]
                ${latestBuildSummary.reasonSummary}
            [/#if]
        [#else]
            &nbsp;
        [/#if]
    </td>
    <!-- Duration -->
    <td>
        [#if hasBuildResults]
            ${latestBuildSummary.durationDescription}
        [/#if]
    </td>

    <!-- test count summary -->
    <td>
    [#if hasBuildResults]
        [#if build.hasTests()]
                        ${latestBuildSummary.testSummary}
        [#else]
            [@ww.text name='buildResult.completedBuilds.noTests'/]
        [/#if]
    [/#if]
    </td>
    <!-- operations -->
    <td class="operations">
        [#if fn.hasPlanPermission('BUILD',build) ]
            [#if build.suspendedFromBuilding]
                <a id="resumeBuild:${build.key}" href="${req.contextPath}/build/admin/resumeBuild.action?buildKey=${build.key}&returnUrl=${req.contextPath}/start.action">[@ui.icon type="build-enable" text="Enable Build"/]</a>
            [#else]
                [#if build.active]
                    <a id="stopBuild_${build.key}" href="${req.contextPath}/build/admin/stopPlan.action?planKey=${build.key}" class="build-stop" title="[@ww.text name='agent.build.cancel' /]">[@ww.text name='agent.build.cancel' /]</a>
                [#else]
                    <a id="manualBuild_${build.key}" href="${req.contextPath}/build/admin/triggerManualBuild.action?buildKey=${build.key}">[@ui.icon type="build-run" text="Checkout &amp; Build"/]</a>
                [/#if]
            [/#if]
        [/#if]
        [#if fn.hasPlanPermission('WRITE', build) ]
            <a id="editBuild:${build.key}" accesskey="E" href="${req.contextPath}/build/admin/edit/editBuildConfiguration.action?buildKey=${build.key}"><img src="${req.contextPath}/images/jt/icn_edit.gif" border="0" hspace="2" align="left" alt="Edit Build" title="Edit Build"></a>
        [/#if]
        [#if user??]
            [@cp.favouriteIcon plan=build operationsReturnUrl=currentUrl user=user/]
        [/#if]
    </td>
</tr>
[/#list]
</table>
[/#macro]
