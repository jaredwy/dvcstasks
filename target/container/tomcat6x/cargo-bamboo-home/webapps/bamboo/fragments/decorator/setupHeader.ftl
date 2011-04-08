<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>[#if title?has_content]${title} - [/#if][#if instanceName?has_content]${instanceName?html}[#else]Atlassian Bamboo[/#if]</title>
    <meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
    <meta name="robots" content="all" />
    <meta name="MSSmartTagsPreventParsing" content="true" />

    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="-1" />

    <link rel="shortcut icon" href="[@cp.getStaticResourcePrefix /]/images/icons/favicon.ico" type="image/x-icon"/>
    <link rel="icon" href="[@cp.getStaticResourcePrefix /]/images/icons/favicon.png" type="image/png" />

    <link type="text/css" rel="stylesheet" href="[@cp.getStaticResourcePrefix /]/styles/main.css" />
    <link type="text/css" rel="stylesheet" href="[@cp.getStaticResourcePrefix /]/styles/main2.css" />
    <link type="text/css" rel="stylesheet" href="[@cp.getStaticResourcePrefix /]/styles/global-static.css" />
    <link type="text/css" rel="stylesheet" href="[@cp.getStaticResourcePrefix /]/styles/forms.css" />
    <link type="text/css" rel="stylesheet" href="[@cp.getStaticResourcePrefix /]/styles/setup/setup.css"/>
    <link type="text/css" rel="stylesheet" href="[@cp.getStaticResourcePrefix /]/styles/setup/aui-3.3-forms.css" />
    <!--[if IE]>
        <link type="text/css" rel="stylesheet" href="[@cp.getStaticResourcePrefix /]/styles/setup/aui-3.3-forms-ie.css"/>
    <![endif]-->
    <link type="text/css" rel="stylesheet" href="[@cp.getStaticResourcePrefix /]/styles/setup/aui-3.3-messages.css" />
    <script type="text/javascript" src="[@cp.getStaticResourcePrefix /]/scripts/setup/jquery/jquery-1.3.2-min.js"></script>
    <script type="text/javascript" src="[@cp.getStaticResourcePrefix /]/scripts/setup/bambooSetup.js"></script>
    <script type="text/javascript" src="[@cp.getStaticResourcePrefix /]/scripts/setup/raphael/raphael-min.js"></script>

    <script type="text/javascript">
        var BAMBOO = window.BAMBOO || {};
        BAMBOO.contextPath = '${req.contextPath}';
    </script>
${head?if_exists}
</head>
<body>
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

