[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ViewAgentPlanMatrix" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ViewAgentPlanMatrix" --]
<html>
<head>
    <title>[@ww.text name='agent.matrix.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>

<body>
    <h1>[@ww.text name='agent.matrix.heading' /]</h1>

    <p>
     [@ww.text name='agent.matrix.description' ]
        [@ww.param]<img src="[@cp.getStaticResourcePrefix /]/images/bad.gif" alt="Agent cannot run plan" width="16" height="16" />[/@ww.param]
     [/@ww.text]
    </p>

    [#if buildables?has_content]
    <table class="aui agentPlanMatrix">
        <thead>
        <tr>
            <th></th>
            [#list agents as agent]
                <th class="agentHeading">
                   ${agent_index + 1}
                   [@ui.renderAgentNameAdminLink agent/]
                </th>
            [/#list]
            [#if elasticEnabled && imagePlanMatrix?has_content]
                [#list images as image]
                    <th class="agentHeading">
                        <img src="[@cp.getStaticResourcePrefix /]/images/jt/icn_elastic_cloud.gif"/>
                        <a href="${req.contextPath}/admin/elastic/image/configuration/viewElasticImageConfiguration.action?configurationId=${image.id}">${image.configurationName?html}</a>
                    </th>
                [/#list]
            [/#if]
        </tr>
        </thead>
        [#list buildables as build]
            <tr>
                <th class="planHeading">
                    ${build_index + 1}
                        [@ww.url id='editBuildConfigurationUrl'  action='editBuildConfiguration' namespace='/build/admin/edit' buildKey='${build.key}'/]
                        [#if build.type.equals("JOB")]
                            [@ww.url id='chainLink'  value='/browse/${build.parent.key}'/]
                            <a title="${build.key}" href="${editBuildConfigurationUrl}">${build.buildName}</a> [@ww.text name='build.partof'/] <a title="${build.parent.name}" href="${chainLink}">${build.parent.name}</a>
                        [#else]
                            <a title="${build.key}" href="${editBuildConfigurationUrl}">${build.name}</a>
                        [/#if]
                </th>
                [#assign agentsForPlan = action.getAgentPlanMatrix().get(build.key) /]
                [#list agents as agent]
                    <td class="checkboxCell" id="${build.key}_agent_${agent.id}">
                        [#assign result = agentsForPlan.get(agent.id) /]
                        [#if result.matches]
                            <img src="[@cp.getStaticResourcePrefix /]/images/good.gif" alt="Agent can run plan">
                        [#else]
                            <img src="[@cp.getStaticResourcePrefix /]/images/bad.gif" alt="Agent cannot run plan">
                            [#assign rejectedRequirements = action.getDecoratedSet(result.rejectedRequirements) /]
                            [@dj.tooltip target='${build.key}_agent_${agent.id}']
                                <ol class="standard">
                                    [#list rejectedRequirements.decoratedObjects as rejected]
                                        <li>${rejected.label!?html} ${rejected.matchType} ${rejected.matchValue!?html} </li>
                                    [/#list]
                                </ol>
                            [/@dj.tooltip]
                        [/#if]
                    </td>
                [/#list]
                [#if elasticEnabled && imagePlanMatrix?has_content]
                [#list images as image]
                    <td class="checkboxCell" id="${build.key}_image_${image.id}">
                        [#assign result = action.getImagePlanMatrix().get(build.key).get(image.id) /]
                        [#if result.matches]
                            <img src="[@cp.getStaticResourcePrefix /]/images/good.gif" alt="Elastic Image can run plan">
                        [#else]
                            <img src="[@cp.getStaticResourcePrefix /]/images/bad.gif" alt="Elastic Image cannot run plan">
                            [#assign rejectedRequirements = action.getDecoratedSet(result.rejectedRequirements) /]
                            [@dj.tooltip target='${build.key}_image_${image.id}']
                                <ol class="standard">
                                    [#list rejectedRequirements.decoratedObjects as rejected]
                                        <li>${rejected.label!?html} ${rejected.matchType} ${rejected.matchValue!?html} </li>
                                    [/#list]
                                </ol>
                            [/@dj.tooltip]
                        [/#if]
                    </td>
                [/#list]
                [/#if]
            </tr>
        [/#list]
    </table>
    [#else]

    [/#if]
</body>
</html>