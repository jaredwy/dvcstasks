[#-- @ftlvariable name="ctx" type="com.atlassian.bamboo.ww2.FreemarkerContext" --]

[#-- ========================================================================================= @cp.displayJiraIssuesSummary --]
[#-- Displays a summary of Jira Issues. --]
[#macro displayJiraIssuesSummary buildResultsSummary maxIssues=2]
    [#import '../plugins/jira-plugin/viewJiraIssueComponents.ftl' as jiraComponents /]
    [#if linkedJiraIssues?has_content && jiraIssueUtils.isJiraServerSetup()]
        <div id="issueSummary" class="issueSummary">
            [@ww.url id='jiraTabUrl' value='/browse/${buildResultsSummary.buildResultKey}/issues' /]
            <div class="toolbar">
                <a id="displayFullJiraIssues" href='${jiraTabUrl}'>[#rt]
                    [#if linkedJiraIssues.size() gt maxIssues]
                        [@ww.text name='buildResult.jiraIssues.all' ][@ww.param name="value" value="${linkedJiraIssues.size()}"/][/@ww.text][#t]
                    [#else]
                        [@ww.text name='buildResult.jiraIssues.details' /][#t]
                    [/#if]
                </a>[#lt]
            </div>
            <h2>[@ww.text name='buildResult.jiraIssues.title' /]</h2>
            <ul>
                [#list action.getShortJiraIssues(maxIssues) as issue]
                    [#if issue_index gte maxIssues]
                        [#break]
                    [/#if]
                    <li>
                        [@jiraComponents.jiraIcon issue /]
                        <h3>[@jiraComponents.jiraIssueKey issue /]</h3>
                        <p class="[#if issue.jiraIssueDetails.summary?has_content]jiraIssueDetails[#else]jiraIssueDetailsError[/#if]">
                            [@jiraComponents.jiraSummary issue /]
                        </p>
                    </li>
                [/#list]
            </ul>
            [#if linkedJiraIssues.size() gt maxIssues]
                 <p class="moreLink">
                    <a href='${jiraTabUrl}'>
                       [@ww.text name='buildResult.jiraIssues.more' ][@ww.param name="value" value="${linkedJiraIssues.size() - maxIssues}"/][/@ww.text]
                    </a>
                 </p>
            [/#if]
        </div>
    [/#if]
[/#macro]

[#-- ================================================================================== @cp.displayAuthorSummary --]

[#macro displayAuthorSummary author]
        [@ui.bambooInfoDisplay titleKey='Builds triggered by ${author.name}' height='300px' cssClass='authorSummary']
            [@ui.displayText]
                Builds triggered by an author are those builds which contains changes committed by the author.
            [/@ui.displayText]

            [@ww.label labelKey='All builds triggered' name='author.numberOfTriggeredBuilds'/]

            [#if author.numberOfTriggeredBuilds gt 0]
                [#assign failedPercent=author.numberOfFailedBuilds / author.numberOfTriggeredBuilds]
                [#assign successPercent=author.numberOfSuccessfulBuilds / author.numberOfTriggeredBuilds]
            [#else]
                [#assign failedPercent=0 /]
                [#assign successPercent=0 /]
            [/#if]

            [@ww.label labelKey='build.common.fail' value='${author.numberOfFailedBuilds} (${failedPercent?string.percent})' /]
            [@ww.label labelKey='build.common.successful' value='${author.numberOfSuccessfulBuilds} (${successPercent?string.percent}) ' /]
        [/@ui.bambooInfoDisplay]
        [@ui.bambooInfoDisplay titleKey='Breakages and Fixes' height='300px' cssClass='authorSummary']
            [@ui.displayText]
                <i>Broken</i> means the build has failed but the previous build was successful.<br />
                <i>Fixed</i> means that the build was successful but the previous build has failed.
            [/@ui.displayText]

            [#if author.numberOfTriggeredBuilds gt 0]
                [#assign breakagePercent=author.numberOfBreakages / author.numberOfTriggeredBuilds]
                [#assign fixesPercent=author.numberOfFixes / author.numberOfTriggeredBuilds]
            [#else]
                [#assign breakagePercent=0 /]
                [#assign fixesPercent=0 /]
            [/#if]


            [@ww.label labelKey='Broken By Author' value='${author.numberOfBreakages} (${breakagePercent?string.percent} of all builds triggered)'/]
            [@ww.label labelKey='Fixed By Author' value='${author.numberOfFixes} (${fixesPercent?string.percent} of all builds triggered)' /]

            [#assign difference=author.numberOfFixes - author.numberOfBreakages /]

            [#if difference > 0]
                [#assign textColour='Successful' /]
            [#else]
                [#assign textColour='Failed' /]
            [/#if]
            [@ww.label labelKey='Difference of fixes and breaks' name='author.numberOfFixes - author.numberOfBreakages' cssClass='${textColour}' /]
            [/@ui.bambooInfoDisplay]
        <div class="clearer"></div>

[/#macro]

[#-- ================================================================================ @cp.displayAuthorOrProfileLink --]

[#macro displayAuthorOrProfileLink author]
[@compress singleLine=true]
    [#if author.linkedUserName?has_content]
        [@ww.url id='profileUrl'
                 value='/browse/user/${author.linkedUserName}' /]
        ${profileUrl}
    [#else]
        [@ww.url id='authorUrl'
                 value='/browse/author/${author.getNameForUrl()}' /]
        ${authorUrl}
    [/#if]
[/@compress]
[/#macro]

[#-- ================================================================================ @cp.displayNotificationWarnings --]
[#macro displayNotificationWarnings messageKey='' addServerKey='' cssClass='warning'  allowInlineEdit=false id='']
    [#if allowInlineEdit]
         [@dj.simpleDialogForm
               triggerSelector=".addInstantMessagingServerInline"
               actionUrl="/ajax/configureInstantMessagingServerInline.action?returnUrl=${currentUrl}"
               width=800
               height=415
               submitLabelKey="global.buttons.update"
               submitMode="ajax"
               submitCallback="function() {window.location.reload();}"
           /]
           [@dj.simpleDialogForm
               triggerSelector=".addMailServerInline"
               actionUrl="/ajax/configureMailServerInline.action?returnUrl=${currentUrl}"
               width=860
               height=540
               submitLabelKey="global.buttons.update"
               submitMode="ajax"
               submitCallback="function() {window.location.reload();}"
           /]
    [/#if]
    [#if messageKey?has_content]
        [#assign notificationWarningMsg][#rt]
            [@ww.text name=messageKey]
                [@ww.param name="value"]<a href="${req.contextPath}/profile/userProfile.action">[/@ww.param]
                [@ww.param name="value"]</a>[/@ww.param]
            [/@ww.text][#t]
            [#if fn.hasAdminPermission()][#lt] <span>[#rt]
                [@ww.text name=addServerKey]
                     [@ww.param name="value"]<a class="addMailServerInline" title="${action.getText('config.email.title')}">[/@ww.param]
                     [@ww.param name="value"]<a class="addInstantMessagingServerInline" title="${action.getText('instantMessagingServer.admin.add')}">[/@ww.param]
                     [@ww.param name="value"]</a>[/@ww.param]
                [/@ww.text]</span>[#t]
            [/#if]
        [/#assign][#lt]
        [@ui.messageBox type=cssClass id=id title=notificationWarningMsg /]
    [/#if]
[/#macro]

[#-- ============================================================================================= @cp.favouriteIcon --]
[#macro favouriteIcon plan operationsReturnUrl user='']
[#if user?has_content && plan.type != 'JOB']
    [@compress single_line=true]

    [#assign isFavourite = action.isFavourite(plan)]
    [@ww.url id='setFavouriteUrl'
            action='setFavourite'
            namespace='/build/label'
            planKey='${plan.key}'
            newFavStatus='${(!isFavourite)?string}'
            returnUrl='${operationsReturnUrl}' /]
    [#if isFavourite ]
        <a href="${setFavouriteUrl}" class="internalLink" id="toggleFavourite_${plan.key}">[@ui.icon type="favourite-remove" text="Remove this plan from your favourites" /]</a>
    [#else]
        <a href="${setFavouriteUrl}" class="internalLink" id="toggleFavourite_${plan.key}">[@ui.icon type="favourite" text="Add this plan to your favourites" /]</a>
    [/#if]

    [/@compress]
[/#if]
[/#macro]

[#-- ============================================================================================= @cp.dashboardFavouriteIcon --]
[#macro dashboardFavouriteIcon plan operationsReturnUrl user='']
[#if user?has_content]
    [@compress single_line=true]

    [#assign isFavourite = action.isFavourite(plan)]
    [@ww.url id='setFavouriteUrl'
            action='setFavourite'
            namespace='/build/label'
            planKey='${plan.key}'
            newFavStatus='${(!isFavourite)?string}'
            returnUrl='${operationsReturnUrl}' /]

    [#if isFavourite]
        <a href="${setFavouriteUrl}" id="toggleFavourite_${plan.key}" title="[@ww.text name='build.favourite.off'/]">[@ui.icon type="favourite-remove" textKey='build.favourite'/]</a>
    [#else]
        <a href="${setFavouriteUrl}" id="toggleFavourite_${plan.key}" title="[@ww.text name='build.favourite.on'/]">[@ui.icon type="favourite" textKey='build.favourite'/]</a>
    [/#if]

    [/@compress]
[/#if]
[/#macro]

[#-- ==================================================================================== @cp.currentBuildStatusIcon --]
[#macro currentBuildStatusIcon build id='' classes='' showLink=true]
[@compress single_line=true]
[#if showLink]
<a [#if id?has_content]
       id="${id}" [#t]
   [/#if]
   [#if classes?has_content]
       class="${classes}" [#t]
   [#elseif build.active]
       class="${build.key}_active" [#t]
   [/#if]
   href="${req.contextPath}/browse/${build.key}">[#t/]
[/#if]
    [#assign latestResultsSummary=build.latestResultsSummary! /]

    [#if build.suspendedFromBuilding]
        <img src="[@cp.getStaticResourcePrefix /]/images/iconsv3/plan_disabled_16.png" title="Plan Disabled" />[#t/]
    [#elseif build.active && build.isExecuting()]
        <img src="[@cp.getStaticResourcePrefix /]/images/jt/icn_building.gif" alt="Build in progress" title="Build in progress"  />[#t/]
    [#elseif build.active]
        <img src="[@cp.getStaticResourcePrefix /]/images/iconsv3/queued_16.png" alt="Build queued" title="Build queued"  />[#t/]
    [#elseif build.isBusy?exists && build.isBusy()]
        <img src="[@cp.getStaticResourcePrefix /]/images/jt/icn_checkinout.gif" alt="Checking out source code" title="Checking out source code" />[#t/]
    [#elseif latestResultsSummary?has_content ]
        [#if latestResultsSummary.successful]
            <img src="[@cp.getStaticResourcePrefix /]/images/iconsv3/plan_successful_16.png" alt="Last build was successful" title="Last build was successful"/>[#t/]
        [#elseif latestResultsSummary.failed]
            <img src="[@cp.getStaticResourcePrefix /]/images/iconsv3/plan_failed_16.png" alt="The last build failed" title="The last build failed" />[#t/]
        [#elseif latestResultsSummary.notBuilt]
            <img src="[@cp.getStaticResourcePrefix /]/images/iconsv3/plan_canceled_16.png" alt="The last build was not built" title="The last build was not built"  />[#t/]
        [/#if]
    [#else]
        <img src="[@cp.getStaticResourcePrefix /]/images/iconsv3/plan_disabled_16.png" alt="No build history" title="No build history" />[#t/]
    [/#if]
[#if showLink]
</a>[#t/]
[/#if]
[/@compress]
[/#macro]

[#-- ============================================================================================ @cp.resultsSubMenu --]
[#macro resultsSubMenu selectedTab='summary' hasSubMenu=false]
    [@ui.messageBox type="warning"]
        [@ww.text name="error.decorator.incorrect"]
            [@ww.param]result[/@ww.param]
        [/@ww.text]
    [/@ui.messageBox]
[/#macro]
[#-- ============================================================================================ @cp.resultsSubMenu --]
[#macro buildResultSubMenu selectedTab='summary' hasSubMenu=false]
    [@ui.messageBox type="warning"]
        [@ww.text name="error.decorator.incorrect"]
            [@ww.param]result[/@ww.param]
        [/@ww.text]
    [/@ui.messageBox]
[/#macro]
[#-- ============================================================================================ @cp.chainResultsSubMenu --]
[#macro chainResultSubMenu selectedTab='summary' hasSubMenu=false]
    [@ui.messageBox type="warning"]
      [@ww.text name="error.decorator.incorrect"]
            [@ww.param]result[/@ww.param]
      [/@ww.text]
    [/@ui.messageBox]
[/#macro]
[#-- ========================================================================-===================== @cp.buildSubMenu --]
[#macro buildSubMenu selectedTab='summary']
    [@ui.messageBox type="warning"]
        [@ww.text name="error.decorator.incorrect"]
            [@ww.param]plan[/@ww.param]
        [/@ww.text]
    [/@ui.messageBox]
[/#macro]
[#-- ========================================================================-===================== @cp.chainSubMenu --]
[#macro chainSubMenu selectedTab='summary']
    [@ui.messageBox type="warning"]
        [@ww.text name="error.decorator.incorrect"]
            [@ww.param]plan[/@ww.param]
        [/@ww.text]
    [/@ui.messageBox]
[/#macro]
[#-- ========================================================================-===================== @cp.editPlanConfigurationTabs --]
[#macro editPlanConfigurationTabs build formId selectedTab='build.details' location="planConfiguration.subMenu"]
     [@ui.messageBox type="warning"]
        [@ww.text name="error.decorator.incorrect"]
            [@ww.param]planConfig[/@ww.param]
        [/@ww.text]
    [/@ui.messageBox]
[/#macro]

[#-- ========================================================================-===================== @cp.profileSubMenu --]
[#macro profileSubMenu selectedTab='personalDetails']
    [#import "menus.ftl" as menu/]
    [@menu.displayTabbedContent location="system.user" selectedTab=selectedTab admin=true]
        [#nested /]
    [/@menu.displayTabbedContent]
[/#macro]

[#-- ========================================================================-===================== @cp.dashboardSubMenu --]
[#macro dashboardSubMenu selectedTab="allPlansTab"]
    [#import "menus.ftl" as menu/]
        [@menu.displayExternalOperations cssClass="dashboardExternal"]
            <li>
                [#assign wallboardTriggerText][@ui.icon type="wallboard" /][@ww.text name="dashboard.wallboard"/][/#assign]
                [@ui.standardMenu wallboardTriggerText "wallBoardDropdown"]
                    [@ui.displayLink titleKey="dashboard.wallboard.all" href="${req.contextPath}/telemetry.action" inList=true /]
                    [#if user??]
                        [@ui.displayLink titleKey="dashboard.wallboard.favourite" href="${req.contextPath}/telemetry.action?filter=favourites" inList=true /]
                    [/#if]
                [/@ui.standardMenu]
            </li>
        [/@menu.displayExternalOperations]

    [@menu.displayTabbedContent location="system.dashboard" selectedTab=selectedTab]
        [#nested /]
    [/@menu.displayTabbedContent]

    [#if user??]
        [#assign rssSuffix="&amp;os_authType=basic" /]
    [#else]
        [#assign rssSuffix="" /]
    [/#if]
    <p>
        <a href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssAll${rssSuffix}">[@ui.icon type="rss" text="Point your rss reader at this link"/]</a>
        [@ww.text name="dashboard.rss"]
            [@ww.param]${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssAll${rssSuffix}[/@ww.param]
            [@ww.param]${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssFailed${rssSuffix}[/@ww.param]
        [/@ww.text]
    </p>

    <script type="text/javascript">
        [#-- update value of cookie controlling tab selection --]
        AJS.$(function() {
              saveCookie("atlassian.bamboo.dashboard.tab.selected", "${selectedTab}");
        });
    </script>
[/#macro]

[#-- ========================================================================-===================== @cp.authorSubMenu --]
[#macro authorSubMenu selectedTab='list']
    [#import "menus.ftl" as menu/]
    [@menu.displayTabbedContent location="system.authors" selectedTab=selectedTab admin=true]
        [#nested /]
    [/@menu.displayTabbedContent]
[/#macro]

[#-- ================================================================================================ @cp.pagination --]
[#macro pagination ]
<ul class="pager">
[#if pager.hasPreviousPage]
    <li><a href="[@ww.url value='${pager.firstPageUrl}' /]" class="firstLink"><img src="[@ww.url value='/images/build_nav_arrow_first.gif' /]" alt="First" /></a></li>
    <li><a href="[@ww.url value='${pager.previousPageUrl}' /]" class="previousLink" accesskey="P"><img src="[@ww.url value='/images/build_nav_arrow_left.gif' /]" alt="Previous" /></a></li>
[#else]
    <li><span class="firstLink"><img src="[@ww.url value='/images/build_nav_arrow_first_grey.gif' /]" alt="First" /></span></li>
    <li><span class="previousLink"><img src="[@ww.url value='/images/build_nav_arrow_left_grey.gif' /]" alt="Previous" /></span></li>
[/#if]
<li class="label">Showing ${pager.page.startIndex + 1}-${pager.page.endIndex} of ${pager.totalSize}</li>
[#if pager.hasNextPage]
    <li><a href="[@ww.url value='${pager.nextPageUrl}' /]" class="nextLink" accesskey="N"><img src="[@ww.url value='/images/build_nav_arrow_right.gif' /]" alt="Next" /></a></li>
    <li><a href="[@ww.url value='${pager.lastPageUrl}' /]" class="lastLink"><img src="[@ww.url value='/images/build_nav_arrow_last.gif' /]" alt="Last" /></a></li>
[#else]
    <li><span class="nextLink"><img src="[@ww.url value='/images/build_nav_arrow_right_grey.gif' /]" alt="Next" /></span></li>
    <li><span class="lastLink"><img src="[@ww.url value='/images/build_nav_arrow_last_grey.gif' /]" alt="Last" /></span></li>
[/#if]
</ul>
[/#macro]

[#-- ========================================================================-===================== @cp.commentIndicatorAsText --]
[#--used for jira bamboo plugin--]
[#macro commentIndicatorAsText buildResultsSummary]
    [#if buildResultsSummary.comments?has_content]
       [@ww.url id='commentUrl'  value="/browse/${buildResultsSummary.buildResultKey}" /]

        <a id="comment:${buildResultsSummary.buildKey}-${buildResultsSummary.buildNumber}" href="${commentUrl}">
            [@ww.text name='buildResult.comment.count' ]
                [@ww.param name="value" value="${buildResultsSummary.comments.size()}"/]
            [/@ww.text]
        </a>
    [/#if]
[/#macro]

[#-- ========================================================================================== @cp.commentIndicator --]
[#macro commentIndicator buildResultsSummary]

    [#if buildResultsSummary.hasCommentsToDisplay()]
        [@ww.url id='commentUrl'  value="/browse/${buildResultsSummary.buildResultKey}" /]

        [#assign commentId = "comment_${buildResultsSummary.buildResultKey}" /]
        <a id="${commentId}" href="${commentUrl}"><img src="[@ww.url value='/images/message.gif' /]" alt="Commented" /></a>

        <script type="text/javascript">
            AJS.$(function() {
                initCommentTooltip("${commentId}", "${buildResultsSummary.buildKey}", "${buildResultsSummary.buildNumber}")
            });
        </script>

    [/#if]
[/#macro]


[#-- ======================================================================================== @cp.getStaticResourcePrefix --]
[#macro getStaticResourcePrefix]
    [#if webResourceManager?exists]
        ${webResourceManager.getStaticResourcePrefix(UrlMode.AUTO)}[#t]
    [#else]
        ${req.contextPath}[#t]
    [/#if]
[/#macro]

[#-- ======================================================================================== @cp.toggleDisplayByGroup --]
[#macro toggleDisplayByGroup toggleGroup_id jsRestore=true]
<script type="text/javascript">
    AJS.$("#${toggleGroup_id}_toggler_on").bind("click", function(){
        toggleOff(null, '${toggleGroup_id}');
    });
    AJS.$("#${toggleGroup_id}_toggler_off").bind("click", function(){
        toggleOn(null, '${toggleGroup_id}');
    });

    [#if jsRestore]
        AJS.$("#${toggleGroup_id}_target").ready(function(){
            restoreTogglesFromCookie('${toggleGroup_id}');
        });
    [/#if]
</script>
[/#macro]


[#-- ======================================================================================== @cp.entityPagination --]
[#--
    Shows pagination links for Users and Group browsers.

    @requires actionUrl - the url to post back to for the page numbers
    @requires paginagionSupport - paginationSupport object
--]

[#macro entityPagination actionUrl paginationSupport ]
    [#assign sanitizedActionUrl=fn.sanitizeUri(actionUrl)/]
<div>
    <ul class="pager">

    [#assign previousIndexes=paginationSupport.previousStartIndexes?if_exists /]
    [#assign nextIndexes=paginationSupport.getNextStartIndexes()?if_exists /]

    [#if paginationSupport.items?has_content]
        [#assign startIndex=paginationSupport.startIndex + 1 /]
        [#assign endIndex=paginationSupport.endIndex /]
    [/#if]

    [#if previousIndexes?has_content || nextIndexes?has_content]
        [#assign currentIndex=0]

        [#if previousIndexes?has_content]
            <li><a href="${sanitizedActionUrl}startIndex=${paginationSupport.previousIndex}" class="previousLink" title="Previous">Previous</a></li>

            [#if previousIndexes?size gt 9]
                ...
                [#assign startFrom = previousIndexes?size - 8]
            [#else]
                [#assign startFrom = 1]
            [/#if]

            [#list previousIndexes as prevIndex]
                [#assign currentIndex=currentIndex+1 /]

                [#if currentIndex gte startFrom]
                    <li><a href="${sanitizedActionUrl}startIndex=${prevIndex}" class="numberedLink">${currentIndex}</a></li>
                [/#if]
            [/#list]
        [/#if]

        [#assign currentIndex=currentIndex + 1 /]
        <li>${currentIndex}</li>

        [#if nextIndexes?has_content]
            [#list nextIndexes as nextIndex]
                [#assign currentIndex=currentIndex + 1 /]
                <li><a href="${sanitizedActionUrl}startIndex=${nextIndex}" class="numberedLink">${currentIndex}</a></li>
            [/#list]
            <li>
               <a href="${sanitizedActionUrl}startIndex=${paginationSupport.nextIndex}" class="nextLink" title="Next">Next</a>
            </li>
        [#else]
            [#if !paginationSupport.items.onLastPage()]
                <li><a href="${sanitizedActionUrl}startIndex=${paginationSupport.nextIndex}" class="nextLink" title="Next">Next</a></li>
            [/#if]
        [/#if]
    [#else]
        [#if paginationSupport.tryNext]
            <li><a href="${sanitizedActionUrl}startIndex=0" class="previousLink" title="Previous">Previous</a></li>
        [/#if]

        [#if paginationSupport.items?? && !paginationSupport.items.onLastPage()]
            <li><a href="${sanitizedActionUrl}tryNext=true" class="nextLink" title="Next">Next</a></li>
        [/#if]
    [/#if]
    </ul>
</div>

[/#macro]

[#-- =========================================================================================== @cp.displayErrorsForPlan --]
[#macro displayErrorsForPlan plan errorAccessor]
    [#assign buildErrors=errorAccessor.getErrors(plan.planKey)]
    [@displayErrors buildErrors plan.key /]
[/#macro]

[#macro displayErrorsForResult planResult errorAccessor manualReturnUrl=""]
    [#assign buildErrors=errorAccessor.getErrors(planResult.planResultKey)]
    [@displayErrors buildErrors planResult.planResultKey.planKey.key planResult.planResultKey.buildNumber manualReturnUrl/]
[/#macro]

[#macro displayErrors buildErrors planKey="" buildNumber="" manualReturnUrl=""]
    [#if buildErrors?has_content]
    <div class="planErrors section">
        <h2 id="buildPlanSummaryErrorLog">[@ww.text name='plan.error.title'/]</h2>
        [#if fn.hasAdminPermission() ]
            [@ui.icon type="delete"/]
            <a href="[@ww.url value='/chain/removePlanErrorsFromLog.action?' planKey=planKey buildNumber=buildNumber returnUrl=currentUrl /]" >[@ww.text name="plan.error.bulk.delete"/]</a>
        [/#if]

        <ol class="noBullet">
            [#list buildErrors as error]
                [#if manualReturnUrl?has_content]
                    [@cp.showSystemError error=error returnUrl=manualReturnUrl/]
                [#else]
                    [@cp.showSystemError error=error returnUrl=currentUrl/]
                [/#if]
            [/#list]
        </ol>
    </div>
    [/#if]
[/#macro]

[#-- =========================================================================================== @cp.showSystemError --]
[#--
    Shows a @ui.messageBox showing the build errors

    @requires error - An ErrorDetails object
--]
[#macro showSystemError error returnUrl='']
[@ui.messageBox type="error"]
    <p class="title">[#rt]
        [#if error.buildSpecific]
            <a href="[@ww.url value='/browse/${error.buildKey}' /]" >${error.buildName}</a>
            [#if error.buildNumber?? && error.buildExists]
                &rsaquo; <a href="[@ww.url value='/browse/${error.buildResultKey}' /]" >${error.buildResultKey}</a>
            [/#if]
        [#elseif error.elastic]
            Elastic Bamboo Error[#t]
        [#else]
            General Error[#t]
        [/#if]
        : <em>${error.context}</em>[#lt]
    </p>

    [#if error.throwableDetails??]
        <div class="grey">(${error.throwableDetails.name?if_exists}[#rt]
            [#if error.throwableDetails.message?has_content]
                : ${error.throwableDetails.message}[#rt]
            [/#if]
            )[#lt]
        </div>
    [/#if]

    [#if error.elastic]
        [#if error.instanceIds?has_content]
             <em>Elastic Instances : </em>
             [#list error.instanceIds as instanceId]
                ${instanceId?html}[#t]
                [#if instanceId_has_next]
                    ,[#lt]
                [/#if]
            [/#list]
        [/#if]
    [/#if]

   <div class="agentErrorDetails">
        (${error.lastOccurred?datetime}[#rt]
        [#if error.numberOfOccurrences > 1]
            , Occurrences: ${error.numberOfOccurrences}[#lt]
        [/#if]
        [#if error.agentIds?has_content]
            , Agents: [#lt]
            [#list error.agentIdentifiers as agent]
                [#if agent.name?has_content]
                    <a href="[@ww.url action='viewAgent' namespace='/agent' agentId=agent.id /]">${agent.name?html}</a>[#t]
                [#else]
                    id: ${agent.id}
                [/#if]
                [#if agent_has_next]
                    ,[#lt]
                [/#if]
            [/#list]
        [/#if]
        )[#lt]
    </div>
    <div>
        [#assign removeErrorReturnUrl=returnUrl!currentUrl /]
        [#if error.throwableDetails??]
           [@ui.icon type="view"/]
           <a href="${req.contextPath}/admin/viewError.action?buildKey=${error.buildKey}&amp;error=${error.errorNumber}" onclick="openHelp('${req.contextPath}/admin/viewError.action?buildKey=${error.buildKey}&amp;error=${error.errorNumber}'); return false;">[@ww.text name="plan.error.view"/]</a>
           [@ww.form id='removeErrorHiddenForm_${error.errorNumber}' action='removeErrorFromLog.action?buildKey=${error.buildKey}&amp;error=${error.errorNumber}&amp;returnUrl=${removeErrorReturnUrl}' namespace='/admin' formEndClearer=false cssClass='bambooForm popupRemoveErrorLogForm']
               <input type='submit' class='hidden'>
           [/@ww.form]
        [/#if]
        [#if fn.hasAdminPermission() ]
            [@ui.icon type="delete"/]
            <a href="${req.contextPath}/admin/removeErrorFromLog.action?buildKey=${error.buildKey}&amp;error=${error.errorNumber}&amp;returnUrl=${removeErrorReturnUrl}">[@ww.text name="plan.error.delete"/]</a>
        [/#if]
    </div>
[/@ui.messageBox]
[/#macro]

[#-- =================================================================== @cp.configChangeHistory changeListPager --]
[#macro configChangeHistory pager jobMap=""]
[#if pager.getPage()??]
    <table class="aui" id="audit-log">
        <thead>
            <tr>
                <th id="al-timestamp">[@ww.text name='auditlog.timestamp' /]</th>
                <th id="al-user">[@ww.text name='auditlog.user' /]</th>
                [#if jobMap?has_content]
                    <th id="al-job">[@ww.text name='auditlog.job' /]</th>
                [/#if]
                <th id="al-change">[@ww.text name='auditlog.changed.field' /]</th>
                <th id="al-old-value">[@ww.text name='auditlog.old.value' /]</th>
                <th id="al-new-value">[@ww.text name='auditlog.new.value' /]</th>
            </tr>
        </thead>
        <tfoot>
                <tr>
                    <td colspan="6">[@cp.pagination /]</td>
                </tr>
        </tfoot>
        <tbody>
            [#list pager.page.list as message]
                <tr>
                    <td headers="al-timestamp">${message.date?datetime?string("hh:mm a, EEE, d MMM")}</td>
                    <td headers="al-user">
                       [#if message.username?? && message.username != "SYSTEM"]
                           <a href="[@ww.url value='/browse/user/${message.username}'/]">${message.username?html}</a>
                       [#else]
                           SYSTEM
                       [/#if]
                    </td>
                    [#if jobMap?has_content]
                        <td headers="al-job">
                            [#if message.jobKey?exists]
                                <a href="${req.contextPath}/build/admin/edit/editBuildDetails.action?buildKey=${message.jobKey}">${jobMap.get(message.jobKey)}</a>
                            [#else]
                                &nbsp;
                            [/#if]
                        </td>
                    [/#if]
                    [#if message.messageType == "FIELD_CHANGE"]
                        <td headers="al-change">${message.message}</td>
		                <td headers="al-old-value">${(message.oldValue!"")?html}</td>
		                <td headers="al-new-value">${(message.newValue!"")?html}</td>
                    [#else]
                        <td headers="al-change" colspan="3">${message.message}</td>
                    [/#if]
                </tr>
            [/#list]
        </tbody>
    </table>
[#else]
    <p>[@ww.text name='auditlog.no.changes.recorded' /]</p>
[/#if]

[/#macro]

[#macro successStatistics statistics averageDuration isJob]
 <div id="successRate">
        <div class="successRatePercentage">
            <p>
                <span>${statistics.successPercentage}%</span>
                [@ww.text name='build.common.statSuccessful' /]
            </p>
        </div> <!-- END #successRatePercentage -->
        <dl>
            <dt class="first">
                [#if isJob]
                    [@ww.text name='build.common.successful' /]:
                [#else]
                    [@ww.text name='chain.summary.graph.successfulBuilds' /]:
                [/#if]
            </dt>
            <dd class="first">
                ${statistics.totalSuccesses} / ${statistics.totalNumberOfResults}
            </dd>
            <dt>
                [@ww.text name='build.common.averageDuration' /]:
            </dt>
            <dd>
                ${durationUtils.getPrettyPrint(averageDuration)}
            </dd>
        </dl>
</div> <!-- END #successRate -->
[/#macro]

[#-- Displays an aui drop down for the configuration pages.  Requires a whole bunch of li's to be nested --]
[#macro configDropDown buttonText location]
    <div id="editConfigurationButton" class="aui-toolbar inline">
        <ul class="toolbar-group">
            <li class="toolbar-item aui-dd-parent">
                <a class="toolbar-trigger" title="${buttonText}">
                    ${buttonText} [@ui.icon type="drop" /]
                </a>
                <ul class="aui-dropdown aui-dropdown-right hidden">
                    [#list action.getWebSectionsForLocation(location) as section ]
                        [#list action.getWebItemsForSection(location + '/' + section.key) as item]
                            [#assign id=item.link.getRenderedId(webFragmentsContextMap)/]
                            [#if !id??]
                                [#assign id=action.renderFreemarkerTemplate(item.key)?html/]
                            [/#if]
                            [#assign url=item.link.getDisplayableUrl(req, webFragmentsContextMap)]
                            <li class="dropdown-item"><a class="item-link" [#if id??] id="${id}"[/#if] href="${url}">${item.webLabel.displayableLabel}</a></li>
                        [/#list]
                    [/#list]
                </ul>
            </li>
        </ul>
    </div>
    <script type="text/javascript">
        AJS.$(function () {
              AJS.$("#editConfigurationButton .aui-dd-parent").dropDown("Standard", { trigger: "a.toolbar-trigger" });
        });
    </script>
[/#macro]

[#macro displayCommentList result headingLevel='h3']
    <ul>
        [#list result.comments as comment]
        <li>
            [#if user??]
                <a class="commentDeleteLink requireConfirmation" href="[@ww.url action='deleteComment' namespace='/build/ajax' commentId=comment.id buildKey=result.buildKey buildNumber=result.buildNumber/]" title="[@ww.text name='buildResult.comment.delete.description' /]">[@ww.text name='global.buttons.delete' /]</a>
            [/#if]
            [#if comment.user??]
                <img class="profileImage" src="[@ui.displayUserGravatar userName=comment.userName size='25' /]" />

                <${headingLevel}>
                    <a href="${req.contextPath}/browse/user/${comment.user.name}">[@ui.displayUserFullName user=comment.user /]</a>
                    [@ui.time datetime=comment.lastModificationDate]${comment.lastModificationDate?datetime}[/@ui.time]
                </${headingLevel}>
                [#else]
                    <img class="profileImage" src="[@ui.displayUserGravatar userName=comment.userName size='25' /]" />

                    <${headingLevel}>
                        [@ww.text name='buildResult.comment.anonymous.title' /]
                        [@ui.time datetime=comment.lastModificationDate]${comment.lastModificationDate?datetime}[/@ui.time]
                    </${headingLevel}>
            [/#if]
            <p>[@ui.renderValidJiraIssues comment.content result /]</p>
        </li>
        [/#list]
    </ul>
[/#macro]

[#--Displays existing comments and button-triggered form to add a new comment.  Whilst it is a component, the delete links currently dont use the return url--]
[#macro displayComments result returnUrl showFormOnLoad=false]
[#if user?? || result.hasCommentsToDisplay()]
    <div class="comments">
        <h2>[@ww.text name='buildResult.comment.title' /]</h2>
        [#if result.comments?has_content]
            [@displayCommentList result=result/]
        [#elseif result.stageResults?has_content]
            [#if !result.hasCommentsToDisplay()]
                <p>[@ww.text name='buildResult.comment.nocomments' /]</p>
            [/#if]
        [#else]
            <p>[@ww.text name='buildResult.comment.job.nocomments' /]</p>
        [/#if]

        [#if result.stageResults?has_content]
            [#assign aggregatedJobResultComments]
                [#list result.stageResults as stage]
                    [#list stage.sortedBuildResults as buildResult]
                        [#if buildResult.comments?has_content]
                            [#assign job = buildResult.plan/]
                            <h3>Comments on <a href="${req.contextPath}/browse/${buildResult.buildResultKey}">${job.buildName}</a></h3>
                            [@displayCommentList result=buildResult headingLevel='h4'/]
                        [/#if]
                    [/#list]
                [/#list]
            [/#assign]
            [#if aggregatedJobResultComments?has_content]
                ${aggregatedJobResultComments}
            [/#if]
        [/#if]

        [#if user??]
            <div class="aui-toolbar inline">
                <ul class="toolbar-group">
                    <li class="toolbar-item aui-dd-parent">
                        <a href="#result-summary-comment" class="toolbar-trigger" id="result-summary-comment-button" title="[@ww.text name='buildResult.comment.add' /]">[@ww.text name='buildResult.changes.comment' /]</a>
                    </li>
                </ul>
            </div>
            <div id="result-summary-comment" class="hidden">
                [@ww.form action='createComment' namespace='/build/ajax' submitLabelKey='global.buttons.update' cancelUri=currentUrl submitLabelKey='add']
                    [@ww.hidden name='buildKey' value=result.buildKey /]
                    [@ww.hidden name='buildNumber' value=result.buildNumber /]
                    [@ww.hidden name='returnUrl' value=returnUrl /]
                    [@ww.textarea labelKey='buildResult.changes.comment' name='commentContent' rows='5' /]
                [/@ww.form]
            </div>
            <script type="text/javascript">
                AJS.$(function ($) {
                    var $formContainer = $("#result-summary-comment"),
                        $createComment = $("#result-summary-comment-button"),
                        $createCommentContainer = $createComment.closest(".aui-toolbar"),
                        $textarea = $formContainer.find("textarea"),
                        $formButtons = $formContainer.find(".buttons > input");
                    $formContainer.find(".buttons a.cancel").click(function (e) {
                        e.preventDefault();
                        $formContainer.hide();
                        $createCommentContainer.show();
                        $textarea.val("");
                    });
                    $createComment.click(function (e) {
                        e.preventDefault();
                        $formContainer.show();
                        $createCommentContainer.hide();
                        setTimeout(function () { $textarea.focus(); }, 1); // slight delay so that the keystroke from keyboard shortcut doesn't get passed into the textarea
                    });
                    AJS.whenIType("[@ww.text name='global.keyboardshortcut.addcomment' /]").click($createComment);
                    $formContainer.children("form").removeAttr("onsubmit").submit(function (e) {
                        if (!$.trim($textarea.val()).length) {
                            e.preventDefault();
                            $textarea.focus();
                        } else {
                            $formButtons.attr("disabled", "disabled");
                        }
                    });

                    [#if showFormOnLoad]
                        $createComment.click();
                    [/#if]
                });
            </script>
        [/#if]
    </div>

[/#if]

[/#macro]

[#import "/fragments/variable/variables.ftl" as variables/]
[#--Displays manually overriden variables--]
[#macro displayManualVariables result]
[#assign manualVariables=result.manuallyOverriddenVariables]
[#if manualVariables?has_content]
    <div class="variables">
        <h2>[@ww.text name='buildResult.variable.title' /]</h2>
        [#if manualVariables?has_content]
            [@variables.displayManualVariables id="chainManualVariables" variablesList=manualVariables /]
        [/#if]
    </div>
[/#if]
[/#macro]

[#macro captcha]
    [@ww.textfield labelKey="user.captcha" name="captcha" required="true" tabindex="4" /]
    <div class="field-group">
        <img id="captcha-image" class="captcha-image" src="${req.contextPath}/captcha"/>
        [@dj.imageReload target="captcha-image" titleKey="user.captcha.reload"/]
    </div>
[/#macro]

[#macro displayOperationsHeader applicableForJobs ]
    <span class="bulk-command">
    [@ww.text name='global.selection.select' /]:
    <span tabindex="0" role="link" selector="bulk_selector_all">[@ww.text name='global.selection.all' /]</span>,[#rt]
    <span tabindex="0" role="link" selector="bulk_selector_none">[@ww.text name='global.selection.none' /]</span>[#rt]
    [#if applicableForJobs]
        ,[#t]
        <span tabindex="0" role="link" selector="bulk_selector_plans">[@ww.text name='bulk.selection.plans' /]</span>[#rt]
        ,[#t]
        <span tabindex="0" role="link" selector="bulk_selector_jobs">[@ww.text name='bulk.selection.jobs' /]</span>
    [/#if]
    </span>

    <script type="text/javascript">
        AJS.$(function() {
            BulkSelectionActions.init();
        });
    </script>
[/#macro]

[#macro displayProjectOperationsHeader key class applicableForJobs enableProjectCheckbox ]
    <span class="${class}">
    [@ww.text name='global.selection.select' /]:
    <span tabindex="0" role="link" selector="bulk_selector_sub_${key}">[@ww.text name='global.selection.all' /]</span>,[#rt]
    <span tabindex="0" role="link" selector="bulk_selector_sub_none_${key}">[@ww.text name='global.selection.none' /]</span>[#rt]
    [#if applicableForJobs]
        ,[#t]
        <span tabindex="0" role="link" selector="bulk_selector_sub_plans_${key}">[@ww.text name='bulk.selection.plans' /]</span>[#rt]
        ,[#t]
        <span tabindex="0" role="link" selector="bulk_selector_sub_jobs_${key}">[@ww.text name='bulk.selection.jobs' /]</span>
    [/#if]
    </span>

    <script type="text/javascript">
            AJS.$(function() {
                BulkSubtreeSelectionActions.init("${key}", ${enableProjectCheckbox?string});
            });
    </script>
[/#macro]

[#macro displaySubtreeOperationsHeader key class ]
    <span class="${class}">
        [@ww.text name='global.selection.select' /]:
        <span tabindex="0" role="link" selector="bulk_selector_sub_${key}">[@ww.text name='global.selection.all' /]</span>,[#rt]
        <span tabindex="0" role="link" selector="bulk_selector_sub_none_${key}">[@ww.text name='global.selection.none' /]</span>
    </span>

    <script type="text/javascript">
        AJS.$(function() {
            BulkSubtreeSelectionActions.init("${key}", false);
        });
    </script>
[/#macro]


[#macro displayBulkActionSelector bulkAction checkboxFieldValueType planCheckboxName jobCheckboxName enableProjectCheckbox=false]
    [@ww.hidden name="selectedBulkActionKey" /]

    [@displayOperationsHeader bulkAction.applicableForJobs /]

    [#list sortedProjects as project]
        [#if action.isApplicable(bulkAction, project)]
            <div class="bulk-project-bar">
                [#if enableProjectCheckbox]
                    [#if checkboxFieldValueType == "id"]
                        [#assign checkboxFieldValue = project.id! /]
                    [#else]
                        [#assign checkboxFieldValue = project.key! /]
                    [/#if]
                    <div class="bulk-project-name">
                        [@ww.checkbox name='selectedProjects'
                                  cssClass='bulk bulkProject bulkPlan bulk' + project.key + ' bulkProject' + project.key
                                  id='checkbox_${project.key!}'
                                  fieldValue=checkboxFieldValue
                                  label='${project.name!}'
                                  checked=action.isProjectSelected(project.key)?string
                                   /]
                    </div>
                [#else]
                    <span class="bulk-project-name">${project.name?html}</span>
                [/#if]
                [@displayProjectOperationsHeader project.key 'bulk-project-links' bulkAction.applicableForJobs enableProjectCheckbox=enableProjectCheckbox /]
            </div>

            [#list action.getSortedPlans(project) as plan]
                <div class="bulk-plan">
                    [#if bulkAction.isApplicable(plan)]
                        [#if checkboxFieldValueType == "id"]
                            [#assign checkboxFieldValue = plan.id! /]
                        [#else]
                            [#assign checkboxFieldValue = plan.key! /]
                        [/#if]

                        <div class="bulk-plan-left">
                            <div class="bulk-plan-name">
                                [@ww.checkbox name=planCheckboxName
                                              cssClass='bulk bulkPlan bulk' + project.key + ' bulkPlan' + project.key
                                              id='checkbox_${plan.key!}'
                                              fieldValue=checkboxFieldValue
                                              label='${plan.buildName?html}'
                                              checked="${action.isPlanSelected(plan.key)?string}" /]
                            </div>
                        </div>

                        [#if bulkAction.applicableForJobs]
                            <div class="bulk-plan-right">
                                    [#assign jobs= action.getSortedJobs(plan)]
                                    [#if jobs?has_content]
                                        <fieldset class="bulk-job">
                                            [#if jobs.size() > 1]
                                                [@displaySubtreeOperationsHeader plan.key 'bulk-job-links' /]
                                            [/#if]
                                            [#list jobs as job]
                                                [#if bulkAction.isApplicable(job)]
                                                    [#if checkboxFieldValueType == "id"]
                                                        [#assign checkboxFieldValue = job.id! /]
                                                    [#else]
                                                        [#assign checkboxFieldValue = job.key! /]
                                                    [/#if]
                                                    [@ww.checkbox name=jobCheckboxName
                                                                  cssClass='bulk bulkJob bulk' + project.key + ' bulk' + plan.key + ' bulkJob' + project.key
                                                                  id='checkbox_${job.key!}'
                                                                  fieldValue=checkboxFieldValue
                                                                  label='${job.buildName?html}'
                                                                  checked="${action.isPlanSelected(job.key)?string}" /]
                                                [/#if]
                                            [/#list]
                                        </fieldset>
                                    [/#if]
                            </div>
                        [/#if]
                    [/#if]
                </div>
            [/#list]
        [/#if]
    [/#list]
[/#macro]

[#macro displayLinkButton buttonId buttonKey buttonUrl ]
    <div id="rightDockButton" class="aui-toolbar inline">
        <ul class="toolbar-group">
            <li class="toolbar-item">
                [#assign title]
                    [@ww.text name=buttonKey/]
                [/#assign]
                <a id=${buttonId} class="toolbar-trigger" title="${title}" href=${buttonUrl}>${title}</a>
            </li>
        </ul>
    </div>
[/#macro]
