</form>
<#--
   There used to be useful stuff here for custom on submits (for funny elements we don't use) removed 27/02/2007
-->

<#-- 
 Code that will add javascript needed for tooltips
--><#t/>
<#if parameters.hasTooltip?default(false)><#t/>
	<#lt/><!-- javascript that is needed for tooltips -->
	<#lt/><script language="JavaScript" type="text/javascript" src="<@ww.url value='/webwork/tooltip/wz_tooltip.js' encode='false' />"></script>
</#if><#t/>
<#if parameters.selectFirstFieldOfForm!false><#t/>
    <script type="text/javascript">
        jQuery(function(){
            selectFirstFieldOfForm('${parameters.id?html}');
        });
    </script>
</#if><#t/>

<#-- Clears the current form context -->
${action.setCurrentFormTheme(null)}

