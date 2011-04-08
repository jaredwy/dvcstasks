function addUniversalOnload(myFunction)
{
    jQuery(document).ready(myFunction);
}

function attachHandler(object, event, myFunction)
{
    jQuery("#" + object).bind(event, myFunction);
}

/**
 * Displays a javascript "waiting" spinner.  Depends on Raphael
 * @param holderid - the element to put the spinner inside
 * @param R1 - the inner circle radius (optional)
 * @param R2 - the outer circle radius (optional)
 * @param count - number of strokes to have in the circle (optional)
 * @param stroke_width - the width of each stroke (optional)
 * @param colour - colour to be used as the basis of the spinner. - try "rainbow" for some pretty colours (optional)
 */
function spinner(holderid, R1, R2, count, stroke_width, colour) {
    var sectorsCount = count || 12,
        color = colour || "#fff",
        width = stroke_width || 15,
        r1 = Math.min(R1, R2) || 35,
        r2 = Math.max(R1, R2) || 60,
        cx = r2 + width,
        cy = r2 + width,
        r = Raphael(holderid, r2 * 2 + width * 2, r2 * 2 + width * 2),

        sectors = [],
        opacity = [],
        beta = 2 * Math.PI / sectorsCount,

        pathParams = {stroke: color, "stroke-width": width, "stroke-linecap": "round"};
        Raphael.getColor.reset();
    for (var i = 0; i < sectorsCount; i++) {
        var alpha = beta * i - Math.PI / 2,
            cos = Math.cos(alpha),
            sin = Math.sin(alpha);
        opacity[i] = 1 / sectorsCount * i;
        sectors[i] = r.path([["M", cx + r1 * cos, cy + r1 * sin], ["L", cx + r2 * cos, cy + r2 * sin]]).attr(pathParams);
        if (color == "rainbow") {
            sectors[i].attr("stroke", Raphael.getColor());
        }
    }
    var tick;
    (function ticker() {
        opacity.unshift(opacity.pop());
        for (var i = 0; i < sectorsCount; i++) {
            sectors[i].attr("opacity", opacity[i]);
        }
        r.safari();
        tick = setTimeout(ticker, 2000 / sectorsCount);
    })();
    return function () {
        clearTimeout(tick);
        r.remove();
    };
}

function selectFirstFieldOfForm(formId) {
    var $form = jQuery("#" + formId),
        $firstError = $form.find(":input:visible:enabled.errorField:first").focus();
    if (!$firstError.length) {
        $form.find(":input:visible:enabled:first").focus();
    }
}

/*
 Runs on a change of a
*/
function handleOnSelectShowHide(sel)
{
    var hideClassName = "dependsOn" + sel.name;
    hideClassName = hideClassName.replaceAll(".", "\\.");

    var switchValue = getSwitchValue(sel);
    if (!switchValue && sel.type == 'radio') return;

    var selector = "#" + sel.form.id + " ." + hideClassName;

    var showPattern = "showOn" + switchValue;
    jQuery(selector).each(function()
    {
        var deps = this;
        if (jQuery(deps).hasClass(showPattern))
        {
            deps.style.display = '';
        }
        else
        {
            deps.style.display = 'none';
        }
    });
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

// Not 100% sure what this stuff is for...

String.prototype.replaceAll = function(pcFrom, pcTo)
{
    var MARKER = "js___bmbo_mrk"
    var i = this.indexOf(pcFrom);
    var c = this;
    while (i > -1)
    {
        c = c.replace(pcFrom, MARKER);
        i = c.indexOf(pcFrom);
    }

    i = c.indexOf(MARKER);
    while (i > -1)
    {
        c = c.replace(MARKER, pcTo);
        i = c.indexOf(MARKER);
    }

    return c;
}


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
