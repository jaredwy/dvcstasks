[#-- @ftlvariable name="pager" type="com.atlassian.bamboo.filter.Pager" --]

[#macro showBuildResultsTable pager showAgent showOperations showArtifacts sort showPager=true showHeader=true showDuration=true useRelativeDate=false showFullBuildName=true]
[#assign extraColumns  = 0 /]

[#if (pager.page.list)?has_content]
    <table id="buildResultsTable" class="aui">
        <thead[#if !showHeader] class="assistive"[/#if]>
            <tr>
                <th>[@ww.text name='buildResult.completedBuilds.status'/]</th>
                <th>[@ww.text name='buildResult.completedBuilds.reason'/]</th>
                <th>[@ww.text name='buildResult.completedBuilds.completionTime'/]</th>
                [#if showDuration]
                    <th>[@ww.text name='buildResult.completedBuilds.duration'/]</th>
                [/#if]
                [#if showAgent]
                    [#assign extraColumns = extraColumns + 1 /]
                    <th>[@ww.text name="buildResult.completedBuilds.agent"/]</th>
                [/#if]
                <th>[@ww.text name='buildResult.completedBuilds.testResults'/]</th>
                [#if showArtifacts]
                    [#assign extraColumns = extraColumns + 1 /]
                    <th>[@ww.text name='buildResult.completedBuilds.artifacts'/]</th>
                [/#if]
                [#if showOperations && fn.hasPlanPermission('WRITE', plan)]
                    [#assign extraColumns = extraColumns + 1 /]
                    <th></th>
                [/#if]
            </tr>
        </thead>
        [#if showPager]
        <tfoot>
            [#if (pager.page)?has_content]
                <tr>
                    <td colspan="${6 + extraColumns}">
                        [@cp.pagination /]
                    </td>
                </tr>
            [/#if]
        </tfoot>
        [/#if]
        <tbody>
        [#list pager.page.list as buildResult]
            <tr>
                <td class="${buildResult.buildState}">
                    [#if showFullBuildName]
                        [@ui.icon '${buildResult.buildState?lower_case}'/]
                        <a href="${req.contextPath}/browse/${buildResult.plan.project.key}">${buildResult.plan.project.name}</a> &rsaquo;

                        [#assign plan=buildResult.plan]
                        [#if plan.type == 'CHAIN']
                            <a href="${req.contextPath}/browse/${buildResult.plan.key}" [#if plan.description?has_content]title="${plan.description}"[/#if]>${buildResult.plan.buildName}</a> &rsaquo;
                        [#elseif plan.type == 'JOB']
                            [#assign chainSummary=buildResult.chainResultsSummary]
                            <a href="${req.contextPath}/browse/${chainSummary.plan.key}" [#if plan.parent.description?has_content]title="${plan.parent.description}"[/#if]>${plan.parent.buildName}</a> &rsaquo;
                        [/#if]

                        [#assign planResult=buildResult]
                        [#if plan.type == 'JOB']
                            [#assign planResult=buildResult.chainResultsSummary]
                        [/#if]

                        <a href="${req.contextPath}/browse/${planResult.planResultKey}">#${planResult.planResultKey.buildNumber}</a>

                        [#if plan.type == 'JOB']
                            &rsaquo;
                            <a href="${req.contextPath}/browse/${buildResult.planResultKey}">${buildResult.plan.buildName}</a>
                        [/#if]
                    [#else]
                        <a class="statusIndicator" id="buildResult_${buildResult.planResultKey}" href="${req.contextPath}/browse/${buildResult.planResultKey}" title="${buildResult.buildState}">[@ui.icon type=buildResult.buildState /] #${buildResult.buildNumber}</a>
                    [/#if]
                    [@cp.commentIndicator buildResultsSummary=buildResult /]
                </td>
                <td>
                    <span id="commits_${buildResult.buildResultKey}" class="commits">${buildResult.reasonSummary}</span>
                    [#if buildResult.hasChanges()]
                        <script type="text/javascript">
                            addUniversalOnload(function(){
                                initCommitsTooltip("commits_${buildResult.buildResultKey}", "${buildResult.buildKey}", "${buildResult.buildNumber}")
                            });
                        </script>
                    [/#if]
                </td>

                [#if buildResult.buildCompletedDate?has_content ]
                    [#assign buildDate=buildResult.buildCompletedDate?datetime?string("EEE, d MMM, hh:mm a")]
                [#else]
                    [#assign buildDate]
                        [@ww.text name='buildResult.completedBuilds.defaultDurationDescription'/]
                    [/#assign]
                [/#if]

                [#if useRelativeDate]
                    <td title="${buildDate}">${buildResult.relativeBuildDate}</td>
                [#else]
                    <td title="${buildResult.relativeBuildDate}">${buildDate}</td>
                [/#if]

                [#if showDuration]
                    <td>${buildResult.durationDescription}</td>
                [/#if]

                [#if showAgent]
                    <td>
                        [#if buildResult.buildAgentId??]
                            [#assign pipelineDefinition = action.getPipelineDefinitionByBuildResult(buildResult)! /]
                            [#if pipelineDefinition?has_content]
                                [@ui.renderPipelineDefinitionNameLink pipelineDefinition/]
                            [#else]
                                (${buildResult.buildAgentId})
                            [/#if]
                        [/#if]
                    </td>
                [/#if]

                <td>
                    [#if buildResult.plan.hasTests()]
                        <a href="${req.contextPath}/browse/${buildResult.planResultKey}/test">${buildResult.testSummary}</a>
                    [#else]
                        [@ww.text name='buildResult.completedBuilds.noTests'/]
                    [/#if]
                </td>
                [#if showArtifacts]
                <td>
                    [#assign artifactLinks=buildResult.artifactLinksThatExist!/]
                    [#if artifactLinks?has_content]
                        [#assign artifactCount=0/]
                        [#list artifactLinks as artifactLink]
                            [#if artifactLink.url?has_content]
                                <div><a href="${req.contextPath}${artifactLink.url}">${artifactLink.label?html}</a></div>
                                [#assign artifactCount=artifactCount + 1 /]
                                [#if artifactCount > 2]
                                    [#break]
                                [/#if]
                            [/#if]
                        [/#list]
                        [#if artifactCount < artifactLinks.size()]
                            [@ww.text name='buildResult.completedBuilds.moreArtifacts'][@ww.param value=artifactLinks.size() - artifactCount/][/@ww.text]
                        [/#if]
                    [#else]
                        [@ww.text name='buildResult.completedBuilds.noArtifacts'/]
                    [/#if]
                </td>
                [/#if]
                [#if showOperations && fn.hasPlanPermission('WRITE', buildResult.plan)]
                <td class="operationsColumn">

                    [@ww.url id='deleteUrl' namespace='/build/admin' action='deletePlanResults' buildNumber='${buildResult.buildNumber}' buildKey='${plan.key}'/]
                        <a class="deleteLink" id="deleteBuildResult_${buildResult.plan.key}-${buildResult.buildNumber}"
                           href="${deleteUrl}"
                           title="Delete the build results"
                           onclick="return confirm('[@ww.text name="buildResult.completedBuilds.confirmDelete"/]');">[@ww.text name='global.buttons.delete'/]
                        </a>
                </td>
                [/#if]
            </tr>
        [/#list]
        </tbody>
    </table>
[#else]
    <p>[@ww.text name='buildResult.completedBuilds.noBuilds'/]</p>
[/#if]
[/#macro]
