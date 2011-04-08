[#-- @ftlvariable name="action" type="com.atlassian.bamboo.v2.ww2.build.ParameterisedManualBuild" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.v2.ww2.build.ParameterisedManualBuild" --]

[@ww.form action="runParametrisedManualBuild" namespace="/ajax"
        cssClass="bambooAuiDialogForm"
        descriptionKey="build.editParameterisedManualBuild.form.description"
        submitLabelKey="global.buttons.run"]

    [@ww.hidden name='planKey' /]

    [#if variables?has_content]
        <table id="buildParameters" class="aui">
            <colgroup>
                <col width="40%">
                <col>
            </colgroup>
            <thead>
                <th>[@ww.text name="global.heading.key"/]</th>
                <th>[@ww.text name="global.heading.value"/]</th>
            </thead>
            <tbody>
            [#list variables as entry ]
                <tr>
                    [#assign key=entry.key?html /]
                    [#assign value=entry.value?html /]
                    <td class="grey">${key}</td>
                    <td>[@ww.textfield name="variable_${key}" value=value cssClass="long-field" theme="simple" /]</td>
                </tr>
            [/#list]
            </tbody>
        </table>
    [#else]
        [@ui.messageBox type="info" titleKey="build.editParameterisedManualBuild.noReplaceableVariables" /]
    [/#if]

[/@ww.form]