FROM ubuntu:latest
ARG GTEST_DIR=/usr/local/src/googletest/googletest

# Fix enter timezone issue
ENV TZ=Europe/Helsinki
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install git-core sudo build-essential make valgrind libcppunit-dev libreadline-dev libreadline6-dev libbsd-dev -y
RUN apt install  openssh-server sudo -y

# Create a user “sshuser” and group “sshgroup”
RUN groupadd sshgroup && useradd -ms /bin/bash -g sshgroup sshuser
# Create sshuser directory in home
RUN mkdir -p /home/sshuser/.ssh

# Copy the ssh public key in the authorized_keys file. The idkey.pub below is a public key file you get from ssh-keygen. They are under ~/.ssh directory by default.
COPY id_rsa.pub /home/sshuser/.ssh/authorized_keys
# change ownership of the key file.
RUN chown sshuser:sshgroup /home/sshuser/.ssh/authorized_keys && chmod 600 /home/sshuser/.ssh/authorized_keys
# Start SSH service
RUN service ssh start
EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]

WORKDIR /valgrind