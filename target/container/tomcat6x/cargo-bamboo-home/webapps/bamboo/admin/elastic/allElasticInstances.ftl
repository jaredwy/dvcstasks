[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.AllElasticInstancesAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.AllElasticInstancesAction" --]
[#-- @ftlvariable name="spotInstanceRequests" type="java.util.List<com.amazonaws.services.ec2.model.SpotInstanceRequest>" --]


[#import "/agent/commonAgentFunctions.ftl" as agt]
[#import "/admin/elastic/commonElasticFunctions.ftl" as ela]
<html>
<head>
    <title>[@ww.text name='elastic.manage.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>

<body>
    <h1>[@ww.text name='elastic.manage.all.instances.heading' /]</h1>
    <p>[@ww.text name='elastic.manage.all.instances.description'/]</p>
    
    [#if actionErrors?has_content]
        [@ww.actionerror /]
    [#else]
        [@ui.bambooPanel]
            [#if allSpotInstanceRequests?has_content]
                [@ui.bambooSection titleKey='Pending Spot Instance Requests']
                    [@showSpotInstanceRequests allSpotInstanceRequests /]
                [/@ui.bambooSection]
            [/#if]

            [#if disconnectedElasticInstances?has_content]
                [@ww.url id='shutdownAllDisconnectedElasticInstancesUrl' action='shutdownAllDisconnectedElasticInstances' namespace='/admin/elastic' returnUrl=currentUrl /]
                [@ui.bambooSection
                    titleKey='elastic.manage.all.not.connected.instances'
                    tools='<a href="${shutdownAllDisconnectedElasticInstancesUrl}">${action.getText("elastic.manage.shutdown.all.disconnected.instances")}</a>'
                ]
                    [@showElasticInstances disconnectedElasticInstances /]
                [/@ui.bambooSection]
            [/#if]
    
            [#if unrelatedElasticInstances?has_content]
                [@ui.bambooSection titleKey='elastic.manage.all.other.instances']
                    [@showElasticInstances unrelatedElasticInstances /]
                [/@ui.bambooSection]
            [/#if]

            [#if detachedVolumes?has_content]
                [@ww.url id='deleteAllDetachedEbsVolumesUrl' action='deleteAllDetachedEbsVolumes' namespace='/admin/elastic' returnUrl=currentUrl /]
                [@ui.bambooSection
                    titleKey='elastic.manage.detached.ebs.volumes'
                    tools='<a href="${deleteAllDetachedEbsVolumesUrl}">${action.getText("elastic.manage.delete.all.detached.volumes")}</a>' ]
                    <table id="elastic-agents" class="aui">
                        <thead><tr>
                            <th>[@ww.text name='elastic.manage.ebs.volume.id' /]</th>
                            <th>[@ww.text name='elastic.manage.ebs.volume.status' /]</th>
                            <th>[@ww.text name='elastic.manage.ebs.volume.operations' /]</th>
                        </tr></thead>
                        <tbody>
                            [#foreach volume in detachedVolumes]
                                <tr>
                                    <td> ${volume.id} </td>
                                    <td> ${volume.status} </td>
                                    <td>
                                        [#if volume.status == "available"]
                                            <a href="${req.contextPath}/admin/elastic/deleteEbsVolume.action?volumeId=${volume.id}&amp;returnUrl=${currentUrl}">[@ww.text name='elastic.manage.delete.volume' /]</a>
                                        [/#if]
                                    </td>
                                </tr>
                            [/#foreach]
                        </tbody>
                    </table>
                [/@ui.bambooSection]
            [/#if]
        [/@ui.bambooPanel]
    [/#if]

    [@ui.clear/]
</body>
</html>


[#macro showSpotInstanceRequests spotInstanceRequests ]
<table id="spot-requests" class="aui">
    <thead>
    <tr>
        <th>[@ww.text name='Request Id' /]</th>
        <th>[@ww.text name='Type' /]</th>
        <th>[@ww.text name='Creation Time' /]</th>
        <th>[@ww.text name='Maximium Bid' /]</th>
        <th>[@ww.text name='Availability Zone' /]</th>
        <th>[@ww.text name='elastic.manage.instance.state' /]</th>
        <th>[@ww.text name='elastic.manage.instance.operations' /]</th>
    </tr>
    </thead>
    <tbody>
        [#foreach spotRequest in spotInstanceRequests]
        <tr>
            <td> ${spotRequest.spotInstanceRequestId} </td>
            <td> ${spotRequest.launchSpecification.instanceType} </td>
            <td> ${spotRequest.createTime?datetime?string("hh:mm a, EEE, d MMM")} </td>
            <td> $${spotRequest.spotPrice?replace("0+$", "", "r")} </td>
            <td> ${spotRequest.availabilityZoneGroup!"n/a"} </td>
            <td> ${spotRequest.state} </td>
            <td>
                [#if spotRequest.state == "open"]
                    <a id="cancel:${spotRequest.spotInstanceRequestId}" href="${req.contextPath}/admin/elastic/shutdownDisconnectedElasticInstance.action?instanceId=${spotRequest.spotInstanceRequestId}&amp;returnUrl=${currentUrl}">[@ww.text name='Cancel' /]</a>
                [/#if]
            </td>
        </tr>
        [/#foreach]
    </tbody>
</table>
[/#macro]

[#-- =================================================================================================== @showElasticInstances --]
[#macro showElasticInstances elasticInstances ]
    [#if elasticInstances?has_content]
        <table id="elastic-agents" class="aui">
            <thead><tr>
                <th>[@ww.text name='elastic.manage.instance.id' /]</th>
                <th>[@ww.text name='elastic.manage.instance.type' /]</th>
                <th>[@ww.text name='elastic.manage.instance.launch.time' /]</th>
                <th>[@ww.text name='elastic.manage.instance.dns.name' /]</th>
                <th>[@ww.text name='elastic.manage.instance.availability.zone' /]</th>
                <th>[@ww.text name='elastic.manage.instance.state' /]</th>
                <th>[@ww.text name='elastic.manage.instance.operations' /]</th>
            </tr></thead>
            <tbody>
                [#foreach instance in elasticInstances]
                    <tr>
                        <td> ${instance.id} </td>
                        <td> ${instance.instanceType} </td>
                        <td> ${instance.launchTime?datetime?string("hh:mm a, EEE, d MMM")} </td>
                        <td> ${instance.dnsName} </td>
                        <td> ${instance.availabilityZone} </td>
                        <td> ${instance.state.getName()} </td>
                        <td>
                            [#if instance.state.getName() == "running"]
                                <a id="shutdown:${instance.id}" href="${req.contextPath}/admin/elastic/shutdownDisconnectedElasticInstance.action?instanceId=${instance.id}&amp;returnUrl=${currentUrl}">[@ww.text name='elastic.manage.shutdown' /]</a>
                            [/#if]
                        </td>
                    </tr>
                [/#foreach]
            </tbody>
        </table>
    [/#if]

[/#macro]

