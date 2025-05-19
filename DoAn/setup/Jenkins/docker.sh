docker build -t myjenkins-blueocean:2.452.3-jdk17 .
docker run -d --name jenkins-blueocean -p 8080:8080  -p 50000:50000 --restart on-failure  myjenkins-blueocean:2.452.3-jdk17
docker logs jenkins-blueocean