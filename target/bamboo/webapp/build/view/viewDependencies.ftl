[#-- @ftlvariable name="parentPlanDependencies" type="java.util.Set<com.atlassian.bamboo.build.PlanDependency>" --]
[#-- @ftlvariable name="childPlanDependencies" type="java.util.Set<com.atlassian.bamboo.build.PlanDependency>" --]
[#-- @ftlvariable name="dependencyBlockingStrategy" type="com.atlassian.bamboo.v2.build.trigger.DependencyBlockingStrategy" --]

[#macro showDependencies parentPlanDependencies childPlanDependencies dependencyBlockingStrategy]

    [#if dependencyBlockingStrategy?has_content]
        [@ui.displayText]
            [@ww.text name='build.dependency.long.description']
                [@ww.param][@help.url pageKey="dependency.blocking"][@ww.text name="build.dependency.strategy"/][/@help.url][/@ww.param]
            [/@ww.text]
        [/@ui.displayText]
        [@ww.label labelKey='build.dependency.strategy' value='${action.getText(dependencyBlockingStrategy.descriptionI18nKey)}' /]
    [/#if]

    [#if !(parentPlanDependencies?has_content || childPlanDependencies?has_content) ]
        <p>[@ww.text name='build.dependency.none' /]</p>
    [#else]
        [#if childPlanDependencies?has_content]
            <p>[@ww.text name='build.dependency.child.description'/]</p>
            <ul>
                [#list childPlanDependencies as dependency]
                    [#if dependency?? && dependency.childPlan??]
                        <li><a href="[@ww.url value='/browse/${dependency.childPlan.key}' /]">${dependency.childPlan.name}</a>
                            [#if !dependency.editable]<span class="disabled">[@ww.text name="build.dependency.generated"/]</span>[/#if]</li>
                    [/#if]
                [/#list]
            </ul>
        [/#if]

        [#if parentPlanDependencies?has_content]
            <p>[@ww.text name='build.dependency.parent.description'][/@ww.text]</p>
            <ul>
                [#list parentPlanDependencies as dependency]
                    [#if dependency?? && dependency.parentPlan??]
                        <li><a href="[@ww.url value='/browse/${dependency.parentPlan.key}' /]">${dependency.parentPlan.name}</a>
                            [#if !dependency.editable]<span class="disabled">[@ww.text name="build.dependency.generated"/]</span>[/#if]</li>
                    [/#if]
                [/#list]
            </ul>
        [/#if]
    [/#if]
[/#macro]
