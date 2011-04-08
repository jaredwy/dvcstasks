// Constants
var BAMBOO = window.BAMBOO || {},
    BAMBOO_DASH_DISPLAY_TOGGLES = "bamboo.dash.display.toggles",
    BAMBOO_EVENT_ON_DASHBOARD_RELOADED = "BAMBOO_EVENT_ON_DASHBOARD_RELOADED",
    VK_ESCAPE = 27,
    VK_ENTER = 13;
//
// Display the given help page in a separate window
//
function openHelp(helpPage) {
    window.open(helpPage, 'manualPopup', 'width=770,height=550,scrollbars=yes,status=yes,resizable=yes');
}

function isDefinedObject(reference) {
    return (typeof reference !== "undefined") && (reference !== null);
}

/**
 * Any href clicked with rel=help (e.g. our help bubbles) will open in new window.
 * Applies to all of Bamboo.
**/
AJS.$(document).delegate("a[rel~='help']", "click", function (e) {
    e.preventDefault();
    window.open(this.href);
});

/**
 * Disables AUI Tabs scripting where we don't use dynamic tabs
 */
AJS.$(function ($) {
    $("div.aui-tabs.non-dynamic-tabs").find("> ul.tabs-menu a").unbind("click");
});

/**
 * Workaround for Cancel links in Dialog which append a hash to URL by default
 */
AJS.$("a.button-panel-link[href='#']").live("click", function (e) {
    e.preventDefault();
});

/**
 * AJS.BambooDialog
 */
AJS.BambooDialog = function(options, onSubmitCallback, onCancelCallback) {
    var dialog;
    options = options || {};
    options = jQuery.extend({}, options, {
        keypressListener: function(e) {
            if (e.keyCode == VK_ESCAPE) {
                 if (isDefinedObject(onCancelCallback)) {
                     onCancelCallback(dialog);
                 } else {
                     dialog.remove();
                 }
            } else if (e.keyCode == VK_ENTER && isDefinedObject(onSubmitCallback)) {
                onSubmitCallback(dialog);
            }
        }
    });
    dialog = new AJS.Dialog(options);
    return dialog;
};

// Text used in the title attribute for elements that have keyboard shortcuts - ideally would be internationalised...
AJS.params.keyType = "Type";
AJS.params.keyThen = "then";

String.prototype.replaceAll = function(pcFrom, pcTo) {
    var MARKER = "js___bmbo_mrk",
        i = this.indexOf(pcFrom),
        c = this;
    while (i > -1) {
        c = c.replace(pcFrom, MARKER);
        i = c.indexOf(pcFrom);
    }

    i = c.indexOf(MARKER);
    while (i > -1) {
        c = c.replace(MARKER, pcTo);
        i = c.indexOf(MARKER);
    }

    return c;
};


if (!jQuery.generateId) {
  jQuery.generateId = function() {
    return arguments.callee.prefix + arguments.callee.count++;
  };
  jQuery.generateId.prefix = 'jq-';
  jQuery.generateId.count = 0;

  jQuery.fn.generateId = function() {
    return this.each(function() {
      this.id = jQuery.generateId();
    });
  };
}


/*
 Runs on a change of a
*/
function handleOnSelectShowHide(sel)
{
    var hideClassName = ("dependsOn" + sel.name).replaceAll(".", "\\."),
        switchValue = getSwitchValue(sel);
    if (!switchValue && sel.type == 'radio') return;

    var selector = "#" + sel.form.id + " ." + hideClassName,
        showPattern = "showOn" + switchValue,
        hidePattern = "showOn__" + switchValue;

    AJS.$(selector).each(function() {
        var $deps = AJS.$(this);
        if ($deps.attr("class").indexOf("showOn__") != -1) {
            if ($deps.hasClass(hidePattern)) {
                $deps.hide();
            } else {
                $deps.show();
            }
        } else {
            if ($deps.hasClass(showPattern)) {
                $deps.show();
            } else {
                $deps.hide();
            }
        }
        if ($deps.hasClass(hidePattern)) {
            $deps.hide();
        }
    });
}

/**
 * JSOn listData looks like:
 *
 *  [data: [{value: 'key1', text: 'name for the screen', supportedValues: ['dependencyKey1', 'dependencyKey2']},
 *   {value: 'key2', text: "name 2", supportedValues: ['dependencyKey1']}]]
 *
 * If supportedValues is empty it will be shown for all selections in selParentJQ.
 *
 * @param selParentJQ - the select list that the your data depends on
 * @param selToMutateJQ - the select list that you want to mutate based on the contents of the selDependency
 * @param listDataJson - the json containing all information required to generate the selToMutate
 */
function mutateSelectListContent(selParentJQ, selToMutateJQ, listDataJson)
{
    var selParent = selParentJQ[0];
    var selToMutate = selToMutateJQ[0];
    var currentSelectedValue = selToMutateJQ.val();
    var switchValue = getSwitchValue(selParent);
    //wipe existing items
    selToMutate.options.length = 0;

    var listData = listDataJson.data;
    // got through selToMutate check if each item is in allowed Items, if not remove?
    for (var i = 0; i<listData.length; i++){
        var value = listData[i].value;
        var text = listData[i].text;
        var allowedOptions = listData[i].supportedValues;

        var show = allowedOptions === null || allowedOptions.length <= 0 || !switchValue;
        if (!show)
        {
            for (var x = 0; x < allowedOptions.length; x++)
            {
                var allowedOption = allowedOptions[x];
                if (switchValue === allowedOption)
                {
                    show = true;
                    break;
                }
            }
        }

        if (show)
        {
            selToMutate.options[selToMutate.options.length]=new Option(text, value, false, value === currentSelectedValue);
        }
    }

    // make sure we update the dependents of the mutated list.
    handleOnSelectShowHide(selToMutate)
}

function getSwitchValue(obj)
{
    if (obj.options && obj.selectedIndex > -1)
    {
        var opt = obj.options[obj.selectedIndex];
        //  Special uiSwitch* class prefix
        if (opt.className.indexOf('uiSwitch') != -1)
        {
            var uiSwitch = opt.className.substring(opt.className.lastIndexOf("uiSwitch") + 8);
            return uiSwitch;
        }
        else
        {
            return opt.value;
        }
    }
    else if (obj.type == 'radio')
    {
        if (obj.checked)
            return obj.value;
        else
            return null;
    }
    else if (obj.type == 'checkbox')
    {
        if (obj.checked)
            return obj.value;
        else
            return 'false';
    }
    else
    {
        return obj.value;
    }
}


/*
 Toggles hide / unhide an element. Also attemots to change the "elementId + header" element to have the headerOpened / headerClosed class.
 Also saves the state in a cookie
*/
function toggleElement(elementId, suffix)
{
    var elem = document.getElementById(elementId);
    if (elem)
    {
        if (readFromConglomerateCookie("bamboo.conglomerate.general.cookie", elementId, '1') == '1')
        {
            elem.style.display = "none";
            var toggler = document.getElementById(elementId + "Toggle");
            if (toggler)
            {
                toggler.innerHTML = "show" + (suffix ? " " + suffix : "");
            }
            //            removeClassName(elementId + 'header', 'headerOpened');
            //            addClassName(elementId + 'header', 'headerClosed');
            saveToConglomerateCookie("bamboo.conglomerate.general.cookie", elementId, '0');
        }
        else
        {
            elem.style.display = "";
            var toggler = document.getElementById(elementId + "Toggle");
            if (toggler)
            {
                toggler.innerHTML = "hide" + (suffix ? " " + suffix : "");
            }
            //            removeClassName(elementId + 'header', 'headerClosed');
            //            addClassName(elementId + 'header', 'headerOpened');
            eraseFromConglomerateCookie("bamboo.conglomerate.general.cookie", elementId);
        }
    }
}

function toggleDivsWithCookie(elementShowId, elementHideId)
{
    var elementShow = document.getElementById(elementShowId);
    var elementHide = document.getElementById(elementHideId);
    if (elementShow.style.display == 'none')
    {
        elementHide.style.display = 'none';
        elementShow.style.display = 'block';
        saveToConglomerateCookie("bamboo.viewissue.cong.general.cookie", elementShowId, null);
        saveToConglomerateCookie("bamboo.viewissue.cong.general.cookie", elementHideId, '0');
    }
    else
    {
        elementShow.style.display = 'none';
        elementHide.style.display = 'block';
        saveToConglomerateCookie("bamboo.viewissue.cong.general.cookie", elementHideId, null);
        saveToConglomerateCookie("bamboo.viewissue.cong.general.cookie", elementShowId, '0');
    }
}

/*
 Similar to toggle. Run this on page load.
*/
function restoreDivFromCookie(elementId, cookieName, defaultValue, suffix)
{
    if (defaultValue == null)
        defaultValue = '1';

    var elem = document.getElementById(elementId);
    if (elem)
    {
        if (readFromConglomerateCookie(cookieName, elementId, defaultValue) != '1')
        {
            elem.style.display = "none";
            var toggler = document.getElementById(elementId + "Toggle");
            if (toggler)
            {
                toggler.innerHTML = "show" + (suffix ? " " + suffix : "");
            }
            //            removeClassName(elementId + 'header', 'headerOpened');
            //            addClassName(elementId + 'header', 'headerClosed')
        }
        else
        {
            elem.style.display = "";
            var toggler = document.getElementById(elementId + "Toggle");
            if (toggler)
            {
                toggler.innerHTML = "hide" + (suffix ? " " + suffix : "");
            }
            //            removeClassName(elementId + 'header', 'headerClosed');
            //            addClassName(elementId + 'header', 'headerOpened')
        }
    }
}

/*
 Similar to toggle. Run this on page load.
*/
function restoreElement(elementId, suffix)
{
    restoreDivFromCookie(elementId, "bamboo.conglomerate.general.cookie", '1', suffix);
}

// Cookie handling functions

function saveToConglomerateCookie(cookieName, name, value)
{
    var cookieValue = getCookieValue(cookieName);
    cookieValue = addOrAppendToValue(name, value, cookieValue);

    saveCookie(cookieName, cookieValue, 365);
}

function readFromConglomerateCookie(cookieName, name, defaultValue)
{
    var cookieValue = getCookieValue(cookieName);
    var value = getValueFromCongolmerate(name, cookieValue);
    if (value != null)
    {
        return value;
    }

    return defaultValue;
}

function eraseFromConglomerateCookie(cookieName, name)
{
    saveToConglomerateCookie(cookieName, name, "");
}

function getValueFromCongolmerate(name, cookieValue)
{
    var newCookieValue = null;
    // a null cookieValue is just the first time through so create it
    if (cookieValue == null)
    {
        cookieValue = "";
    }
    var eq = name + "-";
    var cookieParts = cookieValue.split('|');
    for (var i = 0; i < cookieParts.length; i++)
    {
        var cp = cookieParts[i];
        while (cp.charAt(0) == ' ')
        {
            cp = cp.substring(1, cp.length);
        }
        // rebuild the value string exluding the named portion passed in
        if (cp.indexOf(name) == 0)
        {
            return cp.substring(eq.length, cp.length);
        }
    }
    return null;
}

//either append or replace the value in the cookie string
function addOrAppendToValue(name, value, cookieValue)
{
    var newCookieValue = "";
    // a null cookieValue is just the first time through so create it
    if (cookieValue == null)
    {
        cookieValue = "";
    }

    var cookieParts = cookieValue.split('|');
    for (var i = 0; i < cookieParts.length; i++)
    {
        var cp = cookieParts[i];

        // ignore any empty tokens
        if (cp != "")
        {
            while (cp.charAt(0) == ' ')
            {
                cp = cp.substring(1, cp.length);
            }
            // rebuild the value string exluding the named portion passed in
            if (cp.indexOf(name) != 0)
            {
                newCookieValue += cp + "|";
            }
        }
    }

    // always append the value passed in if it is not null or empty
    if (value != null && value != '')
    {
        var pair = name + "-" + value;
        if ((newCookieValue.length + pair.length) < 4020)
        {
            newCookieValue += pair;
        }
    }
    return newCookieValue;
}

function getCookieValue(name, defaultString)
{
    var eq = name + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++)
    {
        var c = ca[i];
        while (c.charAt(0) == ' ')
        {
            c = c.substring(1, c.length);
        }
        if (c.indexOf(eq) == 0)
        {
            return c.substring(eq.length, c.length);
        }
    }

    return defaultString;
}

function saveCookie(name, value, days)
{
    var ex;
    if (days)
    {
        var d = new Date();
        d.setTime(d.getTime() + (days * 24 * 60 * 60 * 1000));
        ex = "; expires=" + d.toGMTString();
    }
    else
    {
        ex = "";
    }
    document.cookie = name + "=" + value + ex + ";path=" + (!BAMBOO.contextPath.length ? "/" : BAMBOO.contextPath);
}

/*
Reads a cookie. If none exists, then it returns and
*/
function readCookie(name, defaultValue)
{
    var cookieVal = getCookieValue(name);
    if (cookieVal != null)
    {
        return cookieVal;
    }

    // No cookie found, then save a new one as on!
    if (defaultValue)
    {
        saveCookie(name, defaultValue, 365);
        return defaultValue;
    }
    else
    {
        return null;
    }
}

function eraseCookie(name)
{
    saveCookie(name, "", -1);
}

function addUniversalOnload(myFunction)
{
    AJS.$(document).ready(myFunction);
}

function attachHandler(object, event, myFunction)
{
    AJS.$("#" + object).bind(event, myFunction);
}

function toggleOn(e, toggleGroup_id)
{
    var onToggle = document.getElementById(toggleGroup_id + "_toggler_on");
    var offToggle = document.getElementById(toggleGroup_id + "_toggler_off");
    var target = document.getElementById(toggleGroup_id + "_target");
    onToggle.style.display = 'block';
    offToggle.style.display = 'none';
    target.style.display = 'block';
    saveToConglomerateCookie(BAMBOO_DASH_DISPLAY_TOGGLES, toggleGroup_id, null);
}

function toggleOff(e, toggleGroup_id)
{
    var onToggle = document.getElementById(toggleGroup_id + "_toggler_on");
    var offToggle = document.getElementById(toggleGroup_id + "_toggler_off");
    var target = document.getElementById(toggleGroup_id + "_target");
    onToggle.style.display = 'none';
    offToggle.style.display = 'block';
    target.style.display = 'none';
    saveToConglomerateCookie(BAMBOO_DASH_DISPLAY_TOGGLES, toggleGroup_id, '0');
}

function restoreTogglesFromCookie(toggleGroup_id)
{
    var elem = document.getElementById(toggleGroup_id + "_target");
    if (elem)
    {
        if (readFromConglomerateCookie(BAMBOO_DASH_DISPLAY_TOGGLES, toggleGroup_id, null) == '0')
        {
            toggleOff(null, toggleGroup_id);
        }
        else
        {
            toggleOn(null, toggleGroup_id);
        }
    }
}

// Forms JS
function toggleContainingCheckbox(e)
{
    if (e && e.target.tagName == "INPUT")
    {
        return true;
    }

    AJS.$(this).find("input:checkbox").each(function(){
        this.checked = !this.checked;
    });

    return true;
}



// ------------------------------------------------------------------------------------------------- Common Ajax Objects

function ajaxSubmitHandler(e, updateDivId)
{
    e.preventDefault();
    e.stopPropagation();

    var updater = getEl(updateDivId).getUpdateManager();
    var form = e.findTarget(null, 'form');

    updater.formUpdate(form);

    //alert('e: ' + e + ' ctx: ' + updater + ' this: ' + link.href);
}


function ajaxClickHandlerForDiv(e, updateDivId)
{

    var updater = getEl(updateDivId).getUpdateManager();
    var link = e.findTarget('internalLink', 'a');

    if (link != null)
    {
        e.preventDefault();
        updater.update(link.href, null, null, true);
    }

}

// This method will leak if used in a reloading panel. Use with care!
function rewriteForms(el, oResponseObject)
{
    var updater = el.getUpdateManager();
    var forms = el.getChildrenByTagName('form');
    for (var i = 0; i < forms.length; i++)
    {
        forms[i].addManagedListener('submit', ajaxSubmitHandler, el.id);
    }
}

