[#assign externallyManaged = action.isExternallyManaged() /]

[#if mode == 'edit' ]
    [#assign readOnly = bambooUserManager.isReadOnly(currentUser) /]
    [#if readOnly || externallyManaged]
        [#assign targetAction = "updateExternalUser" ]
    [#else]
        [#assign targetAction = "updateUser"]
    [/#if]

    [#assign cancelUri = '/admin/user/viewUsers.action' /]
    [#assign showActionErrors = 'true' /]
    <html><head><title>[@ww.text name='user.admin.${mode}.title' /]</title></head><body>
[#else]
    [#assign targetAction = "createUser"]
    [#assign cancelUri = '' /]
    [#assign showActionErrors = 'false' /]
[/#if]

[#assign mode = mode?html /]

<h1>[@ww.text name='user.admin.${mode}.title' /]</h1>
[@ww.form action=targetAction
          submitLabelKey='global.buttons.update'
          titleKey='user.admin.${mode}.form.title'
          cancelUri=cancelUri
          showActionErrors=showActionErrors
          descriptionKey='user.admin.${mode}.description'
]
    [@ww.hidden name="mode"  /]

    [#if mode == 'edit']
        [@ww.label labelKey='user.username' name="username" /]
        [@ww.hidden name="username" /]
    [#else]
        [@ww.textfield labelKey='user.username' name="username" required="true" /]
    [/#if]
    
    [#if !(mode == 'edit' && (readOnly || externallyManaged)) ]
        [@ww.password labelKey='user.password' name="password" showPassword="true" required=(mode != 'edit') /]
        [@ww.password labelKey='user.password.confirm' name="confirmPassword" showPassword="true" required=(mode != 'edit') /]
    [/#if]

    [#if mode == 'edit' && (readOnly || externallyManaged) ]
        [@ww.label labelKey='user.fullName' name="fullName" /]
        [@ww.label labelKey='user.email' name="email" /]
    [#else]
        [@ww.textfield labelKey='user.fullName' name="fullName" required="true" /]
        [@ww.textfield labelKey='user.email' name="email" required="true" /]
    [/#if]

        [@ww.textfield labelKey='user.jabber' name="jabberAddress" /]

    [#if externallyManaged]
        [#assign groupList='' /]
        [#if groups?has_content]
            [#list groups as group]
                [#assign groupList='${groupList} ${group}' /]
                [@ww.hidden name="groups" value="${group}" /]
                [#if group_has_next]
                    [#assign groupList='${groupList},' /]
                [/#if]
            [/#list]
        [/#if]
        [@ww.label labelKey='user.groups' value='${groupList}'/]
    [#else]
        [@ww.select labelKey='user.groups' name="groups"
                    list=availableGroups multiple="true"]
        [/@ww.select]
    [/#if]

    [@dj.simpleDialogForm
        triggerSelector=".addAlias"
        width=540 height=210
        submitCallback="addAliasSubmitCallback"
    /]
    [#assign addAliasLink]
        <a class="addAlias" title="${action.getText('user.repositoryAlias.add')}" href="[@ww.url value='/ajax/configureAlias.action' returnUrl=currentUrl /]">[@ww.text name='user.repositoryAlias.add' /]</a>
    [/#assign]

    [@ww.select labelKey='user.repositoryAlias' name='authorId'
                list='availableAuthors'
                headerKey='0' headerValue='None'
                cssClass='selectAlias'
                extraUtility=addAliasLink/]

    [#if mode == 'edit' && captchaEnabled]
        [@ww.label labelKey='user.captcha.count' name="captchaCount" descriptionKey="user.captcha.count.description" /]
        [#if captchaResetable]
            [@ww.param name='buttons']
                [@ww.submit value=action.getText('user.captcha.reset') name="resetCaptcha" theme='simple' /]
            [/@ww.param]
        [/#if]
    [/#if]

[/@ww.form]
[#if mode=='edit']
    </body></html>
[/#if]