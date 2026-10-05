FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app
COPY pom.xml .
COPY src ./src

RUN mvn --batch-mode clean package -DskipTests

FROM tomcat:11-jdk21-temurin

RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY --from=build /app/target/SkillForge.war /usr/local/tomcat/webapps/ROOT.war

ENV PORT=8080
EXPOSE 8080

CMD ["sh", "-c", "sed -i \"s/port=\\\"8080\\\"/port=\\\"${PORT}\\\"/\" \"$CATALINA_HOME/conf/server.xml\" && catalina.sh run"]
