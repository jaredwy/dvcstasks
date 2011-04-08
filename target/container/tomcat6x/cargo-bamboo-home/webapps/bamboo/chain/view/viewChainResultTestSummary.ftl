[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.ViewChainResult" --]

[#import "/lib/tests.ftl" as tests]

<html>
<head>
	<title>[@ui.header pageKey='buildResult.tests.title' object='${plan.name} ${chainResultNumber}' title=true /]</title>
    <meta name="tab" content="tests"/>
</head>

<body>

[@ui.header pageKey='buildResult.tests.title' /]
[#if chainResult?has_content && chainResult.finished && chainResult.testResults??]
    [#assign testSummary = chainResult.testResultsSummary /]
    [#assign testResults = filteredTestResults /]
    [@tests.displayTestInfo testSummary=testSummary /]

    [@tests.displayTestSummary testResults=testResults testSummary=testSummary showJob=true /]

[/#if]

</body>
</html>