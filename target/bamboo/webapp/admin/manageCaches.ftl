[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.ManageCachesAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.ManageCachesAction" --]
<html>
<head>
    <title>[@ww.text name='manageCaches.title' /]</title>
</head>

<body>
<h1>[@ww.text name='manageCaches.heading' /]</h1>

[@ui.displayText key='manageCaches.description' /]

[@ww.actionerror /]
[@ww.actionmessage theme='simple' /]

[#list cacheProviders as cacheProvider]
    [#assign provider=cacheProvider.key /]
    <h2>${cacheProvider.name}</h2>
    [@ui.displayText text=cacheProvider.handlerDescription /]
    [@ww.form action="manageCaches!delete.action" id=provider theme="simple"]
    [@ww.hidden name='providerId' value=provider /]
    <p>
            <span>
            [@ww.text name='global.selection.select' /]:
            <span tabindex="0" role="link" selector="${provider}_all">[@ww.text name='global.selection.all' /]</span>,
            <span tabindex="0" role="link" selector="${provider}_none">[@ww.text name='global.selection.none' /]</span>,
            <span tabindex="0" role="link" selector="${provider}_unused">[@ww.text name='manageCaches.status.unused' /]</span>
            </span>

            <span class="formActionsBar">
                [@ww.text name='global.selection.action' /]:
                [@ww.submit value=action.getText("manageCaches.delete.selected.button") theme="simple" name="deleteSelectedButton" id="deleteCacheButton" cssClass="requireConfirmation" cssStyle="display: inline-block;" titleKey="manageCaches.delete.selected.description"/]
                [@ww.submit value=action.getText("manageCaches.delete.unused.button") theme="simple" name="deleteUnusedButton" id="deleteUnusedCachesButton" cssClass="requireConfirmation" cssStyle="display: inline-block;" titleKey="manageCaches.delete.unused.description"/]
            </span>
        <script type="text/javascript">
            AJS.$(function() {
                ConfigurableSelectionActions.init("${provider}");
            });
        </script>
    </p>
    <table id="summary" class="aui">
        <colgroup>
            <col width="5" />
            <col />
            <col width="95" />
            <col width="95" />
        </colgroup>
        <thead>
            <tr>
                <th>&nbsp;</th>
                <th>[@ww.text name='manageCaches.table.heading.location' /]</th>
                <th>[@ww.text name='manageCaches.table.heading.exists' /]</th>
                <th>[@ww.text name='manageCaches.table.heading.operations' /]</th>
            </tr>
        </thead>
        <tbody>
            [#list cacheProvider.cacheDescriptions as cacheDescription]
            <tr>
                [#assign unused=cacheDescription.usingPlans.empty /]
                <td><input name="selectedCaches" type="checkbox" value="${cacheDescription.key}" class="selectorScope_${provider} selector_unused_${unused?string}" /></td>
                <td>
                    ${cacheDescription.location}
                    <div class="subGrey">${cacheDescription.description}</div>
                    [#if unused]
                        <p><em>[@ww.text name='manageCaches.status.unused' /]</em></p>
                    [#else]
                        <ul class="noBullet">
                            [#list cacheDescription.usingPlans as plan]
                            <li>
                                [@ui.renderPlanConfigLink plan=plan /]
                            </li>
                            [/#list]
                        </ul>
                    [/#if]
                </td>
                <td>[@ui.displayYesOrNo displayBool=cacheDescription.exists/]</td>
                <td><a id="delete:${cacheDescription.location}" href="[@ww.url action='manageCaches!delete' namespace='/admin' providerId=provider selectedCaches=cacheDescription.key /]">[@ww.text name='global.buttons.delete' /]</a></td>
            </tr>
            [/#list]
        </tbody>
    </table>
    [/@ww.form]
[/#list]

</body>
</html>


