[#assign ver = webwork.bean("com.atlassian.bamboo.util.BuildUtils")]
	</div> <!-- END #nonFooter -->
    <div id="ft">
        <div id="footer">
            <p>
                <a href="http://www.atlassian.com/software/bamboo/">Continuous integration</a> powered by <a href="http://www.atlassian.com/software/bamboo/">Atlassian Bamboo</a> version ${ver.getCurrentVersion()} build ${ver.getCurrentBuildNumber()} -
                [@ui.time datetime=ver.getCurrentBuildDate()]${ver.getCurrentBuildDate()?date?string("dd MMM yy")}[/@ui.time]
            </p>
        </div> <!-- END #footer -->
    </div> <!-- END #ft -->
</div> <!-- END #doc -->
</body>
</html>