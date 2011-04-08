[#-- @ftlvariable name="action" type="com.atlassian.bamboo.build.ViewBuildFiles" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.build.ViewBuildFiles" --]
<html>
<head>
	<title>${build.getName()}: [@ww.text name='buildFiles.title' /]</title>
     <meta name="tab" content="files"/>
</head>
<body>

    [@ui.header pageKey='buildFiles.title' /]
    [#if lastBuildLocal]
        [#if !files??]
            [@ww.text name='buildFiles.none' /]
        [#else]
            <p>
            [#if directory??]
                <a href="${req.contextPath}/build/viewBuildFiles.action?buildKey=${build.key}">${build.name}</a>
            [#else]
                ${build.name}
            [/#if]
            [#assign breadcrumbs = sourceCodeBreadcrumb]
                [#list breadcrumbs as pathEl]
                    /
                    [#if pathEl_has_next]
                        <a href="${req.contextPath}/build/viewBuildFiles.action?buildKey=${build.key}&directory=${pathEl.file.path?html}">${pathEl.file.name?html}</a>
                    [#else]
                        ${pathEl.file.name?html}
                    [/#if]
                [/#list]
            </p>

            <table id="filelisting" class="aui">
                <thead>
                    <tr>
                        <th></th>
                        <th>[@ww.text name='buildFiles.file' /]</th>
                        <th>[@ww.text name='buildFiles.size' /]</th>
                        <th>[@ww.text name='buildFiles.date' /]</th>
                    </tr>
                </thead>
                [#if files??]
                [#list files as file]
                    <tr>
                        <td width="15">
                            [#if file.isDirectory()]
                                <img src="${req.contextPath}/images/folder.gif" alt="directory" width="16" height="16" border="0">
                            [/#if]
                        </td>
                        <td>
                            [#if file.isDirectory()]
                            <a href="${req.contextPath}/build/viewBuildFiles.action?buildKey=${build.key}&directory=${file.path?html}">${file.name?html}</a>
                            [#else]
                            ${file.name?html}
                            [/#if]
                        </td>
                        <td>
                            [#if !file.isDirectory()]
                                ${action.formatFileSize(file.length())}
                            [/#if]
                        </td>
                        <td>
                            ${action.formatAsDate(file.lastModified())!?datetime}
                        </td>
                    </tr>
                [/#list]
                [/#if]
            </table>
            [#if fn.hasPlanPermission('WRITE', build)]
                <p>
                    <a id="purgeBuildFilesImage" href="${req.contextPath}/build/admin/purgeBuildFiles.action?projecKey=${build.key}" title="Delete the build files"><img src="${req.contextPath}/images/delete_files.gif" border="0" alt="[@ww.text name='queue.delete.from' /]" width="16" height="16" align="absmiddle"></a>
                    <a id="purgeBuildFiles" href="${req.contextPath}/build/admin/purgeBuildFiles.action?buildKey=${build.key}" title="Delete the build files">[@ww.text name='buildFiles.delete' /]</a>
                    [#if (build.buildDefinition.repository)??]
                        from ${sourceDirectory!}
                    [/#if]
                </p>
            [/#if]
        [/#if]
        [#if errorMessages.size() gt 0]
        <p>
            <div id="applicationError">
                <ul>
                [#list formattedErrorMessages as error]
                    <li>${error}</li>
                [/#list]
                </ul>
            </div>
        </p>
        [/#if]
    [#else]
        [@ww.text name="buildFiles.notLocal" /]
    [/#if]
</body>
</html>