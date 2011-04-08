[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.ConfigureSharedRemoteCapability" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.ConfigureSharedRemoteCapability" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]

[#if action.local]
    [#assign type = 'local' /]
    [#assign Type = 'Local' /]
[#else]
    [#assign type = 'remote' /]
    [#assign Type = 'Remote' /]
[/#if]
[#assign cancelUri='/admin/agent/configureShared${Type}Capabilities!default.action'/]

<html>
<head>
    <title>[@ww.text name='agent.capability.shared.${type}.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>

<body>
<h1>[@ww.text name='agent.capability.shared.${type}.title' /]</h1>

<p>[@ww.text name='agent.capability.shared.${type}.description' /]</p>

[@ui.bambooPanel]
    [#if (capabilitySet.capabilities)?has_content]
        [@agt.displayCapabilities capabilitySetDecorator=capabilitySetDecorator showDelete=true returnAfterOpUrl=cancelUri/]
    [#else]
        [@ui.clear /]
        [@ui.displayText key='agent.capability.shared.${type}.empty' /]
    [/#if]
    [#if action.local]
        [@ui.displayFooter]
            <a href="[@ww.url action='updateDefaults${Type}Capability' namespace='/admin/agent' /]"
                    title="[@ww.text name='agent.capability.shared.autodetect.description'/]">[#lt]
                [@ww.text name='agent.capability.shared.autodetect' /][#lt]
            </a>[#lt]
        [/@ui.displayFooter]
    [/#if]
[/@ui.bambooPanel]

[@ui.clear /]

[@ww.form id='addCapability' action='addShared${Type}Capability.action' namespace='/admin/agent' titleKey='agent.capability.add'
          submitLabelKey='global.buttons.add'
          cancelUri=cancelUri]

    [@ww.hidden name="returnUrl" /]

    [#include '/admin/agent/addCapabilityFragment.ftl' /]
[/@ww.form]
</body>
</html>