function clearHandlers(el)
{

    var forms = el.getChildrenByTagName('form');
    for (var i = 0; i < forms.length; i++)
    {
        forms[i].removeAllListeners();
    }

    var evented = el.getChildrenByClassName('evented');
    for (var i = 0; i < evented.length; i++)
    {
        evented[i].removeAllListeners();
    }

    return true;
}


function toggleFavourite(url)
{
    AJS.$.get(url);
    return false;
}

/*
  Toggles the image's icon between having the suffix of '_on' and '_off'. This also clears the title.
*/
function toggleIcon(e)
{
    AJS.$(this).find("img").each(function(){
        var dom = this;
        if (dom.src)
        {
        if (dom.src.indexOf('_on.') != -1)
        {
            toggleIconOff(dom);
        }
        else if (dom.src.indexOf('_off') != -1)
        {
            toggleIconOn(dom);
        }
        }
    });

    return true;
}

function toggleIconOff(dom)
{
    dom.src = dom.src.replace('_on.', '_off.');
}

function toggleIconOn(dom)
{
    dom.src = dom.src.replace('_off.', '_on.');
}

function checkFormChanged(form)
{
    var domForm;
    if (form.dom)
    {
        domForm = form.dom;
    }
    else
    {
        domForm = form;
    }

    var textFields = domForm.getElementsByTagName("INPUT");
    for (var i = 0; i < textFields.length; i++)
    {
        var textField = textFields[i];
        if (textField.type == "text"){
            if (textField.value != textField.defaultValue) return true;
        } else if (textField.type == "textarea") {
            if (textField.value != textField.defaultValue) return true;
        } else if (textField.type == "checkbox") {
            if (textField.checked != textField.defaultChecked) return true;
        } else if (textField.type == "radio") {
            if (textField.checked != textField.defaultChecked) return true;
        } else if (textField.type == "password") {
            if (textField.value != textField.defaultValue) return true;
        }
    }

   var selectFields = domForm.getElementsByTagName("select");
    for (var y = 0; y < selectFields.length; y++)
    {
       var mySelect = selectFields[y];
        for (var z=0; z < mySelect.options.length; z++)
        {
            if (mySelect.options[z].defaultSelected) {
               if (!mySelect.options[z].selected) {
                   return true;
               } else {
                   break;
               }
            }
        }
    }

    var textAreas = domForm.getElementsByTagName("textarea");
    for (var x = 0; x < textAreas.length; x++)
    {
       var textArea = textAreas[x];
       if (textArea.value != textArea.defaultValue) return true;
    }

    return false;
};

/*
*   For user picker - when you click "Check All' all the select boxes are changed
*/
    var selectedBoxes = [];

    function setCheckboxes()
    {
        var numelements = document.selectorform.elements.length;
        var item0 = document.selectorform.elements[0];
        var item1;

        for (var i=1 ; i < numelements ; i++)
        {
            item1 = document.selectorform.elements[i];
            item1.checked = item0.checked;
            if (!selectedBoxes[item1.name])
                selectedBoxes[item1.name] = [];
            selectedBoxes[item1.name][item1.value] = item1.checked;
        }
    }

/**
 * Checks if the form has changed. If it hasn't then returns to the URL. If it has, submits the form with the returnUrl set to the URL
 * @param elem         DOM element or jQuery selector
 * @param contextPath
 * @param url
 */
function submitFormIfChanged(elem, contextPath, url)
{
    var theForm = elem.form ? elem.form : AJS.$(elem).get(0);

    if (checkFormChanged(theForm))
    {
        theForm.action = theForm.action + (theForm.action.indexOf('?') == -1 ? '?' : '&') + 'returnUrl=' + url;
        theForm.submit();
    }
    else
    {
        location.href = contextPath + url;
    }
}

/*
*  For User Picker - checkboxes are named after users so by compiling a list of all selected checkboxes
*   we have a list of users (comma seperated)
*/
    function getEntityNames()
    {
        var numelements = document.selectorform.elements.length;
        var item;
        var checkedList = "";

        var sep = "";
        for (var i = 0 ; i < numelements ; i++)
        {
            item = document.selectorform.elements[i];
            if (item != null && item.type == "checkbox" && item.name != "all" && item.checked == true)
            {
                var itemValue = item.value;
                itemValue = itemValue.replace(/\\/g, "\\\\").replace(/,/g, "\\,");
                checkedList  = checkedList + sep + itemValue;
                sep = ", ";
            }
        }

        return checkedList;
    }

/*
*   For User Picker - takes comma seperated list of users and places them in specified field.
*/
   function addUsers(commaDelimitedUserNames, fieldID, multiSelect)
    {
        var element = document.getElementById(fieldID);
        var currentUsers = element.value;
        if (!multiSelect) {
            element.value = commaDelimitedUserNames;
        } else if (currentUsers != null && currentUsers != ""){
            element.value = currentUsers + ", " + commaDelimitedUserNames;
        } else {
            element.value = commaDelimitedUserNames;
        }
    }

var STATUS_PREFIX = 'statusSection';
var REASON_PREFIX = 'reasonSummary';
var DURATION_PREFIX = 'durationSummary';
var LAST_BUILT = 'lastBuiltSummary';
var TESTCOUNT_PREFIX = 'testSummary';
var LATEST_BUILD_PREFIX = 'latestBuild';
var PLAN_PROPS = [LATEST_BUILD_PREFIX, REASON_PREFIX, DURATION_PREFIX, TESTCOUNT_PREFIX, LAST_BUILT];

function updatePlan(plan)
{
    try
    {
        var planKey = plan.planKey;

        //the following for loops have len initialised as such for improved performance
        for (var i = 0, len = PLAN_PROPS.length; i < len; i++)
        {
            var propPrefix =  PLAN_PROPS[i];
            var elem = AJS.$("#" + propPrefix + planKey);
            if (LATEST_BUILD_PREFIX == propPrefix)
            {
                // Update the status when first item and clear the existing classes on this element

                elem.closest(".planKeySection").attr('class', 'planKeySection ' + plan.statusClass);
            }
            elem.html(plan[propPrefix]);
        }
        var imgs = AJS.$("#" + STATUS_PREFIX + planKey).find("img");
        for (var i = 0, len = imgs.length; i < len; i++)
        {
            var statusIcon = imgs.get(i);
            var newPath = BAMBOO.contextPath + plan.statusIconPath;
            if (newPath != statusIcon.src)
            {
                statusIcon.src = newPath;
                statusIcon.title = plan.statusText;
            }
        }

        // Update favourites
        var faves = AJS.$('#favouriteIconFor_' + planKey);
        for (var i = 0, len = faves.length; i < len; i++)
        {
            var fave = faves.get(i);
            if (plan.favourite)
            {
                toggleIconOn(fave);
            }
            else
            {
                toggleIconOff(fave);
            }
        }

        if (plan.suspendedFromBuilding) {
            AJS.$('#resumeBuild_' + planKey).show();
            AJS.$('#stopSingleBuild_' + planKey).hide();
            AJS.$('#stopMultipleBuilds_' + planKey).hide();
            AJS.$('#manualBuild_' + planKey).hide();
        } else {
            AJS.$('#resumeBuild_' + planKey).hide();
            if (plan.allowStop) {            
                AJS.$('#manualBuild_' + planKey).hide();
                if (plan.numberOfCurrentlyBuildingPlans > 1) {
                    AJS.$('#stopSingleBuild_' + planKey).hide();
                    AJS.$('#stopMultipleBuilds_' + planKey).show();
                } else {
                    AJS.$('#stopSingleBuild_' + planKey).show();
                    AJS.$('#stopMultipleBuilds_' + planKey).hide();
                }
            } else {
                AJS.$('#stopSingleBuild_' + planKey).hide();
                AJS.$('#stopMultipleBuilds_' + planKey).hide();
                AJS.$('#manualBuild_' + planKey).show();
            }
        }
    }
    catch(ex)
    {
        //alert(ex);
        console.warn(ex);
    }
}

function updatePlans(sinceSystemTime)
{
        // Make the call to the server for JSON data
    if (!sinceSystemTime) sinceSystemTime = 0;
    // Define the callbacks for the asyncRequest
    var callbacks = {
        dataType: 'json',
        url:BAMBOO.contextPath + "/ajax/viewPlanUpdates.action?sinceSystemTime=" + sinceSystemTime,
        success : function (response) {
            if (!BAMBOO.reloadDashboard) return; // do nudda

            // Process the JSON data returned from the server
            try {
                if (response.plans)
                {
                    var plans = response.plans;
                    var plan;
                    for (var i = 0, len = plans.length; i < len; i++)
                    {
                        plan = plans[i];
                        updatePlan(plan);
                    }
                }
            }
            catch (x) {
                console.warn("JSON Parse failed! " + x + "\n", response);
            }

            var currentTime = 0;
            //var currentTime = holder.currentTime;
            setTimeout(function () { updatePlans(currentTime); }, BAMBOO.reloadDashboardTimeout * 1000);
            hideAjaxErrorMessage();
            AJS.$("body").trigger(BAMBOO_EVENT_ON_DASHBOARD_RELOADED);
        },

        error : function (XMLHttpRequest) {
            showAjaxErrorMessage(XMLHttpRequest);
        },

        timeout : 60000
    };
    AJS.$.ajax(callbacks);
}

function reloadPanel(id, url, reloadEvery, loadScripts, previousText, callback)
{
    AJS.$.get(processReloadUrl(url), function(data)
    {
        var reponseText = data;

        if (!previousText || previousText != reponseText)
        {
            // only update if the previous response is different
            updateDomObject(reponseText, id, loadScripts, callback);
        }
        if (reloadEvery>0) {
            setTimeout(function() {reloadPanel(id, url, reloadEvery, loadScripts, reponseText, callback);}, reloadEvery * 1000);
        }
    });

}

function processReloadUrl(url)
{
    if (BAMBOO.buildLastCurrentStatus)
    {
        var indexOfCurrentStatus = url.indexOf("&lastCurrentStatus");
        if (indexOfCurrentStatus != -1)
        {
            url = url.substring(0, indexOfCurrentStatus);
        }

        return url + "&lastCurrentStatus=" + BAMBOO.buildLastCurrentStatus;

    }
    else
    {
        return url;
    }
}

