[#include "/fragments/decorator/htmlHeader.ftl"]

<div id="hd">

<div id="header">
    <div id="logo">
        <a href="${req.contextPath}/start.action" rel="nofollow">[@ww.text name='bamboo.name' /]</a>
    </div>
    <ul id="userOptions">
        <li id="helpLink">
            <a id="help" href="http://confluence.atlassian.com/display/BAMBOO">[@ww.text name='bamboo.banner.help' /]</a>
        </li>
    </ul>
</div> <!-- END #header -->
</div>

<div id="bd">
<div id="content">
	<div id="picker-content">
		${body}
	</div>
</div> <!-- END #content -->
</div> <!-- END #bd -->
[#include "/fragments/decorator/minimalFooter.ftl" /]
