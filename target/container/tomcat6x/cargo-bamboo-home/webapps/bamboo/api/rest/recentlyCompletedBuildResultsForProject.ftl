[#-- @ftlvariable name="action" type="com.atlassian.bamboo.rest.GetRecentlyCompletedBuildResultsForProject" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.rest.GetRecentlyCompletedBuildResultsForProject" --]
<response>
[#if resultsList?has_content]
    [#list resultsList as result]
    <build>
        [@api.buildResult buildSummary=result planManager=planManager /]
    </build>
    [/#list]
[/#if]
</response>