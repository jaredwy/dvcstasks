[#include "/fragments/decorator/setupHeader.ftl"]
<div id="hd">
<div id="header">
    <div id="logo">
        <a href="${req.contextPath}/start.action" rel="nofollow">[@ww.text name='bamboo.name' /]</a>
    </div>
</div> <!-- END #header -->
</div> <!-- END #hd -->
<div id="bd">
<div id="content">
    <div id="setup-content">
${body}
    </div>
</div> <!-- END #content -->
</div> <!-- END #bd -->
[#include "/fragments/decorator/setupFooter.ftl"]