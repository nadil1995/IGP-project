FROM tomcat:9.0-jdk11-openjdk

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file (Jenkins should provide it as ROOT.war)
COPY ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Expose port
EXPOSE 8080
