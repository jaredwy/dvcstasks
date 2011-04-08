[#if resultsSummary.commits?has_content]
    <ul>
    [#list resultsSummary.commits as commit]
        <li>
            <img class="profileImage" src="[@ui.displayUserGravatar userName=(commit.author.linkedUserName)! size='25'/]" />
            <h3>
                <a href="[@cp.displayAuthorOrProfileLink author=commit.author /]">[@ui.displayAuthorFullName author=commit.author /]</a>
            </h3>
            <p>
                [@ui.renderValidJiraIssues commit.comment resultsSummary /]
            </p>
            <ul class="files">
                [#list commit.files as file]
                    <li>
                        ${file.cleanName!?html}
                        (version ${file.revision!?html})
                    </li>
                [/#list]
            </ul>
        </li>
    [/#list]
    </ul>
[/#if]
