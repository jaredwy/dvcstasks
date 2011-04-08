[#-- @ftlvariable name="build" type="com.atlassian.bamboo.build.Build" --]
[#-- @ftlvariable name="buildResultsSummary" type="com.atlassian.bamboo.resultsummary.BuildResultsSummary" --]

<script type="text/javascript">
    var LabelAjaxObject = {
        deleteLabel: function (labelName) {
            AJS.$.post("${req.contextPath}/build/label/ajax/deleteLabel.action?buildNumber=${resultsSummary.buildNumber}&buildKey=${plan.key}&selectedLabel=" + labelName, function (data) {
                AJS.$("#labelArea").html(data);
            });
            return false;
        },
        addLabels: function () {
            AJS.$.post('${req.contextPath}/build/label/ajax/addLabels.action', AJS.$("#labelForm").serialize(), function (data) {
                AJS.$("#labelArea").html(data);
            });
            return false;
        },
        viewLabels: function () {
            AJS.$.post("${req.contextPath}/build/label/ajax/viewLabels.action?buildNumber=${resultsSummary.buildNumber}&buildKey=${plan.key}", function (data) {
                AJS.$("#labelArea").html(data);
            });
            return false;
        },
        editLabels: function () {
            AJS.$.post("${req.contextPath}/build/label/ajax/editLabels.action?buildNumber=${resultsSummary.buildNumber}&buildKey=${plan.key}", function (data) {
                AJS.$("#labelArea").html(data);
                AJS.$("#labelArea .textField").focus();
            });
            return false;
        }
    };
</script>
<div id="labelArea">
    [@ww.action name='viewLabels' namespace='/build/label/ajax' executeResult='true'/]
</div>