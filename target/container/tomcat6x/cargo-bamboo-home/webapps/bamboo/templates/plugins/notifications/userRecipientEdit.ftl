[#if notificationUserString?has_content]
    [@ww.textfield labelKey='notification.recipients.users' value='${notificationUserString}' name='notificationUserString' template='userPicker' multiSelect=false /]
[#else]
    [@ww.textfield labelKey='notification.recipients.users' name='notificationUserString' template='userPicker'  multiSelect=false /]
[/#if]

