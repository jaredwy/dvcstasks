${parameters.after?if_exists}
[#if parameters.description?has_content || parameters.descriptionKey?has_content || parameters.helpUri?has_content || parameters.helpKey?has_content|| parameters.optionDescription?has_content || (parameters.labelKey?has_content && action.doesLabelKeyHaveMatchingDescription(parameters.labelKey))]
<div class="fieldDescription"
[#if parameters.id?exists]
 id="${parameters.id?html}Desc"[#rt/]
[/#if]
>
    [#if parameters.descriptionKey?has_content]
        [@ww.text name="${parameters.descriptionKey}" /][#t/]
    [#elseif parameters.description?has_content ]
        ${parameters.description}[#t/]
    [#elseif parameters.labelKey?has_content && action.doesLabelKeyHaveMatchingDescription(parameters.labelKey)]
        ${action.getDescriptionFromLabelKey(parameters.labelKey)}[#t/]
    [/#if]
    [#if parameters.helpKey?has_content]
        [@help.icon pageKey=parameters.helpKey/]
    [#elseif parameters.helpUri?has_content]
        <a href="${req.contextPath}/help/${parameters.helpUri}" onclick="openHelp('${req.contextPath}/help/${parameters.helpUri}');return false;"><img src="${req.contextPath}/images/question_and_answer.gif" alt="more info about this option..." width="16" height="16" border="0"/></a>
    [/#if]
</div>
[/#if]
    [#lt/]
</div> [#rt/]
<div class="clearer"></div>