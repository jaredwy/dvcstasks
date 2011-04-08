[#-- @ftlvariable name="crumbs" type="java.util.Collection<com.atlassian.breadcrumbs.BreadCrumb>" --]

[#macro displayCrumbs crumbs]
    [#list crumbs as crumb]
        [#if crumb.shown]
            [#if crumb.currentPage]
                <span>[#if crumb.disabled?? && crumb.disabled][@ui.icon text='Disabled' type="disabled"/]&nbsp;[/#if]<a href="[@ww.url value='${crumb.url!}' /]" id="breadcrumb:${crumb.id!}"[#if crumb.accessKey??] accesskey="${crumb.accessKey}"[/#if][#if crumb.title??] title="${crumb.title}: ${crumb.label!}"[/#if] class="current">${crumb.labelWithAccessKeyUnderlined!}</a></span>
            [#else]
                <span>[#if (crumb.disabled)!false][@ui.icon text='Disabled' type="disabled"/]&nbsp;[/#if]<a href="[@ww.url value='${crumb.url!}' /]" id="breadcrumb:${crumb.id!}"[#if crumb.accessKey??] accesskey="${crumb.accessKey}"[/#if][#if crumb.title??] title="${crumb.title}: ${crumb.label!}"[/#if]>${crumb.labelWithAccessKeyUnderlined!}</a></span>
                [@displayCrumbs crumbs=crumb.childCrumbs /]
            [/#if]
            [#break /]
        [/#if]
    [/#list]
[/#macro]

<div id="breadcrumb">[@displayCrumbs crumbs=breadCrumbs /]</div>
<!--[if lt IE 8]>
<script type="text/javascript">
    AJS.$(function($){
        $("#breadcrumb > span:not(.disabled, :first-child)").prepend('<span class="breadcrumb-separator">&rsaquo;</span>');
    });
</script>
<![endif]-->