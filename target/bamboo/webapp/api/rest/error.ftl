[#-- @ftlvariable name="action" type="com.atlassian.bamboo.rest.ExecuteBuild" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.rest.ExecuteBuild" --]
<errors>
    [#list actionErrors as error]
    <error>${error?xml}</error>
    [/#list]
</errors>