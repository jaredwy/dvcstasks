[#macro editConfigurationPage plan selectedTab]
<html>
<head>
    <title>[@ui.header pageKey='build.configuration.edit.title.long' object='${plan.name}' title=true /]</title>
    <meta name="tab" content="${selectedTab}" />
</head>
<body>
[#nested /]
</body>
</html>
[/#macro]
