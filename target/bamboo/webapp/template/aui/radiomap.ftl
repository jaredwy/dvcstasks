<fieldset[#if (parameters.id)?has_content] id="fieldArea_${parameters.id}"[/#if] class="group[#if parameters.required!false] required[/#if]">

    [#if parameters.label?? || parameters.labelKey??]
        <legend[#if (parameters.id)?has_content] id="fieldLabelArea_${parameters.id}"[/#if]><span>[#rt/]
            [#if parameters.labelKey?has_content]
                [@ww.text name=parameters.labelKey /][#t/]
            [#elseif parameters.label?has_content]
                ${parameters.label}[#t/]
            [/#if]
            [#if parameters.required!false]
                <span class="aui-icon icon-required"></span><span class="content"> (required)</span>[#t/]
            [/#if]
        </span></legend>[#lt/]
    [/#if]

    [@ww.iterator value="parameters.list"]
        [#if parameters.listKey??]
            [#assign itemKey = stack.findValue(parameters.listKey)/]
        [#else]
            [#assign itemKey = stack.findValue('top')/]
        [/#if]
        [#if parameters.listValue??]
            [#assign itemValue = stack.findString(parameters.listValue)/]
        [#else]
            [#assign itemValue = stack.findString('top')/]
        [/#if]
        <div class="radio">
            <input type="radio" name="${parameters.name?html}" id="${parameters.id?html}${itemKey?html}" [#rt/]
                [#if tag.contains(parameters.nameValue, itemKey)  || (parameters.nameValue?? && parameters.nameValue?string == itemKey)]checked="checked" [#t/][/#if]
                [#if itemKey??]value="${itemKey?html}" [#t/][/#if]
                [#if parameters.disabled!false]disabled="disabled" [#t/][/#if]
                [#if parameters.tabindex??]tabindex="${parameters.tabindex?html}" [#t/][/#if]
                [#if parameters.cssClass??]class="${parameters.cssClass?html}" [#t/][/#if]
                [#if parameters.cssStyle??]style="${parameters.cssStyle?html}" [#t/][/#if]
                [#if parameters.title??]title="${parameters.title?html}" [#t/][/#if]
                [#include "/${parameters.templateDir}/simple/scripting-events.ftl" /]
                [#if (parameters.toggle!false)?string == 'true']onclick="handleOnSelectShowHide(this);" [#t/][/#if]
            />[#lt/]
            <label for="${parameters.id?html}${itemKey?html}">[#rt/]
                [#if parameters.i18nPrefixForValue?has_content]
                    [@ww.text name='${parameters.i18nPrefixForValue}.${itemValue}' /][#t]
                [#else]
                    ${itemValue}[#t/]
                [/#if]
            </label>[#lt/]
            [#if (parameters.toggle!false)?string == 'true']
                <script type="text/javascript">
                    function init${parameters.id?html}${itemKey?html}() {
                        handleOnSelectShowHide(document.getElementById("${parameters.id?html}${itemKey?html}"));
                    }
                    addUniversalOnload(init${parameters.id?html}${itemKey?html});
                </script>
            [/#if]
            [#if parameters.listDescription?? || parameters.showDescription??]
                <div class="description">[#rt/]
                    [#if parameters.i18nPrefixForValue?has_content]
                        [@ww.text name='${parameters.i18nPrefixForValue}.${itemValue}.description' /][#t/]
                    [#else]
                        ${stack.findString(parameters.listDescription)!}[#t/]
                    [/#if]
                </div>[#lt/]
            [/#if]
        </div>
    [/@ww.iterator]
    <div class="field-group">
        [#include "/${parameters.templateDir}/${parameters.theme}/controlfooter-core.ftl" /]
    </div>

</fieldset>
