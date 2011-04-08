[#if builder?exists]
    [#if (builder.path)?has_content]
        [@ww.label labelKey='builder.type' name='builder.label' description="Runs executable at ${builder.path}"/]
    [#else]
        [@ww.label labelKey='builder.type' name='builder.label' /]
    [/#if]

    ${(builder.getViewHtml(build))?if_exists}

    [#list preBuildQueuedActionPluginHtmlList as pluginHtml]
        ${pluginHtml}
    [/#list]

    [#list preBuildActionPluginHtmlList as pluginHtml]
        ${pluginHtml}
    [/#list]

    [#list buildProcessorPluginHtmlList as pluginHtml]
        ${pluginHtml}
    [/#list]

[#else]
    [@ww.label labelKey='builder.type' value='Builder plugin not found for plan!' /]
[/#if]