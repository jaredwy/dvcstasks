[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ConfigureElasticImageConfiguration" --]
[#import "/admin/elastic/commonElasticFunctions.ftl" as ela]

<html>
<head>
    <title>[@ww.text name='elastic.image.configuration.list.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>

<body>

<h1>[@ww.text name='elastic.image.configuration.list.heading' /]</h1>
<p>[@ww.text name='elastic.image.configuration.list.description' /]</p>

[@ww.actionerror /]

<table id="elasticImageConfigurations" class="aui">
    <thead>
        <tr>
            <th>[@ww.text name='elastic.image.configuration.configurationName.heading'/]</th>
            <th>[@ww.text name='elastic.image.configuration.amiId'/]</th>
            <th>[@ww.text name='elastic.image.configuration.ebsSnapshotId'/]</th>
            <th>[@ww.text name='elastic.instance.type'/]</th>
            <th>[@ww.text name='elastic.image.configuration.availabilityZone.preferred'/]</th>
            <th>[@ww.text name='elastic.image.configuration.numberOfActiveInstances.heading'/]</th>
            <th>[@ww.text name='global.heading.operations'/]</th>
        </tr>
    </thead>
    <tbody>
        [#foreach configuration in elasticImageConfigurations]
        [#assign activeInstanceCount = elasticUIBean.getActiveInstancesCountForConfiguration(configuration)/]
        <tr [#if configuration.disabled] class="disabled" [/#if]>
            <td><a href="[@ww.url action='viewElasticImageConfiguration' configurationId=configuration.id /]" title="${configuration.configurationDescription!?html}">[#t]
                ${configuration.configurationName!?html}[#t]
                 </a>[#t]
                [#if configuration.shippedWithBamboo]
                <span class="grey">[@ww.text name="elastic.image.configuration.default" /]</span>
                [/#if]
                [#if configuration.disabled]
                <span class="grey"> [@ww.text name="elastic.image.configuration.disabled" /]</span>
                [/#if]
            </td>
            <td>${configuration.amiId!?html}</td>
            <td>[#rt]
                [#if configuration.isEbsEnabled()][#t]
                    ${configuration.ebsSnapshotId?html}[#t]
                [#else][#t]
                    [@ww.text name='elastic.image.configuration.ebsDisabled'/][#t]
                [/#if][#t]
            </td>[#t]
            <td>${configuration.instanceType!}</td>
            <td>[#rt]
                [#if configuration.availabilityZone?has_content][#t]
                    ${configuration.availabilityZone}[#t]
                [#else][#t]
                    [@ww.text name='elastic.image.configuration.availabilityZone.default'/][#t]
                [/#if][#t]
            </td>[#t]
            <td>
                <a href="[@ww.url action='viewElasticInstancesForConfiguration' namespace='/admin/elastic/image/configuration' configurationId=configuration.id /]">${activeInstanceCount}</a>
            </td>
            <td class="operations">
                [#if configuration.disabled]
                     <a id="enableElasticImageConfiguration-${configuration.id}" href="[@ww.url action='enableElasticImageConfiguration' configurationId=configuration.id /]">
                        [@ww.text name='global.buttons.enable'/][#t]
                     </a>[#t]
                [#else]
                    <a id="startInstancesForConfig-${configuration.id}" href="[@ww.url action='prepareElasticInstances' namespace="/admin/elastic" elasticImageConfigurationId=configuration.id /]">[@ww.text name='elastic.image.configuration.start.short'/]</a>
                    &nbsp;|&nbsp;[#t]
                    <a id="disableElasticImageConfiguration-${configuration.id}" href="[@ww.url action='disableElasticImageConfiguration' configurationId=configuration.id /]">
                        [@ww.text name='global.buttons.disable'/][#t]
                    </a>[#t]
                [/#if]
                &nbsp;|&nbsp;[#t]
                <a id="viewElasticImageConfiguration-${configuration.id}" href="[@ww.url action='viewElasticImageConfiguration' configurationId=configuration.id returnUrl=currentUrl/]">
                    [@ww.text name='global.buttons.view'/][#t]
                </a>[#t]
                &nbsp;|&nbsp;[#t]
                <a id="editElasticImageConfiguration-${configuration.id}" href="[@ww.url action='editElasticImageConfiguration' configurationId=configuration.id returnUrl=currentUrl /]">
                    [@ww.text name='global.buttons.edit'/][#t]
                </a>[#t]
                [#if activeInstanceCount == 0 && !configuration.isShippedWithBamboo()]
                &nbsp;|&nbsp;[#t]
                 <a id="deleteElasticImageConfiguration-${configuration.id}" href="[@ww.url action='deleteElasticImageConfiguration' configurationId=configuration.id returnUrl=currentUrl /]">
                     [@ww.text name='global.buttons.delete'/][#t]
                </a>[#t]
                [/#if]
            </td>
        </tr>
        [/#foreach]
    </tbody>
</table>

<h1>[@ww.text name='elastic.image.configuration.create.heading' /]</h1>
[@ela.editElasticInstance mode="create" /]
</body>
</html>