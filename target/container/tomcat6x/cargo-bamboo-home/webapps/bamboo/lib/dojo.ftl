[#-- This file is wrapper for using javascript widgets --]
[#-- =================================================================================================== @dj.tooltip --]
[#macro tooltip target text='' store=false showDelay=500]
[#if !enableJavascript] [#return] [/#if]

[#if text?has_content]
    [#assign tooltipText = text]
[#else]
    [#assign tooltipText]
    [#nested /]
    [/#assign]
    [#assign tooltipText = tooltipText?trim]
[/#if]
[#if tooltipText?has_content]
<script type="text/javascript">
    AJS.$(function() {
        var targetId = '${target?replace(":", "\\\\:")?js_string}';
        AJS.InlineDialog(AJS.$('#' + targetId), targetId.replace(/[^a-z0-9]/gi, '-'), function (contents, trigger, doShowPopup) {
            contents.html("<div class='tooltip'>${tooltipText?js_string}</div>");
            doShowPopup();
        }, {onHover: true, fadeTime: 50, hideDelay: 0, showDelay: ${showDelay}, width: 300});
    });
</script>
[/#if]
[/#macro]


[#-- ============================================================================================== @dj.tabContainer --]
[#macro tabContainer headings  selectedTab='' tabViewId='tabContainer']
<div id="${tabViewId}" class="aui-tabs horizontal-tabs">
    <ul class="tabs-menu">
        [#list headings as heading]
            <li class="menu-item [#if selectedTab == heading] active-tab[/#if]">
                 <a href="#${heading?replace(' ', '')}"><strong>${heading}</strong></a>
            </li>

            [#if heading == selectedTab]
                [#assign selectedIndex = heading_index /]
            [/#if]
        [/#list]
    </ul>
    [#nested /]
</div>

[#if !selectedIndex??]
    <script type="text/javascript">
        AJS.$(function($){
            $("#${tabViewId} > .tabs-menu > .menu-item:first-child > a").click();
        });
    </script>
[#else]
    <script type="text/javascript">
        AJS.$(function($){
            $("#${tabViewId} > .tabs-menu > .active-tab > a").click();
        });
    </script>
[/#if]
[/#macro]

[#-- ============================================================================================== @dj.contentPane --]
[#macro contentPane labelKey='' id='']
[#if id?has_content]
    [#assign contentPaneId=id/]
[#elseif labelKey?has_content]
    [#assign contentPaneId=(action.getText(labelKey))?replace(" ", "")/]
[/#if]

<div [#if contentPaneId?has_content]id="${contentPaneId}"[/#if] class="tabs-pane">
    [#nested /]
</div>
[/#macro]

[#-- ============================================================================================== @dj.reloadPortlet --]
[#macro reloadPortlet id url reloadEvery loadScripts=true callback='null']
    <div id="${id}">
        [#nested /]
    </div>
    [#if enableJavascript && reloadEvery > 0]
    <script type="text/javascript">
        addUniversalOnload(function() {
            setTimeout(function() {reloadPanel('${id}', '${url}', ${reloadEvery}, ${loadScripts?string}, null, ${callback?string});}, ${reloadEvery} * 1000);
        });
    </script>
    [/#if]
[/#macro]

[#-- ============================================================================================== @dj.simpleDialogForm --]
[#--
     @param triggerSelector  jQuery selector of elements which will be bound to show dialog during onClick event
     @param actionUrl        url which will return HTML of the form to be embedded into dialog
     @param width            width of the dialog
     @param height           height of the dialog
     @param submitLabelKey   i18n key of the label to be used for submit button
     @param submitMode       if set to "ajax" then form will be submitted using AJAX call
     @param submitCallback   callback to be called after submitting in AJAX mode (if set will enforce ajax mode)
--]
[#macro simpleDialogForm triggerSelector actionUrl="" width=800 height=400 submitLabelKey="global.buttons.create" submitMode="" submitCallback="null" cancelCallback="null" header="" headerKey=""]

    [#if submitCallback != "null"]
        [#assign submitMode = "ajax" /]    
    [/#if]
    [#if header?has_content || headerKey?has_content]
        [#assign resolvedHeaderText][@ui.resolvedName header headerKey/][/#assign]
    [/#if]

    <script type="text/javascript">
        [#if actionUrl?has_content]
            AJS.$(function() {
                simpleDialogForm(
                        '${triggerSelector}', '${req.contextPath}${actionUrl}',
                        ${width}, ${height},
                        '[@ww.text name=submitLabelKey /]', '${submitMode}', ${submitCallback?string},
                        null,
                        [#if resolvedHeaderText??]'${resolvedHeaderText?js_string}'[#else ]null[/#if]);
            });
        [#else]
            BAMBOO.simpleDialogForm({
                trigger: '${triggerSelector}',
                dialogWidth: ${width},
                dialogHeight: ${height},
                success: ${submitCallback?string},
                cancel: ${cancelCallback?string}[#if resolvedHeaderText??],
                header: "${resolvedHeaderText?js_string}"[/#if]
            });
        [/#if]
    </script>

[/#macro]

[#-- ============================================================================================== @dj.imageReload --]
[#--
     @param target (required)               id of the image
     @param reload element class            class of the reload element
     @param titleKey                        i18n key for the title of the element
--]
[#macro imageReload target reloadElementClass="image-reload" titleKey="image.reload"]
<script type="text/javascript">
    jQuery(function(){
        jQuery("#" + "${target?js_string}").reloadImage({ text: "[@ww.text name=titleKey /]", cssClass: "${reloadElementClass?js_string}"});
    });
</script>
[/#macro]

[#-- =============================================================================================== @dj.progressBar --]
[#--
    @param id (required)    id to give the progress bar
    @param value            initial percentage complete as an integer (0-100)
    @param text             text to show in the progress bar
--]
[#macro progressBar id value=0 text="" cssClass=""]
[#if value lt 0]
    [#assign progressBarValue = 0]
[#elseif value gt 100]
    [#assign progressBarValue = 100]
[#else]
    [#assign progressBarValue = value]
[/#if]
<div id="${id}" class="progress[#if cssClass?has_content] ${cssClass}[/#if]">
    <div class="progress-bar" style="width: ${progressBarValue}%;"></div>
    <div class="progress-text">${text}</div>
</div>
<script type="text/javascript">
    AJS.$("#${id}").progressBar();
</script>
[/#macro]

[#-- ============================================================================================== @dj.cronBuilder --]
[#-- Adds a cron builder to the target field.
    @param name (required):  Name of the webwork variable that contains the cron expression. Cron expression
                                     will be read and saved to this variable.
    @param idPrefix (optional): Must be unique on the page.
    @param helpKey (optional): Key for a help bubble.
--]
[#macro cronBuilder name idPrefix="" helpKey=""]
    [#assign hiddenFieldId=idPrefix + "cronExpressionTarget" /]
    [#assign displayFieldId=idPrefix + "cronExpressionDisplay" /]

    [@ww.hidden id=hiddenFieldId name=name/]
    [@ww.label id=displayFieldId labelKey='cronEditorBean.label' name=name helpKey=helpKey showDescription=true required=true/]

    <script type="text/javascript">
        AJS.$("#${displayFieldId}").cronBuilder({
             hiddenFieldSelector: "#${hiddenFieldId}",
             dialogTrigger: '<a id="${idPrefix}cronBuilder" class="cron-builder">[@ui.icon type="edit" textKey="cronEditorBean.title"/]</a>',
             eventNamespace: "${idPrefix}cronEditorDialogEvent",
             contextPath: "${req.contextPath}",
             dialogSubmitButtonText: "[@ww.text name='global.buttons.done' /]",
             dialogHeadingText: "[@ww.text name='cronEditorBean.title'/]"
        });
    </script>
[/#macro]

[#macro cronDisplay name idPrefix="" ]
    [@ww.label id="${idPrefix}cronExpression" labelKey="cronEditorBean.label" name=name showDescription=true/]
    <script>
        AJS.$("#${idPrefix}cronExpression").cronDisplay("${req.contextPath}");
    </script>
[/#macro]

[#-- defines a JavaScript variable with name and content copied from action parameter, HTML escaped --]
[#macro defineJsVariableFromActionParam parameterName]
    [#assign jsVariableIndex=(jsVariableIndex!-1)+1/]

    <span id="action_param_${jsVariableIndex}" class="hidden">${parameterName?eval?html}</span>

    <script type="text/javascript">
        var ${parameterName} = AJS.$("#action_param_${jsVariableIndex}").text();
    </script>
[/#macro]

[#-- =============================================================================================== @dj.inPlaceEdit --]
[#-- Create in-place edit (textfield) control.
     @param id (required):            Suffix of id used for control
     @param value (required):         Initial value to display
--]
[#macro inPlaceEditTextField id value]
    <span class="inline-edit-view" tabindex="0" id="${id}">${value}</span>
    [@ww.textfield name=id theme="simple" cssClass="inline-edit-field text" value=value /]
[/#macro]