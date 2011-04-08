[#assign maxChanges = 2 /]
[@ww.url value='/browse/${buildResultsSummary.buildResultKey}/commit' id='changeUrl' /]

[#if buildResultsSummary.commits?has_content]
    <ul>
    [#assign commitToUrls = linkGenerator.getWebRepositoryUrlForCommits(buildResultsSummary.commits, plan.buildDefinition.repository) /]
    [#list buildResultsSummary.commits as commit]
        [#if commit_index gte maxChanges && changeUrl??]
            [#break]
        [/#if]
        <li>
            [#if "Unknown" != commit.author.name && commitToUrls.containsKey(commit)]
                [#assign commitUrl = commitToUrls.get(commit) /]
                [#assign guessedRevision = commit.guessChangeSetId()!("")]
                [#if commitUrl?has_content && guessedRevision?has_content]
                    <a href="${commitUrl}" class="rightFloat" title="View change set in FishEye">(${guessedRevision})</a>
                [/#if]
            [/#if]
            <img class="profileImage" src="[@ui.displayUserGravatar userName=(commit.author.linkedUserName)! size='25'/]" />
            <h3>
                <a href="[@cp.displayAuthorOrProfileLink author=commit.author /]">[@ui.displayAuthorFullName author=commit.author /]</a>
            </h3>
            <p>
                [@ui.renderValidJiraIssues commit.comment  buildResultsSummary /] &nbsp;
            </p>
        </li>
    [/#list]
    </ul>
    [#if buildResultsSummary.commits.size() gt maxChanges]
            <p class="moreLink">
                <a href='${changeUrl}'>
                    [@ww.text name='buildResult.changes.files.more' ][@ww.param name="value" value="${buildResultsSummary.commits.size() - maxChanges}"/][/@ww.text]
                </a>
            </p>
    [/#if]
[/#if]
