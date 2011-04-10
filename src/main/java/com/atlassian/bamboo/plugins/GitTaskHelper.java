package com.atlassian.bamboo.plugins;

import org.apache.commons.configuration.HierarchicalConfiguration;

/**
 * Date: 10/04/11
 */
public class GitTaskHelper {
    private static final String REPOSITORY_GIT_NAME = "repository.git.name";
    private static final String REPOSITORY_GIT_REPOSITORY_URL = "repository.git.repositoryUrl";
    private static final String REPOSITORY_GIT_AUTHENTICATION_TYPE = "repository.git.authenticationType";
    private static final String REPOSITORY_GIT_USERNAME = "repository.git.username";
    private static final String REPOSITORY_GIT_PASSWORD = "repository.git.password";
    private static final String REPOSITORY_GIT_BRANCH = "repository.git.branch";
    private static final String REPOSITORY_GIT_SSH_KEY = "repository.git.ssh.key";
    private static final String REPOSITORY_GIT_SSH_PASSPHRASE = "repository.git.ssh.passphrase";
    private static final String REPOSITORY_GIT_USE_SHALLOW_CLONES = "repository.git.useShallowClones";
    private static final String REPOSITORY_GIT_MAVEN_PATH = "repository.git.maven.path";
    private static final String TEMPORARY_GIT_PASSWORD = "temporary.git.password";
    private static final String TEMPORARY_GIT_PASSWORD_CHANGE = "temporary.git.password.change";
    private static final String TEMPORARY_GIT_SSH_PASSPHRASE = "temporary.git.ssh.passphrase";
    private static final String TEMPORARY_GIT_SSH_PASSPHRASE_CHANGE = "temporary.git.ssh.passphrase.change";
    private static final String TEMPORARY_GIT_SSH_KEY_FROM_FILE = "temporary.git.ssh.keyfile";
    private static final String TEMPORARY_GIT_SSH_KEY_CHANGE = "temporary.git.ssh.key.change";
    


enum GitAuthenticationType
{
    NONE,
    PASSWORD,
    SSH_KEYPAIR;
}

    static class GitRepositoryAccessData implements Serializable
    {
        String repositoryUrl;
        String branch;
        String username;
        String password;
        String sshKey;
        String sshPassphrase;
        GitAuthenticationType authenticationType;
        boolean useShallowClones;
    }

    
    
    
    
    
    
    
    
    //probably need some sort of repository config, some sort of standard for this so i can create a dvcstaskhelper
    //to handle all the authentication grabbing.
    public GitTaskHelper(HierarchicalConfiguration config) {
        config.getString(REPOSITORY_GIT_NAME)
        
    }
    
    
    

}
