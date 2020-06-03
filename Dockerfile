FROM tomcat:8.5.16-jre8-alpine
# Naveen
COPY addressbook_main/target/addressbook.war /usr/local/tomcat/webapps
CMD ["catalina.sh","run"]
