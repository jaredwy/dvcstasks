[#macro configureVariables id variablesList createVariableUrl deleteVariableUrl]
[#if createVariableUrl?starts_with(req.contextPath)]
    [#assign createVariableAction = createVariableUrl?replace(req.contextPath, '', 'f') /]
[#else ]
    [#assign createVariableAction = createVariableUrl /]
[/#if]
[@ww.form id=id name=id action=createVariableAction]
<table class="aui variables-list">
    <colgroup>
        <col width="30%">
        <col width="*">
        <col width="60">
    </colgroup>
    <thead>
        <tr>
            <th>[@ww.text name='global.heading.key' /]</th>
            <th>[@ww.text name='global.heading.value' /]</th>
            <th class="operations"><span class="assistive">[@ww.text name='global.heading.operations' /]</span></th>
        </tr>
    </thead>
    <tbody>
        <tr id="addVariable">
            <td>
                [@ww.textfield name="variableKey" cssClass="inline-edit-field text" theme="simple" /]
                [#if (fieldErrors["variableKey"])?has_content]
                    [#list fieldErrors["variableKey"] as error]
                        <div class="error">${error?html}</div>
                    [/#list]
                [/#if]
            </td>
            <td>
                [@ww.textfield name="variableValue" cssClass="inline-edit-field text" theme="simple" /]
                [#if (fieldErrors["variableValue"])?has_content]
                    [#list fieldErrors["variableValue"] as error]
                        <div class="error">${error?html}</div>
                    [/#list]
                [/#if]
            </td>
            <td class="operations">[@ww.submit value=action.getText("global.buttons.add") theme="simple" /]</td>
        </tr>
        [#list variablesList as variable]
            <tr id="tr_variable_${variable.id}">
                <td>
                    [@dj.inPlaceEditTextField id="key_${variable.id}" value=variable.key /]
                </td>
                <td>
                    [@dj.inPlaceEditTextField id="value_${variable.id}" value=variable.value /]
                </td>
                <td class="operations">
                    <a id="deleteVariable_${variable.id}" class="deleteVariable" href="${deleteVariableUrl?replace('VARIABLE_ID', variable.id)}" title="[@ww.text name='global.buttons.delete'/]" tabindex="-1">[@ui.icon type="variable-delete" textKey="global.buttons.delete" /]</a>
                </td>
            </tr>
        [/#list]
    </tbody>
</table>
[/@ww.form]
[/#macro]

[#macro displayDefinedVariables id variablesList]
<table class="aui" id="${id}">
    <colgroup>
        <col width="33%"/>
        <col width="67%"/>
    </colgroup>
    <thead>
        <tr>
            <th>[@ww.text name='buildResult.variables.name' /]</th>
            <th>[@ww.text name='buildResult.metadata.value' /]</th>
        </tr>
    </thead>
    [#list variablesList as entry]
        <tr>
            <td>${entry.key?html}</td>
            <td>${entry.value?html}</td>
        </tr>
    [/#list]
</table>
[/#macro]

[#macro displaySubstitutedVariables id variablesList]
<table class="aui" id="${id}">
    <colgroup>
        <col width="33%"/>
        <col width="67%"/>
    </colgroup>
    <thead>
        <tr>
            <th>[@ww.text name='buildResult.variables.name' /]</th>
            <th>[@ww.text name='buildResult.metadata.value' /]</th>
        </tr>
    </thead>
    [#list variablesList as entry]
        <tr>
            <td>${entry.key?html}</td>
            <td[#if entry.variableType == "MANUAL"] class="overridden"[/#if]>${entry.value?html}</td>
        </tr>
    [/#list]
</table>
[/#macro]

[#macro displayManualVariables id variablesList]
    <dl>
        [#list variablesList as entry]
            <dt>${entry.key?html}</dt>
            <dd>${entry.value?html}</dd>
        [/#list]
    </dl>
[/#macro]
