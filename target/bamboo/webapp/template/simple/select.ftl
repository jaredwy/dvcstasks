<select[#rt/]
 name="${parameters.name?default("")?html}"[#rt/]
[#if parameters.get("size")?exists]
 size="${parameters.get("size")?html}"[#rt/]
[/#if]
[#if parameters.disabled?default(false)]
 disabled="disabled"[#rt/]
[/#if]
[#if parameters.tabindex?exists]
 tabindex="${parameters.tabindex?html}"[#rt/]
[/#if]
[#if parameters.id?exists]
 id="${parameters.id?html}"[#rt/]
[/#if]
 class="[#rt/]
    [#if parameters.submitOnChange?default('false') == 'true']
      submitOnChange [#t/]
    [/#if]
    [#if parameters.cssClass??]
       ${parameters.cssClass?html}[#rt/]
    [/#if]
" [#rt/]
[#if parameters.cssStyle?exists]
 style="${parameters.cssStyle?html}"[#rt/]
[/#if]
[#if parameters.title?exists]
 title="${parameters.title?html}"[#rt/]
[/#if]
[#if parameters.multiple?default(false)]
 multiple="multiple"[#rt/]
[/#if]
[#include "/${parameters.templateDir}/simple/scripting-events.ftl" /]

>[#t/]
[#if parameters.headerKey?exists && parameters.headerValue?exists]
    <option value="${parameters.headerKey?html}">${parameters.headerValue?html}</option>
[/#if]
[#if parameters.headerKey2?exists && parameters.headerValue2?exists]
    <option value="${parameters.headerKey2?html}"
    [#if parameters.nameValue?string == parameters.headerKey2]
 selected="selected"[#rt/]
    [/#if]
            >${parameters.headerValue2?html}</option>
[/#if]
[#if parameters.emptyOption?default(false)]
    <option value=""></option>
[/#if]
[@ww.iterator value="parameters.list"]
        [#if parameters.groupBy?exists || parameters.groupLabel?exists]
            [#if parameters.groupBy?exists]
                [#assign groupLabel = stack.findValue(parameters.groupBy)/]
            [#elseif parameters.groupLabel?exists]
                [#assign groupLabel = parameters.groupLabel/]
            [/#if]
            [#if !currentGroupLabel?has_content && groupLabel?exists]
                [#assign currentGroupLabel = groupLabel/]
                <optgroup label="${currentGroupLabel}">
            [#elseif currentGroupLabel?exists && groupLabel?exists && currentGroupLabel != groupLabel]
                </optgroup>
                [#assign currentGroupLabel = groupLabel/]
                <optgroup label="${currentGroupLabel}">
            [/#if]
        [/#if]

        [#if parameters.listKey?exists]
            [#assign itemKey = stack.findValue(parameters.listKey)/]
        [#else]
            [#assign itemKey = stack.findValue('top')/]
        [/#if]
        [#assign itemKeyStr = itemKey.toString() /]
        [#if parameters.listValue?exists]
            [#assign itemValue = stack.findString(parameters.listValue)/]
        [#else]
            [#assign itemValue = stack.findString('top')/]
        [/#if]
    <option value="${itemKeyStr?html}"[#rt/]
        [#if parameters.uiSwitch?has_content]
            class="uiSwitch${stack.findString(parameters.uiSwitch)}"
        [/#if]
        [#if parameters.optionDescription?has_content]
            title="${stack.findString(parameters.optionDescription)?if_exists}"
        [/#if]
        [#if tag.contains(parameters.nameValue, itemKey) == true]
 selected="selected"[#rt/]
        [/#if]
    >[#t]
    [#if parameters.i18nPrefixForValue?has_content]
        [@ww.text name='${parameters.i18nPrefixForValue}.${itemValue}' /][#t]
    [#else]
        ${itemValue?html}[#t/]
    [/#if]
    </option>[#lt/]
[/@ww.iterator]

[#if parameters.groupBy?exists || parameters.groupLabel?exists]
    [#if currentGroupLabel?has_content]
        </optgroup>
    [/#if]
[/#if]

[#if parameters.footerKey?? && parameters.footerValue??]
    <option value="${parameters.footerKey?html}"
    [#if parameters.nameValue?? && parameters.nameValue?string == parameters.footerKey]
     selected="selected"[#rt/]
    [/#if]
>${parameters.footerValue?html}</option>
[/#if]
</select>
<input type="hidden" name="selectFields" value="${parameters.name?html}" />[#rt/]        

[#--lets migrate to boolean toggle--]
[#assign doToggle = parameters.toggle?? && ((parameters.toggle?is_string && parameters.toggle == "true") || (parameters.toggle?is_boolean && parameters.toggle)) /]

[#if parameters.id?has_content]
    [#if doToggle || parameters.optionDescription?has_content]
    <script type="text/javascript">
    //<![CDATA[
        AJS.$(function($) {
            $("#${parameters.id?html}").change(function(){
                [#if doToggle ]
                handleOnSelectShowHide(this);
                [/#if]
                [#if parameters.optionDescription?has_content ]
                var $select = $(this);
                $select.nextAll(".description").html($select.find("option:selected").attr("title"));
                [/#if]
            }).change();
        });
    //]]>
    </script>
    [/#if]
[/#if]