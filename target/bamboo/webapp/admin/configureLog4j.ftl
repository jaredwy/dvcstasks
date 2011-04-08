[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.ConfigureLog4jAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.ConfigureLog4jAction" --]

<h1>[@ww.text name='logSettings.heading' /] </h1>
<p>[@ww.text name='logSettigns.description' /] </p>

[@ui.bambooPanel titleKey='logSettings.add' descriptionKey='logSettings.add.description' ]

[@ww.form id='addLog4jEntry'
action='addLog4jEntry'
namespace='/admin'
submitLabelKey='global.buttons.add'
theme="simple" ]

<table class="aui">

    <tr>
        <td>

        [@ww.textfield id='newEntry' size="50" name='extraClassName' labelKey='logSettings.add.classname'/]
                 [@ww.select label='Type' name='extraLevelName' list=levelTypes
        optionTitle='pathHelp'
        descriptionKey='builders.form.type.description' /]
        </td>
    </tr>
</table>
[@ui.buttons]
[@ww.submit type="submit" value=action.getText('global.buttons.add') /]
[/@ui.buttons]
[/@ww.form]
[/@ui.bambooPanel]

[@ui.bambooPanel titleKey='logSettings.edit' descriptionKey='logSettings.edit.description' ]
<table class="aui">
    <thead>
    <tr>
        <th>Package</th>
        <th>Current Level</th>
        <th>New Level</th>
    </tr>
    </thead>
    [#list entries as entry]
        <tr>
            <td>${entry.clazz?html}</td>
            <td>${entry.level}</td>
            <td>
            [@ww.form id='configureLog4jForm' action='saveLog4jClass' theme="simple" namespace="/admin" ]
                [@ww.select label='Level' name='levelName' list=levelTypes /]
                [@ww.hidden name="className" value=entry.clazz /]
                [@compress single_line=true]
                [@ww.submit cssClass='formLink' type="submit" value=action.getText('global.buttons.update') /]
                    <a id="deleteLogClass:${entry.clazz?html}" class="formLink" href="${req.contextPath}/admin/deleteLog4jClass.action?toDeleteName=${entry.clazz?html}">[@ww.text name='global.buttons.delete'/]</a>
                [/@compress]
            [/@ww.form]
            </td>
        </tr>
    [/#list]
</table>
[/@ui.bambooPanel]

