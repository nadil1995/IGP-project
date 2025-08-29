FROM tomcat:9.0
# remove default ROOT app
RUN rm -rf /usr/local/tomcat/webapps/ROOT
# copy your app
COPY target/XYZtechnologies-1.0.war /usr/local/tomcat/webapps/XYZtechnologies-1.0.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
