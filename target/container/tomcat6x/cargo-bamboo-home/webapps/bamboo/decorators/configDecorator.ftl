[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]
[#-- @ftlvariable name="decoratedPlan" type="com.atlassian.bamboo.ww2.beans.DecoratedPlan" --]

[#include "/fragments/decorator/htmlHeader.ftl"]
[#include "/fragments/decorator/header.ftl"]
[#import "/lib/chains.ftl" as chains]
[#import "/lib/menus.ftl" as menu/]
[#if (navigationContext.currentObject)?? && !navigationContext.currentObject.isResult()]
    [#assign decoratedPlan = navigationContext.currentObject/]
    <script type="text/javascript">
        BAMBOO.currentPlan = {
            key: '${decoratedPlan.key}',
            name: '${decoratedPlan.displayName}'
        };
    </script>
    <div id="content">
        <div id="build-details">
            [#if decoratedPlan??]
                [@dj.reloadPortlet id='latestStatusHolder' url='${req.contextPath}/ajax/showLatestBuildStatus.action?planKey=${decoratedPlan.key}' reloadEvery=10]
                    [#include "/fragments/plan/latestStatus.ftl"]
                [/@dj.reloadPortlet]
            [/#if]
            [#include "/fragments/breadCrumbs.ftl"]
            [#if decoratedPlan?? && decoratedPlan.description?has_content]
                <div class="plan-description">${decoratedPlan.description?html}</div>
            [/#if]
        </div>
        <div id="build-container">
            <div id="plan-navigator">
                [@chains.planNavigator navigationContext /]
                [@ui.renderWebPanels 'plan.navigator' /]
            </div>
            <div id="build-content">
                [#if decoratedPlan.type == "CHAIN"]
                    [#assign tabLocation = "chainConfiguration.subMenu" /]
                [#else]
                    [#assign tabLocation = "planConfiguration.subMenu"/]
                [/#if]
                [@menu.editPlanConfigurationTabs decoratedPlan=decoratedPlan selectedTab='${page.properties["meta.tab"]!}' location=tabLocation]
                    ${body}
                [/@menu.editPlanConfigurationTabs]
            </div>
        </div>
    </div>
[#else]
    [@ui.messageBox type="error" title="Apologies, this page could not be properly decorated (data is missing)" /]
    ${body}
[/#if]
[#include "/fragments/decorator/footer.ftl"]
