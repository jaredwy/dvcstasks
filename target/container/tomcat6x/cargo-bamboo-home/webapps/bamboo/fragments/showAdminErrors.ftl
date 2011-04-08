[#-- @ftlvariable name="adminErrors" type="com.atlassian.bamboo.logger.AdminErrorAction" --]
[#assign adminErrors = webwork.bean("com.atlassian.bamboo.logger.AdminErrorAction") ]
[#assign adminHandler = adminErrors.adminErrorHandler ]

[#if !adminHandler.errors.empty]
[@ui.clear/]
    [#if adminHandler.errors.size() == 1]
    <div class="adminErrorBox">
        [#list adminHandler.errors.entrySet() as error]
             [#if fn.hasGlobalPermission('ADMINISTRATION') ]
            <div class="adminErrorBoxLinks"><a href="${req.contextPath}/admin/adminErrors!removeError.action?errorKey=${error.key}">Acknowledge</a></div>
            [/#if]
            <p>${error.value}</p>
        [/#list]
    </div>
    [#else]
    <div class="adminErrorBox">
        [#if fn.hasGlobalPermission('ADMINISTRATION') ]
        <div class="adminErrorBoxLinks"><a href="${req.contextPath}/admin/adminErrors!removeAllErrors.action">Acknowledge All</a>    </div>
        [/#if]
        [#list adminHandler.errors.entrySet() as error]
            <p>${error.value}<br>
                [#if fn.hasGlobalPermission('ADMINISTRATION') ]
                <a href="${req.contextPath}/admin/adminErrors!removeError.action?errorKey=${error.key}">Acknowledge</a>
                [/#if]
            </p>
        [/#list]
    </div>
    [/#if]
[/#if]
