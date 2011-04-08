[#if cronEditorBean??]
    [@ww.form action="returnCronExpression" namespace="/ajax" cssClass="bambooAuiDialogForm"]
        [@ww.radio name='cronEditorBean.mode'
                    list='cronEditorBean.availableSchedules'
                    i18nPrefixForValue='cronEditorBean.availableSchedules'
                    showNewLine='false'
                    toggle='true']
        [/@ww.radio]


        <div class='cronEditorForm'>

        [@ui.bambooSection dependsOn='cronEditorBean.mode' showOn='daysOfWeek']
                [@ww.checkboxlist name='cronEditorBean.checkBoxSpecifiedDaysOfWeek'
                              i18nPrefixForValue='cronEditorBean.daysOfWeek'
                              list=cronEditorBean.daysOfWeek matrix=true /]
        [/@ui.bambooSection]


        <div class='intervalForm'>
            [@ui.bambooSection dependsOn='cronEditorBean.mode' showOn='daily daysOfWeek']
            [@ww.text name='cronEditorBean.time.interval' /]:
                [@ww.select labelKey='Interval' name='cronEditorBean.incrementInMinutes' theme='inline' toggle='true'
                            list='cronEditorBean.intervalOptions'
                            i18nPrefixForValue='cronEditorBean.intervalOptions']
                [/@ww.select]
            [/@ui.bambooSection]

            [@ui.bambooSection dependsOn='cronEditorBean.mode' showOn='daysOfMonth']
                <div class='timeForm'>
                    [@ww.text name='cronEditorBean.time.at' /]:
                    [@ww.select name='cronEditorBean.monthHoursRunOnce' theme='inline'
                                list='cronEditorBean.hourOptions']
                    [/@ww.select]
                    :
                    [@ww.select name='cronEditorBean.monthMinutes' theme='inline'
                                list='cronEditorBean.minuteOptions']
                    [/@ww.select]
                    [@ww.select name='cronEditorBean.monthHoursRunOnceMeridian' theme='inline'
                                list='cronEditorBean.meridianOptions']
                    [/@ww.select]
                </div>
            [/@ui.bambooSection]

            [@ui.bambooSection dependsOn='cronEditorBean.mode' showOn='daily daysOfWeek']
                <div class='timeForm'>
                [@ui.bambooSection dependsOn='cronEditorBean.incrementInMinutes' showOn='0']
                        [@ww.text name='cronEditorBean.time.at' /]:
                        [@ww.select name='cronEditorBean.dayHoursRunOnce' theme='inline'
                                    list='cronEditorBean.hourOptions']
                        [/@ww.select]
                        :
                        [@ww.select name='cronEditorBean.dayMinutes' theme='inline'
                                    list='cronEditorBean.minuteOptions']
                        [/@ww.select]
                        [@ww.select name='cronEditorBean.dayHoursRunOnceMeridian' theme='inline'
                                    list='cronEditorBean.meridianOptions']
                        [/@ww.select]
                [/@ui.bambooSection]
                [@ui.bambooSection dependsOn='cronEditorBean.incrementInMinutes' showOn='180 120 60 30 15']
                        [@ww.text name='cronEditorBean.time.from' /]:
                        [@ww.select name='cronEditorBean.hoursFrom' theme='inline'
                                    list='cronEditorBean.hourOptions']
                        [/@ww.select]
                        :
                        [@ww.textfield name='minutes' value='00' theme='inline' disabled='true'/]
                        [@ww.select name='cronEditorBean.hoursFromMeridian' theme='inline'
                                list='cronEditorBean.meridianOptions']
                        [/@ww.select]
                        [@ww.text name='cronEditorBean.time.to' /]:
                        [@ww.select name='cronEditorBean.hoursTo' theme='inline'
                                    list='cronEditorBean.hourOptions']
                        [/@ww.select]
                        :
                        [@ww.textfield name='minutes' value='00' theme='inline' disabled='true'/]
                        [@ww.select name='cronEditorBean.hoursToMeridian' theme='inline'
                                    list='cronEditorBean.meridianOptions']
                        [/@ww.select]
                [/@ui.bambooSection]
                </div>
            [/@ui.bambooSection]
        </div>

        [@ui.bambooSection dependsOn='cronEditorBean.mode' showOn='daysOfMonth']
            <div class='monthForm'>
                <div>
                [@ww.radio name='cronEditorBean.dayOfWeekOfMonth' template="radio.ftl" theme="simple"  fieldValue='false'/]
                [@ww.text name='cronEditorBean.daysOfMonth.the' /]
                [@ww.select name='cronEditorBean.dayOfMonth' theme='inline' list='cronEditorBean.dayOptions' i18nPrefixForValue='cronEditorBean.dayOptions']
                [/@ww.select]
                [@ww.text name='cronEditorBean.daysOfMonth.dayChoice' /]
                </div>
                <div>
                [@ww.radio name='cronEditorBean.dayOfWeekOfMonth' template="radio.ftl" theme="simple" fieldValue='true'/]
                [@ww.text name='cronEditorBean.daysOfMonth.the' /]
                [@ww.select name='cronEditorBean.dayInMonthOrdinal' theme='inline' list='cronEditorBean.weekOptions' i18nPrefixForValue='cronEditorBean.weekOptions']
                [/@ww.select]
                [@ww.select name='cronEditorBean.monthSpecifiedDaysOfWeek' theme='inline' list='cronEditorBean.daysOfWeek' i18nPrefixForValue='cronEditorBean.daysOfWeek']
                [/@ww.select]
                [@ww.text name='cronEditorBean.daysOfMonth.weekChoice' /]
                </div>
            </div>
        [/@ui.bambooSection]

        [@ui.bambooSection dependsOn='cronEditorBean.mode' showOn='advanced']
            <div class='cronStringForm'>
            [@ww.textfield name='cronEditorBean.cronString' helpKey='cron.expression'/]
            </div>
        [/@ui.bambooSection]

        </div>
    [/@ww.form]
[#else]
    [@ui.messageBox type="error"][@ww.text name="cronEditorBean.error" /][/@ui.messageBox]
[/#if]