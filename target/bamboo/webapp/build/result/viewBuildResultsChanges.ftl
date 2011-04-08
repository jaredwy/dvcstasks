[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ViewNextBuildResults" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ViewNextBuildResults" --]
<html>
<head>
	<title> [@ui.header pageKey='buildResult.changes.title' object='${plan.name} ${resultsSummary.buildNumber}' title=true/] </title>
    <meta name="tab" content="changes"/>
</head>

<body>
    <div id="fullChanges">
            [#if changeUrl?exists]<a href="${changeUrl}">[/#if][@ui.header pageKey='buildResult.changes.title' /][#if changeUrl?exists]</a>[/#if]
            [#if resultsSummary.skippedCommitsCount gt 0]
            <div class="infoMessage">
                [@ww.text name='buildResult.changes.files.skipped' ]
                    [@ww.param name="value" value="${resultsSummary.commits.size()}"/]
                    [@ww.param name="value" value="${resultsSummary.commits.size() + resultsSummary.skippedCommitsCount}"/]
                [/@ww.text]
            </div>
        [/#if]
        <p class="triggerDescription">
            ${action.getTriggerReasonLongDescriptionHtml(resultsSummary)}
        </p>
        [#if plan.buildDefinition.webRepositoryViewer?has_content]
            ${plan.buildDefinition.webRepositoryViewer.getHtmlForCommitsFull(resultsSummary, plan.buildDefinition.repository)}
        [#else]
            [#include "../../templates/plugins/webRepository/noWebRepositoryView.ftl" /]
        [/#if]
    </div>

</body>
</html>
