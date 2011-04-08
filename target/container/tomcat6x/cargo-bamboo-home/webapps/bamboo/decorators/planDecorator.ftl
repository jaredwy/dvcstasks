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
            [@dj.reloadPortlet id='latestStatusHolder' url='${req.contextPath}/ajax/showLatestBuildStatus.action?planKey=${decoratedPlan.key}' reloadEvery=10]
                [#include "/fragments/plan/latestStatus.ftl"]
            [/@dj.reloadPortlet]
            [#include "/fragments/breadCrumbs.ftl"]
            [#if decoratedPlan.description?has_content]
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
                        [@menu.chainSubMenu selectedTab='${page.properties["meta.tab"]!}' ]
                              ${body}
                        [/@menu.chainSubMenu]
                  [#else]
                        [@menu.buildSubMenu selectedTab='${page.properties["meta.tab"]!}' ]
                              ${body}
                        [/@menu.buildSubMenu]
                  [/#if]
            </div>
        </div>
    </div>
    <a class="hidden" href="${req.contextPath}/build/admin/edit/editBuildConfiguration.action?buildKey=${decoratedPlan.key}" accesskey="E">Edit Plan</a>
[#else]
    [@ui.messageBox type="error"]
        [@ww.text name="Apologies, this page could not be properly decorated (data is missing)"/]
    [/@ui.messageBox]
    <div id="build-content">${body}</div>
[/#if]
[#include "/fragments/decorator/footer.ftl"]
