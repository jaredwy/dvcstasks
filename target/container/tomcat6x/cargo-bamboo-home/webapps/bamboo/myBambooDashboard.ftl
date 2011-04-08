[#-- @ftlvariable name="action" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.webwork.StarterAction" --]

[#if user??]
    [#assign rssSuffix="&amp;os_authType=basic" /]
[#else]
    [#assign rssSuffix="" /]
[/#if]
<html>
<head>
    <title>[@ww.text name='dashboard.title' /]</title>
    <link rel="alternate" type="application/rss+xml" title="Bamboo RSS feed" href="${req.contextPath}/rss/createAllBuildsRssFeed.action?feedType=rssAll${rssSuffix}"/>
</head>
<body>
<h1>${instanceName?html}</h1>

[@cp.dashboardSubMenu selectedTab="myTab"]
   [#include "./displayMyBuildSummaries.ftl"/]
[/@cp.dashboardSubMenu]

[#if myFavouritesUrl?has_content]
    <script type="text/javascript">
        AJS.$(function() {
              AsynchronousRequestManager.init(".asynchronous", null, function () {
                      reloadPanel("myFavourites", "${myFavouritesUrl}");
              });
        });
    </script>
[/#if]

<script type="text/javascript">
    AJS.$(document).delegate("#myFavourites .headerOpen", "click", function (e) {
        if (!AJS.$(e.originalTarget).hasClass("projectLink")) {
            AJS.$(this).hide().siblings(".headerClosed").show().end().siblings(".buildList").hide();
            saveToConglomerateCookie(BAMBOO_DASH_DISPLAY_TOGGLES, this.id.replace("_toggler_on", ""), '0');
        }
    });

    AJS.$(document).delegate("#myFavourites .headerClosed", "click", function (e) {
        if (!AJS.$(e.originalTarget).hasClass("projectLink")) {
            AJS.$(this).hide().siblings(".headerOpen, .buildList").show();
            saveToConglomerateCookie(BAMBOO_DASH_DISPLAY_TOGGLES, this.id.replace("_toggler_off", ""), null);
        }
    });
</script>

</body>
</html>
