import jenkins.model.*
import hudson.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(true)
hudsonRealm.createAccount("admin","admin")
instance.setSecurityRealm(hudsonRealm)
instance.save()

def strategy = new GlobalMatrixAuthorizationStrategy()

strategy.add(Jenkins.ADMINISTER, "admin")
strategy.add(Jenkins.READ, "authenticated")
strategy.add(Computer.BUILD, "authenticated")
strategy.add(Job.BUILD, "authenticated")
strategy.add(Job.READ, "authenticated")
strategy.add(Job.CANCEL, "authenticated")
strategy.add(Job.CONFIGURE, "authenticated")
strategy.add(Job.CREATE, "authenticated")
strategy.add(Job.DELETE, "authenticated")
strategy.add(Job.DISCOVER, "authenticated")
strategy.add(Job.WORKSPACE, "authenticated")
strategy.add(View.READ, "authenticated")

instance.setAuthorizationStrategy(strategy)
