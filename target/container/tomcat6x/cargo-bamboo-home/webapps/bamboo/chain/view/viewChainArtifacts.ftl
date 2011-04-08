[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainArtifacts" --]
[#-- @ftlvariable name="resultsSummary" type="com.atlassian.bamboo.chains.ChainResultsSummary" --]

<head>
    <title>[@ui.header pageKey='chain.artifacts.header' object='${plan.name} ${chainResultNumber}' title=true /]</title>
    <meta name="tab" content="artifacts"/>
</head>
<body>

[#assign sharedArtifactsFound = action.hasSharedArtifacts(resultsSummary)/]
[#assign jobArtifactsFound = action.hasJobArtifacts(resultsSummary)/]

[@dj.simpleDialogForm
    triggerSelector="#removeAllArtifacts"
    actionUrl="/ajax/confirmRemoveAllArtifacts.action?planKey=${planKey}&buildNumber=${buildNumber}"
    width=400 height=200
    submitLabelKey="global.common.yes"
/]

[#if fn.hasPlanPermission('ADMINISTRATION', chain) && (sharedArtifactsFound || jobArtifactsFound)]
    [#assign description = "chain.artifacts.description"/]
    [#assign artifactTools]
        <ul class="toolbar-group">
            <li class="toolbar-item">
                <a id="removeAllArtifacts"
                   title="[@ww.text name='artifact.removeAll.title'/]"
                   class="toolbar-trigger">[@ww.text name='artifact.removeAll'/]</a>
            </li>
        </ul>
    [/#assign]
[/#if]
[#if resultsSummary.active]
    [#assign description = "chain.artifacts.description.running"/]
[#else]
    [#if !sharedArtifactsFound && !jobArtifactsFound]
        [#assign description = "chain.artifacts.not.found.description"/]
    [/#if]
[/#if]

[@ui.bambooPanel titleKey='chain.artifacts.header' cssClass='form-view-header' descriptionKey=description auiToolbar=artifactTools headerWeight='h1' /]

[#assign contentFound = false/]
[#assign finishedBuildFound = action.hasFinishedJobs(resultsSummary)/]

[#if sharedArtifactsFound]
    <h2>[@ww.text name='chainResult.artifacts.shared.title'/]</h2>
    <div class="artifactDescription">[@ww.text name="buildResult.artifacts.shared.description"/][@help.icon pageKey='artifacts.shared.description' /]</div>
    [@ui.bambooPanel]
        [@renderArtifactTable shared=true/]
    [/@ui.bambooPanel]
[/#if]

[#if jobArtifactsFound]
    <h2>[@ww.text name='chainResult.artifacts.job.title'/]</h2>
    <div class="artifactDescription">[@ww.text name="buildResult.artifacts.job.description"/][@help.icon pageKey='artifacts.description' /]</div>
    [@ui.bambooPanel]
        [@renderArtifactTable shared=false/]
    [/@ui.bambooPanel]
[/#if]

[@ui.renderWebPanels 'plan.result.artifacts'/]
</body>

[#macro renderArtifactTable shared]
[#assign contentFound = true/]
[#assign hasAdminPermission = fn.hasPlanPermission('ADMINISTRATION', chain)/]
<table class="aui artifact">
    <colgroup>
        <col width="30%"/>
        <col />
        <col width="15%"/>
    </colgroup>
    <thead>
        <tr>
            <th>[@ww.text name="chain.artifacts.job"/]</th>
            <th>[@ww.text name="chain.artifacts.table.header"/]</th>
            <th>[@ww.text name="chain.artifacts.size"/]</th>
        </tr>
    </thead>
    [#list resultsSummary.stageResults as stageResult]
        [#list stageResult.getSortedBuildResults() as buildResult]
            [#if buildResult.finished]
                [#assign finishedBuildFound = true/]
            [/#if]
            [#if shared]
                [#assign artifactLinks = action.getSharedArtifactLinks(buildResult)!/]
            [#else]
                [#assign artifactLinks = action.getJobArtifactLinks(buildResult)!/]
            [/#if]
            [#if artifactLinks?has_content]
                <tbody>
                [#list artifactLinks as artifact]
                    <tr>
                        [#if artifact_index == 0]
                            <th rowspan="${artifactLinks.size()}">
                                <a href="${req.contextPath}/browse/${buildResult.planResultKey.key}/artifact" class="artifactJobLink">${buildResult.plan.buildName}</a>
                                <span class="subGrey">${stageResult.name}</span>
                            </th>
                        [/#if]
                        <td>
                            [#if shared]
                                [@ui.icon type="artifact-shared"/]
                            [#else]
                                [@ui.icon type="artifact"/]
                            [/#if]
                            [#if artifact.exists]
                                <a href="${req.contextPath}${artifact.url}">${artifact.label?html}</a>
                            [#else]
                                <span class="grey">${artifact.label?html}</span>
                            [/#if]
                        </td>
                        <td>
                            [#if artifact.exists]
                                [#if artifact.sizeDescription??]
                                    <span class="subGrey">${artifact.sizeDescription}</span>
                                [/#if]
                            [#else]
                                <span class="subGrey">[@ww.text name='buildResult.artifacts.not.exists' /]</span>
                            [/#if]
                        </td>
                    </tr>
                [/#list]
                </tbody>
            [/#if]
        [/#list]
    [/#list]

    [#if shared]
        [#assign artifactLinks = action.getOrphanedArtifactLinks(resultsSummary)!/]
        [#if artifactLinks?has_content]
            <tbody>
            [#list artifactLinks as artifact]
                <tr>
                    [#if artifact_index == 0]
                        <td rowspan="${artifactLinks.size()}">
                            <span class="grey">[@ww.text name="artifact.deletedJob"/]</span>
                        </td>
                    [/#if]
                    <td>
                        [@ui.icon type="artifact-shared"/]
                        [#if artifact.exists]
                            <a href="${req.contextPath}${artifact.url}">${artifact.label?html}</a>
                        [#else]
                            <span class="grey">${artifact.label?html}</span>
                        [/#if]
                    </td>
                    <td>
                        [#if artifact.exists]
                            [#if artifact.sizeDescription??]
                                <span class="subGrey">${artifact.sizeDescription}</span>
                            [/#if]
                        [#else]
                            <span class="subGrey">[@ww.text name='buildResult.artifacts.not.exists' /]</span>
                        [/#if]
                    </td>
                </tr>
            [/#list]
            </tbody>
        [/#if]
    [/#if]
</table>
[/#macro]
