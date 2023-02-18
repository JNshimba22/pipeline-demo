FROM java:8
COPY webapp/target/webapp.war app.war
ENTRYPOINT ["java","-jar","/app.war"]
# A Java 8 runtime example
# The official Red Hat registry and the base image
FROM registry.access.redhat.com/rhel7-minimal
USER root
# Install Java runtime
RUN microdnf --enablerepo=rhel-7-server-rpms \
install java-1.8.0-openjdk --nodocs ;\
microdnf clean all
# Set the JAVA_HOME variable to make it clear where Java is located
ENV JAVA_HOME /etc/alternatives/jre
# Dir for my app
RUN mkdir -p /app
# Expose port to listen to
EXPOSE 8080
# Copy the MicroProfile starter app
COPY demo-thorntail.jar /app/
# Copy the script from the source; run-java.sh has specific parameters to run a Thorntail app from the command line in a container. More on the script can be found at https://github.com/sshaaf/rhel7-jre-image/blob/master/run-java.sh
COPY run-java.sh /app/
# Setting up permissions for the script to run
RUN chmod 755 /app/run-java.sh
# Finally, run the script
CMD [ "/app/run-java.sh" ]
