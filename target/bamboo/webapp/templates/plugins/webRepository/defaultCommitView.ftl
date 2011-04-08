[#assign repository=plan.buildDefinition.repository /]

[#if (buildResultsSummary.commits)?has_content]
    <ul>
    [#list buildResultsSummary.commits as commit]
        <li>
            [#if "Unknown" != commit.author.name]
                [#assign commitUrl = (linkGenerator.getWebRepositoryUrlForCommit(commit, repository))!('') /]
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
                [@ui.renderValidJiraIssues commit.comment buildResultsSummary /]
            </p>
           <ul class="files">
                [#list commit.files as file]
                <li>
                    [#if "Unknown" != commit.author.name]
                       [#assign fileLink = linkGenerator.getWebRepositoryUrlForFile(file, repository)!]
                       [#if fileLink?has_content]
                          <a href="${fileLink}">${file.cleanName}</a>
                       [#else]
                          ${file.name}
                       [/#if]
                       [#if file.revision?has_content]
                            [#if fileLink?has_content && linkGenerator.getWebRepositoryUrlForRevision(file, repository)?has_content]
                                <a href="${linkGenerator.getWebRepositoryUrlForRevision(file, repository)}">(version ${file.revision})</a>
                            [#else]
                                (version ${file.revision})
                            [/#if]
                            [#if fileLink?has_content && linkGenerator.getWebRepositoryUrlForDiff(file, repository)?has_content]
                                <a href="${linkGenerator.getWebRepositoryUrlForDiff(file, repository)}">(diffs)</a>
                            [/#if]
                       [/#if]
                    [#else]
                        ${file.cleanName!}
                        [#if file.revision??]
                        (version ${file.revision})
                        [/#if]
                    [/#if]
                </li>
                [/#list]
            </ul>
        </li>
    [/#list]
    </ul>
[/#if]
