[#-- @ftlvariable name="action" type="com.atlassian.bamboo.index.ReindexAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.index.ReindexAction" --]
<html>
<head>
    <title>[@ww.text name='index.title' /]</title>
</head>

<body>
<h1>[@ww.text name='index.title' /]</h1>

[@ww.form action="reindex" submitLabelKey='index.button'  titleKey='index.form.title']
    <p class="description">
    [@ww.text name='index.description' ]
        [@ww.param]${dateUtils.formatDurationPretty(systemStatisticsBean.approximateIndexTime)}[/@ww.param]
    [/@ww.text]
    </p>
    [@ww.radio labelKey='index.options'
               name='indexOption'
               listKey='name' listValue='label'
               list=indexOptions ]
    [/@ww.radio]
[/@ww.form]
</body>
</html>
