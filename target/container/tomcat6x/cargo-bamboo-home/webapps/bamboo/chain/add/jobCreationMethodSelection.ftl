[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.CreateJob" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.CreateJob" --]
<title>[@ww.text name='job.create' /]</title>
<meta name="decorator" content="atl.general"/>

<div id="create-content">
[@ui.header pageKey='job.create' descriptionKey='job.create.description' /]

<ul id="creationOption">
    <li>
        <a id="createNewJob"  href="[@ww.url action="newJob" namespace="/chain/admin" buildKey="${buildKey}" existingStage="${existingStage!}"/]">
            <strong>[@ww.text name="job.create.new.title"/]</strong>
            <span>[@ww.text name="job.create.new.help"/]</span>
        </a>
    </li>
    [#if jobsToClone?has_content]
        <li>
            <a id="cloneJob" href="[@ww.url action="cloneJob" namespace="/chain/admin" buildKey="${buildKey}"  existingStage="${existingStage!}"/]">
                <strong>[@ww.text name="job.create.clone.title"/]</strong>
                <span>[@ww.text name="job.create.clone.help"/]</span>
            </a>
        </li>
    [/#if]
</ul>
</div>