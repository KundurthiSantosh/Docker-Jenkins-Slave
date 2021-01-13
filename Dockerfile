FROM ubuntu:18.04

LABEL maintainer="Santosh Kundurthi <santoshsriram2@gmail.com>"

# Make sure the package repository is up to date.
RUN apt-get update && \
    apt-get -qy full-upgrade && \
    apt-get install -qy git && \
# Install a basic SSH server
    apt-get install -qy openssh-server && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
# Install JDK 8 
    apt-get install -qy openjdk-8-jdk && \
# Install maven
    apt-get install -qy maven && \
# Cleanup old packages
    apt-get -qy autoremove && \
# Add user jenkins to the image
    adduser --quiet jenkins && \
# Set password for the jenkins user
    echo "jenkins:jenkins" | chpasswd && \
    mkdir /home/jenkins/.m2

# Copy GIT repostory
RUN mkdir -p /home/jenkins/workspace/Selenium_Docker_Runner && \
	cd /home/jenkins/workspace/Selenium_Docker_Runner && \
	git clone https://github.com/KundurthiSantosh/SeleniumDocker.git

#ADD settings.xml /home/jenkins/.m2/
# Copy authorized keys
COPY .ssh/authorized_keys /home/jenkins/.ssh/authorized_keys

RUN chown -R jenkins:jenkins /home/jenkins/.m2/ && \
    chown -R jenkins:jenkins /home/jenkins/.ssh/ && \
	chown -R jenkins:jenkins /home/jenkins/workspace/Selenium_Docker_Runner/SeleniumDocker/*

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
