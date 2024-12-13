FROM amazoncorretto:21-alpine3.18-jdk as build
RUN apk update \
    && apk upgrade --no-cache \
    && apk search maven \
    && apk add maven
RUN mkdir app
COPY . /app
WORKDIR app
RUN mvn package -e  -Dmaven.test.skip=true
ARG JAR_FILE=target/*.jar
RUN cp ${JAR_FILE} app.jar
FROM amazoncorretto:21-alpine3.18 as final
WORKDIR /app
COPY --from=build /app/app.jar .
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]