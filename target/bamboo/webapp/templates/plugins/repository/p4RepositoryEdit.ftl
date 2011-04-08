[#if repository.perforceExecutableSet]
    [@ui.messageBox type="info"]
        [@ww.text name='repository.p4.executableExists']
            [@ww.param]${repository.p4Executable}[/@ww.param]
        [/@ww.text]
    [/@ui.messageBox]
[#else]
    [@ui.messageBox type="warning"]
        [@ww.text name='repository.p4.noExecutable']
            [@ww.param]${req.contextPath}/admin/agent/configureSharedLocalCapabilities.action[/@ww.param]
        [/@ww.text]
    [/@ui.messageBox]
[/#if]
        
[@ww.textfield labelKey='repository.p4.port' name='repository.p4.port' required='true' helpKey='perforce.fields' /]
[@ww.textfield labelKey='repository.p4.client' name='repository.p4.client' required='true' helpKey='perforce.fields' cssClass="long-field" /]
[@ww.textfield labelKey='repository.p4.depot' name='repository.p4.depot' required='true' helpKey='perforce.fields' cssClass="long-field" /]
[@ww.textfield labelKey='repository.p4.username' name='repository.p4.user' helpKey='perforce.fields' /]
[#if buildConfiguration.getString('repository.p4.password')?has_content]
    [@ww.checkbox labelKey='repository.password.change' toggle='true' name='temporary.p4.passwordChange' /]
    [@ui.bambooSection dependsOn='temporary.p4.passwordChange' showOn='true']
        [@ww.password labelKey='repository.p4.password' name='temporary.p4.password' helpKey='perforce.fields' required='false'/]
    [/@ui.bambooSection]
[#else]
    [@ww.hidden name="temporary.p4.passwordChange" value="true" /]
    [@ww.password labelKey='repository.p4.password' name='temporary.p4.password' helpKey='perforce.fields' required='false'/]
[/#if]

[@ww.checkbox labelKey='repository.p4.manageWorkspace' name='repository.p4.manageWorkspace' helpKey='perforce.fields' /]
