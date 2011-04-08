[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.plans.admin.ConfigurePlanDependencies" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.plans.admin.ConfigurePlanDependencies" --]
[#import "editChainConfigurationCommon.ftl" as eccc/]

[@eccc.editChainConfigurationPage plan=plan  selectedTab='dependencies']
        [#assign pluginInjectedConfiguration = dependenciesBuildConfigurationEditHtml /]

        [#if possiblePlanDependencies?has_content || pluginInjectedConfiguration?has_content]
            [@ww.form id='buildDependenciesForm' action='updateChainDependencies'
                  cancelUri='/browse/${plan.key}/config'
                  submitLabelKey='global.buttons.update' titleKey='chain.dependency.title' descriptionKey='chain.dependency.description']

                [@ww.hidden name="buildKey" /]

                ${pluginInjectedConfiguration}

                [#if possiblePlanDependencies?has_content]
                    [@ui.bambooSection titleKey='chain.dependency.manualManagement.title']
                        [@ww.checkboxlist  name='childPlanKeys' labelKey='build.dependency.child'
                                           list=possiblePlanDependencies listKey='key' listValue='name' disabledList="disabledChildKeys"/]

                        [@ww.checkboxlist  name='parentPlanKeys' labelKey='build.dependency.parent'
                                           list=possiblePlanDependencies listKey='key' listValue='name' disabledList="disabledParentKeys"/]
                    [/@ui.bambooSection]

                    [@ui.bambooSection titleKey="build.dependency.strategy"]
                        [@ui.displayText]
                            [@ww.text name='build.dependency.long.description']
                                [@ww.param][@help.url pageKey="dependency.blocking"][@ww.text name="build.dependency.strategy"/][/@help.url][/@ww.param]
                            [/@ww.text]
                        [/@ui.displayText]
                        [@ww.radio name="custom.dependencies.trigger.remote.strategy" listKey="value" listValue="value" i18nPrefixForValue="build.dependency.strategy" showDescription=true list=dependencyBlockingStrategies /]
                    [/@ui.bambooSection]
                [/#if]
            [/@ww.form]
        [#else]
            <p>
                [@ww.text name='chain.dependency.possible.none' /]
            </p>
        [/#if]
[/@eccc.editChainConfigurationPage]