[#-- @ftlvariable name="action" type="com.atlassian.bamboo.rest.GetBuildResultsDetails" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.rest.GetBuildResultsDetails" --]
<response vcsRevisionKey="${resultsSummary.vcsRevisionKey}">
[#if resultsSummary.commits?has_content]
    <commits>
[#list resultsSummary.commits as commit]
        [#assign guessedRevision = commit.guessChangeSetId()!("")]
        <commit author="${commit.author.name?xml}" date="${commit.date?string("yyyy-MM-dd'T'HH:mm:ssZ")}" [#if guessedRevision?has_content] revision="${guessedRevision?xml}" [/#if]>
            <comment>${commit.comment?xml}</comment>
[#if commit.files??]
            <files>
[#list commit.files as file]
                <file name="${file.cleanName}"[#if file.revisionKnown] revision="${file.revision?xml}"[/#if]/>
[/#list]
            </files>
[/#if]
        </commit>
[/#list]
    </commits>
[/#if]
</response>