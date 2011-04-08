[#-- @ftlvariable name="datetime" type="java.util.Date" --]

[#-- =============================================================================================== @ui.bambooPanel --]
[#-- bambooPanel - this is used for display of input forms. --]
[#macro bambooPanel title='' titleKey='' description='' descriptionKey='' tools='' toolsContainer='div' auiToolbar='' cssClass='' content='' headerWeight='h2']

<div class="form-view[#if cssClass?has_content] ${cssClass}[/#if]">
    [#if title?has_content || titleKey?has_content]
        [#if tools?has_content]
            <${toolsContainer} class="toolbar">
                ${tools}
            </${toolsContainer}>
        [/#if]
        [#if auiToolbar?has_content]
            <div class="aui-toolbar inline">${auiToolbar}</div>
        [/#if]
        <${headerWeight}[#if auiToolbar?has_content] class="has-aui-toolbar"[/#if]>[#rt]
            [#if title?has_content || titleKey?has_content]
                [@ui.resolvedName title titleKey /][#t]
            [/#if]
        </${headerWeight}>[#lt]
    [/#if]
    [#if description?has_content || descriptionKey?has_content]
        [@ui.displayText description descriptionKey /]
    [/#if]
    [#nested]
</div>

[/#macro]

[#-- ========================================================================================= @ui.bambooInfoDisplay --]
[#-- bambooInfoDisplay - similar to bambooPanel, but used only for display of info (no input) --]
[#macro bambooInfoDisplay id='' title='' titleKey='' tools='' toolsContainer='div' float=false border=false height='' cssClass='' headerWeight='h3']
    <div class="form-view[#if float] floatingPanel[/#if][#t]
                [#if border] showBorder[/#if] ${cssClass!}"[#t]
                [#if height?has_content] style="min-height: ${height}"[/#if][#t]
                [#if id?has_content] id="${id}"[/#if]>[#t]
        [#if title?has_content || titleKey?has_content]
            [#if tools?has_content]
            <${toolsContainer} class="toolbar">
                ${tools}
            </${toolsContainer}>
            [/#if]
            <${headerWeight}>[@ui.resolvedName title titleKey /]</${headerWeight}>[#lt]
        [/#if]

        [#nested]
    </div>
[/#macro]

[#-- ============================================================================================= @ui.bambooSection --]
[#macro bambooSection step=0 title='' titleKey='' description='' descriptionKey='' dependsOn='' showOn=true tools='' toolsContainer='div' id='']

[#assign className = '']
[#assign style = '']
[#if dependsOn?has_content]
    [#assign className]
        dependsOn${dependsOn} [#t]
        [#list showOn?string?trim?split(" ") as showOnValue]
            showOn${showOnValue} [#t]
            [#if !(dependsOn?contains('.') || ContainUtil.contains(dependsOn?eval, showOnValue))]
                [#assign style = 'display:none;']
            [/#if]
        [/#list]
    [/#assign]
[/#if]

[#if (currentFormTheme!"") == "aui"]
    <fieldset[#if id?has_content] id="${id}"[/#if][#if className?has_content] class="${className?trim}"[/#if][#if style?has_content] style="${style}"[/#if]>
        [#if step > 0 || title?has_content || titleKey?has_content]
            [#if tools?has_content]
                <${toolsContainer} class="toolbar">
                    ${tools}
                </${toolsContainer}>
            [/#if]
            <h3>[#rt/]
                [#if step > 0]
                    <em>${step}:</em>
                [/#if]
                [#if title?has_content || titleKey?has_content]
                    [@ui.resolvedName title titleKey /]
                [/#if]
            </h3>[#lt/]
        [/#if]
        [#if description?has_content || descriptionKey?has_content]
            [@ui.displayText description descriptionKey /]
        [/#if]
        [#nested]
    </fieldset>
[#else]
    <fieldset[#if className?has_content] class="${className?trim}"[/#if][#if style?has_content] style="${style}"[/#if]>
        [#if step > 0 || title?has_content || titleKey?has_content]
            [#if tools?has_content]
                <${toolsContainer} class="toolbar">
                    ${tools}
                </${toolsContainer}>
            [/#if]
            [#if title?has_content || titleKey?has_content]
                <h3>[@ui.resolvedName title titleKey /]</h3>
            [/#if]
        [/#if]
        [#if description?has_content || descriptionKey?has_content]
            [@ui.displayText description descriptionKey /]
        [/#if]
        [#nested]
    </fieldset>
[/#if]
[/#macro]

[#macro resolvedName text textKey]
    [#if text?has_content]${text}[#else][@ww.text name='${textKey}' /][/#if][#t/]
[/#macro]

[#-- =============================================================================================== @ui.displayLink --]
[#macro displayLink href title="" titleKey="" icon='' id='' inList=false showText=true accessKey='' requiresConfirmation=false isAsynchronous=false ]
    [#if inList]<li class="dropdown-item">[/#if][#t/]
        <a [#if !showText]title="[@resolvedName title titleKey/]" [/#if]href="${href}" [#t/]
            [#if accessKey?has_content]accesskey="${accessKey}" [/#if][#t/]
            [#if id?has_content]id="${id}" [/#if][#t/]
            class="[#t/]
                [#if inList]item-link [/#if][#t/]
                [#if requiresConfirmation]requireConfirmation [/#if][#t/]
                [#if isAsynchronous]asynchronous [/#if][#t/]
        ">[#t/]
            [#if icon?has_content][@ui.icon type=icon /] [/#if][#t/]
            [#if showText]
                [@resolvedName title titleKey/][#t/]
            [/#if]
        </a>[#t/]
    [#if inList]</li>[/#if][#t/]
[/#macro]

[#-- =============================================================================================== @ui.displayLinkForAUIDialog --]
[#macro displayLinkForAUIDialog class="" title="" titleKey="" icon='' id='' inList=false showText=true accessKey='' href='']
    [#if inList]<li class="dropdown-item">[/#if][#t/]
        <a [#if !showText]title="[@resolvedName title titleKey/]" [/#if][#t/]
            [#if accessKey?has_content]accesskey="${accessKey}" [/#if][#t/]
            [#if id?has_content]id="${id}" [/#if][#t/]
            [#if href?has_content]href="${href}" [/#if][#t/]
            [#if inList || class?has_content]class="[#if inList]item-link [/#if][#if class?has_content]${class}[/#if]" [/#if][#t/]
        >[#t/]
            [#if icon?has_content][@ui.icon type=icon /] [/#if][#t/]
            [#if showText]
                [@resolvedName title titleKey/][#t/]
            [/#if]
        </a>[#t/]
    [#if inList]</li>[/#if][#t/]
[/#macro]


[#-- =============================================================================================== @ui.displayText --]
[#macro displayText text='' key='']
<p class="description">
    [#if text?has_content || key?has_content ]
        [@resolvedName text key/]
    [/#if]
    [#nested]
</p>
[/#macro]

[#-- ===================================================================================== @ui.displayRightColumnText --]
[#macro displayDescription text='' key='']
<div class="field-group">
    <div class="description">
        [#if text?has_content || key?has_content ]
            [@resolvedName text key/]
        [/#if]
        [#nested]
    </div>
</div>
[/#macro]

[#-- ============================================================================================= @ui.displayFooter --]
[#macro displayFooter text='']
<div class="buttons-container">
    <div class="buttons">
        ${text}
        [#nested]
    </div>
</div>
[/#macro]
[#-- =================================================================================================== @ui.buttons --]
[#macro buttons]
    <div class="buttons-container">
        <div class="buttons">
            [#nested]
        </div>
    </div>
[/#macro]

[#-- ============================================================================================= @ui.displayButton --]
[#macro displayButton id='' accesskey='' title='' value='' valueKey='' uri='']
[@compress single_line=true]
<input type="button"
    [#if id?has_content] id=${id} [/#if]
    [#if accesskey?has_content] accesskey=${accesskey} [/#if]
    [#if title?has_content] title=${title} [/#if]
    [#if value?has_content] value=${value} [/#if]
    [#if valueKey?has_content] value=[@ww.text name=valueKey /] [/#if]
    [#if uri?has_content] onclick="location.href='${uri}'" [/#if]
/>[/@compress]
[/#macro]


[#-- ================================================================================================= @ui.commaList --]
[#macro commaList list]
[#list list as item]
${item}[#if item_has_next], [/#if][#t]
[/#list]
[/#macro]

[#-- ================================================================================================= @ui.barGraph--]
[#macro barGraph color width title]
<div title="${title}" style="background-color: ${color}; width: ${width}%; height: 5px; font-size: 5px;  /* IE hack */"></div>
[/#macro]

[#-- ================================================================================================= @ui.header--]
[#macro header object='' page='' pageKey='' description='' descriptionKey='' cssClass='' title=false showPlanSuspended=false]
    [#assign headerText]
        [#if object?has_content]${object?html}: [/#if][#t]
        [#if page?has_content || pageKey?has_content][@ui.resolvedName page pageKey /][/#if][#t]
    [/#assign]

    [#if title]
        [#if headerText?trim?has_content]
            <title>${headerText?trim}</title>
        [/#if]
    [#else]
        [#if headerText?trim?has_content]
            <h1[#if cssClass??] class="${cssClass}"[/#if]>${headerText?trim}</h1>[#t]
        [/#if]
        [#if description?has_content || descriptionKey?has_content]
            [@ui.displayText description descriptionKey /]
        [/#if]
    [/#if]
[/#macro]

[#-- ================================================================================= @ui.renderAgentNameLink --]
[#macro renderAgentNameLink agent]
    [#if agent.definition.type.freemarkerIdentifier == "elastic"]
        [#if fn.hasAdminPermission() ]
            <a href="${req.contextPath}/admin/elastic/manageElasticInstances.action" >
                <img class="elasticIcon" id="${agent.id}Elastic" src="${req.contextPath}/images/jt/icn_elastic_cloud.gif" alt="(elastic)"/>
            </a>
        [#else]
            <img class="elasticIcon" id="${agent.id}Elastic" src="${req.contextPath}/images/jt/icn_elastic_cloud.gif" alt="(elastic)"/>
        [/#if]
        [@dj.tooltip target='${agent.id}Elastic' text="This agent is running in the Amazon Elastic Compute Cloud" /]
    [/#if]
    <a href="${req.contextPath}/agent/viewAgent.action?agentId=${agent.id}">${agent.name?html}</a>[#t/]
[/#macro]

[#macro renderPipelineDefinitionNameLink definition]
    [#if definition.type.freemarkerIdentifier == "elastic"]
        [#if fn.hasAdminPermission() ]
            <a href="${req.contextPath}/admin/elastic/manageElasticInstances.action" >
                <img class="elasticIcon" id="${definition.id}Elastic" src="${req.contextPath}/images/jt/icn_elastic_cloud.gif" alt="(elastic)"/>
            </a>
        [#else]
            <img class="elasticIcon" id="${definition.id}Elastic" src="${req.contextPath}/images/jt/icn_elastic_cloud.gif" alt="(elastic)"/>
        [/#if]
        [@dj.tooltip target='${definition.id}Elastic' text="This agent is running in the Amazon Elastic Compute Cloud" /]
    [/#if]
    <a href="${req.contextPath}/agent/viewAgent.action?agentId=${definition.id}">${definition.name?html}</a>[#t/]
[/#macro]

[#macro renderAgentNameAdminLink agent]
    [#if agent.definition.type.freemarkerIdentifier == "elastic"]
        [#if fn.hasAdminPermission() ]
            <a href="${req.contextPath}/admin/elastic/manageElasticInstances.action" >
                <img class="elasticIcon" id="${agent.id}Elastic" src="${req.contextPath}/images/jt/icn_elastic_cloud.gif" alt="(elastic)"/>
            </a>
        [#else]
            <img class="elasticIcon" id="${agent.id}Elastic" src="${req.contextPath}/images/jt/icn_elastic_cloud.gif" alt="(elastic)"/>
        [/#if]
        [@dj.tooltip target='${agent.id}Elastic' text="This agent is running in the Amazon Elastic Compute Cloud" /]
    [/#if]
    <a href="${req.contextPath}/admin/agent/viewAgent.action?agentId=${agent.id}">${agent.name?html}</a>[#t/]
[/#macro]


[#-- ================================================================================= @ui.renderPlanNameLink --]
[#macro renderPlanNameLink plan]
    [#if fn.hasPlanPermission('READ', plan) ]
        [#-- if plan description is not empty render it as title --]
        <a [#if plan.description?has_content]
                title="${plan.description}"
            [#else]
                title="${plan.key}"
           [/#if]
            href="${req.contextPath}/browse/${plan.key}" [#if plan.suspendedFromBuilding] class="Suspended" [/#if]>${plan.name}</a>[#t]
    [#else]
        ${plan.name}[#t]
    [/#if]
[/#macro]

[#macro renderPlanConfigLink plan]
    <a title="${plan.key}" href="[@ww.url value='/browse/${plan.key}/config'/]">
        [#if plan.type=="JOB"]
            ${plan.parent.project.name} &rsaquo; ${plan.parent.buildName} &rsaquo; ${plan.buildName}[#t]
        [#else]
            ${plan.project.name} &rsaquo; ${plan.buildName}[#t]
        [/#if]</a>[#t]
[/#macro][#lt]

[#macro renderBuildResultSummary buildResultSummary='']
[#if buildResultSummary?has_content]
    <a title="${buildResultSummary.buildResultKey} (${buildResultSummary.buildCompletedDate})" class="${buildResultSummary.buildState}" href="${req.contextPath}/browse/${buildResultSummary.buildResultKey}">${buildResultSummary.buildResultKey}</a>[#t]
[/#if]
[/#macro]

[#-- ================================================================================= @ui.renderValidJiraIssues --]

[#macro renderValidJiraIssues content, buildResultSummary ]
    ${jiraIssueUtils.getRenderedString(htmlUtils.getTextAsHtml(content), buildResultSummary)}
[/#macro]

[#macro renderJiraIssues content]
    ${jiraIssueUtils.getRenderedString(htmlUtils.getTextAsHtml(content))}
[/#macro]

[#-- ================================================================================================= @ui.clear --]
[#macro clear]
<div class="paddedClearer"></div>
[/#macro]
[#-- ================================================================================================= @ui.displayUserFullName --]
[#macro displayUserFullName user='']
[#if user?has_content]
    ${fn.getUserFullName(user)?html}
[/#if]
[/#macro]
[#-- ================================================================================================= @ui.displayUserGravatar --]
[#macro displayUserGravatar userName='' size=''][#rt]
	[#assign defaultGravatar][@cp.getStaticResourcePrefix/]/images/icons/businessman.gif[/#assign]
	${action.getGravatarUrl(userName, size)!defaultGravatar}[#t]
[/#macro]
[#-- ================================================================================================= @ui.displayAuthorFullName --]
[#macro displayAuthorFullName author='']
[#if author?has_content]
    ${fn.getAuthorFullName(author)?html}
[/#if]
[/#macro]
[#-- ================================================================================================= @ui.displayAuthorOrProfileLink --]
[#macro displayAuthorOrProfileLink author]
[@compress singleLine=true]
  [#if req?has_content]
     [#if author.linkedUserName?has_content]
        ${req.contextPath}/browse/user/${author.linkedUserName}
     [#else]
       ${req.contextPath}/browse/author/${author.getNameForUrl()}
     [/#if]
  [#elseif baseUrl?has_content]
     [#if author.linkedUserName?has_content]
       ${baseUrl}/browse/user/${author.linkedUserName}
     [#else]
       ${baseUrl}/browse/author/${author.getNameForUrl()}
     [/#if]
  [/#if]
[/@compress]
[/#macro]
[#-- ================================================================================================= @ui.displayRelativeDates --]
[#macro displayRelativeDates date='']
[#if date?has_content]
    <span title="${(date?datetime)!}">${durationUtils.getRelativeDate(date)}</span>

[/#if]
[/#macro]
[#-- ================================================================================================= @ui.displayBuildHungDurationInfoHtml --]
[#macro displayBuildHungDurationInfoHtml buildTime='', averageTime='', buildHangDetails='']
<br/>This build has been running for <strong>${durationUtils.getPrettyPrint(buildTime)}</strong>.[#t]
[#if buildTime > averageTime && averageTime > 0]
    [#assign _fraction=((durationUtils.getNormalizedTime(buildTime)-averageTime)*100/averageTime)?round]
    [#if _fraction > 0]
        This is <strong>${_fraction}%</strong> longer than usual.
    [/#if]
[/#if]
[#if buildHangDetails.lastLogTime != 0]
    <br/>It has been <strong>${durationUtils.getPrettyPrint(buildHangDetails.timeSinceLastLogTime)}</strong> since Bamboo received a log message for this build.
[/#if]
[/#macro]
[#-- ================================================================================================= @ui.displayBuildHungDurationInfoText --]
[#macro displayBuildHungDurationInfoText buildTime='', averageTime='', buildHangDetails='']
This build has been running for ${durationUtils.getPrettyPrint(buildTime)}[#t]
[#if buildTime > averageTime && averageTime > 0]
[#assign _fraction=((durationUtils.getNormalizedTime(buildTime)-averageTime)*100/averageTime)?round]
[#if _fraction > 0]
, which is ${_fraction}% longer than usual[#t]
[/#if]
[/#if]
.
[#if buildHangDetails.lastLogTime != 0]
It has been ${durationUtils.getPrettyPrint(buildHangDetails.timeSinceLastLogTime)} since Bamboo received a log message for this build.
[/#if]
[/#macro]
[#-- ================================================================================================= @ui.displayLogLines --]
[#macro displayLogLines buildLog]
[#if buildLog?has_content]
<table id="buildLog">
[#list buildLog as line]
<tr>
    <td class="time">
        ${line.formattedDate}
    </td>
    <td[#if line.cssStyle??] class="${line.cssStyle}" [/#if]>${line.log}</td>
</tr>
[/#list]
</table>
[/#if]
[/#macro]

[#-- ================================================================================================= @ui.displayYesOrNo --]
[#macro displayYesOrNo displayBool]
[#if displayBool?string == 'true']
    [@ww.text name='global.common.yes' /]
[#else]
    [@ww.text name='global.common.no' /]
[/#if]
[/#macro]

[#-- ================================================================================================ @ui.displayJdk --]
[#macro displayJdk jdkLabel isJdkValid]
[@ww.label labelKey='builder.common.jdk' value=jdkLabel /]
[#if !isJdkValid]
    [@ui.messageBox type="warning"]
        [@ww.text name='builder.common.jdk.invalid' ]
            [@ww.param]${jdkLabel!}[/@ww.param]
        [/@ww.text]
        [#if fn.hasGlobalAdminPermission() ]
            [@ww.text name='builder.common.jdk.invalid.admin' ]
                [@ww.param]<a href="${req.contextPath}/admin/agent/configureSharedLocalCapabilities.action?capabilityType=jdk&jdkLabel=${jdkLabel!}">[/@ww.param]
                [@ww.param]</a>[/@ww.param]
            [/@ww.text]
        [/#if]
    [/@ui.messageBox]
[/#if]
[/#macro]

[#-- ================================================================================================= @ui.displayAddJdkInline --]
[#macro displayAddJdkInline]
    [#if fn.hasAdminPermission()]
        [@ww.text id='addSharedJdkCapabilityTitle' name='builder.common.jdk.inline.heading' /]
        [@ww.url  id='addSharedJdkCapabilityUrl' value='/ajax/configureSharedJdkCapability.action' returnUrl=currentUrl /]
        <a class="addSharedJdkCapability" title="${addSharedJdkCapabilityTitle}" href="${addSharedJdkCapabilityUrl}">${addSharedJdkCapabilityTitle}</a>
    [/#if]
[/#macro]

[#-- =================================================================================== @ui.displayAddBuilderInline --]
[#macro displayAddBuilderInline builderKey=""]
    [#if fn.hasAdminPermission()]
        [@ww.text id='addSharedBuilderCapabilityTitle' name='builders.form.inline.heading' /]
        [@ww.url  id='addSharedBuilderCapabilityUrl' value='/ajax/configureSharedBuilderCapability.action?builderKey=${builderKey}' returnUrl=currentUrl/]
        <a class="addSharedBuilderCapability" title="${addSharedBuilderCapabilityTitle}" href="${addSharedBuilderCapabilityUrl}">${addSharedBuilderCapabilityTitle}</a>
    [/#if]
[/#macro]

[#-- ================================================================================================= @ui.displayIdeIcon --]
[#macro displayIdeIcon]
    [#assign currUser = user /]
    [#assign port = bambooUserManager.getBambooUser(currUser).idePort /]
    <img src="http://localhost:${port}/icon" alt=""
         class="ideConnectorIcon"
         title="${action.getText('ideConnector.openBuild')}"
         onerror="this.width=1"
         onclick="this.src='http://localhost:${port}/build?build_key=${build.key}&build_number=${buildNumber}&server_url=${baseUrl}&id=' + Math.floor(Math.random()*1000)"
         style="cursor: pointer">
[/#macro]

[#-- ====================================================================================================== @ui.icon --]
[#--
    Shows a span for an icon

    @requires type - a string containing the icon type (eg. "failed") which will be prefixed with "icon-"
    @optional text - a string to be inserted inside the icon span, which will be hidden using CSS
--]
[#macro icon type text="" textKey=""]
    [#assign iconText][@ui.resolvedName text textKey/][/#assign]
    <span class="icon icon-${type}"[#if iconText?has_content] title="${iconText}"[/#if]>[#if iconText?has_content]<span>${iconText}</span>[/#if]</span>[#t]
[/#macro]

[#-- ================================================================================================ @ui.messageBox --]
[#macro messageBox id="" type="info" title="" titleKey="" content="" shadowed=true closeable=false icon=true hidden=false]
    [#assign class="aui-message " + type /]
    [#if shadowed]
        [#assign class = class + " shadowed"]
    [/#if]
    [#if closeable]
        [#assign class = class + " closeable"]
    [/#if]
    <div [#if id?has_content]id="${id}"[/#if] class="${class}"[#if hidden] style="display: none;"[/#if]>
        [#if titleKey?has_content || title?has_content]
            <p class="title">
                [#if icon]<span class="aui-icon icon-${type}"></span>[/#if]
                <strong>[@resolvedName text=title textKey=titleKey /]</strong>
            </p>
            [#if content?has_content]${content}[/#if]
            [#nested /]
        [#else]
            [#if content?has_content]${content}[/#if]
            [#nested /]
            [#if icon]<span class="aui-icon icon-${type}"></span>[/#if]
        [/#if]
    </div>
[/#macro]

[#-- ====================================================================================================== @ui.standardMenu --]
[#--
    Display a menu in Bamboo.  Does not allow grouping of attributes.  Nested should be a bunch of <li>'s to be displayed in the menu

    @requires triggerText - a string/title of the drop down
    @requires id - a unique id for the drop down.
--]
[#macro standardMenu triggerText id]
<div class="aui-dd-parent" id="${id}">
    <span class="aui-dd-trigger">${triggerText} [@ui.icon type="drop" /]</span>
    <ul class="aui-dropdown aui-dropdown-right hidden">
        [#nested]
    </ul>
</div>
<script type="text/javascript">
    AJS.$(function() {
        AJS.$("#${id}").dropDown();
    });
</script>
[/#macro]

[#-- ====================================================================================================== @ui.standardMenu --]
[#--
    Display a menu in Bamboo that contains grouped elements.  Nested should be a bunch of <ul>'s, one for each group of items.

    @requires triggerText - a string/title of the drop down
    @requires id - a unique id for the drop down.
--]
[#macro groupedMenu triggerText id]
<div class="aui-dd-parent" id="${id}">
   <span class="aui-dd-trigger">${triggerText} [@ui.icon type="drop" /]</span>
    <ul class="aui-dropdown aui-dropdown-right hidden">
        <li>
            [#nested]
        </li>
    </ul>
</div>
<script type="text/javascript">
    AJS.$(function()
          {
              AJS.$("#${id}").dropDown();
          });
</script>
[/#macro]

[#-- ====================================================================================================== @ui.time --]
[#--
    Provides a consistent formatting for the <time> element

    @requires datetime - a datetime object
--]
[#macro time datetime]
<time datetime="${datetime?string("yyyy-MM-dd'T'HH:mm:ss")}">[#nested]</time>[#t]
[/#macro]

[#macro renderWebPanels location]
    [#list ctx.getWebPanels(location) as webpanel]
        ${webpanel}
    [/#list]
[/#macro]
