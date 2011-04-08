[#-- @ftlvariable name="action" type="com.atlassian.bamboo.rest.GetLatestBuildResultsForProject" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.rest.GetLatestBuildResultsForProject" --]
<response>
    [#if builds??]
    [#list builds as build]
        [#if (build.latestResultsSummary)??]
        <build>
            [@api.buildResult buildSummary=build.latestResultsSummary planManager=planManager /]
        </build>
        [/#if]
    [/#list]
    [/#if]
</response>