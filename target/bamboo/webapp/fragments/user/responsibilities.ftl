[#-- @ftlvariable name="action" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#import "/fragments/plan/displayBuildPlansList.ftl" as planList]
[@planList.displayBuildPlansList id='responsibilities' builds=responsibleForBuilds /]