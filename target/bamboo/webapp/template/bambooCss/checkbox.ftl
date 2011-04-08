[#--
NOTE: The 'header' stuff that follows is in this one file for checkbox due to the fact
that for checkboxes we do not want the label field to show up as checkboxes handle their own
lables
--]
[#assign hasFieldErrors = parameters.name?? && fieldErrors?? && fieldErrors[parameters.name]??/]
<div [#rt/][#if parameters.id??]id="fieldArea_${parameters.id}"[#rt/][/#if]
     class="checkboxArea fieldArea [#if hasFieldErrors]fieldAreaError[/#if][#if parameters.required!false] required[/#if]">

[#include "/${parameters.templateDir}/${parameters.theme}/controlheader-core.ftl" /][#nt/]

[#if parameters.label??  || parameters.labelKey??]
    <label class="labelForCheckbox"[#t/]
    [#if parameters.id??]
            for="${parameters.id?html}" [#t/]
    [/#if]
    [#if parameters.id??]id="label_${parameters.id}"[#rt/][/#if]
        >[#t/]

    [#include "/${parameters.templateDir}/simple/checkbox.ftl" /]

    [#if parameters.required!false]
            <span class="required">*</span>[#t/]
    [/#if]
        [#if parameters.labelKey??]
            [@ww.text name="${parameters.labelKey}" /][#t/]
        [#else]
            ${parameters.label}[#t/]
        [/#if]
        [#include "/${parameters.templateDir}/${parameters.theme}/tooltip.ftl" /]
    </label>[#t/]
[/#if]

[#include "/${parameters.templateDir}/${parameters.theme}/controlfooter-core.ftl" /][#nt/]
