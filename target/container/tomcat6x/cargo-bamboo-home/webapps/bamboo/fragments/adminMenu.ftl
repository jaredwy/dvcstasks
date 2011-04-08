[#if fn.hasAdminPermission() ]
    [#assign adminCrumb = page.getProperty("meta.adminCrumb")!('') /]
    [#assign location='system.admin'/]
    <ul id="admin-menu">
    [#assign webSections = ctx.getWebSectionsForAdminLocation(location, req) /]
    [#list webSections as section ]
        <li>
            [#if section.icon?exists]
                [#assign icon = section.icon]
                <h2 style="background-image: url(${icon.url.getDisplayableUrl(req)})">[#rt/]
            [#else]
                <h2>[#rt/]
            [/#if]
            ${section.webLabel.displayableLabel}[#t/]
            </h2>[#lt/]
            <ul>
                [#assign webItems = ctx.getWebItemsForAdminSection(location + '/' + section.key, req) /]
                [#list webItems as item]
                    [#if item.link.id?has_content]
                        [#assign linkId = item.link.id /]
                    [#elseif item.key?has_content]
                        [#assign linkId = item.key /]
                    [/#if]
                    <li[#if adminCrumb == item.link.id || item.link.getDisplayableUrl(req)?ends_with(ctx.getCurrentUrl(req))] class="active"[/#if]>[#rt]
                        <a id="${linkId!}" href="${item.link.getDisplayableUrl(req)}">${item.webLabel.displayableLabel}</a>[#t]
                    </li>[#lt]
                [/#list]
            </ul>
        </li>
    [/#list]
    </ul>
[/#if]




