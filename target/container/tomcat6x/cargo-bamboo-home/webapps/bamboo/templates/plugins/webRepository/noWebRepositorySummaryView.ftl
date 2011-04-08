[#assign maxChanges = 2 /]

[#if buildResultsSummary.commits?has_content]
    <ul>
    [#list buildResultsSummary.commits as commit]
        [#if commit_index gte maxChanges && changeUrl?exists]
            [#break]
        [/#if]
        <li>
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
    [#if changeUrl?exists && buildResultsSummary.commits.size() gt maxChanges]
        <p class="moreLink">
            <a href='${changeUrl}'>
                [@ww.text name='buildResult.changes.files.more' ][@ww.param name="value" value="${buildResultsSummary.commits.size() - maxChanges}"/][/@ww.text]
            </a>
        </p>
    [/#if]
[/#if]