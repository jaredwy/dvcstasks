[#--NB: Do not use references to BambooActionSupport.class in this file, you must use ctx (FreemarkerContext) instead--]
[#if ctx.pluggableTopNavigation??]
  ${ctx.pluggableTopNavigation.getHtml(req)}
[#else]
<div id="hd">

[#include "/fragments/decorator/bambooBanner.ftl"]

[#assign topCrumb = page.getProperty("meta.topCrumb")!('') /]
<div id="menu">
    <ul>
        <li [#if topCrumb == 'home']class="on"[/#if]><a id="home" href="${req.contextPath}/start.action" title="Atlassian Bamboo" accesskey="H">[@ww.text name='menu.home' /]</a></li>
        [#if ctx?? && ctx.hasBuilds()]
            <li [#if topCrumb == 'authors']class="on"[/#if]><a id="authors" href="${req.contextPath}/authors/gotoAuthorReport.action" accesskey="U">[@ww.text name='menu.authors' /]</a></li>
            <li [#if topCrumb == 'reports']class="on"[/#if]><a id="reports" href="${req.contextPath}/reports/viewReport.action" accesskey="R">[@ww.text name='menu.reports' /]</a></li>
        [/#if]
        [#if fn.hasGlobalPermission('CREATE')]
            <li [#if topCrumb == 'create']class="on"[/#if]><a id="createPlanLink"  accesskey="C" href="${req.contextPath}/build/admin/create/addPlan.action">[@ww.text name='menu.createPlan' /]</a></li>
        [/#if]
        [#if fn.hasAdminPermission()]
            <li [#if topCrumb == 'admin']class="on"[/#if]><a id="admin" accesskey="A" href="${req.contextPath}/admin/administer.action">[@ww.text name='menu.administration' /]</a></li>
        [/#if]
    </ul>
</div> <!-- END #menu -->
[#include "../../fragments/showAdminErrors.ftl"]
</div> <!-- END #hd -->
[/#if]
