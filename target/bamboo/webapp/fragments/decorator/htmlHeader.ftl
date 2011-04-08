<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>[#if title?has_content]${title} - [/#if][#if ctx?? && ctx.instanceName?has_content]${ctx.instanceName?html}[#else]Atlassian Bamboo[/#if]</title>
    <meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
    <meta name="robots" content="all" />
    <meta name="MSSmartTagsPreventParsing" content="true" />

    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="-1" />

    <link rel="shortcut icon" href="[@cp.getStaticResourcePrefix /]/images/icons/favicon.ico" type="image/x-icon"/>
    <link rel="icon" href="[@cp.getStaticResourcePrefix /]/images/icons/favicon.png" type="image/png" />

    <!--[if lt IE 9]>
    <script src="[@cp.getStaticResourcePrefix /]/scripts/html5.js"></script>
    <![endif]-->
    ${webResourceManager.requireResourcesForContext("atl.general")}
    ${webResourceManager.requiredResources}

    <script type="text/javascript">
        var BAMBOO = window.BAMBOO || {};
        BAMBOO.reloadDashboardTimeout = 20;
        BAMBOO.contextPath = '${req.contextPath}';
        AJS.$(addConfirmationToLinks);
    </script>
${head?if_exists}
</head>
<body[#if decorator??] class="dec_${decorator.name?replace(".", "_")}"[/#if]>
<div id="container">
    <ul id="top">
        <li id="skipNav">
            <a href="#menu">Skip to navigation</a>
        </li>
        <li>
            <a href="#content">Skip to content</a>
        </li>
    </ul>
    <div id="nonFooter">

