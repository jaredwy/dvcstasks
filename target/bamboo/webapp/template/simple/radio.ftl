[#assign itemKey = parameters.fieldValue /]
[#assign itemValue = parameters.fieldValue /]

<input type="radio" name="${parameters.name?html}" id="${parameters.id?html}${itemKey?html}"[#rt/]
[#if tag.contains(parameters.nameValue, itemKey) || (parameters.nameValue?? && parameters.nameValue?string == itemKey)]
 checked="checked"[#rt/]
[/#if]
[#if itemKey?exists]
 value="${itemKey?html}"[#rt/]
[/#if]
[#if parameters.disabled?default(false)]
 disabled="disabled"[#rt/]
[/#if]
[#if parameters.tabindex?exists]
 tabindex="${parameters.tabindex?html}"[#rt/]
[/#if]
[#if parameters.cssClass?exists]
 class="${parameters.cssClass?html}"[#rt/]
[/#if]
[#if parameters.cssStyle?exists]
 style="${parameters.cssStyle?html}"[#rt/]
[/#if]
[#if parameters.title?exists]
 title="${parameters.title?html}"[#rt/]
[/#if]
[#include "/${parameters.templateDir}/simple/scripting-events.ftl" /]
[#if parameters.toggle?default('false') == 'true']
 onclick="handleOnSelectShowHide(this);"[#rt/]
[/#if]
/>[#rt/]

[#if parameters.toggle?default('false') == 'true']
<script type="text/javascript">
<!--
    function init${parameters.id?html}${itemKey?html}()
    {
        handleOnSelectShowHide(document.getElementById("${parameters.id?html}${itemKey?html}"));
    }

    addUniversalOnload(init${parameters.id?html}${itemKey?html});
//-->
</script>
[/#if]


