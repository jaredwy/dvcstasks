[#if fn.hasAdminPermission()]
<div class="startupTextBox">
    <p>[@ww.text name="welcome.blurb" /]</p>
    <p><a href="${req.contextPath}/build/admin/create/addPlan.action"><img src="${req.contextPath}/images/btn_createaplan.gif" alt="Create A Plan" width="133" height="38" /></a></p>
</div>

<h2>[@ww.text name="welcome.whatsnext" /]</h2>
<ul>
[@ww.url id="viewServerCapabilities" action="configureSharedLocalCapabilities" namespace="/admin/agent" /]
[#assign builders = localBuilders!/]
[#assign jdks = localJdks! /]
[#if !builders?has_content && !jdks?has_content]
    <li>
        [@ww.text name="welcome.jdksnbuilders.neither"]
            [@ww.param]${viewServerCapabilities}[/@ww.param]
        [/@ww.text]
     </li>
[#elseif !builders?has_content]
    <li>
        [@ww.text name="welcome.jdksnbuilders.jdks"]
            [@ww.param]${viewServerCapabilities}[/@ww.param]
        [/@ww.text]
     </li>
[#elseif !jdks?has_content]
    <li>
       [@ww.text name="welcome.jdksnbuilders.builders"]
            [@ww.param]${viewServerCapabilities}[/@ww.param]
            [@ww.param value=builders.size()/]
        [/@ww.text]
    </li>
[#else]
    <li>[@ww.text name="welcome.jdksnbuilders.both"]
            [@ww.param]${viewServerCapabilities}[/@ww.param]
            [@ww.param value=builders.size()/]
        [/@ww.text]
     </li>
[/#if]
<li>
     [@ww.text name="welcome.communication"]
            [@ww.param][@ww.url action='viewMailServer' namespace='/admin' /][/@ww.param]
            [@ww.param][@ww.url action='viewInstantMessagingServer' namespace='/admin/instantmessagingserver' /][/@ww.param]
     [/@ww.text]
</li>
[#if !allowedRemoteAgents]
    <li> [@ww.text name="welcome.agents.local"]
            [@ww.param][@ww.url action='configureAgents!default' namespace='/admin/agent' /][/@ww.param]
         [/@ww.text]
[#else]
    <li> [@ww.text name="welcome.agents.other"]
            [@ww.param][@ww.url action='configureAgents!default' namespace='/admin/agent' /][/@ww.param]
            [@ww.param][@ww.url action='viewElasticConfig' namespace='/admin/elastic' /][/@ww.param]
         [/@ww.text]
[/#if]
<li> [@ww.text name="welcome.usersetc"]
        [@ww.param][@ww.url action='viewUsers' namespace='/admin/user' /][/@ww.param]
        [@ww.param][@ww.url action='viewGroups' namespace='/admin/group' /][/@ww.param]
        [@ww.param][@ww.url action='viewGlobalPermissions!default' namespace='/admin' /][/@ww.param]
    [/@ww.text]
</ul>
<p>[@ww.text name="welcome.moreinfo.admin" ]
     [@ww.param][@ww.url action='administer' namespace='/admin' /][/@ww.param]
   [/@ww.text]
    [@ww.text name="welcome.moreinfo.user" /]
</p>

[#elseif fn.hasGlobalPermission('CREATE')]

    <div class="startupTextBox">
        <p>[@ww.text name="welcome.blurb" /]</p>
        <p><a href="${req.contextPath}/build/admin/create/addPlan.action"><img src="${req.contextPath}/images/btn_createaplan.gif" alt="Create A Plan" width="133" height="38" /></a></p>
    </div>

    <p>[@ww.text name="welcome.moreinfo.user" /]</p>
[#else]
    <ul>
        [#if !user??]
            <li>
                [@ww.text name="welcome.login"]
                    [@ww.param][@ww.url action='userlogin' namespace='' /][/@ww.param]
                    [@ww.param][@ww.url action='signupUser' method='default' /][/@ww.param]
                [/@ww.text]
            </li>
        [/#if]
        <li>
            [@ww.text name="welcome.noPermission"]
                [@ww.param][@ww.url action='viewAdministrators' namespace='' /][/@ww.param]
            [/@ww.text]
        </li>
    </ul>
[/#if]