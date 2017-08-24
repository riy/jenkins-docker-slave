FROM ubuntu:latest
MAINTAINER Bibin Wilson <bibinwilsonn@gmail.com>

# Add the Ubuntun repository and make sure the package repository is up to date.
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E1DD270288B4E6030699E45FA1715D88E1DF1F24
RUN su -c "echo 'deb http://ppa.launchpad.net/git-core/ppa/ubuntu trusty main' > /etc/apt/sources.list.d/git.list"

RUN apt-get update
RUN apt-get -y upgrade

# Install GIT
RUN apt-get install -y git

# Install a basic SSH server
RUN apt-get install -y openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# Install JDK 8 (latest edition)
RUN apt-get install -y openjdk-8-jdk

# Add user jenkins to the image
RUN adduser --quiet jenkins
# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

RUN mkdir /home/jenkins/.m2

ADD settings.xml /home/jenkins/.m2/

RUN chown -R jenkins:jenkins /home/jenkins/.m2/ 

RUN apt-get install -y maven
# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
