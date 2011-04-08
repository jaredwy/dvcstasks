[#--
    Requirements:
    existingProjectKey  scalar which will hold existing project's key 
    projectKey          scalar which will hold new project key
    projectName         scalar which will hold new project name
--]
[#if uiConfigBean.existingProjects?has_content]
    [@ww.select labelKey='project' name='existingProjectKey' toggle='true'
                list='uiConfigBean.existingProjects' listKey='key' listValue='name' groupLabel="Existing Projects"
                headerKey='newProject' headerValue='New Project' ]
    [/@ww.select]

    [@ui.bambooSection dependsOn='existingProjectKey' showOn='newProject']
        [@ww.textfield labelKey='project.name' name='projectName' required='true' /]
        [@ww.textfield labelKey='project.key' name='projectKey' required='true' /]
    [/@ui.bambooSection]
[#else]
    [@ww.textfield labelKey='project.name' name='projectName' required='true' /]
    [@ww.textfield labelKey='project.key' name='projectKey' required='true' /]
[/#if]