[#ftl]
[#-- @implicitly included --]
[#-- @ftlroot "" --]
[#-- @ftlroot "../webapp" --]
[#-- @ftlroot "." --]

[#-- @ftlvariable name="req" type="com.opensymphony.webwork.dispatcher.WebWorkRequestWrapper" --]
[#-- @ftlvariable name="decorator" type="com.opensymphony.module.sitemesh.mapper.DefaultDecorator" --]
[#-- @ftlvariable name="durationUtils" type="com.atlassian.bamboo.utils.DurationUtils" --]
[#-- @ftlvariable name="ctx" type="com.atlassian.bamboo.ww2.FreemarkerContext" --]
[#-- @ftlvariable name="page" type="com.opensymphony.module.sitemesh.parser.FastPage"  --]
[#-- @ftlvariable name="UrlMode" type="com.atlassian.plugin.webresource.UrlMode"  --]
[#-- @ftlvariable name="webResourceManager" type="com.atlassian.plugin.webresource.WebResourceManager"  --]

[#-- Common param names--]
[#-- @ftlvariable name="brs" type="com.atlassian.bamboo.resultsummary.BuildResultsSummary" --]
[#-- @ftlvariable name="cb" type="com.atlassian.bamboo.v2.build.CurrentlyBuilding" --]
[#-- @ftlvariable name="jiraIssueUtils" type="com.atlassian.bamboo.jira.jiraissues.JiraIssueUtils" --]


[#import "/lib/components.ftl" as cp ]
[#import "/lib/dojo.ftl" as dj ]
[#import "freemarker-lib/ui.ftl" as ui ]
[#import "freemarker-lib/functions.ftl" as fn ]
