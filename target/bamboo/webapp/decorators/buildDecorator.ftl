[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]
[#include "/fragments/decorator/htmlHeader.ftl"]
[#include "/fragments/decorator/header.ftl"]
[#import "/lib/chains.ftl" as chains]
<div id="content">
    [#if breadCrumbs?has_content]
        <div id="build-details">
            [#include "/fragments/breadCrumbs.ftl"]
            [#if plan?? && plan.description?has_content]
                <div class="plan-description">${plan.description?html}</div>
            [#elseif build?? && build.description?has_content]
                <div class="plan-description">${build.description?html}</div>
            [/#if]
        </div>
    [/#if]
    <div id="build-content">${body}</div>
</div>
[#if plan??]
    <a class="hidden" href="${req.contextPath}/build/admin/edit/editBuildConfiguration.action?buildKey=${plan.key}" accesskey="E">Edit Plan</a>
[/#if]
[#include "/fragments/decorator/footer.ftl"]
