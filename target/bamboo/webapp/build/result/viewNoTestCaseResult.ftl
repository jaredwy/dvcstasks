[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ViewTestCaseResultAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ViewTestCaseResultAction" --]

<html>
<head>
    <title>[@ui.header pageKey='buildResult.testCase.title' object='${build.key}-${buildResultsSummary.buildNumber}
        ${action.methodName?html}' title=true/]</title>
    <meta name="tab" content="tests"/>
</head>

<body>
    <h2>[@ww.text name="${action.methodName}"/]</h2>
    <div class="noResult">
        <div class="message">[@ww.text name='buildResult.testCase.noTestCaseResult'/]</div>
        <a href="${req.contextPath}/browse/${build.key}/test/case/${action.testCaseId}">[@ww.text name='buildResult.testCase.history'/]
    </div>
</body>
</html>
