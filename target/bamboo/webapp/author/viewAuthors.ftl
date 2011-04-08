[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.author.ViewAuthors" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.author.ViewAuthors" --]

<html>
<head>
    [@ui.header pageKey='Authors' object='' title=true /]
</head>

<body>
<h1>User and Author Statistics</h1>

[@cp.authorSubMenu selectedTab='list' ]

    [@ui.header pageKey='Authors' /]
    [#if authors?has_content && authors.size() gt 0]
        <p>A listing of all authors who commit to projects in Bamboo.
            <em>Broken</em> means the build has failed but the previous build was successful.
            <em>Fixed</em> means that the build was successful but the previous build has failed.
            The <em>Score</em> is a difference of fixed and broken builds.</p>
    [/#if]


    [#if authors?has_content]

    <table id="authorTable" class="aui tablesorter">
        <thead>
            <tr>
                <th>Name</th>
                <th>Triggered</th>
                <th>Failed</th>
                <th>% Failed</th>
                <th title="Broken means the build has failed but the previous build was successful.">Broken</th>
                <th title="Fixed means that the build was successful but the previous build has failed.">Fixed</th>
                <th title="Difference of fixed and broken builds.">Score</th>
            </tr>
        </thead>
        <tbody>
        [#list authors as author]
            [#if author.numberOfTriggeredBuilds gt 0]
                [#assign failedPercent=author.numberOfFailedBuilds/author.numberOfTriggeredBuilds /]
            [#else]
                [#assign failedPercent=0 /]
            [/#if]
            [#assign extendedAuthor=extendedAuthorManager.getAuthorByName(author.name)?if_exists /]
        <tr>
            [#if extendedAuthor?has_content]
                <td><span class="hidden">${extendedAuthor.fullName?lower_case?html}</span><a href="[@cp.displayAuthorOrProfileLink author=extendedAuthor/]">${author.name?html}
                    [#if extendedAuthor.linkedUserName?has_content]
                        ([@ui.displayAuthorFullName author=extendedAuthor /])
                    [/#if]</a></td>
            [#else]
                [@ww.url id="authorUrl" action="viewAuthor" namespace="/authors" authorName="${author.getNameForUrl()}" /]
                <td><span class="hidden">${author.name?lower_case?html}</span><a href="${authorUrl}">${author.name?html}</a></td>
            [/#if]
            <td>${author.numberOfTriggeredBuilds}</td>
            <td>${author.numberOfFailedBuilds}</td>
            <td>${failedPercent?string.percent}</td>
            <td>${author.numberOfBreakages}</td>
            <td>${author.numberOfFixes}</td>
            <td>${author.numberOfFixes - author.numberOfBreakages}</td>
        </tr>
        [/#list]
        </tbody>
    </table>

    <script type="text/javascript">
        AJS.$(function() {
            AJS.$("#authorTable").tablesorter({ sortList: [[0,0]] });
        });
    </script>
    [#else]
        [@ui.messageBox type="info" title="Bamboo has not found any authors who have committed to builds." /]
    [/#if]

[/@cp.authorSubMenu]
</body>
</html>