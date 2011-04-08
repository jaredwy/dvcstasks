[@ww.iterator value="parameters.list"]
    [#if parameters.listKey?exists]
        [#assign itemKey = stack.findValue(parameters.listKey)/]
    [#else]
        [#assign itemKey = stack.findValue('top')/]
    [/#if]
    [#if parameters.listValue?exists]
        [#assign itemValue = stack.findString(parameters.listValue)/]
    [#else]
        [#assign itemValue = stack.findString('top')/]
    [/#if]
<input type="radio" name="${parameters.name?html}" id="${parameters.id?html}${itemKey?html}"[#rt/]
[#if tag.contains(parameters.nameValue, itemKey)]
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
<label for="${parameters.id?html}${itemKey?html}">[#rt/]
    [#if parameters.i18nPrefixForValue?has_content]
        [@ww.text name='${parameters.i18nPrefixForValue}.${itemValue}' /][#t]
    [#else]
        ${itemValue}[#t/]
    [/#if]
</label>
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
[#if parameters.listDescription?? || parameters.showDescription??]
<div class="radioOptionDescription fieldDescription">
    [#if parameters.i18nPrefixForValue?has_content]
        [@ww.text name='${parameters.i18nPrefixForValue}.${itemValue}.description' /][#t]
    [#else]
        ${stack.findString(parameters.listDescription)!}[#t/]
    [/#if]
</div>
[#else]

[#if !(parameters.showNewLine?? && parameters.showNewLine == 'false')]
<br />
[/#if]

[/#if]
[/@ww.iterator]


