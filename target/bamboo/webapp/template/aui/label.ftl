[#if parameters.hideOnNull?? && parameters.hideOnNull?string == 'true' && (!parameters.nameValue?has_content || parameters.nameValue == '[]' || parameters.nameValue == 'false' || parameters.nameValue == '0')]
    [#else]
        [#include "/${parameters.templateDir}/${parameters.theme}/controlheader.ftl" /]
        [#if parameters.cssClass??]
        ${tag.addParameter("cssClass", "field-value ${parameters.cssClass}") }
            [#else]
            ${tag.addParameter("cssClass", "field-value") }
        [/#if]
        [#include "/${parameters.templateDir}/simple/label.ftl" /]
        [#if parameters.description?has_content || parameters.descriptionKey?has_content || parameters.showDescription?has_content]
            [#include "/${parameters.templateDir}/${parameters.theme}/controlfooter.ftl" /]
        [#else]
            [#include "/${parameters.templateDir}/${parameters.theme}/controlfooter-nodescription.ftl" /]
        [/#if]
[/#if]





