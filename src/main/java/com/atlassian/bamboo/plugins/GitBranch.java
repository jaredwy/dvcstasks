/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.atlassian.bamboo.plugins;

import com.atlassian.bamboo.build.test.TestCollationService;
import com.atlassian.bamboo.process.ProcessService;
import com.atlassian.bamboo.task.TaskContext;
import com.atlassian.bamboo.task.TaskDefinition;
import com.atlassian.bamboo.task.TaskException;
import com.atlassian.bamboo.task.TaskExecutionEvaluator;
import com.atlassian.bamboo.task.TaskResult;
import com.atlassian.bamboo.task.TaskType;
import com.atlassian.bamboo.v2.build.CurrentBuildResult;
import com.atlassian.bamboo.v2.build.agent.capability.CapabilityContext;
import org.apache.commons.configuration.HierarchicalConfiguration;
import com.atlassian.bamboo.security.StringEncrypter;

import org.jetbrains.annotations.NotNull;

/**
 *
 * @author jwyles
 */
public class GitBranch  implements TaskType {
    
     private final CapabilityContext capabilityContext;
     private final ProcessService processService; 
     private final TestCollationService testCollationService;
    
     
     
     
     public GitBranch(CapabilityContext capabilityContext, ProcessService processService, TestCollationService testCollationService) {
        this.capabilityContext = capabilityContext;
        this.processService = processService;
        this.testCollationService = testCollationService;
    }

     @NotNull
      public TaskResult execute(@NotNull TaskDefinition taskDefinition, @NotNull TaskContext taskContext) throws TaskException {
           final CurrentBuildResult currentBuildResult = taskContext.getBuildContext().getBuildResult();
         
           //todo get access to a text provider some how and use that to check.
           //better yet extend repository to check if it is a dvcs. 
           if( taskContext.getBuildContext().getBuildDefinition().getRepository().getName().equals("Git")) {
                    final HierarchicalConfiguration config =  taskContext.getBuildContext().getBuildDefinition().getRepository().toConfiguration();
                    
                    
                    
                    config.containsKey("test");
                    
                    
           }
           TaskExecutionEvaluator taskExecutionEvaluator = TaskExecutionEvaluator.create(taskDefinition, taskContext);
           return taskExecutionEvaluator.evaluate();
            
       }
     
     
    public synchronized void setTextProvider(TextProvider textProvider) {
        super.setTextProvider(textProvider);
        if (textProvider.getText(REPOSITORY_GIT_NAME) == null)
        {
            LocalizedTextUtil.addDefaultResourceBundle("com.atlassian.bamboo.plugins.git.i18n");
        }
    }

     
     

}
