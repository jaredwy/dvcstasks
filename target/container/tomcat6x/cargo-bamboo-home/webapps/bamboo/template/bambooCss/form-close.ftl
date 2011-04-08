[#if parameters.submitLabelKey?has_content || parameters.cancelUri?has_content || parameters.buttons?has_content || parameters.backLabelKey?has_content]

    [#if parameters.cancelUri??]
        [#assign sanitizedCancelUri=fn.sanitizeUri(parameters.cancelUri)]
    [/#if]
    [#if action.returnUrl??]
        [#assign sanitizedReturnUrl=fn.sanitizeUri(action.returnUrl)]
    [/#if]

        <div class="formFooter [#if parameters.wizard?exists]wizardFooter[/#if]">
            <div class="buttons">
            [@compress single_line=true]
            [#-- This is needed so that the Next button is the default button --]
            [#if parameters.submitLabelKey?has_content]
                [@ww.submit value="${action.getText(parameters.submitLabelKey)}" theme='simple' name='save' id="${parameters.id}_defaultSave" cssClass='assistive' hideAccessKey='true' tabindex="-1" /]
            [/#if]
            [#if parameters.backLabelKey?has_content]
                [@ww.submit id="backButton" name="backButton"
                            customAccessKey="${action.getText('global.key.back')}"
                            title="${action.getText(parameters.backLabelKey)}"
                            value="${action.getText(parameters.backLabelKey)}"
                            theme='simple'/]
            [#elseif parameters.wizard?exists]
               <input id="backButton" type="submit" disabled="disabled"
                       title="[@ww.text name='global.buttons.back' /]"
                       value="[@ww.text name='global.buttons.back' /]"
                    />
            [/#if]

            [#if parameters.submitLabelKey?has_content]
                [@ww.submit value="${action.getText(parameters.submitLabelKey)}" theme='simple' name='save'/]
            [/#if]

            ${parameters.buttons?if_exists}

            [#if sanitizedCancelUri?has_content]
                [#if sanitizedReturnUrl?has_content]
                    [@ww.url value='${sanitizedReturnUrl}' id='cancelUri'/]
                [#else]
                    [@ww.url value='${sanitizedCancelUri}' id='cancelUri' /]
                [/#if]

               [#assign cancelText]
                    [#if parameters.cancelSubmitKey?has_content]
                        [@ww.text name='${parameters.cancelSubmitKey}' /]
                    [#else]
                        [@ww.text name='global.buttons.cancel' /]
                    [/#if]
                [/#assign]


                <input id="cancelButton" type="button"
                       accesskey="[@ww.text name='global.key.cancel' /]"
                       title="${cancelText}"
                       value="${cancelText}"
                       onclick="location.href='${cancelUri}'"
                    />
            [/#if]
            [/@compress]
            </div>
        </div>
[/#if]
</div>
[#include "/${parameters.templateDir}/simple/form-close.ftl" /]
[#if !(parameters.formEndClearer?? && parameters.formEndClearer == false)]
    <div class="clearer"></div>
[/#if]
