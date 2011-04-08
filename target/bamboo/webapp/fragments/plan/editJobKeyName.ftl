[#--
    Requirements:

    buildName  scalar which will hold plan key
    subBuildKey   scalar which will hold plan name
--]

[@ww.textfield labelKey='job.name' name='buildName' required='true' /]
[@ww.textfield labelKey='job.key' name='subBuildKey' required='true' /]
[@ww.textfield labelKey='job.description' name='buildDescription' required='false'/]  