[#-- @ftlvariable name="action" type="com.atlassian.bamboo.rest.ListProjectNames" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.rest.ListProjectNames" --]
<response>
    [#if projects?exists]
    [#list projects as project]
    <project>
        <name>${project.name}</name>
        <key>${project.key}</key>
    </project>
    [/#list]
    [/#if]
</response>