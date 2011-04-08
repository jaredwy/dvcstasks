[#-- @ftlvariable name="action" type="com.atlassian.bamboo.webwork.ViewTelemetryAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.webwork.ViewTelemetryAction" --]
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Status Summary Screen - [#if instanceName?has_content]${instanceName?html}[#else]Atlassian Bamboo[/#if]</title>
    <meta http-equiv="X-UA-Compatible" content="IE=EDGE" />

    <meta http-equiv="Pragma" content="no-cache"/>
    <meta http-equiv="Expires" content="-1"/>

    <meta name="decorator" content="none"/>

    <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;"/>
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent"/>

    ${webResourceManager.requireResourcesForContext("atl.telemetry")}
    ${webResourceManager.requiredResources}
</head>
<body>
[#if filteredBuilds.size() > 0 && filteredBuilds.size() < 6]
    [#assign buildWidth = "100%"]
[#elseif filteredBuilds.size() > 5 && filteredBuilds.size() < 9]
    [#assign buildWidth = "50%"]
[#elseif filteredBuilds.size() > 8 && filteredBuilds.size() < 13]
    [#assign buildWidth = "33.33%"]
[/#if]
[#if filteredBuilds.size() < 1]
<div class="no-builds">
    <h3>Bamboo has found no builds to display</h3>
    (this could be due to a filter or viewing permissions)
</div>
[#else]
    [#list filteredBuilds as build]
        [#if build.latestResultsSummary??]
        <div class="build"[#if buildWidth??] style="width: ${buildWidth};"[/#if]>
            <div class="result ${build.latestResultsSummary.buildState} [#if !build.executing]executing[/#if]">
                <div class="plan-name">
                    <span class="icon">
                    [#if build.latestResultsSummary.buildState == "Successful"]
                        &#10004;
                    [#else]
                        &#10008;
                    [/#if]
                    </span>
                    ${build.buildName}
                </div>
                <div class="build-details">
                    [#if build.executing]
                    <div class="indicator">
                        <div id="${build.key}-spinner" class="spinner"></div>
                    </div>
                    [/#if]
                    <div class="project-name">${build.project.name}</div>
                    <div class="time">${build.latestResultsSummary.relativeBuildDate?if_exists}</div>
                </div>
                <div class="details-ext">
                    <div class="details-ext-content">
                        <table>
                            <tr>
                                <th>Tests:</th>
                                [#if build.hasTests()]
                                    <td>${build.latestResultsSummary.testSummary}</td>
                                [#else]
                                    <td>[@ww.text name='buildResult.completedBuilds.noTests'/]</td>
                                [/#if]
                            </tr>
                            <tr>
                                <th>Duration:</th>
                                <td>${durationUtils.getPrettyPrint(build.averageBuildDuration)}</td>
                            </tr>
                            <tr>
                                <th>Changes:</th>
                                [#if build.latestResultsSummary.getChangesListSummary() != ""]
                                    <td>${build.latestResultsSummary.getChangesListSummary()}</td>
                                [#else]
                                    <td>No changes</td>
                                [/#if]
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <div class="reason">${build.latestResultsSummary.reasonSummary?if_exists}</div>
        </div>
        [/#if]
    [/#list]
[/#if]
</body>
</html>