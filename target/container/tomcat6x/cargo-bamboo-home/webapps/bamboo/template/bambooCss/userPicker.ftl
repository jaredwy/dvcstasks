[#include "/${parameters.templateDir}/${parameters.theme}/controlheader.ftl" /]
[#include "/${parameters.templateDir}/simple/text.ftl" /]
[#if parameters.multiSelect?exists]
<a href="#" onclick="var picker = window.open('${req.contextPath}/admin/user/userPickerSearch.action?fieldId=${parameters.id}&multiSelect=${parameters.multiSelect?string}', 'EntitiesPicker', 'status=yes,resizable=yes,top=100,left=200,width=900,height=680,scrollbars=yes'); picker.focus(); return false;"><img src="${req.contextPath}/images/icons/user_16.gif" height="16" width="16" border="0"  title="User Picker" /></a>
[#else]
<a href="#" onclick="var picker = window.open('${req.contextPath}/admin/user/userPickerSearch.action?fieldId=${parameters.id}', 'EntitiesPicker', 'status=yes,resizable=yes,top=100,left=200,width=900,height=680,scrollbars=yes'); picker.focus(); return false;"><img src="${req.contextPath}/images/icons/user_16.gif" height="16" width="16" border="0"  title="User Picker" /></a>
[/#if]
[#include "/${parameters.templateDir}/${parameters.theme}/controlfooter.ftl" /]
