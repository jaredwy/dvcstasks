[#-- @ftlvariable name="action" type="com.atlassian.bamboo.rest.GetBambooBuildNumber" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.rest.GetBambooBuildNumber" --]
<response>
    <bambooBuildNumber>${webwork.bean("com.atlassian.bamboo.util.BuildUtils").getCurrentBuildNumber()?if_exists}</bambooBuildNumber>
</response>