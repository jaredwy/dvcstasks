[#-- @ftlvariable name="action" type="com.atlassian.bamboo.rest.GetProjectDetails" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.rest.GetProjectDetails" --]
<response>
    [#if project?exists]
    <project>
        <name>${project.name}</name>
        <key>${project.key}</key>
        <currentStatus>${project.currentStatus}</currentStatus>
        [#if project.labellings?exists]
        [#list project.labellings as label]
            [#if label.label.name != ':favourite']
            <labels>
                <label>${label.label.name}</label>
                <label>${label.label.namespace}</label>
            </labels>
            [/#if]
        [/#list]
        [/#if]
    </project>
    [/#if]
</response>