[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.user.ConfigureNotificationPreferences" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.user.ConfigureNotificationPreferences" --]
<head>
	<title>[@ui.header pageKey='User Notifications' object='${fn.getUserFullName(currentUser)}' title=true/]</title>
    <meta name="decorator" content="atl.userprofile">
    <meta name="tab" content="userNotifications">
</head>
<body>

[@ww.url id='changePreferences'
        action='editUserNotifications'
        namespace='/profile' /]
[#assign editProfileLink='<a href="${changePreferences}" accesskey="${action.getText(\'global.key.edit\')}">Edit Notification Preferences</a>' /]

[@ui.bambooPanel titleKey='user.notification.preference.view.title' tools='${editProfileLink!}']
    [@ui.bambooSection]
        [#if notificationErrorMessageKey?has_content]
            [@cp.displayNotificationWarnings messageKey=notificationErrorMessageKey addServerKey=notificationAddServerKey cssClass='warning' allowInlineEdit=true/]
        [/#if]
        [@ww.label labelKey='user.notification.preference.view.label' value='${notificationTypes.get(notificationPreference)}'  /]
        [#if notificationPreference=="both" || notificationPreference=="textEmail"]
            [#if notificationTransportPreference=="multipart" ]
                [@ww.label labelKey='user.notification.transportPreference.label' value='${notificationTransportPreferenceTypes.get(notificationTransportPreference)}' descriptionKey='user.notification.preference.multipart.description' /]
            [#else]
                [@ww.label labelKey='user.notification.transportPreference.label' value='${notificationTransportPreferenceTypes.get(notificationTransportPreference)}' /]
            [/#if]
        [/#if]
    [/@ui.bambooSection]

    [@ui.bambooPanel titleKey='user.notification.notifications.title' ]
        [#if usersNotificationRules?has_content]
            [#assign footnote=false /]
            <p>
                [@ww.text name='user.notification.notifications.description' /]
            </p>
            <table id="usersNotificationTable" class="aui">
                <colgroup>
                    <col width="25%">
                    <col width="25%">
                    <col>
                    <col width="150">
                </colgroup>
                <thead>
                    <tr>
                        <th class="notificationHeadingBar" >
                            Plan
                        </th>
                        <th class="notificationHeadingBar"  >
                            Event
                        </th>
                        <th class="notificationHeadingBar" colspan="2" >
                            Notification Recipient
                        </th>
                    </tr>
                </thead>
                <tbody>
                    [#list usersNotificationRules as usersNotification]
                        [#assign plan = usersNotification.plan /]
                        [#assign notification = usersNotification.notificationRule /]

                        [#-- Setting the newRow group variable --]
                        [#if notification.notificationTypeForView?has_content]
                             [#if notification.notificationTypeForView.getViewHtml()?has_content]
                                   [#assign thisNotificationType=notification.notificationTypeForView.getViewHtml() /]
                             [#else]
                                   [#assign thisNotificationType=notification.notificationTypeForView.name /]
                             [/#if]
                        [#else]
                             [#assign thisNotificationType=notification.conditionKey /]
                        [/#if]

                        [#if !lastBuildName?has_content || lastBuildName != plan.name]
                            [#assign newBuildRow = true /]
                            [#assign newRow = true /]
                        [#else]
                            [#assign newBuildRow = false /]
                            [#if !lastNotificationType?has_content || lastNotificationType != thisNotificationType]
                                [#assign newRow = true /]
                            [#else]
                                [#assign newRow = false /]
                            [/#if]
                        [/#if]
                        [#assign lastBuildName=plan.name /]
                        [#assign lastNotificationType=thisNotificationType /]

                        <tr class="notificationRule">
                            <td [#if newBuildRow]class=notificationGroupTop[#else] class="notificationGroupMiddle" [/#if]>
                                [#if newBuildRow][@ui.renderPlanNameLink plan/][/#if]
                            </td>
                            <td [#if newRow]class="notificationGroupTop" [#else] class="notificationGroupMiddle" [/#if] >
                                [#if newRow]${thisNotificationType}[/#if]
                            </td>
                            <td class="notificationMiddleColumn">
                                [#if notification.notificationRecipient?has_content]
                                    [#if notification.notificationRecipient.getViewHtml()?has_content]
                                        ${notification.notificationRecipient.getViewHtml()}
                                    [#else]
                                        ${notification.notificationRecipient.description()}
                                    [/#if]
                                [#else]
                                    ${notification.recipientType}: ${notification.recipient}
                                [/#if]
                                [#if !action.isRecipientUserBased(notification)] *[#assign footnote=true /][/#if]
                            </td>
                            <td class="notificationLastColumn">
                                [#if fn.hasPlanPermission('WRITE', plan) ]
                                    [@ww.url id='editPlanNotificationsUrl'
                                            action='defaultChainNotification'
                                            namespace='/chain/admin/config'
                                            buildKey=plan.key /]
                                     
                                    <a id="editNotification:${notification.getId()}" href="${editPlanNotificationsUrl}" onclick="saveCookie('atlassian.bamboo.build.tab.selected', 'Notifications', 365);">Edit</a>
                                [/#if]
                            </td>
                        </tr>
                    [/#list]
                </tbody>
            </table>
            [#if footnote]
                <p>
                    [@ww.text name='user.notification.notifications.footnote' /]
                </p>
            [/#if]
        [#else]
            <p>
                [@ww.text name='user.notification.notifications.empty' /]
            </p>
        [/#if]
    [/@ui.bambooPanel]
[/@ui.bambooPanel]

</body>
        
