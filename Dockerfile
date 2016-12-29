#FROM mhart/alpine-node:base-6
FROM mhart/alpine-node:6

ARG HAPROXY_VERSION
ENV HAPROXY_VERSION ${HAPROXY_VERSION}

RUN apk update \
	&& apk upgrade \
	&& apk add haproxy \
        && apk add tzdata \
        && cp /usr/share/zoneinfo/Asia/Singapore /etc/localtime \
        && apk del tzdata \
	&& rm -rf /etc/haproxy/haproxy.cfg \
	&& rm -rf /var/cache/apk/*

COPY haproxy.cfg /etc/haproxy/haproxy.cfg
COPY haproxy-base.cfg /etc/haproxy/haproxy-base.cfg

RUN echo "Asia/Singapore" > /etc/timezone
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

#Install app dependencies
COPY package.json /usr/src/app/
RUN npm install

# Bundle app source
COPY . /usr/src/app

EXPOSE 8080
CMD ["ash","./svcrouter.sh"]

