[#-- @ftlvariable name="action" type="com.atlassian.bamboo.rest.GetRecentlyCompletedBuildResultsForBuild" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.rest.GetRecentlyCompletedBuildResultsForBuild" --]
<response>
[#if resultsList?has_content]
    [#list resultsList as result]
    <build>
        [@api.buildResult buildSummary=result planManager=planManager /]
    </build>
    [/#list]
[/#if]
</response>