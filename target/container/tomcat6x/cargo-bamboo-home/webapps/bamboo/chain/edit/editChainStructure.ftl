[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.chains.StageAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.chains.StageAction" --]
[#import "/lib/chains.ftl" as chains]
[#import "editChainConfigurationCommon.ftl" as eccc/]

[@eccc.editChainConfigurationPage plan=plan selectedTab='chain.structure' ]
            <div class="addStage">
                [#if fn.hasPlanPermission("ADMINISTRATION", chain)]
                    [@ww.url id='addStageUrl' value='/chain/admin/ajax/addStage.action' buildKey=buildKey returnUrl=currentUrl /]
                    [@cp.displayLinkButton buttonId='addStage' buttonKey='chain.config.stages.add' buttonUrl=addStageUrl /]

                    <script type="text/javascript">
                        var addStage = function (data) {
                            window.location.reload(true);
                        };
                    </script>
                    [@dj.simpleDialogForm triggerSelector="#addStage" width=540 height=250 headerKey="stage.create" submitCallback="addStage"][/@dj.simpleDialogForm]
                [/#if]
                [@ww.text name="chain.config.stages.description" /]
            </div>

        [#if fn.hasPlanPermission("ADMINISTRATION", chain)]
            <a class="assistive" id="createJob" href="[@ww.url action='addJob' namespace='/chain/admin' buildKey=chain.key /]" title="Create a new Job">Create Job</a>
        [/#if]

        [@chains.stageConfiguration id="editstages" chain=chain /]

[/@eccc.editChainConfigurationPage]
