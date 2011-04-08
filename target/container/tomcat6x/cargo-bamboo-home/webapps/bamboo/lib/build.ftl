[#import "/agent/commonAgentFunctions.ftl" as agt]

[#-- ================================================================================ @bd.displayArtifactDefinitions --]
[#macro artifactSharingToggleContent shared ]
    [#if shared][#t]
        [@ww.text name='artifact.unshare'/][#t]
    [#else]
        [@ww.text name='artifact.share'/][#t]
    [/#if][#t]
[/#macro]

[#macro displayArtifactDefinitions artifactDefinitions showOperations=true]
[#if artifactDefinitions?has_content]
     <table id="artifactDefinitions" class="aui tablesorter">
         <colgroup>
             [#if showOperations]
                 <col width="30%"/>
                 <col width="35%"/>
                 <col width="25%"/>
                 <col width="10%"/>
             [#else]
                 <col width="35%"/>
                 <col width="35%"/>
                 <col width="30%"/>
             [/#if]
         </colgroup>
         <thead>
             <tr>
                 <th>[@ww.text name='artifact.name'/]</th>
                 <th>[@ww.text name='artifact.location'/]</th>
                 <th>[@ww.text name='artifact.copyPattern'/]</th>
                 [#if showOperations]
                     <th>[@ww.text name='global.heading.operations'/]</th>
                 [/#if]
             </tr>
         </thead>
         <tbody>
             [#list artifactDefinitions as artifact]
             <tr id="artifactDefinition-${artifact.id}">
                 <td>
                    [#if artifact.sharedArtifact]
                        [@ui.icon type="artifact-shared"/]
                    [#else]
                        [@ui.icon type="artifact"/]
                    [/#if] <span class="artifactName">${artifact.name}</span>
                 </td>
                 <td>${artifact.location!}</td>
                 <td>${artifact.copyPattern}</td>
                 [#if showOperations]
                     <td>
                         <a id="toggleArtifactDefinitionSharing-${artifact.id}" class="toggleArtifactDefinitionSharing">[@artifactSharingToggleContent artifact.sharedArtifact /]</a>
                         |
                         <a id="editArtifactDefinition-${artifact.id}" class="editArtifactDefinition" >[@ww.text name='global.buttons.edit'/]</a>
                         |
                         <a id="deleteArtifactDefinition-${artifact.id}" class="deleteArtifactDefinition[#if artifact.subscriptions?has_content] hasSubscriptions[/#if]">[@ww.text name='global.buttons.delete'/]</a>
                     </td>
                 [/#if]
             </tr>
             [/#list]
         </tbody>
     </table>

    [#if showOperations]
        <script type="text/javascript">
            AJS.$(function () {
                ArtifactDefinitionEdit.init({
                    html: {
                        artifactSharingToggleContentShared: '[@artifactSharingToggleContent true /]',
                        artifactSharingToggleContentUnshared: '[@artifactSharingToggleContent false /]'
                    },
                    i18n: {
                        artifact_definition_shareToggle_error: "[@ww.text name='artifact.definition.shareToggle.error'/]",
                        artifact_definition_shareToggle_error_header: "[@ww.text name='artifact.definition.shareToggle.error.header'/]",
                        global_buttons_close: "[@ww.text name='global.buttons.close'/]"
                    },
                    deleteArtifactDefinition: {
                        actionUrl: "[@ww.url action='confirmDeleteArtifactDefinition' namespace='/ajax' planKey=plan.key /]",
                        submitLabel: "[@ww.text name='global.buttons.delete'/]",
                        title: "[@ww.text name='artifact.definition.delete'/]"
                    },
                    editArtifactDefinition: {
                        actionUrl: "[@ww.url action='editArtifactDefinition' namespace='/ajax' planKey=plan.key /]",
                        submitLabel: "[@ww.text name='global.buttons.update'/]",
                        title: "[@ww.text name='artifact.definition.edit'/]"
                    },
                    renameArtifactDefinitionToEnableSharing: {
                        actionUrl: "[@ww.url action='renameArtifactDefinitionToEnableSharing' namespace='/ajax' planKey=plan.key /]",
                        submitLabel: "[@ww.text name='artifact.definition.shareToggle.rename.saveAndShare'/]",
                        title: "[@ww.text name='artifact.definition.shareToggle.rename'/]"
                    },
                    toggleArtifactDefinitionSharing: {
                        actionUrl: "[@ww.url action='toggleArtifactDefinitionSharing' namespace='/ajax' /]",
                        submitLabel: "[@ww.text name='global.buttons.update'/]",
                        title: "[@ww.text name='artifact.definition.edit'/]"
                    },
                    confirmToggleArtifactDefinitionSharing: {
                        actionUrl: "[@ww.url action='confirmToggleSharedArtifact' namespace='/ajax' planKey=plan.key /]",
                        submitLabel: "[@ww.text name='artifact.unshare'/]",
                        title: "[@ww.text name='artifact.unshare.title'/]"
                    }
                });
            });
        </script>
    [/#if]

[/#if]

[/#macro]

 [#-- ================================================================================ @bd.displayArtifactDefinitions --]
[#macro displayArtifactSubscriptions artifactSubscriptions showOperations=true showSubstitutionVariables=false]

[#if artifactSubscriptions?has_content]
    [#if showOperations]
        <script type="text/javascript">
            function editArtifactSubscriptionCallback(result) {
                var subscription = result.artifactSubscription;
                var cells = AJS.$("#artifactSubscription-" + subscription.id + " > td");
                AJS.$("> a", cells[0]).replaceWith("<a href='${req.contextPath}/build/admin/edit/defaultBuildArtifact.action?buildKey=" + subscription.producerJobKey + "'>" + subscription.name + "</a>");
                AJS.$(cells[1]).text(subscription.destination);
            }
            function deleteArtifactSubscriptionCallback(result) {
                var subscription = result.artifactSubscription;

                if (AJS.$("#artifactSubscriptions > tbody > tr").length == 1) {
                    AJS.$("#artifactSubscriptions").remove();
                } else {
                    AJS.$("#artifactSubscription-" + subscription.id).remove();
                }
            }
            AJS.$(function(){
                AJS.$("#artifactSubscriptions").tablesorter({
                    headers: {2:{sorter:false}},
                    sortList: [[0,0]]
                });
            });
        </script>

    [/#if]

    <table id="artifactSubscriptions" class="aui tablesorter artifact">
        <colgroup>
            <col width="15%"/>
            <col width="35%"/>
            <col width="10%"/>
        </colgroup>
        <thead>
            <tr>
                <th>[@ww.text name='artifact.subscription.name'/]</th>
                <th>[@ww.text name='artifact.subscription.destination'/]</th>
                [#if showOperations]
                    <th>[@ww.text name='global.heading.operations'/]</th>
                [/#if]
                [#if showSubstitutionVariables]
                    <th>[@ww.text name='artifact.subscription.variableName'/]</th>
                [/#if]
            </tr>
        </thead>
        <tbody>
            [#list artifactSubscriptions as subscription]
            <tr id="artifactSubscription-${subscription.id}">
                <td>[@ui.icon type="artifact-shared"/] <a id="producerJob-${subscription.id}" href="[@ww.url action='defaultBuildArtifact' namespace='/build/admin/edit' buildKey=subscription.artifactDefinition.producerJob.key /]">${subscription.artifactDefinition.name}</a></td>
                <td class="artifact">
                    [#if subscription.destinationDirectory?has_content]
                        ${subscription.destinationDirectory}
                    [#else]
                        <span class="subGrey">[@ww.text name="artifact.subscription.destination.default"/]</span>
                    [/#if]
                </td>
                [#if showOperations]
                    <td>
                        <a id="editArtifactSubscription-${subscription.id}" title="[@ww.text name='artifact.subscription.edit.form'/]">[@ww.text name='global.buttons.edit'/]</a>
                        |
                        <a id="deleteArtifactSubscription-${subscription.id}" title="[@ww.text name='artifact.subscription.delete.form'/]">[@ww.text name='global.buttons.delete'/]</a>

                        [@dj.simpleDialogForm
                            triggerSelector="#editArtifactSubscription-${subscription.id}"
                            actionUrl="/ajax/editArtifactSubscription.action?planKey=${planKey}&subscriptionId=${subscription.id}&artifactDefinitionId=${subscription.artifactDefinition.id}"
                            width=800 height=400
                            submitLabelKey="global.buttons.update"
                            submitMode="ajax"
                            submitCallback="editArtifactSubscriptionCallback"
                        /]
                        [@dj.simpleDialogForm
                            triggerSelector="#deleteArtifactSubscription-${subscription.id}"
                            actionUrl="/ajax/confirmDeleteArtifactSubscription.action?planKey=${planKey}&subscriptionId=${subscription.id}"
                            width=800 height=400
                            submitLabelKey="global.buttons.delete"
                            submitMode="ajax"
                            submitCallback="deleteArtifactSubscriptionCallback"
                        /]
                    </td>
                [/#if]
                [#if showSubstitutionVariables]
                    <td>${subscription.variableName?html}</td>
                [/#if]
            </tr>
            [/#list]
        </tbody>
    </table>
[/#if]

[/#macro]

[#-- ======================================================================================== @build.showJdk --]
[#macro showJdk ]
[@ww.label labelKey='builder.common.jdk' name='plan.buildDefinition.builder.buildJdk' /]
[#if !builder.jdkValid]
    [@ui.messageBox type="warning"]
        [@ww.text name='builder.common.jdk.invalid' ]
            [@ww.param]${builder.buildJdk!}[/@ww.param]
        [/@ww.text]
        [#if fn.hasGlobalAdminPermission() ]
            [@ww.text name='builder.common.jdk.invalid.admin' ]
                [@ww.param]<a href="${req.contextPath}/admin/agent/configureSharedLocalCapabilities.action?capabilityType=jdk&jdkLabel=${builder.buildJdk!}">[/@ww.param]
                [@ww.param]</a>[/@ww.param]
            [/@ww.text]
        [/#if]
    [/@ui.messageBox]
[/#if]
[/#macro]
[#-- ======================================================================================== @build.configureRequirement --]
[#macro configureBuildRequirement showForm=true showOperations=true]
 
    [#if (plan.requirementSet.requirements)?has_content]
    [#assign decoratedObjects = requirementSetDecorator.decoratedObjects /]
    <p>[@ww.text name='requirement.description' ][@ww.param name="value" value="${decoratedObjects.size()}"/][/@ww.text]
        [#if executableAgentMatrix.buildAgents?has_content]
            [#if plan.key??]
                <a href="${req.contextPath}/agent/viewAgents.action?planKey=${plan.key}&amp;returnUrl=/browse/${plan.key}/config" id='executableAgentsText'>
                    [@ww.text name='requirement.executableAgents.descriptionValue' ]
                        [@ww.param name="value" value="${executableAgentMatrix.buildAgents.size()}"/]
                    [/@ww.text]
                </a> [#t]
                [@ww.text name='requirement.executableAgents.descriptionText']
                    [@ww.param name="value" value="${executableAgentMatrix.buildAgents.size()}"/]
                [/@ww.text][#t]
                [#if !executableAgentMatrix.onlineEnabledBuildAgents?has_content]
                    <span class="errorText">
                        [@ww.text name='requirement.onlineEnabledExecutableAgents.empty']
                            [@ww.param name="value" value="${executableAgentMatrix.buildAgents.size()}"/]
                        [/@ww.text][#t]
                    </span>
                [/#if]
                <script type="text/javascript">
                addUniversalOnload(function(){
                    attachActionToTooltip({
                        targetId: "executableAgentsText",
                        actionName: "viewAgentsMatchingRequirements",
                        planKey: "${plan.key}",
                        hideDelay: 270,
                        showDelay: 200,
                        width: 250,
                        offSetY: 7
                    });
                });
                </script>
            [#else]
                [@ww.text name='requirement.executableAgents.description' ]
                    [@ww.param name="value" value="${executableAgentMatrix.buildAgents.size()}"/]
                [/@ww.text][#t]
            [/#if]
        [#else]
            <span [#if !elasticBambooEnabled || !executableAgentMatrix.imageMatches?has_content ]class="errorText".[/#if]>[@ww.text name='requirement.executableAgents.empty' /]</span>
        [/#if]
        [#if elasticBambooEnabled]
            [#assign iconHtml]
                <sup>
                [#if fn.hasAdminPermission() ]
                    <a href="${req.contextPath}/admin/elastic/manageElasticInstances.action" >
                        <img class="elasticIcon" src="${req.contextPath}/images/jt/icn_elastic_cloud.gif" alt="(elastic)" title="Manage Elastic Instances"/>
                    </a>
               [#else]
                    <img class="elasticIcon" src="${req.contextPath}/images/jt/icn_elastic_cloud.gif" alt="(elastic)" title="Manage Elastic Instances"/>
               [/#if]
               </sup>
            [/#assign]
            [#if executableAgentMatrix.imageMatches?has_content ]
                [#if plan.key??]
                    [@ww.text name="requirement.executableImages.descriptionText" ]
                        [@ww.param]${iconHtml}[/@ww.param]
                    [/@ww.text] [#t]
                    <a href="${req.contextPath}/agent/viewAgents.action?planKey=${plan.key}&amp;returnUrl=/browse/${plan.key}/config#elasticImages" id='executableImageText'>
                    [@ww.text name="requirement.executableImages.descriptionValue" ]
                        [@ww.param name="value" value="${executableAgentMatrix.imageMatches.size()}"/]
                    [/@ww.text]
                    </a>
                    <script type="text/javascript">
                    addUniversalOnload(function(){
                        attachActionToTooltip({
                            targetId: "executableImageText",
                            actionName: "viewImagesMatchingRequirements",
                            planKey: "${plan.key}",
                            hideDelay: 270,
                            showDelay: 200,
                            width: 250,
                            offSetY: 7
                        });
                    });
                    </script>
                [#else]
                    [@ww.text name='requirement.executableImages.description' ]
                        [@ww.param name="value" value="${executableAgentMatrix.buildAgents.size()}"/]
                    [/@ww.text][#t]
                [/#if]
            [#else]
                <span [#if !executableAgentMatrix.buildAgents?has_content]class="errorText"[/#if]>
                    [@ww.text name="requirement.noExecutableImages.description" ]
                        [@ww.param]${iconHtml}[/@ww.param]
                    [/@ww.text]
                </span>
            [/#if]
        [/#if]
        </p>

        <table id="requirements" class="aui">
            <thead>
                <tr>
                    <th colspan="4">[@ww.text name='requirement.current' /]</th>
                    <th class="matchingAgents">[@ww.text name="requirement.executableAgents.matching"/]</th>
                    [#if elasticBambooEnabled ]
                    <th class="matchingAgents">[@ww.text name="requirement.executableImages.matching"/]</th>
                    [/#if]
                    [#if showOperations]
                    <th>[@ww.text name='global.heading.operations' /]</th>
                    [/#if]
                </tr>
            </thead>
            <tbody>
                [#list decoratedObjects as requirement]
                    [#assign matchingAgentsForRequirement = (executableAgentMatrix.getBuildAgents(requirement.key))!('') /]
                    [#if elasticBambooEnabled]
                        [#assign matchingImageForRequirement = (executableAgentMatrix.getImageFromMatrix(requirement.key))!('') /]
                    [/#if]
                    <tr [#if !matchingAgentsForRequirement?has_content && !matchingImageForRequirement?has_content ] class="noAgents" [/#if]>
                        <td class="labelPrefixCell">
                            [@ww.text name='agent.capability.type.${requirement.capabilityGroup.typeKey}.title' /]
                        </td>
                        <td class="labelCell">
                            [#if fn.hasGlobalAdminPermission()]
                                <a href="[@ww.url action='viewCapabilityKey' namespace='/admin/agent' capabilityKey=requirement.key /]">${requirement.label?html}</a>
                            [#else]
                                ${requirement.label?html}
                            [/#if]
                        </td>
                        <td class="valueCell" title="[@ww.text name='requirement.matchType.${requirement.matchType}.description' /]">
                            [@ww.text name='requirement.matchType.${requirement.matchType}' /][#rt]
                    [#if requirement.matchValue?has_content]
                        </td>
                        <td class="valueCell2">
                            <span>${requirement.matchValue!?html}</span>
                        </td>
                    [#else]
                            [#lt]
                        </td>
                        <td class="valueCell2"></td>
                    [/#if]
                        <td class="matchingAgents">
                            [#if matchingAgentsForRequirement?has_content]
                                ${matchingAgentsForRequirement.size()}
                            [#else]
                                0
                            [/#if]
                        </td>
                        [#if elasticBambooEnabled ]
                        <td class="matchingAgents">
                            [#assign matchingImageForRequirement = (executableAgentMatrix.getImageFromMatrix(requirement.key))!('') /]
                            [#if matchingImageForRequirement?has_content]
                                ${matchingImageForRequirement.size()}
                            [#else]
                                0
                            [/#if]
                        </td>
                        [/#if]
                    [#if showOperations]
                        <td class="operations">
                            [@agt.showRequirementOperations requirement=requirement build=plan/]
                        </td>
                    [/#if]
                    </tr>
                [/#list]
            </tbody>
        </table>
    [#else]
        <p>[@ww.text name='requirement.empty' /]</p>
    [/#if]


[#if showForm]
[@ui.bambooSection titleKey='requirement.add' descriptionKey='requirement.add.description']
    [@ww.hidden name='buildKey' value=plan.key /]

    [@ww.select labelKey='requirement.add.requirement' name='existingRequirement'
        list=capabilityKeys.decoratedObjects listKey='key' listValue='label' groupBy='capabilityGroup.typeLabel'
        headerKey='' headerValue='${action.getText("requirement.add.new")}'  toggle='true']
    [/@ww.select]
                
    [@ui.bambooSection dependsOn='existingRequirement' showOn='']
        [@ww.textfield labelKey='requirement.key' name='requirementKey' /]
    [/@ui.bambooSection]

    [@ww.select name='requirementMatchType' toggle='true'
        list=matchTypeOptions listKey='name' listValue='label' ]
    [/@ww.select]

    [@ui.bambooSection dependsOn='requirementMatchType' showOn='equal']
        [@ww.textfield name='requirementMatchValue' /]
    [/@ui.bambooSection]

    [@ui.bambooSection dependsOn='requirementMatchType' showOn='match']
        [@ww.textfield name='regexMatchValue' descriptionKey='requirement.add.regex.description'/]
    [/@ui.bambooSection]

    [@ui.buttons]
        <input type="submit" name="[@ww.text name='global.buttons.add' /]" value="[@ww.text name='global.buttons.add' /]" class="button submit" />
        <a id="cancelButton" href="${req.contextPath}/browse/${plan.key}/config" class="cancel">[@ww.text name='global.buttons.cancel' /]</a>
    [/@ui.buttons]
[/@ui.bambooSection]
[/#if]

[/#macro]



[#-- ======================================================================================== @build.configurePostAction --]
[#macro configurePostAction]

[/#macro]

[#-- ====================================================================================== @bd.notificationWarnings --]
[#macro notificationWarnings]
<div id="bd_notificationWarnings">
    [@cp.displayNotificationWarnings messageKey='notification.both.notConfigured' addServerKey='notification.both.add' cssClass='error hidden' id='bd_notificationWarnings_notification_both_notConfigured'/]
    [@cp.displayNotificationWarnings messageKey='notification.mail.notConfigured' addServerKey='notification.mail.add' cssClass='warning hidden' id='bd_notificationWarnings_notification_mail_notConfigured'/]
    [@cp.displayNotificationWarnings messageKey='notification.im.notConfigured' addServerKey='notification.im.add' cssClass='warning hidden' id='bd_notificationWarnings_notification_im_notConfigured'/]

    <script type="text/javascript">

        var notificationWarningsController = function()
        {
            var mailServerConfigured   = ${mailServerConfigured?string};
            var imServerConfigured = ${jabberServerConfigured?string};

            var updateDisplay = function()
            {
                var container = AJS.$("#bd_notificationWarnings");
                AJS.$("div.notificationWarning", container).hide();
                if (!mailServerConfigured && !imServerConfigured)
                {
                    AJS.$("#bd_notificationWarnings_notification_both_notConfigured", container).show();
                }
                else if (!mailServerConfigured)
                {
                    AJS.$("#bd_notificationWarnings_notification_mail_notConfigured", container).show();
                }
                else if (!imServerConfigured)
                {
                    AJS.$("#bd_notificationWarnings_notification_im_notConfigured", container).show();
                }
            };

            var mailServerConfiguredCallback = function()
            {
                mailServerConfigured = true;
                updateDisplay();
            };

            var imServerConfiguredCallback = function()
            {
                imServerConfigured = true;
                updateDisplay();
            };

            return {
                updateDisplay: updateDisplay,
                mailServerConfiguredCallback: mailServerConfiguredCallback,
                imServerConfiguredCallback: imServerConfiguredCallback
            };
        }();

        AJS.$(document).ready(notificationWarningsController.updateDisplay);

    </script>

    [#if !mailServerConfigured]
        [@dj.simpleDialogForm
            triggerSelector=".addMailServerInline"
            actionUrl="/ajax/configureMailServerInline.action?returnUrl=${currentUrl}"
            width=860 height=540
            submitLabelKey="global.buttons.update"
            submitMode="ajax"
            submitCallback="notificationWarningsController.mailServerConfiguredCallback"
        /]
    [/#if]

    [#if !jabberServerConfigured]
        [@dj.simpleDialogForm
            triggerSelector=".addInstantMessagingServerInline"
            actionUrl="/ajax/configureInstantMessagingServerInline.action?returnUrl=${currentUrl}"
            width=800 height=415
            submitLabelKey="global.buttons.update"
            submitMode="ajax"
            submitCallback="notificationWarningsController.imServerConfiguredCallback"
        /]
    [/#if]

</div>
[/#macro]

[#-- ======================================================================================== @build.existingNotificationsTable --]

[#macro existingNotificationsTable showDesc=true showColumnSpecificHeading=true showOperationsColumn=true editUrl='' deleteUrl='']
        [#if plan.notificationSet?has_content && plan.notificationSet.notificationRules?has_content]
            [#if showDesc]
                <p>[@ww.text name='notification.description' /]</p>
            [/#if]
            [@displayNotificationRulesTable plan.notificationSet.sortedNotificationRules showColumnSpecificHeading showOpertationsColumn editUrl deleteUrl/]
        [#else]
            <p>[@ww.text name='notification.empty' /]</p>
        [/#if]
[/#macro]

[#-- ======================================================================================== @build.displayNotificationRulesTable --]

[#macro displayNotificationRulesTable notificationRules showColumnSpecificHeading=true showOperationsColumn=true editUrl='' deleteUrl='']
            <table id="notificationTable" class="aui">
                <colgroup>
                    <col width="40%">
                    <col>
                    <col width="150" >
                </colgroup>
                <thead>
                <tr>
                [#if showColumnSpecificHeading]
                    <th class="notificationHeadingBar" colspan="3">[@ww.text name='notification.current' /]</th>
                [#else]
                    <th>[@ww.text name='bulkAction.notification.eventHeading' /]</th>
                    <th colspan="2">[@ww.text name='bulkAction.notification.recipientHeading' /]</th>
                [/#if]
                </tr>
                </thead>
                <tbody>
                [#list notificationRules as notification]
                    [#-- Setting the newRow group variable --]
                    [#if notification.notificationTypeForView?has_content]
                         [#if notification.notificationTypeForView.getViewHtml()?has_content]
                               [#assign thisNotificationType=notification.notificationTypeForView.getViewHtml() /]
                         [#else]
                               [#assign thisNotificationType=notification.notificationTypeForView.name /]
                         [/#if]
                    [#else]
                         [#assign thisNotificationType=notification.conditionKey /]
                    [/#if]

                    [#if !lastNotificationType?has_content || lastNotificationType != thisNotificationType]
                        [#assign newRow = true /]
                    [#else]
                        [#assign newRow = false /]
                    [/#if]

                    [#assign lastNotificationType=thisNotificationType /]

                    <tr [#if lastModified?has_content && lastModified=notification.id]class="selectedNotification"[#else]class="notificationRule" [/#if] >
                        <td [#if newRow]class="notificationGroupTop" [#else] class="notificationGroupMiddle" [/#if] >
                            [#if newRow]${thisNotificationType}[/#if]
                        </td>
                        <td [#if lastModified?has_content && lastModified=notification.id]class="selectedNotification notificationMiddleColumn"[#else]class="notificationMiddleColumn"[/#if][#if !showOperationsColumn]colspan="2"[/#if]">
                            [#if notification.notificationRecipient?has_content]
                                [#if notification.notificationRecipient.getViewHtml()?has_content]
                                    ${notification.notificationRecipient.getViewHtml()}
                                [#else]
                                    ${notification.notificationRecipient.description()}
                                [/#if]
                             [#else]
                                   ${notification.recipientType}: ${notification.recipient}
                             [/#if]
                        </td>
                        [#if showOperationsColumn]
                        <td [#if lastModified?has_content && lastModified=notification.id]class="selectedNotification notificationLastColumn"[#else]class="notificationLastColumn"[/#if]">
                                [#if editUrl?has_content]
                                    <a id="editNotification:${notification.getId()}" href="${editUrl}&notificationId=${notification.getId()}&edit=true">Edit</a>
                                [/#if]
                                [#if editUrl?has_content && deleteUrl?has_content]
                                    |
                                [/#if]
                                [#if deleteUrl?has_content]
                                    <a id="deleteNotification:${notification.getId()}" href="${deleteUrl}&notificationId=${notification.getId()}">Remove</a>
                                [/#if]
                        </td>
                        [/#if]
                    </tr>
                [/#list]
                </tbody>
            </table>
[/#macro]

[#-- ======================================================================================== @build.configureBuildNotificationsForm --]

[#macro configureBuildNotificationsForm showActionErrors=true showFormButtons=true groupEvents=false]
    [#if edit?has_content && edit=="true"]
        [#assign titleKey="notification.edit.title" /]
    [#else]
        [#assign titleKey="notification.add.title" /]
    [/#if]

    <div id="addNotificationForm">
    [@ui.bambooSection titleKey='${titleKey}' descriptionKey='notification.add.description']
            [@commonNotificationFormContent showActionErrors groupEvents/]
            [#if edit?has_content]
                [@ww.hidden name='edit' /]
            [/#if]
        [#if showFormButtons]
            [@ui.buttons]
                <input type="submit" name="[@ww.text name='global.buttons.add' /]" value="[@ww.text name='global.buttons.add' /]" class="button submit" />
                <a id="cancelButton" href="${req.contextPath}/browse/${plan.key}/config" class="cancel">[@ww.text name='global.buttons.cancel' /]</a>
            [/@ui.buttons]
        [/#if]
    [/@ui.bambooSection]
    </div>
[/#macro]

[#-- ======================================================================================== @build.configureSystemNotificationsForm --]

[#macro configureSystemNotificationsForm showActionErrors=true edit=false showFormButtons=true]
    [#if edit]
        [#assign titleKey="system.notification.edit.title" /]
    [#else]
        [#assign titleKey="system.notification.add.title" /]
    [/#if]

    <div id="addNotificationForm">
    [@ui.bambooSection titleKey='${titleKey}' descriptionKey='notification.add.description']
            [@commonNotificationFormContent showActionErrors/]
            [#if showFormButtons]
            <div class="formFooter buttons">
                <input type="submit" name="[@ww.text name='global.buttons.add' /]" value="[@ww.text name='global.buttons.add' /]" />
                <input type="submit" name="[@ww.text name='cancelButton' /]" value="[@ww.text name='global.buttons.cancel' /]" />
            </div>
            [/#if]
    [/@ui.bambooSection]
    </div>
[/#macro]

[#-- ======================================================================================== @build.commonNotificationFormContent --]

[#macro commonNotificationFormContent showActionErrors=true groupEvents=false]
            [#if showActionErrors]
                [@ww.actionerror /]
            [/#if]

            [#if groupEvents]
                [@ww.select labelKey='notification.condition' name='conditionKey' toggle='true'
                        listValue='name' listKey='key'
                        optionDescription='description'
                        list=allNotificationEventTypes multiple='false' groupBy="scope.displayName" /]
            [#else]
                [@ww.select labelKey='notification.condition' name='conditionKey' toggle='true'
                        listValue='name' listKey='key'
                        optionDescription='description'
                        list=allNotificationEventTypes multiple='false'/]
            [/#if]

            [#list allNotificationEventTypes as condition]
                [@ui.bambooSection dependsOn='conditionKey' showOn='${condition.key}']
                     ${condition.getEditHtml()}
                [/@ui.bambooSection]
            [/#list]

            [@ww.select labelKey='notification.recipients.types' name='notificationRecipientType'
               list=allNotificationRecipientTypes listKey='key' listValue='description' multiple='false' toggle='true'/]

            [#list allNotificationRecipientTypes as recipient]
                [@ui.bambooSection dependsOn='notificationRecipientType' showOn='${recipient.key}']
                     ${recipient.getEditHtml()}
                [/@ui.bambooSection]
            [/#list]
[/#macro]
[#-- ====================================================================================== @build.configurePermissions --]

[#macro configurePermissions action cancelUri='' backLabelKey='']

[@ww.form action='${action}'
            submitLabelKey='global.buttons.update'
            titleKey='build.permissions.title'
            id='permissions'
            cancelUri='${cancelUri}'
            backLabelKey='${backLabelKey}' ]

    [#if buildKey??]
        [@ww.hidden name='buildKey' /]
    [#elseif plan??]
        [@ww.hidden name='buildKey' value='${plan.key}' /]
    [/#if]

    [#if buildIds?has_content]
        [#list buildIds as buildId]
            [@ww.hidden name='buildIds' value='${buildId}' /]
        [/#list]
    [/#if]

    <div class="descriptionSection">
        [@ww.text name='build.permissions.description' /]
    </div>
    <div class="permissionForm">
        <div class="formArea">
        [#if grantedUsers?has_content]
            <table class="aui permissions" id="configureBuildUserPermissions">
            <thead>
            <tr>
                <th>[@ww.text name='build.permissions.users.title' /]</th>
                <th class="checkboxCell">[@ww.text name='build.permissions.type.view.heading' /]</th>
                <th class="checkboxCell">[@ww.text name='build.permissions.type.edit.heading' /]</th>
                <th class="checkboxCell">[@ww.text name='build.permissions.type.build.heading' /]</th>
                <th class="checkboxCell">[@ww.text name='build.permissions.type.clone.heading' /]</th>
                <th class="checkboxCell">[@ww.text name='build.permissions.type.admin.heading' /]</th>
            </tr>
            </thead>
            [#list grantedUsers as user]
            <tr>
                <td>${user}</td>
                [@permissionCheckBox principal='${user}' permission='READ' /]
                [@permissionCheckBox principal='${user}' permission='WRITE' /]
                [@permissionCheckBox principal='${user}' permission='BUILD' /]
                [@permissionCheckBox principal='${user}' permission='CLONE' /]
                [@permissionCheckBox principal='${user}' permission='ADMINISTRATION' /]

            </tr>
            [/#list]
            </table>
        [/#if]

        [#if grantedGroups?has_content]
            <table class="aui permissions" id="configureBuildGroupPermissions">
            <thead>
            <tr>
                <th>[@ww.text name='build.permissions.groups.title' /]</th>
                <th class="checkboxCell">[@ww.text name='build.permissions.type.view.heading' /]</th>
                <th class="checkboxCell">[@ww.text name='build.permissions.type.edit.heading' /]</th>
                <th class="checkboxCell">[@ww.text name='build.permissions.type.build.heading' /]</th>
                <th class="checkboxCell">[@ww.text name='build.permissions.type.clone.heading' /]</th>
                <th class="checkboxCell">[@ww.text name='build.permissions.type.admin.heading' /]</th>
            </tr>
            </thead>

            [#list grantedGroups as group]
            <tr>
                <td>${group}</td>
                [@permissionCheckBox principal='${group}' type='group' permission='READ' /]
                [@permissionCheckBox principal='${group}' type='group' permission='WRITE' /]
                [@permissionCheckBox principal='${group}' type='group' permission='BUILD' /]
                [@permissionCheckBox principal='${group}' type='group' permission='CLONE' /]
                [@permissionCheckBox principal='${group}' type='group' permission='ADMINISTRATION' /]

            </tr>
            [/#list]
            </table>
        [/#if]

        <table class="aui permissions" id="configureBuildOtherPermissions">
            <thead>
            <tr>
                <th>[@ww.text name='build.permissions.other.title' /]</th>
                <th class="checkboxCell">[@ww.text name='build.permissions.type.view.heading' /]</th>
                <th class="checkboxCell">[@ww.text name='build.permissions.type.edit.heading' /]</th>
                <th class="checkboxCell">[@ww.text name='build.permissions.type.build.heading' /]</th>
                <th class="checkboxCell">[@ww.text name='build.permissions.type.clone.heading' /]</th>
                <th class="checkboxCell">[@ww.text name='build.permissions.type.admin.heading' /]</th>
            </tr>
            </thead>
            <tr>
                <td>[@ww.text name='build.permissions.loggedIn.title' /]</td>
                [@permissionCheckBox principal='ROLE_USER' type='role' permission='READ' /]
                [@permissionCheckBox principal='ROLE_USER' type='role' permission='WRITE' /]
                [@permissionCheckBox principal='ROLE_USER' type='role' permission='BUILD' /]
                [@permissionCheckBox principal='ROLE_USER' type='role' permission='CLONE' /]
                [@permissionCheckBox principal='ROLE_USER' type='role' permission='ADMINISTRATION' /]
            </tr>
            <tr>
                <td>[@ww.text name='build.permissions.anonymous.title' /]</td>
                [@permissionCheckBox principal='ROLE_ANONYMOUS' type='role' permission='READ' /]
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
        </table>

    <h3>[@ww.text name='build.permission.form.add.title'/]</h3>
    <div class="permissionFieldLabel">
         [@ww.select name='principalType' list=['User', 'Group'] toggle='true' ][/@ww.select]
    </div>

    [@ui.bambooSection dependsOn='principalType' showOn='User']
        [@ww.textfield name='newUser' template='userPicker' multiSelect=false /]
        [@ui.buttons]
            <input type="submit" name="addUserPrincipal" value="Add"/>
        [/@ui.buttons]
    [/@ui.bambooSection]

    [@ui.bambooSection dependsOn='principalType' showOn='Group']
        [@ww.textfield name='newGroup' /]
        [@ui.buttons]
            <input type="submit" name="addGroupPrincipal" value="Add"/>
        [/@ui.buttons]
    [/@ui.bambooSection]

        </div>
        <div class="helpTextArea">
            <span class="helpTextHeading">[@ww.text name='build.permissions.type.heading' /]</span>
            <ul>
                <li><strong>[@ww.text name='build.permissions.type.view.heading' /]</strong> - [@ww.text name='build.permissions.type.view.description' /]</li>
                <li><strong>[@ww.text name='build.permissions.type.edit.heading' /]</strong> - [@ww.text name='build.permissions.type.edit.description' /]</li>
                <li><strong>[@ww.text name='build.permissions.type.build.heading' /]</strong> - [@ww.text name='build.permissions.type.build.description' /]</li>
                <li><strong>[@ww.text name='build.permissions.type.clone.heading' /]</strong> - [@ww.text name='build.permissions.type.clone.description' /]</li>
                <li><strong>[@ww.text name='build.permissions.type.admin.heading' /]</strong> - [@ww.text name='build.permissions.type.admin.description' /]</li>
            </ul>
            <div class="helpTextNote"><div class="helpTextHeading">[@ww.text name='build.permission.noteGlobalPermission.heading' /]</div>
            <ul>
                <li>[@ww.text name='build.permission.noteGlobalPermission.description' /]</li>
            </ul></div>
        </div>
    </div>
    [@ui.clear /]
[/@ww.form]

[/#macro]

[#-- ======================================================================================== @build.permissionCheckBox --]

[#macro permissionCheckBox principal permission type='user' ]
    [#assign fieldname='bambooPermission_${type}_${principal}_${permission}' /]
    [#assign granted=grantedPermissions.contains(fieldname) /]
    <td class="checkboxCell clickable" id="${fieldname}_cell"><input type="checkbox" name="${fieldname}" [#if granted]checked[/#if] />
    <script type="text/javascript">
        attachHandler('${fieldname}_cell', 'click', toggleContainingCheckbox)
    </script>

    </td>
[/#macro]

[#-- ======================================================================================== @build.liveActivity --]

[#macro liveActivity expandable=true section=true]
[@ww.url id='getBuildsUrl' namespace='/build/admin/ajax' action='getBuilds' /]
[@ww.url id='getChangesUrl' value='/rest/api/latest/result/' /]
[@ww.url id='unknownJiraType' value='/images/icons/jira_type_unknown.gif' /]
[@ww.text id='queueEmptyText' name='job.liveactivity.noactivity'/]
[@ww.text id='cancelBuildText' name='agent.build.cancel' /]
[@ww.text id='cancellingBuildText' name='agent.build.cancelling' /]
[@ww.text id='noAdditionalInfoText' name='plan.liveactivity.build.noadditionalinfo' /]

<div id="liveActivity" [#if section]class="section"[/#if]>
    <p>${queueEmptyText}</p>
</div>
<script type="text/x-template" title="buildListItem-template">
    [@buildListItem buildResultKey="{buildResultKey}" cssClass="{cssClass}" triggerReason="{triggerReason}" buildingOn="{buildingOn}" planKey="{planKey}" buildMessage="{buildMessage}" /]
</script>
<script type="text/x-template" title="buildingOn-template">
    [@buildingOn agentId="{agentId}" agentType="{agentType}" agentName="{agentName}" /]
</script>
<script type="text/x-template" title="buildMessage-template">
    [@message type="{type}"]{text}[/@message]
</script>
<script type="text/x-template" title="jiraIssue-template">
    <li>
        <a title="View this issue" href="{url}?page=com.atlassian.jira.plugin.ext.bamboo%3Abamboo-build-results-tabpanel"><img alt="{issueType}" src="{issueIconUrl}" class="issueTypeImg"/></a>
        <h3><a href="{url}">{key}</a></h3>
        <p class="jiraIssueDetails">{details}</p>
    </li>
</script>
<script type="text/x-template" title="codeChange-changesetLink-template">
    <a href="{commitUrl}" class="rightFloat">({changesetId})</a>
</script>
<script type="text/x-template" title="codeChange-changesetDisplay-template">
    <span class="rightFloat">({changesetId})</span>
</script>
<script type="text/x-template" title="codeChange-template">
    <li>
        {changesetInfo}
        <img alt="{author}" src="[@ww.url value='/images/icons/businessman.gif' /]" class="profileImage"/>
        <h3><a href="${req.contextPath}/browse/{authorOrUser}/{author}">{displayName}</a></h3>
        <p>{comment}</p>
    </li>
</script>
<script type="text/javascript">
    AJS.$(function () {
        LiveActivity.init({
            planKey: "${build.planKey}",
            container: AJS.$("#liveActivity"),
            getBuildsUrl: "${getBuildsUrl}",
            getChangesUrl: "${getChangesUrl}",
            queueEmptyText: "${queueEmptyText?js_string}",
            cancellingBuildText: "${cancellingBuildText?js_string}",
            noAdditionalInfoText: "${noAdditionalInfoText?js_string}",
            defaultIssueIconUrl: "${unknownJiraType?js_string}",
            defaultIssueType: "Unknown Issue Type",
            templates: {
                buildListItemTemplate: "buildListItem-template",
                buildingOnTemplate: "buildingOn-template",
                buildMessageTemplate: "buildMessage-template",
                jiraIssueTemplate: "jiraIssue-template",
                codeChangeTemplate: "codeChange-template",
                codeChangeChangesetLinkTemplate: "codeChange-changesetLink-template",
                codeChangeChangesetDisplayTemplate: "codeChange-changesetDisplay-template"
            }
        });
    });
</script>
[/#macro]

[#-- ======================================================================================== @build.message --]

[#macro message type="informative"]
    <div class="message ${type}">[#nested]</div>
[/#macro]

[#-- ======================================================================================== @build.buildListItem --]

[#macro buildListItem buildResultKey planKey cssClass triggerReason buildingOn="" buildMessage=""][#rt]
<li id="b${buildResultKey}" class="${cssClass}">
    <span class="build-description">[#rt]
        <strong><a href="${req.contextPath}/browse/${buildResultKey}">${buildResultKey}</a></strong> ${triggerReason}${buildingOn}[#t]
    </span>[#lt]
    <a id="stopBuild_${buildResultKey}" href="[@ww.url namespace='/build/admin/ajax' action='stopPlan' /]?planResultKey=${buildResultKey}" class="build-stop" title="${cancelBuildText}">${cancelBuildText}</a>
    ${buildMessage}
    <div class="additional-information">
        <div class="issueSummary"><h2 class="jiraIssuesHeader">JIRA Issues</h2></div>
        <div class="changesSummary"><h2 class="codeChangesHeader">[@ww.text name='buildResult.changes.title' /]</h2></div>
    </div>
</li>
[/#macro][#lt]

[#-- ======================================================================================== @build.buildingOn --]

[#macro buildingOn agentId agentType agentName][#rt]
    <span class="agent-info"> - building on <strong><a href="[@ww.url namespace='/agent' action='viewAgent' /]?agentId=${agentId}" class="${agentType}">${agentName}</a></strong></span>
[/#macro][#lt]
