[#import "editChainConfigurationCommon.ftl" as eccc/]

[@eccc.editChainConfigurationPage plan=plan  selectedTab='repository']
        [@ww.form titleKey='repository.title' action="updateChainRepository"
                  method="post" enctype="multipart/form-data"
                  cancelUri='/browse/${plan.key}/config'
                  submitLabelKey='global.buttons.update']
        [@ww.hidden name="buildKey" /]    
        
        [#include "/build/common/configureChangeDetectionRepository.ftl"]
        
        [/@ww.form]
[/@eccc.editChainConfigurationPage]
