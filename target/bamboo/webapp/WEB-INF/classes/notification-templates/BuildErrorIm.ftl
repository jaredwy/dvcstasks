Error detected for ${error.buildName}[#if error.buildNumber?has_content && error.buildExists] > ${error.buildResultKey}[/#if].
---------------------------------
[#if error.context?has_content]
${error.context}
[/#if]
[#if error.throwableDetails?has_content]
   [#if error.throwableDetails.name?has_content]
${error.throwableDetails.name?html}[#if error.throwableDetails.message?has_content]: [/#if][#rt]
   [/#if]
   [#if error.throwableDetails.message?has_content]
${error.throwableDetails.message?html}[#lt]
   [/#if]
[/#if]

${baseUrl}/browse/${error.buildKey}#buildPlanSummaryErrorLog