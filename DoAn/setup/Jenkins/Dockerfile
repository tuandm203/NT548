FROM jenkins/jenkins:2.452.3-jdk17

# Chạy dưới quyền root để cài tool
USER root

# Fix dpkg info nếu cần
RUN rm /var/lib/dpkg/info/format && printf "1\n" > /var/lib/dpkg/info/format

# Cập nhật và cài lsb-release (để xác định Debian codename)
RUN apt-get update && apt-get install -y \
    lsb-release \
    curl \
    gnupg \
    apt-transport-https

# Thêm Docker repository và cài Docker CLI
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
      https://download.docker.com/linux/debian/gpg \
 && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
      https://download.docker.com/linux/debian \
      $(lsb_release -cs) stable" \
      > /etc/apt/sources.list.d/docker.list \
 && apt-get update \
 && apt-get install -y docker-ce-cli

# Cài Git
RUN apt-get update && apt-get install -y git

# Cài kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
 && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Cài Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Quay về user jenkins và cài plugin cần thiết
USER jenkins

# Cài plugin Blue Ocean và Docker Pipeline
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"

# Thiết lập thư mục làm việc
WORKDIR /var/jenkins_home

# Mặc định container chạy Jenkins
