
import jenkins.model.*

a = Jenkins.instance.getExtensionList(
  hudson.tasks.Maven.DescriptorImpl.class
)[0];

b = (a.installations as List);

b.add(
  new hudson.tasks.Maven.MavenInstallation("maven3", "/opt/apache-maven-3.3.9", [])
);

a.installations = b

a.save()
