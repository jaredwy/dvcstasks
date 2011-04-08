[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.DeleteBuilds" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.DeleteBuilds" --]

<html>
<head>
	<title>[@ww.text name='builds.delete.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
[@ui.header pageKey="builds.delete.heading" /]

[#if sortedProjects?has_content]
    [@ui.messageBox type="warning" titleKey='builds.delete.warning' /]
    [@ww.form titleKey='builds.delete.form.title'
              id='deleteBuildsForm'
              name='deleteBuildsForm'
              action='deleteBuilds!confirm.action'
              submitLabelKey='builds.delete.button'
              descriptionKey="builds.delete.exists"]
        [@cp.displayBulkActionSelector bulkAction=action checkboxFieldValueType='key' planCheckboxName='selectedBuilds' jobCheckboxName='selectedJobs' enableProjectCheckbox=true/]
    [/@ww.form]
[#else]
    [@ui.messageBox titleKey='builds.delete.none' /]
[/#if]
</body>
</html>
