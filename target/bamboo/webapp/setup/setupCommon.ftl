[#-- ================================================================================================ @sc.setupActionErrors--]

[#macro setupActionErrors boxClass="error"]
    [#if action.hasActionErrors() ]
    [@ui.messageBox type=boxClass]
        [#if actionErrors.size() == 1 ]
        <p class="title">${formattedActionErrors.iterator().next()}</p>
        [#else ]
            <ul>
                [#list formattedActionErrors as error]
                    <li>${error}</li>
                [/#list]
            </ul>
        [/#if]
    [/@ui.messageBox]
    [/#if]
[/#macro]
