    </div> <!-- END #nonFooter -->
[#if ctx?? && ctx.pluggableFooter??]
  ${ctx.pluggableFooter.getHtml(req)}
[#else]
[#assign ver = webwork.bean("com.atlassian.bamboo.util.BuildUtils")]
    <div id="ft">
        [#if !bambooLicenseManager?exists]
        [#elseif !bambooLicenseManager.license??]
            <div id="licenseMessage">
                <p>
                    [@ww.text name="license.footer.missing"]
                        [@ww.param]${ver.getCurrentVersion()}[/@ww.param]
                        [@ww.param]${ver.getCurrentBuildNumber()}[/@ww.param]
                        [@ww.param]${ver.getCurrentEdition()}[/@ww.param]
                        [@ww.param]${bootstrapManager.serverID}[/@ww.param]
                    [/@ww.text]
                </p>
            </div>
        [/#if]
        <div id="footer">
            <p>
                <a href="http://www.atlassian.com/software/bamboo/">Continuous integration</a> powered by <a href="http://www.atlassian.com/software/bamboo/">Atlassian Bamboo</a> version ${ver.getCurrentVersion()} build ${ver.getCurrentBuildNumber()} -
                [@ui.time datetime=ver.getCurrentBuildDate()]${ver.getCurrentBuildDate()?date?string("dd MMM yy")}[/@ui.time]
            </p>
            <ul>
                <li>
                    <a href="https://support.atlassian.com/secure/CreateIssue.jspa?pid=10060&amp;issuetype=1">Report a problem</a>
                </li>
                <li>
                    <a href="http://jira.atlassian.com/secure/CreateIssue.jspa?pid=11011&amp;issuetype=4">Request a feature</a>
                </li>
                <li>
                    <a href="http://www.atlassian.com/about/contact.jsp">Contact Atlassian</a>
                </li>
            </ul>
        </div> <!-- END #footer -->
    </div> <!-- END #ft -->
[/#if]
</div> <!-- END #container -->
</body>
</html>