[#include "/${parameters.templateDir}/${parameters.theme}/controlheader.ftl" /]
[#if parameters.cssClass??]
    ${tag.addParameter("cssClass", "textarea ${parameters.cssClass}") }
[#else]
    ${tag.addParameter("cssClass", "textarea") }
[/#if]
[#include "/${parameters.templateDir}/simple/textarea.ftl" /]
[#include "/${parameters.templateDir}/${parameters.theme}/controlfooter.ftl" /]
