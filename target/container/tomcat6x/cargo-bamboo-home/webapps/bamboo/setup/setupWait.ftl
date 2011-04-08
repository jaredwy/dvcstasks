[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.setup.FinishSetupAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.setup.FinishSetupAction" --]
<div>
    <div id="setupWaitMessage"><b>${waitMessage}</b></div>
    <div id="candyBar"></div>
</div>

<script type="text/JavaScript">

    var refreshStatus = function()
    {
       jQuery.post("${req.contextPath}${currentUrl?js_string}?statusRequest=true", null, onComplete, "json");
    };

    var onComplete = function(data) {
       if (data.completed)
       {
           [#if completedUrl?has_content]
                window.location = "${req.contextPath}${completedUrl}";
           [#elseif currentUrl?has_content]
                window.location = "${req.contextPath}${currentUrl}";
           [#else]
                location.reload(true);
           [/#if]
       }
       setTimeout(refreshStatus, 2000);
    };

    jQuery(document).ready(function(){
        setTimeout(refreshStatus, 2000);
    });

    window.onload = function () {
       spinner("candyBar", 40, 60, 12, 15, "#444");
    };
</script>
