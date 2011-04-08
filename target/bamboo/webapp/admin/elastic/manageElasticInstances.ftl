[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ManageElasticInstancesAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ManageElasticInstancesAction" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]
<html>
<head>
    <title>[@ww.text name='elastic.manage.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>

<body>
    <h1>[@ww.text name='elastic.manage.heading' /]</h1>
    <p>
        [@ww.text name='elastic.manage.description'/]<br />
        You can view <a href="${req.contextPath}/admin/elastic/allElasticInstances.action">all elastic instances that are running on your account</a>.
    </p>

    [@dj.reloadPortlet id='elasticWidget' url='${req.contextPath}/ajax/viewElasticSnippet.action' reloadEvery=10]
            [@ww.action name="viewElasticSnippet" namespace="/ajax" executeResult="true"]
            [/@ww.action]
    [/@dj.reloadPortlet]

    [@ui.clear/]
</body>
</html>

