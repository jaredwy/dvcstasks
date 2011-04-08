[#if parameters.name?exists && fieldErrors?has_content && fieldErrors[parameters.name]?has_content]
    <div [#rt/][#if parameters.id?exists]id="fieldArea_${parameters.id}"[#rt/][/#if] class="errorBox">
    [#list fieldErrors[parameters.name] as error]
        <div[#rt/]
        [#if parameters.id?exists]
            errorFor="${parameters.id}"[#rt/]
        [/#if]
            class="fieldError">
             ${error?html}
        </div>[#t/]
    [/#list]
    </div>[#t/]
[/#if]