FROM nmaas87/webratio-ant
MAINTAINER Aleksey Potapkin <apotapkin@demax.ru>

RUN apt-get update &&\
   apt-get install -y curl

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


