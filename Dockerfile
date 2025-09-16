# Use Tomcat with JDK 17 (matches modern Java builds)
FROM tomcat:9.0-jdk17-openjdk

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file as ROOT.war
COPY ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat port
EXPOSE 8080

# Optional: enable verbose logs for debugging
ENV CATALINA_OPTS="-Djava.util.logging.config.file=/usr/local/tomcat/conf/logging.properties"

# Start Tomcat in foreground
CMD ["catalina.sh", "run"]
