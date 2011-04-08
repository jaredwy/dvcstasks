[#-- @ftlvariable name="action" type="com.atlassian.bamboo.security.Login" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.security.Login" --]
<html>
<head>
    <title>[@ww.text name='user.login.title' /]</title>
    <meta name="decorator" content="login" />
</head>

<body>

[#if req.getParameter("os_destination")??]
    [#assign destination = '${req.getParameter(\"os_destination\")}']
[#elseif (session.getAttribute("ACEGI_SAVED_REQUEST_KEY"))??]
    [#assign destination = '${session.getAttribute("ACEGI_SAVED_REQUEST_KEY").servletPath}?${session.getAttribute("ACEGI_SAVED_REQUEST_KEY").queryString!}']
[#else]
    [#assign destination = '/start.action']
[/#if]

[#assign welcome]
    [@ww.text name='bamboo.welcome'][@ww.param]${ctx.instanceName?html}[/@ww.param][/@ww.text]
[/#assign]

[@ww.form action="userlogin.action"
              id="loginForm"
              method="post"
              submitLabelKey='user.login.button'
              cancelUri='${req.contextPath}/forgotPassword!default.action'
              cancelSubmitKey='user.login.description'
              title="${welcome}"
]
    [@ww.hidden name="os_destination" value=destination /]
    [@ww.textfield labelKey='user.username' name="os_username" required="true" tabindex="1" /]
    [@ww.password labelKey='user.password' name="os_password" showPassword="true" required="true" tabindex="2" /]
    [@ww.checkbox id="os_cookie_id" labelKey='user.login.remember' name="os_cookie" tabindex="3" accesskey="R" /]
[#if elevatedSecurityRequired]
    [@cp.captcha/]
[/#if]
[/@ww.form]


<script type="text/javascript">
    AJS.$("#loginForm_os_username").focus();
</script>


[#include "/fragments/decorator/footer.ftl"]

