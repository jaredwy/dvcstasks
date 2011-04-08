[#include "/${parameters.templateDir}/${parameters.theme}/controlheader.ftl" /]
[#if parameters.cssClass??]
    ${tag.addParameter("cssClass", "text ${parameters.cssClass}") }
[#else]
    ${tag.addParameter("cssClass", "text") }
[/#if]
[#include "/${parameters.templateDir}/simple/text.ftl" /]
<a class="user-picker" href="${req.contextPath}/admin/user/userPickerSearch.action?fieldId=${parameters.id}&amp;multiSelect=${(parameters.multiSelect!false)?string}" onclick="var picker = window.open(this.href, 'EntitiesPicker', 'status=yes,resizable=yes,top=100,left=200,width=900,height=680,scrollbars=yes'); picker.focus(); return false;"><span class="aui-icon icon-users">User Picker</span></a>
[#include "/${parameters.templateDir}/${parameters.theme}/controlfooter.ftl" /]
