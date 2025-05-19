docker build -t myjenkins-blueocean:2.452.3-jdk17 .

docker run -d \
  --name jenkins-blueocean \
  -u root \
  -p 8080:8080 \
  -p 50000:50000 \
  --restart on-failure \
  -v /home/ubuntu/jenkins_data:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --privileged \
  myjenkins-blueocean:2.452.3-jdk17
  docker logs jenkins-blueocean