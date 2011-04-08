[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.admin.ViewChainAuditLog" --]
<html>
<head>
    <title>[@ui.header pageKey='chain.auditLog.title' object='${plan.name}' title=true /]</title>
    <meta name="tab" content="auditLog"/>
</head>
<body>
    [@ui.header pageKey="chain.auditLog.title"/]
    [#if filterStart > 0 || filterEnd >0]
        <h2>
            [@ww.text name='auditlog.configuration.recent']
                [@ww.param]${filterStartDate?datetime}[/@ww.param]
                [@ww.param]${filterEndDate?datetime}[/@ww.param]
            [/@ww.text]
        </h2>
        <a href="[@ww.url action='viewChainAuditLog' namespace='/chain/admin/config' planKey=planKey /]">
                [@ww.text name='auditlog.switch.view'][@ww.param]${plan.name}[/@ww.param][/@ww.text]</a>
    [#else]
        <h2>
            [@ww.text name='auditog.configuration.changes'/]
        </h2>
        [#if pager.getPage()??]
            <a href="[@ww.url action='deleteChainAuditLog' namespace='/chain/admin/config' planKey=planKey/]"
                               class="requireConfirmation"
                               title="[@ww.text name='auditlog.delete.confirmation'/]">
            [@ww.text name='auditlog.delete'][@ww.param]${plan.name}[/@ww.param][/@ww.text]</a>
        [/#if]
    [/#if]
    [@cp.configChangeHistory pager=pager jobMap=jobMap/]

</body>
</html>