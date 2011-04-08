[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.author.ViewAuthors" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.author.ViewAuthors" --]
<html>
<head>
    <title>[@ui.header pageKey='author.report' object='' title=true /]</title>


</head>

<body>
<h1>User and Author Statistics</h1>

[@cp.authorSubMenu selectedTab='report' ]
    [@ui.header pageKey='author.report' /]
    <p>[@ww.text name='report.author.description' /]</p>
    <div class="reportParam">
    [#if !authors?has_content]
        [@ui.messageBox type="warning" titleKey="report.author.warning" /]
    [#else]
        [@ww.form action='generateAuthorReport' submitLabelKey='global.buttons.submit' titleKey='report.input.title' method='get']
        [@ww.select labelKey='report.name' name='reportKey' list=availableReports listKey='key' listValue='value' optionDescription='description'
                    headerKey='' headerValue='Select...'/]
        [@ww.select labelKey='Authors'
                    name='selectedAuthorNames'
                    list=authors
                    listKey='name'
                    listValue='name'
                    multiple="true" ]
        [/@ww.select]
        [@ww.select labelKey='report.group.by'
                    name='groupByPeriod'
                    list=availableGroupBy
                    listKey='key'
                    listValue='value']
                    [#if groupByPeriod == 'AUTO' && resolvedAutoPeriod?exists]
                        [@ww.param name='description']Report is grouped by ${availableGroupBy.get(resolvedAutoPeriod)}.[/@ww.param]
                    [/#if]
        [/@ww.select]
        [/@ww.form]
    [/#if]

    </div>


    [#if dataset?has_content]
        <div class="reportDisplay">

        [#if reportKey?exists && availableReports.containsKey(reportKey)]
            <h2>${availableReports.get(reportKey)}</h2>
        [/#if]
        [@dj.tabContainer tabViewId="reportContents" headings=[action.getText('report.tab.chart.title'),action.getText('report.tab.data.title')] selectedTab='${selectedTab?if_exists}']
            [@dj.contentPane labelKey='report.tab.chart.title']
                    [@ww.action name="viewAuthorChart" namespace="/charts" executeResult="true" /]
            [/@dj.contentPane]
            [@dj.contentPane labelKey='report.tab.data.title' ]
                [#assign numSeries=dataset.seriesCount - 1/]
                [#if numSeries gt -1]
                    <table class="aui">
                        <thead>
                            <tr>
                                <th></th>
                                [#list 0..numSeries as seriesIndex]
                                    [#assign seriesKey=dataset.seriesKey(seriesIndex) /]
                                    <th>${seriesKey}</th>
                                [/#list]
                            </tr>
                        </thead>
                        <tbody>
                            [#assign numItems=dataset.getItemCount() - 1/]
                            [#list 0..numItems as itemIndex]
                                <tr>
                                    <th>${dataset.timePeriod(itemIndex)}</th>
                                    [#list 0..numSeries as seriesIndex]
                                        <td>${dataset.getYValue(seriesIndex, itemIndex)?string('#.##')}</td>
                                    [/#list]
                                </tr>
                            [/#list]
                        </tbody>
                    </table>
                [/#if]
            [/@dj.contentPane]
        [/@dj.tabContainer]
        </div>
    [/#if]

[/@cp.authorSubMenu]
</body>
</html>