[#-- @ftlvariable name="action" type="com.atlassian.bamboo.webwork.StarterAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.webwork.StarterAction" --]

<div class="my-bamboo">
    [@ui.bambooPanel titleKey='dashboard.wallboard.favourite' ]
        [@ww.url id='myFavouritesUrl' namespace='/ajax' action='myFavourites' /]
        [@dj.reloadPortlet url='${myFavouritesUrl}' id='myFavourites' reloadEvery=30]
            [@ww.action name='myFavourites' namespace='/ajax' executeResult='true' /]
        [/@dj.reloadPortlet]
    [/@ui.bambooPanel]

    [#if responsibleForBuilds?has_content]
        [@ui.bambooPanel title='Broken Plans' ]
            [@ww.url id='myResponsibilitiesUrl' namespace='ajax' action='myResponsibilities' /]
            [@dj.reloadPortlet url='${myResponsibilitiesUrl}' id='myResponsibilities' reloadEvery=30]
                [@ww.action name='myResponsibilities' namespace='/ajax' executeResult='true' /]
            [/@dj.reloadPortlet]
        [/@ui.bambooPanel]
    [/#if]

    [#if author??]
        [@ui.bambooPanel title='Build Statistics' ]
            [@cp.displayAuthorSummary author=author /]
        [/@ui.bambooPanel]
    [/#if]
</div>

<div class="my-bamboo">
    [@ui.bambooPanel title='Latest Changes' ]
        [#if author??]
                [@ww.url id='myChangesUrl' namespace='/ajax' action='myChanges' /]
                [@dj.reloadPortlet url='${myChangesUrl}' id='latestChanges' reloadEvery=30 callback="AJS.tables.rowStriping"]
                    [@ww.action name='myChanges' namespace='/ajax' executeResult='true' /]
                [/@dj.reloadPortlet]
        [#else]
                [@ui.messageBox]
                No changes found. You may need to <a href="${req.contextPath}/profile/editProfile.action" title="Edit your profile">associate yourself</a> with a source repository alias.
                [/@ui.messageBox]
        [/#if]
    [/@ui.bambooPanel ]
</div>
[#-- Hack for Safari --]
[@dj.tooltip target='hackforsafari' text='hackforsafari' /]
