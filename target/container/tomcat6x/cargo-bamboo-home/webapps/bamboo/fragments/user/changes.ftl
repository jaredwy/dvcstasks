[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.user.ViewUserSummary" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.user.ViewUserSummary" --]
[#assign buildCount = author.numberOfTriggeredBuilds /]
[#if author.triggeredBuildResults?has_content]
    [#import "/fragments/buildResults/displayAuthorBuildsTable.ftl" as buildList]
    [@buildList.displayAuthorBuildsTable buildResults=author.triggeredBuildResults totalBuildNumber = buildCount/]
[#elseif buildCount > 0]
    You have insufficient permissions to see the changes. 
[#else]
    Bamboo has not found any changes made by you.
[/#if]