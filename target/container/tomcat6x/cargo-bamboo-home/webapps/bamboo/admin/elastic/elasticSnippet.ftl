[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ManageElasticInstancesAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.elastic.ManageElasticInstancesAction" --]
[#import "/agent/commonAgentFunctions.ftl" as agt]
[#import "/admin/elastic/commonElasticFunctions.ftl" as ela]

[@ww.text name='elastic.manage.running.description']
    [@ww.param value='${runningElasticInstances.size()}' /]
    [@ww.param value='${requestedElasticInstances.size()}' /]
[/@ww.text]
[@ui.clear/]

<div class="buttons">
    <a href="[@ww.url action='prepareElasticInstances' namespace='/admin/elastic' /]">[@ww.text name='elastic.manage.createAgents' /]</a>
    [#if anyRunningElasticInstancesShutdownable]
        | <a id="shutdownAllElasticInstances" href="[@ww.url action='shutdownAllElasticInstances' namespace='/admin/elastic' /]">[@ww.text name='elastic.manage.shutdown.all' /]</a>
    [/#if]
</div>
[@ui.clear/]

[#if requestedElasticInstances?has_content]
    [@ui.messageBox type="info"]
        [@ww.text name='elastic.manage.instances.pending']
            [@ww.param value='${requestedElasticInstances.size()}' /]
        [/@ww.text]
    [/@ui.messageBox]
    [@ui.clear/]
[/#if]

[#if elasticErrors?has_content]
    <ol class="noBullet">
        [#list elasticErrors as error]
            [@cp.showSystemError error=error returnUrl="/admin/elastic/manageElasticInstances.action"/]
        [/#list]
    </ol>
    [@ui.clear/]
[/#if]

[#if runningElasticInstances?has_content]
    [@ela.listElasticInstances runningElasticInstances /]   
    [@ui.clear/]
[/#if]

[#if elasticAgentLogs?has_content]
   <table id="remoteAgentLog">
       [#list elasticAgentLogs as line]
       <tr>
           <td>
               ${line?html}
           </td>
       </tr>
       [/#list]
   </table>
    [@ui.clear/]
[/#if]
 <div class="subGrey" >
   [@ww.text name='elastic.manage.refresh'/]
 </div>
