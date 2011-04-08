[@ww.text id="taskTypesTitle" name="tasks.types.title" /]
[@ww.text id="tasksAddAbandon" name="tasks.add.abandon" /]
<div id="task-setup">
    <div id="task-list">
        <h2 class="assistive">[@ww.text name="tasks.title" /]</h2>
        <ul>
        [#list existingTasks as taskDef]
        [@taskListItem id=taskDef.id name=taskDef.name!?html description=taskDef.userDescription!?html /]
        [/#list]
            <li class="final-tasks-bar">
                <h3>[@ww.text name="tasks.final.title" /]</h3>

                <div>[@ww.text name="tasks.final.description" /]</div>
            </li>
        [#list finalisingTasks as taskDef]
        [@taskListItem id=taskDef.id name=taskDef.name!?html description=taskDef.userDescription!?html final=true /]
        [/#list]
        </ul>
        <div class="aui-toolbar inline">
            <ul class="toolbar-group">
                <li class="toolbar-item">
                    <a href="[@ww.url action="viewTaskTypes" namespace="/build/admin/edit" planKey=planKey returnUrl=currentUrl /]" id="addTask" class="toolbar-trigger">[@ww.text name="tasks.add" /]</a>
                </li>
            </ul>
        </div>
    </div>
    <div id="task-config"></div>
</div>
<script type="text/x-template" title="taskListItem-template">
[@taskListItem id="{id}" name="{name}" description="{description}" /]
</script>
<script type="text/x-template" title="icon-template">
[@ui.icon type="{type}" /]
</script>
<script type="text/javascript">
    BAMBOO.TASKS.tasksConfig.init({
        addTaskTrigger: "#addTask",
        taskConfigContainer: "#task-config",
        taskList: "#task-list > ul",
        taskTypesDialog: {
            header: "${taskTypesTitle?js_string}"
        },
        templates: {
            taskListItem: "taskListItem-template",
            iconTemplate: "icon-template"
        },
        i18n: {
            cancel: "[@ww.text name='global.buttons.cancel' /]",
            confirmAbandonTask: "${tasksAddAbandon?js_string}",
            tasksAddSuccess: "[@ww.text name='tasks.add.success' /]",
            tasksEditSuccess: "[@ww.text name='tasks.edit.success' /]",
            tasksDeleteSuccess: "[@ww.text name='tasks.delete.success' /]"
        },
        moveTaskUrl: "[@ww.url action="moveTask" namespace="/build/admin/ajax" planKey=planKey /]",
        moveFinalBarUrl: "[@ww.url action="moveFinalBar" namespace="/build/admin/ajax" planKey=planKey /]"
    });
</script>


[#macro taskListItem id name description="" final=false]
<li class="task[#if final] final[/#if]" data-task-id="${id}">
    <a href="[@ww.url action="editTask" namespace="/build/admin/edit" planKey=planKey /]&amp;taskId=${id}">
        <h3 class="task-title">${name}</h3>
        [#if description?has_content]
            <div class="task-description">${description}</div>
        [/#if]
    </a>
</li>
[/#macro]