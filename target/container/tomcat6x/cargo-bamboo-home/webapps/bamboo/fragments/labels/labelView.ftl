[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.labels.EditLabelsAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.labels.EditLabelsAction" --]
[@ww.url id='buildLabelsUrl' action='viewLabels' namespace='/build/label' buildKey='${plan.key}' /]

<dl>
    <dt><a href="${req.contextPath}/browse/${plan.key}/label">Labels</a></dt>
    <dd>
        [#if labels?has_content]
            [#list labels as label]
                <a href="${req.contextPath}/browse/label/${label.name?url}">${label.name?html}</a>&nbsp;
            [/#list]
            [#if user?exists]
                <a onclick="LabelAjaxObject.editLabels();">Edit</a>
            [/#if]
        [#else]
            None&nbsp;
            [#if user?exists]
                <a onclick="LabelAjaxObject.editLabels();">Add</a>
            [/#if]
        [/#if]
    </dd>
</dl>
