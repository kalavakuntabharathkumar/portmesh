FROM eclipse-temurin:21-jdk
WORKDIR /app
COPY pom.xml .
RUN apt-get update && apt-get install -y maven && mvn -q dependency:go-offline && rm -rf /var/lib/apt/lists/*
COPY src src
CMD ["mvn","-q","spring-boot:run"]
