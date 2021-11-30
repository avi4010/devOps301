# Run Time Tomcat Env Image.
FROM tomcat:8.0

MAINTAINER Avinash Seelam <avinash120196@gmail.com>

COPY target/petclinic.war   /usr/local/tomcat/webapps/
