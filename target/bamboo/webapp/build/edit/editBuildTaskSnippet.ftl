[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.task.ConfigureBuildTasks" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.task.ConfigureBuildTasks" --]
[@ww.text id="tasksConfigFormTitle" name="tasks.config.form.title"]
    [@ww.param]${taskName}[/@ww.param]
[/@ww.text]
[@ww.form   action=submitAction
            namespace="/build/admin/edit"
            submitLabelKey="global.buttons.update"
            cancelUri="/build/admin/edit/editBuildTasks.action?planKey=${planKey}"
            title=tasksConfigFormTitle
            cssClass="top-label"]
    [#if submitAction == "updateTask"]
        [@ww.param name="buttons"][#t]
            <a href="[@ww.url action="confirmDeleteTask" namespace="/build/admin/edit" planKey=planKey taskId=taskId /]" class="delete" tabindex="-1" title="[@ww.text name='tasks.delete' /]">[@ui.icon type="task-delete" textKey="global.buttons.delete" /]</a>[#t]
        [/@ww.param][#t]
    [/#if]
    [@ww.textfield name="userDescription" labelKey="tasks.userDescription" cssClass="long-field"/]

    ${editHtml!}

    [@ww.hidden name="createTaskKey"/]
    [@ww.hidden name="taskId"/]
    [@ww.hidden name="planKey"/]
[/@ww.form]