function updateDomObject(html, targetId, loadScripts, callback)
{
    if(typeof html == 'undefined'){
        html = '';
    }
    if(loadScripts !== true){
        AJS.$("#" + targetId).html(html);
        if (AJS.$.isFunction(callback))
        {
            AJS.$("#" + targetId).each(callback);
        }
        return;
    }
    var id = AJS.$.generateId();
    html += '<span id="' + id + '"></span>';

    AJS.$("#" + id).ready(function(){
        var hd = document.getElementsByTagName("head")[0];
        var re = /(?:<script.*?>)((\n|\r|.)*?)(?:<\/script>)/img;
        var srcRe = /\ssrc=([\'\"])(.*?)\1/i;
        var match;
        while(match = re.exec(html)){
            var srcMatch = match[0].match(srcRe);
            if(srcMatch && srcMatch[2]){
                var s = document.createElement("script");
                s.src = srcMatch[2];
                hd.appendChild(s);
            }else if(match[1] && match[1].length > 0){
                eval(match[1]);
            }
        }
        var el = document.getElementById(id);
        if(el){el.parentNode.removeChild(el);}
    });
    var newHtml = html.replace(/(?:<script.*?>)((\n|\r|.)*?)(?:<\/script>)/img, '');
    AJS.$("#" + targetId).html(newHtml);

    if (AJS.$.isFunction(callback))
    {
        AJS.$("#" + targetId).each(callback);
    }
    return;
}


function updateInlineSection(url, sectionName)
{
     AJS.$.get(processReloadUrl(url), function(data)
      {
          updateDomObject(data, sectionName, "true", "null");
      });
}


function addConfirmationToLinks() {
    AJS.$('.requireConfirmation').click(function(e) {
        return confirm('Please confirm that you are about to \n' + this.title);
    });
}

function selectFirstFieldOfForm(formId) {
    var $form = AJS.$("#" + formId),
        $firstError = $form.find(":input:visible:enabled.errorField:first").focus();
    if (!$firstError.length) {
        $form.find(":input:visible:enabled:first").focus();
    }
}

function reloadIfNoFormChanged()
{
    var forms = document.forms;
    for (var i = 0; i < forms.length; i++)
    {
        var form = forms[i];
        if (checkFormChanged(form))
        {
            return;
        }
    }
    window.location.reload();
}

/**
 * Build queue related stuff
 */
var buildQueue = function()
{
    AJS.$(document).ready(function() {buildQueue.portletReloadCallback();});

    return {
        /**
         * Shows and hides Build Queue's action panels
         */
        displayActions : function(actionsId)
        {
            var prevActionsId = readFromConglomerateCookie(BAMBOO_DASH_DISPLAY_TOGGLES, "buildQueueActions", actionsId);
            AJS.$("#builders").removeClass(prevActionsId);
            AJS.$("#builders").addClass(actionsId);

            saveToConglomerateCookie(BAMBOO_DASH_DISPLAY_TOGGLES, "buildQueueActions", actionsId);
        },

        restoreDisplayActionsFromCookie : function()
        {
            this.displayActions(readFromConglomerateCookie(BAMBOO_DASH_DISPLAY_TOGGLES, "buildQueueActions", "actions-queueControl"));
        },

        portletReloadCallback : function()
        {
            buildQueue.restoreDisplayActionsFromCookie();
        }
    };
}();


function initCommitsTooltip(targetId, planKey, buildNumber)
{
    AJS.InlineDialog(AJS.$("#" + targetId),
                 targetId,
                 BAMBOO.contextPath + "/build/ajax/viewBuildCommits.action?buildKey=" + planKey + "&buildNumber=" + buildNumber,
                {onHover: true, fadeTime: 50, hideDelay: 0, showDelay: 100, width: 300, offsetX: 0,offsetY: 10});
}

function initCommentTooltip(targetId, planKey, buildNumber)
{
    var link = AJS.$("#" + targetId);
    AJS.InlineDialog(link,
             targetId,
             BAMBOO.contextPath + "/build/ajax/viewBuildComments.action?buildKey=" + planKey + "&buildNumber=" + buildNumber,
            {onHover: true, fadeTime: 50, hideDelay: 0, showDelay: 100, width: 300, offsetX: 0,offsetY: 10});
}

/**
 * This function is not mentioned to be used directly but rather via @dj.simpleDialogForm FTL macro defined in dojo.ftl
 *
 * All the input params are also described in the dojo.ftl
 */
function simpleDialogForm(triggerSelector, getDialogBodyUrl, dialogWidth, dialogHeight, submitLabel, submitMode, submitCallback, cancelCallback, header, eventNamespace)
{
    function clearAllErrors(formJQ)
    {
        formJQ.find('.error,.aui-message').remove();
    }

    function addActionError(formJQ, errors)
    {
        formJQ.find(".field-group:first").before(BAMBOO.buildAUIErrorMessage(errors));
    }

    function applyErrors(formJQ, result)
    {
        if (result.fieldErrors) {
            for (var fieldName in result.fieldErrors) {
                BAMBOO.addFieldErrors(formJQ, fieldName, result.fieldErrors[fieldName]);
            }
        }

        if (result.errors) {
            addActionError(formJQ, result.errors);
        }
    }

    /**
     * This is called where callee requests non-ajax submit.
     * 1st phase is to call validation via AJAX using form's action attribute and then submit form in a classical way.
     *
     * @param formJQ  form to be submitted
     */
    function validateSubmitForm(formJQ)
    {
        clearAllErrors(formJQ);

        function validationCallback(result)
        {
            if (result.status.toUpperCase() == "OK")
            {
                formJQ.submit();
            }
            else
            {
               applyErrors(formJQ, result);
            }
        }

        AJS.$.post(formJQ.attr("action"), formJQ.serialize() + '&bamboo.enableJSONValidation=true', validationCallback, "json");
    }

    /**
     * For Ajax submit there's no separate validation phase.
     * Assumption is made that action will validate itself and will return proper JSON response in case of validation errors.
     *
     * @param formJQ          jQuery wrapper for form
     * @param submitCallback
     */
    function ajaxSubmitForm(formJQ, submitCallback)
    {
        clearAllErrors(formJQ);

        function successCallback(result)
        {
            if (result.status.toUpperCase()  == "OK")
            {
                submitCallback(result);
            }
            else
            {
               applyErrors(formJQ, result);
            }
        }

         function errorCallback(result)
        {
            if (result.status == 500)
            {
                addActionError(formJQ, Array("An internal server error has occurred. Please check the logs for more details."));
            }
            else
            {
                addActionError(formJQ, Array("An unknown error has occurred."));
            }
        }

        AJS.$.ajax({
            type: "POST",
            url: formJQ.attr("action"),
            data: formJQ.serialize(),
            success: successCallback,
            error: errorCallback,
            dataType: "json"
        });
    }

    function showDialog(linkElementJQ) {
        var onSubmitCallback = function(dialog) {
            var formJQ = AJS.$("#simpleDialogForm form");

            if (submitMode == "ajax") {
                ajaxSubmitForm(formJQ, function(result) {
                    if (AJS.$.isFunction(submitCallback)) {
                        submitCallback(result);
                    }
                    dialog.remove();
                });
            } else {
                validateSubmitForm(formJQ);
            }
        };

        var onCancelCallback = function(dialog) {
            if (AJS.$.isFunction(cancelCallback))
            {
                cancelCallback();
            }
            dialog.remove();
        };
        
        var $dialogForm = AJS.$("<div id='simpleDialogForm'/>"),
            $popup = new AJS.BambooDialog({width: dialogWidth, height: dialogHeight}, onSubmitCallback, onCancelCallback);


        $popup.addHeader(header != null ? header : linkElementJQ.attr('title'))
              .addPanel("I am invisible", $dialogForm)
              .addCancel("Cancel", onCancelCallback);

        AJS.$.get(getDialogBodyUrl, function(data) {
            $dialogForm.html(data);
            $popup.addSubmit(submitLabel, onSubmitCallback);
            $popup.getPage(0).button[1].moveLeft();
            $popup.show();
        });
    }

    if (triggerSelector) {
        var namespace = "click";
        if (eventNamespace && eventNamespace.length) {
            namespace += "." + eventNamespace;
        }

        AJS.$(triggerSelector).bind(namespace, function() {
            showDialog(AJS.$(this));
        });
    } else {
        showDialog(AJS.$(this));
    }

}

/**
 * Asynchronous form handler
 * @param options
 *  - target        String - selector targeting the form
 *  - success       Function - handles JSON response from successful form submission
 *  - cancel        Function - handles what to do when the cancel link is clicked
 *  - formReplaced  Function - is fired after the form is replaced
 *  - $delegator    jQuery Object - where the event handler should be bound
 */
BAMBOO.asyncForm = function (options) {
    var defaults = {
        target: null,
        success: null,
        cancel: null,
        formReplaced: null,
        $delegator: AJS.$(document)
    },
    handleSubmit = function (e) {
        e.preventDefault();
        var $form = AJS.$(this);
        $form.find(".buttons").prepend('<span class="icon icon-loading"/>');
        AJS.$.post($form.attr("action"), $form.serialize() + "&bamboo.jsMode=true&decorator=rest&confirm=true", function (data) {
            if (typeof data == "object") {
                // Returned data is JSON
                options.success(data);
            } else {
                // Returned data isn't JSON, assume it's HTML
                var $data = AJS.$(data);
                $form.replaceWith($data);
                if (AJS.$.isFunction(options.formReplaced)) {
                    options.formReplaced($data);
                }
            }
        });
    },
    handleCancel = function (e) {
        e.preventDefault();
        options.cancel(e);
    };
    options = AJS.$.extend(defaults, options);

    if (AJS.$.isFunction(options.success)) { // No point in an async form if there's no success callback to handle a successful post
        options.$delegator.undelegate(options.target, "submit").delegate(options.target, "submit", handleSubmit);
    }

    if (AJS.$.isFunction(options.cancel)) {
        options.$delegator.undelegate(options.target + " .cancel", "click").delegate(options.target + " .cancel", "click", handleCancel);
    }
};

/**
 * Handles form input in dialogs
 * @param options
 *  - trigger       String - selector targeting the element that triggers the popup
 *  - dialogWidth   Number - dialog width
 *  - dialogHeight  Number - dialog height
 *  - success       Function - handles JSON response from successful form submission
 *  - cancel        Function - handles what to do when the cancel link is clicked
 *  - header        String - header for the dialog
 */
BAMBOO.simpleDialogForm = function (options) {
    var defaults = {
        trigger: null,
        dialogWidth: null,
        dialogHeight: null,
        success: null,
        cancel: null,
        header: null
    };
    options = AJS.$.extend(defaults, options);
    var $trigger,
        $formContainer = AJS.$('<div class="aui-dialog-content"/>'),
        dialog,
        setFocus = function () {
            var $firstError = $formContainer.find(":input:visible:enabled.errorField:first").focus();
            if (!$firstError.length) {
                $formContainer.find(":input:visible:enabled:first").focus();
            }
        },
        setupDialogContent = function (html) {
            $formContainer.html(html);
            setFocus();
            BAMBOO.asyncForm({
                $delegator: $formContainer,
                target: "form",
                success: function (data) {
                    if (AJS.$.isFunction(options.success)) {
                        options.success(data);
                    }
                    dialog.remove();
                },
                cancel: function (e) {
                    e.preventDefault();
                    if (AJS.$.isFunction(options.cancel)) {
                        options.cancel(e);
                    }
                    dialog.remove();
                },
                formReplaced: setFocus
            });
        },
        showDialog = function () {
            dialog = new AJS.Dialog({
                width: options.dialogWidth,
                height: options.dialogHeight,
                keypressListener: function (e) {
                    if (e.which == VK_ESCAPE) {
                        dialog.remove();
                    }
                }
            });
            var header = options.header ? options.header : $trigger.attr("title");
            if (header) {
                dialog.addHeader(header);
            }
            dialog.addPanel("", $formContainer);

            // $trigger.attr("data-dialog-href") won't be needed once we're on jQuery 1.4.3
            AJS.$.ajax({
                url: $trigger.attr("href") || $trigger.data("dialog-href") ||  $trigger.attr("data-dialog-href"),
                success: setupDialogContent,
                cache: false
            });

            dialog.show();
        };

    if (options.trigger) {
        var namespace = "click";
        if (options.eventNamespace && options.eventNamespace.length) {
            namespace += "." + options.eventNamespace;
        }

        AJS.$(document).delegate(options.trigger, namespace, function (e) {
            $trigger = AJS.$(this);
            e.preventDefault();
            showDialog();
        });
    } else {
        showDialog();
    }
};

/**
 * Displays confirmation dialog that is consistent in style with simpleDialogForm but with content
 * generated without additional server request.
 */
function simpleConfirmationDialog(dialogWidth, dialogHeight, content, header, submitLabel, cancelLabel, onSubmit, onCancel) {
    var confirmDialog = new AJS.BambooDialog({width: dialogWidth, height: dialogHeight}),
            doSubmit = function(dialog)
            {
                if (AJS.$.isFunction(onSubmit)) {
                    onSubmit();
                }
                dialog.remove();
            },
            doCancel = function(dialog)
            {
                if (AJS.$.isFunction(onCancel))
                {
                    onCancel();
                }
                dialog.remove();
            };
    confirmDialog.addHeader(header);

    // @TODO a workaround to some bug... We should revisit this post AUI 2.0 upgrade
    confirmDialog.addPanel("nothing", "nothing");
    confirmDialog.addButton(submitLabel, doSubmit);
    confirmDialog.addCancel(cancelLabel, doCancel);

    confirmDialog.getCurrentPanel().html("<div id='simpleDialogForm'>" + content + "</div>");
    confirmDialog.show();
}

/**
 * General checkbox tree utilities.
 */
var checkboxTree = function()
{
    return {
        DONT_ENABLE_PARENT_ON_ALL_CHILDREN_ENABLED : 1 << 0,
        DISABLE_CHILDREN_ON_PARENT_CHECKED : 1 << 1,
        /**
         * Cascade state of a parent checkbox to collection of children checkboxes.
         * @param jqParent    parent checkbox (jQuery object)
         * @param jqChildren  children checkboxes (jQuery object)
         */
        cascadeToChildren : function(jqParent, jqChildren, options)
        {            
            jqChildren.attr("checked", jqParent.attr("checked"));
            if (options & this.DISABLE_CHILDREN_ON_PARENT_CHECKED)
            {
                jqChildren.attr("disabled", jqParent.attr("checked"));
            }
        },

        /**
         * Propagate state of children checkboxes to parent checkbox.
         * @param jqParent    parent checkbox (jQuery object)
         * @param jqChildren  children checkboxes (jQuery object)
         * @param options     options that modify default behavior
         */
        propagateToParent : function(jqParent, jqChildren, options)
        {
            if (jqChildren.is(":not(:checked)"))
            {
                jqParent.removeAttr("checked");
            }
            else
            {
                if (!(options & this.DONT_ENABLE_PARENT_ON_ALL_CHILDREN_ENABLED))
                {
                    jqParent.attr("checked", "checked");
                }
            }
        }
    };
}();

function enableShowSnapshotsForMaven2Dependencies(showAllSelector, showOnlySnapshotsSelector, tableSelector, hasSnapshots)
{
    AJS.$(document).ready(function() {
        var showAllLink = AJS.$(showAllSelector);
        var showOnlySnapshotsLink = AJS.$(showOnlySnapshotsSelector);
        var table = AJS.$(tableSelector);

        showAllLink.click(function() {
            showOnlySnapshotsLink.show();
            showAllLink.hide();
            AJS.$('.gav-tbody-releases').show();
        });

        showOnlySnapshotsLink.click(function() {
            showAllLink.show();
            showOnlySnapshotsLink.hide();
            AJS.$('.gav-tbody-releases').hide();
        });

        if (hasSnapshots) {
            showOnlySnapshotsLink.click();
        } else {
            showAllLink.hide();
            showOnlySnapshotsLink.hide();
        }
    });
}

function removeError(errorNumber)
{
    var removeErrorForm = window.opener.AJS.$('#removeErrorHiddenForm_' + errorNumber);
    removeErrorForm.submit();
    window.close();
}

function addAliasSubmitCallback(result)
{
    AJS.$("select.selectAlias")
            .append(AJS.$(document.createElement("option")).attr("value", result.aliasId).attr("selected", "selected").text(result.aliasName))
            .val(result.aliasId);
}

/*per plan action tooltip, originally for requirements tooltip on plan config page
 * @param args - some are compulsory for hitting the action to display content, the rest are for styling
 * targetId: (compulsory) the id of the content that the tooltip should appear over
 * actionName: (compulsory) the action to hit
 * planKey: (compulsory) the key of the plan
 * fadeTime: (optional)
 * hideDelay: (optional)
 * showDelay: (optional)
 * width: (optional)
 * offsetX: (optional)
 * offsetY: (optional)
 */
function attachActionToTooltip(args)
{
    AJS.InlineDialog(AJS.$("#" + args.targetId),
                 args.targetId,
                 BAMBOO.contextPath + "/ajax/" + args.actionName + ".action?planKey=" + args.planKey,
                {onHover: true,
                 fadeTime: (args.fadeTime || 200),
                 hideDelay: (args.hideDelay || 150),
                 showDelay: (args.showDelay || 150),
                 width: (args.width || 300),
                 offsetX: (args.offsetX || 0),
                 offSetY: (args.offsetY || 10)
                });
}

/**
 * Checks if any forms on the page need a submit on change hook.
 */
addUniversalOnload(function(){
    AJS.$(".submitOnChange").change(function(){ AJS.$(this).closest("form").submit(); });
});

/**
 * Current Activity screen
 */
var CurrentActivity = {
    // Default options
    options: {
        contextPath: null,
        getBuildsUrl: null,
        viewAgentUrl: null,
        reorderBuildUrl: null,
        stopBuildUrl: null,
        manageElasticInstancesUrl: null,
        emptyQueueText: null,
        emptyBuildingText: null,
        cancellingBuildText: null,
        cancelBuildText: null,
        queueOutOfDateText: null,
        canBuildElastically: null,
        canBuildElasticallyAdmin: null,
        fetchingBuildData: null,
        hasAdminPermission: false,
        caParent: null,
        buildingParent: null,
        queueParent: null,
        activityStream: null,
        agentSummary: null
    },
    updateTimeout: null, // ID of timeout which determines when the data will be next fetched from the server
    building: null, // jQuery object referring to the list holding the currently building builds (set on init)
    queue: null, // jQuery object referring to the list holding the queued builds (set on init)
    noBuilding: null, // jQuery object referring to the message shown when there are no currently building builds (set on init)
    noQueued: null, // jQuery object referring to the message shown when there are no queued builds (set on init)
    loadingBuilding: null, // jQuery object referring to the loading indicator shown while currently building data is being fetched the first time (set on init)
    loadingQueued: null, // jQuery object referring to the loading indicator shown while queue data is being fetched the first time (set on init)
    queueOutOfDate: null, // jQuery object referring to the message shown when the queue order has been updated remotely and is not reflected locally (set on init)
    updateTimestamp: null, // Timestamp (represented as milliseconds since the Unix epoch) that the builds were last updated
    isBeingSorted: false, // Is the queue currently being sorted?
    disabledStopHTML: '', // HTML to replace the stop button with if it's disabled (set on init)
    /**
     * Generates a nice, readable string of Agents that the Plan can build on
     * @param executableAgents - Array of Agent objects
     * @returns {String} A readable sentence containing the list of agents
     */
    generateBuildableAgentsText: function (executableAgents) {
        var agentNames = [];
        for (var i = 0; i < executableAgents.length; i++) {
            agentNames.push(executableAgents[i].name);
        }
        return "Can build on " + agentNames.join(", ");
    },
    /**
     * Generates the list item
     * @param build - Build object
     * @returns {Object} containing the list item or false if no list item is built (would require build.status to be something other than BUILDING or QUEUED)
     */
    generateListItem: function (build) {
        var ca = CurrentActivity,
            o = ca.options,
            el = "";
        if (build.hasReadPermission) {
            var buildLink = '<a href="' + o.contextPath + '/browse/' + build.planResultKey + '/">' + build.projectName + ' &rsaquo; ' + build.chainName + ' &rsaquo; #' + build.buildNumber + '</a> &rsaquo; <a href="' + o.contextPath + '/browse/' + build.buildResultKey + '/">' + build.jobName + '</a>';

            if (build.status == "BUILDING") {
                var msgHtml = build.messageType == "PROGRESS" ? '<div class="progress-bar" style="width:' + build.percentageComplete + '%;"></div><div class="progress-text">' + build.messageText + '</div>' : build.messageText;
                var buildAgentInfo = build.agent ? ' building on <a href="' + o.viewAgentUrl + '?agentId=' + build.agent.id + '" class="' + build.agent.type.toLowerCase() + '">' + build.agent.name + '</a>' : '';
                el = '<li id="b' + build.buildResultKey + '" class="buildRow"><div class="buildInfo">' + buildLink + buildAgentInfo + '</div><div class="message ' + build.messageType.toLowerCase() + '">' + msgHtml + '</div>'; //Current Activity
                if (build.hasBuildPermission) {
                    var stopButtonHTML = (build.isBeingStopped) ? ca.disabledStopHTML : '<a href="' + o.stopBuildUrl + '?planResultKey=' + build.buildResultKey + '" title="' + o.cancelBuildText + '" class="build-stop">' + o.cancelBuildText + '</a>';
                    el += '<ul class="buildActions"><li>' + stopButtonHTML + '</li></ul>';
                }
                el += '</li>';
            } else if (build.status == "QUEUED") {
                var title = build.executableAgents ? ' title="' + ca.generateBuildableAgentsText(build.executableAgents) + '"' : '',
                    handle = o.hasAdminPermission ? '<span class="handle"></span>' : '';
                el = '<li id="b' + build.buildResultKey + '" class="buildRow"><div class="buildInfo">' + handle + buildLink + '</div><div class="message ' + build.messageType.toLowerCase() + '"' + title + '>' + build.messageText + '</div>';  //Current Activity
                if (build.executableElasticImages || build.hasBuildPermission) {
                    el += '<ul class="buildActions">';
                    if (build.executableElasticImages) {
                        if (o.hasAdminPermission) {
                            el += '<li><a href="' + o.manageElasticInstancesUrl + '" title="' + o.canBuildElasticallyAdmin + '" class="build-elastic">' + o.canBuildElasticallyAdmin + '</a></li>';
                        } else {
                            el += '<li><span title="' + o.canBuildElastically + '" class="build-elastic-disabled">' + o.canBuildElastically + '</span></li>';
                        }
                    }
                    if (build.hasBuildPermission) {
                        el += '<li><a href="' + o.stopBuildUrl + '?planResultKey=' + build.buildResultKey + '" title="' + o.cancelBuildText + '" class="build-stop">' + o.cancelBuildText + '</a></li>'
                    }
                    el += '</ul>';
                }
                el += '</li>';
            }
        } else {
            el = '<li id="b' + build.buildResultKey + '" class="buildRow"><div class="buildInfo">' + build.planName + '</div><span class="message ' + build.messageType.toLowerCase() + '">' + build.messageText + '</span></li>';
        }
        return (el.length == 0 ? false : AJS.$(el));
    },
    /**
     * Checks if an activity stream is available, and if it is (and there are no activity stream comment forms open -
     * which would indicate the user is probably in the middle of adding a comment) then trigger a refresh.
     */
    updateActivityStream: function () {
        var o = CurrentActivity.options;
        if (o.activityStream && AJS.$(".activity-item-comment-form:visible", document.getElementById("feedContainer-" + o.activityStream.feedId)).length == 0) {
            o.activityStream.populateFeed();
        }
    },
    /**
     * Checks the time the build was last updated with the time the last data was retrieved.
     * Removes the build if it's older than the last update.
     * @param li - List item containing the build
     * @returns {Boolean} indicating whether the build was removed or not
     */
    checkLastUpdated: function (li) {
        var b = AJS.$(li);
        if (b.data("lastUpdated") < CurrentActivity.updateTimestamp) {
            b.remove();
            return true;
        } else {
            return false;
        }
    },
    /**
     * Checks if build lists are empty and if so, hide the list and display a message, otherwise show the list and hide the message.
     */
    checkListsHaveBuilds: function () {
        var ca = CurrentActivity;
        if (ca.building.children().length == 0) {
            ca.building.hide();
            ca.noBuilding.show();
        } else {
            ca.building.show();
            ca.noBuilding.hide();
        }
        if (ca.queue.children().length == 0) {
            ca.queue.hide();
            ca.noQueued.show();
            // If queue is empty but "queue is out-of-date" message is being displayed then hide the message and re-enable sorting
            if (ca.queueOutOfDate.is(":visible")) {
                ca.queue.sortable("enable");
                ca.queueOutOfDate.hide();
            }
        } else {
            ca.queue.show();
            ca.noQueued.hide();
        }
    },
    /**
     * Retrieves the build JSON from the server and adds/removes/changes builds in the currently building and queue as needed.
     * @param callback - Allows the ability to execute a callback once the update has completed
     */
    updateBuilds: function (callback) {
        var ca = CurrentActivity,
            o = ca.options;
        ca.updateTimestamp = (new Date()).getTime();
        // Get builds from API
        AJS.$.ajax({
            url: o.getBuildsUrl,
            dataType: 'json',
            cache: false,
            success: function (json) {
                // If a callback was supplied to updateBuilds, fire it
                if (callback && AJS.$.isFunction(callback)) {
                    callback.call();
                }
                // Update agent summary text if available
                if (o.agentSummary) {
                    o.agentSummary.text(json.agentSummary);
                }
                // Go through each build returned and either update or insert as required
                AJS.$.each(json.builds, function () {
                    var build = AJS.$("#b" + this.buildResultKey);
                    if (build.length > 0) { // Check if the build already exists in building/queue
                        var msg;
                        if (this.status == "BUILDING") {
                            // Check if build has started, if so move to building
                            if (build.closest(".buildContainer")[0] == o.queueParent[0]) {
                                build.remove();
                                build = ca.generateListItem(this).appendTo(ca.building);
                                var progress = AJS.$(".progress", build[0]);
                                if (progress.length > 0) {
                                    progress.progressBar();
                                }
                            } else {
                                msg = AJS.$(".message", build[0]);
                                var messageType = this.messageType.toLowerCase();

                                if (messageType == "progress" && msg.hasClass(messageType)) {
                                    msg.progressBar("option", { value: this.percentageComplete, text: this.messageText });
                                } else if (messageType == "progress") {
                                    msg.attr("class", "message").progressBar({ value: this.percentageComplete, text: this.messageText });
                                } else {
                                    if (msg.hasClass("progress")) {
                                        msg.progressBar("destroy");
                                    }
                                    if (!msg.hasClass(messageType)) {
                                        msg.attr("class", "message " + messageType).text(this.messageText);
                                    } else {
                                        msg.text(this.messageText);
                                    }
                                }
                                if (this.hasBuildPermission && this.isBeingStopped) {
                                    var stopButton = AJS.$(".build-stop", build[0]);
                                    if (stopButton.length > 0) {
                                        stopButton.replaceWith(ca.disabledStopHTML);
                                    }
                                }
                            }
                        } else if (this.status == "QUEUED") {
                            msg = AJS.$(".message", build[0]).text(this.messageText).attr("title", (this.executableAgents ? ca.generateBuildableAgentsText(this.executableAgents) : null));
                            if (!msg.hasClass(this.messageType.toLowerCase())) {
                                msg.attr("class", "message " + this.messageType.toLowerCase());
                            }
                        }
                    } else {
                        if (this.status == "BUILDING") {
                            build = ca.generateListItem(this).appendTo(ca.building);
                            var progress = AJS.$(".progress", build[0]);
                            if (progress.length > 0) {
                                progress.progressBar();
                            }
                        } else if (this.status == "QUEUED") {
                            build = ca.generateListItem(this).appendTo(ca.queue);
                        }
                    }
                    // Check if queue order is correct and reorder if required
                    if (!ca.isBeingSorted && typeof(this.queueIndex) != "undefined" && this.queueIndex != build.prevAll().length) {
                        build.insertBefore(ca.queue.children("li:eq(" + this.queueIndex + ")"));
                    }
                    build.data("lastUpdated", ca.updateTimestamp);
                });

                // Clean up builds not returned in JSON
                var numRemoved = 0;
                ca.building.children().each(function () {
                    if (ca.checkLastUpdated(this)) { numRemoved++; }
                });
                ca.queue.children().each(function () {
                    if (ca.checkLastUpdated(this)) { numRemoved++; }
                });
                if (numRemoved > 0) { ca.updateActivityStream(); }

                if (o.hasAdminPermission) {
                    // Refresh sorting
                    ca.queue.sortable("refresh");
                }

                ca.checkListsHaveBuilds();

                // Update again in 5 seconds
                ca.updateTimeout = setTimeout(ca.updateBuilds, 5000);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                // Error occurred when doing the update, try again in 30 sec, making sure the callback is passed so that it will actually get executed when it finally succeeds
                ca.updateTimeout = setTimeout(function () { ca.updateBuilds(callback); }, 30000);
            }
        });
    },
    /**
     * Strips a build list item's id down to a build result key
     * @param buildListItemID - String containing the build list item's id - eg. bBAM-FUNC-1234
     * @returns {String} containing the build result key - eg. BAM-FUNC-1234
     */
    buildListItemIDToBuildResultKey: function (buildListItemID) {
        return buildListItemID.substr(1);
    },
    /**
     * Initialisation for the Current Activity
     * @param options - Object containing the options to overwrite our defaults
     */
    init: function (options) {
        var ca = CurrentActivity,
            o = ca.options;
        AJS.$.extend(o, options);
        ca.building = AJS.$("<ul/>").appendTo(o.buildingParent).hide();
        ca.queue = AJS.$("<ul/>").appendTo(o.queueParent).hide();
        ca.noBuilding = AJS.$("<p>" + o.emptyBuildingText + "</p>").appendTo(o.buildingParent).hide();
        ca.noQueued = AJS.$("<p>" + o.emptyQueueText + "</p>").appendTo(o.queueParent).hide();
        ca.queueOutOfDate = AJS.$("<p>" + o.queueOutOfDateText + "</p>").insertBefore(ca.queue).hide();
        ca.loadingBuilding = AJS.$('<p class="loading">' + o.fetchingBuildData + '</p>').appendTo(o.buildingParent);
        ca.loadingQueued = AJS.$('<p class="loading">' + o.fetchingBuildData + '</p>').appendTo(o.queueParent);
        ca.disabledStopHTML = '<span class="build-stop-disabled" title="' + o.cancellingBuildText + '">' + o.cancellingBuildText + '</span>';
        AJS.$(".buildActions a.build-stop").live("click", function (e) {
            var el = AJS.$(this),
                li = el.closest(".buildRow");
            AJS.$.post(this.href, function () {
                // Only remove from the queue immediately - currently building builds may take a while to stop and clean up - let the next updateBuilds() that runs clean it up
                if (li.closest(".buildContainer")[0] == o.queueParent[0]) {
                    li.remove();
                }
                ca.checkListsHaveBuilds();
            });
            el.replaceWith(ca.disabledStopHTML);
            e.preventDefault();
        });
        AJS.$("a", ca.queueOutOfDate[0]).click(function (e) {
            clearTimeout(ca.updateTimeout);
            ca.queue.empty().sortable("enable");
            AJS.$(this).parent().hide();
            ca.updateBuilds();
            ca.updateActivityStream();
            e.preventDefault();
        });
        if (o.hasAdminPermission) {
            ca.queue.sortable({
                handle: "span.handle",
                update: function (event, ui) {
                    var self = AJS.$(ui.item),
                        buildResultKey = ca.buildListItemIDToBuildResultKey(self.attr("id")),
                        checkListItemExists = function ($el) {
                            if ($el.length > 0) {
                                return ca.buildListItemIDToBuildResultKey($el.attr("id"));
                            } else {
                                return "";
                            }
                        },
                        prevBuildResultKey = checkListItemExists(self.prev()),
                        nextBuildResultKey = checkListItemExists(self.next());
                    AJS.$.post(o.reorderBuildUrl,
                        { buildResultKey: buildResultKey, prevBuildResultKey: prevBuildResultKey, nextBuildResultKey: nextBuildResultKey },
                        function (json) {
                            // If an error is returned show the queue out of date message. The next update will restore the correct queue order.
                            if (json.status == "ERROR") {
                                ca.queueOutOfDate.show();
                                ca.queue.sortable("disable");
                            }
                        }, "json");
                },
                start: function (event, ui) {
                    ca.isBeingSorted = true;
                },
                stop: function (event, ui) {
                    ca.isBeingSorted = false;
                }
            });
        }
        ca.updateBuilds(function () {
            ca.loadingBuilding.hide();
            ca.loadingQueued.hide();
        });
    }
};

/**
 * Agent Manager dropdown
 */
var AgentManager = {
    // Default options
    options: {
        contextPath: null,
        getAgentsUrl: null,
        enableAgentUrl: null,
        disableAgentUrl: null,
        enableAllAgentsUrl: null,
        disableAllAgentsUrl: null,
        viewAgentUrl: null,
        enableAgentText: null,
        disableAgentText: null,
        enableAllAgentsText: null,
        disableAllAgentsText: null,
        onlineAgentsText: null,
        defaultRemoteAgentSummaryText: null,
        onlineOnly: false,
        includeRemoteAgentSummary: false,
        $trigger: null
    },
    $agentList: null, // jQuery object referring to the list holding the agents
    $dialog: null, // jQuery object referring to the AUI Inline Dialog
    $remoteAgentSummary: null, // jQuery object referring to the paragraph containing the remote agent summary text
    /**
     * Generates the list item
     * @param agent - Agent object
     * @returns {Object} containing the list item or false if no list item is built
     */
    generateListItem: function (agent) {
        var am = AgentManager,
            o = am.options,
            el = "";
        el = '<li class="' + agent.type.toLowerCase() + ' ' + (agent.enabled ? "enabled" : "disabled") + '"><h3><a href="' + o.viewAgentUrl + '?agentId=' + agent.id + '">' + agent.name + '</a></h3><span>' + (agent.agentStatus == "Building" ? agent.agentStatus + ' - <a href="' + o.contextPath + agent.buildLogUrl + '">' + agent.buildResultKey + '</a>' : agent.agentStatus) + '</span> <button class="' + (agent.enabled ? "disable" : "enable") + '">' + (agent.enabled ? o.disableAgentText : o.enableAgentText) + '</button></li>';
        return (el.length == 0 ? false : AJS.$(el).data("agentId", agent.id));
    },
    /**
     * Updates the list of agents
     * @param $contents - jQuery element of the Inline Dialog's contents
     * @param $trigger - jQuery element that is triggering the popup
     * @param doShowPopup - function to display the popup
     */
    updateAgents: function ($contents, $trigger, doShowPopup) {
        var am = AgentManager,
            o = am.options;
        AJS.$.ajax({
            url: o.getAgentsUrl,
            data: { onlineOnly: o.onlineOnly, includeRemoteAgentSummary: o.includeRemoteAgentSummary },
            dataType: 'json',
            cache: false,
            success: function (json) {
                if (o.includeRemoteAgentSummary && json.remoteAgentSummary) {
                    am.$remoteAgentSummary.html(json.remoteAgentSummary);
                } else if (o.includeRemoteAgentSummary) {
                    am.$remoteAgentSummary.html(o.defaultRemoteAgentSummaryText);
                }
                am.$agentList.empty();
                AJS.$.each(json.agents, function () {
                    am.$agentList.append(am.generateListItem(this));
                });
                if (doShowPopup) {
                    doShowPopup();
                }
            }
        });
    },
    /**
     * Initialisation for the Agent Manager
     * @param options - Object containing the options to overwrite our defaults
     */
    init: function (options) {
        var am = AgentManager,
            o = am.options;
        AJS.$.extend(o, options);
        am.$dialog = AJS.InlineDialog(o.$trigger, o.$trigger.attr("id"), am.updateAgents, {
            onHover: true,
            width: 400,
            offsetX: 0,
            offsetY: 3,
            cacheContent: false
        });
        var $contents = am.$dialog.find(".contents").addClass("agentManager");
        am.$agentList = AJS.$('<ul />').appendTo($contents).before('<h2>' + o.onlineAgentsText + '</h2>');
        if (o.includeRemoteAgentSummary) {
            am.$remoteAgentSummary = AJS.$('<p>' + o.defaultRemoteAgentSummaryText + '</p>').insertBefore(am.$agentList);
        }
        var $buttons = AJS.$('<div class="buttons"></div>').appendTo($contents);
        AJS.$('<button>' + o.enableAllAgentsText + '</button>').appendTo($buttons).click(function () {
            var el = AJS.$(this);
            el.attr("disabled", "disabled");
            AJS.$.post(o.enableAllAgentsUrl, function () {
                el.removeAttr("disabled");
                am.updateAgents();
            });
        });
        AJS.$('<button>' + o.disableAllAgentsText + '</button>').appendTo($buttons).click(function () {
            var el = AJS.$(this);
            el.attr("disabled", "disabled");
            AJS.$.post(o.disableAllAgentsUrl, function () {
                el.removeAttr("disabled");
                am.updateAgents();
            });
        });
        // FF not firing buttons on click for some reason, mouseup is okay though?!!
        var dialogId = am.$dialog.attr("id");
        AJS.$("#" + dialogId + " button.enable").live("mouseup", function () {
            var el = AJS.$(this),
                li = el.closest("li");
            var agentId = li.data("agentId");
            el.attr("disabled", "disabled");
            AJS.$.post(o.enableAgentUrl, { agentId: agentId }, function () {
                el.text(o.disableAgentText).attr("class", "disable").removeAttr("disabled").parent().removeClass("disabled");
            });
        });
        AJS.$("#" + dialogId + " button.disable").live("mouseup", function () {
            var el = AJS.$(this),
                li = el.closest("li");
            var agentId = li.data("agentId");
            el.attr("disabled", "disabled");
            AJS.$.post(o.disableAgentUrl, { agentId: agentId }, function () {
                el.text(o.enableAgentText).attr("class", "enable").removeAttr("disabled").parent().addClass("disabled");
            });
        });
    }
};

var SelectionActions = function() {
    return {
        init: function (formId) {
            registerSelectionActions();

            function registerSelectionActions() {
                AJS.$("span[selector='"+formId+"_all']").click( function() {
                    clearSelectionStatus();

                    getSelectAllWarning().show();
                    getAllPagesSelectedInfo().hide();

                    getAllCheckBoxes("").attr("checked", true);
                });
                AJS.$("span[selector='"+formId+"_none']").click( function() {
                    clearSelectionStatus();
                });
                AJS.$("span[selector='"+formId+"_disabled']").click( function() {
                    clearSelectionStatus();
                    getAllCheckBoxes("[class~='selectorAgentEnabled_false']").attr("checked", true);
                });
                AJS.$("span[selector='"+formId+"_idle']").click( function() {
                    clearSelectionStatus();
                    getAllCheckBoxes("[class~='selectorAgentStatus_Idle']").attr("checked", true);
                });
                AJS.$("span[selector='"+formId+"_allPages']").click( function() {
                    setCompleteContentSelected(true);
                    getSelectAllWarning().hide();
                    getAllPagesSelectedInfo().show();
                });
            }

            function getAllCheckBoxes(selector) {
                return AJS.$("input:checkbox.selectorAgentType_"+formId+"[name='selectedAgents']"+selector);
            }

            function setCompleteContentSelected(newValue) {
                AJS.$('.'+formId+'_completeContentSelected').val(newValue);
            }

            function clearSelectionStatus() {
                AJS.$('.'+formId+'_paginatedWarning').hide();
                getAllCheckBoxes("").attr("checked", false);
                setCompleteContentSelected(false);
            }

            function getSelectAllWarning() {
                return AJS.$('.'+formId+'_paginatedSelectAllWarning');
            }

            function getAllPagesSelectedInfo() {
                return AJS.$('.'+formId+'_paginatedAllPagesSelected');
            }
        }
    };
}();

var BulkSelectionActions = function() {
    return {
        init: function (formId) {
            registerSelectionActions();

            function registerSelectionActions() {
                AJS.$("span[selector='bulk_selector_all']").click( function() {
                    clearSelectionStatus();
                    getAllCheckBoxes("").attr("checked", true);
                });
                AJS.$("span[selector='bulk_selector_none']").click( function() {
                    clearSelectionStatus();
                });
                AJS.$("span[selector='bulk_selector_plans']").click( function() {
                    clearSelectionStatus();
                    getAllCheckBoxes("Plan").attr("checked", true);
                });
                AJS.$("span[selector='bulk_selector_jobs']").click( function() {
                    clearSelectionStatus();
                    getAllCheckBoxes("Job").attr("checked", true);
                });
            }

            function getAllCheckBoxes(selector) {
                return AJS.$("input:checkbox.bulk"+selector);
            }

            function setCompleteContentSelected(newValue) {
                AJS.$('.'+formId+'_completeContentSelected').val(newValue);
            }

            function clearSelectionStatus() {
                getAllCheckBoxes("").attr("checked", false);
                setCompleteContentSelected(false);
            }
        }
    };
}();

var BulkSubtreeSelectionActions = function() {
    return {
        init: function (formId, enableProjectCheckbox) {
            registerSelectionActions(enableProjectCheckbox);

            function registerSelectionActions(enableProjectCheckbox) {
                AJS.$("span[selector='bulk_selector_sub_"+formId+"']").click( function() {
                    clearSelectionStatus();
                    getAllCheckBoxes(formId).attr("checked", true);
                });
                AJS.$("span[selector='bulk_selector_sub_none_"+formId+"']").click( function() {
                    clearSelectionStatus();
                });
                AJS.$("span[selector='bulk_selector_sub_plans_"+formId+"']").click( function() {
                    clearSelectionStatus();
                    getAllCheckBoxes("Plan" + formId).attr("checked", true);
                });
                AJS.$("span[selector='bulk_selector_sub_jobs_"+formId+"']").click( function() {
                    clearSelectionStatus();
                    getAllCheckBoxes("Job" + formId).attr("checked", true);
                });

                if (enableProjectCheckbox) {
                    AJS.$("#checkbox_"+formId).change( function() {
                        var val = AJS.$(this).is(":checked");
                        clearSelectionStatus();
                        if (val) {
                            getAllCheckBoxes(formId).attr("checked", true);
                        }
                    });
                }
            }

            function getAllCheckBoxes(selector) {
                return AJS.$("input:checkbox.bulk"+selector);
            }

            function clearSelectionStatus() {
                getAllCheckBoxes(formId).attr("checked", false);
            }
        }
    };
}();

var ConfigurableSelectionActions = function() {
    return {
        init: function (formId) {
            var formIdSelector = formId.replace(/([\.:])/g, "\\$1");
            registerSelectionActions();

            function registerSelectionActions() {
                AJS.$("span[selector='"+formId+"_all']").click( function() {
                    getAllCheckBoxes("").attr("checked", true);
                });
                AJS.$("span[selector='"+formId+"_none']").click( function() {
                    clearSelectionStatus();
                });

                AJS.$("span[selector^='"+formId+"_'][selector!='"+formId+"_none'][selector!='"+formId+"_all']").each(function () {
                    var span = AJS.$(this),
                        selector = span.attr("selector").substring(formId.length + 1);
                    span.click( function() {
                        clearSelectionStatus();
                        getAllCheckBoxes("[class~='selector_"+selector+"_true']").attr("checked", true);
                    });
                });
            }

            function getAllCheckBoxes(selector) {
                return AJS.$("input:checkbox.selectorScope_"+formIdSelector+selector);
            }

            function clearSelectionStatus() {
                getAllCheckBoxes("").attr("checked", false);
            }
        }
    };
}();

/**
 * Live Activity for Plans
 */
var LiveActivity = function ($) {
    var opts = {
        planKey: null,
        container: null,
        getBuildsUrl: null,
        getChangesUrl: null,
        queueEmptyText: null,
        cancellingBuildText: null,
        noAdditionalInfoText: null,
        defaultIssueIconUrl: null,
        defaultIssueType: null,
        slideSpeed: 600,
        templates: {
            buildListItemTemplate: null,
            buildingOnTemplate: null,
            buildMessageTemplate: null,
            jiraIssueTemplate: null,
            codeChangeTemplate: null,
            codeChangeChangesetLinkTemplate: null,
            codeChangeChangesetDisplayTemplate: null,
            currentStageTemplate: null,
            disabledStopButton: AJS.template('<span class="build-stop-disabled" title="{title}">{text}</span>'),
            toggleDetailsButton: AJS.template('<span class="toggle-details"></span>')
        }
    },
    $buildList, // jQuery object referring to the list holding the builds
    $noBuilds, // jQuery object referring to the message that shows when there are no builds
    disabledStopHTML, // HTML fragment that replaces the stop button when a user clicks it (so it can't be clicked multiple times)
    toggleDetailsHTML, // HTML fragment inserted to enable the user to toggle the display of additional information
    /**
     * Checks if build list is empty and if so, hide the list and display a message, otherwise show the list and hide the message.
     */
    checkListHasBuilds = function () {
        if ($buildList.children().length == 0) {
            $buildList.hide();
            $noBuilds.show();
        } else {
            $buildList.show();
            $noBuilds.hide();
        }
    },
    updateTimeout, // ID of timeout which determines when the data will be next fetched from the server
    updateTimestamp, // Timestamp (represented as milliseconds since the Unix epoch) that the builds were last updated
    /**
     * Retrieves the build JSON from the server and adds/removes/changes builds in the build list as needed.
     */
    update = function () {
        updateTimestamp = (new Date()).getTime();
        $.ajax({
            url: opts.getBuildsUrl,
            data: { planKey: opts.planKey },
            dataType: "json",
            cache: false,
            success: function (json) {
                // Go through each build returned and either update or insert as required
                $.each(json.builds, function () {
                    var $build = $("#b" + this.buildResultKey),
                        messageType = this.messageType.toLowerCase(),
                        status = this.status.toLowerCase();
                    if ($build.length > 0) { // Check if the build already exists in list
                        var $msg = $(".message", $build[0]),
                            $stageInfo = $(".stage-info", $build[0]),
                            $agentInfo = $(".agent-info", $build[0]);
                        if (messageType == "progress" && $msg.hasClass(messageType)) {
                            $msg.progressBar("option", { value: this.percentageComplete, text: this.messageText });
                        } else if (messageType == "progress") {
                            $msg.attr("class", "message").progressBar({ value: this.percentageComplete, text: this.messageText });
                        } else {
                            if ($msg.hasClass("progress")) {
                                $msg.progressBar("destroy");
                            }
                            if (!$msg.hasClass(messageType)) {
                                $msg.attr("class", "message " + messageType).text(this.messageText);
                            } else {
                                $msg.text(this.messageText);
                            }
                        }
                        if (status == "building") {
                            if ($agentInfo.length == 0 && this.agent != null) {
                                var buildingOnHTML = status == "building" ? AJS.template.load(opts.templates.buildingOnTemplate).fill({ agentId: this.agent.id, agentType: this.agent.type.toLowerCase(), agentName: this.agent.name }).toString() : "";
                                $(".build-description", $build[0]).append(buildingOnHTML);
                            }
                            if (this.stage != null && $stageInfo.length > 0) {
                                var currentStageHTML = (status == "building" ? AJS.template.load(opts.templates.currentStageTemplate).fill({ stageName: this.stage.name, stageNumber: this.stage.number, totalStages: this.stage.totalStages }).toString() : "");
                                $stageInfo.html($.trim(currentStageHTML));
                            }
                        }
                        if (!$build.hasClass(status)) {
                            $build.removeClass(status == "building" ? "queued" : "building").addClass(status);
                        }
                    } else {
                        var buildingOnHTML = (status == "building" && this.agent != null) ? AJS.template.load(opts.templates.buildingOnTemplate).fill({ agentId: this.agent.id, agentType: this.agent.type.toLowerCase(), agentName: this.agent.name }).toString() : "",
                            currentStageHTML = (status == "building" && this.stage != null) ? AJS.template.load(opts.templates.currentStageTemplate).fill({stageName: this.stage.name, stageNumber: this.stage.number, totalStages: this.stage.totalStages }).toString() : "",
                            buildMessageHTML = AJS.template.load(opts.templates.buildMessageTemplate).fill({ type: messageType, text: this.messageText }).toString(),
                            listItemHTML = AJS.template.load(opts.templates.buildListItemTemplate).fill({
                                buildResultKey: this.buildResultKey,
                                cssClass: status,
                                triggerReason: this.triggerReason,
                                planKey: this.planKey
                            }).fillHtml({
                                buildingOn: buildingOnHTML,
                                currentStage: currentStageHTML,
                                buildMessage: buildMessageHTML
                            }).toString();
                        $build = $(listItemHTML).appendTo($buildList);
                        var $msg = $(".message", $build[0]);
                        $build.addClass("collapsed").prepend(toggleDetailsHTML);
                        $(".additional-information", $build).hide();
                        if (messageType == "progress") {
                            $msg.progressBar({ value: this.percentageComplete, text: this.messageText });
                        }
                    }
                    $build.data("lastUpdated", updateTimestamp);
                });

                // Clean up builds not returned in JSON
                $buildList.children().each(function () {
                    var b = $(this);
                    if (b.data("lastUpdated") < updateTimestamp) {
                        b.fadeOut(500, function () {
                            $(this).remove();
                            checkListHasBuilds();
                        })
                    }
                });

                checkListHasBuilds();

                // Update again in 5 seconds
                updateTimeout = setTimeout(update, 5000);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                // Error occurred when doing the update, try again in 30 sec
                updateTimeout = setTimeout(update, 30000);
            }
        });
    };
    return {
        /**
         * Initialisation for the Live Activity
         * @param options - Object containing the options to overwrite our defaults
         */
        init: function (options) {
            $.extend(true, opts, options);
            disabledStopHTML = opts.templates.disabledStopButton.fill({ title: opts.cancellingBuildText, text: opts.cancellingBuildText }).toString();
            toggleDetailsHTML = opts.templates.toggleDetailsButton.toString();

            $buildList = $("> ul", opts.container);
            if ($buildList.length == 0) {
                $buildList = $("<ul />").hide().prependTo(opts.container);
            } else {
                $buildList.children().addClass("collapsed").prepend(toggleDetailsHTML);
                $(".additional-information", $buildList).hide();
            }
            $noBuilds = $("> p", opts.container);
            if ($noBuilds.length == 0) {
                $noBuilds = $("<p>" + opts.queueEmptyText + "</p>").hide().appendTo(opts.container);
            }

            $("#" + opts.container.attr("id") + " a.build-stop").live("click", function (e) {
                var el = $(this),
                    li = el.closest("li");
                $.post(this.href, function () {
                    // Only remove from the queue immediately - currently building builds may take a while to stop and clean up - let the next updateBuilds() that runs clean it up
                    if (li.hasClass("queued")) {
                        li.fadeOut(500, function () {
                            $(this).remove();
                            checkListHasBuilds();
                        })
                    }
                });
                el.replaceWith(disabledStopHTML);
                e.preventDefault();
            });

            $("#" + opts.container.attr("id") + " .collapsed .toggle-details").live("click", function (e) {
                var el = $(this),
                    li = el.closest("li"),
                    additionalInfo = $(".additional-information", li[0]),
                    buildResultKey = li.attr("id").substring(1);

                if (!additionalInfo.data("data-retrieved")) {
                    li.removeClass("collapsed");
                    $.ajax({
                        url: opts.getChangesUrl + buildResultKey,
                        data: {
                            expand: "jiraIssues,changes.change"
                        },
                        dataType: "json",
                        contentType: "application/json",
                        success: function (json) {
                            var issues = "";
                            if (json.jiraIssues && json.jiraIssues.size > 0) {
                                $.each(json.jiraIssues.issue, function () {
                                    if (this.url && this.url.href && this.key && this.summary) {
                                        issues += AJS.template.load(opts.templates.jiraIssueTemplate).fill({
                                            url: this.url.href,
                                            issueType: (this.issueType && this.issueType.length > 0) ? this.issueType : opts.defaultIssueType,
                                            issueIconUrl: (this.iconUrl && this.iconUrl.length > 0) ? this.iconUrl : opts.defaultIssueIconUrl,
                                            key: this.key,
                                            details: this.summary
                                        }).toString();
                                    }
                                });
                            }

                            var changes = "";
                            if (json.changes && json.changes.size > 0) {
                                $.each(json.changes.change, function () {
                                    if (this.author && this.comment) {
                                        changes += AJS.template.load(opts.templates.codeChangeTemplate).fill({
                                            authorOrUser: (this.userName && this.userName.length > 0) ? "user" : "author",
                                            author: (this.userName && this.userName.length > 0) ? this.userName : this.author,
                                            displayName: (this.fullName && this.fullName.length > 0) ? this.fullName : this.author,
                                            comment: this.comment
                                        }).fillHtml({
                                            changesetInfo: this.changesetId ? AJS.template.load(this.commitUrl ? opts.templates.codeChangeChangesetLinkTemplate : opts.templates.codeChangeChangesetDisplayTemplate).fill({
                                                commitUrl: this.commitUrl ? this.commitUrl : null,
                                                changesetId: this.changesetId
                                            }).toString() : ""
                                        }).toString();
                                    }
                                });
                            }

                            if (issues.length == 0 && changes.length == 0) {
                                additionalInfo.text(opts.noAdditionalInfoText);
                            } else {
                                if (issues.length == 0) {
                                    $(".issueSummary", additionalInfo[0]).remove();
                                } else {
                                    $(".issueSummary", additionalInfo[0]).append("<ul>" + issues + "</ul>");
                                }
                                if (changes.length == 0) {
                                    $(".changesSummary", additionalInfo[0]).remove();
                                } else {
                                    $(".changesSummary", additionalInfo[0]).append("<ul>" + changes + "</ul>");
                                }
                            }

                            li.addClass("expanded");
                            additionalInfo.data("data-retrieved", true, true).stop(true).slideDown(opts.slideSpeed);
                        },
                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                            li.addClass("collapsed");
                        }
                    });
                } else {
                    li.removeClass("collapsed").addClass("expanded");
                    additionalInfo.stop(true, true).slideDown(opts.slideSpeed);
                }
            });

            $("#" + opts.container.attr("id") + " .expanded .toggle-details").live("click", function (e) {
                var el = $(this),
                    li = el.closest("li");
                li.removeClass("expanded").addClass("collapsed");
                $(".additional-information", li[0]).stop(true, true).slideUp(opts.slideSpeed);
            });

            // Trigger the first update
            update();
        }
    }
}(jQuery);



function showAjaxErrorMessage(XMLHttpRequest) {
    AJS.$(".ajaxErrorMessage").html("["+XMLHttpRequest.statusText+"]");
    AJS.$("#ajaxErrorHolder").removeClass("hidden");
    AJS.$("#ajaxErrorHolder").show();
}

function hideAjaxErrorMessage() {
    AJS.$(".ajaxErrorMessage").empty();
    AJS.$("#ajaxErrorHolder").hide();
}

/**
 * Usage: init(selector, reloadEvent) . Calling init function multiple times on the same page is safe regardless of used selectors.
 *
 * @param selector the jQuery selector used to mark asynchronously executed links
 * @param resetLinkStateEventName (optional, nullable) the event causing the "executed" status of links to be cleared
 * @param onUrlCallFinished (optional) handler to call when url processing is finished
 */
var AsynchronousRequestManager = function() {
    var IN_PROGRESS_KEY = "isInProgress";
    var registeredResetLinkStateHandlers = {};

    function isInProgress(link) {
        return link.data(IN_PROGRESS_KEY);
    }

    function setInProgress(link, newValue) {
        link.data(IN_PROGRESS_KEY, newValue);
        if (newValue) {
            link.fadeTo("slow", 0.4);
        } else {
            link.fadeTo("slow", 1);
        }
    }

    var onAsynchronousLinkClick = function (event) {
        var $this = AJS.$(this);
        if (!isInProgress($this)) {
            AJS.$.ajax({
                url: this.href,
                error: function (XMLHttpRequest) {
                    setInProgress($this, false);
                    if (event.data.failureHandler) {
                        event.data.failureHandler();
                    }
                    showAjaxErrorMessage(XMLHttpRequest);
                },
                success: function () {
                            if (event.data.successHandler) {
                                event.data.successHandler();
                            }
                            setInProgress($this, false);
                }
            });
            setInProgress($this, true);
        }
        event.preventDefault();
    };

    function makePair(first, second) {
        return first + "##" + second;
    }

    return {
        init: function (selector, resetLinkStateEventName, onUrlCallFinished) {
            var $selector = AJS.$(selector);
            if (resetLinkStateEventName) {
                var pair = makePair(resetLinkStateEventName, selector);
                if (!(pair in registeredResetLinkStateHandlers)) {
                    AJS.$("body").bind(resetLinkStateEventName, function () {
                        $selector.filter(":visible").each(function () {
                            setInProgress(AJS.$(this), false);
                        });
                    });
                    registeredResetLinkStateHandlers[pair] = true;
                }
            }

            $selector.die("click", onAsynchronousLinkClick).live("click", {
                                                                     successHandler: onUrlCallFinished,
                                                                     failureHandler: onUrlCallFinished
                                                                 }, onAsynchronousLinkClick);
        }
    }
}();



/**
 * JobResultSummary page
 */
var JobResultSummaryLiveActivity = function ($) {
    var opts = {
        buildResultKey: null,
        buildLifeCycleState: null,
        container: null,
        getBuildUrl: null,
        reloadUrl: null,
        templates: {
            disabledStopButton: null,
            logTableRow: null,
            progressOverAverage: null,
            progressUnderAverage: null,
            queueDurationDescription: null,
            queuePositionDescription: null,
            updatingSourceFor: null
        }
    },
    linesOfLogToDisplay = 10,
    $linesOfLogToDisplaySelect,
    $logBody,
    $logContainer,
    $logLoading,
    $progressBarContainer,
    $queueDurationDescriptionContainer,
    $queuePositionDescriptionContainer,
    queueDuration,
    updateTimeout,
    update = function () {

        clearTimeout(updateTimeout);

        var ajaxData = $logContainer.is(":visible") ? {
            expand: 'logEntries[-' + linesOfLogToDisplay + ':]',
            'max-results': linesOfLogToDisplay
        } : {};

        $.ajax({
            url: opts.getBuildUrl,
            data: ajaxData,
            dataType: "json",
            contentType: "application/json",
            cache: false,
            success: function (buildResult) {
                if (buildResult.lifeCycleState != opts.buildLifeCycleState) {
                    document.location = opts.reloadUrl;
                    return;
                } else if (buildResult.lifeCycleState == "Pending" || buildResult.lifeCycleState == "Queued") {
                    if (queueDuration != buildResult.queueDuration) {
                        var queueDurationMarkup = AJS.template.load(opts.templates.queueDurationDescription)
                                .fill({ durationDescription: DurationUtils.getPrettyPrint(buildResult.queueDuration)}).toString();
                        $queueDurationDescriptionContainer.html(queueDurationMarkup);
                        $queueDurationDescriptionContainer.show();
                        queueDuration = buildResult.queueDuration;
                    }

                    var queuePositionMarkup = AJS.template.load(opts.templates.queuePositionDescription)
                            .fill({
                                position: buildResult.queue.position + 1,
                                length: buildResult.queue.length
                            }).toString();
                    $queuePositionDescriptionContainer.html(queuePositionMarkup);
                    $queuePositionDescriptionContainer.show();

                } else if (buildResult.lifeCycleState == "InProgress") {
                    if (buildResult.progress) {

                        var pbOptions = {};

                        if (buildResult.buildStartedTime) {
                            pbOptions.value = buildResult.progress.percentageCompleted * 100;
                            if (buildResult.progress.isUnderAverageTime) {
                                pbOptions.text = AJS.template.load(opts.templates.progressUnderAverage).fill({
                                    elapsed: buildResult.progress.prettyBuildTime,
                                    remaining: buildResult.progress.prettyTimeRemainingLong
                                }).toString();
                            } else {
                                pbOptions.text = AJS.template.load(opts.templates.progressOverAverage).fill({
                                    elapsed: buildResult.progress.prettyBuildTime,
                                    remaining: buildResult.progress.prettyTimeRemainingLong
                                }).toString();
                            }
                        } else {
                            pbOptions.value = 0;
                            pbOptions.text = AJS.template.load(opts.templates.updatingSourceFor).fill({
                                prettyVcsUpdateDuration: buildResult.prettyVcsUpdateDuration
                            }).toString();
                        }

                        $progressBarContainer.progressBar(pbOptions);
                    }

                    if (buildResult.logEntries && buildResult.logEntries.logEntry) {

                        var newLogBody = '';

                        for (var i = 0, ii = buildResult.logEntries.logEntry.length; i < ii; i++) {
                            var logEntry = buildResult.logEntries.logEntry[i];
                            newLogBody += AJS.template.load(opts.templates.logTableRow)
                                    .fill({ time: logEntry.formattedDate })
                                    .fillHtml({ log: logEntry.log }).toString();
                        }
                        if ($logBody.html() != newLogBody) {
                            $logBody.html(newLogBody);
                        }
                        if ($logLoading.is(":visible")) {
                            $logLoading.hide();
                            $logBody.parent().removeClass("hidden");
                        }
                    }
                }

                // Update again in 5 seconds
                updateTimeout = setTimeout(update, 5000);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                // Error occurred when doing the update, try again in 30 sec
                updateTimeout = setTimeout(update, 30000);
            }
        });
    };
    return {
        init: function (options) {
            $.extend(true, opts, options);

            $linesOfLogToDisplaySelect = $("#linesToDisplay");
            $logBody = $("#buildLog tbody");
            $logContainer = $logBody.parent().parent();
            $logLoading = $(".loading", $logContainer[0]);
            $progressBarContainer = $("#pb" + opts.buildResultKey);
            $queueDurationDescriptionContainer = $("#queueDurationDescription");
            $queuePositionDescriptionContainer = $("#queuePositionDescription");

            // Get our default in line with what was set previously
            linesOfLogToDisplay = $linesOfLogToDisplaySelect.val();

            $linesOfLogToDisplaySelect.change(function () {
                linesOfLogToDisplay = $(this).val();
                saveCookie("BAMBOO-MAX-DISPLAY-LINES", linesOfLogToDisplay, 365);
                update();
            });

            var disabledStopHTML = opts.templates.disabledStopButton.toString();
            $("#buildResults a.build-stop").live("click", function (e) {
                var $el = $(this);
                $.post(this.href);
                $el.replaceWith(disabledStopHTML);
                e.preventDefault();
            });

            // Trigger the first update
            update();
        }
    }
}(jQuery);


var DurationUtils = function() {
    var opts = {
        format: "{value} {unit}",
        units: {
            SEC: ["second", "seconds"],
            MIN: ["minute", "minutes"]
        }
    },
    MILLIS_IN_MINUTE = 60 * 1000,
    MILLIS_IN_SECOND = 1000,
    describeValueAs = function(value, unit) {
        return opts.format.replace("{value}", value).replace("{unit}", value == 1 ? unit[0] : unit[1]);
    };
    return {
        init: function (options) {
            $.extend(true, opts, options);
        },
        getPrettyPrint: function(elapsedTimeMillis) {
            if (elapsedTimeMillis >= MILLIS_IN_MINUTE) {
                return describeValueAs(Math.floor(elapsedTimeMillis / MILLIS_IN_MINUTE), opts.units.MIN)
            } else if (elapsedTimeMillis >= MILLIS_IN_SECOND) {
                return describeValueAs(Math.floor(elapsedTimeMillis / MILLIS_IN_SECOND), opts.units.SEC)
            } else {
                return "< 1 {unit}".replace("{unit}", opts.units.SEC[0]);
            }
        }
    }
}();

var ChainResultSummary = function ($) {
    var opts = {
        slideSpeed: 400,
        $list: null,
        getStageResultsUrl: null,
        buildResultKey: null,
        autoUpdate: false,
        templates: {
            buildResultDetails: null,
            buildInProgress: null,
            progressOverAverage: null,
            progressUnderAverage: null,
            updatingSourceFor: null,
            noAgentsForJob: null
        }
    },
    updateTimeout,
    progressBarContainer,
    update = function () {
        $.ajax({
            url: opts.getStageResultsUrl,
            cache: false,
            data: {
                expand: "stages.stage.results.result"
            },
            dataType: "json",
            contentType: "application/json",
            success: function (json) {
                if (json.lifeCycleState == "Finished") {
                    window.location.reload(true);
                    return;
                }

                if (json.lifeCycleState == "InProgress" && $("#buildResultsSummary").hasClass("queued")) {
                    window.location.reload(true);
                }

                if (json.lifeCycleState == "Pending" || json.lifeCycleState == "Queued" || json.lifeCycleState == "InProgress") {
                    if (json.progress) {

                        var pbOptions = {};

                        if (json.buildStartedTime) {
                            pbOptions.value = json.progress.percentageCompleted * 100;
                            if (json.progress.isUnderAverageTime) {
                                pbOptions.text = AJS.template.load(opts.templates.progressUnderAverage).fill({
                                    elapsed: json.progress.prettyBuildTime,
                                    remaining: json.progress.prettyTimeRemainingLong
                                }).toString();
                            } else {
                                pbOptions.text = AJS.template.load(opts.templates.progressOverAverage).fill({
                                    elapsed: json.progress.prettyBuildTime,
                                    remaining: json.progress.prettyTimeRemainingLong
                                }).toString();
                            }
                        } else {
                            pbOptions.value = 0;
                            pbOptions.text = AJS.template.load(opts.templates.updatingSourceFor).fill({
                                prettyVcsUpdateDuration: json.prettyVcsUpdateDuration
                            }).toString();
                        }

                        progressBarContainer.progressBar(pbOptions);
                    }
                }

                // Go through each stage returned and update
                if (json.stages.stage) {
                    $.each(json.stages.stage, function () {
                        var $stage = $("#stage_" + this.id),
                            status = this.lifeCycleState;
                        if ($stage.length > 0) { // Check if the stage exists in list
                            var $stageStatus = $("> div > dl > dd", $stage[0]),
                                $jobs = $("> div > ul", $stage[0]),
                                stageClass = this.displayClass,
                                successfulBuildResults = 0,
                                failedBuildResults = 0,
                                isCollapsed = $stage.hasClass("collapsed"),
                                isNotCollapsible = $stage.hasClass("not-collapsible"),
                                isCollapsedByDefault = this.collapsedByDefault;
                            if ($stageStatus.text() != this.displayMessage) {
                                $stageStatus.text(this.displayMessage);
                            }
                            if (!$stage.hasClass(stageClass)) {
                                $stage.removeClass("Failed Successful NotBuilt Pending InProgress").addClass(stageClass);
                            }
                            if (this.results.result) {
                                $.each(this.results.result, function () {
                                    var $build = $("#job_" + this.key);
                                    if ($build.length > 0) {
                                        var $buildResultDetails = $("> dl", $build[0]),
                                            buildClass = (this.lifeCycleState == "Finished") ? this.state : this.lifeCycleState,
                                            $progress = $("#pb" + this.key),
                                            $errorMessage = $(".jobError", $build);
                                        if (!$build.hasClass(buildClass)) {
                                            $build.attr("class", buildClass);
                                        }
                                        $("> #stopBuildLink_" + this.id, $build).remove();

                                        if (this.lifeCycleState == "Finished" && this.buildDurationDescription && this.buildTestSummary && $buildResultDetails.length == 0) {
                                            $build.append(AJS.template.load(opts.templates.buildResultDetails).fill({
                                                durationDescription: this.buildDurationDescription,
                                                testSummary: this.buildTestSummary
                                            }).toString());
                                            if ($progress.length) {
                                                $progress.remove();
                                            }
                                            if ($errorMessage.length) {
                                                $errorMessage.remove();
                                            }
                                        } else {
                                            if (this.lifeCycleState == "InProgress") {
                                                $build.append(AJS.template.load(opts.templates.buildInProgress).fill({
                                                    id: this.id,
                                                    chainResultKey: json.key,
                                                    buildResultKey: this.key
                                                }).toString());
                                                if (this.progress && !$progress.length) {
                                                    $progress = $("<div />", { id: "pb" + this.key }).progressBar().appendTo($build);
                                                }
                                                if (this.progress && this.progress.percentageCompleted) {
                                                    if (this.progress.averageBuildDuration > 0) {
                                                        $progress.progressBar("option", {
                                                            value: Math.floor(this.progress.percentageCompleted * 100),
                                                            text: this.progress.prettyTimeRemaining
                                                        });
                                                    } else {
                                                        $progress.progressBar("option", {
                                                            value: 0,
                                                            text: AJS.template.load(opts.templates.progressOverAverage).fill({elapsed: this.progress.prettyBuildTime}).toString()
                                                        });
                                                    }
                                                }
                                            }
                                            if ((this.lifeCycleState == "Pending" || this.lifeCycleState == "Queued") && !this.hasExecutableAgents) {
                                                if ($errorMessage.length == 0) {
                                                    $build.append(AJS.template.load(opts.templates.noAgentsForJob).toString());
                                                }
                                            } else {
                                                if ($errorMessage.length) {
                                                    $errorMessage.remove();
                                                }
                                            }
                                        }
                                    }
                                    if (this.state == "Successful") {
                                        successfulBuildResults++;
                                    }
                                    if (this.state == "Failed") {
                                        failedBuildResults++;
                                    }
                                });
                            }
                            if (!isNotCollapsible && isCollapsed != isCollapsedByDefault && !$stage.data("userAlteredDisplayState")) {
                                if (!isCollapsedByDefault) {
                                    $jobs.slideDown(opts.slideSpeed, function () {
                                        $stage.removeClass("collapsed");
                                    });
                                } else {
                                    $jobs.slideUp(opts.slideSpeed, function () {
                                        $stage.addClass("collapsed");
                                    });
                                }
                            }
                        }
                    });
                }

                // Update again in 5 seconds
                updateTimeout = setTimeout(update, 5000);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                // Error occurred when doing the update, try again in 30 sec
                updateTimeout = setTimeout(update, 30000);
            }
        });
    };
    return {
        init: function (options) {
            $.extend(true, opts, options);
            opts.$list.children(":last-child").addClass("last");

            opts.$list.delegate("li > div > dl > dt", "click", function () {
                var $stage = $(this).closest("li"),
                    $jobs = $("> div > ul", $stage[0]);
                if ($stage.hasClass("collapsed")) {
                    $jobs.slideDown(opts.slideSpeed, function () {
                        $stage.removeClass("collapsed").data("userAlteredDisplayState", true);
                    });
                } else if (!$stage.hasClass("not-collapsible")) {
                    $jobs.slideUp(opts.slideSpeed, function () {
                        $stage.addClass("collapsed").data("userAlteredDisplayState", true);
                    });
                }
            });
            
            progressBarContainer = $("#pb" + opts.buildResultKey);
            
            if (opts.autoUpdate) {
                update();
            }
        }
    }
}(jQuery);


/**
 * BuildResultSummary page
 */
var BuildResultSummaryLiveActivity = function ($) {
    var opts = {
        getBuildUrl: null,
        templates: {
            logMessagePending: null,
            logMessageQueued: null,
            logMessageFinished: null,
            logTableRow: null
        }
    },
    displayLogActivity = function(logBody) {
        $logMessage.hide();
        $logLoading.hide();
        if ($logBody.html() != logBody) {
            $logBody.html(logBody);
        }
        $logBody.parent().show();
        $logContainer.show();
    },
    displayLogLoading = function() {
        $logMessage.hide();
        $logBody.parent().hide();
        $logLoading.show();
        $logContainer.show();
    },
    displayLogMessage = function(template) {
        $logContainer.hide();
        $logMessage.html(AJS.template.load(template).fill({job: jobName})).show();
    },
    $jobResultKeyForLogDisplaySelect,
    jobResultKey,
    jobName,
    linesOfLogToDisplay = 10,
    $linesOfLogToDisplaySelect,
    $logBody,
    $logContainer,
    $logLoading,
    $logMessage,
    updateTimeout,
    update = function () {

        clearTimeout(updateTimeout);

        $.ajax({
            url: opts.getBuildUrl.replace("@KEY@", jobResultKey),
            data: {
                expand: 'logEntries[-' + linesOfLogToDisplay + ':]',
                'max-results': linesOfLogToDisplay
            },
            dataType: "json",
            contentType: "application/json",
            cache: false,
            success: function (buildResult) {
                if (buildResult.lifeCycleState == "Pending") {
                    displayLogMessage(opts.templates.logMessagePending);
                } else if (buildResult.lifeCycleState == "Queued") {
                    displayLogMessage(opts.templates.logMessageQueued);
                } else if (buildResult.lifeCycleState == "InProgress") {
                    if (buildResult.logEntries && typeof(buildResult.logEntries.logEntry) != "undefined") {
                        var newLogBody = '';
                        for (var i = 0, ii = buildResult.logEntries.logEntry.length; i < ii; i++) {
                            var logEntry = buildResult.logEntries.logEntry[i];
                            newLogBody += AJS.template.load(opts.templates.logTableRow)
                                    .fill({ time: logEntry.formattedDate })
                                    .fillHtml({ log: logEntry.log }).toString();
                        }
                        displayLogActivity(newLogBody);
                    } else {
                        displayLogLoading();
                    }
                } else if (buildResult.lifeCycleState == "Finished") {
                    displayLogMessage(opts.templates.logMessageFinished);
                }

                // Update again in 5 seconds
                updateTimeout = setTimeout(update, 5000);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                // Error occurred when doing the update, try again in 30 sec
                updateTimeout = setTimeout(update, 30000);
            }
        });
    };
    return {
        init: function(options) {
            $.extend(true, opts, options);
            $jobResultKeyForLogDisplaySelect = $("#jobResultKeyForLogDisplay");
            $linesOfLogToDisplaySelect = $("#linesToDisplay");
            $logContainer = $("#buildResultSummaryLogs");
            $logBody = $("table > tbody", $logContainer[0]);
            $logLoading = $(".loading", $logContainer[0]);
            $logMessage = $("#buildResultSummaryLogMessage");

            // Get our default in line with what was set previously
            linesOfLogToDisplay = $linesOfLogToDisplaySelect.val();

            $jobResultKeyForLogDisplaySelect.change(function () {
                jobResultKey = $jobResultKeyForLogDisplaySelect.val();
                jobName = $jobResultKeyForLogDisplaySelect.find("option:selected").text();
                update();
            });

            $linesOfLogToDisplaySelect.change(function () {
                linesOfLogToDisplay = $linesOfLogToDisplaySelect.val();
                saveCookie("BAMBOO-MAX-DISPLAY-LINES", linesOfLogToDisplay, 365);
                update();
            });

            // Trigger the first update
            $jobResultKeyForLogDisplaySelect.change();
        }
    }
}(jQuery);


var ChainConfiguration = function ($) {
    var opts = {
        $list: null,
        moveStageUrl: null,
        moveJobUrl: null,
        confirmStageMoveUrl: null,
        confirmJobMoveJobUrl: null,
        chainKey: null,
        canReorder: false,
        stageMoveHeader: "Move Stage",
        jobMoveHeader: "Move Job"
    };
    return {
        init: function (options) {
            $.extend(true, opts, options);
            opts.$list.children(":last-child").addClass("last");

            opts.$list.find("li > div > dl > dd > .actions").dropDown("Standard");
            opts.$list.find("li > div > ul > li > .actions").dropDown("Standard", { trigger: ".aui-dd-link" });

            if ($.browser.msie && parseInt($.browser.version, 10) == 7) {
                // Add a custom trigger when someone clicks the trigger to fix IE7's crappy stacking
                opts.$list.find("li > div > ul > li > .actions .aui-dd-link").click(function(){
                    $(this).closest("li[id^='job_']").css("zIndex", 1).siblings().css("zIndex", "");
                });
            }

            if (!opts.canReorder) {
                return;
            }
            
            opts.$list.sortable({
                cursor: "move",
                distance: 5,
                handle: "dl",
                start: function (event, ui) {
                    var $self = $(ui.item);
                    $self.data("movedFromPos", $self.prevAll().length);
                },
                update: function (event, ui) {
                    var $self = $(ui.item),
                        revertMove = function(index) {
                            if ((opts.$list.children().length - 1) == $self.data("movedFromPos")) {
                                $self.appendTo(opts.$list).removeData("movedFromPos");
                            } else {
                                $self.insertBefore(opts.$list.children("li:eq(" + ($self.data("movedFromPos") + (($self.data("movedFromPos") > index)?1:0)) + ")")).removeData("movedFromPos");
                            }
                        },
                        showError = function () {
                            var message = arguments.length ? arguments[0] : "There was a problem moving your stage.",
                                errorDialog = new AJS.Dialog(400, 150);
                            errorDialog.addHeader("Stage move failed").addPanel("errorPanel", '<div class="fieldError errorText">' + message + '</div>').addButton("Close", function (dialog) {
                                dialog.hide();
                            });
                            errorDialog.show();
                            revertMove();
                        },
                        callMoveAction = function() {
                            var stageId = $self.attr("id").split("_")[1],
                                index = $self.prevAll().length;
                            $.ajax({
                                       type: "POST",
                                       url: opts.moveStageUrl,
                                       data: { buildKey: opts.chainKey, stageId: stageId, index: index},
                                       success: function (json) {
                                           if (json.status == "ERROR") {
                                               if (json.errors && json.errors.length > 0) {
                                                   var message = json.errors.join("<br>");
                                                   showError(message);
                                               } else {
                                                   showError();
                                               }
                                           } else if (json.status == "CONFIRM") {
                                               var cancelCallback = function (dialog) {
                                                        revertMove(index);
                                                   };
                                               simpleDialogForm(null, opts.confirmStageMoveUrl + "?buildKey=" + opts.chainKey + "&stageId=" + stageId + "&index=" + index, 600, 500, opts.stageMoveHeader, "ajax", null, cancelCallback, opts.stageMoveHeader);

                                           } else {
                                               opts.$list.children(":last-child").addClass("last").siblings().removeClass("last");
                                           }
                                       },
                                       error: function (XMLHttpRequest, textStatus, errorThrown) {
                                           showError();
                                       },
                                       dataType: "json"
                                   });
                        };
                    callMoveAction();
                }
            });

            var jobLists = opts.$list.find("> li > div > ul");
            jobLists.children("[id^='job_']").draggable({
                cursor: "move",
                handle: ".handle",
                revert: "invalid",
                revertDuration: 300,
                scope: "jobs",
                start: function (event, ui) {
                    var $self = $(this);
                    $self.data("movedFrom", $self.parent()).data("movedFromPos", $self.prevAll().length);

                    // Add a z-index to the stage when someone drags a job to fix IE7's crappy stacking
                    if ($.browser.msie && parseInt($.browser.version, 10) == 7) {
                        $self.closest("li[id^='stage_']").css("zIndex", 1).siblings().css("zIndex", "")
                    }
                }
            });
            jobLists.droppable({
                accept: function (li) {
                    return (this != li.parent()[0]); // prevents being able to drop to the same stage
                },
                activeClass: "ui-state-active",
                drop: function (event, ui) {
                    var $self = ui.draggable,
                        revertMove = function () {
                            var $originalFollowingElement = $self.data("movedFrom").children("li:eq(" + $self.data("movedFromPos") + ")");
                            if ($originalFollowingElement.length == 0)  {
                                $self.appendTo($self.data("movedFrom")).removeData("movedFrom").removeData("movedFromPos");
                            } else  {
                                $self.insertBefore($originalFollowingElement).removeData("movedFrom").removeData("movedFromPos");
                            }
                        },
                        showError = function () {
                            var message = arguments.length ? arguments[0] : "There was a problem moving your Job.",
                                errorDialog = new AJS.Dialog(400, 150);

                            errorDialog.addHeader("Job move failed").addPanel("errorPanel", '<div class="fieldError errorText">' + message + '</div>').addButton("Close", function (dialog) {
                                 dialog.hide();
                            });
                            errorDialog.show();
                            revertMove();
                        },
                        callMoveAction = function() {
                            var stageId = $self.closest("li[id^='stage_']").attr("id").split("_")[1],
                                jobKey = $self.attr("id").split("_")[1];
                            $.ajax({
                                       type: "POST",
                                       url: opts.moveJobUrl,
                                       data: { buildKey: opts.chainKey, stageId: stageId, jobKey: jobKey },
                                       success: function (json)
                                       {
                                           if (json.status == "ERROR") {
                                               if (json.errors && json.errors.length > 0) {
                                                   var message = json.errors.join("<br>");
                                                   showError(message);
                                               } else {
                                                   showError();
                                               }
                                           } else if (json.status == "CONFIRM") {
                                               var cancelCallback = function () {
                                                        revertMove();
                                                    };

                                               simpleDialogForm(null, opts.confirmJobMoveJobUrl + "?buildKey=" + opts.chainKey + "&stageId=" + stageId + "&jobKey=" + jobKey, 600, 500, opts.jobMoveHeader, "ajax", null, cancelCallback, opts.jobMoveHeader);
                                           }
                                       },
                                       error: function (XMLHttpRequest, textStatus, errorThrown) {
                                           showError();
                                       },
                                       dataType: "json"
                                   });
                        };
                    $self.prependTo(this).css({ left: "", top: "" });
                    callMoveAction();
                },
                hoverClass: "ui-state-hover",
                scope: "jobs"
            });
        }
    }
}(jQuery);

var ArtifactDefinitionEdit = function ($) {
    var opts = {
        html: {
            artifactSharingToggleContentShared: null,
            artifactSharingToggleContentUnshared: null
        },
        i18n: {
            artifact_definition_shareToggle_error: null,
            artifact_definition_shareToggle_error_header: null,
            global_buttons_close: null
        },
        deleteArtifactDefinition: {
            actionUrl: null,
            submitLabel: null,
            title: null
        },
        editArtifactDefinition: {
            actionUrl: null,
            submitLabel: null,
            title: null
        },
        renameArtifactDefinitionToEnableSharing: {
            actionUrl: null,
            submitLabel: null,
            title: null
        },
        toggleArtifactDefinitionSharing: {
            actionUrl: null,
            submitLabel: null,
            title: null
        },
        confirmToggleArtifactDefinitionSharing: {
            actionUrl: null,
            submitLabel: null,
            title: null
        }
    },
    $artifactDefinitionsTable,
    deleteArtifactDefinitionCallback = function (result) {
        var artifact = result.artifactDefinition;

        (($("tbody > tr", $artifactDefinitionsTable).length == 1) ? $artifactDefinitionsTable : $("#artifactDefinition-" + artifact.id)).remove();
    },
    deleteArtifactDefinitionOnClick = function() {
        var artifactId = this.id.split("-")[1],
            hasSubscriptions = $(this).hasClass("hasSubscriptions");

        simpleDialogForm(null,
                         opts.deleteArtifactDefinition.actionUrl + "&artifactId=" + artifactId,
                         hasSubscriptions ? 600 : 400,
                         hasSubscriptions ? 500 : 200,
                         opts.deleteArtifactDefinition.submitLabel,
                         "ajax",
                         deleteArtifactDefinitionCallback,
                         null,
                         opts.deleteArtifactDefinition.title,
                         null);
    },
    editArtifactDefinitionOnClick = function() {
        var artifactId = this.id.split("-")[1];

        simpleDialogForm(null,
                         opts.editArtifactDefinition.actionUrl + "&artifactId=" + artifactId,
                         800,
                         450,
                         opts.editArtifactDefinition.submitLabel,
                         "ajax",
                         updateArtifactDefinitionCallback,
                         null,
                         opts.editArtifactDefinition.title,
                         null);
    },
    toggleArtifactDefinitionSharingOnClick = function() {
        var artifactId = this.id.split("-")[1],
            showError = function () {
                var message = arguments.length ? arguments[0] : opts.i18n.artifact_definition_shareToggle_error,
                    errorDialog = new AJS.Dialog(400, 150);
                errorDialog.addHeader(opts.i18n.artifact_definition_shareToggle_error_header)
                        .addPanel("errorPanel", '<div class="fieldError errorText">' + message + '</div>')
                        .addCancel(opts.i18n.global_buttons_close, function (dialog) { dialog.hide(); })
                        .show();
            };

        AJS.$.ajax({
            type: "POST",
            url: opts.toggleArtifactDefinitionSharing.actionUrl,
            data: { artifactId: artifactId },
            success: function (json) {
                if (json.status == "ERROR") {
                    if (json.errors && json.errors.length) {
                        showError(json.errors.join("<br>"));
                    } else if (json.fieldErrors) {
                        if (json.fieldErrors.name && json.fieldErrors.name.length) {
                            simpleDialogForm(null,
                                             opts.renameArtifactDefinitionToEnableSharing.actionUrl + "&artifactId=" + artifactId,
                                             700, 300,
                                             opts.renameArtifactDefinitionToEnableSharing.submitLabel,
                                             "ajax",
                                             updateArtifactDefinitionCallback, null,
                                             opts.renameArtifactDefinitionToEnableSharing.title);
                        } else {
                            var errorMessages = [];
                            for (var fieldError in json.fieldErrors) {
                                errorMessages.push(json.fieldErrors[fieldError].join("<br>"));
                            }
                            showError(errorMessages.join("<br>"));
                        }
                    } else {
                        showError();
                    }
                } else {
                    if (json.status == "CONFIRM") {
                        simpleDialogForm(null,
                                         opts.confirmToggleArtifactDefinitionSharing.actionUrl + "&artifactId=" + artifactId,
                                         600, 500,
                                         opts.confirmToggleArtifactDefinitionSharing.submitLabel,
                                         "ajax",
                                         updateArtifactDefinitionCallback, null,
                                         opts.confirmToggleArtifactDefinitionSharing.title);
                    } else {
                        updateArtifactDefinitionCallback(json);
                    }
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                showError();
            },
            dataType: "json"
        });
    },
    updateArtifactDefinitionCallback = function (result) {
        var artifact = result.artifactDefinition,
            $cells = $("#artifactDefinition-" + artifact.id + " > td");

        $($cells[0]).find("span.artifactName").text(artifact.name);
        $($cells[0]).find("span.icon").attr("class", artifact.sharedArtifact ? "icon icon-artifact-shared" : "icon icon-artifact");

        $($cells[1]).text(artifact.location);
        $($cells[2]).text(artifact.copyPattern);

        $("#toggleArtifactDefinitionSharing-" + artifact.id).html(artifact.sharedArtifact ? opts.html.artifactSharingToggleContentShared : opts.html.artifactSharingToggleContentUnshared);

        $artifactDefinitionsTable.trigger("update").trigger("sorton", [$artifactDefinitionsTable.get(0).config.sortList]);
    };

    return {
        init: function (options) {
            $.extend(true, opts, options);

            $artifactDefinitionsTable = $("#artifactDefinitions");

            // initialize table sorter
            $artifactDefinitionsTable.tablesorter({
                headers: {3:{sorter:false},4:{sorter:false}},
                sortList: [[0,0]]
            });
            $artifactDefinitionsTable.delegate("a.deleteArtifactDefinition", "click", deleteArtifactDefinitionOnClick)
                                     .delegate("a.editArtifactDefinition", "click", editArtifactDefinitionOnClick)
                                     .delegate("a.toggleArtifactDefinitionSharing", "click", toggleArtifactDefinitionSharingOnClick);
        }
    }
}(jQuery);


/* Tests Tables */
AJS.$(document).delegate(".tests-table > tbody > tr > .twixie > span", "click", function (e) {
    var $twixie = AJS.$(this),
        $tr = $twixie.closest("tr"),
        $stack = $tr.next(),
        newTwixieText = !$twixie.hasClass("icon-collapse") ? "Collapse" : "Expand"; //negated because we toggle the class later
    $stack[$tr.hasClass("collapsed") ? "show" : "hide"]();
    $tr.toggleClass("collapsed expanded");
    $twixie.toggleClass("icon-collapse icon-expand").attr("title", newTwixieText).html("<span>" + newTwixieText + "</span>");
});
AJS.$(document).delegate(".tests-table > thead > tr > .twixie span[role]", "click", function (e) {
    var $trigger = AJS.$(this),
        $li = $trigger.closest("li"),
        $table = $trigger.closest("table");
    if ($li.hasClass("expand-all")) {
        $table.find("tbody > .collapsed .twixie > span").click();
    } else if ($li.hasClass("collapse-all")) {
        $table.find("tbody > .expanded .twixie > span").click();
    }
});


/**
 * Strip given prefix from input.
 * Can handle String and jQuery object input.
 *
 * @param prefix String                   prefix to be stripped from input
 * @param input  String or jQuery object
 */
BAMBOO.stripPrefixFromId = function(prefix, input) {
    if (typeof(input) == 'string') {
        if (input.indexOf(prefix) == 0) {
            return input.slice(prefix.length);
        } else {
            return input;
        }
    } else {
        return this.stripPrefixFromId(prefix, AJS.$(input).attr("id"));
    }
};

/**
 * Escape characters in element id to use it as jQuery selector
 * @param id
 */
BAMBOO.escapeIdToJQuerySelector = function(id) {
    return id.replace(/([\.:])/g, '\\$1');
};

BAMBOO.buildAUIErrorMessage = function(errors) {
    var $dummy = AJS.$('<div/>');
    if (errors.length == 1) {
        AJS.messages.error($dummy, {title: errors[0], closeable: false});
    } else if (errors.length > 1) {
        var list = ['<ul>'];
        for (var i = 0, ii = errors.length; i < ii; i++) {
            list.push('<li>', errors[i], '</li>');
        }
        list.push('</ul>');
        AJS.messages.error($dummy, {body: list.join(''), closeable: false});
    }
    return $dummy.children();
};

BAMBOO.buildFieldError = function(errors) {
    var $dummy = AJS.$('<div/>');
    for (var i = 0, ii = errors.length; i < ii; i++) {
        $dummy.append(AJS.$('<div class="error"/>').html(errors[i]));
    }
    return $dummy.children();
};

BAMBOO.addFieldErrors = function($form, fieldName, errors) {
    var $field = AJS.$('#fieldArea_' + $form.attr('id') + '_' + fieldName.replace(".", "_")),
        $input = AJS.$('#' + $form.attr('id') + '_' + fieldName.replace(".", "_")),
        $description = $field.find('.description'),
        $errors = BAMBOO.buildFieldError(errors);

    if ($description.length) {
        $description.before($errors);
    } else if ($field.length) {
        $field.append($errors);
    } else {
        $input.after($errors);
    }
};


/**
 * Inline Editing
 * @param options
 *  - target        String - selector targeting the span/element to make inline-editable
 *  - submit        Function - handles what to do when value is submitted
 *  - cancel        Function - handles what to do when cancel is triggered
 *  - focus         Function - handles what to do when focus is given to the edit field
 *  - $delegator    jQuery Object - where the event handler should be bound
 */
BAMBOO.inlineEdit = function (options) {
    var defaults = {
            target: null,
            submit: null,
            cancel: null,
            focus: null,
            $delegator: AJS.$(document)
        },
        handleEdit = function (e) {
            var $target = AJS.$(this),
                $input = $target.next("input.inline-edit-field");
            if (!$input.length) {
                $input = AJS.$("<input/>", {
                    "type": "text",
                    "class": "inline-edit-field text",
                    "keydown": handleKeyDown,
                    "blur": handleSubmit,
                    "val": $target.text(),
                    "data": { hasInlineEditHandlers: true, lastValidValue: $target.text() }
                }).insertAfter($target);
            }
            if (!$input.data("hasInlineEditHandlers")) {
                $input.keydown(handleKeyDown).blur(handleSubmit).data("hasInlineEditHandlers", true).data("lastValidValue", $input.val());
            }
            $input.addClass("focus");
            $target.hide();
            $input.show().focus();
            if (AJS.$.isFunction(options.focus)) {
                options.focus(e);
            }
        },
        handleKeyDown = function (e) {
            if (e.which == VK_ESCAPE) {
                handleCancel(e);
            } else if (e.which == VK_ENTER) {
                e.preventDefault(); // prevents form submission when enter key is pressed
                handleSubmit(e);
            }
        },
        handleCancel = function (e) {
            var $input = AJS.$(e.currentTarget),
                $target = $input.prev(".inline-edit-view");
            var lastValidValue = $input.data("lastValidValue");
            $input.hide().removeClass("focus").val(lastValidValue);
            $target.text(lastValidValue).show();
            if (AJS.$.isFunction(options.cancel)) {
                options.cancel(e);
            }
        },
        handleSubmit = function (e) {
            var $input = AJS.$(e.currentTarget),
                $target = $input.prev(".inline-edit-view");
            if ($target.text() != $input.val()) {
                $target.text($input.val());
                $input.hide().removeClass("focus");
                $target.show();
                if (AJS.$.isFunction(options.submit)) {
                    options.submit(e);
                }
            } else {
                handleCancel(e);
            }
        };

    options = AJS.$.extend(true, defaults, options);

    if (options.target) {
        options.$delegator.delegate(options.target, "click focus", handleEdit);
    }
};


/**
 * ConfigureVariables screen (both global and chain)
 */
BAMBOO.ConfigureVariables = function ($) {
    var opts = {
            target: null,
            updateVariableUrl: null,
            $loadingIndicator: $("<span/>", { "class": "icon icon-loading" })
        },
        $container,
        $addVariable,
        clearAllErrors = function () {
            $container.find('.error,.aui-message').remove();
        },
        clearFieldErrors = function ($field) {
            $field.nextAll(".error").remove();
        },
        createNewVariable = function (e) {
            e.preventDefault();
            clearAllErrors();
            $.post($container.attr("action"), $addVariable.find(":input").serialize() + "&bamboo.jsMode=true&decorator=rest&confirm=true", function (result) {
                if (result.status.toUpperCase() == "OK") {
                    window.location.reload();
                } else if (result.status.toUpperCase() == "ERROR") {
                    if (result.fieldErrors) {
                        for (var fieldName in result.fieldErrors) {
                            $addVariable.find("input[name='" + fieldName + "']").after(BAMBOO.buildFieldError(result.fieldErrors[fieldName]));
                        }
                    }
                    if (result.errors) {
                        $container.prepend(BAMBOO.buildAUIErrorMessage(result.errors));
                    }
                    var $firstError = $addVariable.find(":input:visible:enabled.errorField:first").focus();
                    if (!$firstError.length) {
                        $addVariable.find(":input:visible:enabled:first").focus();
                    }
                }
            });
        },
        deleteVariable = function (e) {
            e.preventDefault();
            var $this = $(this),
                id = BAMBOO.stripPrefixFromId('deleteVariable_', $this.attr("id"));
            $.post($this.attr("href"), { 'bamboo.jsMode': true, decorator: 'rest', confirm: true }, function (result) {
                if (result.status.toUpperCase() == "OK") {
                    $this.closest("tr").remove();
                }
            });
        },
        handleEditSubmit = function (e) {
            var $input = $(e.currentTarget),
                $loading = opts.$loadingIndicator.clone(),
                name = $input.attr("name"),
                id, $key, $value;

            if (name.indexOf('key_') == 0) {
                id = BAMBOO.stripPrefixFromId('key_', name);
                $key = $input;
                $value = $container.find("input:text[name='value_" + id + "']");
            } else if (name.indexOf('value_') == 0) {
                id = BAMBOO.stripPrefixFromId('value_', name);
                $key = $container.find("input:text[name='key_" + id + "']");
                $value = $input;
            }
            if (id && $key && $value) {
                $loading.insertAfter($input[0]);
                clearFieldErrors($input);
                $.post(opts.updateVariableUrl, {
                    variableId: id,
                    variableKey: $key.val(),
                    variableValue: $value.val(),
                    "bamboo.jsMode": true,
                    decorator: 'rest',
                    confirm: true
                }, function (result) {
                    $loading.remove();
                    var $tr = $input.closest("tr");
                    if (!$tr.find(".focus").length) {
                        $tr.removeClass("active");
                    }
                    if (result.status.toUpperCase() == "OK") {
                        $input.data("lastValidValue", $input.val());
                        if (!$container.find(".focus").length) {
                            $addVariable.removeClass("inactive").find("input").removeAttr("disabled");
                        }
                    } else if (result.status.toUpperCase() == "ERROR") {
                        if (result.fieldErrors) {
                            for (var fieldName in result.fieldErrors) {
                                var $field = (fieldName == "variableValue" ? $value : $key);
                                clearFieldErrors($field);
                                $field.after(BAMBOO.buildFieldError(result.fieldErrors[fieldName]));
                            }
                        }
                        if (result.errors) {
                            $key.after(BAMBOO.buildAUIErrorMessage(result.errors));
                        }
                    }
                });
            }
        },
        handleEditFocus = function (e) {
            $(e.currentTarget).closest("tr").addClass("active");
            $addVariable.addClass("inactive");
        },
        handleEditCancel = function (e) {
            clearFieldErrors($(e.currentTarget).closest("tr").removeClass("active").end());
            $addVariable.removeClass("inactive");
        };
    return {
        init: function (options) {
            $.extend(true, opts, options);

            $(function () {
                $container = $(opts.target).submit(createNewVariable);
                $addVariable = $("#addVariable");
                $container.delegate("a.deleteVariable", "click", deleteVariable);
                BAMBOO.inlineEdit({
                    target: ".inline-edit-view",
                    $delegator: $container,
                    submit: handleEditSubmit,
                    focus: handleEditFocus,
                    cancel: handleEditCancel
                });
            });
        }
    }
}(jQuery);

BAMBOO.ViewTaskList = function($) {
    var opts = {
            collapseAll: null,
            expandAll: null,
            target: null,
            i18n: {
                collapse: null,
                expand: null
            }
        },
        $container = null,
        collapseAll = function() {
            $container.find(".task.expanded > .summary > a.toggle").click();
        },
        expandAll = function() {
            $container.find(".task.collapsed > .summary > a.toggle").click();
        },
        toggle = function() {
            var $toggle = $(this),
                $task = $toggle.closest(".task"),
                $icon = $toggle.children("span.icon");

            if ($task.hasClass("collapsed")) {
                $icon.toggleClass("icon-expand icon-collapse").attr({title: opts.i18n.collapse}).children().text(opts.i18n.collapse);
                $task.children(".details").stop(true, true).slideDown(function() {
                    $task.toggleClass("expanded collapsed");
                });
            } else {
                $icon.toggleClass("icon-expand icon-collapse").attr({title: opts.i18n.expand}).children().text(opts.i18n.expand);
                $task.children(".details").stop(true, true).slideUp(function() {
                    $task.toggleClass("expanded collapsed");
                });
            }
        };
    return {
        init: function(options) {
            $.extend(true, opts, options);

            $(function(){
                $container = $(opts.target);
                $container.delegate(".task > .summary > a.toggle", "click", toggle);
                if (opts.collapseAll) {
                    $(opts.collapseAll).click(collapseAll);
                }
                if (opts.expandAll) {
                    $(opts.expandAll).click(expandAll);
                }
            });
        }
    }
}(jQuery);

/**
 * TODO: extend this with automatic link adding (which will work also for AJAX loaded forms).
 */
BAMBOO.JdkSelectWidget = function($) {
    var opts = {
            clickTarget: "a.addSharedJdkCapability",
            displayTarget: "select.jdkSelectWidget",
            dialog: {
                height: 260,
                width: 540
            }
        },
        addJdkOption = function(result) {
            // add new option to ALL JDK-related selects
            $(opts.displayTarget).append($("<option />", { val: result.capability.label, text: result.capability.label })).val(result.capability.label);
        };
    return {
        init: function(options) {
            $.extend(true, opts, options);

            BAMBOO.simpleDialogForm({
                trigger: opts.clickTarget,
                dialogWidth: opts.dialog.width,
                dialogHeight: opts.dialog.height,
                success: addJdkOption
            });
        }
    }
}(jQuery);

BAMBOO.BuilderSelectWidget = function($) {
    var opts = {
            clickTarget: "a.addSharedBuilderCapability",
            dialog: {
                height: 260,
                width: 540
            }
        },
        addBuilderOption = function(result)
        {
            AJS.$(opts.displayTarget)
                    .append(AJS.$(document.createElement("option")).attr("value", result.capability.label).text(result.capability.label))
                    .val(result.capability.label);
        }
        ;
    return {
        init: function(options) {
            $.extend(true, opts, options);

            BAMBOO.simpleDialogForm({
                trigger: opts.displayTarget + " ~ " + opts.clickTarget,
                dialogWidth: opts.dialog.width,
                dialogHeight: opts.dialog.height,
                success: addBuilderOption
            });
        }
    }
}(jQuery);


AJS.$(function() {
    /* Default options for jQuery's tablesorter plugin */
    // use 'zebra' plugin by default
    AJS.$.tablesorter.defaults.widgets = ['zebra'];
    // use AUI compatible classes
    AJS.$.tablesorter.defaults.widgetZebra = {css: ['', 'zebra']};

    // handleOnSelectShowHide functionality for input[type="checkbox"]
    AJS.$('input:checkbox.handleOnSelectShowHide').each( function() { handleOnSelectShowHide(this); });
});

// handleOnSelectShowHide functionality for input[type="checkbox"]
AJS.$(document).delegate('input:checkbox.handleOnSelectShowHide', 'click', function() { handleOnSelectShowHide(this); });

BAMBOO.JdkSelectWidget.init({});
