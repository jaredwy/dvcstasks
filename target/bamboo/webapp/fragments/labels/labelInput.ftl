[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.labels.EditLabelsAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.labels.EditLabelsAction" --]
[@ww.form id='labelForm' onsubmit='LabelAjaxObject.addLabels(); return false;' theme='simple']
    [@ww.hidden name='buildKey' /]
    [@ww.hidden name='buildNumber'  /]
    <dl>
        <dt>Labels</dt>
        <dd>
            [#if labels?has_content]
                [#list labels as label]
                    <span onclick="LabelAjaxObject.deleteLabel('${label.name?html?js_string}');" title="Delete label">${label.name?html}</span>
                [/#list]
            [#else]
                None
            [/#if]
        </dd>
        <dt><label for="labelForm_labelInput">Add labels</label></dt>
        <dd>
            [@ww.textfield label='Label' name='labelInput' theme='inline'/]
            <input type="submit" id="done" name="Done" value="Done" />
            <a onclick="LabelAjaxObject.viewLabels()">Cancel</a>
        </dd>
    </dl>
[/@ww.form]
