[#-- @ftlvariable name="action" type="com.atlassian.bamboo.v2.ww2.build.TriggerRemoteBuild" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.v2.ww2.build.TriggerRemoteBuild" --]
<response>
    [#if build?exists]
    <success>A build of ${build.name?if_exists} was triggered by remote http call.</success>
    [/#if]
</response>