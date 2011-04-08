[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.ViewBuildResultsTable" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.ViewBuildResultsTable" --]
[#--used for jira bamboo plugin, when the builds by date tab is selected --]
[#import "/fragments/plan/displayWideBuildPlansList.ftl" as planList]

[#if resultsList?has_content]
    [#if resultsList.size() > 1]
    <p class="build_result_count">
        [#if maxBuilds?has_content && (resultsList?size > maxBuilds)]
           Showing ${maxBuilds} of ${resultsList?size} builds.
        [#else]
           Showing ${resultsList?size} of ${resultsList?size} builds.
        [/#if]
    </p>
    [/#if]
    <ol class="build_result_list">
    [#list resultsList as summary]
        [#if maxBuilds?has_content && summary_index == maxBuilds]
            [#break]
        [/#if]
        [@planList.showBuildResultSummary summary=summary/]
    [/#list]
    </ol>

[/#if]
