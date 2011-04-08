[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]

[#if action.hasActionErrors() ]
    [#if actionErrors.size() == 1 ]
        [#assign heading][@ww.text name='error.heading' /]: ${formattedActionErrors.iterator().next()}.[/#assign]
        [@ui.messageBox type="error" title=heading /]
    [#else ]
        [@ui.messageBox type="error" titleKey="error.multiple"]
            <ul>
                [#list formattedActionErrors as error]
                    <li>${error}</li>
                [/#list]
            </ul>
        [/@ui.messageBox]
    [/#if]
[/#if]
