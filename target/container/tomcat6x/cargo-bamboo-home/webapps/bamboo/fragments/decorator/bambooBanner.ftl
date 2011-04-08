<div id="header">
    <div id="logo">
        <a href="${req.contextPath}/start.action" rel="nofollow">[@ww.text name='bamboo.name' /]</a>
    </div>
    <ul id="userOptions">
    [#if ctx?? && ctx.getUser(req)??]
        <li id="userInfo">
            User: <strong><a href="${req.contextPath}/browse/user/${ctx.getUser(req).name?url}">[@ui.displayUserFullName user=ctx.getUser(req) /]</a></strong>
        </li>
        <li id="profileLink">
            <a id="profile" href="${req.contextPath}/profile/userProfile.action">[@ww.text name='bamboo.banner.profile' /]</a>
        </li>
        <li id="logoutLink">
            <a id="logout" href="${req.contextPath}/userLogout.action">[@ww.text name='bamboo.banner.logout' /]</a>
        </li>
    [#elseif ctx??]
        <li id="loginLink">
            <a id="login" href="${req.contextPath}/userlogin!default.action?os_destination=${ctx.getCurrentUrl(req)?url}">[@ww.text name='bamboo.banner.login' /]</a>
        </li>
        [#if ctx.isEnableSignup() ]
            <li id="signupLink">
                <a id="signup" href="${req.contextPath}/signupUser!default.action">[@ww.text name='bamboo.banner.signup' /]</a>
            </li>
        [/#if]
    [/#if]
        <li id="helpLink">
            <a id="help" href="http://confluence.atlassian.com/display/BAMBOO">[@ww.text name='bamboo.banner.help' /]</a>
        </li>
    </ul>
</div> <!-- END #header -->
