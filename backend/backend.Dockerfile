# Springboot Official: https://spring.io/guides/topicals/spring-boot-docker/
FROM eclipse-temurin:17-jdk as image-with-jar
WORKDIR /any-path/flying-monkey
COPY . .
RUN apt-get update \
    && apt-get install -y wget unzip \
    && wget https://services.gradle.org/distributions/gradle-8.5-bin.zip \
    && unzip gradle-8.5-bin.zip -d /opt \
    && ln -s /opt/gradle-8.5 /opt/gradle \
    && rm gradle-8.5-bin.zip

ENV PATH="/opt/gradle/bin:${PATH}"
RUN gradle --version

RUN gradle wrapper --gradle-version 8.5

RUN ./gradlew clean build

FROM eclipse-temurin:17-jdk
WORKDIR /any-path/flying-horse
COPY --from=image-with-jar /any-path/flying-monkey/build/libs/backend-*-SNAPSHOT.jar ./backend.jar
ENTRYPOINT ["java", "-jar", "backend.jar"]

