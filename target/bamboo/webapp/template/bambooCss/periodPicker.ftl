[#assign cssClass = 'periodPicker' /]
[#include "/${parameters.templateDir}/${parameters.theme}/controlheader.ftl" /]
[#include "/${parameters.templateDir}/simple/text.ftl" /]
[@ww.select name='${parameters.periodField}'
            list=['days', 'weeks', 'months'] theme='simple'
             /]
[#include "/${parameters.templateDir}/${parameters.theme}/controlfooter.ftl" /]
