FROM anapsix/alpine-java:latest
MAINTAINER me codar nl
WORKDIR	/tmp

ENV ES_URL="https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.3.0.tar.gz"
ENV LS_URL="https://artifacts.elastic.co/downloads/logstash/logstash-5.3.0.tar.gz"
ENV  K_URL="https://artifacts.elastic.co/downloads/kibana/kibana-5.3.0-linux-x86_64.tar.gz"

ENV GEOCITY_URL="http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz"

RUN apk    add --update --no-cache s6 ca-certificates openssl wget unzip git tar nodejs \
	&& mkdir -p /opt/elasticsearch /opt/kibana /opt/logstash/patterns /opt/logstash/databases /var/lib/elasticsearch

# fixups and permissions
RUN	   adduser -D -h /opt/elasticsearch elasticsearch \
	&& adduser -D -h /opt/logstash logstash \
	&& adduser -D -h /opt/kibana kibana \
	&& wget -q $ES_URL -O elasticsearch.tar.gz \
	&& wget -q $LS_URL -O logstash.tar.gz \
	&& wget -q  $K_URL -O kibana.tar.gz \
	&& wget -q $GEOCITY_URL -O geocity.gz \
	&& tar -zxf elasticsearch.tar.gz --strip-components=1 -C /opt/elasticsearch \
	&& tar -zxf logstash.tar.gz --strip-components=1 -C /opt/logstash \
	&& tar -zxf kibana.tar.gz --strip-components=1 -C /opt/kibana \
	&& gunzip -c geocity.gz > /opt/logstash/databases/GeoLiteCity.dat \
	&& git clone https://github.com/logstash-plugins/logstash-patterns-core.git \
	&& cp -a logstash-patterns-core/patterns/* /opt/logstash/patterns/ \
	&& /opt/logstash/bin/logstash-plugin install logstash-input-beats \
	&& ln -s /opt/jdk/bin/java /usr/bin/java \
	&& rm -rf /tmp/*

# add files, this also creates the layout for the filesystem
COPY files/root/ /

# fixups
RUN	   chmod a+x /service/*/run

# ready to run, expose web and mqtt
EXPOSE 5601/tcp 9200/tcp 9300/tcp 5044/tcp

# volumes
VOLUME /var/lib/elasticsearch

# manage with s6
ENTRYPOINT ["/bin/s6-svscan","/service"]
