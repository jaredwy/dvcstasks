var BuildResult = function ($) {
    var opts = {
        currentKey: null,
        getStatusUrl: null,
        buildStatus: null,
        jobStatus: null
    },
    $planNavigator,
    $stageElements,
    $statusRibbon,
    $progressBar,
    $buildingFor,
    getBuildStatus = function (build) {
        if (build.finished) {
            return build.state;
            /* The REST for plan results doesn't contain a "state" (e.g. Successful, Failed, NotBuilt), so build.state will be undefined
               but will cause the page to reload anyway, at which point this JS shouldn't be executed because the build is no longer "active".
               Ideally we'd have the plan result build state returned in the REST. */
        } else if (build.progress && build.progress.buildTime) {
            return "InProgress";
        } else {
            return "Queued";
        }
    },
    getJobStatus = function (job) {
        if (job.finished) {
            return job.state;
        } else if (job.waiting) {
            return "Pending";
        } else if (job.progress && !job.queued) {
            if (job.updatingSource) {
                return "updatingSource";
            } else {
                return "InProgress";
            }
        } else {
            return "Queued";
        }
    },
    isJobResult,
    updateTimeout,
    update = function () {
        $.ajax({
            url: opts.getStatusUrl,
            cache: false,
            data: {
                expand: "stages.stage.results.result"
            },
            dataType: "json",
            contentType: "application/json",
            success: function (json) {
                if (json.finished) {
                    window.location.reload(true);
                    return;
                }

                refreshBuildRibbon(json);
                refreshPlanNavigator(json);

                // Update again in 5 seconds
                updateTimeout = setTimeout(update, 5000);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                // Error occurred when doing the update, try again in 30 sec
                updateTimeout = setTimeout(update, 30000);
            }
        });
    },
    updateIcon = function ($icon, iconType) {
        var fullIconType = "icon-" + iconType;
        if (!$icon.hasClass(fullIconType)) {
            $icon.attr("class", "icon " + fullIconType);
        }
    },
    refreshBuildRibbon = function (json) {
        if (opts.buildStatus != getBuildStatus(json)) {
            window.location.reload(true);
            return;
        }
        if (!isJobResult) {
            if (!json.progress.buildTime) {
                $buildingFor.text(json.prettyQueuedTime);
            } else {
                $progressBar.progressBar("option", "value", Math.ceil(100 - (json.progress.percentageCompleted * 100)));
                if (json.progress.averageBuildDuration > 0) {
                    $buildingFor.text("- " + json.progress.prettyTimeRemaining);
                } else {
                    $buildingFor.text("- " + json.progress.prettyBuildTime);
                }
            }
        }
    },
    refreshJobRibbon = function (job) {
        if (opts.jobStatus != getJobStatus(job)) {
            window.location.reload(true);
            return;
        }
        if (job.queued) {
            $buildingFor.text(job.prettyQueuedTime);
        } else if (job.updatingSource) {
            $buildingFor.text(job.prettyVcsUpdateDuration);
        } else if (job.progress) {
            $progressBar.progressBar("option", "value", Math.ceil(100 - (job.progress.percentageCompleted * 100)));
            if (job.progress.averageBuildDuration > 0) {
                $buildingFor.text("- " + job.progress.prettyTimeRemaining);
            } else {
                $buildingFor.text("- " + job.progress.prettyBuildTime);
            }
        }
    },
    refreshPlanNavigator = function (json) {
        var jobs = [];
        for (var i=0, ii=json.stages.stage.length; i<ii; i++) {
            var stage = json.stages.stage[i],
                $stageElement = $($stageElements[i]);

            jobs = jobs.concat(stage.results.result);

            if (stage.isBuilding) {
                $stageElement.removeClass("Pending").addClass("InProgress");
            } else if (stage.isCompleted) {
                $stageElement.removeClass("Pending InProgress").addClass(stage.isSuccessful ? "Successful" : "Failed");
            } else {
                $stageElement.addClass("Pending");
            }
        }
        for (var j=0, jj=jobs.length; j<jj; j++) {
            var job = jobs[j],
                $job = $("#job-" + job.key),
                $icon = $(".icon", $job[0]),
                $progress = $(".progress", $job[0]);
            if (isJobResult && job.key == opts.currentKey) {
                refreshJobRibbon(job);
            }
            if (job.finished) {
                updateIcon($icon, job.state);
                if ($progress.length) {
                    $progress.remove();
                }
            } else if (job.progress && !job.queued) {
                updateIcon($icon, "InProgress");
                if (!$progress.length) {
                    $progress = $("<div />", { id: "navPb" + job.key }).progressBar().prependTo($job);
                }
                $progress.progressBar("option", "value", Math.ceil(100 - (job.progress.percentageCompleted * 100)));
            } else {
                updateIcon($icon, "Queued");
            }
        }
    };
    return {
        init: function (options) {
            $.extend(true, opts, options);

            $planNavigator = $("#plan-navigator");
            $statusRibbon = $("#status-ribbon");
            isJobResult = $statusRibbon.hasClass("has-job");
            $progressBar = $("#sr-pb-" + opts.currentKey);
            $buildingFor = $(".operationTime", $statusRibbon[0]);
            $stageElements = $("> ul > li", $planNavigator[0]);

            update();
        }
    }
}(jQuery);
