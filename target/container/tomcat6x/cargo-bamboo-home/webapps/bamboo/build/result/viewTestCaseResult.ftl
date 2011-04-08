[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ViewTestCaseResultAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ViewTestCaseResultAction" --]

<html>
<head>
    <title>[@ui.header pageKey='buildResult.testCase.title' object='${build.key}-${buildResultsSummary.buildNumber}
        ${testCaseResult.methodName?html}' title=true/]</title>
    <meta name="tab" content="tests"/>

</head>

<body>

    <h2>${testCaseResult.methodName?html}</h2>

    [@ww.url id='testCaseUrl' value=fn.getViewTestCaseHistoryUrl(buildKey, testCaseResult.testCase.id) /]

    <p>
        [@ww.text name='buildResult.testCase.summary']
            [@ww.param]${testCaseResult.methodName?html}[/@ww.param]
            [@ww.param name="value" value="${buildResultsSummary.buildNumber}"/]
            [@ww.param]${build.name}[/@ww.param]
        [/@ww.text]
        <a href="${testCaseUrl}">[@ww.text name='buildResult.testCase.history'/]</a>
    </p>

    [@ui.bambooInfoDisplay float=true]
        [@ww.label labelKey='buildResult.testCase.description' name='testCaseResult.methodName'/]
        [@ww.label labelKey='buildResult.testCase.class' value='${testClassResult.name?html}'/]
        [@ww.label labelKey='buildResult.testCase.method' name='testCaseResult.name' /]
    [/@ui.bambooInfoDisplay]

    [@ui.bambooInfoDisplay float=true]
        [@ww.label labelKey='buildResult.testCase.duration' value='${testCaseResult.getPrettyDuration()}' /]
        [#assign  statusValue]
            ${testCaseResult.state.displayName}[#if  testCaseResult.deltaState != "NONE" && testCaseResult.deltaState != "PASSING"] (${testCaseResult.deltaState.displayName})[/#if]
        [/#assign]
        [@ww.label labelKey='buildResult.testCase.status' value='${statusValue}' cssClass='${testCaseResult.state.displayName}' /]

    [/@ui.bambooInfoDisplay]

    [@ui.clear /]





[#if testCaseResult.errors.size() gt 0]
    <div class="testCaseErrorLogSection">
        <h2>Error Log</h2>
        <pre class="outputErrorLog">[#rt]
            [#list testCaseResult.errors as error]
                ${error.content?trim?html}[#t]
            [/#list]
        </pre>[#lt]
    </div>
[/#if]

</body>
</html>
