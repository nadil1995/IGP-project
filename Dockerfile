FROM tomcat:9.0-jdk11-openjdk

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file
COPY XYZtechnologiestechnologies-1.0.war /usr/local/tomcat/webapps/

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
