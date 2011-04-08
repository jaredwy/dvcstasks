[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]
[#-- ========================================================================-===================== @cp.chainSubMenu --]

[#macro chainSubMenu selectedTab='summary']
 [@displayExternalOperations]
    [#if filterController??]
        <li>
            [@displayFilterController filterController=filterController plan=plan/]
        </li>
    [/#if]
    [#if plan?? && plan.type == 'CHAIN']
        [#assign planLevelItems]
              [#if plan.suspendedFromBuilding]
                    [@displayPlanResumeLink plan 'chain.enable'/]
              [#else]
                    [@displayManualStartLink plan=plan labelKey='chain.run' /]
                    [@displayParametrisedManualStartLink plan=plan labelKey="chain.run.parameterised" /]
                    [@displayPlanSuspendLink plan 'chain.disable'/]
              [/#if]
              [#if user??]
                [@displayFavouriteToggler plan=plan/]
              [/#if]
              [@displayConfigureLink plan 'chain.edit'/]
              [@displayPlanDeleteLink plan 'chain.delete' '/start.action'/]
        [/#assign]
        [#assign buildLevelItems]
            [#assign numberOfRunningChains = action.getNumberOfCurrentlyBuildingPlans(plan.key) /]
            [#if numberOfRunningChains > 0]
                [@displayPlanStopLink plan 'chain.stop.all'/]
                [#--[@displayPlanCancelLink plan "chain.abandon"/]--]
            [/#if]
        [/#assign]
        [#if planLevelItems?has_content || buildLevelItems?has_content]
            <li>
                [@ui.groupedMenu triggerText="Actions" id="buildMenuParent"]
                    [#if planLevelItems?has_content]
                        <ul>${planLevelItems}</ul>
                    [/#if]
                    [#if buildLevelItems?has_content]
                        <ul>${buildLevelItems}</ul>
                    [/#if]
                [/@ui.groupedMenu]
            </li>
        [/#if]
    [/#if]
  [/@displayExternalOperations]

[@displayTabbedContent selectedTab=selectedTab location="chain.subMenu"]
    [#nested]
[/@displayTabbedContent]
[/#macro]

[#-- ========================================================================-===================== @cp.buildSubMenu --]

[#macro buildSubMenu selectedTab='summary']
    [@displayExternalOperations]
        [#if filterController??]
            <li>
                [@displayFilterController filterController=filterController plan=plan/]
            </li>
        [/#if]

        [#if plan??]
            [#assign planLevelItems]
                [@displayManualStartLink plan=plan.parent labelKey="chain.run" /]
                [@displayParametrisedManualStartLink plan=plan.parent labelKey="chain.run.parameterised" /]
            [/#assign]
            [#assign jobLevelItems]
                [#if plan.suspendedFromBuilding]
                    [@displayPlanResumeLink plan 'job.enable'/]
                [#else]
                    [@displayPlanSuspendLink plan 'job.disable'/]
                [/#if]
                [#if user??]
                    [@displayFavouriteToggler plan=plan /]
                [/#if]
                [@displayConfigureLink plan 'job.edit'/]
                [@displayPlanDeleteLink plan 'job.delete' '/browse/${plan.parent.key}'/]
            [/#assign]
            [#if planLevelItems?has_content || jobLevelItems?has_content]
                <li>
                    [@ui.groupedMenu triggerText="Actions" id="buildMenuParent"]
                        [#if planLevelItems?has_content]
                            <ul>${planLevelItems}</ul>
                        [/#if]
                        [#if jobLevelItems?has_content]
                            <ul>${jobLevelItems}</ul>
                        [/#if]
                    [/@ui.groupedMenu]
                </li>
            [/#if]
        [/#if]
    [/@displayExternalOperations]
    [@displayTabbedContent  selectedTab=selectedTab location="build.subMenu"]
        [#nested/]
    [/@displayTabbedContent]
[/#macro]

[#-- ============================================================================================ @cp.buildResultSubMenu --]


[#macro buildResultSubMenu selectedTab='summary']
    [@displayExternalOperations]
        [#if plan??]
            [#assign planLevelItems]
                [@displayManualStartLink plan=plan.parent labelKey="chain.run" /]
                [@displayParametrisedManualStartLink plan=plan.parent labelKey="chain.run.parameterised" /]
            [/#assign]
            [#assign jobLevelItems]
                [#if plan.suspendedFromBuilding]
                    [@displayPlanResumeLink plan 'job.enable'/]
                [#else]
                    [@displayPlanSuspendLink plan 'job.disable'/]
                [/#if]
                [@displayConfigureLink plan 'job.edit'/]
                [@displayPlanDeleteLink plan 'job.delete' '/browse/${plan.parent.key}'/]
            [/#assign]
            [#assign buildLevelItems]
                [#if resultsSummary.active]
                    [#if resultsSummary.inProgress || resultsSummary.queued]
                        [@displayResultStopLink resultsSummary "job.stop"/]
                        [#if plan.type != 'JOB']
                            [@displayResultCancelLink resultSummary "build.cancel"/]
                        [/#if]
                    [/#if]
                [/#if]
                [@displayResultCommentLink resultsSummary 'buildResult.comment.add'/]
                [#if plan.type != 'JOB']
                    [#if resultsSummary.finished || resultsSummary.notBuilt]
                        [@displayResultDeleteLink resultsSummary 'build.remove.result'/]
                    [/#if]
                [/#if]
            [/#assign]
            [#if planLevelItems?has_content || jobLevelItems?has_content || buildLevelItems?has_content]
                <li>
                     [@ui.groupedMenu triggerText="Actions" id="buildMenuParent"]
                                [#if planLevelItems?has_content]
                                    <ul>${planLevelItems}</ul>
                                [/#if]
                                [#if jobLevelItems?has_content]
                                    <ul>${jobLevelItems}</ul>
                                [/#if]
                                [#if buildLevelItems?has_content]
                                    <ul>${buildLevelItems}</ul>
                                [/#if]
                     [/@ui.groupedMenu]
                </li>
            [/#if]
        [/#if]
    [/@displayExternalOperations]
    [@displayTabbedContent selectedTab=selectedTab location="results.subMenu"  ]
        [#nested /]
    [/@displayTabbedContent]
[/#macro]

[#-- ============================================================================================ @cp.chainResultSubMenu --]

[#macro chainResultSubMenu selectedTab='summary']
    [@displayExternalOperations]
        <li>
            [#if plan??]
                [#assign planLevelItems]
                    [#if plan.suspendedFromBuilding]
                        [@displayPlanResumeLink plan 'chain.enable'/]
                    [#else]
                        [@displayManualStartLink plan=plan labelKey='chain.run' /]
                        [@displayParametrisedManualStartLink plan=plan labelKey="chain.run.parameterised" /]
                        [@displayPlanSuspendLink plan 'chain.disable'/]
                    [/#if]
                    [#if user??]
                        [@displayFavouriteToggler plan=plan/]
                    [/#if]
                    [@displayConfigureLink plan 'chain.edit'/]
                    [@displayPlanDeleteLink plan 'chain.delete' '/start.action'/]
                [/#assign]
                [#assign buildLevelItems]
                    [#if resultsSummary.active]
                        [@displayResultStopLink resultsSummary "chain.stop.result"/]
                    [/#if]
                    [@displayResultCommentLink resultsSummary 'buildResult.comment.add'/]
                    [#if resultsSummary.finished || resultsSummary.notBuilt]
                        [@displayResultDeleteLink resultsSummary 'chain.remove.result'/]
                    [/#if]
                [/#assign]

                [#if planLevelItems?has_content || buildLevelItems?has_content]
                    [@ui.groupedMenu triggerText="Actions" id="buildMenuParent"]
                        [#if planLevelItems?has_content]
                            <ul>${planLevelItems}</ul>
                        [/#if]
                        [#if buildLevelItems?has_content]
                            <ul>${buildLevelItems}</ul>
                        [/#if]
                    [/@ui.groupedMenu]
                [/#if]
            [/#if]
        </li>
    [/@displayExternalOperations]
    [@displayTabbedContent selectedTab=selectedTab  location="chainResults.subMenu" ]
        [#nested/]
    [/@displayTabbedContent]
[/#macro]

[#-- ========================================================================================== View Plan/Job Button --]
[#macro viewConfigButtons decoratedPlan]
    [#if decoratedPlan??]
        [@displayExternalOperations]
            <li>
                [@viewRunPlanButton decoratedPlan=decoratedPlan /]
            </li>    
            <li>
                [#if decoratedPlan.type == "JOB"]
                    <a class="view" href="[@ww.url value="/browse/${decoratedPlan.key}/config"/]">[@ww.text name="job.configuration.view"/]</a>
                [#else]
                    <a class="view"  href="[@ww.url value="/browse/${decoratedPlan.key}/config"/]">[@ww.text name="plan.configuration.view"/]</a>
                [/#if]
            </li>
        [/@displayExternalOperations]
    [/#if]
[/#macro]

[#-- ========================================================================================== Run Plan/Enable Plan Link --]
[#macro viewRunPlanLink decoratedPlan]
    [#if decoratedPlan??]
        [#if plan.type == 'CHAIN']
            [#assign chain=plan/]
        [#else]
            [#assign chain=plan.parent/]
        [/#if]
        [#if !chain.suspendedFromBuilding]
            [@displayManualStartLink plan=chain labelKey='chain.run' /]
        [#else]
            [@displayPlanResumeLink chain 'chain.enable'/]
        [/#if]
    [/#if]
[/#macro]

[#macro viewRunPlanButton decoratedPlan]
    [#if decoratedPlan??]
        [#if plan.type == 'CHAIN']
            [#assign chain=plan/]
        [#else]
            [#assign chain=plan.parent/]
        [/#if]
        [#if !chain.suspendedFromBuilding]
            [@displayManualStartButton plan=chain labelKey='chain.run' /]
        [#else]
            [@displayPlanResumeButton chain 'chain.enable'/]
        [/#if]
    [/#if]
[/#macro]

[#-- ============================================================================================ Plan Configuration --]
[#macro editPlanConfigurationTabs decoratedPlan selectedTab='' location="planConfiguration.subMenu"]
    [@viewConfigButtons decoratedPlan=decoratedPlan /]

    [@displayTabbedContent location=location selectedTab=selectedTab]
        [@ww.text name='build.configuration.edit.tabChangeConfirm' id='confirmText'/]
        [#assign savedTabCookieName= 'atlassian.bamboo.' + decoratedPlan.type?lower_case + '.config.tab.selected'/]

        <script type="text/javascript">
            [#-- update value of cookie controlling tab selection in buildConfiguration view (see buildConfiguration.ftl) --]
            AJS.$(function() {
                AJS.Cookie.save('${savedTabCookieName}', ${selectedIndex});
            });
            [#--todo dirty form checking --]
        </script>

        [#if saved?? && saved]
            [@ui.messageBox type="success" titleKey="${location}.confirmsave" /]
        [/#if]
        [#nested /]
    [/@displayTabbedContent]
[/#macro]

[#-- ============================================================================================ HELPER MACROS --]
[#macro displayExternalOperations cssClass=""]
    <ul id="external-operations" [#if cssClass?has_content]class="${cssClass}"[/#if]>
        [#nested/]
    </ul>
[/#macro]

[#macro displayTabbedContent selectedTab location admin=false]
<div class="aui-tabs horizontal-tabs non-dynamic-tabs">
    <ul class="tabs-menu">
        [#if admin]
            [@displayTabsNoAction selectedTab location/]
        [#else]
            [@displayTabs selectedTab location/]
        [/#if]
    </ul>
    <div class="tabs-pane active-pane">
        [#nested /]
    </div>
</div>
[/#macro]

[#macro displayTabs selectedTab location]
    [#assign selectedIndex = 0/]
    [#list action.getWebSectionsForLocation(location) as section ]
        [#list action.getWebItemsForSection(location + '/' + section.key) as item]
            [#assign id=item.link.getRenderedId(webFragmentsContextMap)/]
            [#if !id??]
                [#assign id=action.renderFreemarkerTemplate(item.key)?html/]
            [/#if]
            [#assign url=item.link.getDisplayableUrl(req, webFragmentsContextMap)]
            <li class="menu-item[#if selectedTab == item.name] active-tab[/#if]">
                <a [#if id??] id="${id}"[/#if] href="${url}"><strong>${item.webLabel.displayableLabel}</strong></a>
            </li>
            [#if selectedTab == item.name]
                [#assign selectedIndex=item_index /]
            [/#if]
        [/#list]
    [/#list]
[/#macro]

[#macro displayTabsNoAction selectedTab location]
    [#assign selectedIndex = 0/]
    [#list ctx.getWebSectionsForAdminLocation(location, req) as section ]
        [#list ctx.getWebItemsForAdminSection(location + '/' + section.key, req) as item]
            [#assign url=item.link.getDisplayableUrl(req)]
            [#assign id=item.link.getRenderedId(ctx.getWebFragmentsContextMapForAdminMenu(req))/]
            [#if !id??]
                [#assign id=ctx.renderFreemarkerTemplateForAdmin(item.key, req)?html/]
            [/#if]
            <li class="menu-item[#if selectedTab == item.name] active-tab[/#if]">
                <a [#if id??] id="${id}"[/#if] href="${url}"><strong>${item.webLabel.displayableLabel}</strong></a>
            </li>
        [/#list]
    [/#list]
[/#macro]

[#macro displayFilterController filterController plan]
    [@ui.standardMenu triggerText="Showing ${filterController.selectedFilterName}" id="filterMenuParent"]
        [#list filterController.filterMap.keySet() as key]
            [@ww.url id="filterUrl" action="setResultsFitler" namespace="/build" returnUrl=currentUrl buildKey="${plan.key}"]
                [@ww.param name="filterController.selectedFilterKey"]${key}[/@ww.param]
            [/@ww.url]
            [@ui.displayLink id="filter:${key}"
                             title=filterController.filterMap[key]
                             href=filterUrl
                             inList=true /]
        [/#list]
    [/@ui.standardMenu]
[/#macro]

[#macro displayManualStartButton plan labelKey]
    [#if fn.hasPlanPermission('BUILD', plan)]
        [#if !plan.suspendedFromBuilding]
            [#if !plan.active || action.getNumberOfCurrentlyBuildingPlans(plan.key) < plan.buildDefinition.configObjects.get("custom.concurrentBuilds.planLevelConfig").effectiveNumberOfConcurrentBuilds]
                [@ww.url id='startPlanUrl' action="triggerManualBuild" namespace="/build/admin" buildKey="${plan.key}" /]
                <a href="${startPlanUrl}" id="manualBuild_${plan.key}">[@ui.icon type="build-run"/] [@ww.text name=labelKey/]</a>
            [/#if]
        [/#if]
    [/#if]
[/#macro]

[#macro displayManualStartLink plan labelKey]
    [#if fn.hasPlanPermission('BUILD', plan)]
        [#if !plan.suspendedFromBuilding]
            [#if !plan.active || action.getNumberOfCurrentlyBuildingPlans(plan.key) < plan.buildDefinition.configObjects.get("custom.concurrentBuilds.planLevelConfig").effectiveNumberOfConcurrentBuilds]
                [@ww.url id='startPlanUrl' action="triggerManualBuild" namespace="/build/admin" buildKey="${plan.key}" /]
                [@ui.displayLink id="manualBuild_${plan.key}"
                                 titleKey=labelKey
                                 href=startPlanUrl
                                 icon="build-run"
                                 inList=true /]
            [/#if]
        [/#if]
    [/#if]
[/#macro]

[#macro displayParametrisedManualStartLink plan labelKey]
    [#if fn.hasPlanPermission('BUILD', plan) && fn.hasPlanPermission('WRITE', plan) ]
        [#if !plan.suspendedFromBuilding]
            [#if !plan.active || action.getNumberOfCurrentlyBuildingPlans(plan.key) < plan.buildDefinition.configObjects.get("custom.concurrentBuilds.planLevelConfig").effectiveNumberOfConcurrentBuilds]
                [@ww.url id="editParameterisedManualBuild" action="editParameterisedManualBuild" namespace="/ajax" planKey=plan.key returnUrl=currentUrl /]

                [@dj.simpleDialogForm triggerSelector="#parameterisedManualBuild_${plan.key}"
                                      width=800
                                      height=400
                                      headerKey="build.editParameterisedManualBuild.form.title"
                                      /]
                [@ui.displayLinkForAUIDialog id="parameterisedManualBuild_${plan.key}"
                                         titleKey=labelKey
                                         icon="build-run"
                                         inList=true
                                         href=editParameterisedManualBuild /]
            [/#if]
        [/#if]
    [/#if]
[/#macro]

[#macro displayPlanStopLink plan labelKey]
    [#if fn.hasPlanPermission('BUILD', plan)]
        [#if numberOfRunningChains > 1]
                [@dj.simpleDialogForm triggerSelector=".build-stop_${plan.key}"
                                      actionUrl="/ajax/viewRunningPlans.action?planKey=${plan.key}&returnUrl=${currentUrl}"
                                      width=800
                                      height=400
                                      submitLabelKey="build.stop.confirmation.button" /]
                [@ui.displayLinkForAUIDialog id="stopBuild_${plan.key}"
                                         titleKey=labelKey
                                         class="build-stop_${plan.key}"
                                         icon="build-stop"
                                         inList=true /]
        [#else]
                [@ww.url id='stopPlanUrl'  action='stopPlan' namespace='/build/admin' planKey='${plan.key}'  returnUrl='/browse/${plan.key}' /]
                [@ui.displayLink id="stopPlan_${plan.key}"
                         titleKey=labelKey
                         href=stopPlanUrl
                         icon="build-stop"
                         inList=true /]
        [/#if]
    [/#if]
[/#macro]

[#macro displayResultStopLink resultSummary labelKey]
    [#if fn.hasPlanPermission('BUILD', resultSummary.plan)]
        [@ww.url id='stopResultUrl' action='stopPlan' namespace='/build/admin'
                    planResultKey='${resultSummary.planResultKey}' returnUrl='/browse/${resultSummary.planResultKey}' /]
        [@ui.displayLink id="stopBuild_${resultSummary.planResultKey}"
                         titleKey=labelKey
                         href=stopResultUrl
                         icon="build-stop"
                         inList=true /]
    [/#if]
[/#macro]

[#macro displayResultCancelLink resultSummary labelKey]
    [#if fn.hasPlanPermission('BUILD', resultSummary.plan)]
          [@ww.url id='cancelBuildUrl'
                     action='stopPlan'
                     namespace='/build/admin'
                     planResultKey='${resultsSummary.planResultKey}'
                     abandonResult=true
                     returnUrl='/browse/${resultsSummary.planResultKey}' /]
          [@ui.displayLink id="cancelBuild_${resultsSummary.planResultKey}"
                     titleKey=labelKey
                     href=cancelBuildUrl
                     icon="build-cancel"
                     inList=true /]
    [/#if]
[/#macro]

[#macro displayPlanCancelLink plan labelKey]
    [#if fn.hasPlanPermission('BUILD', plan)]
        [@ww.url id='cancelPlanUrl'
                 action='stopPlan'
                 namespace='/build/admin'
                 planKey="${plan.key}"
                 abandonResult=true
                 returnUrl='/browse/${plan.key}' /]
        [@ui.displayLink id="abandonBuild:${plan.key}"
                 title="Cancel Build"
                 href=cancelPlanUrl
                 icon="build-cancel"
                 inList=true /]
     [/#if]
[/#macro]

[#macro displayConfigureLink plan labelKey]
    [#if fn.hasPlanPermission('WRITE', plan)]
        [@ww.url id='editPlanUrl' value="/browse/${plan.key}/editConfig" /]        
        [@ui.displayLink id="editBuild:${plan.key}"
                         titleKey=labelKey
                         href=editPlanUrl
                         icon="build-configure"
                         inList=true /]
    [/#if]
[/#macro]

[#macro displayPlanResumeButton plan labelKey]
    [#if fn.hasPlanPermission('BUILD', plan)]
        [@ww.url id='resumePlanUrl' action="resumeBuild" namespace="/build/admin" buildKey="${plan.key}" returnUrl=currentUrl/]
        <a href="${resumePlanUrl}" id="resumeBuild:${plan.key}">[@ui.icon type="build-enable"/] [@ww.text name=labelKey/]</a>
    [/#if]
[/#macro]

[#macro displayPlanResumeLink plan labelKey]
    [#if fn.hasPlanPermission('BUILD', plan)]
        [@ww.url id='resumePlanUrl' action="resumeBuild" namespace="/build/admin" buildKey="${plan.key}" returnUrl=currentUrl/]
        [@ui.displayLink id="resumeBuild:${plan.key}"
                         titleKey=labelKey
                         href=resumePlanUrl
                         icon="build-enable"
                         inList=true /]
    [/#if]
[/#macro]

[#macro displayPlanSuspendLink plan labelKey]
    [#if fn.hasPlanPermission('BUILD', plan)]
        [@ww.url id='suspendBuildUrl' action="suspendBuild" namespace="/build/admin" buildKey="${plan.key}" returnUrl=currentUrl/]
        [@ui.displayLink id="suspendBuild:${plan.key}"
             titleKey=labelKey
             href=suspendBuildUrl
             icon="build-disable"
             inList=true /]
    [/#if]
[/#macro]

[#macro displayPlanDeleteLink plan labelKey returnUrl]
    [#if fn.hasPlanPermission('ADMINISTRATION', plan)]
        [@ww.url id='deletePlanUrl' action="deleteChain" namespace="/chain/admin" buildKey="${plan.key}" returnUrl=returnUrl/]
        [@ui.displayLink id="deleteBuild:${plan.key}"
                         titleKey=labelKey
                         href=deletePlanUrl
                         icon="build-delete"
                         inList=true/]
    [/#if]
[/#macro]

[#macro displayResultDeleteLink resultsSummary labelKey]
    [#if fn.hasPlanPermission('WRITE', resultsSummary.plan)]
        [@ww.url id='deleteResultUrl' namespace='/build/admin' action='deletePlanResults'
             buildKey='${resultsSummary.buildKey}'
             buildNumber='${resultsSummary.buildNumber}'/]
        [@ui.displayLink id="deleteBuildResult_${resultsSummary.planResultKey}"
                         titleKey=labelKey
                         href=deleteResultUrl
                         icon="build-delete"
                         inList=true
                         requiresConfirmation=true /]
    [/#if]
[/#macro]

[#macro displayResultCommentLink resultsSummary labelKey]
    [#if user??]
        [@ww.url id='commentBuildUrl' value='/browse/${resultsSummary.planResultKey}' commentMode=true /]
        [@ui.displayLink id="commentBuild_${resultsSummary.planResultKey}"
                         titleKey=labelKey
                         href="${commentBuildUrl}"
                         icon="comment-add"
                         inList=true /]
    [/#if]
[/#macro]

[#macro displayFavouriteToggler plan]
    [#if user?has_content && plan.type != 'JOB']
        [#assign isFavourite = ctx.isFavourite(plan, req)/]
        [@ww.url id='setFavouriteUrl' action='setFavourite' namespace='/build/label' planKey='${plan.key}' newFavStatus='${(!isFavourite)?string}'  returnUrl=currentUrl/]
        [#if isFavourite ]
            [#assign favIcon="favourite-remove"/]
            [#assign labelKey="build.favourite.off"/]
        [#else]
            [#assign favIcon="favourite"/]
            [#assign labelKey="build.favourite.on"/]
        [/#if]
        [@ui.displayLink id="toggleFavourite_${plan.key}"
            titleKey=labelKey
            href=setFavouriteUrl
            icon=favIcon
            inList=true /]
    [/#if]
[/#macro]