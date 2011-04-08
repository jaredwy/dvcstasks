[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.agent.AddSharedLocalCapability" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.agent.AddSharedLocalCapability" --]
[@ww.form action="addSharedBuilderCapability" namespace="/ajax"
        descriptionKey='builder.inline.addCapability.description'
        submitLabelKey="global.buttons.add"]

    [@ww.select labelKey='builders.form.typeLabel' name='builderType' list=capabilityHelper.getFilteredBuildersFromTypeString(capabilityType, builderKey) listKey='key' listValue='name'
                optionDescription='pathHelp'
                descriptionKey='builders.form.type.description' /]
    [@ww.textfield labelKey='agent.capability.type.builder.key' name='builderLabel' /]
    [@ww.textfield labelKey='agent.capability.type.builder.value' name='builderPath' /]

    [@ww.hidden name='capabilityType' value='builder' /]
    [@ww.hidden name='returnUrl' /]

[/@ww.form]