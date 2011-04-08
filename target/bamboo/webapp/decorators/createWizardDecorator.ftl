[#include "/fragments/decorator/htmlHeader.ftl"]
[#include "/fragments/decorator/header.ftl"]
<div id="content">
[#assign step = page.properties["meta.tab"]!/]
[#assign prefix = page.properties["meta.prefix"]!"plan"/]
<div class="wizardStatus">
    <div [#if step == "1"]class="selected"[/#if]><span class="number">[@ww.text name="${prefix}.create.step.one"/]</span> <span>[@ww.text name="${prefix}.create.step.one.description"/]</span></div>[#t]
    [@ui.icon type="wizard-arrow" /][#t]
    <div [#if step == "2"]class="selected"[/#if]><span class="number">[@ww.text name="${prefix}.create.step.two"/]</span> <span>[@ww.text name="${prefix}.create.step.two.description"/]</span></div>[#t]
</div>
<div id="create-content">
${body}
</div>
</div>
[#include "/fragments/decorator/footer.ftl"]