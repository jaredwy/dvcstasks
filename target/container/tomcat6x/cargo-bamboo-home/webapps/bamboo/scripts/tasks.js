var BAMBOO = window.BAMBOO || {};
BAMBOO.TASKS = {};

BAMBOO.TASKS.tasksConfig = function ($) {
    var defaults = {
        addTaskTrigger: null,
        taskConfigContainer: null,
        taskList: null,
        taskTypesDialog: {
            header: null,
            width: 665,
            height: 530
        },
        templates: {
            taskListItem: null,
            iconTemplate: null
        },
        i18n: {
            cancel: "Cancel",
            confirmAbandonTask: null,
            tasksAddSuccess: null,
            tasksEditSuccess: null,
            tasksDeleteSuccess: null
        },
        moveTaskUrl: null,
        moveFinalBarUrl: null
    },
    options,
    $taskTypesContainer = $('<div class="aui-dialog-content"/>'),
    $taskConfigContainer,
    $taskList,
    $loadingIndicator,
    $finalTasksBar,
    taskTypesDialog,
    displaySuccessMessage = function (message) {
        var $dummy = $("<div/>");
        AJS.messages.success($dummy, { title: message, closeable: false });
        var $successMsg = $dummy.children();
        $taskConfigContainer.html($successMsg);
        setTimeout(function(){
            $successMsg.fadeOut(function(){ $successMsg.remove(); });
        }, 3000);
    },
    setFocus = function () {
        var $firstError = $taskConfigContainer.find(":input:visible:enabled.errorField:first").focus();
        if (!$firstError.length) {
            $taskConfigContainer.find(":input:visible:enabled:first").focus();
        }
    },
    setupAsyncForm = function ($taskListItem) {
        BAMBOO.asyncForm({
            $delegator: $taskConfigContainer,
            target: "form",
            success: function (data) {
                displaySuccessMessage(($taskListItem.hasClass("unsaved") ? options.i18n.tasksAddSuccess : options.i18n.tasksEditSuccess));
                var $newTaskListItem = $(AJS.template.load(options.templates.taskListItem).fill({ name: data.task.name, description: data.task.description, id: data.task.id }).toString()).addClass("active");
                $taskListItem.replaceWith($newTaskListItem);
                setTimeout(function(){ $newTaskListItem.removeClass("active"); }, 0); // this is so that the class doesn't get removed immediately after the DOM element is replaced which would causes the CSS transition (fading) not to be applied
            },
            cancel: function (e) {
                $taskConfigContainer.empty();
                if ($taskListItem.hasClass("unsaved")) {
                    $taskListItem.remove();
                } else {
                    $taskListItem.removeClass("active");
                }
            },
            formReplaced: setFocus
        });
    },
    isOkayToProceedWithUnsavedTask = function () {
        var $unsavedTask = $taskList.find(".unsaved");
        if ($unsavedTask.length) {
            if (confirm(options.i18n.confirmAbandonTask)) {
                $unsavedTask.remove();
                $taskConfigContainer.empty();
            } else {
                return false;
            }
        }
        return true;
    },
    addTask = function (e) {
        e.preventDefault();

        if (!$finalTasksBar) {
            $finalTasksBar = $taskList.find(".final-tasks-bar");
        }

        var $taskTypeListItem = $(this),
            $taskConfigLink = $taskTypeListItem.find(".task-type-title > a"),
            taskName = $taskConfigLink.text(),
            $loadingTaskConfigurationIndicator = $(AJS.template.load(options.templates.iconTemplate).fill({ type: "loading" }).toString()).appendTo($taskTypeListItem);

        $.ajax({
            url: $taskConfigLink.attr("href"),
            data: { decorator: 'rest', confirm: true },
            success: function (html) {
                $taskConfigContainer.html(html);
                var $taskListItem = $(AJS.template.load(options.templates.taskListItem).fill({ name: taskName, description: "", id: "" }).toString()).insertBefore($finalTasksBar);
                $taskListItem.addClass("active unsaved").siblings().removeClass("active");
                setupAsyncForm($taskListItem);
                taskTypesDialog.remove();
                setFocus();
            },
            cache: false
        });
    },
    editTask = function (e) {
        e.preventDefault();
        if (!$taskConfigContainer) {
            $taskConfigContainer = $(options.taskConfigContainer);
        }
        if (!$taskList) {
            $taskList = $(options.taskList);
        }

        var $taskListItem = $(this);

        if ($taskListItem.hasClass("active") || !isOkayToProceedWithUnsavedTask()) {
            setFocus();
            return false;
        }

        var $taskConfigLink = $taskListItem.find("> a"),
            $loadingTaskConfigurationIndicator = $(AJS.template.load(options.templates.iconTemplate).fill({ type: "loading" }).toString()).appendTo($taskListItem);

        $.ajax({
            url: $taskConfigLink.attr("href"),
            data: { decorator: 'rest', confirm: true },
            success: function (html) {
                $taskConfigContainer.html(html);
                $loadingTaskConfigurationIndicator.remove();
                $taskListItem.addClass("active").siblings().removeClass("active");
                setupAsyncForm($taskListItem);
                setFocus();
            },
            cache: false
        });
    },
    setupTaskTypesDialogContent = function (html) {
        $loadingIndicator.hide();
        $taskTypesContainer.html(html);
        taskTypesDialog.addPanel("All", $taskTypesContainer).show();
    },
    showTaskTypesPicker = function (e) {
        e.preventDefault();
        var $addTaskTrigger = $(this),
            header = options.taskTypesDialog.header ? options.taskTypesDialog.header : $addTaskTrigger.text();

        if (!$taskConfigContainer) {
            $taskConfigContainer = $(options.taskConfigContainer);
        }
        if (!$taskList) {
            $taskList = $(options.taskList);
        }

        if (!isOkayToProceedWithUnsavedTask()) {
            setFocus();
            return false;
        }

        if (!$loadingIndicator) {
            $loadingIndicator = $(AJS.template.load(options.templates.iconTemplate).fill({ type: "loading" }).toString()).insertAfter($addTaskTrigger.closest(".aui-toolbar"));
        } else {
            $loadingIndicator.show();
        }

        taskTypesDialog = new AJS.Dialog({
            width: options.taskTypesDialog.width,
            height: options.taskTypesDialog.height,
            keypressListener: function (e) {
                if (e.which == VK_ESCAPE) {
                    taskTypesDialog.remove();
                }
            }
        });

        if (header) {
            taskTypesDialog.addHeader(header);
        }
        taskTypesDialog.addCancel(options.i18n.cancel, function () { taskTypesDialog.remove(); });

        $.ajax({
            url: $addTaskTrigger.attr("href"),
            data: { decorator: 'rest', confirm: true },
            success: setupTaskTypesDialogContent,
            cache: false
        });

        $taskTypesContainer.delegate(".task-type-list > li", "click", addTask);
    };
    return {
        init: function (opts) {
            options = $.extend(true, defaults, opts);

            $(document).delegate(options.addTaskTrigger, "click", showTaskTypesPicker).delegate(options.taskList + " > .task", "click", editTask);
            $(document).delegate("#finalisePlanCreation, #finaliseJobCreation", "submit", function (e) {
                if (!isOkayToProceedWithUnsavedTask()) {
                    e.preventDefault();
                }
            });

            BAMBOO.simpleDialogForm({
                trigger: options.taskConfigContainer + ' .delete',
                dialogWidth: 540,
                dialogHeight: 160,
                success: function (data) {
                    if (!$taskConfigContainer) {
                        $taskConfigContainer = $(options.taskConfigContainer);
                    }
                    if (!$taskList) {
                        $taskList = $(options.taskList);
                    }
                    displaySuccessMessage(options.i18n.tasksDeleteSuccess);
                    $taskList.find(".active").remove();
                },
                cancel: null
            });

            $(function(){
                if (!$taskList) {
                    $taskList = $(options.taskList);
                }

                $taskList.sortable({
                    cursor: "move",
                    update: function (event, ui) {
                        var $self = $(ui.item),
                            revertMove = function() {
                                var index = $self.prevAll().length;
                                if (($taskList.children().length - 1) == $self.data("movedFromPos")) {
                                    $self.appendTo($taskList).removeData("movedFromPos");
                                } else {
                                    $self.insertBefore($taskList.children("li:eq(" + ($self.data("movedFromPos") + (($self.data("movedFromPos") > index) ? 1 : 0)) + ")")).removeData("movedFromPos");
                                }
                            },
                            showError = function () {
                                var message = arguments.length ? arguments[0] : BAMBOO.buildAUIErrorMessage([ "There was a problem moving your task." ]),
                                    errorDialog = new AJS.Dialog(400, 160);
                                errorDialog.addHeader("Task move failed").addPanel("errorPanel", message).addButton("Close", function (dialog) {
                                    dialog.hide();
                                });
                                errorDialog.show();
                                revertMove();
                            },
                            callMoveAction = $self.hasClass("final-tasks-bar") ? function () {
                                $.ajax({
                                    type: "POST",
                                    url: options.moveFinalBarUrl,
                                    data: {
                                        afterId: $self.nextAll(".task:first").attr("data-task-id"),
                                        beforeId: $self.prevAll(".task:first").attr("data-task-id")
                                    },
                                    success: function (json) {
                                        if (json.status == "ERROR") {
                                            if (json.errors && json.errors.length) {
                                                var messages = BAMBOO.buildAUIErrorMessage(json.errors);
                                                showError(messages);
                                            } else {
                                                showError(BAMBOO.buildAUIErrorMessage([ "There was a problem moving the final tasks bar." ]));
                                            }
                                        } else {
                                            $self.nextAll(".task").addClass("final").end().prevAll(".task").removeClass("final");
                                        }
                                    },
                                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                                        showError(BAMBOO.buildAUIErrorMessage([ "There was a problem moving the final tasks bar." ]));
                                    },
                                    dataType: "json"
                                });
                            } : function () {
                                var taskId = $self.attr("data-task-id"),
                                    isFinal = !!$self.prevAll(".final-tasks-bar").length;
                                $.ajax({
                                    type: "POST",
                                    url: options.moveTaskUrl,
                                    data: {
                                        taskId: taskId,
                                        afterId: $self.nextAll(".task:first").attr("data-task-id"),
                                        beforeId: $self.prevAll(".task:first").attr("data-task-id"),
                                        finalising: isFinal
                                    },
                                    success: function (json) {
                                        if (json.status == "ERROR") {
                                            if (json.errors && json.errors.length) {
                                                var messages = BAMBOO.buildAUIErrorMessage(json.errors);
                                                showError(messages);
                                            } else {
                                                showError();
                                            }
                                        } else {
                                            $self.toggleClass("final", isFinal);
                                        }
                                    },
                                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                                        showError();
                                    },
                                    dataType: "json"
                                });
                            };
                        callMoveAction();
                    },
                    start: function (event, ui) {
                        var $self = $(ui.item);
                        $self.data("movedFromPos", $self.prevAll().length);
                    }
                });
            });
        }
    }
}(jQuery);
