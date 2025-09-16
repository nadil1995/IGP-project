FROM tomcat:9.0-jdk11-openjdk

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file as ROOT.war
COPY XYZtechnologies-1.0.war /usr/local/tomcat/webapps/ROOT.war

# Expose port
EXPOSE 8080

# Add JVM options to bypass cgroupv2 issue
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -Djdk.disableLastUsageTracking=true -XX:-UseContainerCpuShares -XX:-UseContainerCpuQuota -XX:-UseContainerCpuAccounting"

# Start Tomcat
CMD ["catalina.sh", "run"]
