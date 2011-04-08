[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.ViewBambooInternals" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.ViewBambooInternals" --]
[#-- @ftlvariable name="jobDetail" type="org.quartz.JobDetail" --]
<html>
<head>
	<title>[@ww.text name='system.internal' /]</title>
</head>
<body>
    <h2>Events</h2>
    [#assign executorService = eventManager.executorService /]
    [#assign eventsQueue = eventManager.executorService.queue /]
    [@ui.displayText]
        <p>Running Workers: ${executorService.activeCount} / ${executorService.poolSize}</p>
        <p>Pending Events: ${eventsQueue?size}</p>
    [/@ui.displayText]
    [#if eventsQueue?has_content]
        <table class="aui">
            <thead>
                <tr>
                    <th>&nbsp;</th>
                    <th>Event</th>
                    <th>Event Listener</th>
                </tr>
            </thead>
            <tbody>
        [#list eventsQueue as runnable]
                <tr>
                    <td>
                        ${runnable_index+1}.
                    </td>
                    <td>${runnable.event.class.name}</td>
                    <td>${runnable.eventListener.class.name}</td>
                </tr>
        [/#list]
            </tbody>
        </table>    
    [/#if]


    <h2>[@ww.text name='system.internal.scheduler' /]</h2>

    <table class="aui">
        [#list jobDetailMultimap.asMap().entrySet() as entry]
            <thead>
                <tr>
                    <th colspan="4">[@ww.text name='system.internal.scheduler.group' /] ${entry.key}</th>
                </tr>
            </thead>
            <tbody>
                [#list entry.value as jobDetail]
                    <tr>
                        <td>
                            ${jobDetail_index+1}.
                        </td>
                        <td>
                            ${jobDetail.fullName}
                            <div class="small grey">
                                ${jobDetail.jobClass.name}
                            </div>
                        </td>
                        <td>
                            [#list scheduler.getTriggersOfJob(jobDetail.name, jobDetail.group) as trigger]
                                ${trigger.nextFireTime?datetime}
                                <div class="small grey">(in ${durationUtils.getRelativeToDate(trigger.nextFireTime.time)})</div>
                                <br />
                            [/#list]
                        </td>
                        <td>
                            [#assign dataMap = jobDetail.getJobDataMap() /]
                            [#list dataMap.keys as key]
                                ${key!}: ${dataMap.get(key)!}
                                <br />
                            [/#list]
                        </td>
                    </tr>
                [/#list]
            </tbody>
        [/#list]
    </table>
</body>
</html>