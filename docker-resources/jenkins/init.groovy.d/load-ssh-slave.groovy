import jenkins.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import hudson.model.*
import hudson.slaves.*
import hudson.plugins.sshslaves.*
import java.util.ArrayList;
import hudson.slaves.EnvironmentVariablesNodeProperty.Entry;

// Script from JMMeessen - https://github.com/jmMeessen/the-captains-shack

global_domain = Domain.global()
credentials_store =
        Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

credentials = new BasicSSHUserPrivateKey(
        CredentialsScope.GLOBAL,
        "ssh-agent-jenkins",
        "jenkins",
        new BasicSSHUserPrivateKey.FileOnMasterPrivateKeySource("/ssh-keys/id_rsa"),
        "",
        "RSA private Keys for SSH slaves"
)

// Check if the key has already been loaded
def creds = com.cloudbees.plugins.credentials.CredentialsProvider.lookupCredentials(
        com.cloudbees.plugins.credentials.common.StandardUsernameCredentials.class,
        Jenkins.instance,
        null,
        null
);

boolean found = false
for (c in creds) {
    println(c.id + ": " + c.description)
    if(c.description.equals("Key to manage the slaves")) {
        found = true
        println("Key already loaded, skipping.")
    }
}

if(!found) {
    println("Loading SSH key")
    credentials_store.addCredentials(global_domain, credentials)
}


List<Entry> env = new ArrayList<Entry>();
env.add(new Entry("DOCKER_HOST","tcp://docker-service:2375"))
env.add(new Entry("PUBLIC_IP",System.getenv("PUBLIC_IP")))
EnvironmentVariablesNodeProperty envPro = new EnvironmentVariablesNodeProperty(env);
Slave slave = new DumbSlave(
        "ssh-agent","SSH Agent",
        "/tmp/jenkins",
        "6",
        Node.Mode.NORMAL,
        "docker-cloud jdk8 docker",
        new SSHLauncher("ssh-agent", 22, "ssh-agent-jenkins",
             "", "", "", "",
             0, 3, 10),
        new RetentionStrategy.Always(),
        new LinkedList())
slave.getNodeProperties().add(envPro)
Jenkins.instance.addNode(slave)
