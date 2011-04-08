[#-- @ftlvariable name="" type="com.atlassian.bamboo.buildqueue.ViewRunningPlans" --]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.buildqueue.ViewRunningPlans" --]

<title>Builds running</title>
[@ww.form action="stopPlan" namespace="/build/admin"
        cssClass="bambooForm bambooAuiDialogForm"]

    <div class="noteBox">
        [@ww.text name='build.stop.confirmation.warning']
            [@ww.param]${runningPlans.size()}[/@ww.param]
        [/@ww.text]
    </div>
    [#list runningPlans as plan]
        <p class="build-description">[#rt]
            <a href="${req.contextPath}/browse/${plan.planResultKey}">${plan.planResultKey}</a> ${plan.triggerReason.getNameForSentence()}[#t]
        </p>
    [/#list]
    [@ww.hidden name="planKey"/]
    [@ww.hidden name="returnUrl"/]
[/@ww.form]
