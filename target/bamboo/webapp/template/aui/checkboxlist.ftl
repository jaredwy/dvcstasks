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

    [#assign itemCount = 0/]
    [#if parameters.list??]
        [#if parameters.matrix!false]
            <div class="matrix">
        [/#if]

        [@ww.iterator value="parameters.list"]
            [#assign itemCount = itemCount + 1/]
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
            <div class="checkbox">
                <input type="checkbox" class="checkbox" name="${parameters.name?html}" value="${itemKey?html}" id="${parameters.name?html}-${itemCount}" [#rt/]
                    [#if tag.contains(parameters.nameValue, itemKey)]checked="checked" [#t/][/#if]
                    [#if parameters.disabled!false]disabled="disabled" [#t/]
                    [#elseif parameters.disabledList??]
                        [#if tag.contains(stack.findValue(parameters.disabledList), itemKey)]disabled="disabled" [#t/][/#if]
                    [/#if]
                    [#if parameters.title??]title="${parameters.title?html}" [#t/][/#if]
                    [#include "/${parameters.templateDir}/simple/scripting-events.ftl" /]
                />[#lt/]
                <label for="${parameters.name?html}-${itemCount}">[#rt]
                    [#if parameters.i18nPrefixForValue?has_content]
                        [@ww.text name='${parameters.i18nPrefixForValue}.${itemValue}' /][#t]
                    [#else]
                        ${itemValue?html}[#t/]
                    [/#if]
                </label>
            </div>
        [/@ww.iterator]
        [#if parameters.matrix?? && parameters.matrix==true]
            </div>
        [/#if]
    [/#if]
    <div class="field-group">
        [#include "/${parameters.templateDir}/${parameters.theme}/controlfooter-core.ftl" /]
    </div>

    <input type="hidden" name="checkBoxFields" value="${parameters.name?html}" />
</fieldset>
