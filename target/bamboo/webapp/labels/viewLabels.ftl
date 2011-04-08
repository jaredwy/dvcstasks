[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.labels.ViewLabels" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.labels.ViewLabels" --]
<html>
<head>
	<title>[@ui.header pageKey='Labels' object='' title=true /]</title>
</head>

<body>
[#if plan?? && plan.type.equals("JOB")]
    [#assign chain = plan.parent]
    [#assign job = plan]
[#elseif plan??]
    [#assign chain = plan]
[/#if]

[#if project??]
<p id="labelCrumb">See also labels in: <a href="${req.contextPath}/browse/label">All Projects</a>
    [#if chain??]
    | <a href="${req.contextPath}/browse/${project.key}/label">Project ${project.name}</a>
    [/#if]
    [#if job??]
    | <a href="${req.contextPath}/browse/${chain.key}/label">Plan ${chain.buildName}</a>
    [/#if]
</p>
[/#if]
    
<h1>Labels</h1>

<p>
    [#if job??]
        This page lists all labels against builds in job <strong>${job.name}</strong>.
    [#elseif chain??]
        This page lists all labels against builds in plan <strong>${chain.name}</strong>.
    [#elseif project??]
        This page lists all labels against builds in project <strong>${project.name}</strong>.
    [#else]
        This page lists <strong>all</strong> labels used in Bamboo.
    [/#if]
    The <strong>bigger</strong> the text, the more build results are associated with this label. Click on a label to see the builds associated with it.
</p>

<div class="labelSortSelection">
    [@ww.url id='orderByAlphaUrl' action='viewLabels' namespace='/build/label' orderByRank='false']
        [#if project??]
            [@ww.param name='projectKey']${project.key}[/@ww.param]
        [/#if]
        [#if build??]
            [@ww.param name='buildKey']${build.key}[/@ww.param]
        [/#if]
    [/@ww.url]
    [@ww.url id='orderByRankUrl' action='viewLabels' namespace='/build/label' orderByRank='true']
        [#if project??]
            [@ww.param name='projectKey']${project.key}[/@ww.param]
        [/#if]
        [#if build??]
            [@ww.param name='buildKey']${build.key}[/@ww.param]
        [/#if]
    [/@ww.url]

    View the labels:
    <a [#if orderByRank]href="${orderByAlphaUrl}"[#else]class="disabledLink"[/#if]>Alphabetically</a> |
    <a [#if !orderByRank]href="${orderByRankUrl}"[#else]class="disabledLink"[/#if]>By Popularity</a>
</div>

<ul class="labelDisplay">
    [#list results.entrySet() as result]
        [#assign size=12 + result.value * 2 /]
        [@ww.url id='labelUrl' action='viewBuildsForLabel' namespace='/build/label' labelName=result.key.label.name /]
        <li style="font-size: ${size}px; padding: 2px;">
            <a href="${req.contextPath}/browse/label/${result.key.label.name}">${result.key.label.name}</a>
        </li>
    [/#list]
</ul>

</body>
</html>