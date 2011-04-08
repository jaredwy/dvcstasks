[#macro displaySubscribersAndProducersByStage subscribedJobs dependenciesDeletionMessage headerWeight='h2']
    [#if subscribedJobs.size() > 0]
    <div id="artifact-delete-dependencies">
        <${headerWeight}>[@ww.text name="artifact.consumed.title"/]</${headerWeight}>
        <p>${dependenciesDeletionMessage}</p>
        [@ui.bambooPanel content=true ]
            <div id="artifact-delete-navigator">
                <ul>
                    [#list subscribedJobs.keySet() as stage]
                        <li>
                            <h4>${stage.name?html}</h4>
                            <ul>
                                [#list subscribedJobs.get(stage) as job]
                                    <li id="job-${job.key}" class="[#if (job.suspendedFromBuilding)!false] disabled[/#if]">
                                    [@ui.icon "job"/]
                                        <a id="navJob_${job.key}" href="${req.contextPath}/build/admin/edit/defaultBuildArtifact.action?buildKey=${job.key}">${job.buildName}</a>
                                    </li>
                                [/#list]
                            </ul>
                        </li>
                    [/#list]
                </ul>
            </div>
        [/@ui.bambooPanel]
    </div>
    [/#if]
[/#macro]