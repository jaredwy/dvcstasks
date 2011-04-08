[#-- @ftlvariable name="action" type="com.atlassian.bamboo.rest.ListBuildNames" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.rest.ListBuildNames" --]
<response>
[#if plans?has_content]
[#list plans as plan]
    <build enabled="${(action.isEnabled(plan))?string}">
        <name>${plan.name?xml}</name>
        <key>${plan.key?xml}</key>
    </build>
[/#list]
[/#if]
</response>