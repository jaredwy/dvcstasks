[#-- @ftlvariable name="action" type="com.atlassian.bamboo.rest.GetLatestBuildResults" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.rest.GetLatestBuildResults" --]
<response>
[#if (plan.latestResultsSummary)??]
    [@api.buildResult buildSummary=plan.latestResultsSummary planManager=planManager /]
[/#if]
</response>