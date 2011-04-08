[#-- @ftlvariable name="action" type="com.atlassian.bamboo.rest.GetLatestUserBuilds" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.rest.GetLatestUserBuilds" --]
<response>
    [#if builds?exists]
    [#list builds as build]
    <build>
        <name>${build.name}</name>
        <key>${build.key}</key>
        <state>${build.currentStatus?if_exists}</state>
        <buildNumber>${build.lastBuildNumber?if_exists}</buildNumber>
        <failedTestCount>${(build.latestBuildSummary.failedTestCount)?if_exists}</failedTestCount>
        <successfulTestCount>${(build.latestBuildSummary.successfulTestCount)?if_exists}</successfulTestCount>
        <buildTime>${(build.latestBuildSummary.buildTime)?if_exists}</buildTime>
    </build>
    [/#list]
    [/#if]
</response>