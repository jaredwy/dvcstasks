[#--
	Only show message if errors are available.
	This will be done if ActionSupport is used.
--]
[#assign hasFieldErrors = parameters.name?exists && fieldErrors?exists && fieldErrors[parameters.name]?exists/]
<div [#rt/][#if parameters.id?exists]id="fieldArea_${parameters.id}"[#rt/][/#if] class="fieldArea [#if hasFieldErrors]fieldAreaError[/#if][#if parameters.required?default(false)] required[/#if]">

[#include "/${parameters.templateDir}/${parameters.theme}/controlheader-core.ftl" /][#nt/]

[#if parameters.label?exists  || parameters.labelKey?exists]
    <label class="fieldLabelArea" [#t/]
    [#if parameters.id?exists]
            for="${parameters.id?html}" [#t/]
    [/#if]
    [#if parameters.id?exists]id="fieldLabelArea_${parameters.id}"[/#if][#t/]
        >[#t/]
    [#if parameters.required?default(false)]
            <span class="required">*</span>[#t/]
    [/#if]
        [#if parameters.labelKey?has_content]
            [@ww.text name="${parameters.labelKey}" /]:[#t/]
        [#elseif parameters.label?has_content]
            ${parameters.label}:[#t/]
        [/#if]
        [#include "/${parameters.templateDir}/${parameters.theme}/tooltip.ftl" /]
    </label>[#t/]
[/#if]

<div class="fieldValueArea" [#rt/]
[#if parameters.id?exists]id="fieldValueArea_${parameters.id}"[#rt/][/#if] >
    