[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]
[#-- @ftlvariable name="decoratedResult" type="com.atlassian.bamboo.ww2.beans.DecoratedResult" --]
[#import "/lib/chains.ftl" as chains]
[#import "/lib/menus.ftl" as menu/]

[#include "/fragments/decorator/htmlHeader.ftl"]
[#include "/fragments/decorator/header.ftl"]

[#if (navigationContext.currentObject)?? && navigationContext.currentObject.isResult()]
    [#assign decoratedResult = navigationContext.currentObject/]
    <div id="content">
        <div id="build-details">
            [@dj.reloadPortlet id='latestStatusHolder' url='${req.contextPath}/ajax/showLatestBuildStatus.action?planKey=${decoratedResult.planKey}' reloadEvery=10]
                [#include "/fragments/plan/latestStatus.ftl"]
            [/@dj.reloadPortlet]                
            [#include "/fragments/breadCrumbs.ftl"]
            [#if decoratedResult?? && decoratedResult.description?has_content]
                <div class="plan-description">${decoratedResult.description?html}</div>
            [/#if]
        </div>
        [@chains.statusRibbon navigationContext /]
        <div id="build-container">
            <div id="plan-navigator">
                [@chains.planNavigator navigationContext /]
                [@ui.renderWebPanels 'plan.navigator' /]
            </div>
            <div id="build-content">
                [#if decoratedResult.type == "CHAIN"]
                    [@menu.chainResultSubMenu selectedTab='${page.properties["meta.tab"]!}']${body}[/@menu.chainResultSubMenu]
                [#else]
                    [@menu.buildResultSubMenu selectedTab='${page.properties["meta.tab"]!}']${body}[/@menu.buildResultSubMenu]
                [/#if]
            </div>
        </div>
    </div>
    <a class="hidden" href="${req.contextPath}/build/admin/edit/editBuildConfiguration.action?buildKey=${decoratedResult.key}" accesskey="E">Edit Plan</a>
[#else]
    [@ui.messageBox type="error" title="Apologies, this page could not be properly decorated (data is missing)" /]
    ${body}
[/#if]
[#include "/fragments/decorator/footer.ftl"]
