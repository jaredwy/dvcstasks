[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.labels.ViewBuildResultsForLabelAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.labels.ViewBuildResultsForLabelAction" --]
<html>
<head>
	<title> [@ui.header pageKey='Label' object='${labelName?html}' title=true /]</title>
</head>

<body>
    [@ww.url id='allLabelsUrl'
         action='viewLabels'
         namespace='/build/label' /]

    <p id="labelCrumb">View: <a href="${allLabelsUrl}">All Labels</a></p>
    <h1>Label: ${labelName?html}</h1>
    <div class="section">

    Below are the ${resultsList.size()} build results with label <strong>${labelName?html}</strong>.

    [@ww.action name="viewBuildResultsTable" namespace="/build" executeResult="true"  ]
    [/@ww.action]

    [@ww.url id='rssFeedUrl'
             action='createLabelRssFeed'
             namespace='/rss'
             labelName='${labelName?html}' /]

    <a href="${rssFeedUrl}"><img src="${req.contextPath}/images/rss.gif" border="0" hspace="2" align="absmiddle" title="Point your rss reader at this link"></a>
    <a href="${rssFeedUrl}">Feed for builds labelled ${labelName?html}</a>
    </div>
</body>
</html>