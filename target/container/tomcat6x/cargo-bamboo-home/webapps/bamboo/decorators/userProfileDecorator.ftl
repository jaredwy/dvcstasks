[#include "/fragments/decorator/htmlHeader.ftl"]
[#include "/fragments/decorator/header.ftl"]
[#import "/lib/menus.ftl" as menu/]

<div id="bd">
<div id="content">

<h1>[@ww.text name="user.profile"/] [@ui.displayUserFullName user=ctx.getUser(req) /]</h1>

[@menu.displayTabbedContent location="system.user" selectedTab='${page.properties["meta.tab"]}' admin=true]
    ${body}
[/@menu.displayTabbedContent]

</div> <!-- END #content -->
</div> <!-- END #bd -->
[#include "/fragments/decorator/footer.ftl"]