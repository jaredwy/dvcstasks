[@ui.bambooSection titleKey='buildExpiry.heading' descriptionKey='buildExpiry.plan.description' ]
[@ww.checkbox labelKey='buildExpiry.config.plan.enable' name='custom.buildExpiryConfig.enabled' toggle='true'/]

    [@ui.bambooSection dependsOn='custom.buildExpiryConfig.enabled' showOn='true']
        [#include "/admin/build/editBuildExpiryForm.ftl" /]
    [/@ui.bambooSection]
[/@ui.bambooSection]