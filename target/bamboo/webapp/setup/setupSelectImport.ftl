[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.setup.SetupImportDataAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.setup.SetupImportDataAction" --]
<html>
	<head>
		<title>[@ww.text name='setup.data.title' /]</title>
	</head>

	<body>
        <h1>[@ww.text name='setup.data.title' /]</h1>

        [@ww.form action="performImportData" submitLabelKey='global.buttons.continue' titleKey='setup.data.form.title']
           [@ww.radio labelKey='setup.data.options' name='dataOption'
                   listKey='key' listValue='value' toggle='true'
                   list=importOptions ]
            [/@ww.radio]
            [@ui.bambooSection dependsOn='dataOption' showOn='import']
                    [@ww.textfield labelKey='setup.data.import.path' name='importPath' required='true' cssClass="long-field" /]
            [/@ui.bambooSection]
        [/@ww.form ]

    </body>
</html>