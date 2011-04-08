[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.setup.SetupDatabaseAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.setup.SetupDatabaseAction" --]
<html>
<head>
    <title>[@ww.text name='setup.install.database' /]</title>
</head>

<body>

<h1>[@ww.text name='setup.install.database' /]</h1>

<p>[@ww.text name='setup.install.database.description' /]</p>


[@ww.form action="chooseDatabaseType"
            submitLabelKey='global.buttons.continue'
            titleKey='setup.install.database.form.title']

<fieldset id='fieldArea_chooseDatabaseType' class='group'>
    <div class="radio">
        <input type="radio" name="dbChoice" id="chooseDatabaseType_dbChoiceembeddedDb" checked="checked" value="embeddedDb"/>
        <label for="chooseDatabaseType_dbChoiceembeddedDb"><strong>[@ww.text name='setup.install.database.embedded' /]</strong></label>
    </div>
    <div class="databaseDescriptions">
        [@ww.text name='setup.install.database.embedded.description' /]
    </div>
    <div class="radio">
        <input type="radio" name="dbChoice" id="chooseDatabaseType_dbChoicestandardDb" value="standardDb"/>
        <label for="chooseDatabaseType_dbChoicestandardDb"><strong>[@ww.text name='setup.install.database.external' /]</strong></label>
    </div>
    <div class="databaseDescriptions">
        [@ww.text name='setup.install.database.external.description' /]
        [@ww.select id="dbselect" name='selectedDatabase' list=databases listKey='key' listValue='value' toggle="true" /]
    </div>
    [@ui.bambooSection dependsOn='selectedDatabase' showOn="mysql"]
        [@ui.messageBox type="info" titleKey="setup.install.database.external.mysqlnotice" /]
    [/@ui.bambooSection ]
</fieldset>
[/@ww.form]

<script type="text/javascript">
   jQuery('#dbselect').change(function() {
      jQuery('#chooseDatabaseType_dbChoicestandardDb').attr("checked", "checked");
  });
</script>

</body>
</html>
