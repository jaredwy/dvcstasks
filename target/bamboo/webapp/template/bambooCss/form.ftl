[#include "/${parameters.templateDir}/xhtml/form-validate.ftl" /]
[#include "/${parameters.templateDir}/simple/form.ftl" /]
<div class="${parameters.cssClass?default('bambooForm')?html}"[#rt/]
[#if parameters.cssStyle?exists] style="${parameters.cssStyle?html}"[#rt/]
[/#if]
>
[#if parameters.title?exists || parameters.titleKey?exists]
    <h2>
        [#if parameters.title?exists]
            ${parameters.title}
        [#else]
            [@ww.text name='${parameters.titleKey}' /]
        [/#if]
    </h2>
[/#if]
[#if parameters.smallTitle?exists || parameters.smallTitleKey?exists]
    <h3>
        [#if parameters.smallTitle?exists]
            ${parameters.smallTitle}
        [#else]
            [@ww.text name='${parameters.smallTitleKey}' /]
        [/#if]
    </h3>
[/#if]
[#if parameters.description?? || parameters.descriptionKey??]
    <div class="descriptionSection">
        [#if parameters.description??]
            ${parameters.description}
        [#else]
            [@ww.text name='${parameters.descriptionKey}' /]
        [/#if]
    </div>
[#else]
<!--Add some padding-->
[/#if]
        
[#if action.hasActionErrors()]
    [#if !(parameters.showActionErrors?exists && parameters.showActionErrors = 'false')]
        [@ww.actionerror /]
    [/#if]
[/#if]

[#if action.hasActionMessages()]
    [#if !(parameters.showActionMessages?? && parameters.showActionMessages = 'false')]
        [@ww.actionmessage theme='simple'/]    
    [/#if]
[/#if]