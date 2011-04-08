[#-- @ftlvariable name="action" type="com.atlassian.bamboo.rest.GetLatestBuildsByUser" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.rest.GetLatestBuildsByUser" --]
<response>
[#if author.triggeredBuildResults?has_content]
    [#list author.triggeredBuildResults as buildSummary]
    <build>
        [@api.buildResult buildSummary=buildSummary planManager=planManager /]
        <buildCommitComment>[#if buildSummary.commits?has_content][#list buildSummary.commits as commit]${action.sanitizeXml(commit.comment)}[/#list][/#if]</buildCommitComment>
    </build>
    [/#list]
[/#if]
</response>