[@ww.label labelKey='repository.svn.repository' value='${plan.buildDefinition.repository.repositoryUrl}' /]
[#if plan.buildDefinition.repository.username?has_content]
    [@ww.label labelKey='repository.svn.username' value='${plan.buildDefinition.repository.username}' /]
[#else]
    [@ww.label labelKey='repository.svn.username' value="<i>[none specified]</i>" escape='false' /]
[/#if]
[@ww.label labelKey='repository.svn.authentication' value='${plan.buildDefinition.repository.authType}' /]
[@ww.label labelKey='repository.svn.keyFile' value='${plan.buildDefinition.repository.keyFile!}' hideOnNull='true' /]

[@ww.label labelKey='repository.svn.useExternals' value='${plan.buildDefinition.repository.useExternals?string}' hideOnNull='true' /]
[#if repository.useExternals && repository.externalPathRevisionMappings?has_content]
    <table class="aui">
            <thead>
            <tr>
                <th>
                    Externals Path
                </th>
                <th>
                    Revision
                </th>
            </tr>
        </thead>
        <tbody>
        [#list repository.externalPathRevisionMappingsSorted.entrySet() as entry]
            <tr>
                <td>
                    ${entry.key}
                </td>
                <td>
                    ${entry.value}                    
                </td>
            </tr>
        [/#list]
        </tbody>
    </table>
[/#if]
