# Use latest jboss/base-jdk:8 image as the base
FROM jboss/base-jdk:8

# Set the WILDFLY_VERSION env variable
ENV WILDFLY_VERSION 10.0.0.Final
ENV WILDFLY_SHA1 c0dd7552c5207b0d116a9c25eb94d10b4f375549
ENV JBOSS_HOME /opt/jboss/wildfly

# Add the WildFly distribution to /opt, and make wildfly the owner of the extracted tar content
# Make sure the distribution is available from a well-known place
RUN cd $HOME \
&& curl -O https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz \
&& sha1sum wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 \
&& tar xf wildfly-$WILDFLY_VERSION.tar.gz \
&& mv $HOME/wildfly-$WILDFLY_VERSION $JBOSS_HOME \
&& rm wildfly-$WILDFLY_VERSION.tar.gz

# Ensure signals are forwarded to the JVM process correctly for graceful shutdown
ENV LAUNCH_JBOSS_IN_BACKGROUND true

# Expose the ports we're interested in
EXPOSE 1433
EXPOSE 3306
EXPOSE 8080
EXPOSE 9990

# Add Deployment
ADD ticket-monster.war /opt/jboss/wildfly/standalone/deployments/
#ADD "Hibernate jar" /opt/jboss/wildfly/modules/system/layers/base/ord/hibernate/main
#ADD "Hibernate modules" /opt/jboss/wildfly/modules/system/layers/base/ord/hibernate/main
#ADD "JDTCore.zip Jar" /opt/jboss/wildfly/modules/system/layers/base/org/eclipse/jdtcore/main
#ADD "JDTCore.zip module" /opt/jboss/wildfly/modules/system/layers/base/org/eclipse/jdtcore/main
CMD mkdir /opt/jboss/wildfly/moduels/system/layers/base/com/sun/jersey/main
#ADD "Jersy Jar" /opt/jboss/wildfly/moduels/system/layers/base/com/sun/jersey/main
#ADD "Jersy Modules" /opt/jboss/wildfly/moduels/system/layers/base/com/sun/jersey/main
#ADD "Quartz Jar" /opt/jboss/wildfly/moduels/system/layers/base/org/quartz/main
#ADD "Quartz Moduel.xml" /opt/jboss/wildfly/moduels/system/layers/base/org/quartz/main
#ADD "DB Module.xml" /opt/jboss/wildfly/moduels/system/layers/base/com
#ADD "DB jar" /opt/jboss/wildfly/moduels/system/layers/base/com



# Add Admin User
RUN /opt/jboss/wildfly/bin/add-user.sh admin Ou812wtf --silent
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
#RUN /opt/jboss/wildfly/bin/jboss-cli.sh --connct --controller=127.0.0.1:9999
#CMD ["/opt/jboss/wildfly/bin/jboss-cli.sh", "--connect", "--controller=127.0.0.1:9999", "/subsystem=datasource/jdbc-driver=sqlserver:add(driver-name=sqlaserver,driver-module-name=com.microsoft.jdbc,driver-xa-datasource-class-name=com.microsoft.system.jdbc,driver-xa-datasource-class-name=com.microsoft.system.jdbc.SQLServerXADataSource"]
# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
# CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]