[#-- @ftlvariable name="build" type="com.atlassian.bamboo.build.Buildable" --]
[#-- @ftlvariable name="buildSummary" type="com.atlassian.bamboo.resultsummary.BuildResultsSummary" --]
[#include "notificationCommonsText.ftl" ]
[#assign authors = buildSummary.uniqueAuthors/]
[#if buildSummary.successful]
[@buildNotificationTitleText build buildSummary/] was SUCCESSFUL[#if buildSummary.testResultsSummary.totalTestCaseCount >0] [@showTestSummary buildSummary.testResultsSummary/][/#if].[#if authors?has_content] [@showAuthorSummary authors/][/#if][#lt]
[#else]
[@buildNotificationTitleText build buildSummary/] has FAILED[#if buildSummary.testResultsSummary.totalTestCaseCount >0] [@showTestSummary buildSummary.testResultsSummary/][/#if].[#if authors?has_content] [@showAuthorSummary authors/][/#if][#lt]
[/#if]
${baseUrl}/browse/${buildSummary.buildResultKey}/