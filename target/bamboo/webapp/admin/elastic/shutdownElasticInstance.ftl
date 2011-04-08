[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ManageElasticInstancesAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ManageElasticInstancesAction" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]

[#assign shutdownConfirmation]
[@ui.messageBox type="warning"]
    [#if shutdownAll]
        [@ww.text name='elastic.manage.shutdown.all.confirmation' /]
    [#else]
        [@ww.text name='elastic.manage.shutdown.confirmation']
            [@ww.param]${instanceId}[/@ww.param]
        [/@ww.text]
[/#if]
[/@ui.messageBox]
[/#assign]


<html>
<head>
    [#if shutdownAll]
        <title>[@ww.text name='elastic.manage.shutdown.all.title' /]</title>
    [#else]
        <title>[@ww.text name='elastic.manage.shutdown.title' /]</title>
    [/#if]
    <meta name="decorator" content="adminpage">
</head>

<body>
    [#if shutdownAll]
        [@ww.form titleKey='elastic.manage.shutdown.all.heading'
                  id='confirmElasticInstanceShutdownForm'
                  action='shutdownAllElasticInstances.action' namespace='/admin/elastic'
                  submitLabelKey='global.buttons.confirm'
                  cancelUri='/admin/elastic/manageElasticInstances.action'
                  description=shutdownConfirmation
        ]
            [@ww.hidden name='confirmed' value=true /]
        [/@ww.form]
    [#else]
        [@ww.form titleKey='elastic.manage.shutdown.heading'
                  id='confirmElasticInstanceShutdownForm'
                  action='shutdownElasticInstance.action' namespace='/admin/elastic'
                  submitLabelKey='global.buttons.confirm'
                  cancelUri='/admin/elastic/manageElasticInstances.action'
                  description=shutdownConfirmation
        ]
            [@ww.hidden name='confirmed' value=true /]
            [@ww.hidden name='instanceId' value=instanceId /]
        [/@ww.form]
    [/#if]
</body>
</html>

