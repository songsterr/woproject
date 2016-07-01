FROM anapsix/alpine-java:jdk8
MAINTAINER Aleksey Potapkin <apotapkin@demax.ru>

RUN apk add --no-cache curl docker python py-pip git && \
  pip install awscli && \
  apk del py-pip

# Installs Ant
ENV ANT_VERSION 1.9.7
RUN cd && \
    wget -q http://www.us.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz && \
    tar -xzf apache-ant-${ANT_VERSION}-bin.tar.gz && \
    mv apache-ant-${ANT_VERSION} /opt/ant && \
    rm apache-ant-${ANT_VERSION}-bin.tar.gz
ENV ANT_HOME /opt/ant
ENV PATH ${PATH}:/opt/ant/bin

WORKDIR /drone

COPY ./WOJenkins/ /drone/WOJenkins
COPY ./wonder/ /drone/Wonder

ENV WO_VERSION 5.4.3
ENV WONDER_BRANCH master

RUN bash -x /drone/WOJenkins/Install/WebObjects/installWebObjects.sh && \
bash -x /drone/WOJenkins/Build/Wonder/WorkspaceSetupScripts/Git/setupWonderWorkspace.sh

RUN ant frameworks frameworks.install \
	-propertyfile /Root/build.properties \
	-Dant.build.javac.target=1.7 \
	-buildfile /drone/Wonder/build.xml

RUN apk del curl


