[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.EditChainDetails" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.EditChainDetails" --]
[#import "editChainConfigurationCommon.ftl" as eccc/]

[@eccc.editChainConfigurationPage plan=plan  selectedTab='build.details' ]
        [@ww.form action="saveChainDetails" namespace="/chain/admin/config"
                 cancelUri='/browse/${chain.key}/config'
                  submitLabelKey='global.buttons.update' titleKey='chain.details.edit' descriptionKey='chain.details.edit.description']

            [@ww.hidden name="buildKey" /]
            [@ww.textfield labelKey='project.name' name='projectName' required='true' /]
            [@ww.textfield labelKey='chain.name' name='chainName' required='true' /]
            [@ww.textfield labelKey='chainDescription' name='chainDescription' required='false' /]
            [@ww.checkbox labelKey='plan.enabled' name="enabled" /]
        [/@ww.form]
[/@eccc.editChainConfigurationPage]
