[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.task.ConfigureBuildTasks" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.task.ConfigureBuildTasks" --]

[#if availableTasks?has_content]
    <ol class="task-type-list">
        [#list availableTasks as taskType]
        <li>
            <span class="task-type-icon-holder"></span>
            <h3 class="task-type-title"><a href="[@ww.url action="addTask" namespace="/build/admin/edit" planKey=planKey createTaskKey=taskType.completeKey returnUrl=returnUrl /]">${taskType.name?html}</a></h3>
            [#if taskType.description??]
                <div class="task-type-description">${taskType.description?html}</div>
            [/#if]
        </li>
        [/#list]
    </ol>
[/#if]