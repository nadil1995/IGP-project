# Use Tomcat with matching JDK version
FROM tomcat:9.0-jdk8-openjdk

# Remove default webapps (optional but recommended)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR as ROOT.war
COPY target/XYZtechnologies-1.0.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat in the foreground
CMD ["catalina.sh", "run"]
