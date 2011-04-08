[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.DeleteBuilds" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.DeleteBuilds" --]

<html>
<head>
	<title>[@ww.text name='builds.delete.confirm.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
	<h1>[@ww.text name='builds.delete.confirm.heading' /]</h1>

    [@ww.form titleKey='builds.delete.confirm.form.title' id='deleteBuildsForm' action='deleteBuilds.action' submitLabelKey='global.buttons.confirm' cancelUri='/admin/deleteBuilds!default.action' ]
                [@ui.messageBox type="warning" titleKey="builds.delete.confirm.warning" /]
        [#if selectedProjects??]
            <p>[@ww.text name='builds.delete.confirm.projects' /]</p>
            <ul>
                [#list projectsToConfirm as project]
                    [#if project??]
                        <li>${project.name} <em>(${project.key})</em></li>
                    [/#if]
                [/#list]
            </ul>
        [/#if]
        [#if selectedBuilds??]
            <p>[@ww.text name='builds.delete.confirm.plans' /]</p>
            <ul>
                [#list buildsToConfirm as build]
                    [#if build??]
                        <li>${build.name} <em>(${build.key})</em>
                               [#assign jobs = action.getJobsToConfirm(build) /]
                                [#if jobs?has_content ]
                                    <ul>
                                    [#list jobs.toArray()?sort_by("name") as job]
                                        [#if job??]
                                            <li>${job.name} <em>(${job.key})</em></li>
                                        [/#if]
                                    [/#list]
                                    </ul>
                                [/#if]
                        </li>
                    [/#if]
                [/#list]
            </ul>
        [/#if]
        [#if selectedBuilds??]
            [#list selectedBuilds as selectedBuild]
                [@ww.hidden name='selectedBuilds' value=selectedBuild /]
            [/#list]
        [/#if]
        [#if selectedProjects??]
            [#list selectedProjects as selectedProject]
                [@ww.hidden name='selectedProjects' value=selectedProject /]
            [/#list]
        [/#if]
    [/@ww.form]
</body>
</html>
