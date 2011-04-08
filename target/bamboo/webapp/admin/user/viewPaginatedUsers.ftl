[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.user.SearchUserAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.user.SearchUserAction" --]

<div class="inlineSearchForm">
    [@ww.form action='searchUsers' namespace='/admin/user' submitLabelKey='Search' theme='simple' ]
    <div class="inlineSearchField" >
        <span class="inlineSearchLabel">[@ww.text name="user.username" /]</span>
        [@ww.textfield labelKey='user.username' name="usernameTerm" /]
    </div>
    <div class="inlineSearchField" >
        <span class="inlineSearchLabel">[@ww.text name="user.fullName" /]</span>
        [@ww.textfield labelKey='user.fullName' name="fullnameTerm" /]
    </div>
    <div class="inlineSearchField" >
        <span class="inlineSearchLabel">[@ww.text name="user.email" /]</span>
        [@ww.textfield labelKey='user.email' name="emailTerm" /]
    </div>
    <div class="inlineSubmitButton" >
        <input type='submit' value='Search' />
    </div>

    [/@ww.form]
    <div class="clearer"></div>
     <div class="inlineSearchDescription">[@ww.text name="user.search.help"/]</div>
</div>

<table id="existingUsers" class="aui">
    <thead>
    <tr>
        <th>[@ww.text name="user.username"/]</th>
        <th>[@ww.text name="user.email"/]</th>
        <th>[@ww.text name="user.fullName"/]</th>
        <th>[@ww.text name="user.groups"/]</th>
        <th>[@ww.text name="user.repositoryAlias"/]</th>
        <th>[@ww.text name="global.heading.operations"/]</th>
    </tr>
    </thead>
    [#if paginationSupport?? && paginationSupport.page??]
    [#foreach userInfo in paginationSupport.page ]
    <tr [#if affectedUsername?? && affectedUsername==userInfo.name] class="selectedRow"[/#if]>
        [#assign groups = (action.getGroups(userInfo)!) /]
        <td>
            ${userInfo.name?html}
        </td>
        <td>
            ${userInfo.email!?html}
        </td>
        <td>
            [@ui.displayUserFullName user=userInfo /]
        </td>
        <td>
            [#if groups?has_content]
                [#foreach group in groups]
                    ${group} <br />
                [/#foreach]
            [/#if]
        </td>
        <td>
            ${(action.getLinkedAuthorForUser(userInfo).name)!?html}
        </td>
        <td class="operations">
            <a id="editUser-${userInfo.name}" href="[@ww.url action='editUser' username=userInfo.name /]">[@ww.text name='global.buttons.edit' /]</a>
            [#if !(user?? && (user.name == userInfo.name)) && bambooUserManager.isDeletable(userInfo) && !action.isExternallyManaged()]
                |
                <a id="deleteUser-${userInfo.name}" href="[@ww.url action='deleteUser' username=userInfo.name /]">[@ww.text name='global.buttons.delete' /]</a>
            [/#if]
        </td>
    </tr>
    [/#foreach]
    [/#if]
</table>

[@cp.entityPagination actionUrl='?usernameTerm=${usernameTerm?if_exists}&fullnameTerm=${fullnameTerm?if_exists}&emailTerm=${emailTerm?if_exists}&' paginationSupport=paginationSupport /]

