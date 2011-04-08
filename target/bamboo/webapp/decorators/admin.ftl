[#include "/fragments/decorator/htmlHeader.ftl"]
[#include "/fragments/decorator/header.ftl"]

<div id="bd">
    <div id="content">
        [#include "/fragments/adminMenu.ftl"]
        <div id="admin-content">
            ${body}
        </div>
    </div>
</div>
[#include "/fragments/decorator/footer.ftl"]