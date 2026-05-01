FROM jenkins/jenkins:lts

USER root

# Install docker CLI
RUN apt-get update && apt-get install -y docker.io && \
    apt-get clean

USER jenkins

# Skip initial setup wizard
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Install plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

# Copy init scripts
COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/init.groovy
COPY init.groovy.d/*.groovy /usr/share/jenkins/ref/init.groovy.d/