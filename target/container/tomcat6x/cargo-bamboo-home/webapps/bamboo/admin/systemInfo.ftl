[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.SystemInfoAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.SystemInfoAction" --]

<html>
<head>
	<title>[@ww.text name='system.title' /]</title>
</head>
<body>
	<h1>[@ww.text name='system.heading' /]</h1>
    [@ui.bambooPanel titleKey='system.info.title']
    [@ui.bambooSection]
        [@ww.label labelKey='system.info.date' name='systemInfo.systemDate' /]
        [@ww.label labelKey='system.info.time' name='systemInfo.systemTime' /]
        [@ww.label labelKey='system.info.uptime' name='systemInfo.uptime' /]
        [@ww.label labelKey='system.info.username' name='systemInfo.userName' /]
        [@ww.label labelKey='system.info.timezone' name='systemInfo.userTimezone' /]
        [@ww.label labelKey='system.info.locale' name='systemInfo.userLocale' /]
        [@ww.label labelKey='system.info.encoding' name='systemInfo.systemEncoding' /]
        [@ww.label labelKey='system.info.os' name='systemInfo.operatingSystem' /]
        [@ww.label labelKey='system.info.osArch' name='systemInfo.operatingSystemArchitecture' /]
        [@ww.label labelKey='system.info.processors' name='systemInfo.availableProcessors' /]
        [@ww.label labelKey='system.info.appServer' name='systemInfo.appServerContainer' hideOnNull='true' /]
    [/@ui.bambooSection]

    [@ui.bambooSection titleKey='system.java.title' ]
        [@ww.label labelKey='system.java.version' value='${systemInfo.getSystemProperty("java.version")}' /]
        [@ww.label labelKey='system.java.vendor' value='${systemInfo.getSystemProperty("java.vendor")}' /]

        [@ww.label labelKey='system.java.specVersion' value='${systemInfo.getSystemProperty("java.vm.specification.version")}' /]
        [@ww.label labelKey='system.java.specVendor' value='${systemInfo.getSystemProperty("java.vm.specification.vendor")}' /]

        [@ww.label labelKey='system.java.jvmVersion' value='${systemInfo.getSystemProperty("java.vm.version")}' /]
        [@ww.label labelKey='system.java.jvmVendor' value='${systemInfo.getSystemProperty("java.vm.vendor")}' /]
        [@ww.label labelKey='system.java.jvmName' value='${systemInfo.getSystemProperty("java.vm.name")}' /]

        [@ww.label labelKey='system.java.jreVersion' value='${systemInfo.getSystemProperty("java.runtime.version")}' /]
        [@ww.label labelKey='system.java.jreName' value='${systemInfo.getSystemProperty("java.runtime.name")}' /]
    [/@ui.bambooSection]

    [@ui.bambooSection titleKey="system.network.title" ]
        [@ww.label labelKey='system.network.hostName' name='systemInfo.hostName' /]
        [@ww.label labelKey='system.network.ipAddress' name='systemInfo.ipAddress' /]
    [/@ui.bambooSection]

    [@ui.bambooSection titleKey='system.memory.title' ]
        [@ww.label labelKey='system.memory.total' value='${systemInfo.totalMemory} MB' /]
        [@ww.label labelKey='system.memory.free' value='${systemInfo.freeMemory} MB' /]
        [@ww.label labelKey='system.memory.used' value='${systemInfo.usedMemory} MB' /]
    [/@ui.bambooSection]

    [@ui.bambooSection titleKey='system.bamboo.version' ]
        [@ww.label labelKey='system.bamboo.version.ver' name='bambooVersion' /]
        [@ww.label labelKey='system.bamboo.version.build' name='bambooBuildNumber' /]
        [@ww.label labelKey='system.bamboo.version.date' name='bambooBuildDate' /]
    [/@ui.bambooSection]

    [@ui.bambooSection titleKey='system.bambooPaths.title' ]
        [@ww.label labelKey='system.bambooPaths.cwd' name='systemInfo.currentDirectory' /]
        [@ww.label labelKey='system.bambooPaths.configurationPath' name='systemInfo.configPath' /]
        [@ww.label labelKey='system.bambooPaths.buildPath' name='systemInfo.buildPath' /]
        [@ww.label labelKey='config.server.buildDirectory' name='systemInfo.buildWorkingDirectory' /]
        [@ww.label labelKey='config.server.artifactsDirectory' name='systemInfo.artifactsDirectory' /]
        [@ww.label labelKey='system.bambooPaths.home' name='systemInfo.applicationHome' /]
        [@ww.label labelKey='system.bambooPaths.logs' name='logPath' /]
        [@ww.label labelKey='system.bambooPaths.temp' name='systemInfo.tempDir' /]
        [@ww.label labelKey='system.bambooPaths.userHome' name='systemInfo.userHome' /]
    [/@ui.bambooSection]

    [@ui.bambooSection titleKey='system.file.stats' ]
        [@ww.label labelKey='system.file.disk.free' name='systemInfo.freeDiskSpace' /]
    [/@ui.bambooSection]

    [@ui.bambooSection titleKey='system.bamboo.stats' ]
        [@ww.label labelKey='system.bamboo.plans' name='systemStatisticsBean.numberOfPlans' /]
        [@ww.label labelKey='system.bamboo.results' name='systemStatisticsBean.numberOfResults' /]
        [@ww.label labelKey='system.bamboo.index.time' value='${dateUtils.formatDurationPretty(systemStatisticsBean.approximateIndexTime)}' /]
    [/@ui.bambooSection]

    [@ui.bambooSection titleKey='system.jms.title' ]
        [#if (systemInfo.broker.getTransportConnectors())?has_content   ]
            [@ww.label labelKey='system.jms.brokerUri' value='${systemInfo.broker.getTransportConnectors()[0].uri}' /]
        [#else]
            [@ww.label labelKey='system.jms.remoteBrokerUri' value='Not enabled' /]
        [/#if]
        [@ww.label labelKey='system.jms.borkerVmUri' value='${systemInfo.broker.vmConnectorURI}' /]
    [/@ui.bambooSection]
    [#--
    [#if compressionStats?exists]
        [@ui.bambooSection title='Compression Stats' ]
            [@ww.label label='Compressed Responses' name='compressionStats.numResponsesCompressed' /]
            [@ww.label label='Compressed Bytes' name='compressionStats.ResponseCompressedBytes' /]
            [@ww.label label='Compression Ratio' name='compressionStats.responseAverageCompressionRatio' /]
        [/@ui.bambooSection]
    [/#if]
    --]

    [@ui.bambooSection titleKey='system.environment.title' ]
        <ul>
        [#list systemInfo.environmentVariables as env]
           <li>${env?if_exists}</li>
        [/#list]
        </ul>
    [/@ui.bambooSection]

    [#--
    [@ui.bambooSection title='System Properties' ]
        <ul>
        [#list systemInfo.systemProperties as env]
           <li>${env?if_exists}</li>
        [/#list]
        </ul>
    [/@ui.bambooSection]
    --]

    [@ui.bambooSection titleKey='system.plugins.title' ]
        <ul>
        [#list enabledPlugins as plugin]
           <li>
               ${plugin.name!?html} - ${((plugin.pluginInformation.version)!"No version")?html}
               <div class="subGrey">Vendor: ${((plugin.pluginInformation.vendorName)!"No Vendor")?html}</div>
           </li>
        [/#list]
        </ul>
    [/@ui.bambooSection]

    [/@ui.bambooPanel]
    [@ww.form action="#"
              theme='simple']
        [@ww.hidden name='bambooHome' value="${systemInfo.applicationHome}" /]
    [/@ww.form]

</body>
</html>